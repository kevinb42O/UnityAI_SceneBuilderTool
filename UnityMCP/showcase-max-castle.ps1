# ============================================================
# MAX SHOWCASE: Epic Castle Biome Generation
# Maximum detail castle with village - THE ULTIMATE SHOWCASE
# ============================================================

$ErrorActionPreference = "Stop"
$UNITY_BASE = "http://localhost:8765"

Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  🏰 EPIC CASTLE MAX SHOWCASE 🏰" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Test connection
Write-Host "[1/4] Checking Unity connection..." -ForegroundColor Yellow
try {
    $result = Test-NetConnection -ComputerName localhost -Port 8765 -WarningAction SilentlyContinue
    if (-not $result.TcpTestSucceeded) {
        Write-Host "ERROR: Unity MCP Server not running on port 8765" -ForegroundColor Red
        exit 1
    }
    Write-Host "   Unity connected successfully!" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Cannot connect to Unity: $_" -ForegroundColor Red
    exit 1
}

# Create new scene
Write-Host ""
Write-Host "[2/4] Creating fresh scene..." -ForegroundColor Yellow
try {
    Invoke-RestMethod -Uri "$UNITY_BASE/newScene" -Method Post -ContentType "application/json" -Body "{}" -UseBasicParsing | Out-Null
    Write-Host "   New scene created!" -ForegroundColor Green
    Start-Sleep -Seconds 1
} catch {
    Write-Host "   Warning: Could not create new scene" -ForegroundColor Yellow
}

# Generate EPIC MAX CASTLE
Write-Host ""
Write-Host "[3/4] Generating EPIC MAX CASTLE..." -ForegroundColor Yellow
Write-Host ""
Write-Host "   Settings:" -ForegroundColor Cyan
Write-Host "   - World Size: 300m x 300m (MASSIVE!)" -ForegroundColor Gray
Write-Host "   - Density: 100 (MAXIMUM DETAIL)" -ForegroundColor Gray
Write-Host "   - Seed: EpicCastleShowcase2025" -ForegroundColor Gray
Write-Host "   - All features: ENABLED" -ForegroundColor Gray
Write-Host ""

$epicCastle = @{
    biome = "Medieval"
    worldSize = 300
    density = 100
    includeTerrain = $true
    includeLighting = $true
    includeProps = $true
    optimizeMeshes = $true
    seed = "EpicCastleShowcase2025"
} | ConvertTo-Json

$startTime = Get-Date

try {
    $response = Invoke-RestMethod -Uri "$UNITY_BASE/generateWorld" `
        -Method POST `
        -ContentType "application/json" `
        -Body $epicCastle `
        -UseBasicParsing
    
    $duration = ((Get-Date) - $startTime).TotalSeconds
    
    if ($response.success) {
        Write-Host "   🏰 EPIC CASTLE GENERATED! 🏰" -ForegroundColor Green
        Write-Host ""
        Write-Host "   Generation Statistics:" -ForegroundColor Cyan
        Write-Host "   =====================" -ForegroundColor Cyan
        Write-Host "   World Name:        $($response.worldName)" -ForegroundColor White
        Write-Host "   Total Objects:     $($response.totalObjects)" -ForegroundColor White
        Write-Host "   Generation Time:   $([math]::Round($duration, 2))s" -ForegroundColor White
        Write-Host "   Biome Type:        $($response.biome)" -ForegroundColor White
        Write-Host "   World Size:        300m x 300m" -ForegroundColor White
        Write-Host "   Density:           100 (MAX)" -ForegroundColor White
        Write-Host ""
    } else {
        Write-Host "ERROR: Castle generation failed: $($response.error)" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "ERROR: Failed to generate castle: $_" -ForegroundColor Red
    exit 1
}

# Camera positioning
Write-Host "[4/4] Setting up cinematic camera view..." -ForegroundColor Yellow
try {
    $cameraBody = @{
        name = "Main Camera"
        position = @{
            x = 100
            y = 80
            z = 100
        }
        rotation = @{
            x = 30
            y = -45
            z = 0
        }
    } | ConvertTo-Json
    
    Invoke-RestMethod -Uri "$UNITY_BASE/setTransform" `
        -Method POST `
        -ContentType "application/json" `
        -Body $cameraBody `
        -UseBasicParsing | Out-Null
    
    Write-Host "   Camera positioned for epic aerial view" -ForegroundColor Green
} catch {
    Write-Host "   Warning: Could not position camera" -ForegroundColor Yellow
}

# Final showcase info
Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  🏰 EPIC CASTLE FEATURES 🏰" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "CASTLE FORTIFICATIONS:" -ForegroundColor Yellow
Write-Host "  - Elevated castle hill (procedural terrain)" -ForegroundColor White
Write-Host "  - Massive outer defensive walls" -ForegroundColor White
Write-Host "  - 4 towering corner towers with battlements" -ForegroundColor White
Write-Host "  - Imposing central keep (tallest structure)" -ForegroundColor White
Write-Host "  - Fortified gatehouse with twin towers" -ForegroundColor White
Write-Host "  - Multi-level defensive architecture" -ForegroundColor White
Write-Host ""

Write-Host "INNER COURTYARD:" -ForegroundColor Yellow
Write-Host "  - Barracks for garrison troops" -ForegroundColor White
Write-Host "  - Armory building" -ForegroundColor White
Write-Host "  - Stables for cavalry" -ForegroundColor White
Write-Host "  - Strategic positioning" -ForegroundColor White
Write-Host ""

Write-Host "VILLAGE (Maximum Density):" -ForegroundColor Yellow
Write-Host "  - 50+ varied buildings at hill base" -ForegroundColor White
Write-Host "  - Central village square with fountain" -ForegroundColor White
Write-Host "  - Multiple house types (large, medium, small)" -ForegroundColor White
Write-Host "  - Varied roof colors (red, brown, gray)" -ForegroundColor White
Write-Host "  - Organic street layout" -ForegroundColor White
Write-Host ""

Write-Host "INFRASTRUCTURE:" -ForegroundColor Yellow
Write-Host "  - Complete road network" -ForegroundColor White
Write-Host "  - Paths connecting village to castle" -ForegroundColor White
Write-Host "  - Market stalls throughout village" -ForegroundColor White
Write-Host "  - Props and decorative elements" -ForegroundColor White
Write-Host ""

Write-Host "DECORATIVE ELEMENTS:" -ForegroundColor Yellow
Write-Host "  - Colorful flags on castle towers" -ForegroundColor White
Write-Host "  - Market stalls with varied goods" -ForegroundColor White
Write-Host "  - Barrels, crates, and props" -ForegroundColor White
Write-Host "  - Village square centerpiece" -ForegroundColor White
Write-Host ""

Write-Host "OPTIMIZATION:" -ForegroundColor Yellow
Write-Host "  - Automatic mesh combining enabled" -ForegroundColor White
Write-Host "  - Efficient draw call reduction" -ForegroundColor White
Write-Host "  - Performance-optimized architecture" -ForegroundColor White
Write-Host ""

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  Explore your epic castle in Unity!" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "VIEWING TIPS:" -ForegroundColor Yellow
Write-Host "  • Use Scene view to fly through the castle" -ForegroundColor Gray
Write-Host "  • Check out the village layout from above" -ForegroundColor Gray
Write-Host "  • Inspect the multi-level castle walls" -ForegroundColor Gray
Write-Host "  • Zoom in to see individual house details" -ForegroundColor Gray
Write-Host "  • Find the central keep (tallest structure)" -ForegroundColor Gray
Write-Host ""

Write-Host "This is Asset Store quality work! 🏆" -ForegroundColor Green
Write-Host ""
