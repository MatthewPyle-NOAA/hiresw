#!/bin/ksh 
#
# Author:        Geoff Manikin       Org: NP22         Date: 2007-08-06
#
# Script history log:
# 2007-08-06  Geoff Manikin
# 2012-07-24  Jeff McQueen  cleaned up redundant codes
#    Created precip threshold loop for creating sref prob precip files
# 2012-09-26  JTM : Modified for wcoss
#                   Combined on & off cycles options into one script 
# 2012-10-22  JTM : Combined addprecip and makeprecip codes
# 2012-10-26  JTM : Combined various nam region scripts
#                   smartinit: getgrib.f: fixed bug with reading sref prob file
# 2012-10-31  JTM : moved smartinit system to tide
# 2012-12-03  JTM : Unified for nam parent and nested region runs
# 2014-01-23  Matthew Pyle : Overhaul for HiresWindow purposes
#======================================================================
#  Set Defaults fcst hours,cycle,model,region in config_nam_nwpara called in parent job

lnsf() # safe version of "ln -sf", waits until "ls" shows correct link
{
    set +x
    tries=10000
    if [[ $# -ne 2 ]] ; then
	export pgm=lnsf
	export err=1
	err_chk
    fi
    file=$1
    link=$2
    ln -sf $file $link
    ready=0
    iloop=0
    while [ $ready -eq 0 ] ; do
	test=` ls -l $link 2>/dev/null | awk '{print $11}' `
	[[ $test == $file ]] && ready=1
	if [ $ready -eq 0 ] ; then
            printf "lnsf warning: link_name:%s   expected_target:%s   bad_target:%s    " $link $file $test ; date "+%H:%M:%S.%N"
            ((++iloop))
            if [[ $iloop -eq $tries ]] ; then
		echo "FATAL ERROR: symbolic link cannot be established"
		export pgm=lnsf
		export err=2
		err_chk
	    fi
	fi
    done
    set -x
}



set -x 

inest=1  # treat hiresw domains like they are nests

export rg=$RUNTYP

#=====================================================================
# Set special filename extensions for mdl,sref,master,wgt,output files
# mdl input file         : mdlgrd,natgrd
# eg: nam.t12z.conusnest.bsmart.tm00

# smartinit in/out file  : rg / outreg
# eg: MESOAK.NDFD
# eg: nam.t12z.smartconus2p5.f03
#=====================================================================

#INPUT MODEL GRID filename extension
export mdlgrd=$RUNTYP  
export mdl=$RUNTYP

# cd $DATA/smartinit
cd $DATA

cpfs $INPUT_DATA/DATE .

#SMARTINIT OUTPUT grid filename extension
outreg=$rg
case $RUNTYP in
  conusmem2arw) rg=conus; outres="2p5km"; outreg=conusmem2;wgrib2def="lambert:265:25:25 238.446:2145:2540 20.192:1377:2540";;
  conusarw|conusnmmb|conusfv3) rg=conus; outres="2p5km"; outreg=conus;wgrib2def="lambert:265:25:25 238.446:2145:2540 20.192:1377:2540";;
  hiarw|hinmmb|hifv3) rg=hi; outres="2p5km"; outreg=hi;wgrib2def="mercator:20 198.475:321:2500:206.131 18.073:225:2500:23.088";;
  himem2arw) rg=hi; outres="2p5km"; outreg=himem2;wgrib2def="mercator:20 198.475:321:2500:206.131 18.073:225:2500:23.088";;
  prarw|prnmmb|prfv3) rg=pr; outres="2p5km"; outreg=pr; wgrib2def="mercator:20 291.804:177:2500:296.028 16.829:129:2500:19.747";;
  prmem2arw) rg=pr; outres="2p5km"; outreg=prmem2; wgrib2def="mercator:20 291.804:177:2500:296.028 16.829:129:2500:19.747";;
  akarw|aknmmb|akfv3) rg=ak; outres="3km"; outreg=ak; wgrib2def="nps:210:60 181.429:1649:2976 40.53:1105:2976";;
  akmem2arw) rg=ak; outres="3km"; outreg=akmem2; wgrib2def="nps:210:60 181.429:1649:2976 40.53:1105:2976";;
  guamarw|guamnmmb|guamfv3) rg=guam; outres="2p5km"; outreg=guam; wgrib2def="mercator:20 143.687:193:2500:148.280 12.35:193:2500:16.794";;
