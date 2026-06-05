# PowerShell utility script to render the tex file to a pdf
# Equivalent to make_thesis.sh for Windows PowerShell

param(
    [switch]$ForceRebuild
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "Using Docker" -ForegroundColor Green

# Build the docker image with all tex dependencies (skip if image exists)
# ensure variable exists to satisfy Set-StrictMode
$needBuild = $false

if ($ForceRebuild) {
    Write-Host "Force rebuild requested: building Docker image..." -ForegroundColor Cyan
    $needBuild = $true
} else {
    Write-Host "Checking for existing Docker image 'bpimg'..." -ForegroundColor Cyan
    docker image inspect bpimg > $null 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Docker image 'bpimg' found — skipping build." -ForegroundColor Yellow
        $needBuild = $false
    } else {
        Write-Host "Docker image 'bpimg' not found — building now..." -ForegroundColor Cyan
        $needBuild = $true
    }
}

if ($needBuild) {
    docker build --tag bpimg --file docker/Dockerfile .
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Docker build failed"
        exit 1
    }
}

# Build the thesis
Write-Host "Rendering thesis..." -ForegroundColor Cyan
$pwd = (Get-Location).Path
docker run --rm --volume "${pwd}:/bp" bpimg sh /bp/docker/render_thesis.sh gradproef

if ($LASTEXITCODE -ne 0) {
    Write-Error "Thesis rendering failed"
    exit 1
}

$cleanupPath = Join-Path (Get-Location).Path 'output'
Get-ChildItem -Path $cleanupPath -Force | Where-Object { $_.Name -notlike '*.pdf' } | Remove-Item -Recurse -Force

Write-Host "Thesis build completed successfully!" -ForegroundColor Green
Write-Host "Cleaned output folder; only PDFs remain." -ForegroundColor Green
Write-Host "Output: output/DePusJonasGP.pdf" -ForegroundColor Green
