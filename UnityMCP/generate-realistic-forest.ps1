# ==============================================================================
# REALISTIC TEMPERATE DECIDUOUS FOREST GENERATOR
# ==============================================================================
# Creates an extremely detailed forest biome based on real-world ecosystems
# Features:
# - 4 tree species (Oak, Maple, Birch, Pine) with realistic proportions
# - Multi-layered canopy system
# - Understory vegetation (saplings, bushes, ferns)
# - Forest floor debris (fallen logs, stumps, boulders)
# - Natural clearings with wildflowers
# - Meandering forest stream
# - Realistic materials and colors
# ==============================================================================

$ErrorActionPreference = "Stop"
$UNITY_BASE = "http://localhost:8765"

Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  REALISTIC FOREST BIOME GENERATOR" -ForegroundColor Cyan
Write-Host "  Temperate Deciduous Forest Ecosystem" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Check Unity connection
Write-Host "[1/7] Checking Unity connection..." -ForegroundColor Yellow
try {
    $result = Test-NetConnection -ComputerName localhost -Port 8765 -WarningAction SilentlyContinue
    if (-not $result.TcpTestSucceeded) {
        Write-Host "ERROR: Unity MCP Server not running on port 8765" -ForegroundColor Red
        Write-Host "Please start Unity and ensure the MCP server is active" -ForegroundColor Red
        exit 1
    }
    Write-Host "   Unity connected successfully!" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Cannot connect to Unity: $_" -ForegroundColor Red
    exit 1
}

# Clear existing world
Write-Host ""
Write-Host "[2/7] Clearing existing scene objects..." -ForegroundColor Yellow
try {
    $clearBody = @{
        pattern = "*"
    } | ConvertTo-Json
    
    $clearResult = Invoke-RestMethod -Uri "$UNITY_BASE/deleteObjects" `
        -Method POST `
        -ContentType "application/json" `
        -Body $clearBody `
        -UseBasicParsing
    
    if ($clearResult.success) {
        Write-Host "   Scene cleared: $($clearResult.deletedCount) objects removed" -ForegroundColor Green
    }
} catch {
    Write-Host "   Warning: Could not clear scene: $_" -ForegroundColor Yellow
}

# Generate the forest world
Write-Host ""
Write-Host "[3/7] Generating Temperate Deciduous Forest..." -ForegroundColor Yellow
Write-Host "   This creates a realistic multi-layered forest ecosystem" -ForegroundColor Gray
Write-Host ""

$worldSettings = @{
    biome = "Forest"
    worldSize = 120          # 120 meters = large forest area
    density = 80             # High density for realistic forest
    includeTerrain = $true
    includeLighting = $true
    includeProps = $true
    optimizeMeshes = $false  # Keep separate for inspection
    seed = "AppalachianForest2025"
} | ConvertTo-Json

Write-Host "   World Size: 120m x 120m" -ForegroundColor Gray
Write-Host "   Density: 80 (Dense temperate forest)" -ForegroundColor Gray
Write-Host "   Seed: AppalachianForest2025" -ForegroundColor Gray
Write-Host ""

$startTime = Get-Date

