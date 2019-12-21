c:
cd \users\mark\videos\astro\meteorcam\radio
del ..\logs\getradiodata.log
$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"

Start-Transcript -path ..\logs\getradiodata.log -append

$x=(pwd).path
net use \\markslaptop\spectrum /user:radiometeor Radiometeor3
robocopy \\markslaptop\spectrum *.jpg *.dat *.txt  .  /s
net use \\markslaptop\spectrum  /d
net use \\markslaptop\colorgramme /user:radiometeor Radiometeor3
robocopy \\markslaptop\colorgramme\rmob *.* rmob 
robocopy \\markslaptop\colorgramme\img *.* rmob

# create next month's empty RMOB file, if it doesn't already exist
$nexmth=(get-date).adddays(8).tostring("yyyyMM")
$fname = -join("\\markslaptop\spectrum\RMOB-", $nexmth, ".DAT")
if((test-path $fname) -eq $false) { new-item -path $fname }

net use \\markslaptop\colorgramme /d
cd $x

stop-transcript