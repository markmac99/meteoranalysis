$logf=  -join("c:\users\mark\videos\astro\meteorcam\logs\robocopy-meteorpi-", (get-date -uformat "%Y%m%d-%H%M%S"),".log")

Write-Output "starting" (get-date) 
$msg = "starting " + (get-date)  
add-content $logf $msg
$maxage=30
if ($argv.count  -gt 1 ) 
{
    $maxage=$argv[1]
}

c:
$curdir=get-location
$cams=@('UK0006','UK000F')
$pis=@('meteorpi','meteorpi2')

for ($i=0;$i -lt $cams.count; $i++)
{
    $cam=$cams[$i]
    $pi=$pis[$i]
    mkdir C:\Users\Mark\Videos\Astro\MeteorCam\$cam  | out-null
    set-location C:\Users\Mark\Videos\Astro\MeteorCam\$cam

    $loopctr=0
    ping -n 1 $pi
    while (($? -ne "True") -and ($loopctr -lt 10))  {
        start-Sleep 5
        ping -n 1 $pi
        $loopctr++
    }
    if ($loopctr -eq 10)  {
        $msg=$pi+' seems to be down'
        Send-MailMessage -from meteor@observatory -to mark@localhost -subject $msg -body $msg -smtpserver 192.168.1.151    
        exit 1
    }
    Write-Output "copying data" 
    add-content $logf "copying data"
    robocopy \\$pi\rms_share\ArchivedFiles ArchivedFiles /dcopy:DAT /tee /v /s /r:3 /log+:$logf /maxage:$maxage
#    robocopy \\$pi\rms_share\ConfirmedFiles ConfirmedFiles /dcopy:DAT /tee /v /s /r:3 /log+:$logf /maxage:$maxage
    robocopy \\$pi\rms_share\logs logs log*.log /dcopy:DAT /tee /v /s /r:3 /log+:$logf /maxage:$maxage
    set-location $curdir
    & $PSScriptRoot\DailyChecks\reorgByYMD.ps1 $cam
}
Write-Output "finished" (get-date) 
add-content $logf "finished"