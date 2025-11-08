# ============================================================
# DEMO: Complete Realtime World Generation
# Showcases all 10 biome types with full world generation
# ============================================================

# Import helper library
. "$PSScriptRoot\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  REALTIME WORLD GENERATION DEMO" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test connection
if (-not (Test-UnityConnection)) {
    exit 1
}

Write-Host ""
Write-Host "[DEMO] This demonstration will generate 3 different worlds" -ForegroundColor Green
Write-Host "       Press Ctrl+C to skip any world generation" -ForegroundColor Gray
Write-Host ""

# ============================================================
# WORLD 1: Fantasy Forest
# ============================================================

Write-Host ""
Write-Host "================================================" -ForegroundColor Yellow
Write-Host " WORLD 1: Fantasy Forest (Magical Trees)" -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Yellow

$world1 = New-World -biome "Fantasy" -worldSize 80 -density 40

if ($world1) {
    Write-Host ""
    Write-Host "[WORLD 1] Complete! Check Unity to see glowing magical trees and crystals" -ForegroundColor Green
    Write-Host ""
    Start-Sleep -Seconds 3
}

# ============================================================
# WORLD 2: Medieval Village
# ============================================================

Write-Host ""
Write-Host "================================================" -ForegroundColor Yellow
Write-Host " WORLD 2: Medieval Village (Castle & Houses)" -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Yellow

# Clear scene first
try {
    Invoke-RestMethod -Uri "$UNITY_BASE/newScene" -Method POST -UseBasicParsing | Out-Null
    Write-Host "[INFO] Scene cleared for new world" -ForegroundColor Gray
    Write-Host ""
}
catch {
    Write-Host "[WARN] Could not clear scene" -ForegroundColor Yellow
}

$world2 = New-World -biome "Medieval" -worldSize 100 -density 50

if ($world2) {
    Write-Host ""
    Write-Host "[WORLD 2] Complete! Check Unity to see castle with towers and village houses" -ForegroundColor Green
    Write-Host ""
    Start-Sleep -Seconds 3
}

# ============================================================
# WORLD 3: Sci-Fi City
# ============================================================

Write-Host ""
Write-Host "================================================" -ForegroundColor Yellow
Write-Host " WORLD 3: Sci-Fi City (Futuristic Buildings)" -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Yellow

# Clear scene first
try {
    Invoke-RestMethod -Uri "$UNITY_BASE/newScene" -Method POST -UseBasicParsing | Out-Null
    Write-Host "[INFO] Scene cleared for new world" -ForegroundColor Gray
    Write-Host ""
}
catch {
    Write-Host "[WARN] Could not clear scene" -ForegroundColor Yellow
}

$world3 = New-World -biome "SciFi" -worldSize 120 -density 60

if ($world3) {
    Write-Host ""
    Write-Host "[WORLD 3] Complete! Check Unity to see metallic structures with glowing elements" -ForegroundColor Green
    Write-Host ""
}

# ============================================================
# COMPLETION SUMMARY
# ============================================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " WORLD GENERATION DEMO COMPLETE!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$totalObjects = 0
if ($world1) { $totalObjects += $world1.totalObjects }
if ($world2) { $totalObjects += $world2.totalObjects }
if ($world3) { $totalObjects += $world3.totalObjects }

Write-Host "Demonstration Summary:" -ForegroundColor Yellow
Write-Host "  [1] Fantasy Forest - Magical trees, glowing crystals" -ForegroundColor White
Write-Host "  [2] Medieval Village - Castle with towers, village houses" -ForegroundColor White
Write-Host "  [3] Sci-Fi City - Futuristic buildings, glowing energy cores" -ForegroundColor White
Write-Host ""
Write-Host "Total Objects Generated: $totalObjects" -ForegroundColor Green
Write-Host ""

Write-Host "Available Biomes:" -ForegroundColor Cyan
Write-Host "  - Forest      - Lush trees and greenery" -ForegroundColor White
Write-Host "  - Desert      - Sand dunes and cacti" -ForegroundColor White
Write-Host "  - City        - Modern urban buildings" -ForegroundColor White
Write-Host "  - Medieval    - Castles and villages" -ForegroundColor White
Write-Host "  - SciFi       - Futuristic structures" -ForegroundColor White
Write-Host "  - Fantasy     - Magical environments" -ForegroundColor White
Write-Host "  - Underwater  - Coral and aquatic life" -ForegroundColor White
Write-Host "  - Arctic      - Ice formations" -ForegroundColor White
Write-Host "  - Jungle      - Dense vegetation" -ForegroundColor White
Write-Host "  - Wasteland   - Post-apocalyptic ruins" -ForegroundColor White
Write-Host ""

Write-Host "Try creating your own world:" -ForegroundColor Yellow
Write-Host "  New-World -biome 'Forest' -worldSize 100 -density 50" -ForegroundColor Gray
Write-Host ""

Write-Host "This is REALTIME WORLD GENERATION for Unity." -ForegroundColor Cyan
Write-Host ""
