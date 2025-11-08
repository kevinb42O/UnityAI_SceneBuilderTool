# ============================================================================
# PARKOUR COURSE TEST & VALIDATION
# Validates all 7 phases of the parkour course implementation
# ============================================================================

. ".\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  PARKOUR COURSE TEST & VALIDATION" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

# Test connection
try {
    $null = Invoke-RestMethod -Uri "http://localhost:8765/ping" -Method POST -ContentType "application/json" -Body '{}' -UseBasicParsing -ErrorAction Stop
    Write-Host "[OK] Unity MCP server connected" -ForegroundColor Green
} catch {
    Write-Host "[FATAL] Unity MCP server not running!" -ForegroundColor Red
    exit 1
}

$testsPassed = 0
$testsFailed = 0

# Helper function to test object exists
function Test-ObjectExists {
    param([string]$name)
    
    try {
        $body = @{ query = $name; maxResults = 1 } | ConvertTo-Json
        $result = Invoke-RestMethod -Uri "http://localhost:8765/queryScene" `
            -Method POST -ContentType "application/json" `
            -Body $body -UseBasicParsing
        
        if ($result.objects -and $result.objects.Count -gt 0) {
            return $true
        }
        return $false
    } catch {
        return $false
    }
}

# Helper function to count objects with prefix
function Count-ObjectsWithPrefix {
    param([string]$prefix)
    
    try {
        $body = @{ query = $prefix; maxResults = 500 } | ConvertTo-Json
        $result = Invoke-RestMethod -Uri "http://localhost:8765/queryScene" `
            -Method POST -ContentType "application/json" `
            -Body $body -UseBasicParsing
        
        if ($result.objects) {
            return $result.objects.Count
        }
        return 0
    } catch {
        return 0
    }
}

Write-Host ""
Write-Host "=== PHASE 2: GROUND ROAD SYSTEM TESTS ===" -ForegroundColor Magenta

# Test road segments
Write-Host "  [TEST] Checking road segments..." -ForegroundColor Gray
$roadCount = Count-ObjectsWithPrefix "Road_"
if ($roadCount -ge 50) {
    Write-Host "    [PASS] Found $roadCount road segments (expected 60+)" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] Found only $roadCount road segments (expected 60+)" -ForegroundColor Red
    $testsFailed++
}

# Test road markers
Write-Host "  [TEST] Checking road markers..." -ForegroundColor Gray
$markerCount = Count-ObjectsWithPrefix "RoadMarker_"
if ($markerCount -ge 30) {
    Write-Host "    [PASS] Found $markerCount road markers (expected 32: 16 posts + 16 orbs)" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] Found only $markerCount road markers (expected 32)" -ForegroundColor Red
    $testsFailed++
}

# Test parent group
Write-Host "  [TEST] Checking ParkourRoads group..." -ForegroundColor Gray
if (Test-ObjectExists "ParkourRoads") {
    Write-Host "    [PASS] ParkourRoads group exists" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] ParkourRoads group not found" -ForegroundColor Red
    $testsFailed++
}

Write-Host ""
Write-Host "=== PHASE 3: ELEVATED PARKOUR ELEMENTS TESTS ===" -ForegroundColor Magenta

# Test castle to bridge platforms
Write-Host "  [TEST] Checking castle-to-bridge platforms..." -ForegroundColor Gray
if (Test-ObjectExists "Platform_Castle_Bridge3") {
    Write-Host "    [PASS] Castle-to-bridge platforms found" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] Castle-to-bridge platforms missing" -ForegroundColor Red
    $testsFailed++
}

# Test stepping stones
Write-Host "  [TEST] Checking aerial stepping stones..." -ForegroundColor Gray
$stoneCount = Count-ObjectsWithPrefix "SteppingStone_"
if ($stoneCount -ge 20) {
    Write-Host "    [PASS] Found $stoneCount stepping stones (expected 24)" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] Found only $stoneCount stepping stones (expected 24)" -ForegroundColor Red
    $testsFailed++
}

