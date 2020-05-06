Write-Output "starting" (get-date) 
c:
$curdir=get-location
Set-Location C:\Users\Mark\Videos\Astro\MeteorCam\ne
$logf=  -join("..\logs\robocopy-ne-", (get-date -uformat "%Y%m%d-%H%M%S"),".log")
Write-Output "starting" (get-date) 

$loopctr=0
ping -n 1 astromini
while (($? -ne "True") -and ($loopctr -lt 10))  {
    Start-Sleep 30
    ping -n 1 astromini
    $loopctr++
}
if ($loopctr -eq 10)  {
    Send-MailMessage -from astromini@oservatory -to mark@localhost -subject "astromini down" -body "astromini seems to be down, check power and network" -smtpserver 192.168.1.151    
    Write-Output "Astromini seems to be down, check power and network" > $logf
    exit 1
}

$tod=((get-date).tostring("yyyy\\yyyyMM"))
$ytd=((get-date).adddays(-1).tostring("yyyy\\yyyyMM"))
$exists= test-path $tod
if ($exists -eq $false) {
    mkdir $tod
}
$exists= test-path $ytd
if ($exists -eq $false) {
    mkdir $ytd
}
dir \\astromini\data
if ($? -eq $false ){
    net use \\astromini\data /user:dataxfer Wombat33dx   
}

Write-Output "copying data for $tod" 
robocopy \\astromini\\data\meteorcam2\$tod $tod *.jpg *.bmp *.txt *.xml M*.avi /dcopy:DAT /tee /m /v /s /r:3 /log+:$logf /mov
if ($tod -ne $ytd) {
    Write-Output "copying data for $ytd"
    robocopy \\astromini\\data\meteorcam2\$ytd $ytd *.jpg *.bmp *.txt *.xml M*.avi /dcopy:DAT /tee /m /v /s /r:3 /log+:$logf /mov
}
Set-Location $curdir
Write-Output "finished" (get-date) 
exit 0
