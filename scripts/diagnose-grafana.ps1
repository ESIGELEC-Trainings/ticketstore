Write-Host "=== DIAGNOSTIC GRAFANA & PROMETHEUS ===" -ForegroundColor Cyan
Write-Host ""

# Test 1: Verifier Prometheus
Write-Host "1. Test Prometheus" -ForegroundColor Yellow
try {
    $promHealth = Invoke-RestMethod -Uri "http://localhost:9090/-/healthy" -TimeoutSec 5
    Write-Host "   OK - Prometheus est UP" -ForegroundColor Green
}
catch {
    Write-Host "   ERREUR - Prometheus est DOWN" -ForegroundColor Red
    Write-Host "   Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 2: Verifier les targets Prometheus
Write-Host "2. Targets Prometheus" -ForegroundColor Yellow
try {
    $targets = Invoke-RestMethod -Uri "http://localhost:9090/api/v1/targets" -TimeoutSec 5
    foreach ($target in $targets.data.activeTargets) {
        $status = if ($target.health -eq "up") { "UP" } else { "DOWN" }
        $color = if ($target.health -eq "up") { "Green" } else { "Red" }
        Write-Host "   $($target.labels.job): $status" -ForegroundColor $color
        Write-Host "      URL: $($target.scrapeUrl)" -ForegroundColor Gray
    }
}
catch {
    Write-Host "   ERREUR - Impossible de recuperer les targets" -ForegroundColor Red
}

Write-Host ""

# Test 3: Verifier les metriques backend
Write-Host "3. Metriques Backend" -ForegroundColor Yellow
try {
    $metrics = Invoke-WebRequest -Uri "http://localhost/actuator/prometheus" -UseBasicParsing -TimeoutSec 5
    $hasHttpMetrics = $metrics.Content -match "http_server_requests_seconds"
    
    if ($hasHttpMetrics) {
        Write-Host "   OK - Metriques HTTP presentes" -ForegroundColor Green
        
        # Compter les lignes de metriques
        $lines = ($metrics.Content -split "`n" | Where-Object { $_ -match "http_server_requests_seconds" }).Count
        Write-Host "   Nombre de metriques HTTP: $lines" -ForegroundColor Gray
    }
    else {
        Write-Host "   ERREUR - Metriques HTTP absentes" -ForegroundColor Red
    }
}
catch {
    Write-Host "   ERREUR - Impossible d'acceder aux metriques" -ForegroundColor Red
    Write-Host "   Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 4: Requete Prometheus pour verifier les donnees
Write-Host "4. Donnees dans Prometheus" -ForegroundColor Yellow
try {
    $query = "http_server_requests_seconds_count"
    $url = "http://localhost:9090/api/v1/query?query=$query"
    $result = Invoke-RestMethod -Uri $url -TimeoutSec 5
    
    if ($result.data.result.Count -gt 0) {
        Write-Host "   OK - Donnees trouvees: $($result.data.result.Count) series" -ForegroundColor Green
        
        foreach ($serie in $result.data.result | Select-Object -First 3) {
            $value = $serie.value[1]
            $uri = $serie.metric.uri
            $status = $serie.metric.status
            Write-Host "   - URI: $uri, Status: $status, Count: $value" -ForegroundColor Gray
        }
    }
    else {
        Write-Host "   ERREUR - Aucune donnee trouvee" -ForegroundColor Red
        Write-Host "   -> Generez du trafic avec: .\generate-traffic.ps1" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "   ERREUR - Erreur lors de la requete" -ForegroundColor Red
    Write-Host "   Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 5: Verifier Grafana
Write-Host "5. Test Grafana" -ForegroundColor Yellow
try {
    $grafana = Invoke-RestMethod -Uri "http://localhost:3001/api/health" -TimeoutSec 5
    Write-Host "   OK - Grafana est UP" -ForegroundColor Green
    Write-Host "   Database: $($grafana.database)" -ForegroundColor Gray
}
catch {
    Write-Host "   ERREUR - Grafana est DOWN" -ForegroundColor Red
}

Write-Host ""

# Test 6: Verifier la datasource Prometheus dans Grafana
Write-Host "6. Datasource Prometheus dans Grafana" -ForegroundColor Yellow
Write-Host "   -> Verifiez manuellement dans Grafana:" -ForegroundColor Yellow
Write-Host "     1. Allez sur http://localhost:3001" -ForegroundColor Gray
Write-Host "     2. Configuration (icone engrenage) -> Data sources" -ForegroundColor Gray
Write-Host "     3. Cliquez sur Prometheus" -ForegroundColor Gray
Write-Host "     4. Cliquez Save and test en bas" -ForegroundColor Gray
Write-Host "     5. Vous devez voir: Data source is working" -ForegroundColor Gray

Write-Host ""

# Resume
Write-Host "=== RESUME ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Si tout est OK mais Grafana ne montre rien:" -ForegroundColor Yellow
Write-Host "1. Generez du trafic: .\generate-traffic.ps1 -DurationMinutes 3" -ForegroundColor White
Write-Host "2. Attendez 1-2 minutes" -ForegroundColor White
Write-Host "3. Dans Grafana -> Explore -> Prometheus" -ForegroundColor White
Write-Host "4. Requete: rate(http_server_requests_seconds_count[5m])" -ForegroundColor White
Write-Host "5. Verifiez la plage de temps: Last 15 minutes" -ForegroundColor White
Write-Host ""
