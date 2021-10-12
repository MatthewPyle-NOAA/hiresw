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
	exit
fi

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

module load prod_envir/${prod_envir_ver}
module load prod_util/${prod_util_ver}

cat sub_make_ic.lsf_in_cray_retro  | sed s:_DATE_:${DATE}:g | sed s:_DOM_:${DOM}:g | \
	sed s:_CORE_:${CORE}:g | sed s:_CYC_:${CYC}:g > sub_make_ic.lsf_${DOM}_${CORE}_${CYC}_retro

qsub sub_make_ic.lsf_${DOM}_${CORE}_${CYC}_retro
rm sub_make_ic.lsf_${DOM}_${CORE}_${CYC}_retro
