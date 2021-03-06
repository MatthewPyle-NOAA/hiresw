#!/bin/ksh
################################################################################
####  UNIX Script Documentation Block
#                      .                                             .
# Script name:         exhiresw_ungrib.sh.ecf
# Script description:  Runs first WRF Preprocessing System (WPS) program "ungrib"
#                      to unpack needed GRIB data for initializing HiresW runs
#
# Author:        Eric Rogers       Org: NP22         Date: 2004-07-02
#
# Abstract: The scripts gets all the input files needed for the NMMB and WRF-ARW hiresw run
#           and runs the ungrib program to prepare data to be interpolated by the subsequent
#           "metgrid" job, which is run on multiple processors
#
# Script history log:
# 2003-11-01  Matt Pyle - Original script for parallel
# 2004-07-02  Eric Rogers - Preliminary modifications for production.
# 2004-10-01  Eric Rogers - Modified to run special real executable for Alaska NMM
# 2007-04-09  Matthew Pyle - Modified to run WPS rather than wrfsi
# 2009-09-24  Shawna Cokley - Streamlines way script obtains date information -
#                             pulls from $PDY rather than copying a file to the working directory
# 2013-09-30  Matthew Pyle - Broken out from prelim job (non-RAP prelim job now in three distinct pieces)
# 2016-10-19  Matthew Pyle - Changes to use 6 h old GFS when needed

set -x

LENGTH=48

### NEST options are east, west, ak, hi, pr, or conus
### MODEL is arw or nmm or nmmb

msg="JOB $job FOR WRF NEST=${NEST}${MODEL} HAS BEGUN"
postmsg  "$msg"

RUNLOC=${NEST}${MODEL}

yy=`echo $PDY | cut -c1-4`
mm=`echo $PDY | cut -c5-6`
dd=`echo $PDY | cut -c7-8`

ystart=`echo $PDY | cut -c1-4`
mstart=`echo $PDY | cut -c5-6`
dstart=`echo $PDY | cut -c7-8`

start=$ystart$mstart$dstart$cyc

let cycold=cyc-6

echo first cycold is $cycold

if [ $cycold = "-6" ]
then
cycold=18
fi

typeset -Z2 cycold
echo cycold is $cycold

int1=`$NDATE +12 $start`
yyint1=`echo $int1 | cut -c1-4`
mmint1=`echo $int1 | cut -c5-6`
ddint1=`echo $int1 | cut -c7-8`
hhint1=`echo $int1 | cut -c9-10`

int2=`$NDATE +12 $int1`
yyint2=`echo $int2 | cut -c1-4`
mmint2=`echo $int2 | cut -c5-6`
ddint2=`echo $int2 | cut -c7-8`
hhint2=`echo $int2 | cut -c9-10`

int3=`$NDATE +12 $int2`
yyint3=`echo $int3 | cut -c1-4`
mmint3=`echo $int3 | cut -c5-6`
ddint3=`echo $int3 | cut -c7-8`
hhint3=`echo $int3 | cut -c9-10`

int4=`$NDATE +12 $int3`
yyint4=`echo $int4 | cut -c1-4`
mmint4=`echo $int4 | cut -c5-6`
ddint4=`echo $int4 | cut -c7-8`
hhint4=`echo $int4 | cut -c9-10`

end=`$NDATE $LENGTH $start`

yend=`echo $end | cut -c1-4`
mend=`echo $end | cut -c5-6`
dend=`echo $end | cut -c7-8`

whr=06
count=0
last=${LENGTH}
let last=last+6
echo last is $last
incr=3

#
# Check to see how many storms are being run by the GFDL hurricane model.
# If number is >= 2, do not make any hiresw runs.
# If number is 1, cancel job if this is a WRF-EM run.
#
#if [ "$NEST" != "pr" -a "$NEST" != "hi" -a "$NEST" != "guam" ] ; then
#  $USHhiresw/hiresw_chkhur.sh $MODEL
#  err=$?
#  if [ $err -eq 99 ] ; then
#    exit
#  fi
  echo "export NEST=$NEST" > $COMOUT/hiresw.t${cyc}z.${RUNLOC}.envir.sh
  echo "export MODEL=$MODEL" >> $COMOUT/hiresw.t${cyc}z.${RUNLOC}.envir.sh
#fi

export CYCLE=$PDY$cyc
echo "export CYCLE=$CYCLE" >> $COMOUT/hiresw.t${cyc}z.${RUNLOC}.envir.sh

# All domains : Use GFS (0.5 degree pgrb2)
# CONUS : Also Use RAP (grid 221)

export DATA

mkdir -p $DATA/run_ungrib
mkdir -p $DATA/run_ungrib_1
mkdir -p $DATA/run_ungrib_2
mkdir -p $DATA/run_ungrib_3
mkdir -p $DATA/run_ungrib_4

