echo "starting" (get-date) 
c:
cd C:\Users\Mark\Videos\Astro\MeteorCam\TC

$logf=  -join("..\logs\robocopy-tc-", (get-date -uformat "%Y%m%d-%H%M%S"),".log")

ping -n 1 astro2
if ($? -ne "True")  {
    Sleep 30
    ping -n 1 astro2
    if ($? -ne "True")  {
        Send-MailMessage -from astro2@oservatory -to mark@localhost -subject "astro2 down" -body "astro2 seems to be down, check power and network" -smtpserver 192.168.1.151    
        Write-Output "Astro2 seems to be down, check power and network" > $logf
        exit 1
    }
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
net use \\astro2\meteorcamdata /user:meteorcam Wombat33mc
if ($? -ne "True")  {
    Send-MailMessage -from astro2@observatory -to mark@localhost -subject "Astro2: Unable co connect" -body "unable to connect to astro2" -smtpserver 192.168.1.151    
    Add-Content $logf "net-use failed`n"
    exit 2
} 
echo "copying TC data for $tod" 
robocopy \\astro2\meteorcamdata\tc\$tod $tod *.jpg *.bmp *.txt *.xml M*.avi /dcopy:DAT /m /tee /v /s /r:3 /log+:$logf
if ($tod -ne $ytd) {
    echo "copying TC data for $yyd"
    robocopy \\astro2\meteorcamdata\tc\$ytd $ytd *.jpg *.bmp *.txt *.xml M*.avi /dcopy:DAT /tee /m /v /s /r:3 /log+: $logf
}
cd ..\NE
echo "copying NE data for $tod" 
robocopy \\astro2\meteorcamdata\ne\$tod $tod *.jpg *.bmp *.txt *.xml M*.avi /dcopy:DAT /m /tee /v /s /r:3 /log+:$logf
if ($tod -ne $ytd) {
    echo "copying NE data for $yyd"
    robocopy \\astro2\meteorcamdata\ne\$ytd $ytd *.jpg *.bmp *.txt *.xml M*.avi /dcopy:DAT /tee /m /v /s /r:3 /log+: $logf
}
net use \\astro2\meteorcamdata /d
echo "finished" (get-date) 
Get-ChildItem –Path  "..\Logs" –Recurse -include *.log | Where-Object { $_.CreationTime –lt (Get-Date).AddDays(-30) } | Remove-Item
exit 0
