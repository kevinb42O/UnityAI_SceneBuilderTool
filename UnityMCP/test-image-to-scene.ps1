# ============================================================
# IMAGE-TO-SCENE SYSTEM TEST
# Tests all components of the image-to-scene pipeline
# ============================================================

# Import helper library
. "$PSScriptRoot\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " IMAGE-TO-SCENE SYSTEM TEST" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Test Unity connection
if (-not (Test-UnityConnection)) {
    Write-Host "[ERROR] Unity not connected. Please start Unity and the MCP server." -ForegroundColor Red
    exit 1
}

$testsPassed = 0
$testsFailed = 0

# ============================================================
# Test 1: Image Analysis Script Exists
# ============================================================

Write-Host "[TEST 1] Checking if image-to-scene.ps1 exists..." -ForegroundColor Yellow
if (Test-Path "$PSScriptRoot\image-to-scene.ps1") {
    Write-Host "[PASS] image-to-scene.ps1 found" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "[FAIL] image-to-scene.ps1 not found" -ForegroundColor Red
    $testsFailed++
}

Write-Host ""

# ============================================================
# Test 2: JSON Generator Script Exists
# ============================================================

Write-Host "[TEST 2] Checking if generate-scene-from-json.ps1 exists..." -ForegroundColor Yellow
if (Test-Path "$PSScriptRoot\generate-scene-from-json.ps1") {
    Write-Host "[PASS] generate-scene-from-json.ps1 found" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "[FAIL] generate-scene-from-json.ps1 not found" -ForegroundColor Red
    $testsFailed++
}

Write-Host ""

# ============================================================
# Test 3: Image Analyzer JS Module Exists
# ============================================================

Write-Host "[TEST 3] Checking if image-analyzer.js exists..." -ForegroundColor Yellow
if (Test-Path "$PSScriptRoot\image-analyzer.js") {
    Write-Host "[PASS] image-analyzer.js found" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "[FAIL] image-analyzer.js not found" -ForegroundColor Red
    $testsFailed++
}

Write-Host ""

# ============================================================
# Test 4: Documentation Exists
# ============================================================

Write-Host "[TEST 4] Checking documentation files..." -ForegroundColor Yellow

$docFiles = @(
    "IMAGE_TO_SCENE_GUIDE.md",
    "IMAGE_TO_SCENE_QUICK_START.md",
    "CURRENT_BUILDING_BLOCKS.md"
)

$allDocsExist = $true
foreach ($doc in $docFiles) {
    if (Test-Path "$PSScriptRoot\$doc") {
        Write-Host "  [OK] $doc found" -ForegroundColor Gray
    } else {
        Write-Host "  [MISSING] $doc not found" -ForegroundColor Red
        $allDocsExist = $false
    }
}

if ($allDocsExist) {
    Write-Host "[PASS] All documentation files exist" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "[FAIL] Some documentation files missing" -ForegroundColor Red
    $testsFailed++
}

Write-Host ""

# ============================================================
# Test 5: Example Data Generation (Simple Object)
# ============================================================

Write-Host "[TEST 5] Testing example data generation (object)..." -ForegroundColor Yellow

