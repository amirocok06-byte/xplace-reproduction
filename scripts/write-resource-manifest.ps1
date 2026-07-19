[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$rows = foreach ($directory in Get-ChildItem -LiteralPath (Join-Path $root 'third_party') -Directory) {
    if (-not (Test-Path -LiteralPath (Join-Path $directory.FullName '.git'))) { continue }
    [pscustomobject]@{
        name = $directory.Name
        official_url = (git -C $directory.FullName remote get-url origin)
        head = (git -C $directory.FullName rev-parse HEAD)
        branch = (git -C $directory.FullName branch --show-current)
        retrieved_utc = [DateTime]::UtcNow.ToString('o')
        dirty = [bool](git -C $directory.FullName status --porcelain)
    }
}
$rows | Export-Csv -LiteralPath (Join-Path $root 'manifests/tools.csv') -NoTypeInformation -Encoding UTF8

