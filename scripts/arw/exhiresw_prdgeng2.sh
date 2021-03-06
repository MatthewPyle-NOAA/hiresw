#!/bin/ksh
################################################################################
####  UNIX Script Documentation Block
#                      .                                             .
# Script name:         exhiresw_prdgen.sh
# Script description:  Run hiresw product generator jobs
#
# Author:        Eric Rogers       Org: NP22         Date: 1999-06-23
#
# Abstract: This script runs the HiresW PRDGEN jobs
#
# Script history log:
# 1999-06-23  Eric Rogers
# 1999-08-25  Brent Gordon  Modified for production, removed here file.
# 2003-03-21  Eric Rogers  Modified for special hourly output
# 2007-04-30  Matthew Pyle - Adopted for HiresW use
# 2008-05-06  Chris Magee - Add prdgendone file for gempak step to key on.
# 2009-09-24  Shawna Cokley - Eliminates copy of date file to working directory
# 2012-12-13  Matthew Pyle - Small changes for WCOSS machine
# 2013-09-01  Matthew Pyle - Changes to be run from prdgenmgr (works on the $post_times hour passed in)
# 2014-02-27  Matthew Pyle - Undoes changes to be run from prdgenmgr (now loops over time again)
# 2014-12-09  Matthew Pyle - Adds ability to be restarted midstream
# 2021-01-27  Matthew Pyle - Removes looping over time within script - just work on ${fhr} passed in
#

set -x

######
export INCR=01
######

cd $DATA
filedir=$DATA

export tmmark=tm00

# export fhr=00
# export fhrend=48

## see if any prdgendone?? files exist, and if so, which is the last hour completed

# while [ $fhr -le $fhrend ]
# do

if [ -e prdgendone${fhr} ]
then
echo "f${fhr} of prdgen appears to have already run"
ls -l ./prdgendone${fhr}
exit 0
fi

# done

# fhr=${fhrsave}

echo STARTING PRDGEN with fhr $fhr


icnt=1

# while [ $fhr -le $fhrend ]
# do


if [ $NEST = "conus" -o $NEST = "conusmem2" ]
then

echo "$USHhiresw/hiresw_prdgen_big_grid_g2.sh $fhr $NEST $cyc $MODEL 1 " > $DATA/poescript_${fhr}
echo "$USHhiresw/hiresw_prdgen_big_grid_g2.sh $fhr $NEST $cyc $MODEL 2 " >> $DATA/poescript_${fhr}
echo "$USHhiresw/hiresw_prdgen_big_grid_g2.sh $fhr $NEST $cyc $MODEL 3 " >> $DATA/poescript_${fhr}
echo "$USHhiresw/hiresw_prdgen_5km_grid_g2.sh     $fhr $NEST $cyc $MODEL 1 " >> $DATA/poescript_${fhr}
echo "$USHhiresw/hiresw_prdgen_5km_grid_g2.sh     $fhr $NEST $cyc $MODEL 2 " >> $DATA/poescript_${fhr}
echo "$USHhiresw/hiresw_prdgen_5km_grid_g2.sh     $fhr $NEST $cyc $MODEL 3 " >> $DATA/poescript_${fhr}
echo "$USHhiresw/hiresw_prdgen_5km_grid_g2.sh     $fhr $NEST $cyc $MODEL 4 " >> $DATA/poescript_${fhr}
echo "$USHhiresw/hiresw_prdgen_5km_grid_g2.sh     $fhr $NEST $cyc $MODEL 5 " >> $DATA/poescript_${fhr}
echo "$USHhiresw/hiresw_prdgen_5km_grid_g2.sh     $fhr $NEST $cyc $MODEL 6 " >> $DATA/poescript_${fhr}
echo "$USHhiresw/hiresw_prdgen_oldgrid_g2.sh_5km  $fhr $NEST $cyc $MODEL 1 conus " >> $DATA/poescript_${fhr}
echo "$USHhiresw/hiresw_prdgen_oldgrid_g2.sh_5km  $fhr $NEST $cyc $MODEL 2 conus " >> $DATA/poescript_${fhr}
echo "$USHhiresw/hiresw_prdgen_3km_grid_g2.sh     $fhr $NEST $cyc $MODEL 1 " >> $DATA/poescript_${fhr}
chmod 775 $DATA/poescript_${fhr}
command="$DATA/poescript_${fhr} "

