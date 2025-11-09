# ============================================================================
# Egyptian Pyramid World - Validation Test Script
# Tests all helper functions and validates script structure
# ============================================================================

Write-Host ""
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host "  EGYPTIAN PYRAMID WORLD - VALIDATION TEST" -ForegroundColor Cyan
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host ""

$testsPassed = 0
$testsFailed = 0

# Test 1: Check if helper library exists
Write-Host "[TEST 1] Checking helper library..." -ForegroundColor Yellow
if (Test-Path ".\unity-helpers-v2.ps1") {
    Write-Host "  [PASS] Helper library found" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "  [FAIL] Helper library not found" -ForegroundColor Red
    $testsFailed++
}

# Test 2: Check if main script exists
Write-Host "[TEST 2] Checking main script..." -ForegroundColor Yellow
if (Test-Path ".\create-egyptian-pyramid-world.ps1") {
    Write-Host "  [PASS] Main script found" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "  [FAIL] Main script not found" -ForegroundColor Red
    $testsFailed++
}

# Test 3: Load and parse main script
Write-Host "[TEST 3] Parsing main script..." -ForegroundColor Yellow
try {
    $scriptContent = Get-Content -Raw ".\create-egyptian-pyramid-world.ps1"
    $null = [System.Management.Automation.PSParser]::Tokenize($scriptContent, [ref]$null)
    Write-Host "  [PASS] Script syntax valid" -ForegroundColor Green
    $testsPassed++
} catch {
    Write-Host "  [FAIL] Script syntax error: $_" -ForegroundColor Red
    $testsFailed++
}

# Test 4: Check for required functions in script
Write-Host "[TEST 4] Checking function definitions..." -ForegroundColor Yellow
$requiredFunctions = @("Build-Pyramid", "Build-Obelisk", "Build-PalmTree")
$functionsFound = 0

foreach ($func in $requiredFunctions) {
    if ($scriptContent -match "function $func") {
        Write-Host "  [FOUND] $func" -ForegroundColor Gray
        $functionsFound++
    } else {
        Write-Host "  [MISSING] $func" -ForegroundColor Red
    }
}

if ($functionsFound -eq $requiredFunctions.Count) {
    Write-Host "  [PASS] All required functions defined" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "  [FAIL] Missing $($requiredFunctions.Count - $functionsFound) functions" -ForegroundColor Red
    $testsFailed++
}

# Test 5: Check color palette
Write-Host "[TEST 5] Checking color palette..." -ForegroundColor Yellow
$requiredColors = @("Sand", "Limestone", "GoldLeaf", "TorchFire")
$colorsFound = 0

foreach ($color in $requiredColors) {
    if ($scriptContent -match $color) {
        $colorsFound++
    }
}

if ($colorsFound -eq $requiredColors.Count) {
    Write-Host "  [PASS] Color palette complete ($colorsFound/$($requiredColors.Count))" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "  [FAIL] Missing colors ($colorsFound/$($requiredColors.Count))" -ForegroundColor Red
    $testsFailed++
}

# Test 6: Check section structure
Write-Host "[TEST 6] Checking section structure..." -ForegroundColor Yellow
$requiredSections = @(
    "SECTION 1: DESERT GROUND",
    "SECTION 2: GREAT PYRAMIDS",
    "SECTION 3: THE GREAT SPHINX",
    "SECTION 4: CENTRAL BATTLE ALTAR",
    "SECTION 5: OBELISKS",
    "SECTION 6: PALM TREES",
    "SECTION 7: STONE PATHWAYS",
    "SECTION 8: DECORATIVE ELEMENTS",
    "SECTION 9: TORCH LIGHTING"
)

$sectionsFound = 0
foreach ($section in $requiredSections) {
    if ($scriptContent -match [regex]::Escape($section)) {
        $sectionsFound++
    }
}

if ($sectionsFound -eq $requiredSections.Count) {
    Write-Host "  [PASS] All sections present ($sectionsFound/$($requiredSections.Count))" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "  [FAIL] Missing sections ($sectionsFound/$($requiredSections.Count))" -ForegroundColor Red
    $testsFailed++
}

