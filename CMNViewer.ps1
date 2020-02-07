# simple script to display the most recent CMN/RMS meteor captures

$rootdir='C:\users\mark\Videos\astro\MeteorCam\UK0006\ArchivedFiles'
$path=(dir $rootdir -directory | sort creationtime | select -last 1).name
$myf = $rootdir + '\'+$path
cd "C:\Program Files (x86)\CMN_binViewer"
& .\CMN_binViewer.exe $myf
