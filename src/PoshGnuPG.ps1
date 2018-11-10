function Invoke-GpgExe
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

        [string] $GpgPath = "C:\Program Files (x86)\GnuPG\bin\gpg.exe",

        [string] $GpgLog = "~/gpg.log",

        [string] $GpgErr = "~/gpgErr.log"
    )

    
    # Build the argument list
    $args = @(
                "-e", "-v", "-r",# "-y",
                $ForUser,
                $FilePath
    )

    # Show the argument list we are using
    #Write-Verbose $args.ToString()

    $log = Invoke-GpgExe -GpgPath $GpgPath -GpgLog $GpgLog -GpgErr $GpgErr -ArgumentList $args

    return ($encFile, $log)
}