elif [ $NEST = "ak" -o $NEST = "akmem2" ]
then

echo "$USHhiresw/hiresw_prdgen_big_grid_g2.sh $fhr $NEST $cyc $MODEL 0" > $DATA/poescript_${fhr}
echo "$USHhiresw/hiresw_prdgen_oldgrid_g2.sh $fhr $NEST $cyc $MODEL 1" >> $DATA/poescript_${fhr}
echo "$USHhiresw/hiresw_prdgen_oldgrid_g2.sh $fhr $NEST $cyc $MODEL 2" >> $DATA/poescript_${fhr}
echo "$USHhiresw/hiresw_prdgen_oldgrid_g2.sh $fhr $NEST $cyc $MODEL 3" >> $DATA/poescript_${fhr}
echo "$USHhiresw/hiresw_prdgen_oldgrid_g2.sh $fhr $NEST $cyc $MODEL 4" >> $DATA/poescript_${fhr}
chmod 775 $DATA/poescript_${fhr}
command="$DATA/poescript_${fhr} "

else
echo "$USHhiresw/hiresw_prdgen_big_grid_g2.sh $fhr $NEST $cyc $MODEL 0 " > $DATA/poescript_${fhr}
echo "$USHhiresw/hiresw_prdgen_oldgrid_g2.sh $fhr $NEST $cyc $MODEL 0 " >> $DATA/poescript_${fhr}
chmod 775 $DATA/poescript_${fhr}
command="$DATA/poescript_${fhr} "
fi

export MP_PGMMODEL=mpmd
export MP_CMDFILE=$DATA/poescript_${fhr}
#

# Execute the script.
#time mpirun.lsf
# time $command
mpiexec -cpu-bind verbose,depth --configfile ${command}
export err=$?; err_chk

if [ $NEST = "conus" ]
then

# reassemble the large 5 km output grid

  if test $SENDCOM = 'YES'
  then

cat $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_1 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_2 \
    $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_3 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_4 \
    $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_5 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_6 > \
    $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2
 
$WGRIB2 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2 -ncep_uv $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2
$WGRIB2 $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2 -s > $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2.idx

## subset the full CONUS grid to approximate the CAM common grid list
## now likely will interpolate subset products to 3 km grid instead for CONUS

### change to use a PARM .txt file, and do for CONUS and AK

# cp $PARMhiresw/hiresw_subset.txt .

# $WGRIB2 $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2 |  grep -F -f hiresw_subset.txt | \
# $WGRIB2  -i -grib $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.subset.grib2  $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2 

cat $DATA/hiresw.t${cyc}z.${MODEL}_3km.f${fhr}.conus.grib2_1  > $COMOUT/hiresw.t${cyc}z.${MODEL}_3km.f${fhr}.conus.subset.grib2
$WGRIB2 $COMOUT/hiresw.t${cyc}z.${MODEL}_3km.f${fhr}.conus.subset.grib2 -s > $COMOUT/hiresw.t${cyc}z.${MODEL}_3km.f${fhr}.conus.subset.grib2.idx


    if [ $SENDDBN = YES ]; then
       $SIPHONROOT/bin/dbn_alert MODEL HIRESW_3KM_CONUS       $job $COMOUT/hiresw.t${cyc}z.${MODEL}_3km.f${fhr}.conus.subset.grib2
       $SIPHONROOT/bin/dbn_alert MODEL HIRESW_3KM_CONUS_WIDX  $job $COMOUT/hiresw.t${cyc}z.${MODEL}_3km.f${fhr}.conus.subset.grib2.idx
       $SIPHONROOT/bin/dbn_alert MODEL ${DBN_ALERT_TYPE}      $job $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2
       $SIPHONROOT/bin/dbn_alert MODEL ${DBN_ALERT_TYPE_WIDX} $job $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2.idx
    fi

  fi # SENDCOM


