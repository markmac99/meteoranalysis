remove-item c:\spectrum\screenshots\tmp\actions.log
$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
$curloc = Get-Location

set-location c:\spectrum\screenshots
Start-Transcript -path tmp\actions.log -append
#set-executionpolicy Unrestricted

Remove-item tmp\runtime.log
add-content -path tmp\runtime.log -value 'copying latest image'

$awssite=get-content 'c:\spectrum\scripts\awssite.txt'

$key='c:\users\astro\.ssh\markskey.pem'
$targ= 'bitnami@'+$awssite+':data/meteors' 
scp -o StrictHostKeyChecking=no -i $key ..\latest2d.jpg $targ

add-content -path tmp\runtime.log -value 'copying last capture'
$fnam=(get-childitem  c:\spectrum\screenshots\event*.jpg | sort-object lastwritetime).name | select-object -last 1
copy-item $fnam  -destination latestcapture.jpg
scp -o StrictHostKeyChecking=no -i $key latestcapture.jpg $targ

add-content -path tmp\runtime.log -value 'updating colorgrammes'

python c:\spectrum\scripts\colorgram.py

add-content -path tmp\runtime.log -value 'copying colorgramme file'
#$mmyyyy=((get-date).tostring("MMyyyy"))
copy-item 'C:\Spectrum\rmob\RMOB_latest.jpg' -destination .
$fnam='RMOB_latest.jpg'
scp -o StrictHostKeyChecking=no -i $key $fnam $targ

copy-item 'C:\Spectrum\rmob\3months_latest.jpg' -destination .
$fnam='3months_latest.jpg'
scp -o StrictHostKeyChecking=no -i $key $fnam $targ

# push CSVs to AWS
$keyfile='c:/spectrum/scripts/ukmon-shared.csv'
$keys=((Get-Content $keyfile)[1]).split(',')
$Env:AWS_ACCESS_KEY_ID = $keys[0]
$env:AWS_SECRET_ACCESS_KEY = $keys[1]
aws s3 sync c:\spectrum\csv\ s3://ukmon-shared/archive/Tackley/Radio/

$msg=get-date
add-content -path tmp\runtime.log -value $msg
set-location $curloc
stop-transcript 