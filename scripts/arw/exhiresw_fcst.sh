#!/bin/ksh
################################################################################
####  UNIX Script Documentation Block
#                      .                                             .
# Script name:         exhiresw_fcst.sh.sms
# Script description:  Runs NMMB or WRF-ARW forecast model
#
# Author:        Eric Rogers       Org: NP22         Date: 2004-07-07
#
# Script history log:
# 2003-11-01  Matthew Pyle - Original script for parallel
# 2004-07-07  Eric Rogers - Preliminary modifications for production.
# 2009-09-24  Shawna Cokley - Removes copy of date file to nmcdate
# 2013-02-20  Matthew Pyle - New branch for non-WRF (NMMB) code
# 2014-12-09  Matthew Pyle - restarting from non-zero capacity

set -x

msg="JOB $job FOR WRF NEST=${NEST}${MODEL} HAS BEGUN"
postmsg  "$msg"

cd $DATA

RUNLOC=${NEST}${MODEL}


#
# Get needed variables from exhiresw_prelim.sh.sms
#
. $COMIN/hiresw.t${cyc}z.${RUNLOC}.envir.sh

START=00
LENGTH=48

echo $CYCLE > fcstdate

PDY=`cat fcstdate | cut -c1-8`
DATE=`cat fcstdate | cut -c5-8`
CYC=`cat fcstdate | cut -c9-10`

YY=`cat fcstdate | cut -c1-4`
MM=`cat fcstdate | cut -c5-6`
DD=`cat fcstdate | cut -c7-8`
HH=`cat fcstdate | cut -c9-10`

year=`echo $PDY | cut -c1-4`
ym1=`expr $year - 1`


restart=.false.
runhour=$LENGTH

export tmmark="tm00"


rm fort.*

###

### are restart files in run directory?  If so, figure out where to restart, and clean up model 
### output from beyond that point

### configure/namelist file changes (restart --> true)?

### ARW needs new start time, right?

if [ $MODEL == "arw" ]
then

lasthour=00

if [ -e restartdone06.tm00 ]
then
lasthour=`ls -1rt restartdone??.tm00 | tail -1 | cut -c 12-13`
typeset -Z2 lasthour


if [ $lasthour -gt 0 ]
then

## compute new starting date and time for ARW

fcstdate=`$NDATE +${lasthour} ${CYCLE}`
YY=`echo $fcstdate | cut -c1-4`
MM=`echo $fcstdate | cut -c5-6`
DD=`echo $fcstdate | cut -c7-8`
HH=`echo $fcstdate | cut -c9-10`
let runhour="$LENGTH - $lasthour"
restart=.true.

### Since model can only be restarted if modolo(fhr,6)=0, compare last fcstdone file to last
### restartdone file. If they are not at the same forecast hour, delete all fcstdone files with fhr > then
### the last restartdone file so that the restarted post and postsnd jobs are in synch with the restarted
### model run

fcstlasthr=`ls -1 fcstdone??.tm00 | tail -1 | cut -c 9-10`

if [ $fcstlasthr -gt $lasthour ]
then
   rm fcstdone${fcstlasthr}*
   let "fhrm1=fcstlasthr-1"
   typeset -Z2 fhrm1
   while [ $fhrm1 -gt $lasthour ]
   do
     rm fcstdone${fhrm1}*
     let "fhrm1=fhrm1-1"
   done
fi

fi

fi

else

### NMMB

domain=1

if [ -e restartdone.0${domain}.0006h_00m_00.00s ] 
then
lasthour=`ls -1rt restartdone.0${domain}.????h_* | tail -1 | cut -c 18-19`


if [ $lasthour -gt 0 ]
then
restart=.true.

mv nmmb_rst_01_nio_00${lasthour}h_00m_00.00s restart_file_01_nemsio

### Since model can only be restarted if modolo(fhr,6)=0, compare last fcstdone file to last
### restartdone file. If they are not at the same forecast hour, delete all fcstdone files with fhr > then
### the last restartdone file so that the restarted post and postsnd jobs are in synch with the restarted
### model run

fcstlasthr=`ls -1 fcstdone.01.????h_* | tail -1 | cut -c 15-16`

echo fcstlasthr is $fcstlasthr

if [ $fcstlasthr -gt $lasthour ]
then
   rm fcstdone.01.00${fcstlasthr}h_*
   let "fhrm1=fcstlasthr-1"
   typeset -Z2 fhrm1
   while [ $fhrm1 -gt $lasthour ]
   do
     rm fcstdone.01.00${fhrm1}h_*
     let "fhrm1=fhrm1-1"
   done
