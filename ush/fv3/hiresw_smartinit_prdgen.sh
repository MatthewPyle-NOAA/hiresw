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
# 2014-11-04  Matthew Pyle : SREF probs taken from GRIB2 files
#======================================================================


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
echo srefcyc_1= $srefcyc
inest=1  # treat hiresw domains like they are nests

export rg=$RUNTYP

compress="c3 -set_bitmap 1"

ffhr=${1}

echo working ffhr $ffhr

cd  $DATA/smartinit_${ffhr}/

#=====================================================================

#INPUT MODEL GRID filename extension
export mdlgrd=$RUNTYP  
export mdl=$RUNTYP

#SMARTINIT OUTPUT grid filename extension
outreg=$rg
case $RUNTYP in
  conusmem2arw) rg=conus; outreg=conusmem2; wgrib2def="lambert:265:25:25 238.446:2145:2540 20.192:1377:2540";;
  conusarw|conusfv3) rg=conus; outreg=conus; wgrib2def="lambert:265:25:25 238.446:2145:2540 20.192:1377:2540";;
  hiarw|hifv3) rg=hi; compress="c3";outreg=hi; wgrib2def="mercator:20 198.475:321:2500:206.131 18.073:225:2500:23.088";;
  himem2arw) rg=hi; compress="c3"; outreg=himem2; wgrib2def="mercator:20 198.475:321:2500:206.131 18.073:225:2500:23.088";;
  prarw|prfv3) rg=pr; compress="c3"; outreg=pr; wgrib2def="mercator:20 291.804:177:2500:296.028 16.829:129:2500:19.747";;
  prmem2arw) rg=pr;  compress="c3"; outreg=prmem2; wgrib2def="mercator:20 291.804:177:2500:296.028 16.829:129:2500:19.747";;
  akmem2arw) rg=ak; outreg=akmem2; wgrib2def="nps:210:60 181.429:1649:2976 40.53:1105:2976";;
  akarw|akfv3) rg=ak; outreg=ak; wgrib2def="nps:210:60 181.429:1649:2976 40.53:1105:2976";;
  guamarw|guamfv3) rg=guam; compress="c3"; outreg=guam; wgrib2def="mercator:20 143.687:193:2500:148.280 12.35:193:2500:16.794";;
esac

cycon=0

# 12 hour max/mins must be computed at 00 and 12 UTC

# FOR NESTS,parent script, exnam, sets forecast range (60 or 54h)
case $cyc in
  00|12) set -A A6HR 12 24 36 48 60 999;;
  * )    set -A A6HR 18 30 42 54 999;;
esac

# srefcyc and set in parent job (JHIRESW_SMARTINIT)

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
elif [ $MODEL = "arw" ]
then
prdgfl=wrf.EM${rgprdgen}04
elif [ $MODEL = "fv3" ]
then
prdgfl=fv3.${rgprdgen}04
fi

  natgrd="natprs"       # native model type grid extension (eg: bgrd3d, bsmart)

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


   echo here with rg $rg

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
     akarw|akmem2arw)  sgrb=216;ogrd=91
      grid="255 5 1649 1105 40530 181429 8 210000 2976 2976 0 64 0 25000 25000";;
     aknmmb|akfv3)  sgrb=216;ogrd=91
      grid="255 5 1649 1105 40530 181429 8 210000 2976 2976 0 64 0 25000 25000";;
     conusarw|conusmem2arw)  sgrb=212;ogrd=184 
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

maskfl=${maskpre}.${ext}
topofl=${topopre}.${ext}

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

#======================================================================
#  CREATE SREF PROB. PRECIP FILES
#======================================================================

# fhr should be gt 0 since precip is not available at initial time
if [ $ffhr -gt 0 -a $sgrb -ne 999 ]; then

# get the sref precip fields that we need
echo srefcyc_3= $srefcyc

# here

loop=1
looplim=90

filecheck=$COMINsref/sref.t${srefcyc}z.pgrb${sgrb}.prob_3hrly.grib2

while [ $loop -le $looplim ]
do
 if [ -s $filecheck ]
 then
   break
 else
   loop=$((loop+1))
   sleep 20
 fi
 if [ $loop -ge $looplim ]
   then
   msg="FATAL ERROR: ABORTING after 30 minutes of waiting for $filecheck"
   err_exit $msg
 fi
done

# end here

  cpfs $COMINsref/sref.t${srefcyc}z.pgrb${sgrb}.prob_3hrly.grib2 SREFPROB

#   if [ ! -s SREFPROB ]; then
#     cpfs $COMINgefs/${gefscyc}/sref.t${gefscyc}z.pgrb${sgrb}.prob_3hrly.grib2 SREFPROB
#  fi

  $GRB2INDEX SREFPROB SREFPROBI
  # check for missing sref data
  export err=$?; err_chk

  let IP=0
  if [ $ffhr -lt 6 ]; then pcphr6=;pcphr12=;fi
  if [ $ffhr -lt 12 ]; then pcphr12=;fi
  grbpre="2 0 0 0 0"
  for PHR in $pcphr3 $pcphr6 $pcphr12;do 

