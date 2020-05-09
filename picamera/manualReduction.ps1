# script to run manual meteor reduction for the Pi
# args 
#   yymmdd date to copy for 
#   hhmmss time to copy for

$srcdir=$args[0]
$srcfile=$args[1]

#these details are specific to your camera and file system 
# name of your camera
$cam="UK0006"       

# UNC of the shared area on your Pi
$rootdir='\\meteorpi\RMS_Share\' 

# location where you keep the files on your PC. This area will have the
# ArchiveFiles and ConfirmedFiles folders in it
$datadir='c:\users\mark\videos\astro\meteorcam\' 

# folder under the datadir where you'll run manual reduction 
$targdir=$datadir+'manual\'

# location of RMS on your PC
$RMSloc='C:\Users\mark\Documents\Projects\meteorhunting\RMS'

# from here on it should not require any alterations
$here=Get-Location
set-location $targdir
del *.*

$src=$rootdir +"CapturedFiles\"+ $cam+"_"+ $srcdir +"*\FF_"+$cam+"*"+$srcfile+"*.fits"
Copy $src $targdir
$src=$rootdir +"CapturedFiles\"+ $cam+"_"+ $srcdir +"*\FR_"+$cam+"*"+$srcfile+"*.bin"
Copy $src $targdir
$src=$rootdir +"platepar*.cal"
Copy $src $targdir
$src=$rootdir +".config"
Copy $src $targdir
set-location $targdir
$ff=(Get-ChildItem "FF*.fits").fullname
set-location $RMSloc 
python -m Utils.ManualReduction -c . $ff
set-location $targdir
$ftp=(Get-ChildItem "FTPdetect*manual.txt").fullname
set-location $here
$arcdir=$datadir+$cam+"\ArchivedFiles\"
$arcdir=$arcdir+$cam+"_"$srcdir+"*"
set-location $arcdir
copy $ff .
$nftp=(Get-ChildItem "FTPdetect*.txt").fullname
msg  /w $env:username "opening windows for you to edit the FTPdetect files - don't forget to change the meteor count!"
notepad $ftp
notepad $nftp[0]

msg $env:username "now rerun the Confirmation process in CMN_BinViewer"