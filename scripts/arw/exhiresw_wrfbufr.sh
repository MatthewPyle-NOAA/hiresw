#!/bin/ksh
######################################################################
####  UNIX Script Documentation Block
#                      .                                             .
# Script name:         exhiresw_wrfbufr.sh
# Script description:  Trigger hiresw sounding post job
#
# Author:        Eric Rogers       Org: NP22         Date: 1999-06-23
#
# Abstract: This script triggers the hiresw sounding post job, which
#           creates a piece of the model sounding profile whose
#           time interval is determined by the input forecast hours.
#
# Script history log:
# 2000-05-16  Eric Rogers
# 2006-01-20  Eric Rogers -- extended to 84-h and modified for WRF-NMM NAM
# 2009-12-18  Matthew Pyle -- shortened to 48-h and generalized for multiple domains
#                             and diferent dynamical cores
#

set -x


mkdir -p $DATA/bufrpost/${fhr}
cd $DATA/bufrpost/${fhr}

RUNLOC=${NEST}${MODEL}

export tmmark=tm00
. $COMIN/hiresw.t${cyc}z.${RUNLOC}.envir.sh

cp $FIXhiresw/hiresw_${RUNLOC}_profdat hiresw_profdat

OUTTYP=binary

if [ $MODEL == "arw" ]
then
model=NCAR
else
model=$MODEL
fi

INCR=01

let NFILE=1

YYYY=`echo $PDY | cut -c1-4`
MM=`echo $PDY | cut -c5-6`
DD=`echo $PDY | cut -c7-8`
CYCLE=$PDY$cyc

startd=$YYYY$MM$DD
startdate=$CYCLE

endtime=`$NDATE 48 $CYCLE`

STARTDATE=${YYYY}-${MM}-${DD}_${cyc}:00:00

YYYY=`echo $endtime | cut -c1-4`
MM=`echo $endtime | cut -c5-6`
DD=`echo $endtime | cut -c7-8`

FINALDATE=${YYYY}-${MM}-${DD}_${cyc}:00:00

wyr=`echo $STARTDATE | cut -c1-4`
wmn=`echo $STARTDATE | cut -c6-7`
wdy=`echo $STARTDATE | cut -c9-10`
whr=`echo $STARTDATE | cut -c12-13`

eyr=`echo $FINALDATE | cut -c1-4`
emn=`echo $FINALDATE | cut -c6-7`
edy=`echo $FINALDATE | cut -c9-10`
ehr=`echo $FINALDATE | cut -c12-13`

edate=$eyr$emn$edy$ehr


# check for existence of sndpostdone files

cd $DATA

if [ -e sndpostdone${fhr}.tm00 ]
then
echo "Appear to have run the BUFRPOST for ARW for this hour"
ls -l sndpostdone${fhr}.tm00
exit 0
fi

timeform=$STARTDATE

export fhr

wdate=`$NDATE +${fhr} $startdate`

echo starting with fhr $fhr
echo starting with wdate $wdate

cd $DATA/bufrpost/${fhr}

########################################################

# while [ $wdate -le $edate ]
# do

datestr=`date`
echo top of loop at $datestr

date=`$NDATE $fhr $CYCLE`

wyr=`echo $date | cut -c1-4`
wmn=`echo $date | cut -c5-6`
wdy=`echo $date | cut -c7-8`
whr=`echo $date | cut -c9-10`

let fhrold="$fhr - 1"
dateold=`$NDATE $fhrold $CYCLE`

oyr=`echo $dateold | cut -c1-4`
omn=`echo $dateold | cut -c5-6`
ody=`echo $dateold | cut -c7-8`
ohr=`echo $dateold | cut -c9-10`

timeform=${wyr}"-"${wmn}"-"${wdy}"_"${whr}":00:00"
timeformold=${oyr}"-"${omn}"-"${ody}"_"${ohr}":00:00"

if [ $model == "NCAR" ]
then

OUTFIL=$INPUT_DATA/wrfout_d01_${timeform}
OLDOUTFIL=$INPUT_DATA/wrfout_d01_${timeformold}