try {
    $worldResult = Invoke-RestMethod -Uri "$UNITY_BASE/generateWorld" `
        -Method POST `
        -ContentType "application/json" `
        -Body $worldSettings `
        -UseBasicParsing
    
    if ($worldResult.success) {
        Write-Host "   FOREST GENERATED SUCCESSFULLY!" -ForegroundColor Green
        Write-Host ""
        Write-Host "   Generation Statistics:" -ForegroundColor Cyan
        Write-Host "   =====================" -ForegroundColor Cyan
        Write-Host "   Total Objects:     $($worldResult.totalObjects)" -ForegroundColor White
        Write-Host "   Generation Time:   $([math]::Round($worldResult.generationTime, 2))s" -ForegroundColor White
        Write-Host "   Biome Type:        $($worldResult.biome)" -ForegroundColor White
        Write-Host "   World Name:        $($worldResult.worldName)" -ForegroundColor White
        Write-Host ""
    } else {
        Write-Host "ERROR: World generation failed: $($worldResult.error)" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "ERROR: Failed to generate world: $_" -ForegroundColor Red
    exit 1
}

# Query and display forest composition
Write-Host "[4/7] Analyzing forest composition..." -ForegroundColor Yellow
Write-Host ""

$queries = @(
    @{ pattern = "Oak*"; name = "Oak Trees (Quercus)" },
    @{ pattern = "Maple*"; name = "Maple Trees (Acer)" },
    @{ pattern = "Birch*"; name = "Birch Trees (Betula)" },
    @{ pattern = "Pine*"; name = "Pine Trees (Pinus)" },
    @{ pattern = "Sapling*"; name = "Saplings (Young Trees)" },
    @{ pattern = "Fern*"; name = "Ferns (Ground Cover)" },
    @{ pattern = "Bush*"; name = "Bushes & Shrubs" },
    @{ pattern = "FallenLog*"; name = "Fallen Logs" },
    @{ pattern = "Boulder*"; name = "Boulders & Rocks" },
    @{ pattern = "Stump*"; name = "Tree Stumps" },
    @{ pattern = "Clearing*"; name = "Forest Clearings" },
    @{ pattern = "Forest_Stream*"; name = "Stream Features" }
)

Write-Host "   Forest Layer Breakdown:" -ForegroundColor Cyan
Write-Host "   ======================" -ForegroundColor Cyan

foreach ($query in $queries) {
    try {
        $queryBody = @{
            namePattern = $query.pattern
            maxResults = 1000
        } | ConvertTo-Json
        
        $queryResult = Invoke-RestMethod -Uri "$UNITY_BASE/queryObjects" `
            -Method POST `
            -ContentType "application/json" `
            -Body $queryBody `
            -UseBasicParsing
        
        $count = $queryResult.objects.Count
        if ($count -gt 0) {
            $displayName = $query.name.PadRight(30)
            Write-Host "   $displayName : " -NoNewline -ForegroundColor Gray
            Write-Host "$count objects" -ForegroundColor White
        }
    } catch {
        # Skip if query fails
    }
}

Write-Host ""

# Display forest features
Write-Host "[5/7] Forest Ecosystem Features:" -ForegroundColor Yellow
Write-Host ""

Write-Host "   CANOPY LAYER (15-25m)" -ForegroundColor Green
Write-Host "   - Oak: Dominant species, broad spreading crowns" -ForegroundColor Gray
Write-Host "   - Maple: Secondary canopy, vibrant foliage" -ForegroundColor Gray
Write-Host "   - Birch: Distinctive white bark, slender trunks" -ForegroundColor Gray
Write-Host "   - Pine: Conical evergreens, layered tiers" -ForegroundColor Gray
Write-Host ""

Write-Host "   UNDERSTORY LAYER (3-6m)" -ForegroundColor Green
Write-Host "   - Young saplings competing for light" -ForegroundColor Gray
Write-Host "   - Varied species regeneration" -ForegroundColor Gray
Write-Host ""

Write-Host "   GROUND LAYER (0-2m)" -ForegroundColor Green
Write-Host "   - Dense fern coverage" -ForegroundColor Gray
Write-Host "   - Bushes and low shrubs" -ForegroundColor Gray
Write-Host "   - Wildflowers in clearings" -ForegroundColor Gray
Write-Host ""

Write-Host "   FOREST FLOOR FEATURES" -ForegroundColor Green
Write-Host "   - Decomposing fallen logs (some with moss)" -ForegroundColor Gray
Write-Host "   - Granite boulders (some with moss patches)" -ForegroundColor Gray
Write-Host "   - Cut tree stumps" -ForegroundColor Gray
Write-Host "   - Natural clearings with wildflowers" -ForegroundColor Gray
Write-Host "   - Meandering forest stream with rocks" -ForegroundColor Gray
Write-Host ""

# Camera setup for optimal viewing
Write-Host "[6/7] Setting up optimal camera position..." -ForegroundColor Yellow

try {
    $cameraBody = @{
        name = "Main Camera"
        position = @{
            x = 35
            y = 25
            z = 35
        }
        rotation = @{
            x = 25
            y = -45
            z = 0
        }
    } | ConvertTo-Json
    
    Invoke-RestMethod -Uri "$UNITY_BASE/setTransform" `
        -Method POST `
        -ContentType "application/json" `
        -Body $cameraBody `
        -UseBasicParsing | Out-Null
    
    Write-Host "   Camera positioned for aerial forest view" -ForegroundColor Green
} catch {
    Write-Host "   Warning: Could not position camera" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[7/7] Forest generation complete!" -ForegroundColor Yellow
Write-Host ""

# Final summary
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  ECOSYSTEM REALISM FEATURES" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Tree Species Distribution (Real-world based):" -ForegroundColor White
Write-Host "  40% Oak    - Dominant canopy species" -ForegroundColor Gray
Write-Host "  30% Maple  - Secondary canopy" -ForegroundColor Gray
Write-Host "  20% Birch  - Edge and clearing trees" -ForegroundColor Gray
Write-Host "  10% Pine   - Scattered conifers" -ForegroundColor Gray
Write-Host ""

Write-Host "Realistic Features:" -ForegroundColor White
Write-Host "  - Multi-layered tree canopies" -ForegroundColor Gray
Write-Host "  - Visible branches on major trees" -ForegroundColor Gray
Write-Host "  - Birch trees with characteristic black bark marks" -ForegroundColor Gray
Write-Host "  - Pine trees with tiered conical structure" -ForegroundColor Gray
Write-Host "  - Moss growth on logs and boulders" -ForegroundColor Gray
Write-Host "  - Natural forest clearings with wildflowers" -ForegroundColor Gray
Write-Host "  - Meandering stream with rocks" -ForegroundColor Gray
Write-Host "  - Slight tree lean (wind effect)" -ForegroundColor Gray
Write-Host "  - Varied tree heights and trunk widths" -ForegroundColor Gray
Write-Host ""

Write-Host "Material Realism:" -ForegroundColor White
Write-Host "  - Oak: Dark brown bark, deep green leaves" -ForegroundColor Gray
Write-Host "  - Maple: Gray-brown bark, fall color variation" -ForegroundColor Gray
Write-Host "  - Birch: White bark, light green-yellow leaves" -ForegroundColor Gray
Write-Host "  - Pine: Reddish-brown bark, dark evergreen needles" -ForegroundColor Gray
Write-Host "  - Realistic smoothness values (rough bark, smooth water)" -ForegroundColor Gray
Write-Host ""

Write-Host "Inspired by:" -ForegroundColor White
Write-Host "  - Appalachian Mountain forests (Eastern USA)" -ForegroundColor Gray
Write-Host "  - European temperate deciduous forests" -ForegroundColor Gray
Write-Host "  - Real-world forest ecology principles" -ForegroundColor Gray
Write-Host ""

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  Explore your realistic forest in Unity!" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "TIP: Use Scene view to fly through the forest" -ForegroundColor Yellow
Write-Host "     and inspect individual tree species!" -ForegroundColor Yellow
Write-Host ""
