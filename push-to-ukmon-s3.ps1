# powershell script to push files to UKMON's AWS S3 archive 
if ($args.count -lt 2)
{ 
    $yy = get-date -format "yyyy"
    $mm1 = get-date -format "MM"
}
else
{
    $yy=$args[0]
    $mm1=$args[1]
}
$mm=([string]$mm1).padleft(2,'0')

$keyfile='c:\users\mark\videos\astro\meteorcam\scripts\ukmon-key.csv'
$keys=((Get-Content $keyfile)[1]).split(',')

$Env:AWS_ACCESS_KEY_ID = $keys[0]
$env:AWS_SECRET_ACCESS_KEY = $keys[1]

$mthyr="$yy/$yy"+$mm+"/"

$srcdir='c:/users/mark/videos/astro/MeteorCam/NE/'+$mthyr
$destdir= 's3://ukmon-shared/archive/Tackley/c2/'+$mthyr
aws s3 sync $srcdir $destdir --exclude "*T.jpg" --exclude "*.avi" --exclude "*.bmp"

$srcdir='c:/users/mark/videos/astro/MeteorCam/TC/'+$mthyr
$destdir= 's3://ukmon-shared/archive/Tackley/c1/'+$mthyr
aws s3 sync $srcdir $destdir --exclude "*T.jpg" --exclude "*.avi" --exclude "*.bmp"

$srcdir='c:/users/mark/videos/astro/MeteorCam/UK0006/'+$mthyr
$destdir= 's3://ukmon-shared/archive/Tackley/UK0006/'+$mthyr
aws s3 sync $srcdir $destdir --exclude "*.avi" --exclude "*.bz2" 
