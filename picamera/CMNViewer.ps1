# simple script to display the most recent CMN/RMS meteor captures

#$rootdir='C:\users\mark\Videos\astro\MeteorCam\UK0006\ArchivedFiles'
net use \\meteorpi\RMS_share /user:pi Wombat33rpi
$rootdir='\\meteorpi\RMS_Share\ArchivedFiles'
$path=(get-childitem $rootdir -directory | sort-object creationtime | select-object -last 1).name
$myf = $rootdir + '\'+$path
#set-location 'C:\Program Files (x86)\CMN_binViewer'
#& .\CMN_binViewer.exe $myf
set-location \\buffalonas\mark\projects\CroatianMeteorNetwork\cmn_binviewer
conda activate binviewer
python CMN_BinViewer.py $myf
