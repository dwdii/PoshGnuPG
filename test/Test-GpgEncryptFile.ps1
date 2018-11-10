$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

Import-Module ($scriptPath  + "\..\src\PoshGnuPG.ps1")

if (1 -eq 0)
{
    $args = ( "-o", "C:\Users\Dan\OneDrive\Backups\gpg4win\2018-KeyPair-hotmail-MSI.p12",
              "--export", "dan_dittenhafer@hotmail.com", "--export-format", "pkcs12", "--cert")
    $args2= ( "-o", "C:\Users\Dan\OneDrive\Backups\gpg4win\2018-KeyPair-hotmail-MSI.p12",
              "--export", "dan_dittenhafer@hotmail.com", "--export-format", "pkcs12", "--cert")

    $listArgs = @("--list-secret=keys", "--keyid-format", "short")
    $helpArgs = ("-h")

    $gpgLog = "~/gpg.log"
    $gpgErr = "~/gpgErr.log"

    Start-Process -FilePath  $GpgPath -ArgumentList $helpArgs  -Wait -NoNewWindow -RedirectStandardOutput $gpgLog -RedirectStandardError $gpgErr

    Get-Content $gpgLog 
}

Invoke-GpgExe -ArgumentList ("-h") -Verbose

#
GpgEncrypt-File -FilePath "D:\Code\PowerShell\PoshGnuPG\test-data\monalisa-test.jpg" -ForUser "daniel@dittenhafer.net" -Verbose
                
