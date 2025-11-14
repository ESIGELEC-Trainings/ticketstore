param(
    [int]$DurationMinutes = 2,
    [int]$RequestsPerMinute = 30
)

$url = "http://localhost:3000"
$endTime = (Get-Date).AddMinutes($DurationMinutes)
$delaySeconds = 60 / $RequestsPerMinute

Write-Host "Génération de trafic pendant $DurationMinutes minutes..."
Write-Host "URL: $url"
Write-Host "Requêtes par minute: $RequestsPerMinute"
Write-Host ""

$count = 0
while ((Get-Date) -lt $endTime) {
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 10
        $count++
        Write-Host "[$count] Requête OK - Status: $($response.StatusCode)" -ForegroundColor Green
    }
    catch {
        Write-Host "[$count] Erreur: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Start-Sleep -Seconds $delaySeconds
}

Write-Host ""
Write-Host "Terminé ! Total de requêtes: $count"