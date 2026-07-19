[CmdletBinding(SupportsShouldProcess)]
param([switch]$ToolsOnly)

$ErrorActionPreference = 'Stop'
$root = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$tools = @(
    @{ Name='DREAMPlace'; Url='https://github.com/limbo018/DREAMPlace.git' },
    @{ Name='OpenROAD'; Url='https://github.com/The-OpenROAD-Project/OpenROAD.git' },
    @{ Name='OpenROAD-flow-scripts'; Url='https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git' },
    @{ Name='Xplace'; Url='https://github.com/cuhk-eda/Xplace.git' }
)
foreach ($tool in $tools) {
    $destination = Join-Path $root "third_party/$($tool.Name)"
    if (Test-Path -LiteralPath $destination) {
        if (-not (Test-Path -LiteralPath (Join-Path $destination '.git'))) { throw "拒绝覆盖非 Git 目录: $destination" }
        Write-Output "SKIP existing checkout: $destination"
        continue
    }
    if ($PSCmdlet.ShouldProcess($destination, "git clone --recurse-submodules $($tool.Url)")) {
        git clone --recurse-submodules $tool.Url $destination
        if ($LASTEXITCODE -ne 0) { throw "clone failed: $($tool.Name)" }
    }
}
if (-not $ToolsOnly) { Write-Output 'Dataset sources are registered in docs/dataset-sources.md.' }
