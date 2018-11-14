#
# Pester: https://github.com/Pester/Pester/wiki
#
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Invoke-GpgExe" {
    It " given no parameters, executes gpg.exe and returns the help string" {
        $res = Invoke-GpgExe
        #$res | Select-Object -Index 0 | Write-Host
        $res | Select-Object -Index 0 | Should Be "gpg (GnuPG) 2.2.10"
    }
}

Describe "GpgEncrypt-Folder" {
    It "encrypts each file in the the folder <Path> and outputs to <OutputPath> the encrypted file. " {
        $inputRoot = ($here + "\..\test-data\")
        $outputPath = ($here + "\..\test-data\output")
        $donePath = ($here + "\..\test-data\done") 
        $res = GpgEncrypt-Folder -Path $inputRoot -Filter "*.jpg" -ForUser "daniel@dittenhafer.net" -OutputPath $outputPath -DonePath $donePath -Verbose
        #$res | Select-Object -Index 0 | Write-Host
        #$res | Select-Object -Index 0 | Should Be "gpg (GnuPG) 2.2.10"
        
        foreach($f in $res)
        {
            # Test outcome
            $f | Should Exist

            # Cleanup
            Write-Host ("Removing {0}" -F $f)
            Remove-Item -Path $f
        }

        Get-ChildItem -Path $donePath -Filter "*.jpg" | Move-Item -Destination $inputRoot
        
    }
}