### need an offset here to account for the 3 h offset in the SREF data????

#   prob of pcp > 0.01

	echo "get PCP>0.01 over: " ${PHR} ${pcphr}

    $WGRIB2 SREFPROB | grep APCP |  grep "prob >0.25" | grep ":${PHR}-${pcphr} hour" | $WGRIB2 -i SREFPROB  -grib dump
    export err=$?; err_chk
    let IP=IP+1
    mv dump srefpcp$IP

#   prob of pcp > 0.05
    $WGRIB2 SREFPROB | grep APCP | grep "prob >1.27" | grep ":${PHR}-${pcphr} hour" | $WGRIB2 -i SREFPROB  -grib  dump
    export err=$?; err_chk
    let IP=IP+1
    mv dump srefpcp$IP

#   prob of pcp > 0.10
    $WGRIB2 SREFPROB | grep APCP |  grep "prob >2.54" | grep ":${PHR}-${pcphr} hour"  | $WGRIB2 -i SREFPROB -grib dump
    export err=$?; err_chk
    let IP=IP+1
    mv dump srefpcp$IP

#   prob of pcp > 0.25
    $WGRIB2 SREFPROB | grep APCP |  grep "prob >6.35" | grep ":${PHR}-${pcphr} hour"  | $WGRIB2 -i SREFPROB -grib dump
    export err=$?; err_chk
    let IP=IP+1
    mv dump srefpcp$IP

#   prob of pcp > 0.50
    $WGRIB2 SREFPROB | grep APCP |  grep "prob >12.7" | grep ":${PHR}-${pcphr} hour" | $WGRIB2 -i SREFPROB -grib dump
    export err=$?; err_chk
    let IP=IP+1
    mv dump srefpcp$IP
  done

  cat srefpcp1 srefpcp2 srefpcp3 srefpcp4 srefpcp5 > srefallpcp
  if [ $ffhr -ge 6 ]; then
    cat srefpcp6 srefpcp7 srefpcp8 srefpcp9 srefpcp10 >> srefallpcp
  fi
  if [ $ffhr -ge 12 ]; then
    cat srefpcp11 srefpcp12 srefpcp13 srefpcp14 srefpcp15 >> srefallpcp
  fi

### budget maybe not correct for probabilities here
###  $WGRIB2  srefallpcp -set_grib_type ${compress} -new_grid_interpolation budget -new_grid_winds grid -new_grid ${wgrib2def} srefpcp${rg}_${SREF_PDY}${srefcy}cf0${pcphrl}
  $WGRIB2  srefallpcp -set_grib_type ${compress} -new_grid_winds grid -new_grid ${wgrib2def} srefpcp${rg}_${SREF_PDY}${srefcyc}f0${pcphrl}
  export err=$?; err_chk
  $GRB2INDEX srefpcp${rg}_${SREF_PDY}${srefcyc}f0${pcphrl} srefpcp${rg}i_${SREF_PDY}${srefcyc}f0${pcphrl}
  export err=$?; err_chk

fi #fhr -ge 0

let ffhr1=ffhr-1
let ffhr2=ffhr-2
hours="${ffhr}"
if [ $ffhr -ge 3 ];then hours="${ffhr2} ${ffhr1} ${ffhr}";fi

#===========================================================
#  CREATE Accum precip buckets if necessary 
#===========================================================
for fhr in $hours; do

  rm -f *out${fhr}
  mk3p=0;mk6p=0;mk12p=0

if [ $fhr -ne 0 ] 
then
  let check=fhr%3
  let check6=fhr%6
else
  check=9
  check6=9
fi

   
  let fhr1=fhr-1
  let fhr2=fhr-2
  let fhr3=fhr-3
  let fhr6=fhr-6
  let fhr9=fhr-9
  let fhr12=fhr-12
  typeset -Z2 fhr1 fhr2 fhr3 fhr6 fhr9 fhr12 fhr ffhr


# do in 13 pieces (conus only??)

INF=${COMIN}/${RUN}.t${cyc}z.${rg}fv3.${natgrd}.f${fhr}.grib2
CHKF=${INPUT_DATA}/prdgendone${fhr}

loop=1
looplim=90

while [ $loop -le $looplim ]
do
 echo in while
 #if [ -s $INF ]
 if [ -s $CHKF ]
 then
   break
 else
   loop=$((loop+1))
   sleep 20
 fi
 if [ $loop -ge $looplim ]
   then
   msg="FATAL ERROR: ABORTING after 30 minutes of waiting for $INF"
   err_exit $msg
 fi
done



