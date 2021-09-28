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

export HOMEhiresw=/lfs/h2/emc/lam/noscrub/Matthew.Pyle/hiresw.v8.0.5
export HOMEfv3=/lfs/h2/emc/lam/noscrub/Matthew.Pyle/hiresw.v8.0.5

cd ${HOMEhiresw}/launch_fv3/

source ${HOMEhiresw}/versions/fv3/run.ver

if [ $DOM == "conus" ]
then
        TOTAL_TASKS=2376
        TASK_X=30
        TASK_Y=72
        NODES=19
        # quilt stuff
        WG=3
        WTPG=72

elif [ $DOM == "ak" ]
then
        TOTAL_TASKS=1248
        TASK_X=24
        TASK_Y=48
        NODES=10
        # quilt stuff
        WG=2
        WTPG=48

elif [ $DOM == "hi" ]
then
export 	TOTAL_TASKS=2
	NODES=1
elif [ $DOM == "pr" ]
then
export 	TOTAL_TASKS=2
	NODES=1

elif [ $DOM == "guam" ]
then
        TOTAL_TASKS=162
        TASK_X=8
        TASK_Y=18
        NODES=2
        # quilt stuff
        WG=1
        WTPG=18
fi


cat sub_prdgen.lsf_in_cray_retro | sed s:_DATE_:${DATE}:g | sed s:_DOM_:${DOM}:g | \
        sed s:_CORE_:${CORE}:g | sed s:_CYC_:${CYC}:g  | sed s:_NODES_:${NODES}:g | \
	sed s:_NPROC_:${TOTAL_TASKS}:g | sed s:_POSTSPAN_:${TOTAL_TASKS}:g > sub_prdgen.lsf_${DOM}_${CORE}_${CYC}

qsub  sub_prdgen.lsf_${DOM}_${CORE}_${CYC}
