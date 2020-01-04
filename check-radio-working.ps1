# powershell script to check radio meteor log and alert me if it 
# seems to have stopped working

$offset=-0.5
set-location c:\spectrum
while($true)
{
    $sdrdown='c:\temp\sdrdown'
    $dt =get-date -uformat '%Y%m%d'
    $ftocheck='event_log'+$dt+'.txt'
    write-output "checking..."
    if ((get-item $ftocheck).lastwritetime -lt  (get-date).addhours($offset)) 
    { 
        if (![System.IO.File]::Exists($sdrdown))
        {
            $msg='radio meteor seems to have stopped'
            write-output $msg
            Send-MailMessage -from radiometeor@rm -to mark@localhost -subject "Radio down" -body $msg -smtpserver 192.168.1.151    
            Write-Output "Radio down" > $sdrdown
        }
    } 
    else 
    {
        if ([System.IO.File]::Exists($sdrdown))
	{
            remove-item $sdrdown | out-null
	}
    }

    Start-Sleep -seconds 60
}