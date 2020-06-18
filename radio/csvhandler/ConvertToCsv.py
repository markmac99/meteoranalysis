# python programme to convert Radio log files into UFO-like format

 # 
 # start of main function
 #   
from datetime import date
import calendar
import csv
import os
import sys

interval = 100 # millisecs between loops in Colorlab
id = 'TACKLEY'
lat=51.8831
lng=-1.30616
alt=80
tz=0

def doafile (yr, mt, dy, srcpath, targpath):
    print('processing ' + yr+mt+dy)
    #dt = "{:4d}{:02d}{:02d}".format(yr,mt,dy)
    dt = yr+mt+dy

    srcfile = srcpath + 'event_log' +dt + '.txt'
    targfile=targpath +yr+'/'+yr+mt+'/R'+yr+mt+dy+'_'+id + '.csv'
    try:
        os.makedirs(targpath + yr +'/'+yr+mt)
    except:
        print('dir exists')

    outf = open(targfile,'w+') 

    with open(srcfile) as inf:
        outf.write('Ver,Y,M,D,h,m,s,Bri,Dur,freq,ID,Long,Lat,Alt,Tz\n')
        mydata = csv.reader(inf, delimiter=',')
        for row in mydata:
            tstamp=row[0]
            hr=tstamp[0:2]
            mi=tstamp[3:5]
            se=tstamp[6:9]
            bri=round(float(row[2])-float(row[3]),2)
            freq=row[4]
            dur=int(row[5])*interval
            s ="RMOB,{:s},{:s},{:s},{:s},{:s},{:s},".format(yr,mt,dy,hr,mi,se)
            s = s+ "{:f},{:d},{:s},".format(bri,dur,freq)
            s = s + "{:s},{:f},{:f},{:f},{:d}\n".format(id, lng,lat,alt,tz)
            outf.write(s)
    inf.close
    outf.close
    return 0

def main():
    # beginning of main function
    yr=sys.argv[1] #'2020'
    mt=sys.argv[2] #'02'
    dy=sys.argv[3] #'10'
    doafile(yr, mt, dy, 'c:/spectrum', 'c:/spectrum/csv/')

if __name__ == '__main__':
        main()