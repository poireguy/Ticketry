#!/usr/bin/env pwsh

param (
    [Parameter(Mandatory = $true)]
    [string]$BinDir
)

# Determine Desktop Path
$OD_Desktop = Join-Path $env:ONEDRIVE "Desktop"
$Desktop = Join-Path $env:USERPROFILE "Desktop"
$DesktopPath = if (Test-Path $OD_Desktop) { $OD_Desktop } else { $Desktop }

# Get all fragment files
$fragments = Get-ChildItem -Path $BinDir -Filter "*.bin" | Sort-Object Name

if ($fragments.Count -eq 0) {
    Write-Error "No binary fragments found in '$BinDir'."
    exit 1
}

# Derive output name from prefix
$prefix = ($fragments[0].BaseName -replace '\d+$', '')  # Remove numeric suffix
$mergedPath = Join-Path $BinDir "$prefix.bin"
$finalExe = Join-Path $DesktopPath "$prefix.exe"

Write-Host "Merging fragments into '$mergedPath'..."
$hex = ""

foreach ($fragment in $fragments) {
    $bytes = [System.IO.File]::ReadAllBytes($fragment.FullName)
    $hex += ($bytes | ForEach-Object { $_.ToString("X2") }) -join ""
}

# Slice hex string into clean 2-character chunks
$byteList = [Byte[]] @()

for ($i = 0; $i -lt $hex.Length; $i += 2) {
    $chunk = $hex.Substring($i, 2)
    try {
        $byteList += [Convert]::ToByte($chunk, 16)
    } catch {
        Write-Warning "Failed to parse hex chunk '$chunk' at position $i."
    }
}

# Write to .bin
[System.IO.File]::WriteAllBytes($mergedPath, $byteList)
Write-Host "Merged .bin written to $mergedPath"

# Restore as .exe to desktop
[System.IO.File]::WriteAllBytes($finalExe, $byteList)
Write-Host "Final executable reconstructed: $finalExe"