esac

compress=complex2


cycon=0

# 12 hour max/mins must be computed at 00 and 12 UTC

# FOR NESTS,parent script, exnam, sets forecast range (60 or 54h)
case $cyc in
  00|12) set -A A6HR 12 24 36 48 60 999;;
  * )    set -A A6HR 18 30 42 54 999;;
esac

# srefcyc and set in parent job (JHIRESW_SMARTINITB)

# set the variables again here (typeset sometimes does not work correctly for imported variables)
srefcyc=$srefcyc
# gefscyc=$gefscyc
pcphrl=$pcphrl

typeset -Z2 srefcyc pcphrl


#======================================================================
#  Configure input met grib, land-sea mask and topo file names
#======================================================================

#  Set indices to determine input met file name 
#       eg: MDL.tCYCz.MDLGRD.NATGRD${FHR}.tm00
#       eg: nam.t12z.bgrd3d24.tm00
#       eg: nam.t12z.conusnest.bsmart24.tm00

# prdgfl=meso${rg}.NDFD  # output prdgen grid name (eg: mesocon.NDFD,mesoak...)

if [ $rg = "hi" ]
then
rgprdgen=HI
elif [ $rg = "pr" ]
then
rgprdgen=PR
elif [ $rg = "conus" ]
then
rgprdgen=CONUS
elif [ $rg = "ak" ]
then
rgprdgen=AK
elif [ $rg = "guam" ]
then
rgprdgen=GU
fi

if [ $MODEL = "nmmb" ]
then
prdgfl=wrf.${rgprdgen}04
echo prdgfl is $prdgfl
elif [ $MODEL = "arw" ]
then
prdgfl=wrf.EM${rgprdgen}04
fi

  natgrd="wrfprs"       # native model type grid extension (eg: bgrd3d, bsmart)

#-------------------------------------------------------------------------
#   For all grids, set the following:
#   sgrb : Input SREF grid grib number (eg: 212, 216, 243)
#   grid : output grid to copygb sref precip and nam precip buckets to 
#          one exception for non-nests where nam precip buckets are 
#          interpolated to smartinit output (ogrd)
#   ogrd : output grib number for prdgen and smartinit codes 
#          (eg: 197,196,195,184)
#--------------------------------------------------------------------------
grdext=" 0 64 25000 25000"
grdextmerc=" 0 64 2500 2500"

   maskpre=hiresw_smartmask${rg}
   topopre=hiresw_smarttopo${rg}
   ext=grb
   case $RUNTYP in
     guamnmmb|guamarw|guamfv3)          sgrb=999;ogrd=199
      grid="255 1 193 193 12350 143687 128 16794 148280 20000  $grdextmerc";;
     hiarw)            sgrb=243;ogrd=196
      grid="255 1 321 225 18067 -161626 128 23082 -153969 20000 $grdextmerc";;
     himem2arw)            sgrb=243;ogrd=196
      grid="255 1 321 225 18067 -161626 128 23082 -153969 20000 $grdextmerc";;
     hinmmb|hifv3)            sgrb=243;ogrd=196
      grid="255 1 321 225 18067 -161626 128 23082 -153969 20000 $grdextmerc";;
     prarw)            sgrb=212;ogrd=195
      grid="255 1 177 129 16829  -68196 128 19747  -63972 20000 $grdextmerc";;
     prmem2arw)            sgrb=212;ogrd=195
      grid="255 1 177 129 16829  -68196 128 19747  -63972 20000 $grdextmerc";;
     prnmmb|prfv3)            sgrb=212;ogrd=195
      grid="255 1 177 129 16829  -68196 128 19747  -63972 20000 $grdextmerc";;
     akarw)  sgrb=216;ogrd=91
      grid="255 5 1649 1105 40530 181429 8 210000 2976 2976 0 64 0 25000 25000";;
     akmem2arw)  sgrb=216;ogrd=91
      grid="255 5 1649 1105 40530 181429 8 210000 2976 2976 0 64 0 25000 25000";;
     aknmmb|akfv3)  sgrb=216;ogrd=91
      grid="255 5 1649 1105 40530 181429 8 210000 2976 2976 0 64 0 25000 25000";;
     conusarw)  sgrb=212;ogrd=184 
      grid="255 3 2145 1377 20192 238446 8 265000 2540 2540 $grdext"
      topopre=ruc2_ndfd_elevtiles.ndfd2.5
      maskpre=ruc2_ndfd_vegtiles.ndfd2.5;;
     conusmem2arw)  sgrb=212;ogrd=184 
      grid="255 3 2145 1377 20192 238446 8 265000 2540 2540 $grdext"
      topopre=ruc2_ndfd_elevtiles.ndfd2.5
      maskpre=ruc2_ndfd_vegtiles.ndfd2.5;;
     conusnmmb|conusfv3)  sgrb=212;ogrd=184 
      grid="255 3 2145 1377 20192 238446 8 265000 2540 2540 $grdext"
      topopre=ruc2_ndfd_elevtiles.ndfd2.5
      maskpre=ruc2_ndfd_vegtiles.ndfd2.5;;
