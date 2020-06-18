c:
set-location \users\mark\videos\astro\meteorcam\radio

$keyfile='C:\Users\mark\Documents\Projects\aws\mark-creds.csv'
$keys=((Get-Content $keyfile)[1]).split(',')
$Env:AWS_ACCESS_KEY_ID = $keys[0]
$env:AWS_SECRET_ACCESS_KEY = $keys[1]

# old instance id was i-05da5c16195647714
$awssite=((aws ec2 describe-instances --instance-ids i-05e6d6b8068e60690) | convertfrom-json).reservations[0].instances[0].publicdnsname

if ($awssite.length -gt 5 )
{
    write-output $awssite > awssite.txt
}

remove-item ..\logs\getradiodata.log
$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"

Start-Transcript -path ..\logs\getradiodata.log -append

write-output "starting...."

#net use \\radiometeor\spectrum /user:meteor Wombat33rm
copy awssite.txt \\astro3\spectrum\scripts
robocopy \\astro3\spectrum *.jpg *.dat eve*.txt  .  /s
#net use \\astro3\spectrum  /d

net use \\astro3\colorgramme /user:meteor Wombat33rm
robocopy \\astro3\colorgramme\rmob *.* rmob 
robocopy \\astro3\colorgramme\img *.* rmob

# create next month's empty RMOB file, if it doesn't already exist
$nexmth=(get-date).adddays(8).tostring("yyyyMM")
$fname = -join("\\astro3\spectrum\RMOB-", $nexmth, ".DAT")
if((test-path $fname) -eq $false) 
{ 
    write-output "creating empty file...."
    new-item -path $fname 
}

#net use \\radiometeor\colorgramme /d

# compress older files to save space
$prvmth = (get-date).addmonths(-2) 
$ccyymm=get-date($prvmth) -uformat('%Y%m')
$yymm=get-date($prvmth) -uformat('%y%m')
$srcs = 'event_log'+$ccyymm+'*.txt'
$archfile = 'event_log'+$ccyymm+'.zip'
get-childitem -path $srcs | compress-archive -destinationpath $archfile -Update
remove-item $srcs
Set-Location screenshots
$srcs = 'event'+$yymm+'*.jpg'
$archfile = 'event'+$ccyymm+'.zip'
get-childitem -path $srcs | compress-archive -destinationpath $archfile -Update
Remove-Item $srcs
Set-Location ..

set-location $PSScriptRoot
write-output "done"

stop-transcript