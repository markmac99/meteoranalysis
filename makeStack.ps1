# script to push video data to the website
$curloc = get-location
$fnam=$args[0]

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
ssh -o StrictHostKeyChecking=no -i $key $usr data/meteors/tmp/makestack.sh

scp -o StrictHostKeyChecking=no -i $key $targ/stack.jpg .
move stack.jpg ../stacks/$fnam.jpg -Force

& 'C:\Program Files (x86)\FastStone Image Viewer\fsviewer.exe' ../stacks/$fnam.jpg

$del = read-host -Prompt 'Delete source files?'

if ( $del -eq 'Y' -or $del -eq 'y' )
{
    rm *.jpg
}

set-location $curloc