﻿$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$Files = Get-ChildItem $toolsDir -Filter '*.exe' |
               Sort-Object LastWriteTime | 
               Select-Object -Last 2

$File32 = ($Files | Where-Object {$_.Name -notmatch 'win64'}).fullname
$File64 = ($Files | Where-Object {$_.Name -match 'win64'}).fullname

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   File           = $File32
   File64         = $File64
   softwareName   = "$env:ChocolateyPackageName*"
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

foreach ($File in $Files) {
   Remove-Item $File -ea 0 -force
}
