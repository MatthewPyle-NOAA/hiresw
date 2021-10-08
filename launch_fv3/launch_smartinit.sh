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

export HOMEhiresw=/lfs/h2/emc/lam/noscrub/Matthew.Pyle/hiresw.v8.1.0
export HOMEfv3=/lfs/h2/emc/lam/noscrub/Matthew.Pyle/hiresw.v8.1.0

cd ${HOMEhiresw}/launch_fv3/

source ${HOMEhiresw}/versions/run.ver

export 	TOTAL_TASKS=11
	NODES=1
export OMP_NUM_THREADS=1


cat sub_smartinit.lsf_in_cray_retro | sed s:_DATE_:${DATE}:g | sed s:_DOM_:${DOM}:g | \
        sed s:_CORE_:${CORE}:g | sed s:_CYC_:${CYC}:g  | sed s:_NODES_:${NODES}:g | \
	sed s:_NPROC_:${TOTAL_TASKS}:g | sed s:_POSTSPAN_:${TOTAL_TASKS}:g > sub_smartinit.lsf_${DOM}_${CORE}_${CYC}

qsub  sub_smartinit.lsf_${DOM}_${CORE}_${CYC}

rm sub_smartinit.lsf_${DOM}_${CORE}_${CYC}
