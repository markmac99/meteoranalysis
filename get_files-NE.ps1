echo "starting" (get-date) 
c:
cd C:\Users\Mark\Videos\Astro\MeteorCam\ne
$logf=  -join("..\logs\robocopy-ne-", (get-date -uformat "%Y%m%d-%H%M%S"),".log")
echo "starting" (get-date) 

$loopctr=0
ping -n 1 astromini
while (($? -ne "True") -and ($loopctr -lt 10))  {
    Sleep 30
    ping -n 1 astromini
    $loopctr++
}
if ($loopctr -eq 10)  {
    Send-MailMessage -from astromini@oservatory -to mark@localhost -subject "astromini down" -body "astromini seems to be down, check power and network" -smtpserver 192.168.1.151    
    Write-Output "Astromini seems to be down, check power and network" > $logf
    exit 1
}

set tod ((get-date).tostring("yyyy\\yyyyMM"))
set ytd ((get-date).adddays(-1).tostring("yyyy\\yyyyMM"))
$exists= test-path $tod
if ($exists -eq $false) {
    mkdir $tod
}
$exists= test-path $ytd
if ($exists -eq $false) {
    mkdir $ytd
}
net use \\astromini\data /user:astromini Wombat33
if ($? -ne "True")  {
    Send-MailMessage -from astromini@observatory -to mark@localhost -subject "Astromini: Unable co connect" -body "unable to connect to astromini" -smtpserver 192.168.1.151    
    Add-Content $logf "net-use failed`n"
    exit 2
} 
echo "copying data for $tod" 
robocopy \\astromini\\data\meteorcam2\$tod $tod *.jpg *.bmp *.txt *.xml M*.avi /dcopy:DAT /tee /m /v /s /r:3 /log+:$logf
if ($tod -ne $ytd) {
    echo "copying data for $yyd"
    robocopy \\astromini\\data\meteorcam2\$ytd $ytd *.jpg *.bmp *.txt *.xml M*.avi /dcopy:DAT /tee /m /v /s /r:3 /log+:$logf
}
net use \\astromini\data /d
cd C:\Users\Mark\Videos\Astro\MeteorCam\scripts
echo "finished" (get-date) 
exit 0
