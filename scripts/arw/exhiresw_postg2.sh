#!/bin/ksh

################################################################################
####  UNIX Script Documentation Block
#                      .                                             .
# Script name:         exhiresw_post.sh.sms
# Script description:  Runs NMMB or WRF-ARW post-processor
#
# Author:        Eric Rogers       Org: NP22         Date: 2004-07-07
#
# Script history log:
#
# 2003-11-01  Matt Pyle - Original script for parallel
#
# 2004-07-07  Eric Rogers - Preliminary modifications for production.
#
# 2007-04-30  Matthew Pyle - Changed to a "one size fits all" version of the WRF post.
#                             Eliminated inline call of prdgen job.
#
# 2009-09-24  Pyle/Cokley  - Reduces potential for conflict with other jobs by:
#
#                            1) doing work in a "post" subdirectory
#                            2) eliminating write of "lower" file
#                            3) Extracting date information from PDY rather than
#                               copying date file
#
#                            Also, cleaned out some unused items related to prdgen to
#                            streamline and prevent confusion.
#
# 2013-09-01  Pyle          - Modified to be run from postmgr, working on $post_times
#                             passed into the script
# 2014-02-27  Pyle          - Modified to loop through forecast hours (reverting to old style)
# 2014-12-09  Pyle          - Modified so can start from non-zero time if postdone?? files
#                             exist

set -x

msg="JOB $job FOR WRF NEST=${NEST}${MODEL} HAS BEGUN"
postmsg "$msg"

RUNLOC=${NEST}${MODEL}


######
export INCR=01
######

rm OUTPUT* errfil*

cp $PARMhiresw/hiresw_micro_lookup.dat .
cp hiresw_micro_lookup.dat eta_micro_lookup.dat

#
# Get needed variables from exhiresw_prelim.sh.sms
#

. $COMIN/hiresw.t${cyc}z.${RUNLOC}.envir.sh

# fhr=00
# fhrend=48

## see if any postdone?? files exist, and if so, which is the last hour completed

# while [ $fhr -le $fhrend ]
# do

if [ -e ../postdone${fhr} ]
then
echo "It looks like this ARW post hour was run already"
ls -l ../postdone${fhr}
exit 0
fi

# done

# fhr=${fhrsave}

echo STARTING POST with fhr $fhr



# OUTTYP=binarympiio
OUTTYP=binary

model=`echo $MODEL | tr '[a-z]' '[A-Z]'`

YYYY=`echo $PDY | cut -c1-4`
MM=`echo $PDY | cut -c5-6`
DD=`echo $PDY | cut -c7-8`
CYCLE=$PDY$cyc

startd=$YYYY$MM$DD
startdate=$CYCLE

STARTDATE=${YYYY}-${MM}-${DD}_${cyc}:00:00

endtime=`$NDATE 48 $CYCLE`

YYYY=`echo $endtime | cut -c1-4`
MM=`echo $endtime | cut -c5-6`
DD=`echo $endtime | cut -c7-8`

FINALDATE=${YYYY}-${MM}-${DD}_${cyc}:00:00


### potentially redefine start date for non-zero start hour

if [ $fhr -gt 0 ]
then

startdate=`$NDATE $fhr ${CYCLE}`
YYYY=`echo $startdate | cut -c1-4`
MM=`echo $startdate | cut -c5-6`
DD=`echo $startdate | cut -c7-8`
HH=`echo $startdate | cut -c9-10`

STARTDATE=${YYYY}-${MM}-${DD}_${HH}:00:00

echo new STARTDATE $STARTDATE

fi



export tmmark=tm00

wyr=`echo $STARTDATE | cut -c1-4`
wmn=`echo $STARTDATE | cut -c6-7`
wdy=`echo $STARTDATE | cut -c9-10`
whr=`echo $STARTDATE | cut -c12-13`

eyr=`echo $FINALDATE | cut -c1-4`
emn=`echo $FINALDATE | cut -c6-7`
edy=`echo $FINALDATE | cut -c9-10`
ehr=`echo $FINALDATE | cut -c12-13`

edate=$eyr$emn$edy$ehr

# If job needs to be restarted due to production failure, reset
# wdate=valid date of first available WRF restart file

wdate=$wyr$wmn$wdy$whr

timeform=$STARTDATE

if [ $NEST = pr -o $NEST = guam -o $NEST = hi -o $NEST = prmem2 -o $NEST = himem2 ] ; then
 if [ $MODEL = nmmb ] ; then
    cp $PARMhiresw/hiresw_nmmb_cntrl.parm.xml_small postcntrl.xml
 else
    cp $PARMhiresw/hiresw_arw_cntrl.parm.xml_small postcntrl_nonf00.xml
    cp $PARMhiresw/hiresw_arw_cntrl.parm_f00.xml_small postcntrl_f00.xml
 fi
else
 if [ $MODEL = nmmb ] ; then
    cp $PARMhiresw/hiresw_nmmb_cntrl.parm.xml postcntrl.xml
 else
    cp $PARMhiresw/hiresw_arw_cntrl.parm.xml  postcntrl_nonf00.xml
    cp $PARMhiresw/hiresw_arw_cntrl.parm_f00.xml postcntrl_f00.xml
 fi
fi

##### export fhr=00

# while [ $wdate -le $edate ]
# do

date=`$NDATE $fhr $CYCLE`

wyr=`echo $date | cut -c1-4`
wmn=`echo $date | cut -c5-6`
wdy=`echo $date | cut -c7-8`
whr=`echo $date | cut -c9-10`

timeform=${wyr}"-"${wmn}"-"${wdy}"_"${whr}":00:00"

icnt=1


### for GRIB2 (from HRRR):

