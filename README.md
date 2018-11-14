# PoshGnuPG

Powershell wrapper for [Gpg4win](https://www.gpg4win.org/) and GnuGP

## Gpg4Win

This module was developed and tested using Gpg4Win v3.1.4 and GnuGP v2.2.10

## Usage

### GpgEncrypt-Folder

* Path: The path to the folder to encrypt files from .
* Filter: A file system filter to apply when discovering files
* ForUser: The identifier of the user for which the encryption will be performed. This is the recipient of the encrypted file.
* OutputPath: The path to the destination of the encrypted files.
* DonePath: The path to the location where files that have been worked will move to.

```powershell
GpgEncrypt-Folder -Path "filepath\to\file.ext" -Filter "*.ext" -ForUser "user@email.com" -OutputPath "filepath\to\encypted files" -DonePath "destination\of\worked\files"
```

### GpgEncrypt-File

* FilePath: The file system path to the file to be encrypted.
* ForUser: The identifier of the user for which the encryption will be performed. This is the recipient of the encrypted file.

```powershell
GpgEncrypt-File -FilePath "filepath\to\file.ext" -ForUser "user@email.com"
```

### GpgDecrypt-File

* FilePath: The file system path to the file to be encrypted.

```powershell
GpgDecrypt-File -FilePath "filepath\to\file.ext.gpg"
```

### Invoke-GpgExe

`Invoke-GpgExe` is simply a PowerShell wrapper around the `gpg.exe`.

* ArgumentList: The arguments to pass to the `gpg.exe`.

```powershell
Invoke-GpgExe -ArgumentList @("-h")
```
