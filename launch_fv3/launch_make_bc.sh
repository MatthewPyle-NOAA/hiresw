#! /bin/sh

DOM=${1}
CORE=${2}
CYC=${3}
DATE=${4}


if [ $CORE != 'fv3' ]
then
	echo BAD CORE for this job
	echo CORE was $CORE
	echo needed to be fv3
fi


cd /u/$USER    # cron does this for us - this is here just to be safe
. /etc/profile

if [ -a .profile ]; then
   . ./.profile
fi

if [ -a .bashrc ]; then
   . ./.bashrc
fi



module load prod_envir
module load prod_util

cd /lfs/h2/emc/lam/noscrub/Matthew.Pyle/hiresw.v8.0.5/launch_fv3/


echo NDATE is $NDATE



if [ $DOM$CORE == "conusfv3" ] 
then
NPROC=16
MEM=130
elif [ $DOM$CORE == "prfv3" ]
then
NPROC=8
MEM=75
elif [ $DOM$CORE == "hifv3" ]
then
NPROC=8
MEM=70
elif [ $DOM$CORE == "guamfv3" ]
then
NPROC=8
MEM=70
elif [ $DOM$CORE == "akfv3" ]
then
NPROC=16
MEM=100
fi

hours="03 06 09 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60"

for hr in $hours
do

cat sub_make_bc.lsf_in_cray_retro  | sed s:_DATE_:${DATE}:g | sed s:_DOM_:${DOM}:g | \
	sed s:_NPROC_:${NPROC}:g | sed s:_MEM_:${MEM}:g | \
	sed s:_CORE_:${CORE}:g | sed s:_CYC_:${CYC}:g | sed s:_HR_:${hr}:g  > sub_make_bc.lsf_${DOM}_${CORE}_${CYC}_retro_${hr}

qsub sub_make_bc.lsf_${DOM}_${CORE}_${CYC}_retro_${hr}

sleep 2

rm sub_make_bc.lsf_${DOM}_${CORE}_${CYC}_retro_${hr}

done