cp ${PARMfv3}/hiresw_smartinit.parmlist.g2_1 list_1.txt
cp ${PARMfv3}/hiresw_smartinit.parmlist.g2_2 list_2.txt
cp ${PARMfv3}/hiresw_smartinit.parmlist.g2_3 list_3.txt
cp ${PARMfv3}/hiresw_smartinit.parmlist.g2_4 list_4.txt
cp ${PARMfv3}/hiresw_smartinit.parmlist.g2_5 list_5.txt
cp ${PARMfv3}/hiresw_smartinit.parmlist.g2_6 list_6.txt
cp ${PARMfv3}/hiresw_smartinit.parmlist.g2_7 list_7.txt
cp ${PARMfv3}/hiresw_smartinit.parmlist.g2_8 list_8.txt
cp ${PARMfv3}/hiresw_smartinit.parmlist.g2_9 list_9.txt
cp ${PARMfv3}/hiresw_smartinit.parmlist.g2_10 list_10.txt
cp ${PARMfv3}/hiresw_smartinit.parmlist.g2_11 list_11.txt
cp ${PARMfv3}/hiresw_smartinit.parmlist.g2_12 list_12.txt
cp ${PARMfv3}/hiresw_smartinit.parmlist.g2_13 list_13.txt
cp ${PARMfv3}/hiresw_smartinit.parmlist.g2_14 list_14.txt
cp ${PARMfv3}/hiresw_smartinit.parmlist.g2_nn list_nn.txt


if [ -e inputs.grb2_1 ]
then
rm inputs.grb2_1 inputs.grb2_2 inputs.grb2_3 inputs.grb2_4 inputs.grb2_5 inputs.grb2_6 inputs.grb2_7 inputs.grb2_8 

if [ $outreg != "conusmem2" -a $outreg != "himem2" -a  $outreg != "prmem2" -a $outreg != "akmem2" ]
then
rm inputs.grb2_9 inputs.grb2_10 inputs.grb2_11 inputs.grb2_12 inputs.grb2_13 inputs.grb2_14  inputs.grb2_nn 
else
rm inputs.grb2_9 inputs.grb2_12  inputs.grb2_nn 
fi

fi

$WGRIB2 $INF | grep -F -f list_1.txt | $WGRIB2 -i -grib inputs.grb2_1 $INF
export err=$?; err_chk
$WGRIB2 $INF | grep -F -f list_2.txt | $WGRIB2 -i -grib inputs.grb2_2 $INF
export err=$?; err_chk
$WGRIB2 $INF | grep -F -f list_3.txt | $WGRIB2 -i -grib inputs.grb2_3 $INF
export err=$?; err_chk
$WGRIB2 $INF | grep -F -f list_4.txt | $WGRIB2 -i -grib inputs.grb2_4 $INF
export err=$?; err_chk
$WGRIB2 $INF | grep -F -f list_5.txt | $WGRIB2 -i -grib inputs.grb2_5 $INF
export err=$?; err_chk
$WGRIB2 $INF | grep -F -f list_6.txt | $WGRIB2 -i -grib inputs.grb2_6 $INF
export err=$?; err_chk
$WGRIB2 $INF | grep -F -f list_7.txt | $WGRIB2 -i -grib inputs.grb2_7 $INF
export err=$?; err_chk
$WGRIB2 $INF | grep -F -f list_8.txt | $WGRIB2 -i -grib inputs.grb2_8 $INF
export err=$?; err_chk
$WGRIB2 $INF | grep -F -f list_9.txt | $WGRIB2 -i -grib inputs.grb2_9 $INF
export err=$?; err_chk

if [ $outreg != "conusmem2" -a $outreg != "himem2" -a  $outreg != "prmem2" -a $outreg != "akmem2" ]
then
$WGRIB2 $INF | grep -F -f list_10.txt | $WGRIB2 -i -grib inputs.grb2_10 $INF
export err=$?; err_chk
$WGRIB2 $INF | grep -F -f list_11.txt | $WGRIB2 -i -grib inputs.grb2_11 $INF
export err=$?; err_chk
fi

$WGRIB2 $INF | grep -F -f list_12.txt | $WGRIB2 -i -grib inputs.grb2_12 $INF
export err=$?; err_chk
$WGRIB2 $INF | grep -F -f list_13.txt | $WGRIB2 -i -grib inputs.grb2_13 $INF
export err=$?; err_chk
$WGRIB2 $INF | grep -F -f list_14.txt | $WGRIB2 -i -grib inputs.grb2_14 $INF
export err=$?; err_chk
$WGRIB2 $INF | grep -F -f list_nn.txt | $WGRIB2 -i -grib inputs.grb2_nn $INF
export err=$?; err_chk

if [ -e ./wgrib2.poe ]
then
rm ./wgrib2.poe
fi

if [ -e model.ndfd_1 ]
then
rm  model.ndfd_1  model.ndfd_2  model.ndfd_3  model.ndfd_4  model.ndfd_5 model.ndfd_6 model.ndfd_nn
rm  model.ndfd_7 model.ndfd_8 model.ndfd_9 model.ndfd_10 model.ndfd_11 model.ndfd_12
fi