#  NESTS--------------------------------------------------------------------
   *)
      echo RUNTYP  ${RUNTYP} configuration not available $mdlgrd $rg
      exit;;
   esac

	echo here2 with rg $rg
	echo here2 with maskpre $maskpre

maskfl=${maskpre}.${ext}
topofl=${topopre}.${ext}

# set the variables again here (typeset sometimes does not work correctly for imported variables)
fhr1=$fhr1
fhr2=$fhr2
fhr3=$fhr3
fhr6=$fhr6
fhr9=$fhr9
fhr=$fhr
ffhr=$ffhr
typeset -Z2 fhr1 fhr2 fhr3 fhr6 fhr9 fhr12 fhr ffhr

echo
echo "============================================================"
echo BEGIN SMARTINIT PROCESSING FOR FFHR $ffhr  CYCLE $cyc
echo RUNTYP:  $RUNTYP $mdlgrd  $rg
echo INTERP GRID: $grid
echo OUTPUT GRID: $ogrd $outreg

echo "============================================================"
echo 

#  Set Defaults pcp hours and frequencies
let pcphr=ffhr+3
let pcphrl=ffhr+3
let pcphr12=pcphr-12
let pcphr6=pcphr-6
let pcphr3=pcphr-3

let ffhr1=ffhr-1
let ffhr2=ffhr-2
hours="${ffhr}"
if [ $ffhr -ge 3 ];then hours="${ffhr2} ${ffhr1} ${ffhr}";fi


#### TOP OF LOOP
#####
for fhr in $hours
do
#####

  mk3p=0;mk6p=0;mk12p=0
  let check=fhr%3
  let check6=fhr%6

  if [ $fhr -eq 0 ]
  then
    check=9
    check6=9
  fi

  let fhr1=fhr-1
  let fhr2=fhr-2
  let fhr3=fhr-3
  let fhr6=fhr-6
  let fhr9=fhr-9
  let fhr12=fhr-12

    if [ $check -eq 0 -a $MODEL = "arw" ]
    then
      mk3p=3
      ppgm=make
    else
      mk3p=0
    fi
    if [ $check6 -eq 0 ];then
      mk6p=6
        if [ MODEL = "nmmb" ]
        then
      ppgm=add
        else
      ppgm=make
        fi
    fi

typeset -Z2 fhr1 fhr2 fhr3 fhr6 fhr9 fhr12 fhr ffhr

#=================================================================
#   DECLARE INPUTS and RUN SMARTINIT 
#=================================================================