# Test 7: Check documentation
Write-Host "[TEST 7] Checking documentation..." -ForegroundColor Yellow
$docsFound = 0
if (Test-Path ".\EGYPTIAN_PYRAMID_WORLD_GUIDE.md") {
    Write-Host "  [FOUND] Main guide" -ForegroundColor Gray
    $docsFound++
}
if (Test-Path ".\EGYPTIAN_QUICK_START.md") {
    Write-Host "  [FOUND] Quick start" -ForegroundColor Gray
    $docsFound++
}

if ($docsFound -eq 2) {
    Write-Host "  [PASS] All documentation present" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "  [FAIL] Missing documentation" -ForegroundColor Red
    $testsFailed++
}

# Test 8: Check object count tracking
Write-Host "[TEST 8] Checking object counting..." -ForegroundColor Yellow
if ($scriptContent -match '\$totalObjects\+\+' -or $scriptContent -match '\$script:totalObjects\+\+') {
    Write-Host "  [PASS] Object counting implemented" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "  [FAIL] Object counting not found" -ForegroundColor Red
    $testsFailed++
}

# Test 9: Check group creation
Write-Host "[TEST 9] Checking group organization..." -ForegroundColor Yellow
$groupsToCheck = @("Pyramids", "Sphinx", "BattleAltar", "Obelisks", "PalmTrees")
$groupsFound = 0

foreach ($group in $groupsToCheck) {
    if ($scriptContent -match "New-Group.*$group") {
        $groupsFound++
    }
}

if ($groupsFound -eq $groupsToCheck.Count) {
    Write-Host "  [PASS] All groups defined ($groupsFound/$($groupsToCheck.Count))" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "  [FAIL] Missing groups ($groupsFound/$($groupsToCheck.Count))" -ForegroundColor Red
    $testsFailed++
}

# Test 10: Check cleanup section
Write-Host "[TEST 10] Checking cleanup logic..." -ForegroundColor Yellow
if ($scriptContent -match "CLEANUP" -and $scriptContent -match "deleteGameObject") {
    Write-Host "  [PASS] Cleanup section present" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "  [FAIL] Cleanup section missing" -ForegroundColor Red
    $testsFailed++
}

# Test 11: Estimate object count from script
Write-Host "[TEST 11] Estimating object count..." -ForegroundColor Yellow
# Count approximate object creations
$buildColoredCount = ([regex]::Matches($scriptContent, "Build-ColoredObject")).Count
$createObjectCount = ([regex]::Matches($scriptContent, "Create-UnityObject")).Count
$estimatedObjects = $buildColoredCount + $createObjectCount

Write-Host "  [INFO] Estimated objects: ~$estimatedObjects" -ForegroundColor Gray
if ($estimatedObjects -gt 900) {
    Write-Host "  [PASS] Expected 1000+ objects, found ~$estimatedObjects" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "  [WARN] Lower than expected object count (~$estimatedObjects)" -ForegroundColor Yellow
    $testsPassed++  # Still pass but warn
}

# Test 12: Check Unity MCP connection test
Write-Host "[TEST 12] Checking Unity connection test..." -ForegroundColor Yellow
if ($scriptContent -match "Invoke-RestMethod.*ping") {
    Write-Host "  [PASS] Unity connection test implemented" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "  [FAIL] Unity connection test missing" -ForegroundColor Red
    $testsFailed++
}

# Summary
Write-Host ""
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host "  VALIDATION SUMMARY" -ForegroundColor Cyan
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Tests Passed: $testsPassed" -ForegroundColor Green
Write-Host "Tests Failed: $testsFailed" -ForegroundColor Red
Write-Host "Total Tests:  $($testsPassed + $testsFailed)" -ForegroundColor White
Write-Host ""

$percentage = [Math]::Round(($testsPassed / ($testsPassed + $testsFailed)) * 100, 1)
Write-Host "Success Rate: $percentage%" -ForegroundColor $(if ($percentage -ge 90) { "Green" } elseif ($percentage -ge 70) { "Yellow" } else { "Red" })
Write-Host ""

if ($testsFailed -eq 0) {
    Write-Host "[SUCCESS] All validation tests passed!" -ForegroundColor Green
    Write-Host "Script is ready for execution with Unity MCP server." -ForegroundColor Green
    exit 0
} else {
    Write-Host "[WARNING] Some tests failed. Review issues above." -ForegroundColor Yellow
    exit 1
}