echo "#! /bin/ksh" > ./a.poe
echo "$WGRIB2  inputs.grb2_1  -set_grib_type ${compress} -new_grid_winds grid -new_grid ${wgrib2def} m1; $FSYNC m1; mv m1 model.ndfd_1" >> ./a.poe
echo "#! /bin/ksh" > ./b.poe
echo "$WGRIB2  inputs.grb2_2  -set_grib_type ${compress} -new_grid_winds grid -new_grid ${wgrib2def} m2; $FSYNC m2; mv m2 model.ndfd_2" >> ./b.poe
echo "#! /bin/ksh" > ./c.poe
echo "$WGRIB2  inputs.grb2_3  -set_grib_type ${compress} -new_grid_winds grid -new_grid ${wgrib2def} m3; $FSYNC m3; mv m3 model.ndfd_3" >> ./c.poe
echo "#! /bin/ksh" > ./d.poe
echo "$WGRIB2  inputs.grb2_4  -set_grib_type ${compress} -new_grid_winds grid -new_grid ${wgrib2def} m4; $FSYNC m4; mv m4 model.ndfd_4" >> ./d.poe
echo "#! /bin/ksh" > ./e.poe
echo "$WGRIB2  inputs.grb2_5  -set_grib_type ${compress} -new_grid_winds grid -new_grid ${wgrib2def} m5; $FSYNC m5; mv m5 model.ndfd_5" >> ./e.poe
echo "#! /bin/ksh" > ./f.poe
echo "$WGRIB2  inputs.grb2_6  -set_grib_type ${compress} -new_grid_winds grid -new_grid ${wgrib2def} m6; $FSYNC m6; mv m6 model.ndfd_6" >> ./f.poe
echo "#! /bin/ksh" > ./g.poe
echo "$WGRIB2  inputs.grb2_7  -set_grib_type ${compress} -new_grid_winds grid -new_grid ${wgrib2def} m7; $FSYNC m7; mv m7 model.ndfd_7" >> ./g.poe
echo "#! /bin/ksh" > ./h.poe
echo "$WGRIB2  inputs.grb2_8  -set_grib_type ${compress} -new_grid_winds grid -new_grid ${wgrib2def} m8; $FSYNC m8; mv m8 model.ndfd_8" >> ./h.poe
echo "#! /bin/ksh" > ./i.poe
echo "$WGRIB2  inputs.grb2_9  -set_grib_type ${compress} -new_grid_winds grid -new_grid ${wgrib2def} m9; $FSYNC m9; mv m9 model.ndfd_9" >> ./i.poe
echo "#! /bin/ksh" > ./j.poe
echo "$WGRIB2  inputs.grb2_10  -set_grib_type ${compress} -new_grid_winds grid -new_grid ${wgrib2def} m10; $FSYNC m10; mv m10 model.ndfd_10" >> ./j.poe
echo "#! /bin/ksh" > ./k.poe
echo "$WGRIB2  inputs.grb2_11  -set_grib_type ${compress} -new_grid_winds grid -new_grid ${wgrib2def} m11; $FSYNC m11; mv m11 model.ndfd_11" >> ./k.poe
echo "#! /bin/ksh" > ./l.poe
echo "$WGRIB2  inputs.grb2_12  -set_grib_type ${compress} -new_grid_winds grid -new_grid ${wgrib2def} m12; $FSYNC m12; mv m12 model.ndfd_12" >> ./l.poe
echo "#! /bin/ksh" > ./m.poe
echo "$WGRIB2 inputs.grb2_nn  -set_grib_type ${compress} -new_grid_interpolation neighbor -new_grid_winds grid -new_grid ${wgrib2def} m_nn; $FSYNC m_nn; mv m_nn model.ndfd_nn" >> ./m.poe

echo "#! /bin/ksh" > ./n.poe
echo "$WGRIB2  inputs.grb2_13  -set_grib_type ${compress} -new_grid_winds grid -new_grid ${wgrib2def} m13; $FSYNC m13; mv m13 model.ndfd_13" >> ./n.poe
echo "#! /bin/ksh" > ./o.poe
echo "$WGRIB2  inputs.grb2_14  -set_grib_type ${compress} -new_grid_winds grid -new_grid ${wgrib2def} m14; $FSYNC m14; mv m14 model.ndfd_14" >> ./o.poe

chmod 775 ./a.poe
chmod 775 ./b.poe
chmod 775 ./c.poe
chmod 775 ./d.poe
chmod 775 ./e.poe
chmod 775 ./f.poe
chmod 775 ./g.poe
chmod 775 ./h.poe
chmod 775 ./i.poe
chmod 775 ./j.poe
chmod 775 ./k.poe
chmod 775 ./l.poe
chmod 775 ./m.poe
chmod 775 ./n.poe
chmod 775 ./o.poe

