#! /bin/ksh
set -x
hr=01
while [ $hr -le 60 ]
do
  hr=$(printf %02i $hr) 
  cp jhiresw_post_f00.ecf jhiresw_post_f${hr}.ecf
  perl -pi -e s/f00/f${hr}/g jhiresw_post_f${hr}.ecf
  perl -pi -e s/fhr=00/fhr=${hr}/g jhiresw_post_f${hr}.ecf
  let "hr=hr+1"
done
