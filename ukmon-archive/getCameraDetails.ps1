# script to get UKMON camera details

$arc='c:\users\mark\videos\astro\meteorcam\archive-full\'

$camdets='c:\users\mark\videos\astro\meteorcam\ukmon\camera-details.csv'

if($args.count -lt 3 )
{
    Write-Output "usage: getCameraDetails.ps1 xmlfile"
    Write-Output "eg getCameraDetails.ps1 Tackley c1 2020"
}
else {
    $locname=$args[0]
    $camname=$args[1]
    $yr=$args[2]

    $floc=$arc+$locname+'\'+$camname+'\'+$yr+'\'+$yr+'01\M*.xml'
    $flist= get-childitem -recurse -path $floc
    if($flist.count -gt 0){
        if($flist.count -eq 1)
            {$xmlf=(($flist).fullname)}
        else
            {$xmlf=(($flist).fullname)[0]}
        [xml]$fin=get-content $xmlf
        $rec=$fin.ufocapture_record

        $outstr=$locname+','+$camname+','+$rec.lid+','+$rec.sid+','+$rec.cam+','+$rec.lens+','+$rec.cx+','+$rec.cy+','+$rec.lng+','+$rec.lat+','+$rec.alt
        $outstr | out-file $camdets -Append
    }else {
        write-output 'file not found - check path'
    }
}
