# doing Pi Camera astrometry
Function Get-Folder($initialDirectory) {
    [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | out-null
    $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowserDialog.RootFolder = 'MyComputer'
    if ($initialDirectory) { $FolderBrowserDialog.SelectedPath = $initialDirectory }
    [void] $FolderBrowserDialog.ShowDialog()
    return $FolderBrowserDialog.SelectedPath
}
$myf = get-folder('C:\users\mark\Videos\astro\MeteorCam\UK0006\ArchivedFiles')

set-location c:\users\mark\documents\projects\RMS
python -m RMS.Astrometry.SkyFit --config . $myf
set-location $PSScriptRoot
