function Invoke-GpgExe
{
    [CmdletBinding()]
    param
    (
        [string] $GpgPath = "C:\Program Files (x86)\GnuPG\bin\gpg.exe",

        [string] $GpgLog = "~/gpg.log",

        [string] $GpgErr = "~/gpgErr.log",

        [object[]] $ArgumentList = @("-h")
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
    $proc = Start-Process -FilePath  $GpgPath -ArgumentList $ArgumentList -Wait -NoNewWindow -RedirectStandardOutput $GpgLog -RedirectStandardError $GpgErr -PassThru

    # Show result code
    ("{0} exit code: {1}" -F $GpgPath, $proc.ExitCode) | Out-String | Write-Verbose

    # Load log and err log
    $log = Get-Content $GpgLog 
    $err = Get-Content $GpgErr 
    if ($proc.ExitCode -gt 0)
    {
        throw $log
    }

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
    #$encFile = Get-Item -Path $OutputFile

    return $log
}

function GpgEncrypt-Folder
{
    <#
    .SYNOPSIS
        Iterates over discovered files in the specified path by filter criteria
        to encrypt each file, outputing to the OutputPath. Completed input
        files are moved to the DonePath. Encrypt is using the ForUser's 
        encryption key found in Kleopatra. 

    .PARAMETER Path
        The file system path to the input folder of files to encrypt.

    .PARAMETER Filter
        The file system filter, such as *.* or *.csv.

    .PARAMETER ForUser
        The email address (or other identifier) of the encryption key to use from Kleopatra.

    .PARAMETER OutputPath
        The file system path to the folder which receives the encrypted files.

    .PARAMETER DonePath
        The file system path to the folder which receives the original input files after successful encryption.

    .PARAMETER LogPath
        The file system path and filename to the log file used by the function for persistent logging.
    
    .OUTPUTS
        An array list of the encrypted output files.

    #>    
    [CmdletBinding()]
    param
    (
        [string] $Path,

        [string] $Filter,

        [string] $ForUser,

        [string] $OutputPath,

        [string] $DonePath,

        [string] $LogPath = (".\PohGnuPG-{0}.log") -f (Get-Date -Format "yyyyMMdd")
    )

    # check if exists and if not, then create the output path.
    if(-not (Test-Path -Path $OutputPath -PathType Container))
    {
        New-Item -Path $OutputPath -ItemType Container
    }

    # check if exists and if not, then create the done path.
    if(-not (Test-Path -Path $DonePath -PathType Container))
    {
        New-Item -Path $OutputPath -ItemType Container
    }

    # Get a list of available files to encrypt and allocate the list of encrypted files
    $files = Get-ChildItem  -Path $Path -Filter $filter
    $outputFiles = New-Object System.Collections.ArrayList

    foreach ($file in $files) 
    {
        # Log
        Add-Content -Path $LogPath -Value ("{0},{1}" -F (Get-Date -Format "yyyyMMdd HH:mm:ss"), $file)

        $FullPath = Join-Path -Path $Path -ChildPath $file
        $OutputFile = Join-Path -Path $OutputPath -ChildPath ($file.Name + ".gpg")
    
        # Encrypt the input file
        $result = GpgEncrypt-File -FilePath $FullPath -ForUser $ForUser -OutputFile $OutputFile

        # Log
        foreach($s in $result)
        {
            Add-Content -Path $LogPath -Value ("{0},{1}" -F (Get-Date -Format "yyyyMMdd HH:mm:ss"), $s)
        }
        
        # If the output file got created successfully, move the input file to the done folder.
        if(Test-Path -Path $OutputFile -PathType Leaf )
        {
            Move-Item -Path $FullPath -Destination $DonePath
            $outputFiles.Add($OutputFile) | Out-Null
        }

    }

    return $outputFiles
}


function GpgDecrypt-File
{
    <#
    .SYNOPSIS
        Decrypts a specified file, if an appropriate key exists to decrypt.
        This function is interactive due to Gpg.exe launching a modal dialog
        for private key password entry.

    #>

    [CmdletBinding()]
    param
    (
        [string] $FilePath,

        [string] $ForUser,

        [string] $OutputFile,

        [string] $GpgPath = "C:\Program Files (x86)\GnuPG\bin\gpg.exe",

        [string] $GpgLog = "~/gpgDecrypt.log",

        [string] $GpgErr = "~/gpgDecryptErr.log"
    )

    if($OutputFile.Length -eq 0)
    {
        $folder = [IO.Path]::GetDirectoryName($FilePath)
        $rootFilename = [IO.Path]::GetFileNameWithoutExtension($FilePath)
        $OutputFile = Join-Path -Path $folder -ChildPath $rootFilename
    }

    
    # Build the argument list
    $args = New-Object System.Collections.ArrayList
    $args.Add("-d") | Out-Null
    $args.Add("-v") | Out-Null
    #$args.Add("-r") | Out-Null
    #$args.Add($ForUser) | Out-Null

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
    #$encFile = Get-Item -Path $OutputFile

    return $log
}


