#! /bin/ksh
set -x
hr=03
while [ $hr -le 60 ]
do
  hr=$(printf %02i $hr) 
  cp jhiresw_make_bc_f03.ecf jhiresw_make_bc_f${hr}.ecf
  perl -pi -e s/f03/f${hr}/g jhiresw_make_bc_f${hr}.ecf
  perl -pi -e s/fhr=03/fhr=${hr}/g jhiresw_make_bc_f${hr}.ecf
  let "hr=hr+3"
done
