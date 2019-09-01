c:
cd C:\users\mark\documents\projects\RMS

$cmdline = "python -m RMS.Astrometry.SkyFit --config .  C:\users\mark\Videos\astro\MeteorCam\UK0006\ArchivedFiles\"

write-output "echo starting" | out-file -filepath c:\temp\doit.bat -encoding ascii
foreach ($a in dir C:\users\mark\Videos\astro\MeteorCam\UK0006\ArchivedFiles -ad) 
{
	$arr = $a -split ' ' 
	write-output  $cmdline$arr | out-file -filepath c:\temp\doit.bat -encoding ascii -append
}
c:\temp\doit.bat

