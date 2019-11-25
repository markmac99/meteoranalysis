del c:\spectrum\screenshots\tmp\actions.log
$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"

cd c:\spectrum\screenshots
Start-Transcript -path tmp\actions.log -append
#set-executionpolicy Unrestricted

del tmp\runtime.log
add-content -path tmp\runtime.log -value 'copying latest image'

scp -o StrictHostKeyChecking=no -i c:\users\radiometeor\documents\keys\markskey.pem ..\latest2d.jpg ec2-user@ec2-18-130-54-182.eu-west-2.compute.amazonaws.com:/var/www/html/markmcintyreastro/meteors/radio 

add-content -path tmp\runtime.log -value 'copying last capture'
$fnam=(ls  c:\spectrum\screenshots\*.jpg | sort-object lastwritetime).name | select-object -last 1
copy-item $fnam  -destination .\tmp\latestcapture.jpg
scp -o StrictHostKeyChecking=no -i c:\users\radiometeor\documents\keys\markskey.pem "$fnam" ec2-user@ec2-18-130-54-182.eu-west-2.compute.amazonaws.com:/var/www/html/markmcintyreastro/meteors/radio/latestcapture.jpg 

add-content -path tmp\runtime.log -value 'copying colorgramme file'
$mmyyyy=((get-date).tostring("MMyyyy"))
$fnam='C:\Spectrum\rmob\RMOB_latest.jpg'
copy-item $fnam -destination .\tmp
$fnam='RMOB_latest.jpg'
scp -o StrictHostKeyChecking=no -i c:\users\radiometeor\documents\keys\markskey.pem tmp\$fnam ec2-user@ec2-18-130-54-182.eu-west-2.compute.amazonaws.com:/var/www/html/markmcintyreastro/meteors/radio/ 

add-content -path tmp\runtime.log -value 'executing the script'
ssh -i c:\users\radiometeor\documents\keys\markskey.pem ec2-user@ec2-18-130-54-182.eu-west-2.compute.amazonaws.com /var/www/html/markmcintyreastro/meteors/getdata.sh 

$msg=get-date
add-content -path tmp\runtime.log -value $msg
stop-transcript 