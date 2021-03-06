#!/bin/ksh
################################################################################
####  UNIX Script Documentation Block
#                      .                                             .
# Script name:         exhiresw_prepfinal.sh.sms
# Script description:  Runs WRF REAL code for the WRF-ARW 
#
# Author:        Eric Rogers       Org: NP22         Date: 2004-07-02
#
# Abstract: The script runs the final piece of the WRF-ARW hiresw preprocessing.
#           It runs the WRF "REAL" code which interpolate in the vertical and
#           generates WRF model initial and lateral boundary conditions
#
# Script history log:
# 2003-11-01  Matt Pyle - Original script for parallel
# 2004-07-02  Eric Rogers - Preliminary modifications for production.
# 2004-10-01  Eric Rogers - Modified to run special real executable for Alaska NMM
# 2007-04-09  Matthew Pyle - Modified to run WPS rather than wrfsi
# 2009-09-24  Shawna Cokley - Streamlines way script obtains date information -
#                             pulls from $PDY rather than copying a file to the working directory
# 2013-10-30  Matthew Pyle - Breaks out last piece from old prelim script  to run real, just for WRF-ARW

set -x

LENGTH=48

### NEST options are east, west, ak, hi, pr, or conus
### MODEL is arw or nmm or nmmb

msg="JOB $job FOR WRF NEST=${NEST}${MODEL} HAS BEGUN"
postmsg  "$msg"

RUNLOC=${NEST}${MODEL}

yy=`echo $PDY | cut -c1-4`
mm=`echo $PDY | cut -c5-6`
dd=`echo $PDY | cut -c7-8`

ystart=`echo $PDY | cut -c1-4`
mstart=`echo $PDY | cut -c5-6`
dstart=`echo $PDY | cut -c7-8`

start=$ystart$mstart$dstart$cyc

filt_start=`$NDATE -1 $start`

filt_ys=`echo $filt_start | cut -c1-4`
filt_ms=`echo $filt_start | cut -c5-6`
filt_ds=`echo $filt_start | cut -c7-8`
filt_hs=`echo $filt_start | cut -c9-10`

filt_ye=$ystart
filt_me=$mstart
filt_de=$dstart
filt_he=$cyc

export CYCLE=$PDY$cyc
echo "export CYCLE=$CYCLE" >> $COMOUT/hiresw.t${cyc}z.${RUNLOC}.envir.sh

#########################################################
# RUN REAL PROGRAM TO GENERATE WRFINPUT/WRFBDY FILES (ARW)
#########################################################

cd $DATA

cycstart=`echo ${PDY}${cyc}`

start=$ystart$mstart$dstart

end=`$NDATE $LENGTH $cycstart`

yend=`echo $end | cut -c1-4`
mend=`echo $end | cut -c5-6`
dend=`echo $end | cut -c7-8`
hend=`echo $end | cut -c9-10`

## for all domains now, special namelist.input files are required for the model

### this could be generalized and simplified

if [ $NEST = "pr" -o $NEST = "prmem2" -o $NEST = "hi" -o  $NEST = "himem2" -o \
     $NEST = "guam" -o $NEST = "ak" -o $NEST = "conus" -o "conusmem2"  -o $NEST = "akmem2"  ] ; then

  cp $PARMhiresw/hiresw_${MODEL}_namelist.input_in_${NEST} namelist.input_in
  cp $PARMhiresw/hiresw_${MODEL}_namelist.input_in_${NEST}_model namelist.input_in_model

else

msg="FATAL ERROR: invalid NEST choice $NEST in prepfinal"
err_exit $msg
fi


### number of input levels depends on source model data

if [ $NEST != "conusmem2" -a $NEST != "akmem2" -a $NEST != "prmem2" -a $NEST != "himem2" ]
then
NUMLEVS=27
else
NUMLEVS=40
fi

cat namelist.input_in | sed s:YSTART:$ystart: | sed s:MSTART:$mstart: \
 | sed s:DSTART:$dstart: | sed s:HSTART:$cyc: | sed s:YEND:$yend: \
 | sed s:MEND:$mend:     | sed s:DEND:$dend: | sed s:HEND:$hend:  \
 | sed s:FILT_YS:${filt_ys}: | sed s:FILT_MS:${filt_ms}: | sed s:FILT_DS:${filt_ds}: \
 | sed s:FILT_HS:${filt_hs}: | sed s:FILT_YE:${filt_ye}: | sed s:FILT_ME:${filt_me}: \
 | sed s:FILT_DE:${filt_de}: | sed s:FILT_HE:${filt_he}: \
 | sed s:NUMLEV:$NUMLEVS: > namelist.input

