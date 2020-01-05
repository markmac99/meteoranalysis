# powershell script to push files to UKMON's AWS S3 archive 

$keyfile='c:\users\mark\videos\astro\meteorcam\scripts\ukmon-key.csv'
$keys=((Get-Content $keyfile)[1]).split(',')

$Env:AWS_ACCESS_KEY_ID = $keys[0]
$env:AWS_SECRET_ACCESS_KEY = $keys[1]

$mthyr='2020/202001/'

$srcdir='c:/users/mark/videos/astro/MeteorCam/NE/'+$mthyr
$destdir= 's3://ukmon-shared/archive/Tackley/c2/'+$mthyr
aws s3 cp --recursive $srcdir $destdir --exclude "*T.jpg" --exclude "*.avi" --exclude "*.bmp"

$srcdir='c:/users/mark/videos/astro/MeteorCam/TC/'+$mthyr
$destdir= 's3://ukmon-shared/archive/Tackley/c1/'+$mthyr
aws s3 cp --recursive $srcdir $destdir --exclude "*T.jpg" --exclude "*.avi" --exclude "*.bmp"

$srcdir='c:/users/mark/videos/astro/MeteorCam/UK0006/'+$mthyr
$destdir= 's3://ukmon-shared/archive/Tackley/UK0006/'+$mthyr
aws s3 cp --recursive $srcdir $destdir --exclude "*.avi" --exclude "*.bz2" 
