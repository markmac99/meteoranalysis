# 
# usage1: scan a months and copy any fireball data
#   .\Fireballreport.ps1 cameraname yyyymm
#
# parameter1 = two-letter SID of your camera. Mine are TC and NE 
# parameter2 = the year and month you want to analyse eg 201909
#
# usage2: copy a single fireball/meteor by name
#   .\Fireballreport.ps1 cameraname yyyymmdd_hhmmss

$camname=$args[0]

# VARIABLES YOU MUST SET
# set this to the location of your capture files. Do NOT include the camera SID
$caploc="C:\users\mark\videos\astro\MeteorCam\"

# set this to the location of where you want your fireball reports
$fbdir="C:\users\mark\videos\astro\MeteorCam\fireballs\"

# set this to the location of your UA2 profile files. Note that its camera-specific
$profdir = $caploc+$camname+'\UA2\prof\'

# thats it, everything else should just work
$basedir=$caploc+$camname

if ($args.count -lt 2) {
    $yyyy = get-date -format "yyyy"
    $mm = ([string](get-date -format "MM")).padleft(2,'0')
    $dd=0
} else {
    # check if we have actually been given a meteor name eg YYYYMMDD
    if (([string]$args[1]).length -eq 15) {
        $yyyy=([string]$args[1]).substring(0,4)
        $mm = ([string]$args[1]).substring(0,6)
        $dd= ([string]$args[1]).substring(0,8)
        $meteorid='M'+[string]$args[1]
    } else {

        $mm=$args[1]
        $yyyy=([string]$args[1]).Substring(0,4)
        $dd=0
    }
}
$msg = 'Checking '+$camname +' for ' + $mm
if ($dd -gt 0) {$msg ='Checking '+$camname+' for '+ $meteorid}
write-output $msg
if($dd -eq 0 ) {
    $targ=$basedir+'\'+$yyyy+'\'+$mm+'\*A.xml'
    $fb4 = (get-childitem -r $targ | select-string 'mag="-4').path | get-unique
    $fb5 = (get-childitem -r $targ | select-string 'mag="-5').path | get-unique
    $fb6 = (get-childitem -r $targ | select-string 'mag="-6').path | get-unique
    $fb7 = (get-childitem -r $targ | select-string 'mag="-7').path | get-unique
    $fblist = ([array]$fb4+$fb5+$fb6+$fb7) | get-unique
} else {
    $targ=$basedir+'\'+$yyyy+'\'+$mm+'\'+$dd+'\'+$meteorid+'*A.xml'
    $fblist = (get-childitem -r $targ ).fullname  
}
if ($fblist.count -eq 0) {write-output "No files found"}
for ($i=0 ; $i -lt $fblist.count; $i++)
{
    if(!$fblist[$i]) {continue}
    if($fblist.count -gt 1 )
    {
        $fc= $fblist[$i].indexof('\M20')+1
        $meteorid=$fblist[$i].substring($fc,16)
        $yyyy = ([string]$meteorid).Substring(1,4)
        $mm = ([string]$meteorid).Substring(1,6)
        $dd = ([string]$meteorid).Substring(1,8)
    }

    $srcdir = $basedir + "\"+$yyyy+"\"+$mm+"\"+$dd 
    $destdir = $fbdir+$meteorid
    $srcfiles= $srcdir + "\" + $meteorid + "*.*"

    $jpgfile = $srcdir + "\" + $meteorid + "*"+$camname +"P.jpg"
    #write-output $jpgfile
    $exists = test-path $jpgfile   
    if ($exists -eq $true) {
        $exists= test-path $destdir
        if ($exists -eq $false) {
            mkdir $destdir | Out-Null
        }
        Copy-Item $srcfiles $destdir

        $msg= "Copied "+$camname + " " + $meteorid +" data to fireballs directory"
        write-output $msg

        $profname = get-childitem $profdir | Sort-object Name -Descending | Select-object Name -First 1
        $fpn=$profdir + ([string]$profname.name)
        copy-item $fpn $destdir
    }
    else
    {
        $msg = "Files not found in source directory "
        write-output $msg
    }
}