#!/bin/ksh
################################################################################
####  UNIX Script Documentation Block
#                      .                                             .
# Script name:         exhiresw_prelim_rap.sh.ecf
# Script description:  Runs WRF Preprocessing System (WPS) and REAL code for the WRF-ARW or
#                      the full NPS suite for NMMB.
#
# Author:        Eric Rogers       Org: NP22         Date: 2004-07-02
#
# Abstract: The scripts gets all the input files needed for the NMMB and WRF-ARW hiresw run
#           and runs the WPS/REAL codes (WRF-ARW) or NPS codes (NMMB)  which interpolate the 
#           operational RAP initial conditions to the NMMB or WRF-ARW domain
#           and create lateral boundary conditions
#
# Script history log:
# 2003-11-01  Matt Pyle - Original script for parallel
# 2004-07-02  Eric Rogers - Preliminary modifications for production.
# 2004-10-01  Eric Rogers - Modified to run special real executable for Alaska NMM
# 2007-04-09  Matthew Pyle - Modified to run WPS rather than wrfsi
# 2009-09-24  Shawna Cokley - Streamlines way script obtains date information -
#                             pulls from $PDY rather than copying a file to the working directory
# 2013-09-01  Matthew Pyle -  Modified to process a single RAP file as input to the CONUS HIresW domain.

set -x

LENGTH=00

### NEST options are conus, pr for this script
### MODEL is arw

msg="JOB $job FOR WRF NEST=${NEST}${MODEL} HAS BEGUN"
postmsg "$msg"

RUNLOC=${NEST}${MODEL}

yy=`echo $PDY | cut -c1-4`
mm=`echo $PDY | cut -c5-6`
dd=`echo $PDY | cut -c7-8`

ystart=`echo $PDY | cut -c1-4`
mstart=`echo $PDY | cut -c5-6`
dstart=`echo $PDY | cut -c7-8`

start=$ystart$mstart$dstart$cyc

end=`$NDATE $LENGTH $start`

yend=`echo $end | cut -c1-4`
mend=`echo $end | cut -c5-6`
dend=`echo $end | cut -c7-8`
hend=`echo $end | cut -c9-10`

filt_start=`$NDATE -1 $start`

filt_ys=`echo $filt_start | cut -c1-4`
filt_ms=`echo $filt_start | cut -c5-6`
filt_ds=`echo $filt_start | cut -c7-8`
filt_hs=`echo $filt_start | cut -c9-10`

filt_ye=$ystart
filt_me=$mstart
filt_de=$dstart
filt_he=$cyc

whr=00
whrp1=01
count=0
last=$LENGTH
incr=3

#
# Check to see how many storms are being run by the GFDL hurricane model.
# If number is >= 2, do not make any hiresw runs.
# If number is 1, cancel job if this is a WRF-EM run.
#
#if [ "$NEST" != "pr" -a "$NEST" != "hi" -a "$NEST" != "guam" ] ; then

###############
# Turn off hurricane check; No pre-emption as of 2014 implementation
###############
  #$USHhiresw/hiresw_chkhur.sh $MODEL
  #err=$?
  #if [ $err -eq 99 ] ; then
  #  exit
  #fi
  echo "export NEST=$NEST" > $COMOUT/hiresw.t${cyc}z.${RUNLOC}.envir.sh
  echo "export MODEL=$MODEL" >> $COMOUT/hiresw.t${cyc}z.${RUNLOC}.envir.sh
#fi

export CYCLE=$PDY$cyc
echo "export CYCLE=$CYCLE" >> $COMOUT/hiresw.t${cyc}z.${RUNLOC}.envir.sh

# Puerto Rico : Use grid #221 (awip32)
# Hawaii : Use grid #243 (awiphi)
# East & West : Use grid #212 (awip3d)
# Alaska & Guam : Use GFS (1 degree pgrb)

mkdir -p $DATA/run_ungrib

cp $PARMhiresw/hiresw_Vtable.NAM  $DATA/run_ungrib/Vtable 


while [ $whr -le $last ]
do

if [ $NEST = "conus" -o $NEST = "pr"  ]
then

onehold=`$NDATE -1 ${PDY}${cyc}`
DATEold=`echo $onehold | cut -c1-8`
cycold=`echo $onehold | cut -c9-10`

