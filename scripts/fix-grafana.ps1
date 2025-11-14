Write-Host "=== CORRECTION GRAFANA ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Arret de Grafana..." -ForegroundColor Yellow
docker-compose stop grafana

Write-Host ""
Write-Host "2. Suppression du conteneur Grafana..." -ForegroundColor Yellow
docker-compose rm -f grafana

Write-Host ""
Write-Host "3. Redemarrage de Grafana..." -ForegroundColor Yellow
docker-compose up -d grafana

Write-Host ""
Write-Host "4. Attente du demarrage (30 secondes)..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

Write-Host ""
Write-Host "5. Verification..." -ForegroundColor Yellow
docker-compose ps grafana

Write-Host ""
Write-Host "OK - Grafana redemarre avec le dashboard corrige" -ForegroundColor Green
Write-Host ""
Write-Host "Prochaines etapes:" -ForegroundColor Cyan
Write-Host "1. Ouvrir http://localhost:3001" -ForegroundColor White
Write-Host "2. Login: admin / admin" -ForegroundColor White
Write-Host "3. Aller dans Dashboards -> TicketStore Premium" -ForegroundColor White
Write-Host ""
