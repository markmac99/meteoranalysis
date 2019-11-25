cd $PSScriptRoot
invoke-expression -Command .\get_files-TC.ps1
cd $PSScriptRoot
invoke-expression -Command .\get_files-NE.ps1
cd $PSScriptRoot
invoke-expression -Command .\get_files-GMN1.ps1
cd $PSScriptRoot
invoke-expression -Command .\get_files-RADIO.ps1

