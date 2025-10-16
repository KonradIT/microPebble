# Build script for microPebble using Docker

Write-Host "Building Docker image..." -ForegroundColor Cyan
docker build -t micropebble-build .

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nDocker image built successfully!" -ForegroundColor Green
    Write-Host "`nRunning build in container..." -ForegroundColor Cyan
    
    # Run the build and copy output back to host
    docker run --rm -v ${PWD}/app/build:/workspace/app/build micropebble-build
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`nBuild completed successfully!" -ForegroundColor Green
        Write-Host "APK files are in: app\build\outputs\apk\" -ForegroundColor Yellow
    } else {
        Write-Host "`nBuild failed!" -ForegroundColor Red
    }
} else {
    Write-Host "`nDocker image build failed!" -ForegroundColor Red
}