# CHANGE : for non-conus look in FIXnam for topo,land files
  cpfs $FIXsar/${topofl} TOPONDFD
  cpfs $FIXsar/${maskfl} LANDNDFD
  lnsf TOPONDFD     fort.46
  lnsf LANDNDFD     fort.48
  if [ $ext = grb ];then
    $GRBINDEX TOPONDFD TOPONDFDi
    $GRBINDEX LANDNDFD LANDNDFDi
    lnsf TOPONDFDi  fort.47
    lnsf LANDNDFDi  fort.49
  fi

cpfs $INPUT_DATA/meso${rg}.NDFDf${fhr} .
err1=$?

$GRB2INDEX meso${rg}.NDFDf${fhr} meso${rg}.NDFDif${fhr}
export err=$?; err_chk

echo err1 on copy $err1

  mksmart=1
  if [ $check -eq 0 -a $fhr -ne 00 ];then 


	if [ $sgrb -ne 999 ] ; then
    cpfs $INPUT_DATA/srefpcp${rg}_${SREF_PDY}${srefcyc}f0${pcphrl} SREFPCP
    cpfs $INPUT_DATA/srefpcp${rg}i_${SREF_PDY}${srefcyc}f0${pcphrl} SREFPCPi
        fi
	echo fhr2 $fhr2
	echo fhr1 $fhr1

	if [ -e MAXMING2.f${fhr2} ]
        then
    cpfs MAXMING2.f${fhr2} MAXMIN2
        else
    echo MAXMING2.f${fhr2} is missing
        fi

	echo copy MAXMING2.f${fhr1} to MAXMIN1
    cpfs MAXMING2.f${fhr1} MAXMIN1

    $GRB2INDEX MAXMIN1 MAXMIN1i
    export err=$?; err_chk
    $GRB2INDEX MAXMIN2 MAXMIN2i
    export err=$?; err_chk
  fi

  freq=6;fmx=21   #fmx =  maxmin unit number for 1st maxmin file

     cpgbgrd=$grid
     if [ $inest -gt 0 ];then cpgbgrd=$ogrd;fi

### always copy

 	if [ $check -eq 0 -a -e $INPUT_DATA/3precip.${fhr}_interp ]
        then
cpfs $INPUT_DATA/3precip.${fhr}_interp .
        fi

	if [ $check6 -eq 0 ]
	then

cpfs $INPUT_DATA/${freq}precip.${fhr}_interp .
err1=$?
cpfs $INPUT_DATA/${freq}snow.${fhr}_interp .
err2=$?

if [ $MODEL = "arw" ]
then
cpfs $INPUT_DATA/3precip.${fhr}_interp .
err3=$?
if [ $err3 -ne 0 ]
then
echo did not find 3precip file that was expected for ARW run
fi
fi

cpfs $INPUT_DATA/meso${rg}.NDFDf${fhr} .
cpfs $INPUT_DATA/meso${rg}.NDFDif${fhr} .

echo copy ${freq}precip.${fhr} $err1
echo copy ${freq}snow.${fhr} $err2


     mv ${freq}precip.${fhr}_interp ${freq}precip
     $GRB2INDEX ${freq}precip ${freq}precipi
     export err=$?; err_chk

     mv ${freq}snow.${fhr}_interp ${freq}snow
     $GRB2INDEX ${freq}snow ${freq}snowi
     export err=$?; err_chk

	fi

	if [ $MODEL = "arw" -a $check -eq 0 ]
	then

        cpfs 3precip.${fhr}_interp 3precip
        $GRB2INDEX 3precip 3precipi
        export err=$?; err_chk
        
	fi



	if [ $MODEL = "arw" -a $check -eq 0 ]
	then
	cat 3precip meso${rg}.NDFDf${fhr} > new_meso${rg}.NDFDf${fhr}
	mv new_meso${rg}.NDFDf${fhr} meso${rg}.NDFDf${fhr}
        $GRB2INDEX meso${rg}.NDFDf${fhr} meso${rg}.NDFDif${fhr}
        export err=$?; err_chk
        fi

