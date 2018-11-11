$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
Import-Module ($scriptPath  + "\..\src\PoshGnuPG.ps1")

# Get and Show Gpg.exe help
Invoke-GpgExe -ArgumentList ("-h") -Verbose

# Test the encryption function
$encfile, $log = GpgEncrypt-File -FilePath "D:\Code\PowerShell\PoshGnuPG\test-data\monalisa-test.jpg" -ForUser "daniel@dittenhafer.net" -Verbose
#Write-Output $encfile
#Write-Host $log
                

$destFile = "D:\Code\PowerShell\PoshGnuPG\test-data\monalisa-test.jpg.enctest"
$encfile, $log = GpgEncrypt-File -FilePath "D:\Code\PowerShell\PoshGnuPG\test-data\monalisa-test.jpg" -ForUser "daniel@dittenhafer.net" -Verbose -OutputFile $destFile

$encfile | Out-String | Write-Host 
$log | Out-String | Write-Host 


GpgDecrypt-File -FilePath $destFile