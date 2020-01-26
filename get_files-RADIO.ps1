c:
set-location \users\mark\videos\astro\meteorcam\radio
remove-item ..\logs\getradiodata.log
$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"

Start-Transcript -path ..\logs\getradiodata.log -append

$x=(get-location).path
net use \\radiometeor\spectrum /user:meteor Wombat33rm
robocopy \\radiometeor\spectrum *.jpg *.dat *.txt  .  /s
net use \\radiometeor\spectrum  /d
net use \\radiometeor\colorgramme /user:meteor Wombat33rm
robocopy \\radiometeor\colorgramme\rmob *.* rmob 
robocopy \\radiometeor\colorgramme\img *.* rmob

# create next month's empty RMOB file, if it doesn't already exist
$nexmth=(get-date).adddays(8).tostring("yyyyMM")
$fname = -join("\\radiometeor\spectrum\RMOB-", $nexmth, ".DAT")
if((test-path $fname) -eq $false) 
{ 
    new-item -path $fname 
}

net use \\radiometeor\colorgramme /d
set-location $PSScriptRoot

stop-transcript