rm  $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_1 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_2 \
    $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_3 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_4 \
    $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_5 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_6

# reassemble the ndfd output grid

cat $DATA/hiresw.t${cyc}z.${MODEL}_2p5km.f${fhr}.${NEST}.grib2_1  $DATA/hiresw.t${cyc}z.${MODEL}_2p5km.f${fhr}.${NEST}.grib2_2 \
    $DATA/hiresw.t${cyc}z.${MODEL}_2p5km.f${fhr}.${NEST}.grib2_3 > $DATA/hiresw.t${cyc}z.${MODEL}_2p5km.f${fhr}.${NEST}.grib2


## is this overwritten by smartinit output?
#  if test $SENDCOM = 'YES'
#  then
# cp $DATA/prdgen_full/hiresw.t${cyc}z.${MODEL}_2p5km.f${fhr}.conus.grib2 $COMOUT/hiresw.t${cyc}z.${MODEL}_2p5km.f${fhr}.conus.grib2
#   fi

rm $DATA/hiresw.t${cyc}z.${MODEL}_2p5km.f${fhr}.conus.grib2_1 
rm $DATA/hiresw.t${cyc}z.${MODEL}_2p5km.f${fhr}.conus.grib2_2
rm $DATA/hiresw.t${cyc}z.${MODEL}_2p5km.f${fhr}.conus.grib2_3

# reassemble the legacy 5 km output grid

  if test $SENDCOM = 'YES'
  then

cat $DATA/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_conus_1 $DATA/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_conus_2 > $DATA/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.conussbn.grib2

$WGRIB2 $DATA/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.conussbn.grib2 -ncep_uv $COMOUT/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.conussbn.grib2
$WGRIB2 $COMOUT/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.conussbn.grib2 -s > $COMOUT/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.conussbn.grib2.idx

  fi

# rm $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conuseast.grib2_1 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conuseast.grib2_2
# rm $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conuswest.grib2_1 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conuswest.grib2_2

elif [ $NEST = "conusmem2" ]
then

# reassemble the large 5 km output grid

  if test $SENDCOM = 'YES'
  then

cat $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_1 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_2 \
    $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_3 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_4 \
    $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_5 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_6 > \
    $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conusmem2.grib2
 
$WGRIB2 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conusmem2.grib2 -ncep_uv $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conusmem2.grib2
$WGRIB2 $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conusmem2.grib2 -s > $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conusmem2.grib2.idx

### change to use a PARM .txt file, and do for CONUS and AK

cp $PARMhiresw/hiresw_subset.txt .

# $WGRIB2 $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conusmem2.grib2 |  grep -F -f hiresw_subset.txt | \
# $WGRIB2  -i -grib $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conusmem2.subset.grib2  $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conusmem2.grib2 

cat $DATA/hiresw.t${cyc}z.${MODEL}_3km.f${fhr}.conus.grib2_1  > $COMOUT/hiresw.t${cyc}z.${MODEL}_3km.f${fhr}.conusmem2.subset.grib2
$WGRIB2 $COMOUT/hiresw.t${cyc}z.${MODEL}_3km.f${fhr}.conusmem2.subset.grib2 -s > $COMOUT/hiresw.t${cyc}z.${MODEL}_3km.f${fhr}.conusmem2.subset.grib2.idx

    if [ $SENDDBN = YES ]; then
       $SIPHONROOT/bin/dbn_alert MODEL HIRESW_3KM_CONUS       $job $COMOUT/hiresw.t${cyc}z.${MODEL}_3km.f${fhr}.conusmem2.subset.grib2
       $SIPHONROOT/bin/dbn_alert MODEL HIRESW_3KM_CONUS_WIDX  $job $COMOUT/hiresw.t${cyc}z.${MODEL}_3km.f${fhr}.conusmem2.subset.grib2.idx
       $SIPHONROOT/bin/dbn_alert MODEL ${DBN_ALERT_TYPE}      $job $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conusmem2.grib2
       $SIPHONROOT/bin/dbn_alert MODEL ${DBN_ALERT_TYPE_WIDX} $job $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conusmem2.grib2.idx
    fi

  fi # SENDCOM


