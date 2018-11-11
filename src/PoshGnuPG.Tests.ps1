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