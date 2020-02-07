# python testing
import os.path
from fnmatch import fnmatch

def processfile(fname):
    x=fname.find('M20')
    yr=fname[x+1:x+5]

    outf='c:/temp/M' + yr + '-unified.csv'

    linelist = [line.rstrip('\n') for line in open(fname,'r')]

    if os.path.isfile(outf) :
        print('appending to existing file')
        uniflist = [line.rstrip('\n') for line in open(outf,'r')]
        newlist = uniflist[0:1] + sorted(set(uniflist[1:] + linelist[1:]))
    else:
        print('creating new file')
        newlist = linelist

    with open (outf, 'w') as fout:
        fout.write('\n'.join(newlist))

dirname = 'C:/users/mark/videos/astro/MeteorCam/TC'
pattern='M*.csv'
for (dirpath, dirnames, filenames) in os.walk(dirname):
    for name in filenames:
        if fnmatch(name, pattern):
            print(os.path.join(dirpath, name))
            processfile(os.path.join(dirpath, name))

#fname1='C:/users/mark/videos/astro/MeteorCam/TC/2019/201911/M20191103_18_028_TACKLEY_TC.csv'
#fname2='C:/users/mark/videos/astro/MeteorCam/TC/2019/201912/M20191201_19_028_TACKLEY_TC.csv' 
#processfile(fname1)
#processfile(fname2)

#with open ('c:/temp/header.txt','w') as fout:
#    fout.write(linelist[0])


#var bucketName = process.env.bucketName;
#var keyName = getKeyName(folder, filename);
#var content = 'This is a sample text file';# var params = { Bucket: bucketName, Key: keyName, Body: content };
#s3.putObject(params, function (err, data)  {
#    if (err)
#        console.log(err)
#    else
#        console.log("Successfully saved object to " + bucketName + "/" + keyName);
#    })
#    }