param(
    [int]$DurationMinutes = 2,
    [int]$RequestsPerMinute = 30
)

$apiUrl = "http://localhost/api/events"
$endTime = (Get-Date).AddMinutes($DurationMinutes)
$delaySeconds = 60 / $RequestsPerMinute

Write-Host "Generation de trafic API pendant $DurationMinutes minutes..." -ForegroundColor Cyan
Write-Host "URL: $apiUrl" -ForegroundColor White
Write-Host "Requetes par minute: $RequestsPerMinute" -ForegroundColor White
Write-Host ""

$count = 0
$errors = 0

while ((Get-Date) -lt $endTime) {
    try {
        $response = Invoke-RestMethod -Uri $apiUrl -Method Get -TimeoutSec 10
        $count++
        $eventCount = $response.Count
        Write-Host "[$count] OK - Status: 200 - Events: $eventCount" -ForegroundColor Green
    }
    catch {
        $errors++
        Write-Host "[$count] ERREUR: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Start-Sleep -Seconds $delaySeconds
}

Write-Host ""
Write-Host "Termine !" -ForegroundColor Cyan
Write-Host "Total requetes: $count" -ForegroundColor White
Write-Host "Erreurs: $errors" -ForegroundColor $(if ($errors -gt 0) { "Red" } else { "Green" })
Write-Host ""
Write-Host "Attendez 1-2 minutes puis verifiez dans Grafana" -ForegroundColor Yellow
