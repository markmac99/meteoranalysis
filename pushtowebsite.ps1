# script to push video data to the website
$curloc = get-location

$yr = (get-date -uformat '%Y')
$mth = (get-date -uformat '%Y%m')
$awssite=get-content 'c:\users\mark\videos\astro\meteorcam\radio\awssite.txt'
$usr= 'bitnami@'+$awssite

write-output 'Collecting TC data'
set-location c:\users\mark\videos\astro\meteorcam\tc\$yr\$mth
mkdir  C:\temp\tc 2> $NULL
remove-item c:\temp\tc\*.jpg
$x=(get-childitem -r *p.jpg).fullname
for ($i=0;$i -lt $x.count ; $i++) {copy-item $x[$i] c:\temp\tc }

write-output 'pushing to TC folder'
$key='c:\users\mark\.ssh\markskey.pem'
$targ= 'bitnami@'+$awssite+':data/meteors/tc/' 
ssh -o StrictHostKeyChecking=no -i $key $usr rm -f data/meteors/tc/*.jpg
scp -o StrictHostKeyChecking=no -i $key c:\temp\tc\*.jpg $targ

write-output 'Collecting NE data'
set-location c:\users\mark\videos\astro\meteorcam\ne\$yr\$mth
mkdir C:\temp\ne 2> $NULL
remove-item c:\temp\ne\*.jpg
$x=(get-childitem -r *p.jpg).fullname
for ($i=0;$i -lt $x.count ; $i++) {copy-item $x[$i] c:\temp\ne }

write-output 'pushing to NE folder'
$key='c:\users\mark\.ssh\markskey.pem'
$targ= 'bitnami@'+$awssite+':data/meteors/ne/' 
ssh -o StrictHostKeyChecking=no -i $key $usr rm -f data/meteors/ne/*.jpg
scp -o StrictHostKeyChecking=no -i $key c:\temp\ne\*.jpg $targ

write-output 'Creating stacks'
ssh -o StrictHostKeyChecking=no -i $key $usr data/meteors/update.sh

write-output 'finding latest RMS stack'
$targ= 'bitnami@'+$awssite+':data/meteors/' 
$x=(get-childitem -r c:\users\mark\videos\astro\meteorcam\UK0006\ConfirmedFiles\*stack*.jpg).FullName
copy-item $x[$x.count-1] c:\temp\UK0006_latest.jpg
scp -o StrictHostKeyChecking=no -i $key c:\temp\UK0006_latest.jpg $targ

set-location $curloc