# grab post-digital filter analysis file if available


	if [ -e  ${COMINrap}/rap.t${cyc}z.awip32f${whr}df.grib2 ]
	then

 cp ${COMINrap}/rap.t${cyc}z.awip32f${whr}df.grib2 $DATA/run_ungrib/.
 suf="df.grib2"
 NUMLEVS=41
 
	elif [ -e ${DATA}/../rap.t${cyc}z.awip32f${whr}df.grib2 ]
	then
 cp ${DATA}/../rap.t${cyc}z.awip32f${whr}df.grib2 $DATA/run_ungrib/.
 suf="df.grib2"
 NUMLEVS=41

        elif [ -e ${COMINrap}/rap.t${cycold}z.awip32f${whrp1}.grib2 ]
        then
 echo USING 1h OLD
 cp ${COMINrap}/rap.t${cycold}z.awip32f${whrp1}.grib2 $DATA/run_ungrib/.
 suf=".grib2"
 NUMLEVS=41

        elif [ -e ${COMINrap}/rap.t${cyc}z.awip32f${whr}.grib2 ]
        then
 echo "USING ON TIME RAP (non DF)"
 cp ${COMINrap}/rap.t${cyc}z.awip32f${whr}.grib2 $DATA/run_ungrib/.
 suf=".grib2"
 NUMLEVS=41

        else
           msg="FATAL ERROR: ${COMINrap}/rap.t${cyc}z.awip32f${whr}df.grib2  DOES NOT EXIST"
           err_exit $msg
        fi

if [ $PDY -lt 20160801 ]
then
 cp $PARMhiresw/hiresw_Vtable.RAP_retro $DATA/run_ungrib/Vtable
else
 cp $PARMhiresw/hiresw_Vtable.RAP $DATA/run_ungrib/Vtable
fi
 export err1=$?
 mod=rap
 GRIBSRC=RAP
 type=awip32f	

else

msg="FATAL ERROR: JHIRESW_PREPRAP attempted to run for non CONUS or PR domain."
err_exit $msg

fi


if [ $MODEL = "arw" ]
then

  cat $PARMhiresw/hiresw_${NEST}_${MODEL}.namelist.wps_in | sed s:YSTART:$ystart: | sed s:MSTART:$mstart: \
 | sed s:DSTART:$dstart: | sed s:HSTART:$cyc: | sed s:YEND:$yend: \
 | sed s:MEND:$mend:     | sed s:DEND:$dend: | sed s:HEND:$hend: | sed s:_GRIBSRC_:${GRIBSRC}:g > $DATA/run_ungrib/namelist.wps

fi

whr=`expr $whr + $incr`

if [ $whr -lt 10 ]
then
whr=0$whr
fi

done

cd $DATA/run_ungrib

if [ -e ${mod}.t${cyc}z.${type}00${suf} ]
then
mv ${mod}.t${cyc}z.${type}00${suf} GRIBFILE.AAA
else
mv ${mod}.t${cycold}z.${type}01${suf} GRIBFILE.AAA
fi

pwd

### run_ungrib

cd $DATA/run_ungrib/

if [ $MODEL = "arw" ]
then
cp $EXEChiresw/hiresw_wps_ungrib ungrib.exe

export pgm=ungrib
./ungrib.exe >> $pgmout 2>errfile
export err=$?; err_chk
fi

files=`ls FILE*`

for fl in $files
do
mv ${fl} ../
done


#########################################################
# RUN SINGLE METGRID STEP OF RAP FILES
#########################################################

# Create a script to be poe'd
cd $DATA

# do not want to send RAP metgrid file to /com
#
export send=0
#

$USHhiresw/hiresw_wps_metgrid_gen.sh $NEST $cyc 00 00 1 $MODEL $send


cat $DATA/metgrid.log.0000_* > $COMOUT/hiresw.t${cyc}z.${NEST}${MODEL}.metgrid.log

#########################################################
# RUN REAL PROGRAM TO GENERATE WRFINPUT/WRFBDY FILES
#########################################################

cd $DATA

cycstart=`echo ${PDY}${cyc}`

start=$ystart$mstart$dstart

end=`$NDATE $LENGTH $cycstart`

yend=`echo $end | cut -c1-4`
mend=`echo $end | cut -c5-6`
dend=`echo $end | cut -c7-8`
hend=`echo $end | cut -c9-10`

if [ $NEST = "conus" -o $NEST = "pr" ] ; then

if [ $MODEL = "arw" ]; then
  cp $PARMhiresw/hiresw_${MODEL}_namelist.input_in_${NEST} namelist.input_in
  cp $PARMhiresw/hiresw_${MODEL}_namelist.input_in_${NEST}_model namelist.input_in_model
