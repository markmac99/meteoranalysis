set-location $PSScriptRoot
invoke-expression -Command .\get_files-TC.ps1
set-location $PSScriptRoot
invoke-expression -Command .\get_files-NE.ps1
set-location $PSScriptRoot
invoke-expression -Command .\get_files-GMN1.ps1
set-location $PSScriptRoot
invoke-expression -Command .\get_files-RADIO.ps1
set-location $PSScriptRoot
invoke-expression -command .\create-colorgram.bat
set-location $PSScriptRoot
if ((get-date).hour -eq 8 ) {invoke-expression -command .\ukmon-archive\get-archive.ps1}
set-location $PSScriptRoot
if ((get-date).hour -eq 20 ) {invoke-expression -command .\pushtowebsite.ps1}