echo "./a.poe" >> ./wgrib2.poe
echo "./b.poe" >> ./wgrib2.poe
echo "./c.poe" >> ./wgrib2.poe
echo "./d.poe" >> ./wgrib2.poe
echo "./e.poe" >> ./wgrib2.poe
echo "./f.poe" >> ./wgrib2.poe
echo "./g.poe" >> ./wgrib2.poe
echo "./h.poe" >> ./wgrib2.poe
echo "./i.poe" >> ./wgrib2.poe
echo "./j.poe" >> ./wgrib2.poe
echo "./k.poe" >> ./wgrib2.poe
echo "./l.poe" >> ./wgrib2.poe
echo "./m.poe" >> ./wgrib2.poe
echo "./n.poe" >> ./wgrib2.poe
echo "./o.poe" >> ./wgrib2.poe

chmod 775 ./wgrib2.poe
# export MP_PGMMODEL=mpmd
# export MP_CMDFILE=wgrib2.poe
#time mpirun.lsf
# time aprun -n 1 -N 1 -d $NTASK ./wgrib2.poe
mpiexec -cpu-bind verbose,depth --configfile ./wgrib2.poe

export err=$?;  err_chk

# sleep 60
sleep 1

# $WGRIB2 inputs.grb2_nn  -set_grib_type ${compress} -new_grid_interpolation neighbor -new_grid_winds grid -new_grid ${wgrib2def} model.ndfd_nn

if [ $outreg != "conusmem2" -a $outreg != "himem2" -a  $outreg != "prmem2" -a $outreg != "akmem2" ]
then

while (! cat model.ndfd_1 model.ndfd_2 model.ndfd_3 model.ndfd_4 model.ndfd_5 model.ndfd_6 \
    model.ndfd_7 model.ndfd_8 model.ndfd_9 model.ndfd_10 model.ndfd_11 model.ndfd_12 model.ndfd_13 model.ndfd_14 model.ndfd_nn > NDFD${fhr}.tm00 ) ; do sleep 1; done

else

while (! cat model.ndfd_1 model.ndfd_2 model.ndfd_3 model.ndfd_4 model.ndfd_5 model.ndfd_6 \
    model.ndfd_7 model.ndfd_8 model.ndfd_9 model.ndfd_12 model.ndfd_nn > NDFD${fhr}.tm00 ) ; do sleep 1; done

fi


###	cp NDFD${fhr}.tm00 $COMIN/$mdl.t${cyc}z.NDFD${fhr}
	cp NDFD${fhr}.tm00 $prdgfl

  if [ -e WRFPRS${fhr}.tm00 ]
  then
  $GRB2INDEX WRFPRS${fhr}.tm00 WRFPRS${fhr}i.tm00
  export err=$?; err_chk
  fi

  if [ $fhr -gt 0 ];then
#-------------------------------------------------------------
#   OFF-CYC & Nests: Create 6/12 hour buckets, 3 hr buckets available
#   ON-CYC :
#     3hr precip available at only 3,15, 27,39... forcast fhours
#     other hours, create 3 hr precip
#     6hr precip: Create only at 00/12 UTC valid times 
#           eg: fhr=12,24,36
#     Create 12 hour precip at 00/12 UTC valid times
#-------------------------------------------------------------
    if [ $check -eq 0 -a $MODEL != "nmmb" ]
    then
      mk3p=3
      ppgm=make
    else
      mk3p=0
    fi
    if [ $check6 -eq 0 ];then 
      mk6p=6
	if [ $MODEL = "nmmb" ] 
        then 
      ppgm=add
	echo mk6p and ppgm are $mk6p $ppgm
        else
      ppgm=make
        echo for 6h doing ppgm $ppgm
        fi
    fi

#   hr3bkt flag determines when to run smartprecip to create 3 hr buckets
    let hr3bkt=$((fhr-3))%12

#-------------------------------------------------------------
#   ON-CYC: The 3-hr fhrs (3,15,27,39....) --> Already have 3-hr buckets
#   For in-between fhrs (22,23,25) --> Create 3-hr buckets
#   since we only gather max/min data at those hours to compute 12 hr max/mins
#-------------------------------------------------------------

	if [ $MODEL = "nmmb" ]
        then
      hr3bkt=0
        fi

  fi  #fhr -ne 0

#-------------------------------------------------------------
# ON-CYCLE:  At 12-hr times:  Need 6 hour buckets as well
# Except for 6 hr times (18,30,42...) : Already have 6 hour buckets  ### not true hiresw
# In addition, For 00/12 UTC valid times: Need to make 12 hour accumulations
#-------------------------------------------------------------
  case $fhr in 
    ${A6HR[0]}|${A6HR[1]}|${A6HR[2]}|${A6HR[3]}|${A6HR[4]}|${A6HR[5]}|${A6HR[6]} )
