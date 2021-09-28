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



module load prod_envir
module load prod_util

cd /lfs/h2/emc/lam/noscrub/Matthew.Pyle/hiresw.v8.0.5/launch_fv3/


echo NDATE is $NDATE



if [ $DOM$CORE == "conusfv3" ] 
then
MODPROCS=82
MODSPAN=82
MODNODES=1
POSTPROCS=2
POSTSPAN=2
PRDGENPROCS=2
PRDGENSPAN=2
BUFRSPAN=1
NPROCBUFR=1
NPROCBUFR=1
elif [ $DOM$CORE == "prfv3" ]
then
MODPROCS=158
MODNODES=2
MODSPAN=79
POSTPROCS=2
POSTSPAN=2
PRDGENPROCS=2
PRDGENSPAN=2
BUFRSPAN=1
NPROCBUFR=1
elif [ $DOM$CORE == "guamfv3" ]
then
MODPROCS=104
MODNODES=1
NCPUSMOD=100
NCPUSQUILT=4
MODSPAN=104
POSTPROCS=2
POSTSPAN=2
PRDGENPROCS=2
PRDGENSPAN=2
BUFRSPAN=1
NPROCBUFR=1
elif [ $DOM$CORE == "akfv3" ]
then
MODPROCS=1340
MODNODES=10
MODSPAN=128
NCPUSMOD=128
NCPUSQUILT=60
POSTPROCS=16
POSTSPAN=8
PRDGENPROCS=5
PRDGENSPAN=5
NPROCBUFR=1
BUFRSPAN=1
fi


cat sub_make_bc.lsf_in_cray_retro  | sed s:_DATE_:${DATE}:g | sed s:_DOM_:${DOM}:g | \
	sed s:_CORE_:${CORE}:g | sed s:_CYC_:${CYC}:g > sub_make_bc.lsf_${DOM}_${CORE}_${CYC}_retro

qsub sub_make_bc.lsf_${DOM}_${CORE}_${CYC}_retro

