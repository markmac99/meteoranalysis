$logf=  -join("..\logs\robocopy-gmn1-", (get-date -uformat "%Y%m%d-%H%M%S"),".log")

echo "starting" (get-date) 
c:
cd C:\Users\Mark\Videos\Astro\MeteorCam\UK0006
ping -n 1 rpicamera
if ($? -ne "True")  {
    Sleep 30
    ping -n 1 rpicamera
    if ($? -ne "True")  {
        Send-MailMessage -from rpicamera@oservatory -to mark@localhost -subject "rpicamera down" -body "rpicamera seems to be down, check power and network" -smtpserver 192.168.1.151    
        Write-Output "rpicamera seems to be down, check power and network" > $logf
        exit 1
    }
} 
net use \\rpicamera\RMS_share
if ($? -ne "True")  {
    Send-MailMessage -from rpicamera@observatory -to mark@localhost -subject "rpicamera: Unable co connect" -body "unable to connect to rpicamera" -smtpserver 192.168.1.151    
    Add-Content $logf "net-use failed`n"
    exit 2
} 
echo "copying data" 


robocopy \\rpicamera\rms_share\ArchivedFiles ArchivedFiles /dcopy:DAT /tee /v /s /r:3 /log+:$logf

net use \\rpicamera\RMS_share /d
echo "finished" (get-date) 
