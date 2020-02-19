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

net use \\radiometeor\spectrum /user:meteor Wombat33rm
copy awssite.txt \\radiometeor\spectrum\scripts
robocopy \\radiometeor\spectrum *.jpg *.dat eve*.txt  .  /s
net use \\radiometeor\spectrum  /d
net use \\radiometeor\colorgramme /user:meteor Wombat33rm
robocopy \\radiometeor\colorgramme\rmob *.* rmob 
robocopy \\radiometeor\colorgramme\img *.* rmob

# create next month's empty RMOB file, if it doesn't already exist
$nexmth=(get-date).adddays(8).tostring("yyyyMM")
$fname = -join("\\radiometeor\spectrum\RMOB-", $nexmth, ".DAT")
if((test-path $fname) -eq $false) 
{ 
    write-output "creating empty file...."
    new-item -path $fname 
}

net use \\radiometeor\colorgramme /d
set-location $PSScriptRoot
write-output "done"

stop-transcript