#     off-cycles and  Nests have 3 hr buckets but need 6,12 hour precip
	echo "make both 6 and 12 hour buckets"
      mk6p=6
      mk12p=12

	if [ $MODEL = "nmmb" ]
        then
      ppgm=add
        else
      ppgm=make
        fi

      mk12p=12;;

  esac 

  for MKPCP in $mk3p $mk6p $mk12p;do
    if [ $MKPCP -ne 0 ];then
    echo ====================================================================
    echo BEGIN Making $MKPCP hr PRECIP Buckets for $fhr Hour $ppgm freq $freq
    echo ====================================================================
      pfhr3=-99;pfhr4=-99

      case $MKPCP in
        $mk3p )
        FHRFRQ=$fhr3;freq=3
        pfhr1=$fhr;pfhr2=$fhr3;;

        $mk6p )
        FHRFRQ=$fhr6;freq=6
        pfhr1=$fhr;pfhr2=$fhr6
        if [ $ppgm = add ];then 
          FHRFRQ=$fhr3
          pfhr1=$fhr3;pfhr2=$fhr
	echo add block here FHRFRQ $FHRFRQ
	echo add block pfhr1 pfhr2 $pfhr1 $pfhr2
        fi;;

        $mk12p )
	if [ $MODEL = "nmmb" ]
        then
        FHRFRQ=$fhr9;freq=12
        else
        FHRFRQ=$fhr12;freq=12
        pfhr1=$fhr;pfhr2=$fhr12
        fi

        if [ $ppgm = add ];then 
	echo add block just mk12p or all
        pfhr1=$fhr9;pfhr2=$fhr6;pfhr3=$fhr3;pfhr4=$fhr
        fi;;

      esac


        INF=${COMIN}/${RUN}.t${cyc}z.${rg}fv3.${natgrd}.f${fhr}.grib2
        $WGRIB2 $INF | grep -F -f $PARMfv3/hiresw_smartinit.g2_rainsnow | $WGRIB2 -i -grib  WRFPRS${fhr}.tm00.g2 $INF
        export err=$?; err_chk

	$FSYNC WRFPRS${fhr}.tm00.g2
       mv WRFPRS${fhr}.tm00.g2 WRFPRS${fhr}.tm00
   

	echo here with FHRFRQ $FHRFRQ
        INF=${COMIN}/${RUN}.t${cyc}z.${rg}fv3.${natgrd}.f${FHRFRQ}.grib2
        $WGRIB2 $INF | grep -F -f $PARMfv3/hiresw_smartinit.g2_rainsnow | $WGRIB2 -i -grib  WRFPRS${FHRFRQ}.tm00.g2 $INF
        export err=$?; err_chk

	$FSYNC WRFPRS${FHRFRQ}.tm00.g2
         mv WRFPRS${FHRFRQ}.tm00.g2 WRFPRS${FHRFRQ}.tm00


      $GRB2INDEX WRFPRS${fhr}.tm00 WRFPRS${fhr}i.tm00.temp
       export err=$?; err_chk

	$FSYNC WRFPRS${fhr}i.tm00.temp
	mv WRFPRS${fhr}i.tm00.temp WRFPRS${fhr}i.tm00

      $GRB2INDEX WRFPRS${FHRFRQ}.tm00 WRFPRS${FHRFRQ}i.tm00.temp
       export err=$?; err_chk
	$FSYNC WRFPRS${FHRFRQ}i.tm00.temp WRFPRS${FHRFRQ}i.tm00
	mv WRFPRS${FHRFRQ}i.tm00.temp WRFPRS${FHRFRQ}i.tm00
	
      export pgm=nam_smartprecip; . prep_step
      lnsf "WRFPRS${FHRFRQ}.tm00"  fort.13  
      lnsf "WRFPRS${FHRFRQ}i.tm00" fort.14
      lnsf "WRFPRS${fhr}.tm00"     fort.15
      lnsf "WRFPRS${fhr}i.tm00"    fort.16
      lnsf "${freq}precip.${fhr}"  fort.50
      lnsf "${freq}snow.${fhr}"    fort.52


	echo defining fort.13 with ${FHRFRQ}

      if [ $MKPCP -eq $mk12p ];then

        INF=${COMIN}/${RUN}.t${cyc}z.${rg}fv3.${natgrd}.f${fhr9}.grib2
        $WGRIB2 $INF | grep -F -f $PARMfv3/hiresw_smartinit.g2_rainsnow | $WGRIB2 -i -grib  WRFPRS${fhr9}.tm00.g2 $INF
        export err=$?; err_chk

	$FSYNC WRFPRS${fhr9}.tm00.g2
      mv WRFPRS${fhr9}.tm00.g2 WRFPRS${fhr9}.tm00

	if [ $MODEL = "nmmb" ]
	then

#          cp $COMIN/${mdl}.t${cyc}z.${natgrd}${fhr3} WRFPRS${fhr3}.tm00


        INF=${COMIN}/${RUN}.t${cyc}z.${rg}fv3.${natgrd}.f${fhr3}.grib2
        $WGRIB2 $INF | grep -F -f $PARMfv3/hiresw_smartinit.g2_rainsnow | $WGRIB2 -i -grib  WRFPRS${fhr3}.tm00.g2 $INF
        export err=$?; err_chk

	$FSYNC WRFPRS${fhr3}.tm00.g2
	mv  WRFPRS${fhr3}.tm00.g2 WRFPRS${fhr3}.tm00