ls -l meso${rg}.NDFDf${fhr}

  lnsf "meso${rg}.NDFDf${fhr}"    fort.11
  lnsf "meso${rg}.NDFDif${fhr}"   fort.12

        if [ ${fhr} -ne 00 -a $check -eq 0 -a $sgrb -ne 999 ]; then
        lnsf "SREFPCP"                  fort.13

	if [ -e SREFPCPi ] 
        then
          rm SREFPCPi
        fi

        $GRB2INDEX SREFPCP SREFPCPi
        export err=$?; err_chk
        lnsf "SREFPCPi"                 fort.14
	fi

	if [ $check6 -eq 0 ]
	then



  lnsf "${freq}precip"            fort.15

mv ${freq}precipi ${freq}precipi_was

$GRB2INDEX ${freq}precip ${freq}precipi
export err=$?; err_chk

  lnsf "${freq}precipi"           fort.16
        fi


# At 12-hr times, input 12-hr max/min temps and 3 and 6-hr buckets

  case $fhr in 
    ${A6HR[0]}|${A6HR[1]}|${A6HR[2]}|${A6HR[3]}|${A6HR[4]}|${A6HR[5]}|${A6HR[6]} )
    echo "********************************************************"
    echo RUN SMARTINIT for 12h valid 00 or 12Z fcst hours: $fhr

	fmx=21

#	if [ ! -e $COMOUT/${mdl}.t${cyc}z.smart${outreg}f${fhr3}.grib2 ]
#	then
#	err_exit "missing $COMOUT/${mdl}.t${cyc}z.smart${outreg}f${fhr3}.grib2"
#	fi

    cpfs $COMOUT/${RUN}.t${cyc}z.${MODEL}_${outres}.f${fhr3}.${outreg}.grib2 MAXMIN3
    cpfs $COMOUT/${RUN}.t${cyc}z.${MODEL}_${outres}.f${fhr6}.${outreg}.grib2 MAXMIN4
    cpfs $COMOUT/${RUN}.t${cyc}z.${MODEL}_${outres}.f${fhr9}.${outreg}.grib2 MAXMIN5

    $GRB2INDEX MAXMIN3 MAXMIN3i
    export err=$?; err_chk
    $GRB2INDEX MAXMIN4 MAXMIN4i
    export err=$?; err_chk
    $GRB2INDEX MAXMIN5 MAXMIN5i
    export err=$?; err_chk

#     READ 6/12 hr precip from special files created by makeprecip

     cpgbgrd=$grid
     if [ $inest -gt 0 ];then cpgbgrd=$ogrd;fi

cpfs $INPUT_DATA/12precip.${fhr}_interp .
cpfs $INPUT_DATA/6snow.${fhr}_interp .

     mv 12precip.${fhr}_interp 12precip
     $GRB2INDEX 12precip 12precipi
     export err=$?; err_chk


     mv 6snow.${fhr}_interp 6snow
     $GRB2INDEX 6snow 6snowi
     export err=$?; err_chk

      lnsf "6snow"      fort.17
      lnsf "6snowi"     fort.18
      lnsf "12precip"   fort.19
      lnsf "12precipi"  fort.20
    lnsf "MAXMIN1"   fort.$fmx
    lnsf "MAXMIN2"   fort.$((fmx+1))
    lnsf "MAXMIN3"   fort.$((fmx+2))
    lnsf "MAXMIN4"   fort.$((fmx+3))
    lnsf "MAXMIN5"   fort.$((fmx+4))
    lnsf "MAXMIN1i"  fort.$((fmx+5))
    lnsf "MAXMIN2i"  fort.$((fmx+6))
    lnsf "MAXMIN3i"  fort.$((fmx+7))
    lnsf "MAXMIN4i"  fort.$((fmx+8))
    lnsf "MAXMIN5i"  fort.$((fmx+9));;

    *)   # Not 00/12 UTC valid times

     if [ $check -eq 0 -a $fhr -ne 00 ];then

