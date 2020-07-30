c:
set-location \users\mark\videos\astro\meteorcam\radio
$logf=  -join("..\logs\getradiodata-", (get-date -uformat "%Y%m%d-%H%M%S"),".log")
write-output "starting...." >> $logf

$keyfile='C:\Users\mark\Documents\Projects\aws\mark-creds.csv'
$keys=((Get-Content $keyfile)[1]).split(',')
$Env:AWS_ACCESS_KEY_ID = $keys[0]
$env:AWS_SECRET_ACCESS_KEY = $keys[1]

# old instance id was i-05da5c16195647714
write-output "getting AWS details..." >> $logf
$awssite=((aws ec2 describe-instances --instance-ids i-05e6d6b8068e60690) | convertfrom-json).reservations[0].instances[0].publicdnsname

if ($awssite.length -gt 5 )
{
    write-output $awssite > awssite.txt
}

write-output "copying files" >> $logf

net use \\astro3\spectrum /user:dataxfer Wombat33dx   
if ($? -ne "True")  {
    Send-MailMessage -from radio@observatory -to mark@localhost -subject "Radio: Unable co connect" -body "unable to connect to radio detector" -smtpserver 192.168.1.151    
    Add-Content $logf "net-use failed`n"
    exit 2
} 

robocopy awssite.txt \\astro3\spectrum\scripts /dcopy:DAT /tee /m /v /s /r:3  >> $logf
robocopy \\astro3\spectrum *.jpg *.dat eve*.txt *.csv *.zip  .  /dcopy:DAT /tee /m /v /s /r:3 >> $logf

# create next month's empty RMOB file, if it doesn't already exist
$nexmth=(get-date).adddays(8).tostring("yyyyMM")
$fname = -join("\\astro3\spectrum\RMOB-", $nexmth, ".DAT")
if((test-path $fname) -eq $false) 
{ 
    write-output "creating empty file...." >> $logf
    new-item -path $fname 
}
net use \\astro3\spectrum  /d

write-output "archiving old data" >> $logf

# delete older files to save space
$prvmth = (get-date).addmonths(-2) 
$ccyymm=get-date($prvmth) -uformat('%Y%m')
$yymm=get-date($prvmth) -uformat('%y%m')
$srcs = 'event_log'+$ccyymm+'*.txt'
$archfile = 'event_log'+$ccyymm+'.zip'
get-childitem -path $srcs | compress-archive -destinationpath $archfile -Update
remove-item $srcs
Set-Location screenshots
$srcs = 'event'+$yymm+'*.jpg'
$archfile = 'event'+$yymm+'.zip'
get-childitem -path $srcs | compress-archive -destinationpath $archfile -Update
Remove-Item $srcs
Set-Location ..

set-location $PSScriptRoot
write-output "done" >> $logf

