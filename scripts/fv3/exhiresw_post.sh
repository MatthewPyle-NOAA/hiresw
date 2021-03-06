#!/bin/ksh
############################################################################
# Script name:		exfv3cam_post.sh
# Script description:	Run the post processor jobs to create grib2 output.
# Script history log:
#   1) 2018-08-20	Eric Aligo / Hui-Ya Chuang
#                       Created script to post process output 
#                       from the SAR-FV3.
#   2) 2018-08-23	Ben Blake
#                       Adapted script into EE2-compliant Rocoto workflow.
#   3) 2019-11-06       Matthew Pyle
#                       Establishing an "odd/even" post script in case NCO wants it like
#                       current HiresW
############################################################################
set -x

# fhr=00
fhrend=60
# INCR=02

MODEL=fv3


# see if any postdone files exist, and if so, which is last hour completed


if [ -e ../postdone${fhr} ]
then
 echo "The FV3 Post appears to have already run for fhr $fhr"
 ls -l ../postdone${fhr}
 exit 0
fi

echo STARTING POST with fhr $fhr


# while [ $fhr -le $fhrend ]
# do

looplim=45
loop=1

while [ $loop -le $looplim ]
do
 echo in while
 if [ -s $INPUT_DATA/logf0${fhr} ]
 then
   break
 else
   loop=$((loop+1))
   sleep 20
 fi
 if [ $loop -ge $looplim ]
   then
   msg="FATAL ERROR: ABORTING after 15 minutes of waiting for $INPUT_DATA/logf0${fhr}"
   err_exit $msg
 fi
done


if [ $tmmark = tm00 ] ; then
  export NEWDATE=`${NDATE} +${fhr} $CDATE`
else
  offset=`echo $tmmark | cut -c 3-4`
  export vlddate=`${NDATE} -${offset} $CDATE`
  export NEWDATE=`${NDATE} +${fhr} $vlddate`
fi
export YYYY=`echo $NEWDATE | cut -c1-4`
export MM=`echo $NEWDATE | cut -c5-6`
export DD=`echo $NEWDATE | cut -c7-8`
export HH=`echo $NEWDATE | cut -c9-10`

cat > itag <<EOF
${INPUT_DATA}/dynf0${fhr}.nc
netcdf
grib2
${YYYY}-${MM}-${DD}_${HH}:00:00
FV3R
${INPUT_DATA}/phyf0${fhr}.nc

 &NAMPGB
 KPO=47,PO=1000.,975.,950.,925.,900.,875.,850.,825.,800.,775.,750.,725.,700.,675.,650.,625.,600.,575.,550.,525.,500.,475.,450.,425.,400.,375.,350.,325.,300.,275.,250.,225.,200.,175.,150.,125.,100.,70.,50.,30.,20.,10.,7.,5.,3.,2.,1.,
 /
EOF

rm -f fort.*

# copy flat files
cp ${PARMfv3}/nam_micro_lookup.dat      ./eta_micro_lookup.dat

if [ $fhr -eq 00 ] ; then
cp ${PARMfv3}/postxconfig-NT-fv3sar_f00.txt ./postxconfig-NT.txt
elif [ $fhr -eq 01 ] ; then
cp ${PARMfv3}/postxconfig-NT-fv3sar_f01.txt ./postxconfig-NT.txt
else
cp ${PARMfv3}/postxconfig-NT-fv3sar.txt     ./postxconfig-NT.txt
fi

cp ${PARMfv3}/params_grib2_tbl_new      ./params_grib2_tbl_new

# Run the post processor
export pgm=hireswfv3_post
. prep_step

startmsg
${APRUNC} ${POSTGPEXEC} < itag > $pgmout 2> err
export err=$?; err_chk

if [ $err -eq 0 ]
then
# move output to main post run directory
mv BGDAWP${fhr}.tm00  ../
cd ../
fi

# only do this processing on even numbered hours

if [ $fhr -gt 0 -a $fhr%2 -eq 0 ]
then

## compute snow by differencing WEASD on native grid

if [ $NEST = "conus" ]
then
 dim1=2001
 dim2=1201
elif [ $NEST = "ak" ]
then
 dim1=1441
 dim2=1185
elif [ $NEST = "hi" ]
then
 dim1=433
 dim2=345
elif [ $NEST = "pr" ]
then
 dim1=625
 dim2=416
elif [ $NEST = "guam" ]
then
 dim1=449
 dim2=385
fi

fhrold=`expr $fhr - 1`
fhrold2=`expr $fhr - 2`
fhrold3=`expr $fhr - 3`
fhrold4=`expr $fhr - 4`

if [ $fhr%3 -eq 0 ]
then
  do_3=1
else
  do_3=0
fi


if [ $fhrold -lt 10 ]
then
fhrold=0$fhrold
fi

if [ $fhrold2 -ge 0 -a $fhrold2 -lt 10 ]
then
fhrold2=0$fhrold2
fi

if [ $fhrold3 -ge 0 -a $fhrold3 -lt 10 ]
then
fhrold3=0$fhrold3
fi

