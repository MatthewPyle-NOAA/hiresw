#! /bin/sh

cyc=12
date=20210824

doms="conus hi guam"
# doms="ak pr"

for dom in $doms
do
	./launch_make_bc.sh ${dom} fv3 ${cyc} ${date}
	./launch_make_ic.sh ${dom} fv3 ${cyc} ${date}
done
	sleep 620
for dom in $doms
do

	echo submitting model for ${dom} ${cyc}
	./launch_model.sh ${dom} fv3 ${cyc} ${date}
done

	sleep 90

for dom in $doms
do
	echo submitting post for ${dom} ${cyc}
	./launch_post.sh ${dom} fv3 ${cyc} ${date}
	./launch_prdgen.sh ${dom} fv3 ${cyc} ${date}
	./launch_wrfbufrsnd.sh ${dom} fv3 ${cyc} ${date}
done
	sleep 90
for dom in $doms
do
	echo submitting smartinit_awips_gempak for ${dom} ${cyc}
	./launch_smartinit.sh ${dom} fv3 ${cyc} ${date}
	./launch_smartinitb.sh ${dom} fv3 ${cyc} ${date}
	./launch_awips.sh ${dom} fv3 ${cyc} ${date}
	./launch_gempak.sh ${dom} fv3 ${cyc} ${date}
done

