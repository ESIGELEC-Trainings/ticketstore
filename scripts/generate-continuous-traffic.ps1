param(
    [int]$RequestsPerMinute = 60
)

$apiUrl = "http://localhost/api/events"
$delaySeconds = 60 / $RequestsPerMinute

Write-Host "=== GENERATION DE TRAFIC CONTINU ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "URL: $apiUrl" -ForegroundColor White
Write-Host "Requetes par minute: $RequestsPerMinute" -ForegroundColor White
Write-Host ""
Write-Host "Appuyez sur Ctrl+C pour arreter" -ForegroundColor Yellow
Write-Host ""

$count = 0
$errors = 0
$startTime = Get-Date

try {
    while ($true) {
        try {
            $response = Invoke-RestMethod -Uri $apiUrl -Method Get -TimeoutSec 10
            $count++
            $eventCount = $response.Count
            $elapsed = [math]::Round(((Get-Date) - $startTime).TotalMinutes, 1)
            
            Write-Host "[$count] OK - Events: $eventCount - Temps ecoule: $elapsed min" -ForegroundColor Green
        }
        catch {
            $errors++
            Write-Host "[$count] ERREUR: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        Start-Sleep -Seconds $delaySeconds
    }
}
finally {
    $elapsed = [math]::Round(((Get-Date) - $startTime).TotalMinutes, 1)
    Write-Host ""
    Write-Host "=== ARRET ===" -ForegroundColor Cyan
    Write-Host "Duree totale: $elapsed minutes" -ForegroundColor White
    Write-Host "Total requetes: $count" -ForegroundColor White
    Write-Host "Erreurs: $errors" -ForegroundColor $(if ($errors -gt 0) { "Red" } else { "Green" })
    Write-Host ""
}