# Test ParkourPlatforms group
Write-Host "  [TEST] Checking ParkourPlatforms group..." -ForegroundColor Gray
if (Test-ObjectExists "ParkourPlatforms") {
    Write-Host "    [PASS] ParkourPlatforms group exists" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] ParkourPlatforms group not found" -ForegroundColor Red
    $testsFailed++
}

Write-Host ""
Write-Host "=== PHASE 4: FLOATING ISLAND ENHANCEMENT TESTS ===" -ForegroundColor Magenta

# Test island trees
Write-Host "  [TEST] Checking island trees..." -ForegroundColor Gray
$treeCount = Count-ObjectsWithPrefix "Island1_Tree_"
$treeCount += Count-ObjectsWithPrefix "Island2_Tree_"
$treeCount += Count-ObjectsWithPrefix "Island3_Tree_"
if ($treeCount -ge 20) {
    Write-Host "    [PASS] Found $treeCount tree objects (expected ~27 trunks+canopies)" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] Found only $treeCount tree objects (expected ~27)" -ForegroundColor Red
    $testsFailed++
}

# Test inter-island bridges
Write-Host "  [TEST] Checking inter-island bridges..." -ForegroundColor Gray
$bridgeCount = Count-ObjectsWithPrefix "Bridge_I"
if ($bridgeCount -ge 15) {
    Write-Host "    [PASS] Found $bridgeCount bridge platforms (expected 20)" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] Found only $bridgeCount bridge platforms (expected 20)" -ForegroundColor Red
    $testsFailed++
}

# Test groups
Write-Host "  [TEST] Checking island groups..." -ForegroundColor Gray
if ((Test-ObjectExists "IslandTrees") -and (Test-ObjectExists "IslandBridges")) {
    Write-Host "    [PASS] IslandTrees and IslandBridges groups exist" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] Island groups not found" -ForegroundColor Red
    $testsFailed++
}

Write-Host ""
Write-Host "=== PHASE 5: TOWER INTEGRATION TESTS ===" -ForegroundColor Magenta

# Test tower spiral platforms
Write-Host "  [TEST] Checking tower spiral platforms..." -ForegroundColor Gray
$spiralCount = Count-ObjectsWithPrefix "TowerSpiral_"
if ($spiralCount -ge 14) {
    Write-Host "    [PASS] Found $spiralCount spiral platforms (expected 16)" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] Found only $spiralCount spiral platforms (expected 16)" -ForegroundColor Red
    $testsFailed++
}

# Test descent platforms
Write-Host "  [TEST] Checking descent platforms..." -ForegroundColor Gray
$descentCount = Count-ObjectsWithPrefix "Descent_"
if ($descentCount -ge 20) {
    Write-Host "    [PASS] Found $descentCount descent platforms (expected 24)" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] Found only $descentCount descent platforms (expected 24)" -ForegroundColor Red
    $testsFailed++
}

# Test TowerParkour group
Write-Host "  [TEST] Checking TowerParkour group..." -ForegroundColor Gray
if (Test-ObjectExists "TowerParkour") {
    Write-Host "    [PASS] TowerParkour group exists" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] TowerParkour group not found" -ForegroundColor Red
    $testsFailed++
}

Write-Host ""
Write-Host "=== PHASE 6: FOREST INTEGRATION TESTS ===" -ForegroundColor Magenta

# Test forest platforms
Write-Host "  [TEST] Checking forest platforms..." -ForegroundColor Gray
$forestCount = Count-ObjectsWithPrefix "ForestPlatform_"
if ($forestCount -ge 12) {
    Write-Host "    [PASS] Found $forestCount forest platforms (expected 14)" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] Found only $forestCount forest platforms (expected 14)" -ForegroundColor Red
    $testsFailed++
}

# Test ForestParkour group
Write-Host "  [TEST] Checking ForestParkour group..." -ForegroundColor Gray
if (Test-ObjectExists "ForestParkour") {
    Write-Host "    [PASS] ForestParkour group exists" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] ForestParkour group not found" -ForegroundColor Red
    $testsFailed++
}

Write-Host ""
Write-Host "=== PHASE 7: FINALIZATION TESTS ===" -ForegroundColor Magenta

