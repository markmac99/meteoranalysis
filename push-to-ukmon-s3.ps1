# powershell script to push files to UKMON's AWS S3 archive 

$Env:AWS_ACCESS_KEY_ID = 'AKIA36ZZGKDHZYMLPKOH'
$env:AWS_SECRET_ACCESS_KEY = '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'

$srcdir='c:/users/mark/videos/astro/MeteorCam/NE/2020/202001/'
$destdir= 's3://ukmon-shared/archive/Tackley/c2/2020/202001/'
aws s3 cp --recursive $srcdir $destdir --exclude "*T.jpg" --exclude "*.avi" --exclude "*.bmp"

$srcdir='c:/users/mark/videos/astro/MeteorCam/TC/2020/202001/'
$destdir= 's3://ukmon-shared/archive/Tackley/c1/2020/202001/'
aws s3 cp --recursive $srcdir $destdir --exclude "*T.jpg" --exclude "*.avi" --exclude "*.bmp"
