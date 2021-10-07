#!/bin/ksh
#
# Script name:         exhiresw_pmgr.sh.sms
#
#  This script monitors the progress of the hiresw_fcst job
#
set -x

hour=00
TEND=48
TCP=49

if [ -e posthours ]; then
   rm -f posthours
fi

while [ $hour -lt $TCP ]; 
do
  hour=$(printf %02i $hour)
  echo $hour >>posthours
  let "hour=hour+1"
done
postjobs=`cat posthours`

#
# Wait for all fcst hours to finish 
#
icnt=1
while [ $icnt -lt 1000 ]
do
  for fhr in $postjobs
  do 
    fhr2=`printf "%02d" $fhr`   
    if [ -s ${INPUT_DATA}/fcstdone${fhr}.tm00 ]
    then
      ecflow_client --event release_post${fhr2}
      # Remove current fhr from list
      postjobs=`echo $postjobs | sed "s/${fhr}//"`
    fi
  done
  
  result_check=`echo $postjobs | wc -w`
  if [ $result_check -eq 0 ]
  then
     break
  fi

  sleep 10
  icnt=$((icnt + 1))
  if [ $icnt -ge 720 ]
  then
    msg="ABORTING after 2 hours of waiting for $INPUT_DATA/logf0${fhr}."
    err_exit $msg
  fi

done

echo Exiting $0

exit
