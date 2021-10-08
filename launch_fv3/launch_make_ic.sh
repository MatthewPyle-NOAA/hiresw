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

echo NDATE is $NDATE

if [ $DOM$CORE == "hiarw" ] 
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
elif [ $DOM$CORE == "himem2arw" ]
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
elif [ $DOM$CORE == "prarw" ]
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
elif [ $DOM$CORE == "prmem2arw" ]
then
MODPROCS=124
MODNODES=1
MODSPAN=124
POSTPROCS=2
POSTSPAN=2
PRDGENPROCS=2
PRDGENSPAN=2
BUFRSPAN=1
NPROCBUFR=1
elif [ $DOM$CORE == "guamarw" ]
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
elif [ $DOM$CORE == "conusarw" ]
then
MODPROCS=1632
MODNODES=12
NCPUSMOD=128
NCPUSQUILT=96
MODSPAN=128
POSTPROCS=22
POSTSPAN=11
PRDGENPROCS=13
PRDGENSPAN=5
NPROCBUFR=1
BUFRSPAN=1
elif [ $DOM$CORE == "conusmem2arw" ]
then
MODPROCS=1376
MODNODES=10
NCPUSMOD=128
NCPUSQUILT=96
MODSPAN=128
POSTPROCS=16
POSTSPAN=8
PRDGENPROCS=12
PRDGENSPAN=5
NPROCBUFR=1
BUFRSPAN=1
elif [ $DOM$CORE == "akarw" ]
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
elif [ $DOM$CORE == "akmem2arw" ]
then
MODPROCS=944
NCPUSMOD=128
MODNODES=7
NCPUSQUILT=48
MODSPAN=24
POSTPROCS=16
POSTSPAN=8
PRDGENPROCS=5
PRDGENSPAN=5
NPROCBUFR=1
BUFRSPAN=1
fi


cat sub_make_ic.lsf_in_cray_retro  | sed s:_DATE_:${DATE}:g | sed s:_DOM_:${DOM}:g | \
	sed s:_CORE_:${CORE}:g | sed s:_CYC_:${CYC}:g > sub_make_ic.lsf_${DOM}_${CORE}_${CYC}_retro

qsub sub_make_ic.lsf_${DOM}_${CORE}_${CYC}_retro
rm sub_make_ic.lsf_${DOM}_${CORE}_${CYC}_retro