if [ $fhrold4 -ge 0 -a $fhrold4 -lt 10 ]
then
fhrold4=0$fhrold4
fi

curpath=`pwd`
altpath=`pwd`

echo curpath $curpath
echo altpath $altpath

echo working fhr $fhr


# make sure fhrold is available

looplim=45
loop=1
while [ $loop -le $looplim ]
do
 echo in while
 if [ -s $altpath/temp.t${cyc}z.f${fhrold}.grib2 ]
 then
   break
 else
   loop=$((loop+1))
   sleep 20
 fi
 if [ $loop -ge $looplim ]
   then
   msg="FATAL ERROR: ABORTING after 15 minutes of waiting for temp.t${cyc}z.f${fhrold}.grib2"
   err_exit $msg
 fi
done

echo $curpath > input.${fhr}
echo "temp.t${cyc}z.f" >> input.${fhr}
echo $fhrold >> input.${fhr}
echo $fhr >> input.${fhr}
echo 0 >> input.${fhr}
echo "$dim1 $dim2" >> input.${fhr}

# ln -sf BGDAWP${fhr}.tm00 temp.t${cyc}z.f${fhr}.grib2
# even hour file
$WGRIB2 BGDAWP${fhr}.tm00 -match ":(APCP|WEASD):"  -grib  temp.t${cyc}z.f${fhr}.grib2

looplim=45
loop=1
while [ $loop -le $looplim ]
do
 echo in while
 if [ -s $altpath/BGDAWP${fhrold}.tm00 ]
 then
   break
 else
   loop=$((loop+1))
   sleep 20
 fi
 if [ $loop -ge $looplim ]
   then
   msg="FATAL ERROR: ABORTING after 15 minutes of waiting for $altpath/BGDAWP${fhrold}.tm00"
   err_exit $msg
 fi
done

# odd hour file
# ln -sf $altpath/BGDAWP${fhrold}.tm00  temp.t${cyc}z.f${fhrold}.grib2
$WGRIB2  $altpath/BGDAWP${fhrold}.tm00  -match ":(APCP|WEASD):"  -grib  temp.t${cyc}z.f${fhrold}.grib2

filecheck=BGDAWP${fhr}.tm00

# 1 h added to even time file
if [ -e $filecheck ]
then
$EXECfv3/hireswfv3_fv3snowbucket < input.${fhr}
export err=$?; err_chk
cat ./PCP1HR${fhr}.tm00 >> $filecheck
fi

# attempt to make a 3 h WEASD field

if [ $fhr%3 -eq 0 ]
then

looplim=45
loop=1
while [ $loop -le $looplim ]
do
 echo in while
 if [ -s $altpath/temp.t${cyc}z.f${fhrold3}.grib2 ]
 then
   break
 else
   loop=$((loop+1))
   sleep 20
 fi
 if [ $loop -ge $looplim ]
   then
   msg="FATAL ERROR: ABORTING after 15 minutes of waiting for temp.t${cyc}z.f${fhrold3}.grib2"
   err_exit $msg
 fi
done

echo $curpath > input.${fhr}
echo "temp.t${cyc}z.f" >> input.${fhr}
echo $fhrold3 >> input.${fhr}
echo $fhr >> input.${fhr}
echo 0 >> input.${fhr}
echo "$dim1 $dim2" >> input.${fhr}

# 3 h added to even time file
if [ -e $filecheck ]
then
$EXECfv3/hireswfv3_fv3snowbucket < input.${fhr}
export err=$?; err_chk
cat ./PCP3HR${fhr}.tm00 >> $filecheck
fi


## do 3 h QPF from hireswfv3_bucket

  echo "${curpath}" > input.card.${fhr}
  echo "temp.t${cyc}z.f" >> input.card.${fhr}
  echo $fhrold3 >> input.card.${fhr}
  echo $fhr >> input.card.${fhr}
  echo 0 >> input.card.${fhr}
  echo "$dim1 $dim2" >> input.card.${fhr}

if [ -e $filecheck ]
then
 mv PCP3HR${fhr}.tm00 PCP3HR${fhr}.tm00_snow
 $EXECfv3/hireswfv3_bucket < input.card.${fhr}
 export err=$?; err_chk
 cat ./PCP3HR${fhr}.tm00 >> $filecheck
 cp PCP3HR${fhr}.tm00 PCP3HR${fhr}.tm00_qpf
fi


fi # 3 h time


# do the "odd" hour since have the needed temp.* files in place in cwd

if [ $fhr -gt 0 -a $fhr%2 -eq 0 ]
then

echo fhrold2 $fhrold2
echo fhrold $fhrold

ls -l temp.t${cyc}z.f${fhrold2}*
ls -l temp.t${cyc}z.f${fhrold}*

