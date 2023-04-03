#! /bin/sh


DOM=${1}
CORE=${2}
CYC=${3}
DATE=${4}

cd /u/$USER    # cron does this for us - this is here just to be safe
. /etc/profile

if [ -a .profile ]; then
   . ./.profile
fi

if [ -a .bashrc ]; then
   . ./.bashrc
fi

export HOMEhiresw=/lfs/h2/emc/lam/noscrub/Matthew.Pyle/hiresw.v8.1.9
export HOMEfv3=/lfs/h2/emc/lam/noscrub/Matthew.Pyle/hiresw.v8.1.9

cd ${HOMEhiresw}/launch_fv3/

source ${HOMEhiresw}/versions/run.ver

if [ $DOM == "conus" ]
then
        TOTAL_TASKS=24
        NODES=1

elif [ $DOM == "ak" ]
then
        TOTAL_TASKS=12
        NODES=1

elif [ $DOM == "hi" ]
then
        TOTAL_TASKS=2
        NODES=1
elif [ $DOM == "pr" ]
then
export 	TOTAL_TASKS=2
	NODES=1

elif [ $DOM == "guam" ]
then
        TOTAL_TASKS=2
        NODES=1
fi


cat sub_post.lsf_in_cray_retro | sed s:_DATE_:${DATE}:g | sed s:_DOM_:${DOM}:g | \
        sed s:_CORE_:${CORE}:g | sed s:_CYC_:${CYC}:g  | sed s:_NODES_:${NODES}:g | \
	sed s:_NPROC_:${TOTAL_TASKS}:g | sed s:_POSTSPAN_:${TOTAL_TASKS}:g > sub_post.lsf_${DOM}_${CORE}_${CYC}

qsub  sub_post.lsf_${DOM}_${CORE}_${CYC}

rm sub_post.lsf_${DOM}_${CORE}_${CYC}