cat namelist.input_in_model | sed s:YSTART:$ystart: | sed s:MSTART:$mstart: \
 | sed s:DSTART:$dstart: | sed s:HSTART:$cyc: | sed s:YEND:$yend: \
 | sed s:MEND:$mend:     | sed s:DEND:$dend: | sed s:HEND:$hend:  \
 | sed s:FILT_YS:${filt_ys}: | sed s:FILT_MS:${filt_ms}: | sed s:FILT_DS:${filt_ds}: \
 | sed s:FILT_HS:${filt_hs}: | sed s:FILT_YE:${filt_ye}: | sed s:FILT_ME:${filt_me}: \
 | sed s:FILT_DE:${filt_de}: | sed s:FILT_HE:${filt_he}: \
 | sed s:NUMLEV:$NUMLEVS: > namelist.input_model

rm fort.*

cp $PARMhiresw/hiresw_LANDUSE.TBL LANDUSE.TBL
cp $PARMhiresw/hiresw_ETAMPNEW_DATA ETAMPNEW_DATA
cp $PARMhiresw/hiresw_ETAMPNEW_DATA micro_lookup.dat
cp $PARMhiresw/hiresw_VEGPARM.TBL VEGPARM.TBL
cp $PARMhiresw/hiresw_SOILPARM.TBL SOILPARM.TBL
cp $PARMhiresw/hiresw_GENPARM.TBL GENPARM.TBL

cp $FIXhiresw/hiresw_RRTM_DATA RRTM_DATA
cp $FIXhiresw/hiresw_tr49t67 tr49t67
cp $FIXhiresw/hiresw_tr49t85 tr49t85
cp $FIXhiresw/hiresw_tr67t85 tr67t85


FHRS="00 03 06 09 12 15 18 21 24 27 30 33 36 39 42 45 48"
for FHR in $FHRS
do
newdate=`$NDATE +$FHR $cycstart`
yy=`echo $newdate | cut -c1-4`
mm=`echo $newdate | cut -c5-6`
dd=`echo $newdate | cut -c7-8`
hh=`echo $newdate | cut -c9-10`
mv $INPUT_DATA/hiresw.t${cyc}z.${NEST}${MODEL}.met_em.d01.${yy}-${mm}-${dd}_${hh}:00:00.bin met_em.d01.${yy}-${mm}-${dd}_${hh}:00:00.bin
done

export pgm=hiresw_${MODEL}_init
. prep_step

startmsg

export MP_PGMMODEL=spmd
unset MP_CMDFILE
export FORT_BUFFERED=true


mpiexec -n $NTASK -ppn $PTILE  $EXEChiresw/hiresw_wrfarwfcst_init > $pgmout 2>&1

export err=$?; err_chk

# Copy 3 files needed to run WRF forecast to COM (two in case of CONUS domain)
# CONUS domain input file produced by separate JHIRESW_PREPRAP job

cp wrfbdy_d01 $COMOUT/hiresw.t${cyc}z.${NEST}${MODEL}.wrfbdy_d01
cp namelist.input_model $COMOUT/hiresw.t${cyc}z.${NEST}${MODEL}.namelist.input

if [ $NEST != "conus" -a $NEST != "pr" ]
then
 cp wrfinput_d01 $COMOUT/hiresw.t${cyc}z.${NEST}${MODEL}.wrfinput_d01

 if [ ! -f $COMOUT/hiresw.t${cyc}z.${NEST}${MODEL}.wrfbdy_d01 ] || [ ! -f $COMOUT/hiresw.t${cyc}z.${NEST}${MODEL}.wrfinput_d01 ]; then
   msg="FATAL ERROR: WRF initial or boundary condition files needed by WRF-ARW model not copied to $COMOUT"
   err_exit $msg
 fi
fi

cat $DATA/rsl.error.0000 $DATA/rsl.out.0000 >  $COMOUT/hiresw.t${cyc}z.${NEST}${MODEL}.real.log

msg="JOB $job FOR WRF NEST=${NEST}${MODEL} HAS COMPLETED NORMALLY"
postmsg "$msg"
