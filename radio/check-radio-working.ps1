# powershell script to check radio meteor log and restart if it 
# seems to have stopped working

$offset=-0.5
$offsmin=-60*$offset
set-location c:\spectrum
while($true)
{
    $dt =get-date -uformat '%Y%m%d'
    $ftocheck='event_log'+$dt+'.txt'
    $now = get-date -uformat '%H:%M:%S'
    write-output "checking at $now..."
    if ((get-item $ftocheck).lastwritetime -lt  (get-date).addhours($offset)) 
    { 
        # need to handle midnight when the new file may not exist yet
        $hrmin=(get-date -uformat %H%M)
        if ($hrmin -gt $offsmin)
        {
            $msg='radio meteor seems to have stopped'
            write-output $msg
            Send-MailMessage -from radiometeor@rm -to mark@localhost -subject "Radio down" -body $msg -smtpserver 192.168.1.151    
            $id=(Get-Process SDRSharp).id
            stop-process $id
            & scripts\runSDRSharp.exe
        }
    } 
    Start-Sleep -seconds 60
}