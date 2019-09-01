$logf=  -join(".\logs\robocopy-", (get-date -uformat "%Y%m%d-%H%M%S"),".log")

echo "starting" (get-date) 
c:
cd C:\Users\Mark\Videos\Astro\MeteorCam

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
echo "copying data for $tod" 
robocopy \\thelinux\meteorcam\$tod $tod *.jpg *.bmp *.txt *.xml M*.avi /m /dcopy:DAT /tee /v /s /log+:$logf
if ($tod -ne $ytd) {
    echo "copying data for $yyd"
    robocopy \\thelinux\meteorcam\$ytd $ytd *.jpg *.bmp *.txt *.xml M*.avi  /m /dcopy:DAT /tee /v /s /log+:$logf
}

echo "finished" (get-date) 
