$fnam=(ls  c:\spectrum\screenshots\ | sort-object lastwritetime).fullname | select-object -last 1
aws s3 cp $fnam s3://mjmm-meteor-uploads
aws s3 cp c:\spectrum\latest2d.jpg s3://mjmm-meteor-uploads
