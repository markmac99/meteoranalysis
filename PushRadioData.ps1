cd c:\spectrum\screenshots
scp -i C:\Users\Mark\Documents\projects\aws\markskey.pem ..\latest2d.jpg ec2-user@ec2-18-130-54-182.eu-west-2.compute.amazonaws.com:/var/www/html/markmcintyreastro/meteors/radio
$fnam=(ls  c:\spectrum\screenshots\ | sort-object lastwritetime).fullname | select-object -last 1
scp -i C:\Users\Mark\Documents\projects\aws\markskey.pem $fnam ec2-user@ec2-18-130-54-182.eu-west-2.compute.amazonaws.com:/var/www/html/markmcintyreastro/meteors/radio/latestcapture.jpg
$mmyyyy=((get-date).tostring("MMyyyy"))
$fnam='C:\Program Files (x86)\Colorgramme Lab\img\McIntyre_'+ $mmyyyy +'.jpg'
scp -i C:\Users\Mark\Documents\projects\aws\markskey.pem $fnam ec2-user@ec2-18-130-54-182.eu-west-2.compute.amazonaws.com:/var/www/html/markmcintyreastro/meteors/radio/latestcapture.jpg
ssh -i C:\Users\Mark\Documents\projects\aws\markskey.pem ec2-user@ec2-18-130-54-182.eu-west-2.compute.amazonaws.com /var/www/html/markmcintyreastro/meteors/getdata.sh

