#!/bin/ksh

##################################################################################
#  UTILITY SCRIPT NAME :  exhiresw_awips.sh.sms 
#         DATE WRITTEN :  April 08, 2008
#
#  Abstract:  This utility script produces the Hiresw for AWIPS
#
#  History: April 8, 2008 - Original script from Boi Vuong at NCO
#           Feb 27, 2014 - Update for HiresW v6 domain changes by Matthew Pyle
#           March 27, 2015 - Update for HiresW v6.1 filename changes by Matthew Pyle
#
##################################################################################

set -x

cd $DATA

msg="Hiresw post-processing for AWIPS has begun on `hostname` at `date`"
postmsg  "$msg"
startmsg

RUNLOC=${NEST}${MODEL}

for fhr in 00 03 06 09 12 15 18 21 24 27 30 33 36 39 42 45 48 ;
do
    export FORTREPORTS="unit_vars=yes"     # Allow overriding default names.

if [ $RUNLOC = "conusarw" -o $RUNLOC = "conusfv3" ]
then
  icnt=1
  maxtries=100
  while [ $icnt -lt $maxtries ]
  do
    if [ -f $COMIN/${NET}.t${cyc}z.${MODEL}_5km.f${fhr}.conussbn.grib2.idx ] ; then
      break
    else
      let "icnt=icnt+1"
      sleep 30
    fi
  done
  if [ $icnt -ge $maxtries ]; then
     msg="FATAL ERROR - ABORTING after 50 minutes of waiting for conus sbn F$fhr to become available."
     err_exit $msg
  fi

    export FORT11=$COMIN/${NET}.t${cyc}z.${MODEL}_5km.f${fhr}.conussbn.grib2
    export FORT31=""
    export FORT51=grib2.t${cyc}z.awpreg_${RUNLOC}f${fhr}
    $TOCGRIB2 < $PARMutil/grib2_${NEST}_hiresw.awpreg_f${fhr}

    if [ $SENDCOM = "YES" ] ; then
       cp  $FORT51  $COMOUTwmo/
    fi

    if [ $SENDDBN_NTC = "YES" ] ; then
       $SIPHONROOT/bin/dbn_alert NTC_LOW ${DBN_ALERT_TYPE} $job $COMOUTwmo/grib2.t${cyc}z.awpreg_${RUNLOC}f${fhr}
    else
       msg="File $output_grb.$job not posted to db_net."
       postmsg "$msg"
    fi

else
  icnt=1
  maxtries=100
  while [ $icnt -lt $maxtries ]
  do
    if [ -f $COMIN/${NET}.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2.idx ]; then
      break
    else
      let "icnt=icnt+1"
      sleep 30
    fi
  done
  if [ $icnt -ge $maxtries ]; then
     msg="FATAL ERROR - ABORTING after 50 minutes of waiting for ${NEST}${MODEL} 5km  F$fhr to become available."
     err_exit $msg
  fi
    export FORT11=$COMIN/${NET}.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2
    export FORT31=""
    export FORT51=grib2.t${cyc}z.awpreg_${RUNLOC}f${fhr}
    $TOCGRIB2 < $PARMutil/grib2_${NEST}_hiresw.awpreg_f${fhr}

    if [ $SENDCOM = "YES" ] ; then
       cp  $FORT51  $COMOUTwmo/
    fi

    if [ $SENDDBN_NTC = "YES" ] ; then
       $SIPHONROOT/bin/dbn_alert NTC_LOW ${DBN_ALERT_TYPE} $job $COMOUTwmo/grib2.t${cyc}z.awpreg_${RUNLOC}f${fhr}
    else
       msg="File $output_grb.$job not posted to db_net."
       postmsg  "$msg"
    fi

fi

done

#####################################################################
# GOOD RUN
set +x
echo "**************JOB $job COMPLETED NORMALLY on `hostname` at `date`"
echo "**************JOB $job COMPLETED NORMALLY on `hostname` at `date`"
echo "**************JOB $job COMPLETED NORMALLY on `hostname` at `date`"
set -x
#####################################################################