else
  echo BAD MODEL CHOICE FOR CONUS/PR DOMAIN
  err=99
fi

else

  echo RAP processing only available for CONUS/PR domains
  echo do not use for domain $NEST
  err=99

fi


if [ $err -ne 0 ]; then
   echo EXIT FROM RAP prelim job with err $err
   err_chk
fi


### number of input levels depends on source model data

NUMLEVS=27

if [ $mod = "rap" ]
then
NUMLEVS=40
fi

# fi

if [ $MODEL = "arw" ]
then

cat namelist.input_in | sed s:YSTART:$ystart: | sed s:MSTART:$mstart: \
 | sed s:DSTART:$dstart: | sed s:HSTART:$cyc: | sed s:YEND:$yend: \
 | sed s:MEND:$mend:     | sed s:DEND:$dend: | sed s:HEND:$hend:  \
 | sed s:FILT_YS:${filt_ys}: | sed s:FILT_MS:${filt_ms}: | sed s:FILT_DS:${filt_ds}: \
 | sed s:FILT_HS:${filt_hs}: | sed s:FILT_YE:${filt_ye}: | sed s:FILT_ME:${filt_me}: \
 | sed s:FILT_DE:${filt_de}: | sed s:FILT_HE:${filt_he}: \
 | sed s:NUMLEV:$NUMLEVS: > namelist.input

cat namelist.input_in_model | sed s:YSTART:$ystart: | sed s:MSTART:$mstart: \
 | sed s:DSTART:$dstart: | sed s:HSTART:$cyc: | sed s:YEND:$yend: \
 | sed s:MEND:$mend:     | sed s:DEND:$dend: | sed s:HEND:$hend:  \
 | sed s:FILT_YS:${filt_ys}: | sed s:FILT_MS:${filt_ms}: | sed s:FILT_DS:${filt_ds}: \
 | sed s:FILT_HS:${filt_hs}: | sed s:FILT_YE:${filt_ye}: | sed s:FILT_ME:${filt_me}: \
 | sed s:FILT_DE:${filt_de}: | sed s:FILT_HE:${filt_he}: \
 | sed s:NUMLEV:$NUMLEVS: > namelist.input_model

fi


rm fort.*

cp $PARMhiresw/hiresw_LANDUSE.TBL LANDUSE.TBL
cp $PARMhiresw/hiresw_ETAMPNEW_DATA ETAMPNEW_DATA
cp $PARMhiresw/hiresw_ETAMPNEW_DATA micro_lookup.dat
cp $PARMhiresw/hiresw_VEGPARM.TBL VEGPARM.TBL
cp $PARMhiresw/hiresw_SOILPARM.TBL SOILPARM.TBL
cp $PARMhiresw/hiresw_GENPARM.TBL GENPARM.TBL

cp $FIXhiresw/hiresw_RRTM_DATA RRTM_DATA
cp $FIXhiresw/hiresw_tr49t67 tr49t67
cp $FIXhiresw/hiresw_tr49t85 tr49t85
cp $FIXhiresw/hiresw_tr67t85 tr67t85

if [ $MODEL = "arw" ]
then

export pgm=hiresw_${MODEL}_init
. prep_step

startmsg

export MP_PGMMODEL=spmd
unset MP_CMDFILE

#mpirun.lsf $EXEChiresw/hiresw_${MODEL}_real > $pgmout 2>&1
# aprun -n $NTASK -N $PTILE $EXEChiresw/hiresw_${MODEL}_real > $pgmout 2>&1
mpiexec  -n $NTASK -ppn $PTILE $EXEChiresw/hiresw_wrfarwfcst_init > $pgmout 2>&1

export err=$?
err_chk

# Copy input file needed to make model forecast to COM

cp wrfinput_d01 $COMOUT/hiresw.t${cyc}z.${NEST}${MODEL}.wrfinput_d01_rap

if [ ! -f $COMOUT/hiresw.t${cyc}z.${NEST}${MODEL}.wrfinput_d01_rap ]; then
    msg="FATAL ERROR: WRF initial condition from RAP conditions not produced"
    err_exit $msg
fi

# Cat REAL log files and send to COM
cat $DATA/rsl.error.000? $DATA/rsl.out.000? >  $COMOUT/hiresw.t${cyc}z.${NEST}${MODEL}.realrap.log

fi

msg="JOB $job FOR WRF NEST=${NEST}${MODEL} HAS COMPLETED NORMALLY"
postmsg  "$msg"