try {
    # Create a test image file (dummy)
    $testImagePath = "$PSScriptRoot\test-dummy-image.jpg"
    "dummy" | Out-File -FilePath $testImagePath -Encoding ASCII
    
    # This should generate example data without needing actual image
    $output = & "$PSScriptRoot\image-to-scene.ps1" `
        -ImagePath $testImagePath `
        -AnalysisType "object" `
        -UseExampleData 2>&1
    
    # Check if script generated successfully
    $generatedScript = Get-ChildItem "$PSScriptRoot\generated-scene-*.ps1" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    
    if ($generatedScript) {
        Write-Host "[PASS] Example data script generated: $($generatedScript.Name)" -ForegroundColor Green
        $testsPassed++
        
        # Clean up generated script
        Remove-Item $generatedScript.FullName -Force
    } else {
        Write-Host "[FAIL] Failed to generate script from example data" -ForegroundColor Red
        $testsFailed++
    }
    
    # Clean up test image
    if (Test-Path $testImagePath) {
        Remove-Item $testImagePath -Force
    }
} catch {
    Write-Host "[FAIL] Exception during example data test: $_" -ForegroundColor Red
    $testsFailed++
}

Write-Host ""

# ============================================================
# Test 6: JSON Validation (Single Object)
# ============================================================

Write-Host "[TEST 6] Testing JSON-to-script generation (single object)..." -ForegroundColor Yellow

try {
    # Create test JSON
    $testJson = @{
        type = "single_object"
        name = "TestObject"
        description = "Test object for validation"
        components = @(
            @{
                primitive = "Cube"
                position = @{ x = 0; y = 1; z = 0 }
                scale = @{ x = 1; y = 1; z = 1 }
                rotation = @{ x = 0; y = 0; z = 0 }
                material = @{
                    preset = "Stone_Gray"
                    color = $null
                    metallic = 0
                    smoothness = 0.5
                }
            }
        )
    }
    
    $testJsonPath = "$PSScriptRoot\test-analysis.json"
    $testJson | ConvertTo-Json -Depth 10 | Out-File -FilePath $testJsonPath -Encoding UTF8
    
    # Generate script from JSON (don't execute)
    & "$PSScriptRoot\generate-scene-from-json.ps1" -JsonPath $testJsonPath 2>&1 | Out-Null
    
    # Check if script was generated
    $generatedScript = Get-ChildItem "$PSScriptRoot\generated-scene-*.ps1" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    
    if ($generatedScript -and (Get-Date $generatedScript.LastWriteTime) -gt (Get-Date).AddMinutes(-1)) {
        Write-Host "[PASS] Script generated from JSON successfully" -ForegroundColor Green
        $testsPassed++
        
        # Clean up
        Remove-Item $generatedScript.FullName -Force
    } else {
        Write-Host "[FAIL] Failed to generate script from JSON" -ForegroundColor Red
        $testsFailed++
    }
    
    # Clean up test JSON
    if (Test-Path $testJsonPath) {
        Remove-Item $testJsonPath -Force
    }
} catch {
    Write-Host "[FAIL] Exception during JSON validation test: $_" -ForegroundColor Red
    $testsFailed++
}

Write-Host ""

# ============================================================
# Test 7: JSON Validation (Complete Scene)
# ============================================================

Write-Host "[TEST 7] Testing JSON-to-script generation (complete scene)..." -ForegroundColor Yellow

try {
    # Create test JSON for scene
    $testJson = @{
        type = "complete_scene"
        description = "Test scene"
        environment = @{
            terrain = "flat"
            ground_material = "Grass_Green"
            lighting = @{
                type = "Directional"
                intensity = 1.0
                color = @{ r = 1; g = 1; b = 1 }
                direction = @{ x = 0; y = -1; z = 0 }
            }
        }
        objects = @(
            @{
                name = "TestCube"
                primitive = "Cube"
                position = @{ x = 0; y = 1; z = 0 }
                scale = @{ x = 1; y = 1; z = 1 }
                material = @{ preset = "Concrete" }
            }
        )
    }
    
    $testJsonPath = "$PSScriptRoot\test-scene-analysis.json"
    $testJson | ConvertTo-Json -Depth 10 | Out-File -FilePath $testJsonPath -Encoding UTF8
    
    # Generate script from JSON (don't execute)
    & "$PSScriptRoot\generate-scene-from-json.ps1" -JsonPath $testJsonPath 2>&1 | Out-Null
    
    # Check if script was generated
    $generatedScript = Get-ChildItem "$PSScriptRoot\generated-scene-*.ps1" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    
    if ($generatedScript -and (Get-Date $generatedScript.LastWriteTime) -gt (Get-Date).AddMinutes(-1)) {
        Write-Host "[PASS] Scene script generated from JSON successfully" -ForegroundColor Green
        $testsPassed++
        
        # Clean up
        Remove-Item $generatedScript.FullName -Force
    } else {
        Write-Host "[FAIL] Failed to generate scene script from JSON" -ForegroundColor Red
        $testsFailed++
    }
    
    # Clean up test JSON
    if (Test-Path $testJsonPath) {
        Remove-Item $testJsonPath -Force
    }
} catch {
    Write-Host "[FAIL] Exception during scene JSON validation test: $_" -ForegroundColor Red
    $testsFailed++
}

Write-Host ""

# ============================================================
# Test 8: MCP Server Extension Check
# ============================================================

Write-Host "[TEST 8] Checking MCP server has image analysis tools..." -ForegroundColor Yellow

# Check if index.js contains the new tools
$indexPath = "$PSScriptRoot\index.js"
if (Test-Path $indexPath) {
    $indexContent = Get-Content $indexPath -Raw
    
    $hasAnalyzeTool = $indexContent -match "unity_analyze_image_for_scene"
    $hasGenerateTool = $indexContent -match "unity_generate_script_from_analysis"
    
    if ($hasAnalyzeTool -and $hasGenerateTool) {
        Write-Host "[PASS] MCP server includes image analysis tools" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "[FAIL] MCP server missing image analysis tools" -ForegroundColor Red
        $testsFailed++
    }
} else {
    Write-Host "[FAIL] index.js not found" -ForegroundColor Red
    $testsFailed++
}

Write-Host ""

# ============================================================
# Test 9: Building Blocks Documentation
# ============================================================

Write-Host "[TEST 9] Validating building blocks documentation..." -ForegroundColor Yellow

$buildingBlocksPath = "$PSScriptRoot\CURRENT_BUILDING_BLOCKS.md"
if (Test-Path $buildingBlocksPath) {
    $content = Get-Content $buildingBlocksPath -Raw
    
    # Check for key sections
    $hasToolInventory = $content -match "Core Building Blocks"
    $hasExpansion = $content -match "Expansion Strategy"
    $hasMaterialLibrary = $content -match "Material Library"
    
    if ($hasToolInventory -and $hasExpansion -and $hasMaterialLibrary) {
        Write-Host "[PASS] Building blocks documentation is comprehensive" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "[FAIL] Building blocks documentation incomplete" -ForegroundColor Red
        $testsFailed++
    }
} else {
    Write-Host "[FAIL] Building blocks documentation not found" -ForegroundColor Red
    $testsFailed++
}

Write-Host ""

# ============================================================
# Test 10: README Update Check
# ============================================================

Write-Host "[TEST 10] Checking README includes image-to-scene feature..." -ForegroundColor Yellow

$readmePath = "$PSScriptRoot\..\README.md"
if (Test-Path $readmePath) {
    $readmeContent = Get-Content $readmePath -Raw
    
    $hasImageFeature = $readmeContent -match "Image-to-Scene"
    $hasVLMReference = $readmeContent -match "VLM|Vision Language Model"
    $hasDocLinks = $readmeContent -match "IMAGE_TO_SCENE"
    
    if ($hasImageFeature -and $hasDocLinks) {
        Write-Host "[PASS] README updated with image-to-scene feature" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "[FAIL] README missing image-to-scene references" -ForegroundColor Red
        $testsFailed++
    }
} else {
    Write-Host "[FAIL] README.md not found" -ForegroundColor Red
    $testsFailed++
}

Write-Host ""

# ============================================================
# Test Results Summary
# ============================================================

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " TEST RESULTS SUMMARY" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

$totalTests = $testsPassed + $testsFailed
$passRate = [math]::Round(($testsPassed / $totalTests) * 100, 1)

Write-Host "Total Tests: $totalTests" -ForegroundColor White
Write-Host "Passed: $testsPassed" -ForegroundColor Green
Write-Host "Failed: $testsFailed" -ForegroundColor Red
Write-Host "Pass Rate: $passRate%" -ForegroundColor $(if ($passRate -ge 80) { "Green" } else { "Yellow" })
Write-Host ""

if ($testsFailed -eq 0) {
    Write-Host "============================================================" -ForegroundColor Green
    Write-Host " ALL TESTS PASSED!" -ForegroundColor Green
    Write-Host "============================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "The image-to-scene system is ready for use." -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Try the quick start guide: IMAGE_TO_SCENE_QUICK_START.md" -ForegroundColor White
    Write-Host "2. Test with example data: .\image-to-scene.ps1 -ImagePath test.jpg -UseExampleData" -ForegroundColor White
    Write-Host "3. Use with real VLM: Follow IMAGE_TO_SCENE_GUIDE.md" -ForegroundColor White
    Write-Host ""
    exit 0
} else {
    Write-Host "============================================================" -ForegroundColor Red
    Write-Host " SOME TESTS FAILED" -ForegroundColor Red
    Write-Host "============================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please review the failed tests above." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}
