# script to get CSV files from UFO Archive

$keyfile='c:\users\mark\videos\astro\meteorcam\scripts\ukmon-key.csv'
$keys=((Get-Content $keyfile)[1]).split(',')

$Env:AWS_ACCESS_KEY_ID = $keys[0]
$env:AWS_SECRET_ACCESS_KEY = $keys[1]

aws s3 sync --dryrun s3://ukmon-shared/archive/ c:/users/mark/videos/astro/MeteorCam/archive/ --exclude "*" --include "*.csv"

