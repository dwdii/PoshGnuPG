# PoshGnuPG

Powershell wrapper for [Gpg4win](https://www.gpg4win.org/) and GnuGP

## Gpg4Win

This module was developed and tested using Gpg4Win v3.1.4 and GnuGP v2.2.10

## Usage

```powershell
GpgEncrypt-File -FilePath "filepath\to\file.ext" -ForUser "user@email.com"
```

```powershell
GpgDecrypt-File -FilePath "filepath\to\file.ext.gpg"
```

### Invoke-GpgExe

`Invoke-GpgExe` is simply a PowerShell wrapper around the `gpg.exe`. 

* ArgumentList: The arguments to pass to the `gpg.exe`.

```powershell
Invoke-GpgExe -ArgumentList @("-h")
```