#####

	ls -l  WRFPRS${fhr3}.tm00

        $GRB2INDEX WRFPRS${fhr3}.tm00 WRFPRS${fhr3}i.tm00.temp
        export err=$?; err_chk
	$FSYNC WRFPRS${fhr3}i.tm00.temp
	mv WRFPRS${fhr3}i.tm00.temp WRFPRS${fhr3}i.tm00

        INF=${COMIN}/${RUN}.t${cyc}z.${rg}fv3.${natgrd}.f${fhr6}.grib2
        $WGRIB2 $INF | grep -F -f $PARMfv3/hiresw_smartinit.g2_rainsnow | $WGRIB2 -i -grib  WRFPRS${fhr6}.tm00.g2 $INF
        export err=$?; err_chk

	$FSYNC WRFPRS${fhr6}.tm00.g2
       mv WRFPRS${fhr6}.tm00.g2 WRFPRS${fhr6}.tm00

#####
        $GRB2INDEX WRFPRS${fhr6}.tm00 WRFPRS${fhr6}i.tm00.temp
        export err=$?; err_chk
	$FSYNC WRFPRS${fhr6}i.tm00.temp
	mv WRFPRS${fhr6}i.tm00.temp WRFPRS${fhr6}i.tm00

        lnsf "WRFPRS${fhr6}.tm00"      fort.15    
        lnsf "WRFPRS${fhr6}i.tm00"     fort.16
        lnsf "WRFPRS${fhr3}.tm00"      fort.17
        lnsf "WRFPRS${fhr3}i.tm00"     fort.18
        lnsf "WRFPRS${fhr}.tm00"       fort.19
        lnsf "WRFPRS${fhr}i.tm00"      fort.20

	else  ## arw/fv3

#          cp $COMIN/${mdl}.t${cyc}z.${natgrd}${fhr3} WRFPRS${fhr3}.tm00

        INF=${COMIN}/${RUN}.t${cyc}z.${rg}fv3.${natgrd}.f${fhr3}.grib2
        $WGRIB2 $INF | grep -F -f $PARMfv3/hiresw_smartinit.g2_rainsnow | $WGRIB2 -i -grib  WRFPRS${fhr3}.tm00.g2 $INF
        export err=$?; err_chk

	$FSYNC WRFPRS${fhr3}.tm00.g2
	mv  WRFPRS${fhr3}.tm00.g2 WRFPRS${fhr3}.tm00

#####
        $GRB2INDEX WRFPRS${fhr3}.tm00 WRFPRS${fhr3}i.tm00.temp
        export err=$?; err_chk
	$FSYNC WRFPRS${fhr3}i.tm00.temp
	mv WRFPRS${fhr3}i.tm00.temp WRFPRS${fhr3}i.tm00


#          cp $COMIN/${mdl}.t${cyc}z.${natgrd}${fhr6} WRFPRS${fhr6}.tm00

        INF=${COMIN}/${RUN}.t${cyc}z.${rg}fv3.${natgrd}.f${fhr6}.grib2
        $WGRIB2 $INF | grep -F -f $PARMfv3/hiresw_smartinit.g2_rainsnow | $WGRIB2 -i -grib  WRFPRS${fhr6}.tm00.g2 $INF
        export err=$?; err_chk

	$FSYNC WRFPRS${fhr6}.tm00.g2
	mv WRFPRS${fhr6}.tm00.g2 WRFPRS${fhr6}.tm00

#####
        $GRB2INDEX WRFPRS${fhr6}.tm00 WRFPRS${fhr6}i.tm00.temp
        export err=$?; err_chk
	$FSYNC WRFPRS${fhr6}i.tm00.temp
	mv WRFPRS${fhr6}i.tm00.temp WRFPRS${fhr6}i.tm00


        lnsf "WRFPRS${fhr}.tm00"       fort.15
        lnsf "WRFPRS${fhr}i.tm00"      fort.16

	fi

      fi  # mk12p

#===============================================================
# nam_smartprecip : Create Precip Buckets for smartinit 
#===============================================================
     echo MAKE $freq HR PRECIP BUCKET FILE using fhrs $pfhr1 $pfhr2 $pfhr3 $pfhr4


# IARW=1 means no special treatment for snow in smartprecip code

	if [ $MODEL = "arw" ]
	then
	IARW=1
	else
	IARW=1
	fi

	echo about to execute hireswfv3_smartprecip
	ls -l fort.*
	sleep 2


     $EXECfv3/hireswfv3_smartprecip <<EOF > ${ppgm}precip${freq}${fhr}.out 2>&1 
$pfhr1 $pfhr2 $pfhr3 $pfhr4 $IARW
EOF
export err=$?; err_chk

#    Interp precip to smartinit GRID
     cpgbgrd=$grid

	echo cpgbgrd is $cpgbgrd

     if [ $inest -gt 0 ];then cpgbgrd=$ogrd;fi
     if [ $RUNTYP = aknest3 ];then cpgbgrd=$grid;fi