# Test start platform
Write-Host "  [TEST] Checking start platform..." -ForegroundColor Gray
if ((Test-ObjectExists "StartPlatform") -and (Test-ObjectExists "StartBeacon")) {
    Write-Host "    [PASS] Start platform and beacon found" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] Start platform or beacon missing" -ForegroundColor Red
    $testsFailed++
}

# Test finish platform
Write-Host "  [TEST] Checking finish platform..." -ForegroundColor Gray
if ((Test-ObjectExists "FinishPlatform") -and (Test-ObjectExists "FinishBeacon")) {
    Write-Host "    [PASS] Finish platform and beacon found" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] Finish platform or beacon missing" -ForegroundColor Red
    $testsFailed++
}

# Test checkpoints
Write-Host "  [TEST] Checking checkpoint markers..." -ForegroundColor Gray
$checkpointCount = Count-ObjectsWithPrefix "CP_"
if ($checkpointCount -ge 40) {
    Write-Host "    [PASS] Found $checkpointCount checkpoint objects (expected 42: 21 pillars + 21 orbs)" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] Found only $checkpointCount checkpoint objects (expected 42)" -ForegroundColor Red
    $testsFailed++
}

# Test directional arrows
Write-Host "  [TEST] Checking directional arrows..." -ForegroundColor Gray
$arrowCount = Count-ObjectsWithPrefix "Arrow_"
if ($arrowCount -ge 8) {
    Write-Host "    [PASS] Found $arrowCount arrow objects (expected 10: 5 shafts + 5 heads)" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] Found only $arrowCount arrow objects (expected 10)" -ForegroundColor Red
    $testsFailed++
}

# Test ParkourCheckpoints group
Write-Host "  [TEST] Checking ParkourCheckpoints group..." -ForegroundColor Gray
if (Test-ObjectExists "ParkourCheckpoints") {
    Write-Host "    [PASS] ParkourCheckpoints group exists" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [FAIL] ParkourCheckpoints group not found" -ForegroundColor Red
    $testsFailed++
}

Write-Host ""
Write-Host "=== INTEGRATION TESTS ===" -ForegroundColor Magenta

# Test world compatibility
Write-Host "  [TEST] Checking base world compatibility..." -ForegroundColor Gray
if ((Test-ObjectExists "MedievalCastle") -and (Test-ObjectExists "FloatingIslands")) {
    Write-Host "    [PASS] Base world structures found" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "    [WARN] Base world not found - run create-ultimate-complete-world.ps1 first" -ForegroundColor Yellow
    # Don't count as fail since it's optional for standalone test
}

# Test total object count
Write-Host "  [TEST] Estimating total parkour objects..." -ForegroundColor Gray
$totalEstimate = $roadCount + $markerCount + $stoneCount + $treeCount + $bridgeCount + 
                 $spiralCount + $descentCount + $forestCount + $checkpointCount + $arrowCount + 20
Write-Host "    [INFO] Estimated parkour objects: ~$totalEstimate (expected 279+)" -ForegroundColor Cyan

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  TEST RESULTS" -ForegroundColor White
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Tests Passed: $testsPassed" -ForegroundColor Green
Write-Host "  Tests Failed: $testsFailed" -ForegroundColor $(if ($testsFailed -gt 0) { "Red" } else { "Green" })
Write-Host "  Pass Rate: $([Math]::Round($testsPassed * 100.0 / ($testsPassed + $testsFailed), 1))%" -ForegroundColor White
Write-Host ""

if ($testsFailed -eq 0) {
    Write-Host "  [SUCCESS] All tests passed! Parkour course is ready!" -ForegroundColor Green
    Write-Host "  Try the complete route in Unity!" -ForegroundColor Green
} else {
    Write-Host "  [FAILURE] Some tests failed. Check implementation." -ForegroundColor Red
    Write-Host "  Review errors above and re-run create-parkour-course.ps1" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

# Exit with appropriate code
if ($testsFailed -gt 0) {
    exit 1
} else {
    exit 0
}
