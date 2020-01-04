$logf=  -join("..\logs\robocopy-gmn1-", (get-date -uformat "%Y%m%d-%H%M%S"),".log")

Write-Output "starting" (get-date) 
c:
set-location C:\Users\Mark\Videos\Astro\MeteorCam\UK0006

$loopctr=0
ping -n 1 meteorpi
while (($? -ne "True") -and ($loopctr -lt 10))  {
    Sleep 30
    ping -n 1 meteorpi
    $loopctr++
}
if ($loopctr -eq 10)  {
    Send-MailMessage -from meteorpi@oservatory -to mark@localhost -subject "pi camera down" -body "rpicamera seems to be down, check power and network" -smtpserver 192.168.1.151    
    Write-Output "pi camera seems to be down, check power and network" > $logf
    exit 1
}

$pidown='c:\temp\pidown'
$chk=test-connection -quiet picamera
if ($chk -ne "True")  
{
    Start-Sleep 30
    $chk=test-connection -quiet picamera
    if ($chk -ne "True")  {
        if (![System.IO.File]::Exists($pidown))
        {
            Send-MailMessage -from rpicamera@oservatory -to mark@localhost -subject "camera down" -body "camera seems to be down, check power and network" -smtpserver 192.168.1.151    
            Write-Output "camera down" > $pidown
        }
        Write-Output "Pi camera seems to be down, check power and network" > $logf
        exit 1
    }
} 
if ([System.IO.File]::Exists($pidown))
{
    remove-item $pidown
}
net use \\meteorpi\RMS_share
if ($? -ne "True")  {
    Send-MailMessage -from rpicamera@observatory -to mark@localhost -subject "rpicamera: Unable co connect" -body "unable to connect to rpicamera" -smtpserver 192.168.1.151    
    Add-Content $logf "net-use failed`n"
    exit 2
} 
Write-Output "copying data" 


robocopy \\meteorpi\rms_share\ArchivedFiles ArchivedFiles /dcopy:DAT /tee /v /s /r:3 /log+:$logf

net use \\meteorpi\RMS_share /d
Write-Output "finished" (get-date) 