#was budget

echo WGRIB2 for ${freq}precip

$WGRIB2 ${freq}precip.${fhr} -set_grib_type ${compress} -new_grid_winds grid -new_grid_interpolation neighbor -new_grid ${wgrib2def}  ${freq}precip
export err=$?; err_chk

echo copy to ${freq}precip.${fhr}_interp
cp ${freq}precip ${freq}precip.${fhr}_interp
	err=$?


#### do precip and snow as a two item poe job??

	if [ $err -ne 0 ]
	then
	echo "bad copygb to generate ${freq}precip"
	fi

	echo here with freq $freq and fhr $fhr
     $GRB2INDEX ${freq}precip ${freq}precipi
     export err=$?; err_chk
	ls -l  ${freq}precip ${freq}precipi
$WGRIB2 ${freq}snow.${fhr} -set_grib_type ${compress} -new_grid_winds grid -new_grid_interpolation neighbor -new_grid ${wgrib2def}  ${freq}snow
export err=$?; err_chk
cp ${freq}snow ${freq}snow.${fhr}_interp
	if [ $err -ne 0 ]
	then
	echo "bad copygb to generate ${freq}snow"
	fi
     $GRB2INDEX ${freq}snow ${freq}snowi
     export err=$?; err_chk
    fi #MKPCP>0
  done #MKPCP loop

#=================================================================
#  RUN PRODUCT GENERATOR
#=================================================================

 if [ -e WRFPRS${fhr}i.tm00 ];then rm WRFPRS${fhr}i.tm00;fi

	if [ -e  WRFPRS${fhr}.tm00 ]
        then
  $GRB2INDEX WRFPRS${fhr}.tm00 WRFPRS${fhr}i.tm00.temp
  export err=$?; err_chk
  $FSYNC WRFPRS${fhr}i.tm00.temp
  mv WRFPRS${fhr}i.tm00.temp WRFPRS${fhr}i.tm00
	fi

#  cpfs ${COMROOThps}/date/t${cyc}z DATE
echo "DATE__${PDY}${cyc}xx" > DATE



  if [ -s $prdgfl ];then  
    mv ${prdgfl} meso${rg}.NDFDf${fhr}  
    echo $prdgfl FOUND FOR FORECAST HOUR ${fhr}
  elif [ -s ${prdgfl}${fhr} ];then    # check for hawaii ???
    mv ${prdgfl}${fhr} meso${rg}.NDFDf${fhr}  
    echo $prdgfl${fhr} FOUND FOR FORECAST HOUR ${fhr}
  else
    echo $prdgfl NOT FOUND FOR FORECAST HOUR ${fhr}
    exit
  fi

  if [ $rg = "guam" ];then
    cat  $FIXsar/hiresw_smartsfcr${rg}_${MODEL}.grib2 >> meso${rg}.NDFDf${fhr} 
	export err=$?; err_chk
  fi
  $GRB2INDEX meso${rg}.NDFDf${fhr} meso${rg}.NDFDif${fhr}
  export err=$?; err_chk

echo "DONE" > smartinitprdgendone${fhr}
datestr=`date`

done  #fhr loop

## rm -f fort.*


# how handle this now?

if [ ${fhr} -eq 0 ]
then
# cp PDY NMCDATE ncepdate startmsg postmsg null break err_exit errexit errchk err_chk prep_step tracer ../smartinit/
#XXW cp PDY NMCDATE ncepdate startmsg postmsg null break err_exit errexit errchk err_chk prep_step tracer ../
# cp DATE ../smartinit/
cp DATE ../
fi

cp  meso${rg}.NDFDf* meso${rg}.NDFDif* ../

if [ ${fhr} -gt 0 -a $sgrb -ne 999 ]
then
    cp  srefpcp${rg}_${SREF_PDY}${srefcyc}f0${pcphrl} srefpcp${rg}i_${SREF_PDY}${srefcyc}f0${pcphrl} ../
fi

if [ ${fhr} -gt 0 ]
then
    if [ $check -eq 0 -a $MODEL = "arw" ]
    then
     cp  3precip.${fhr}* 3snow.${fhr}* ../
    err=$?
	if [ $err -ne 0 ]
	then
	echo "BAD COPY OF 3precip.${fhr} 3snow.${fhr}"
        fi
    fi
fi

    if [ $check6 -eq 0 ];then 
cp  6precip.${fhr}* 6snow.${fhr}* ../
    err=$?
	if [ $err -ne 0 ]
	then
	echo "BAD COPY OF 6precip.${fhr} 6snow.${fhr}"
        fi
    fi

    if [ $mk12p -eq 12 ];then 
cp  12precip.${fhr}* 12snow.${fhr}* ../
    err=$?
	if [ $err -ne 0 ]
	then
	echo "BAD COPY OF 12precip.${fhr} 12snow.${fhr}"
        fi
    fi

cp WRFPRS* ../

cp  smartinitprdgendone${fhr} ../

exit
