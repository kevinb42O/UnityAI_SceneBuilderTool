# Test Relative Scaling System for Castle Biome
# This script generates 3 castles at different world sizes to verify proportional scaling

Write-Host "=== TESTING RELATIVE SCALING SYSTEM ===" -ForegroundColor Cyan
Write-Host "Generating 3 castles at different scales to verify component proportions..." -ForegroundColor Yellow
Write-Host ""

$UNITY_BASE = "http://localhost:8765"

# Test 1: Small castle (worldSize = 100)
Write-Host "[TEST 1] Generating SMALL castle (worldSize=100, density=80)..." -ForegroundColor Green
$smallBody = @{
    biome = "Medieval"
    worldSize = 100
    density = 80
    seed = "SmallCastle2025"
} | ConvertTo-Json

try {
    $smallResult = Invoke-RestMethod -Uri "$UNITY_BASE/generateWorld" -Method Post -Body $smallBody -ContentType "application/json"
    Write-Host "[SUCCESS] Small castle: $($smallResult.totalObjects) objects in $([math]::Round($smallResult.generationTime, 2))s" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to generate small castle: $_" -ForegroundColor Red
    exit 1
}

Start-Sleep -Seconds 2

# Test 2: Medium castle (worldSize = 200)
Write-Host "[TEST 2] Generating MEDIUM castle (worldSize=200, density=80)..." -ForegroundColor Green
$mediumBody = @{
    biome = "Medieval"
    worldSize = 200
    density = 80
    seed = "MediumCastle2025"
} | ConvertTo-Json

try {
    $mediumResult = Invoke-RestMethod -Uri "$UNITY_BASE/generateWorld" -Method Post -Body $mediumBody -ContentType "application/json"
    Write-Host "[SUCCESS] Medium castle: $($mediumResult.totalObjects) objects in $([math]::Round($mediumResult.generationTime, 2))s" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to generate medium castle: $_" -ForegroundColor Red
    exit 1
}

Start-Sleep -Seconds 2

# Test 3: Large castle (worldSize = 300)
Write-Host "[TEST 3] Generating LARGE castle (worldSize=300, density=100)..." -ForegroundColor Green
$largeBody = @{
    biome = "Medieval"
    worldSize = 300
    density = 100
    seed = "LargeCastle2025"
} | ConvertTo-Json

try {
    $largeResult = Invoke-RestMethod -Uri "$UNITY_BASE/generateWorld" -Method Post -Body $largeBody -ContentType "application/json"
    Write-Host "[SUCCESS] Large castle: $($largeResult.totalObjects) objects in $([math]::Round($largeResult.generationTime, 2))s" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to generate large castle: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== SCALING TEST COMPLETE ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "RESULTS:" -ForegroundColor Yellow
Write-Host "  Small (100):  $($smallResult.totalObjects) objects" -ForegroundColor White
Write-Host "  Medium (200): $($mediumResult.totalObjects) objects (should be ~same)" -ForegroundColor White
Write-Host "  Large (300):  $($largeResult.totalObjects) objects (slightly more due to density 100)" -ForegroundColor White
Write-Host ""
Write-Host "VERIFICATION:" -ForegroundColor Yellow
Write-Host "  1. Check Unity Scene Hierarchy - should see 3 Medieval worlds" -ForegroundColor White
Write-Host "  2. All castle components should scale proportionally" -ForegroundColor White
Write-Host "  3. Towers, walls, keep, gatehouse should maintain consistent ratios" -ForegroundColor White
Write-Host "  4. Village buildings should scale with castle architecture" -ForegroundColor White
Write-Host "  5. Roads and props should match building scales" -ForegroundColor White
Write-Host ""
Write-Host "[NEXT STEP] Manually inspect castle proportions in Unity Editor" -ForegroundColor Cyan
