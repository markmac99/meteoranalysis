# script to get CSV files from UFO Archive

$oldkey = $Env:AWS_ACCESS_KEY_ID
$oldsec = $env:AWS_SECRET_ACCESS_KEY

$keyfile='C:\Users\mark\Documents\Projects\aws\ukmon-shared.csv'
$keys=((Get-Content $keyfile)[1]).split(',')
$Env:AWS_ACCESS_KEY_ID = $keys[0]
$env:AWS_SECRET_ACCESS_KEY = $keys[1]

aws s3 sync s3://ukmon-shared/archive/ c:/users/mark/videos/astro/MeteorCam/archive-full/ --exclude "*" --include "*.csv" --exclude "*detlog.csv"
aws s3 sync s3://ukmon-shared/consolidated c:/users/mark/videos/astro/MeteorCam/archive/ --exclude "*" --include "*.csv" --exclude "*temp*"

$Env:AWS_ACCESS_KEY_ID = $oldkey
$env:AWS_SECRET_ACCESS_KEY = $oldsec