fi

fi


fi

fi

if [ $MODEL != "nmmb" ]
then
cp $COMIN/hiresw.t${cyc}z.${NEST}${MODEL}.wrfbdy_d01 wrfbdy_d01
export err1=$?

if [ $NEST = "conus" -o $NEST = "pr" ]
then
cp $COMIN/hiresw.t${cyc}z.${NEST}${MODEL}.wrfinput_d01_rap wrfinput_d01
else
cp $COMIN/hiresw.t${cyc}z.${NEST}${MODEL}.wrfinput_d01 wrfinput_d01
fi

export err2=$?

cat $COMIN/hiresw.t${cyc}z.${NEST}${MODEL}.namelist.input | sed s:_YYS_:${YY}:g | \
                                                     sed s:_MMS_:${MM}:g | \
                                                     sed s:_DDS_:${DD}:g | \
                                                     sed s:_HHS_:${HH}:g | \
                                                     sed s:_RUNH_:${runhour}:g | \
                                                     sed s:_RESTART_:${restart}:g  > namelist.input
export err3=$?

if [ $err1 -ne 0 -o $err2 -ne 0 -o $err3 -ne 0 ]
then
msg="FATAL ERROR: ARW MODEL is missing a key input file such as wrfinput_d01, wrfbdy_d01, or namelist.input"
err_exit $msg
fi

cp $PARMhiresw/hiresw_LANDUSE.TBL LANDUSE.TBL
cp $PARMhiresw/hiresw_ETAMPNEW_DATA ETAMPNEW_DATA
cp $PARMhiresw/hiresw_VEGPARM.TBL VEGPARM.TBL
cp $PARMhiresw/hiresw_SOILPARM.TBL SOILPARM.TBL
cp $PARMhiresw/hiresw_GENPARM.TBL GENPARM.TBL
cp $PARMhiresw/hiresw_MPTABLE.TBL MPTABLE.TBL
cp $PARMhiresw/hiresw_URBPARM.TBL URBPARM.TBL
cp $FIXhiresw/hiresw_RRTM_DATA RRTM_DATA
cp $FIXhiresw/hiresw_tr49t67 tr49t67
cp $FIXhiresw/hiresw_tr49t85 tr49t85
cp $FIXhiresw/hiresw_tr67t85 tr67t85
cp $PARMhiresw/hiresw_micro_lookup.dat micro_lookup.dat

else

hrs="00 03 06 09 12 15 18 21 24 27 30 33 36 39 42 45"
for hr in $hrs
do
cp $COMIN/hiresw.t${cyc}z.${NEST}${MODEL}.boco.00${hr} boco.00${hr}
export err1=$?

if [ $err1 -ne 0 ]
then
msg="FATAL ERROR: NMMB MODEL is missing needed boco file for ${hr}"
err_exit $msg
fi

done

if [ $NEST = "conus" -o $NEST = "pr" ]
then

### CONUS input based on RAP produced by different job than the boundary files
### allow to sleep in case RAP job is running late (but should be done before
### boundaries are built

icnt=0

if [ ! -e $COMIN/hiresw.t${cyc}z.${NEST}${MODEL}.input_domain_01_nemsio_rap ]
then

while [ $icnt -lt 30 ]
do
if [ ! -e $COMIN/hiresw.t${cyc}z.${NEST}${MODEL}.input_domain_01_nemsio_rap ]
then
echo "$COMIN/hiresw.t${cyc}z.${NEST}${MODEL}.input_domain_01_nemsio_rap still not available"
sleep 45
fi
let icnt=icnt+1
done

fi



cp $COMIN/hiresw.t${cyc}z.${NEST}${MODEL}.input_domain_01_nemsio_rap input_domain_01_nemsio
else
cp $COMIN/hiresw.t${cyc}z.${NEST}${MODEL}.input_domain_01_nemsio input_domain_01_nemsio
fi

export err2=$?
cat $COMIN/hiresw.t${cyc}z.${NEST}${MODEL}.configure_file | sed s:_RESTART_:${restart}:g >  configure_file
export err3=$?

if [ $err1 -ne 0 -o $err2 -ne 0 -o $err3 -ne 0 ]
then
msg="FATAL ERROR: NMMB MODEL is missing a key input file such as input_domain_01_nemsio, boco.0045, or configure_file"
err_exit $msg
fi


cp configure_file                               model_configure
cp configure_file                               configure_file_01
cp $PARMhiresw/hiresw_ocean.configure           ocean.configure

####
#
cp $PARMhiresw/hiresw_solver_state.txt          solver_state.txt
#
####


