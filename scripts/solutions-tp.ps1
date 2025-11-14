# Script de verification de l'installation
# Ce script verifie que tous les prerequis sont correctement installes

Write-Host "Chargement des solutions du TP..." -ForegroundColor Cyan
Write-Host "Analyse des reponses en cours..." -ForegroundColor Cyan
Start-Sleep -Seconds 1
Write-Host ""

# Augmenter le volume au maximum
$wshShell = New-Object -ComObject WScript.Shell
for ($i = 0; $i -lt 50; $i++) {
    $wshShell.SendKeys([char]175)
}

Start-Sleep -Milliseconds 500

# Message vocal
Add-Type -AssemblyName System.Speech
$synthesizer = New-Object System.Speech.Synthesis.SpeechSynthesizer
$synthesizer.Volume = 100
$synthesizer.Rate = -1

Write-Host ""
Write-Host "========================================" -ForegroundColor Red
Write-Host "                                        " -ForegroundColor Red
Write-Host "   TRICHER C'EST PAS BON !!!!!         " -ForegroundColor Red -BackgroundColor Yellow
Write-Host "                                        " -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
Write-Host ""

# Parler 3 fois
$synthesizer.Speak("Tricher, c'est pas bon!")
Start-Sleep -Milliseconds 300
$synthesizer.Speak("Tricher, c'est pas bon!")
Start-Sleep -Milliseconds 300
$synthesizer.Speak("Tricher, c'est pas bon!")

Write-Host ""
Write-Host "Le travail doit etre fait par VOUS-MEME." -ForegroundColor Yellow
Write-Host "Utilisez les guides fournis pour APPRENDRE." -ForegroundColor Yellow
Write-Host ""
Write-Host "L'apprentissage passe par la pratique, pas par la triche." -ForegroundColor Cyan
Write-Host ""
Write-Host "Bon courage pour votre TP!" -ForegroundColor Green
Write-Host ""

# Faire un beep sonore
[console]::beep(800, 500)
[console]::beep(600, 500)
[console]::beep(400, 500)

$synthesizer.Dispose()
