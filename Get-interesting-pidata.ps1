# powershell script to grab interesting files from Pi Camera analysis

$srcpath='c:\users\mark\videos\astro\meteorcam\UK0006\'

$arcpath=$srcpath + 'ArchivedFiles\'
$dlist = (get-childitem -directory $arcpath).Name
foreach ($dname in $dlist)
{
    $msg = 'processing '+$dname
    Write-Output $msg
    $yr=$dname.substring(7,4)
    $mt=$dname.substring(11,2)
    $dy=$dname.substring(13,2)

    # powershell can recursively create a folder
    $pth= $srcpath+$yr+'\'+$yr+$mt+'\'+$yr+$mt+$dy
    $exists = test-path $pth
    if ($exists -ne $true) { mkdir $pth | Out-Null}

    $src=$srcpath +'ArchivedFiles\'+$dname +'\*radiants.*'
    copy-item $src $pth
    $src=$srcpath +'ArchivedFiles\'+$dname +'\*meteors.*'
    copy-item $src $pth
    $src=$srcpath +'ArchivedFiles\'+$dname +'\*thumbs.jpg'
    copy-item $src $pth
    $src=$srcpath +'ArchivedFiles\'+$dname +'\FTP*.txt'
    copy-item $src $pth
    $src=$srcpath +'ArchivedFiles\'+$dname +'\*.csv'
    copy-item $src $pth
    $src=$srcpath +'ArchivedFiles\'+$dname +'\FF_UK0006_*.jpg'
    copy-item $src $pth
    $src=$srcpath +'ArchivedFiles\'+$dname +'\FF_UK0006_*.gif'
    copy-item $src $pth
}
