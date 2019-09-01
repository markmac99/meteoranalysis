c:
cd C:\Users\Mark\Videos\Astro\MeteorCam
set x (get-content last_get.txt)
echo $x > logfile.txt
echo $x
(gci -r -path \\astrolaptop\meteorcam -File | where-object {$_.LastWriteTime -gt $x}).fullname.SubString(24) > c:\temp\filelist.txt
 get-date -uformat "%Y/%m/%d %H:%M:%S" > last_get.txt
get-content c:\temp\filelist.txt | foreach-object {
  echo $_ >> logfile.txt
  echo $_
  $a = test-path $_.substring(0,20) 
  if (-not $a)
  {
    new-item -itemtype directory -path $_.substring(0,20)
  }
  copy  \\astrolaptop\meteorcam\$_ -Destination $_ 
}
echo Done >> logfile.txt
exit