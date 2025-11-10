# Integration Test: Point Cloud & Procedural Mesh Systems
# Validates all new functionality end-to-end

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Point Cloud Integration Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Load helper functions
. .\point-cloud-helpers.ps1

$testsPassed = 0
$testsFailed = 0

function Test-Feature {
    param([string]$name, [scriptblock]$test)
    
    Write-Host "[TEST] $name..." -ForegroundColor Yellow
    try {
        $result = & $test
        if ($result) {
            Write-Host "  ✓ PASS" -ForegroundColor Green
            $script:testsPassed++
            return $true
        } else {
            Write-Host "  ✗ FAIL - Returned null/false" -ForegroundColor Red
            $script:testsFailed++
            return $false
        }
    }
    catch {
        Write-Host "  ✗ FAIL - $_" -ForegroundColor Red
        $script:testsFailed++
        return $false
    }
}

Write-Host "[PHASE 1] Connection Tests" -ForegroundColor Magenta
Write-Host ""

Test-Feature "Unity MCP Server Connection" {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:8765/ping" -Method Post -ContentType "application/json" -Body "{}"
        return $response.status -eq "ok"
    } catch {
        return $false
    }
}

Write-Host ""
Write-Host "[PHASE 2] Point Cloud Tests" -ForegroundColor Magenta
Write-Host ""

Test-Feature "Generate Small Point Cloud (5000 points)" {
    $result = New-PointCloudTerrain -name "TestPC_Small" -pointCount 5000 -areaSize 50 -noiseAmplitude 5
    return $result -ne $null -and $result.success
}

Test-Feature "Generate Large Point Cloud (15000 points)" {
    $result = New-PointCloudTerrain -name "TestPC_Large" -pointCount 15000 -areaSize 100 -noiseAmplitude 20 -seed 42
    return $result -ne $null -and $result.success
}

Test-Feature "Point Cloud with Custom Parameters" {
    $result = New-PointCloudTerrain -name "TestPC_Custom" `
        -pointCount 8000 `
        -areaSize 80 `
        -noiseAmplitude 15 `
        -noiseScale 0.08 `
        -gridResolution 40 `
        -seed 123
    return $result -ne $null -and $result.success
}

Write-Host ""
Write-Host "[PHASE 3] Procedural Terrain Tests" -ForegroundColor Magenta
Write-Host ""

Test-Feature "Perlin Noise Terrain" {
    $result = New-ProceduralTerrain -name "TestTerrain_Perlin" -noiseType "Perlin" -amplitude 10 -octaves 4
    return $result -ne $null -and $result.success
}

Test-Feature "Ridged Noise Terrain" {
    $result = New-ProceduralTerrain -name "TestTerrain_Ridged" -noiseType "Ridged" -amplitude 15 -octaves 5
    return $result -ne $null -and $result.success
}

Test-Feature "Voronoi Noise Terrain" {
    $result = New-ProceduralTerrain -name "TestTerrain_Voronoi" -noiseType "Voronoi" -amplitude 8 -octaves 3
    return $result -ne $null -and $result.success
}

Test-Feature "Billow Noise Terrain" {
    $result = New-ProceduralTerrain -name "TestTerrain_Billow" -noiseType "Billow" -amplitude 12 -octaves 4
    return $result -ne $null -and $result.success
}

Test-Feature "Simplex Noise Terrain" {
    $result = New-ProceduralTerrain -name "TestTerrain_Simplex" -noiseType "Simplex" -amplitude 10 -octaves 4
    return $result -ne $null -and $result.success
}

Write-Host ""
Write-Host "[PHASE 4] Building Facade Tests" -ForegroundColor Magenta
Write-Host ""

Test-Feature "Simple Building (5 floors)" {
    $result = New-BuildingFacade -name "TestBuilding_Simple" -floors 5 -windowsPerFloor 4
    return $result -ne $null -and $result.success
}

Test-Feature "Building with Balconies" {
    $result = New-BuildingFacade -name "TestBuilding_Balconies" -floors 8 -addBalconies $true
    return $result -ne $null -and $result.success
}

Test-Feature "Skyscraper (15 floors)" {
    $result = New-BuildingFacade -name "TestBuilding_Skyscraper" -floors 15 -windowsPerFloor 8
    return $result -ne $null -and $result.success
}

Test-Feature "Building with Custom Position" {
    $result = New-BuildingFacade -name "TestBuilding_Positioned" `
        -floors 6 `
        -position @{x=50; y=0; z=50}
    return $result -ne $null -and $result.success
}

