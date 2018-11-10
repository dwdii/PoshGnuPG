﻿function Invoke-GpgExe
{
    [CmdletBinding()]
    param
    (
        [string] $GpgPath = "C:\Program Files (x86)\GnuPG\bin\gpg.exe",

        [string] $GpgLog = "~/gpg.log",

        [string] $GpgErr = "~/gpgErr.log",

        [object[]] $ArgumentList
    )

    if(Test-Path $GpgLog)
    {
        Remove-Item $GpgLog
    }

    if(Test-Path $GpgErr)
    {
        Remove-Item $GpgErr
    }


    # Show the argument list we are using
    $ArgumentList | Out-String | Write-Verbose 

    # Fire up gpg.exe
    Start-Process -FilePath  $GpgPath -ArgumentList $ArgumentList -Wait -NoNewWindow -RedirectStandardOutput $GpgLog -RedirectStandardError $GpgErr

    # Load log and err log
    $log = Get-Content $GpgLog 
    $err = Get-Content $GpgErr 
    #if ($err.Length -gt 0)
    #{
    #    throw $err
    #}

    return ($log + $err)
}

function GpgEncrypt-File
{
    [CmdletBinding()]
    param
    (
        [string] $FilePath,

        [string] $ForUser,

        [string] $OutputFile,

        [string] $GpgPath = "C:\Program Files (x86)\GnuPG\bin\gpg.exe",

        [string] $GpgLog = "~/gpg.log",

        [string] $GpgErr = "~/gpgErr.log"
    )

    if($OutputFile.Length -eq 0)
    {
        $OutputFile = ($FilePath + ".gpg")
    }

    
    # Build the argument list
    $args = New-Object System.Collections.ArrayList
    $args.Add("-e") | Out-Null
    $args.Add("-v") | Out-Null
    $args.Add("-r") | Out-Null
    $args.Add($ForUser) | Out-Null

    # if an output file was specified, then pass it along
    if($OutputFile.Length -gt 0)
    {
        $args.Add("-o") | Out-Null
        $args.Add($OutputFile) | Out-Null
    }

    $args.Add($FilePath) | Out-Null

    # Show the argument list we are using
    #Write-Verbose $args.ToString()

    # Encrypt the file
    $log = Invoke-GpgExe -GpgPath $GpgPath -GpgLog $GpgLog -GpgErr $GpgErr -ArgumentList $args

    # Get the file object
    $encFile = Get-Item -Path $OutputFile

    return ($encFile, $log)
}


