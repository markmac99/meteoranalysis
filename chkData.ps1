Function Get-Folder($initialDirectory) {
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowserDialog.RootFolder = 'MyComputer'
    if ($initialDirectory) { $FolderBrowserDialog.SelectedPath = $initialDirectory }
    [void] $FolderBrowserDialog.ShowDialog()
    return $FolderBrowserDialog.SelectedPath
}
$myf = get-folder('C:\users\mark\Videos\astro\MeteorCam\UK0006\ArchivedFiles')
cd C:\users\mark\documents\projects\meteorhunting\RMS
python -m Utils.FRbinViewer $myf