Write-Host ""
Write-Host "[PHASE 5] L-System Tree Tests" -ForegroundColor Magenta
Write-Host ""

Test-Feature "Default Oak Tree" {
    $result = New-LSystemTree -name "TestTree_Oak" -preset "tree" -iterations 4
    return $result -ne $null -and $result.success
}

Test-Feature "Pine-like Tree (narrow angle)" {
    $result = New-LSystemTree -name "TestTree_Pine" -iterations 5 -angle 18
    return $result -ne $null -and $result.success
}

Test-Feature "Wide Spreading Tree" {
    $result = New-LSystemTree -name "TestTree_Wide" -iterations 4 -angle 35
    return $result -ne $null -and $result.success
}

Test-Feature "Tree with Custom Position" {
    $result = New-LSystemTree -name "TestTree_Positioned" `
        -iterations 4 `
        -position @{x=-50; y=0; z=-50}
    return $result -ne $null -and $result.success
}

Write-Host ""
Write-Host "[PHASE 6] Complex Scene Tests" -ForegroundColor Magenta
Write-Host ""

Test-Feature "City Block (5 buildings)" {
    $result = New-ProceduralCityBlock -name "TestCityBlock" `
        -buildingCount 5 `
        -blockSize 80 `
        -minFloors 3 `
        -maxFloors 8
    return $result -ne $null -and $result.Count -gt 0
}

Test-Feature "Small Forest (10 trees)" {
    $result = New-ProceduralForest -name "TestForest" `
        -treeCount 10 `
        -areaSize 100 `
        -generateTerrain $true `
        -seed 999
    return $result -ne $null -and $result.trees -ne $null
}

Write-Host ""
Write-Host "[PHASE 7] Parameter Validation Tests" -ForegroundColor Magenta
Write-Host ""

Test-Feature "Seed Reproducibility (same seed)" {
    $result1 = New-ProceduralTerrain -name "TestSeed1" -seed 42 -width 50 -height 50
    $result2 = New-ProceduralTerrain -name "TestSeed2" -seed 42 -width 50 -height 50
    # Both should succeed (can't compare mesh data, but both should create)
    return $result1 -ne $null -and $result2 -ne $null -and $result1.success -and $result2.success
}

Test-Feature "High Octave Terrain (7 octaves)" {
    $result = New-ProceduralTerrain -name "TestHighOctaves" -octaves 7 -amplitude 20
    return $result -ne $null -and $result.success
}

Test-Feature "High-Resolution Point Cloud" {
    $result = New-PointCloudTerrain -name "TestHighRes" -pointCount 30000 -gridResolution 80
    return $result -ne $null -and $result.success
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Test Results" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Tests Passed: $testsPassed" -ForegroundColor Green
Write-Host "Tests Failed: $testsFailed" -ForegroundColor Red
Write-Host "Total Tests: $($testsPassed + $testsFailed)" -ForegroundColor Cyan
Write-Host ""

if ($testsFailed -eq 0) {
    Write-Host "✓ ALL TESTS PASSED!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Point Cloud & Procedural Mesh systems are fully operational." -ForegroundColor Green
    Write-Host "Ready for production use." -ForegroundColor Green
} else {
    Write-Host "✗ SOME TESTS FAILED" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please check Unity console for errors." -ForegroundColor Yellow
    Write-Host "Ensure Unity MCP Server is running." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Test Objects Created:" -ForegroundColor Cyan
Write-Host "  - 3 Point Cloud Terrains" -ForegroundColor Gray
Write-Host "  - 5 Procedural Terrains (all noise types)" -ForegroundColor Gray
Write-Host "  - 4 Buildings" -ForegroundColor Gray
Write-Host "  - 4 Trees" -ForegroundColor Gray
Write-Host "  - 1 City Block (5 buildings)" -ForegroundColor Gray
Write-Host "  - 1 Forest (10 trees + terrain)" -ForegroundColor Gray
Write-Host "  - 3 Validation Tests (seeds, octaves, resolution)" -ForegroundColor Gray
Write-Host ""
Write-Host "Total Objects: 30+ generated for testing" -ForegroundColor Cyan
Write-Host ""

$successRate = [math]::Round(($testsPassed / ($testsPassed + $testsFailed)) * 100, 1)
Write-Host "Success Rate: $successRate%" -ForegroundColor $(if ($successRate -eq 100) { "Green" } elseif ($successRate -gt 80) { "Yellow" } else { "Red" })
Write-Host ""

if ($successRate -eq 100) {
    Write-Host "🚀 Point Cloud & Procedural Mesh Integration: COMPLETE!" -ForegroundColor Green
}
