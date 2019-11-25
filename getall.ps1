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



