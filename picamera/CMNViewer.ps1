# simple script to display the most recent CMN/RMS meteor captures

#$rootdir='C:\users\mark\Videos\astro\MeteorCam\UK0006\ArchivedFiles'
$rootdir='\\meteorpi\RMS_Share\ArchivedFiles'
$path=(get-childitem $rootdir -directory | sort-object creationtime | select-object -last 1).name
$myf = $rootdir + '\'+$path
set-location 'C:\Program Files (x86)\CMN_binViewer'
& .\CMN_binViewer.exe $myf