if [ $NEST != "conusmem2" -a $NEST != "akmem2" -a $NEST != "himem2" -a $NEST != "prmem2" ]
then

mod=gfs
type=pgrb2.0p25.f0
suf=""

else

mod=nam
type=awp151
suf=".tm00.grib2"
sufold=".tm00.grib2"

fi

while [ $whr -le $last ]
do

if [ $NEST != "conusmem2" -a $NEST != "akmem2" -a $NEST != "himem2" -a $NEST != "prmem2" ]
then

icnt=0

while [ ! -e ${COMINgfs}/${cycold}/atmos/${mod}.t${cycold}z.${type}${whr} ]
do
  sleep 10
  if [ $icnt -gt 90 ]; then 
    msg="FATAL ERROR: ${COMINgfs}/${cycold}/atmos/${mod}.t${cycold}z.${type}${whr} STILL NOT AVAILABLE after 15 minutes waiting."
    export err=911; err_chk
   else 
     icnt=$((icnt + 1))
   fi 
done

cp ${COMINgfs}/${cycold}/atmos/${mod}.t${cycold}z.${type}${whr} $DATA/.
  export err1=$?

if [ $err1 -eq 0 ]
then

cd $DATA

$WGRIB2 ${mod}.t${cycold}z.${type}${whr}  -not ':0.01 mb' \
             -not ':0.02 mb' \
             -not ':0.04 mb' \
             -not ':0.07 mb'  \
             -not ':0.1 mb'  \
             -not ':0.2 mb' \
             -not ':0.7 mb'  -grib tmp.grib2

mv tmp.grib2 ${mod}.t${cycold}z.${type}${whr}
fi

  cp $PARMhiresw/hiresw_Vtable.GFS  $DATA/run_ungrib_1/Vtable 
  cp $PARMhiresw/hiresw_Vtable.GFS  $DATA/run_ungrib_2/Vtable 
  cp $PARMhiresw/hiresw_Vtable.GFS  $DATA/run_ungrib_3/Vtable 
  cp $PARMhiresw/hiresw_Vtable.GFS  $DATA/run_ungrib_4/Vtable 

export GRIBSRC=GFS

else

echo mem2 branch

icnt=0
while [ ! -e ${COMINnam}/${mod}.t${cyc}z.${type}00${suf} ]
do
  sleep 10
  if [ $icnt -gt 90 ]; then 
    msg="FATAL ERROR: ${COMINnam}/${mod}.t${cyc}z.${type}00${suf} STILL NOT AVAILABLE after 15 minutes waiting."
    export err=911; err_chk
   else 
     icnt=$((icnt + 1))
   fi 
done

if [ $whr = "06" ]    # first time
then
cp ${COMINnam}/${mod}.t${cyc}z.${type}00${suf}  $DATA/.   # get f00 from tm00
else
cp ${COMINnamold}/${mod}.t${cycold}z.${type}${whr}${sufold} $DATA/.
fi
  export err1=$?

  cp $PARMhiresw/hiresw_Vtable.NAM  $DATA/run_ungrib_1/Vtable 
  cp $PARMhiresw/hiresw_Vtable.NAM  $DATA/run_ungrib_2/Vtable 
  cp $PARMhiresw/hiresw_Vtable.NAM  $DATA/run_ungrib_3/Vtable 
  cp $PARMhiresw/hiresw_Vtable.NAM  $DATA/run_ungrib_4/Vtable 

export GRIBSRC=NAM


fi


if [ $MODEL != "nmmb" ]
then

  cat $PARMhiresw/hiresw_${NEST}_${MODEL}.namelist.wps_in | sed s:YSTART:$ystart: | sed s:MSTART:$mstart: \
 | sed s:DSTART:$dstart: | sed s:HSTART:$cyc: | sed s:YEND:$yyint1: \
 | sed s:MEND:$mmint1:     | sed s:DEND:$ddint1: | sed s:HEND:$hhint1: > $DATA/namelist.wps.1

  cat $PARMhiresw/hiresw_${NEST}_${MODEL}.namelist.wps_in | sed s:YSTART:$yyint1: | sed s:MSTART:$mmint1: \
 | sed s:DSTART:$ddint1: | sed s:HSTART:$hhint1: | sed s:YEND:$yyint2: \
 | sed s:MEND:$mmint2:     | sed s:DEND:$ddint2: | sed s:HEND:$hhint2: > $DATA/namelist.wps.2

  cat $PARMhiresw/hiresw_${NEST}_${MODEL}.namelist.wps_in | sed s:YSTART:$yyint2: | sed s:MSTART:$mmint2: \
 | sed s:DSTART:$ddint2: | sed s:HSTART:$hhint2: | sed s:YEND:$yyint3: \
 | sed s:MEND:$mmint3:     | sed s:DEND:$ddint3: | sed s:HEND:$hhint3: > $DATA/namelist.wps.3

  cat $PARMhiresw/hiresw_${NEST}_${MODEL}.namelist.wps_in | sed s:YSTART:$yyint3: | sed s:MSTART:$mmint3: \
 | sed s:DSTART:$ddint3: | sed s:HSTART:$hhint3: | sed s:YEND:$yyint4: \
 | sed s:MEND:$mmint4:     | sed s:DEND:$ddint4: | sed s:HEND:$hhint4: > $DATA/namelist.wps.4

