set-location $PSScriptRoot
invoke-expression -Command .\get_files-TC.ps1
set-location $PSScriptRoot
invoke-expression -Command .\get_files-NE.ps1
set-location $PSScriptRoot
invoke-expression -Command .\get_files-UK0006.ps1
set-location $PSScriptRoot
invoke-expression -Command .\get_files-RADIO.ps1
set-location $PSScriptRoot
if ((get-date).hour -eq 8 ) {invoke-expression -command .\ukmon-archive\get-archive.ps1}
set-location $PSScriptRoot
if ((get-date).hour -eq 20 ) {invoke-expression -command .\pushtowebsite.ps1}
set-location $PSScriptRoot
if ((get-date).hour -eq 12 ) {
    set-location c:\users\mark\documents\projects\meteorhunting\ukmon-shared\newanalysis
    $dt=get-date -uformat '%Y%m%d'
    conda activate RMS
    python curateCamera.py ..\tackley_tc $dt
    python curateCamera.py ..\tackley_ne $dt
}


