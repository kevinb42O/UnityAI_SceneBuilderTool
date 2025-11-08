# Test Scene Query Bug Fix
# Verifies that parent GameObjects without Renderer components don't crash

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Scene Query Bug Fix Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Query for "Wall" objects (includes parent "Walls" without renderer)
Write-Host "[TEST 1] Querying for 'Wall' objects..." -ForegroundColor Yellow
$body = @{ query = "Wall" } | ConvertTo-Json -Depth 5 -Compress
try {
    $result = Invoke-RestMethod -Uri "http://localhost:8765/queryScene" -Method Post -Body $body -ContentType "application/json"
    $wallObjects = $result.results | Where-Object { $_.name -like "*Wall*" }
    $withBounds = ($wallObjects | Where-Object { $_.bounds -ne $null }).Count
    $withoutBounds = ($wallObjects | Where-Object { $_.bounds -eq $null }).Count
    
    Write-Host "  [OK] Found $($result.count) total objects" -ForegroundColor Green
    Write-Host "  [OK] Wall objects with bounds (have renderers): $withBounds" -ForegroundColor Green
    Write-Host "  [OK] Wall objects without bounds (parent containers): $withoutBounds" -ForegroundColor Green
} catch {
    Write-Host "  [FAIL] Query failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Test 2: Query for "Building" (parent container without renderer)
Write-Host "[TEST 2] Querying for 'Building' parent..." -ForegroundColor Yellow
$body = @{ query = "Building" } | ConvertTo-Json -Depth 5 -Compress
try {
    $result = Invoke-RestMethod -Uri "http://localhost:8765/queryScene" -Method Post -Body $body -ContentType "application/json"
    $building = $result.results | Where-Object { $_.name -eq "Building" }
    
    if ($building) {
        Write-Host "  [OK] Found 'Building' parent object" -ForegroundColor Green
        if ($building.bounds -eq $null) {
            Write-Host "  [OK] Bounds correctly set to null (no renderer)" -ForegroundColor Green
        } else {
            Write-Host "  [FAIL] Bounds should be null but got: $($building.bounds)" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "  [SKIP] Building not found in scene" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  [FAIL] Query failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Test 3: Query within radius (tests all objects)
Write-Host "[TEST 3] Querying objects within 50 units of origin..." -ForegroundColor Yellow
$body = @{ 
    query = ""
    radius = 50
    position = @{ x = 0; y = 0; z = 0 }
} | ConvertTo-Json -Depth 5 -Compress
try {
    $result = Invoke-RestMethod -Uri "http://localhost:8765/queryScene" -Method Post -Body $body -ContentType "application/json"
    Write-Host "  [OK] Found $($result.count) objects within radius" -ForegroundColor Green
    
    $withBounds = ($result.results | Where-Object { $_.bounds -ne $null }).Count
    $withoutBounds = ($result.results | Where-Object { $_.bounds -eq $null }).Count
    Write-Host "  [OK] Objects with meshes: $withBounds" -ForegroundColor Green
    Write-Host "  [OK] Parent containers: $withoutBounds" -ForegroundColor Green
} catch {
    Write-Host "  [FAIL] Query failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " All Tests Passed!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Bug Fix Summary:" -ForegroundColor Cyan
Write-Host "  - Parent GameObjects without Renderer work correctly" -ForegroundColor White
Write-Host "  - Scene queries handle hierarchical structures" -ForegroundColor White