else

  cat $PARMhiresw/hiresw_${NEST}_${MODEL}.namelist.nps_in | sed s:YSTART:$ystart: | sed s:MSTART:$mstart: \
 | sed s:DSTART:$dstart: | sed s:HSTART:$cyc: | sed s:YEND:$yyint1: \
 | sed s:MEND:$mmint1:     | sed s:DEND:$ddint1: | sed s:HEND:$hhint1: | sed s:_GRIBSRC_:${GRIBSRC}:g > $DATA/namelist.nps.1

  cat $PARMhiresw/hiresw_${NEST}_${MODEL}.namelist.nps_in | sed s:YSTART:$yyint1: | sed s:MSTART:$mmint1: \
 | sed s:DSTART:$ddint1: | sed s:HSTART:$hhint1: | sed s:YEND:$yyint2: \
 | sed s:MEND:$mmint2:     | sed s:DEND:$ddint2: | sed s:HEND:$hhint2: | sed s:_GRIBSRC_:${GRIBSRC}:g > $DATA/namelist.nps.2

  cat $PARMhiresw/hiresw_${NEST}_${MODEL}.namelist.nps_in | sed s:YSTART:$yyint2: | sed s:MSTART:$mmint2: \
 | sed s:DSTART:$ddint2: | sed s:HSTART:$hhint2: | sed s:YEND:$yyint3: \
 | sed s:MEND:$mmint3:     | sed s:DEND:$ddint3: | sed s:HEND:$hhint3: | sed s:_GRIBSRC_:${GRIBSRC}:g > $DATA/namelist.nps.3

  cat $PARMhiresw/hiresw_${NEST}_${MODEL}.namelist.nps_in | sed s:YSTART:$yyint3: | sed s:MSTART:$mmint3: \
 | sed s:DSTART:$ddint3: | sed s:HSTART:$hhint3: | sed s:YEND:$yyint4: \
 | sed s:MEND:$mmint4:     | sed s:DEND:$ddint4: | sed s:HEND:$hhint4: | sed s:_GRIBSRC_:${GRIBSRC}:g > $DATA/namelist.nps.4

fi

if [ $err1 -ne 0 ] 
then
  msg="FATAL ERROR: $whr input GRIB file from $GRIBSRC not found."
  err_exit $msg
fi

whr=`expr $whr + $incr`

if [ $whr -lt 10 ]
then
whr=0$whr
fi

done

### Get the needed GRIB files into each of the four run_ungrib subdirectories

if [ $NEST != "conusmem2" -a  $NEST != "akmem2" -a $NEST != "himem2" -a  $NEST != "prmem2" ]
then

mv ${mod}.t${cycold}z.${type}06${suf} ./run_ungrib_1/GRIBFILE.AAA
mv ${mod}.t${cycold}z.${type}09${suf} ./run_ungrib_1/GRIBFILE.AAB
mv ${mod}.t${cycold}z.${type}12${suf} ./run_ungrib_1/GRIBFILE.AAC
mv ${mod}.t${cycold}z.${type}15${suf} ./run_ungrib_1/GRIBFILE.AAD
cp ${mod}.t${cycold}z.${type}18${suf} ./run_ungrib_1/GRIBFILE.AAE

mv ${mod}.t${cycold}z.${type}18${suf} ./run_ungrib_2/GRIBFILE.AAA
mv ${mod}.t${cycold}z.${type}21${suf} ./run_ungrib_2/GRIBFILE.AAB
mv ${mod}.t${cycold}z.${type}24${suf} ./run_ungrib_2/GRIBFILE.AAC
mv ${mod}.t${cycold}z.${type}27${suf} ./run_ungrib_2/GRIBFILE.AAD
cp ${mod}.t${cycold}z.${type}30${suf} ./run_ungrib_2/GRIBFILE.AAE

