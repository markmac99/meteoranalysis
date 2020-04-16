# script to push video data to the website
$curloc = get-location
$fnam=$args[0]
$minbri=$args[1]

if($args.count -lt 1) {$fnam='stack.jpg'}
if($args.count -lt 2) {$minbri=0.5}

$awssite=get-content 'c:\users\mark\videos\astro\meteorcam\radio\awssite.txt'
$usr= 'bitnami@'+$awssite
if ($env:username -eq 'admin' )
{
    $key='c:\users\admin\.ssh\markskey.pem'
}else{
    $key='C:\users\mark\.ssh\markskey.pem'
}


write-output 'Collecting data'
set-location c:\users\mark\videos\astro\meteorcam\tmpstack

write-output 'pushing to temp folder'
$targ= 'bitnami@'+$awssite+':data/meteors/tmp/' 
ssh -o StrictHostKeyChecking=no -i $key $usr rm -f data/meteors/tmp/*.jpg
scp -o StrictHostKeyChecking=no -i $key *.jpg $targ

write-output 'Creating stack'
ssh -o StrictHostKeyChecking=no -i $key $usr data/meteors/tmp/makestack.sh $fnam $minbri

scp -o StrictHostKeyChecking=no -i $key $targ/$fnam ../stacks/
#move-item stack.jpg ../stacks/$fnam.jpg -Force

& 'C:\Program Files (x86)\FastStone Image Viewer\fsviewer.exe' ../stacks/$fnam

$del = read-host -Prompt 'Delete source files?'

if ( $del -eq 'Y' -or $del -eq 'y' )
{
    remove-item *.jpg
}

set-location $curloc