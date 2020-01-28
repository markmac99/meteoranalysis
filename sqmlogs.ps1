# get SQM logs
$mystr = "starting at " + (get-date) 
write-output $mystr
write-output $mystr  >> c:\temp\getsqm.log
net use \\astro2\mysqm /user:meteorcam Wombat33mc
robocopy \\astro2\mysqm\ *.csv c:\users\mark\pictures\astro\sqmlogs /mir
net use \\astro2\mysqm /d
write-output "done" >> c:\temp\getsqm.log