mv ${mod}.t${cycold}z.${type}30${suf} ./run_ungrib_3/GRIBFILE.AAA
mv ${mod}.t${cycold}z.${type}33${suf} ./run_ungrib_3/GRIBFILE.AAB
mv ${mod}.t${cycold}z.${type}36${suf} ./run_ungrib_3/GRIBFILE.AAC
mv ${mod}.t${cycold}z.${type}39${suf} ./run_ungrib_3/GRIBFILE.AAD
cp ${mod}.t${cycold}z.${type}42${suf} ./run_ungrib_3/GRIBFILE.AAE

mv ${mod}.t${cycold}z.${type}42${suf} ./run_ungrib_4/GRIBFILE.AAA
mv ${mod}.t${cycold}z.${type}45${suf} ./run_ungrib_4/GRIBFILE.AAB
mv ${mod}.t${cycold}z.${type}48${suf} ./run_ungrib_4/GRIBFILE.AAC
mv ${mod}.t${cycold}z.${type}51${suf} ./run_ungrib_4/GRIBFILE.AAD
mv ${mod}.t${cycold}z.${type}54${suf} ./run_ungrib_4/GRIBFILE.AAE

else

echo other branch using NAM...only partially cyc old

mv ${mod}.t${cyc}z.${type}00${suf} ./run_ungrib_1/GRIBFILE.AAA
mv ${mod}.t${cycold}z.${type}09${sufold} ./run_ungrib_1/GRIBFILE.AAB
mv ${mod}.t${cycold}z.${type}12${sufold} ./run_ungrib_1/GRIBFILE.AAC
mv ${mod}.t${cycold}z.${type}15${sufold} ./run_ungrib_1/GRIBFILE.AAD
cp ${mod}.t${cycold}z.${type}18${sufold} ./run_ungrib_1/GRIBFILE.AAE

mv ${mod}.t${cycold}z.${type}18${sufold} ./run_ungrib_2/GRIBFILE.AAA
mv ${mod}.t${cycold}z.${type}21${sufold} ./run_ungrib_2/GRIBFILE.AAB
mv ${mod}.t${cycold}z.${type}24${sufold} ./run_ungrib_2/GRIBFILE.AAC
mv ${mod}.t${cycold}z.${type}27${sufold} ./run_ungrib_2/GRIBFILE.AAD
cp ${mod}.t${cycold}z.${type}30${sufold} ./run_ungrib_2/GRIBFILE.AAE

mv ${mod}.t${cycold}z.${type}30${sufold} ./run_ungrib_3/GRIBFILE.AAA
mv ${mod}.t${cycold}z.${type}33${sufold} ./run_ungrib_3/GRIBFILE.AAB
mv ${mod}.t${cycold}z.${type}36${sufold} ./run_ungrib_3/GRIBFILE.AAC
mv ${mod}.t${cycold}z.${type}39${sufold} ./run_ungrib_3/GRIBFILE.AAD
cp ${mod}.t${cycold}z.${type}42${sufold} ./run_ungrib_3/GRIBFILE.AAE

mv ${mod}.t${cycold}z.${type}42${sufold} ./run_ungrib_4/GRIBFILE.AAA
mv ${mod}.t${cycold}z.${type}45${sufold} ./run_ungrib_4/GRIBFILE.AAB
mv ${mod}.t${cycold}z.${type}48${sufold} ./run_ungrib_4/GRIBFILE.AAC
mv ${mod}.t${cycold}z.${type}51${sufold} ./run_ungrib_4/GRIBFILE.AAD
mv ${mod}.t${cycold}z.${type}54${sufold} ./run_ungrib_4/GRIBFILE.AAE

fi

pwd

### run_ungrib

cd $DATA

rm -rf poescript

echo "#!/bin/bash" > poescript
echo "$USHhiresw/hiresw_wps_ungrib_gen.sh $MODEL 2 &" >> poescript
echo "$USHhiresw/hiresw_wps_ungrib_gen.sh $MODEL 1 &" >> poescript
echo "$USHhiresw/hiresw_wps_ungrib_gen.sh $MODEL 3 &" >> poescript
echo "$USHhiresw/hiresw_wps_ungrib_gen.sh $MODEL 4 &" >> poescript
echo "wait" >> poescript

chmod 775 $DATA/poescript
export MP_PGMMODEL=mpmd
export MP_CMDFILE=poescript
export MP_LABELIO=YES
export MP_INFOLEVEL=3
export MP_STDOUTMODE=ordered

export pgm=hiresw_wps_ungrib_gen.sh
./poescript

# mpirun -n 1 -N 1 -d $NTASK ./poescript
export err=$?; err_chk

cd run_ungrib/

files=`ls FILE*`

for fl in $files
do
mv ${fl} $DATA/hiresw.t${cyc}z.${NEST}${MODEL}.${fl}
done

msg="JOB $job FOR WRF NEST=${NEST}${MODEL} HAS COMPLETED NORMALLY"
postmsg "$msg"
