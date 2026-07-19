[CmdletBinding()]
param()

$ErrorActionPreference = 'Continue'
Write-Output "timestamp=$([DateTime]::UtcNow.ToString('o'))"
Write-Output "windows=$([Environment]::OSVersion.VersionString)"
Write-Output "cpu=$((Get-CimInstance Win32_Processor | Select-Object -First 1 -ExpandProperty Name).Trim())"
$memory = Get-CimInstance Win32_ComputerSystem
Write-Output "memory_gb=$([Math]::Round($memory.TotalPhysicalMemory / 1GB, 2))"
$drive = Get-PSDrive -Name ([Environment]::GetFolderPath('Desktop').Substring(0,1))
Write-Output "desktop_drive_free_gb=$([Math]::Round($drive.Free / 1GB, 2))"
foreach ($command in @('git','wsl','docker','nvidia-smi')) {
    $found = Get-Command $command -ErrorAction SilentlyContinue
    Write-Output "$command=$([bool]$found)"
}
if (Get-Command wsl -ErrorAction SilentlyContinue) { wsl --status 2>&1 }
if (Get-Command nvidia-smi -ErrorAction SilentlyContinue) {
    nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader 2>&1
}

