# make a fireball report dataset 
# usage: Fireballreport.ps1 cameraname yyyy mm
# eg Fireballreport.ps1 TC 2019 09
# to find fireballs 
# powershell command to get list of fireballs: 
# (get-childitem -r ne\2019\201909\*A.xml | select-string 'mag="-4').path | unique

$camname=$args[0]
if ($args.count -lt 3)
{
    $yyyy = get-date -format "yyyy"
    $mm = ([string](get-date -format "MM")).padleft(2,'0')
}
else 
{
    $yyyy=$args[1]
    $mm=([string]$args[2]).padleft(2,'0')
}
$basedir="C:\users\mark\videos\astro\MeteorCam\"+$camname

$targ=$basedir+'\'+$yyyy+'\'+$yyyy+$mm+'\*A.xml'
$fb4 = (get-childitem -r $targ | select-string 'mag="-4').path | get-unique
$fb5 = (get-childitem -r $targ | select-string 'mag="-5').path | get-unique
$fb6 = (get-childitem -r $targ | select-string 'mag="-6').path | get-unique
$fb7 = (get-childitem -r $targ | select-string 'mag="-7').path | get-unique
$fblist = ([array]$fb4+$fb5+$fb6+$fb7) | get-unique
#Write-Output "found " $fblist.count "fireballs"
#write-output $fblist
for ($i=0 ; $i -lt $fblist.count; $i++)
{
    if(!$fblist[$i]) {continue}
    $fc= $fblist[$i].indexof('\M20')+1
    $meteorid=$fblist[$i].substring($fc,16)

    $yyyy = ([string]$meteorid).Substring(1,4)
    $mm = ([string]$meteorid).Substring(1,6)
    $dd = ([string]$meteorid).Substring(1,8)

    $srcdir = $basedir + "\"+$yyyy+"\"+$mm+"\"+$dd 
    $destdir = $basedir +"\..\fireballs\"+$meteorid
    $srcfiles= $srcdir + "\" + $meteorid + "*.*"

    $jpgfile = $srcdir + "\" + $meteorid + "*"+$camname +"P.jpg"
    $exists = test-path $jpgfile   
    if ($exists -eq $true) {
        $exists= test-path $destdir
        if ($exists -eq $false) {
            mkdir $destdir | Out-Null
        }
        Copy-Item $srcfiles $destdir

        $msg= "Copied "+$camname + " " + $meteorid +" data to fireballs directory"
        write-output $msg
    }
    else
    {
        $msg = "Files not found in source directory "
        write-output $msg
    }
}