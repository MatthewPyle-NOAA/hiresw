#!/bin/ksh
################################################################################
####  UNIX Script Documentation Block
#                      .                                             .
# Script name:         exhiresw_prdgen.sh
# Script description:  Run hiresw product generator jobs
#
# Author:        Eric Rogers       Org: NP22         Date: 1999-06-23
#
# Abstract: This script runs the HiresW PRDGEN jobs
#
# Script history log:
# 1999-06-23  Eric Rogers
# 1999-08-25  Brent Gordon  Modified for production, removed here file.
# 2003-03-21  Eric Rogers  Modified for special hourly output
# 2007-04-30  Matthew Pyle - Adopted for HiresW use
# 2008-05-06  Chris Magee - Add prdgendone file for gempak step to key on.
# 2009-09-24  Shawna Cokley - Eliminates copy of date file to working directory
# 2012-12-13  Matthew Pyle - Small changes for WCOSS machine
# 2013-09-01  Matthew Pyle - Changes to be run from prdgenmgr (works on the $post_times hour passed in)
# 2014-02-27  Matthew Pyle - Undoes changes to be run from prdgenmgr (now loops over time again)
# 2014-12-09  Matthew Pyle - Adds ability to be restarted midstream
# 2019-11-18  Matthew Pyle - Adapated for FV3 system
# 2021-01-27  Matthew Pyle - Removes looping over time within script - just work on ${fhr} passed in
# 2026-09-22  Matthew Pyle - Streamlines to be a Guam-only script
#

set -x

cd $DATA
filedir=$DATA

export tmmark=tm00

# export fhr=00
# export fhrend=60

## see if any prdgendone?? files exist, and if so, which is the last hour completed

# while [ $fhr -le $fhrend ]
# do

if [ -e ./prdgendone${fhr} ]
then
echo "f${fhr} of prdgen appears to have already run"
ls -l ./prdgendone${fhr}
exit 0
fi

# done

# fhr=${fhrsave}

echo STARTING PRDGEN with fhr $fhr

icnt=1

# while [ $fhr -le $fhrend ]
# do


echo to here with INPUT_DATA $INPUT_DATA

looplim=90
loop=1

while [ $loop -le $looplim ]
do
 echo in while
 if [ -s $INPUT_DATA/postdone${fhr} ]
 then
   break
 else
   loop=$((loop+1))
   sleep 20
 fi
 if [ $loop -ge $looplim ]
   then
   msg="FATAL ERROR: ABORTING after 30 minutes of waiting for $INPUT_DATA/postdone${fhr}"
   err_exit $msg
 fi
done

echo "$USHfv3/hiresw_prdgen_big_grid_g2.sh $fhr $NEST $cyc $MODEL 0 &" > $DATA/poescript_${fhr}
echo "$USHfv3/hiresw_prdgen_oldgrid_g2.sh $fhr $NEST $cyc $MODEL 0 &" >> $DATA/poescript_${fhr}
chmod 775 $DATA/poescript_${fhr}
command="$DATA/poescript_${fhr} "

# time $command
mpiexec -cpu-bind verbose,depth --configfile ${command}

export err=$?; err_chk

  if test $SENDCOM = 'YES'
  then

echo here with DATA $DATA

ls -l  $DATA/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2_0
$WGRIB2 $DATA/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2_0 -ncep_uv $COMOUT/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2
$WGRIB2 $COMOUT/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2 -s > $COMOUT/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2.idx

rm $DATA/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2_0

    if [ $SENDDBN = YES ]; then
       $SIPHONROOT/bin/dbn_alert MODEL ${DBN_ALERT_TYPE}      $job $COMOUT/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2
       $SIPHONROOT/bin/dbn_alert MODEL ${DBN_ALERT_TYPE_WIDX} $job $COMOUT/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2.idx
    fi

  fi

export err=$?; err_chk

if [ $SENDCOM = YES ]
then

  if [ $tmmark = tm00 ] ; then
    cp $INPUT_DATA/BGDAWP${fhr}.${tmmark} ${COMOUT}/${RUN}.t${cyc}z.${NEST}fv3.natprs.f${fhr}.grib2
  else
    cp $INPUT_DATA/BGDAWP${fhr}.${tmmark} ${COMOUT}/${RUN}.t${cyc}z.${NEST}fv3.natprs.f${fhr}.${tmmark}.grib2
  fi

fi

echo "done executing prdgen" > $DATA/prdgendone${fhr}
postmsg  "HIRESW ${NEST}${MODEL} PRDGEN done for F${fhr}"

if [ $fhr -eq 60 -a $SENDECF = YES ]; then
  ecflow_client --event prdgen60_ready
fi