#      READ PRECIP FROM SPECIAL FILES CREATED BY SMARTPRECIP
#      ON-CYC: All forecast hours divisible by 3 except for (3,15,27....), 
#      read  3-hr buckets max/min temp data for the previous 2 hours
#      OFF-CYC: Set input files to read 6 hr prcp from makeprecip files

       if [ $mk6p -ne 0 ];then
         echo "****************************************************************"

         case $cycon in
          1) echo RUN SMARTINIT for ON-CYC  hrs without 3 hr buckets : $fhr;;
          *) echo RUN SMARTINIT for OFF-CYC hrs without 6 hr buckets : $fhr;;
         esac

if [ ! -e ${freq}snow ]
then
cpfs $INPUT_DATA/${freq}snow.${fhr}_interp ${freq}snow
rm ${freq}snowi
$GRB2INDEX ${freq}snow ${freq}snowi
export err=$?; err_chk
fi

         lnsf "${freq}snow"  fort.17
         lnsf "${freq}snowi" fort.18
         lnsf "MAXMIN2"   fort.19
         lnsf "MAXMIN1"   fort.20
         lnsf "MAXMIN2i"  fort.21
         lnsf "MAXMIN1i"  fort.22

       else           
#        READ PRECIP FROM INPUT NAM GRIB FILE 
#        ON-CYC:  Forecast hours 3,15,27,39....already  have 3-hr buckets,
#        OFF-CYC: 3 hour buckets available for all 3 hour forecast times
#        ALL-CYC: Input only  max/min temp data for the previous 2 hours

         echo "****************************************************"
         echo RUN SMARTINIT for hours with 3 hr buckets: $fhr
         lnsf "MAXMIN2"   fort.15
         lnsf "MAXMIN1"   fort.16
         lnsf "MAXMIN2i"  fort.17
         lnsf "MAXMIN1i"  fort.18
       fi  

     else   # fhr%3 -ne 0
#    For all "in-between" forecast hours (13,14,16....)
#    No special data needed
       echo "*****************************************************"
       echo RUN SMARTINIT for in-between hour: $fhr
       lnsf __dummy__ fort.13
       lnsf __dummy__ fort.14
       lnsf __dummy__ fort.15

       lnsf __dummy__ fort.16
       if [ $RUNTYP = "guamarw" -o $RUNTYP = "guamnmmb" -a $fhr -lt 24 ];then
         mksmart=1
       else
         mksmart=0
       fi
       if [ $fhr -eq 00 ];then mksmart=1;fi
     fi;;
  esac

#========================================================
# Run Smartinit
#========================================================
  case $RUNTYP in
   conus|conusmem2|conusnest) RGIN=CS;;
      conusnest2p5) RGIN=CS2P;;
        ak_rtmages) RGIN=AKRT;;
                 *) RGIN=`echo $rg |tr '[a-z]'  '[A-Z]' `;;
  esac

  export pgm=hiresw_smartinit;. prep_step

	ls -l fort.*

	if [ $fhr -gt 0 ]
        then
	ls -l MAXMIN*
        fi

sleep 2 # safety sleep

echo RUNTYP is $RUNTYP

if [ $RUNTYP = "akfv3" -o $RUNTYP = "prfv3"  -o $RUNTYP = "hifv3"  -o $RUNTYP = "conusfv3" ]
then
NLEV=60
elif [ $RUNTYP = "conusmem2arw" -o $RUNTYP = "akmem2arw" -o $RUNTYP = "himem2arw" -o $RUNTYP = "prmem2arw" ]
then
NLEV=40
else
NLEV=50
fi

echo execute with $NLEV levels

mpiexec -n 1 -ppn 1 $EXECfv3/hireswfv3_smartinit $cyc $fhr $ogrd $RGIN $inest $MODEL $NLEV > smartinit.out${fhr} 2>&1
export err=$?; err_chk



# ncoproc all hours now

# Run NCO processing to convert output to grib2 and awips
   export RUNTYP
   export RGIN=$RGIN  # Region id (eg: CS, HI, PR,AK..)
   export outreg
   export cyc  
   export fhr=$fhr
   export ogrd 
   export mksmart

echo run hiresw_ncoprocg2.sh

   ${USHfv3}/hiresw_ncoprocg2.sh

echo past run hiresw_ncoprocg2.sh


done  #fhr loop

exit