looplim=45
loop=1
while [ $loop -le $looplim ]
do
 echo in while
 if [ -s $altpath/temp.t${cyc}z.f${fhrold2}.grib2 ]
 then
   break
 else
   loop=$((loop+1))
   sleep 20
 fi
 if [ $loop -ge $looplim ]
   then
   msg="FATAL ERROR: ABORTING after 15 minutes of waiting for temp.t${cyc}z.f${fhrold2}.grib2"
   err_exit $msg
 fi
done

echo $curpath > input.${fhr}
echo "temp.t${cyc}z.f" >> input.${fhr}
echo $fhrold2 >> input.${fhr}
echo $fhrold >> input.${fhr}
echo 0 >> input.${fhr}
echo "$dim1 $dim2" >> input.${fhr}

$EXECfv3/hireswfv3_fv3snowbucket < input.${fhr}
export err=$?; err_chk

# 1 h added to odd time file
if [ -e $altpath/BGDAWP${fhrold}.tm00 ]
then
$EXECfv3/hireswfv3_fv3snowbucket < input.${fhr}
export err=$?; err_chk
cat ./PCP1HR${fhrold}.tm00 >> $altpath/BGDAWP${fhrold}.tm00
fi

if [ $fhrold%3 -eq 0 ]
then
# attempt to make a 3 h WEASD field

looplim=45
loop=1
while [ $loop -le $looplim ]
do
 echo in while
 if [ -s $altpath/temp.t${cyc}z.f${fhrold4}.grib2 ]
 then
   break
 else
   loop=$((loop+1))
   sleep 20
 fi
 if [ $loop -ge $looplim ]
   then
   msg="FATAL ERROR: ABORTING after 15 minutes of waiting for temp.t${cyc}z.f${fhrold4}.grib2"
   err_exit $msg
 fi
done

echo $curpath > input.${fhr}
echo "temp.t${cyc}z.f" >> input.${fhr}
echo $fhrold4 >> input.${fhr}
echo $fhrold >> input.${fhr}
echo 0 >> input.${fhr}
echo "$dim1 $dim2" >> input.${fhr}

# 3 h added to odd time file
if [ -e $altpath/BGDAWP${fhrold}.tm00  ]
then
$EXECfv3/hireswfv3_fv3snowbucket < input.${fhr}
export err=$?; err_chk
cat ./PCP3HR${fhrold}.tm00 >>  $altpath/BGDAWP${fhrold}.tm00
fi

## do 3 h QPF from hireswfv3_bucket


  echo "${curpath}" > input.card.${fhr}
  echo "temp.t${cyc}z.f" >> input.card.${fhr}
  echo $fhrold4 >> input.card.${fhr}
  echo $fhrold >> input.card.${fhr}

if [ $fhrold = '03' ]
then
# just take later period if f03
  echo 1 >> input.card.${fhr}
else
  echo 0 >> input.card.${fhr}
fi
  echo "$dim1 $dim2" >> input.card.${fhr}

if [ -e $altpath/BGDAWP${fhrold}.tm00  ]
then
 mv PCP3HR${fhrold}.tm00 PCP3HR${fhrold}.tm00_snow

 $EXECfv3/hireswfv3_bucket < input.card.${fhr}
 export err=$?; err_chk

if [ $fhrold = '03' ]
then
 echo " will not duplicate the 3 h total at f03 "
else
 cat ./PCP3HR${fhrold}.tm00 >> $altpath/BGDAWP${fhrold}.tm00
fi
 cp PCP3HR${fhrold}.tm00 PCP3HR${fhrold}.tm00_qpf
fi

fi

else

# special case for f01

echo $curpath > input.${fhr}
echo "temp.t${cyc}z.f" >> input.${fhr}
echo 00 >> input.${fhr}
echo 01 >> input.${fhr}
echo 0 >> input.${fhr}
echo "$dim1 $dim2" >> input.${fhr}

$EXECfv3/hireswfv3_fv3snowbucket < input.${fhr}
export err=$?; err_chk

# 1 h added to f01
if [ -e $altpath/BGDAWP01.tm00 ]
then
$EXECfv3/hireswfv3_fv3snowbucket < input.${fhr}
export err=$?; err_chk
cat ./PCP1HR01.tm00 >> $altpath/BGDAWP01.tm00
echo done > $altpath/postdone01
fi

fi

else

echo executing this one more block for fhr $fhr

ls -l temp.t${cyc}z.f${fhr}.grib2

# one more
# ln -sf BGDAWP${fhr}.tm00 temp.t${cyc}z.f${fhr}.grib2
$WGRIB2  BGDAWP${fhr}.tm00  -match ":(APCP|WEASD):"  -grib  temp.t${cyc}z.f${fhr}.grib2


echo "after the one more"

ls -l temp.t${cyc}z.f${fhr}.grib2

fi

if [ $fhr -gt 0 -a $fhr%2 -eq 0 ]
then
 echo done > postdone${fhr}
 echo done > postdone${fhrold}
elif [ $fhr -eq 0 ]
then
 echo done > postdone${fhr}
fi

# fhr=`expr $fhr + $INCR`

# if [ $fhr -lt 10 ]
# then
# fhr=0$fhr
# fi

# done

echo EXITING $0

exit
