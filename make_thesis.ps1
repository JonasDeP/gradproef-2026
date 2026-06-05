# PowerShell utility script to render the tex file to a pdf
# Equivalent to make_thesis.sh for Windows PowerShell

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "Using Docker" -ForegroundColor Green

# Build the docker image with all tex dependencies
Write-Host "Building Docker image..." -ForegroundColor Cyan
docker build --tag bpimg --file docker/Dockerfile .

if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker build failed"
    exit 1
}

# Build the thesis
Write-Host "Rendering thesis..." -ForegroundColor Cyan
$pwd = (Get-Location).Path
docker run --rm --volume "${pwd}:/bp" bpimg sh /bp/docker/render_thesis.sh gradproef

if ($LASTEXITCODE -ne 0) {
    Write-Error "Thesis rendering failed"
    exit 1
}

Write-Host "Thesis build completed successfully!" -ForegroundColor Green
Write-Host "Output: output/DePusJonasGP.pdf" -ForegroundColor Green
