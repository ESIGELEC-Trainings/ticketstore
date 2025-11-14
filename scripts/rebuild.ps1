param(
    [string]$Service = "all"
)

Write-Host "Arret des services..." -ForegroundColor Yellow
docker-compose down -v

if ($Service -eq "all") {
    Write-Host "Rebuild de tous les backends..." -ForegroundColor Yellow
    docker-compose build --no-cache backend-1 backend-2
} else {
    Write-Host "Rebuild de $Service..." -ForegroundColor Yellow
    docker-compose build --no-cache $Service
}

Write-Host "Demarrage des services..." -ForegroundColor Yellow
docker-compose up -d

Write-Host "Attente du demarrage (3 minutes)..." -ForegroundColor Yellow
Start-Sleep -Seconds 180

Write-Host "Etat des services:" -ForegroundColor Green
docker-compose ps