icnt=1

# wait for model restart file
while [ $icnt -lt 1000 ]
do
   if [ -s $INPUT_DATA/fcstdone${fhr}.${tmmark} ]
   then
      break
   else
      icnt=$((icnt + 1))
      sleep 9
   fi
if [ $icnt -ge 200 ]
then
    msg="FATAL ERROR: ABORTING after 30 minutes of waiting for HIRESW ${RUNLOC} FCST F${fhr} to end."
    err_exit $msg
fi
done


else

OUTFIL=$INPUT_DATA/nmmb_hst_01_nio_00${fhr}h_00m_00.00s
OLDOUTFIL=$INPUT_DATA/nmmb_hst_01_nio_00${fhrold}h_00m_00.00s

icnt=1

# wait for model restart file
while [ $icnt -lt 1000 ]
do
   if [ -s $INPUT_DATA/fcstdone.01.00${fhr}h_00m_00.00s ]
   then
      break
   else
      icnt=$((icnt + 1))
      sleep 9
   fi
if [ $icnt -ge 200 ]
then
    msg="FATAL ERROR: ABORTING after 30 minutes of waiting for HIRESW ${RUNLOC} FCST F${fhr} to end."
    err_exit $msg
fi
done

fi

datestr=`date`

cat > itag <<EOF
$OUTFIL
$model
$OUTTYP
$STARTDATE
$NFILE
$INCR
$fhr
$OLDOUTFIL
EOF

export pgm=hiresw_wrfbufr

. prep_step

export FORT19="$DATA/bufrpost/${fhr}/hiresw_profdat"
export FORT79="$DATA/bufrpost/${fhr}/profilm.c1.${tmmark}"
export FORT11="itag"

startmsg

mpiexec -n $NTASK -ppn $PTILE $EXEChiresw/hiresw_wrfbufr  > pgmout.log_${fhr} 2>&1
export err=$?;err_chk

mv $DATA/bufrpost/${fhr}/profilm.c1.${tmmark} $DATA/profilm.c1.${tmmark}.f${fhr}
echo done > $DATA/sndpostdone${fhr}.${tmmark}

# cat $DATA/profilm.c1.${tmmark}  $DATA/profilm.c1.${tmmark}.f${fhr} > $DATA/profilm_int
# mv $DATA/profilm_int $DATA/profilm.c1.${tmmark}

# fhr=`expr $fhr + $INCR`


# if [ $fhr -lt 10 ]
# then
# fhr=0$fhr
# fi

# wdate=`$NDATE ${fhr} $CYCLE`

# done

cd $DATA

########################################################
############### SNDP code
########################################################

if [ $fhr -eq 48 ]
then

fhrloop=00

cat $DATA/profilm.c1.${tmmark}.f${fhrloop} > $DATA/profilm.c1.${tmmark}

while [ $fhrloop -le 47 ]
do
let fhrloop=fhrloop+1

if [ $fhrloop -lt 10 ]
then
  fhrloop=0${fhrloop}
fi

# check on existence
looplim=45
loop=1

while [ $loop -le $looplim ]
do
 echo in while
 if [ -s $DATA/profilm.c1.${tmmark}.f${fhrloop} ]
 then
   break
 else
   loop=$((loop+1))
   sleep 20
 fi
 if [ $loop -ge $looplim ]
   then
   msg="FATAL ERROR: ABORTING after 15 minutes of waiting for profilm.c1.${tmmark}.f${fhrloop}"
   err_exit $msg
 fi
done
#


echo "added ${fhrloop} to the main combined file"
cat $DATA/profilm.c1.${tmmark}.f${fhrloop} >> $DATA/profilm.c1.${tmmark}

done


export pgm=hiresw_sndp_${RUNLOC}

. prep_step

cp $PARMhiresw/hiresw_sndp.parm.mono $DATA/hiresw_sndp.parm.mono
cp $PARMhiresw/hiresw_bufr.tbl $DATA/hiresw_bufr.tbl