rm  $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_1 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_2 \
    $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_3 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_4 \
    $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_5 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conus.grib2_6

# reassemble the ndfd output grid

cat $DATA/hiresw.t${cyc}z.${MODEL}_2p5km.f${fhr}.${NEST}.grib2_1  $DATA/hiresw.t${cyc}z.${MODEL}_2p5km.f${fhr}.${NEST}.grib2_2 \
    $DATA/hiresw.t${cyc}z.${MODEL}_2p5km.f${fhr}.${NEST}.grib2_3 > $DATA/hiresw.t${cyc}z.${MODEL}_2p5km.f${fhr}.${NEST}.grib2

rm $DATA/hiresw.t${cyc}z.${MODEL}_2p5km.f${fhr}.${NEST}.grib2_1 
rm $DATA/hiresw.t${cyc}z.${MODEL}_2p5km.f${fhr}.${NEST}.grib2_2
rm $DATA/hiresw.t${cyc}z.${MODEL}_2p5km.f${fhr}.${NEST}.grib2_3

# reassemble the legacy 5 km output grid

  if test $SENDCOM = 'YES'
  then

cat $DATA/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.conusmem2.grib2_conus_1 $DATA/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.conusmem2.grib2_conus_2 > $DATA/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.conusmem2sbn.grib2

$WGRIB2 $DATA/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.conusmem2sbn.grib2 -ncep_uv $COMOUT/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.conusmem2sbn.grib2
$WGRIB2 $COMOUT/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.conusmem2sbn.grib2 -s > $COMOUT/${RUN}.t${cyc}z.${MODEL}_5km.f${fhr}.conusmem2sbn.grib2.idx

  fi

# rm $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conuseast.grib2_1 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conuseast.grib2_2
# rm $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conuswest.grib2_1 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.conuswest.grib2_2

elif [ $NEST = "ak" -o $NEST = "akmem2" ]
then

  if test $SENDCOM = 'YES'
  then

cat $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2_1 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2_2 \
    $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2_3 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2_4 > \
  $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2

$WGRIB2 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2 -ncep_uv $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2
  
rm $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2_1 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2_2 \
   $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2_3 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2_4

$WGRIB2 $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2 -s > $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2.idx

    if [ $SENDDBN = YES ]; then
       $SIPHONROOT/bin/dbn_alert MODEL ${DBN_ALERT_TYPE}      $job $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2
       $SIPHONROOT/bin/dbn_alert MODEL ${DBN_ALERT_TYPE_WIDX} $job $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2.idx
    fi


cp $PARMhiresw/hiresw_subset.txt .

$WGRIB2 $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2 |  grep -F -f hiresw_subset.txt | \
$WGRIB2  -i -grib $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.subset.grib2  $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2 

$WGRIB2 $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.subset.grib2 -s > $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.subset.grib2.idx

  fi

else

  if test $SENDCOM = 'YES'
  then

$WGRIB2 $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2_0 -ncep_uv $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2
$WGRIB2 $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2 -s > $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2.idx

rm $DATA/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2_0

    if [ $SENDDBN = YES ]; then
       $SIPHONROOT/bin/dbn_alert MODEL ${DBN_ALERT_TYPE}      $job $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2
       $SIPHONROOT/bin/dbn_alert MODEL ${DBN_ALERT_TYPE_WIDX} $job $COMOUT/hiresw.t${cyc}z.${MODEL}_5km.f${fhr}.${NEST}.grib2.idx 
    fi
 
  fi

fi

echo "done executing prdgen" > $DATA/prdgendone${fhr}
postmsg  "HIRESW ${NEST}${MODEL} PRDGEN done for F${fhr}"

if [ $fhr -eq 36 -a $SENDECF = YES ]; then
  ecflow_client --event prdgen36_ready
fi

# let fhr=fhr+1
# 
# if [ $fhr -lt 10 ]
# then
# fhr=0$fhr
# fi

# done
