# doing Pi Camera astrometry
Function Get-Folder($initialDirectory) {
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowserDialog.RootFolder = 'MyComputer'
    if ($initialDirectory) { $FolderBrowserDialog.SelectedPath = $initialDirectory }
    [void] $FolderBrowserDialog.ShowDialog()
    return $FolderBrowserDialog.SelectedPath
}
$myf = get-folder('C:\users\mark\Videos\astro\MeteorCam\UK0006\ArchivedFiles')

cd c:\users\mark\documents\projects\RMS
python -m RMS.Astrometry.SkyFit --config . $myf
set-location $PSScriptRoot