export FORT11="$DATA/hiresw_sndp.parm.mono"
export FORT32="$DATA/hiresw_bufr.tbl"
export FORT66="$DATA/profilm.c1.${tmmark}"
export FORT78="$DATA/class1.bufr"

startmsg

echo here RUNLOC  $RUNLOC
echo here MODEL $MODEL

if [ ${RUNLOC} == "conusmem2arw" -o ${RUNLOC} == "akmem2arw" -o ${RUNLOC} == "himem2arw" -o ${RUNLOC} == "prmem2arw" ]
then
echo running mem2 version
nlev=40
else
nlev=50
fi

echo "${MODEL} $nlev" > itag
mpiexec -n 1 -ppn 1 $EXEChiresw/hiresw_sndp  < itag >> $pgmout 2>$pgmout
export err=$?;err_chk

############### Convert BUFR output into format directly readable by GEMPAK namsnd on WCOSS

$CWORDush unblk class1.bufr class1.bufr.unb
$CWORDush block class1.bufr.unb class1.bufr.wcoss

if [ $SENDCOM == "YES" ]
then
cp $DATA/class1.bufr $COMOUT/hiresw.t${cyc}z.${RUNLOC}.class1.bufr
cp $DATA/class1.bufr.wcoss $COMOUT/hiresw.t${cyc}z.${RUNLOC}.class1.bufr.wcoss
cp $DATA/profilm.c1.${tmmark} ${COMOUT}/hiresw.t${cyc}z.${RUNLOC}.profilm.c1
fi

# remove bufr file breakout directory in $COMOUT if it exists

if [ -d ${COMOUT}/bufr.${NEST}${MODEL}${cyc} ]
then
  cd $COMOUT
  rm -r bufr.${NEST}${MODEL}${cyc}
  cd $DATA
fi


rm stnmlist_input

cat <<EOF > stnmlist_input
1
$DATA/class1.bufr
${COMOUT}/bufr.${NEST}${MODEL}${cyc}/${NEST}${MODEL}bufr
EOF

  mkdir -p ${COMOUT}/bufr.${NEST}${MODEL}${cyc}

  export pgm=hiresw_stnmlist
  . prep_step

  export FORT20=$DATA/class1.bufr
  export DIRD=${COMOUT}/bufr.${NEST}${MODEL}${cyc}/${NEST}${MODEL}bufr

  startmsg
#  $EXEChiresw/hiresw_stnmlist < stnmlist_input >> $pgmout 2>errfile
mpiexec -n 1  $EXEChiresw/hiresw_stnmlist < stnmlist_input >> $pgmout 2>errfile
  export err=$?;err_chk

  echo ${COMOUT}/bufr.${NEST}${MODEL}${cyc} > ${COMOUT}/bufr.${NEST}${MODEL}${cyc}/bufrloc

#   cp class1.bufr.tm00 $COMOUT/${RUN}.${cyc}.class1.bufr

cd ${COMOUT}/bufr.${NEST}${MODEL}${cyc}

# Tar and gzip the individual bufr files and send them to /com
  tar -cf - . | /usr/bin/gzip > ../${RUN}.t${cyc}z.${RUNLOC}.bufrsnd.tar.gz

files=`ls`
for fl in $files
do
$CWORDush unblk ${fl} ${fl}.unb
$CWORDush block ${fl}.unb ${fl}.wcoss
rm ${fl}.unb
done


# Make an upper case version of the ${RUNLOC} variable for the alert
#export DBN_NEST=`echo ${RUNLOC} | tr '[a-z]' '[A-Z]'`

if [ $SENDDBN == "YES" ]
then
  $SIPHONROOT/bin/dbn_alert MODEL ${DBN_ALERT_TYPE} $job $COMOUT/${RUN}.t${cyc}z.${RUNLOC}.class1.bufr
  $SIPHONROOT/bin/dbn_alert MODEL ${DBN_ALERT_TYPE}_TAR $job $COMOUT/${RUN}.t${cyc}z.${RUNLOC}.bufrsnd.tar.gz
fi

# make gempak files
$USHhiresw/hiresw_bfr2gpk.sh

fi # f48 if test

echo EXITING $0 with return code $err
exit $err
