#!/bin/ksh
################################################################################
####  UNIX Script Documentation Block
#                      .                                             .
# Script name:         exhiresw_smartinit.sh.ecf
# Script description:  Run HiresW smart init jobs
#
# Author:        Bradley Mabe       Org: NP11         Date: 2007-08-23
#
# Abstract: This script runs the preparatory (predgen) portion of the  HiresWSmart Init jobs
#
# Script history log:
# 2007-08-23  Bradley Mabe  - Created script (copied actually) to call nam_smartinit on & off
#                          initially of Alaskan precip & snowfall
# 2007-09-17  Geoff Manikin - This version for CONUS runs
# 2011-07-06  Geoff Manikin - Adapted to use nested output
# 2011-07-22  Geoff Manikin - Can't use nest output for F00 
# 2012-12-22  Jeff McQueen  - Modified for unified smartinit system
#                             where configuration is controlled by RUNTYP Variable
# 2013-07-01  Jeff McQueen  - Enabled hrw guamnest smartinit ndfd grid 199 generation 
# 2013-07-02  Jeff McQueen  - Modified to create all 00 hour downscaling from NAM parent
#                             While 03 --> 54/60 created from NAM Nests
# 2014-01-23  Matthew Pyle  - Adopted for HiresW, split into two separate jobs

set -xa
msg="JOB $job HAS BEGUN"
postmsg  "$msg"

cd $DATA

RUNLOC=${NEST}${MODEL}

# 00/12 UTC CYCLE smartinit CONFIGURE
  export ENDHR=48
  export RUNTYP=${RUNLOC}


hr=00

hrlim=48

if [ -e $DATA/smartinitprdgendone00 ]
then
cd $DATA
lasthour=`ls -1rt smartinitprdgendone?? | tail -1 | cut -c 20-21`
let "hr=lasthour+1"
typeset -Z2 hr
fi

echo start smartinit with hr $hr


while [ $hr -le $hrlim ]
do

looplim=45
loop=1
while [ $loop -le $looplim ]
do
 echo in while
 if [ -s $INPUT_DATA/prdgendone${hr} ]
 then
   break
 else
   loop=$((loop+1))
   sleep 20
 fi
 if [ $loop -ge $looplim ]
   then
   msg="FATAL ERROR: ABORTING after 15 minutes of waiting for $INPUT_DATA/prdgendone${fhr}"
   err_exit $msg
 fi
done

if [ $(($hr % 3)) -eq 0 ]
then
   $USHhiresw/hiresw_smartinit.sh_justprdgeng2 ${hr}
fi

let "hr=hr+1"
typeset -Z2 hr

done

#####################################################################

echo EXITING $0
exit
#
