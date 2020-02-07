# testing ukmon archive triggers
$myl=(get-childitem -r m*.csv).fullname
for ($i=0;$i -lt $myl.count;$i++) {
    aws s3 cp $myl[$i] s3://mjmm-meteor-uploads
}