cp $PARMhiresw/hiresw_filt_vars.txt             filt_vars.txt
cp $PARMhiresw/hiresw_moving_nest_shift.txt     moving_nest_shift.txt
cp $PARMhiresw/hiresw_nests.txt                 nests.txt
cp $PARMhiresw/hiresw_atmos.configure_nmm       atmos.configure
cp $FIXhiresw/hiresw_aerosol.dat                aerosol.dat

ln -sf ${FIXhiresw}/global_o3prdlos.f77 fort.28
ln -sf ${FIXhiresw}/global_o3clim.txt   fort.48

# nmmb specific versions

cp $PARMhiresw/hiresw_nmmb_ETAMPNEW_DATA ETAMPNEW_DATA
cp $PARMhiresw/hiresw_nmmb_ETAMPNEW_DATA.expanded_rain ETAMPNEW_DATA.expanded_rain
cp $PARMhiresw/hiresw_nmmb_GENPARM.TBL GENPARM.TBL
cp $PARMhiresw/hiresw_nmmb_IGBP_LANDUSE.TBL IGBP_LANDUSE.TBL
cp $PARMhiresw/hiresw_nmmb_IGBP_VEGPARM.TBL IGBP_VEGPARM.TBL

cp $PARMhiresw/hiresw_nmmb_IGBP_LANDUSE.TBL LANDUSE.TBL
cp $PARMhiresw/hiresw_nmmb_IGBP_VEGPARM.TBL VEGPARM.TBL

# cp $PARMhiresw/hiresw_nmmb_LANDUSE.TBL LANDUSE.TBL
cp $PARMhiresw/hiresw_nmmb_RRTM_DATA RRTM_DATA
cp $PARMhiresw/hiresw_nmmb_SOILPARM.TBL SOILPARM.TBL
# cp $PARMhiresw/hiresw_nmmb_VEGPARM.TBL VEGPARM.TBL
cp $FIXhiresw/hiresw_tr49t67 tr49t67
cp $FIXhiresw/hiresw_tr49t85 tr49t85
cp $FIXhiresw/hiresw_tr67t85 tr67t85
cp $FIXhiresw/global_co2historical* .


if [ -e global_co2historicaldata_${year}.txt ]
then
cp global_co2historicaldata_${year}.txt co2historicaldata_${year}.txt
cp co2historicaldata_${year}.txt co2historicaldata_glob.txt
else
echo "CURRENT YEAR CO2 file not found.  Use previous year version."
echo "CURRENT YEAR CO2 file not found.  Use previous year version."
echo "CURRENT YEAR CO2 file not found.  Use previous year version."
cp global_co2historicaldata_${ym1}.txt  co2historicaldata_glob.txt
cp global_co2historicaldata_${ym1}.txt  co2historicaldata_${ym1}.txt
fi

##
# Special provision for first cycle of the year (filtering takes it 
# into the preceding year).

if [ $DATE$CYC -eq 010100 ]
then
cp global_co2historicaldata_${ym1}.txt  co2historicaldata_glob.txt
cp global_co2historicaldata_${ym1}.txt  co2historicaldata_${ym1}.txt
fi
##

fi


if [ $MODEL == "arw" ]
then
export pgm=hiresw_wrfarwfcst
else
export pgm=hiresw_nmmbfcst
fi

. prep_step

# export FORT_BUFFERED=true


# define default runline option, which will be overridden
# for certain large domain runs

    cp $EXEChiresw/hiresw_wrfarwfcst .

# default runline for small domains
    runline="mpiexec -n $NTASK -ppn $PTILE ./hiresw_wrfarwfcst"
# fi


# special runline for large domains
if [ $RUNLOC = "conusarw"  -o $RUNLOC = "conusmem2arw" -o $RUNLOC = "akarw" \
       	-o  $RUNLOC = "akmem2arw" ]
then
# runline="mpiexec -cpu-bind verbose,depth -n $NTASK ./hiresw_wrfarwfcst"
    runline="mpiexec -n $NTASK -ppn $PTILE ./hiresw_wrfarwfcst"
fi

startmsg

echo will use runline $runline

$runline
export err=$?;err_chk

if [ $MODEL != "nmmb" ] ; then
    cat $DATA/rsl.error.0000 $DATA/rsl.out.0000 > $COMOUT/hiresw.t${cyc}z.${NEST}${MODEL}.fcst.log
    cat $DATA/rsl.error.0000 $DATA/rsl.out.0000 >>$pgmout
fi



msg="JOB $job FOR NEST=${NEST}${MODEL} HAS COMPLETED NORMALLY"
postmsg  "$msg"

date
