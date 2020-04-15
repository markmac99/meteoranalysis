# script to push video data to the website
$curloc = get-location

$yr = (get-date -uformat '%Y')
$mth = (get-date -uformat '%Y%m')
$awssite=get-content 'c:\users\mark\videos\astro\meteorcam\radio\awssite.txt'
$usr= 'bitnami@'+$awssite
if ($env:username -eq 'admin' )
{
    $key='c:\users\admin\.ssh\markskey.pem'
}else{
    $key='C:\users\mark\.ssh\markskey.pem'
}


write-output 'Collecting TC data'
set-location c:\users\mark\videos\astro\meteorcam\tc\$yr\$mth
mkdir  c:\users\mark\videos\astro\meteorcam\temp\tc 2> $NULL
remove-item c:\users\mark\videos\astro\meteorcam\temp\tc\*.jpg
$x=(get-childitem -r *p.jpg).fullname
for ($i=0;$i -lt $x.count ; $i++) {copy-item $x[$i] c:\users\mark\videos\astro\meteorcam\temp\tc }

write-output 'pushing to TC folder'
$targ= 'bitnami@'+$awssite+':data/meteors/tc/' 
ssh -o StrictHostKeyChecking=no -i $key $usr rm -f data/meteors/tc/*.jpg
scp -o StrictHostKeyChecking=no -i $key c:\users\mark\videos\astro\meteorcam\temp\tc\*.jpg $targ

write-output 'Collecting NE data'
set-location c:\users\mark\videos\astro\meteorcam\ne\$yr\$mth
mkdir c:\users\mark\videos\astro\meteorcam\temp\ne 2> $NULL
remove-item c:\users\mark\videos\astro\meteorcam\temp\ne\*.jpg
$x=(get-childitem -r *p.jpg).fullname
for ($i=0;$i -lt $x.count ; $i++) {copy-item $x[$i] c:\users\mark\videos\astro\meteorcam\temp\ne }

write-output 'pushing to NE folder'
$targ= 'bitnami@'+$awssite+':data/meteors/ne/' 
ssh -o StrictHostKeyChecking=no -i $key $usr rm -f data/meteors/ne/*.jpg
scp -o StrictHostKeyChecking=no -i $key c:\users\mark\videos\astro\meteorcam\temp\ne\*.jpg $targ

write-output 'Creating stacks'
ssh -o StrictHostKeyChecking=no -i $key $usr data/meteors/update.sh

write-output 'finding latest RMS stack'
$targ= 'bitnami@'+$awssite+':data/meteors/' 
$x=(get-childitem -r c:\users\mark\videos\astro\meteorcam\UK0006\ConfirmedFiles\*stack*.jpg).FullName
copy-item $x[$x.count-1] c:\users\mark\videos\astro\meteorcam\temp\UK0006_latest.jpg
scp -o StrictHostKeyChecking=no -i $key c:\users\mark\videos\astro\meteorcam\temp\UK0006_latest.jpg $targ

set-location $curloc