# PoshGnuPG

Powershell wrapper for [Gpg4win](https://www.gpg4win.org/) and GnuGP

## Gpg4Win

This module was developed and tested using Gpg4Win v3.1.4 and GnuGP v2.2.10

## Usage

```posh
GpgEncrypt-File -FilePath "filepath\to\file.ext" -ForUser "user@email.com"
```

```{posh}
GpgDecrypt-File -FilePath "filepath\to\file.ext.gpg"
```

```{posh}
Invoke-GpgExe -ArgumentList @("-h")
```
