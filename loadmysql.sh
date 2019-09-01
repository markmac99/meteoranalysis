#!/bin/bash

#curdir=/cygdrive/c/Users/Mark/Videos/Astro/MeteorCam/csv
curdir=/mnt/c/Users/Mark/Videos/Astro/MeteorCam/csv
cd $curdir
pwd

yyyymm=$1
if [ x$yyyymm==x ] ; then yyyymm=`date +%Y%m` ; fi

logfile=../logs/loadmysql-`date +%Y%m%d`.log
echo extracting data for $yyyymm | tee $logfile
perl ../scripts/get-data.pl ${yyyymm} 

echo clearing staging tables... | tee -a $logfile
mysql -umeteor_rw  -pmeteor_rw1 -hthelinux meteors << EOD1
delete  from tmpdata;
delete  from tmpavs;
commit;
exit
EOD1

echo copying to server | tee -a $logfile
scp -i /mnt/c/cygwin/home/mark/.ssh/mark.pem ${yyyymm}.csv mark@thelinux:/tmp/tmpdata.csv >> $logfile
scp -i /mnt/c/cygwin/home/mark/.ssh/mark.pem ${yyyymm}_av.csv mark@thelinux:/tmp/tmpavs.csv >> $logfile

echo loading into MySQL | tee -a $logfile
mysqlimport -d --verbose -C --debug --fields-terminated-by=, -umeteor_rw -pmeteor_rw1 -hthelinux meteors /tmp/tmpavs.csv /tmp/tmpdata.csv >> $logfile


echo copying to main tables... | tee -a $logfile
mysql -umeteor_rw  -pmeteor_rw1 -hthelinux meteors --tee=$logfile << EOD2
insert into meteor_data select * from tmpdata where objectid not in (select objectid from meteor_data);
insert into av_stdevs select * from tmpavs where objectid not in (select objectid from av_stdevs);
commit;
exit
EOD2
echo done | tee -a $logfile

/usr/bin/find ../logs -name "*.log" -mtime +4 -exec rm -f {} \;
