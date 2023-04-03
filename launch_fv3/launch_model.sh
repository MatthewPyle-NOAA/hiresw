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
export TOTAL_TASKS=2232
export TASK_X=30
export TASK_Y=72
export NODES=18
        # quilt stuff
export WG=3
export WTPG=24

elif [ $DOM == "ak" ]
then
export        TOTAL_TASKS=1392
export        TASK_X=28
export        TASK_Y=48
export        NODES=11
        # quilt stuff
export        WG=2
export        WTPG=24

elif [ $DOM == "hi" ]
then
export        TOTAL_TASKS=156
export        TASK_X=8
export        TASK_Y=18
export        NODES=2
        # quilt stuff
export        WG=1
export        WTPG=12

elif [ $DOM == "pr" ]
then
export 	TOTAL_TASKS=228
export 	TASK_X=12
export	TASK_Y=18
	NODES=2
	# quilt stuff
export  WG=1
export 	WTPG=12


elif [ $DOM == "guam" ]
then
export        TOTAL_TASKS=156
export        TASK_X=8
export        TASK_Y=18
export        NODES=2
        # quilt stuff
export        WG=1
export        WTPG=12
fi


cat sub_model.lsf_in_cray_retro | sed s:_DATE_:${DATE}:g | sed s:_DOM_:${DOM}:g | \
        sed s:_CORE_:${CORE}:g | sed s:_CYC_:${CYC}:g  | sed s:_NODES_:${NODES}:g | \
	sed s:_TASK_X_:${TASK_X}:g | sed s:_TASK_Y_:${TASK_Y}:g  | \
	sed s:_WTPG_:${WTPG}:g | sed s:_WG_:${WG}:g | \
	sed s:_NPROC_:${TOTAL_TASKS}:g | sed s:_SPAN_:128:g > sub_model.lsf_${DOM}_${CORE}_${CYC}

qsub  sub_model.lsf_${DOM}_${CORE}_${CYC}

rm sub_model.lsf_${DOM}_${CORE}_${CYC}