export SPLNUM=47
export SPL=2.,5.,7.,10.,20.,30.\
,50.,70.,75.,100.,125.,150.,175.,200.,225.\
,250.,275.,300.,325.,350.,375.,400.,425.,450.\
,475.,500.,525.,550.,575.,600.,625.,650.\
,675.,700.,725.,750.,775.,800.,825.,850.\
,875.,900.,925.,950.,975.,1000.,1013.2


## add $CYCLE so the starting time is avail in code?
## Does need to be in WRF time format?

YS=`echo $CYCLE | cut -c1-4`
MS=`echo $CYCLE | cut -c5-6`
DS=`echo $CYCLE | cut -c7-8`
HS=`echo $CYCLE | cut -c9-10`

timeformstart=${YS}"-"${MS}"-"${DS}"_"${HS}":00:00"

cat > itag <<EOF
$INPUT_DATA/wrfout_d01_${timeform}
$OUTTYP
grib2
${timeformstart}
${timeform}
${POSTMOD}
${NEST}
${SPLNUM}
${SPL}
${VALIDTIMEUNITS}
EOF

rm -f fort.*

cp ${PARMhiresw}/hiresw_post_avblflds.xml       post_avblflds.xml
cp ${PARMhiresw}/hiresw_params_grib2_tbl_new    params_grib2_tbl_new
                                                                                                                   
### assume that ready to process based on postmgr jobhj

if [ $MODEL = nmm ] ; then 

cat > itag <<EOF
$INPUT_DATA/wrfout_d01_${timeform}
$OUTTYP
$timeform
$model
EOF

elif [ $MODEL = arw ] ; then

export POSTMOD=NCAR

looplim=45
loop=1

if [ $fhr = "00" ]
then
cp postcntrl_f00.xml postcntrl.xml
else
cp postcntrl_nonf00.xml postcntrl.xml
fi


while [ $loop -le $looplim ]
do
 echo in while
 if [ -s $INPUT_DATA/fcstdone${fhr}.${tmmark} ]
 then
   break
 else
   loop=$((loop+1))
   sleep 20
 fi
 if [ $loop -ge $looplim ]
   then
   msg="FATAL ERROR: ABORTING after 15 minutes of waiting for $INPUT_DATA/fcstdone${fhr}.${tmmark}"
   err_exit $msg
 fi
done


# cat > itag <<EOF
# $INPUT_DATA/wrfout_d01_${timeform}
# $OUTTYP
# $timeform
# $POSTMOD
# EOF

cat > itag <<EOF
$INPUT_DATA/wrfout_d01_${timeform}
$OUTTYP
grib2
${timeformstart}
${timeform}
${POSTMOD}
${NEST}
${SPLNUM}
${SPL}
${VALIDTIMEUNITS}
EOF

else

export POSTMOD=NMM

looplim=45
loop=1
while [ $loop -le $looplim ]
do
 echo in while
 if [ -s $INPUT_DATA/fcstdone.01.00${fhr}h_00m_00.00s ]
 then
   break
 else
   loop=$((loop+1))
   sleep 20
 fi
 if [ $loop -ge $looplim ]
   then
   msg="FATAL ERROR: ABORTING after 15 minutes of waiting for $INPUT_DATA/fcstdone.01.00${fhr}h_00m_00.00s"
   err_exit $msg
 fi
done

# cat > itag <<EOF
# $INPUT_DATA/nmmb_hst_01_nio_00${fhr}h_00m_00.00s
# $OUTTYP
# $timeform
# $POSTMOD
# EOF

cat > itag <<EOF
$INPUT_DATA/nmmb_hst_01_nio_00${fhr}h_00m_00.00s
$OUTTYP
grib2
${timeformstart}
${timeform}
${POSTMOD}
${NEST}
${SPLNUM}
${SPL}
${VALIDTIMEUNITS}
EOF

fi
#-----------------------------------------------------------------------
#   Run wrf post.

export pgm=hiresw_${MODEL}_post
. prep_step

# export FORT14="wrf_cntrl.parm"

export FORT_BUFFERED=true

echo RUNLOC $RUNLOC

if [ $RUNLOC = "conusarw"  ]
then
 export MPICH_RANK_REORDER_METHOD=3
 cp $FIXhiresw/hiresw_post_rank_order_22task MPICH_RANK_ORDER
elif [ $RUNLOC = "conusmem2arw" ]
then
 export MPICH_RANK_REORDER_METHOD=3
 cp $FIXhiresw/hiresw_post_rank_order_16task MPICH_RANK_ORDER
elif [ $RUNLOC = "akarw" ]
then
 export MPICH_RANK_REORDER_METHOD=3
 cp $FIXhiresw/hiresw_post_rank_order_16task MPICH_RANK_ORDER
elif [ $RUNLOC = "akmem2arw" ]
then
 export MPICH_RANK_REORDER_METHOD=3
 cp $FIXhiresw/hiresw_post_rank_order_16task MPICH_RANK_ORDER
fi

mpiexec  -n $NTASK -ppn $PTILE $EXEChiresw/hiresw_post  <  itag  > $pgmout 2>errfile
export err=$?;err_chk

if [ $err -eq 0 ]
then
# move output to main post run directory
mv WRFPRS${fhr}.tm00  ${DATA}/
fi

cp $pgmout ${DATA}/${pgmout}_${fhr}
cp errfile ${DATA}/errfile_${fhr}

echo "done executing the post" > $DATA/postdone${fhr}
# postmsg  "HIRESW ${NEST}${MODEL} POST done for F${fhr}"

# fhr=`expr $fhr + $INCR`

# if [ $fhr -lt 10 ]
# then
# fhr=0$fhr
# fi

# wdate=`$NDATE ${fhr} $CYCLE`

# done

echo EXITING $0
exit
