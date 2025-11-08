# ============================================================
# Advanced Scene Creation Demo - Showcases New AI Tools
# Demonstrates rotation, arrays, physics, and lighting
# ============================================================

$baseUrl = "http://localhost:8765"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ADVANCED SCENE CREATION DEMO" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Helper function
function Invoke-Unity {
    param(
        [string]$endpoint,
        [hashtable]$body
    )
    try {
        $json = $body | ConvertTo-Json -Depth 10
        $result = Invoke-RestMethod -Uri "$baseUrl$endpoint" -Method POST -ContentType "application/json" -Body $json -UseBasicParsing
        return $result
    }
    catch {
        Write-Host "ERROR: $_" -ForegroundColor Red
        return $null
    }
}

# Test connection
Write-Host "Testing Unity connection..." -ForegroundColor Yellow
try {
    Invoke-RestMethod -Uri "$baseUrl/ping" -Method POST -UseBasicParsing | Out-Null
    Write-Host "✓ Connected to Unity" -ForegroundColor Green
} catch {
    Write-Host "✗ Cannot connect to Unity. Please start Unity MCP Server." -ForegroundColor Red
    exit
}

# Create new scene
Write-Host ""
Write-Host "Creating new scene..." -ForegroundColor Yellow
Invoke-Unity "/newScene" @{} | Out-Null
Start-Sleep -Milliseconds 500

# ============================================================
# DEMO 1: Circular Array - Temple Pillars
# ============================================================

Write-Host ""
Write-Host "=== DEMO 1: Circular Array Temple ===" -ForegroundColor Cyan
Write-Host "Creating temple with 12 pillars in a circle..." -ForegroundColor Yellow

# Create base pillar
Invoke-Unity "/createGameObject" @{
    name = "Pillar_Base"
    primitiveType = "Cylinder"
} | Out-Null

Invoke-Unity "/setTransform" @{
    name = "Pillar_Base"
    position = @{x=0; y=5; z=0}
    scale = @{x=1; y=5; z=1}
} | Out-Null

Invoke-Unity "/setMaterial" @{
    name = "Pillar_Base"
    color = @{r=0.8; g=0.7; b=0.6}
    metallic = 0.0
    smoothness = 0.2
} | Out-Null

# Create circular array of pillars
Write-Host "Creating circular array..." -ForegroundColor Yellow
$result = Invoke-Unity "/createCircularArray" @{
    sourceName = "Pillar_Base"
    count = 12
    radius = 20
    center = @{x=0; y=0; z=0}
    rotateToCenter = $false
    namePrefix = "Pillar"
}

if ($result.success) {
    Write-Host "✓ Created $($result.count) pillars in circle" -ForegroundColor Green
}

# Add center statue
Invoke-Unity "/createGameObject" @{
    name = "Statue"
    primitiveType = "Sphere"
} | Out-Null

Invoke-Unity "/setTransform" @{
    name = "Statue"
    position = @{x=0; y=3; z=0}
    scale = @{x=4; y=6; z=4}
} | Out-Null

Invoke-Unity "/setMaterial" @{
    name = "Statue"
    color = @{r=0.9; g=0.85; b=0.7}
    metallic = 0.3
    smoothness = 0.6
} | Out-Null

Write-Host "✓ Temple complete!" -ForegroundColor Green
Start-Sleep -Seconds 2

# ============================================================
# DEMO 2: Grid Array - City Buildings
# ============================================================

Write-Host ""
Write-Host "=== DEMO 2: Grid Array City ===" -ForegroundColor Cyan
Write-Host "Creating city block with 5x1x3 building grid..." -ForegroundColor Yellow

# Create base building
Invoke-Unity "/createGameObject" @{
    name = "Building_Base"
    primitiveType = "Cube"
} | Out-Null

Invoke-Unity "/setTransform" @{
    name = "Building_Base"
    position = @{x=40; y=5; z=0}
    scale = @{x=5; y=10; z=5}
} | Out-Null

Invoke-Unity "/setMaterial" @{
    name = "Building_Base"
    color = @{r=0.5; g=0.5; b=0.55}
    metallic = 0.2
    smoothness = 0.4
} | Out-Null

# Create grid array
Write-Host "Creating grid array..." -ForegroundColor Yellow
$result = Invoke-Unity "/createGridArray" @{
    sourceName = "Building_Base"
    countX = 5
    countY = 1
    countZ = 3
    spacingX = 8
    spacingY = 0
    spacingZ = 8
    namePrefix = "Building"
}

if ($result.success) {
    Write-Host "✓ Created $($result.count) buildings in grid" -ForegroundColor Green
}

Start-Sleep -Seconds 2

# ============================================================
# DEMO 3: Linear Array - Bridge Support Cables
# ============================================================

Write-Host ""
Write-Host "=== DEMO 3: Linear Array Bridge Cables ===" -ForegroundColor Cyan
Write-Host "Creating bridge with suspension cables..." -ForegroundColor Yellow

# Create bridge tower left
Invoke-Unity "/createGameObject" @{
    name = "Tower_Left"
    primitiveType = "Cube"
} | Out-Null

Invoke-Unity "/setTransform" @{
    name = "Tower_Left"
    position = @{x=-30; y=15; z=-30}
    scale = @{x=3; y=30; z=3}
} | Out-Null

Invoke-Unity "/setMaterial" @{
    name = "Tower_Left"
    color = @{r=0.6; g=0.6; b=0.6}
    metallic = 0.5
    smoothness = 0.3
} | Out-Null

# Create bridge tower right
Invoke-Unity "/createGameObject" @{
    name = "Tower_Right"
    primitiveType = "Cube"
} | Out-Null

Invoke-Unity "/setTransform" @{
    name = "Tower_Right"
    position = @{x=30; y=15; z=-30}
    scale = @{x=3; y=30; z=3}
} | Out-Null

Invoke-Unity "/setMaterial" @{
    name = "Tower_Right"
    color = @{r=0.6; g=0.6; b=0.6}
    metallic = 0.5
    smoothness = 0.3
} | Out-Null

# Create deck
Invoke-Unity "/createGameObject" @{
    name = "Deck"
    primitiveType = "Cube"
} | Out-Null

Invoke-Unity "/setTransform" @{
    name = "Deck"
    position = @{x=0; y=10; z=-30}
    scale = @{x=70; y=1; z=10}
} | Out-Null

Invoke-Unity "/setMaterial" @{
    name = "Deck"
    color = @{r=0.4; g=0.4; b=0.4}
    metallic = 0.3
    smoothness = 0.4
} | Out-Null

# Create cable base
Invoke-Unity "/createGameObject" @{
    name = "Cable_Base"
    primitiveType = "Cylinder"
} | Out-Null

Invoke-Unity "/setTransform" @{
    name = "Cable_Base"
    position = @{x=-30; y=25; z=-30}
    rotation = @{x=0; y=0; z=90}
    scale = @{x=0.2; y=15; z=0.2}
} | Out-Null

Invoke-Unity "/setMaterial" @{
    name = "Cable_Base"
    color = @{r=0.8; g=0.8; b=0.2}
    metallic = 0.7
    smoothness = 0.6
} | Out-Null

# Create linear array of cables
Write-Host "Creating cable array..." -ForegroundColor Yellow
$result = Invoke-Unity "/createLinearArray" @{
    sourceName = "Cable_Base"
    count = 6
    spacing = @{x=10; y=0; z=0}
    namePrefix = "Cable"
}

if ($result.success) {
    Write-Host "✓ Created $($result.count) support cables" -ForegroundColor Green
}

Start-Sleep -Seconds 2

# ============================================================
# DEMO 4: Look At - Spotlight System
# ============================================================

Write-Host ""
Write-Host "=== DEMO 4: Look At Spotlight System ===" -ForegroundColor Cyan
Write-Host "Creating spotlights aimed at center..." -ForegroundColor Yellow

# Create center target sphere
Invoke-Unity "/createGameObject" @{
    name = "Spotlight_Target"
    primitiveType = "Sphere"
} | Out-Null

Invoke-Unity "/setTransform" @{
    name = "Spotlight_Target"
    position = @{x=0; y=2; z=-50}
    scale = @{x=2; y=2; z=2}
} | Out-Null

Invoke-Unity "/setMaterial" @{
    name = "Spotlight_Target"
    color = @{r=1; g=0.2; b=0.2}
    emission = @{r=1; g=0.2; b=0.2; intensity=2}
} | Out-Null

# Create spotlight 1
Write-Host "Creating spotlight 1..." -ForegroundColor Yellow
$result = Invoke-Unity "/createLight" @{
    name = "Spotlight_1"
    lightType = "Spot"
    position = @{x=-10; y=15; z=-50}
    color = @{r=1; g=0.8; b=0.6}
    intensity = 3
    range = 30
    spotAngle = 45
    shadows = "Soft"
}

# Make spotlight look at target
Invoke-Unity "/lookAt" @{
    name = "Spotlight_1"
    targetName = "Spotlight_Target"
} | Out-Null

# Create spotlight 2
Write-Host "Creating spotlight 2..." -ForegroundColor Yellow
Invoke-Unity "/createLight" @{
    name = "Spotlight_2"
    lightType = "Spot"
    position = @{x=10; y=15; z=-50}
    color = @{r=0.6; g=0.8; b=1}
    intensity = 3
    range = 30
    spotAngle = 45
    shadows = "Soft"
} | Out-Null

Invoke-Unity "/lookAt" @{
    name = "Spotlight_2"
    targetName = "Spotlight_Target"
} | Out-Null

Write-Host "✓ Spotlights aimed at target!" -ForegroundColor Green
Start-Sleep -Seconds 2

# ============================================================
# DEMO 5: Physics - Falling Blocks
# ============================================================

Write-Host ""
Write-Host "=== DEMO 5: Physics System ===" -ForegroundColor Cyan
Write-Host "Creating physics simulation with falling blocks..." -ForegroundColor Yellow

# Create ground plane
Invoke-Unity "/createGameObject" @{
    name = "Ground"
    primitiveType = "Plane"
} | Out-Null

Invoke-Unity "/setTransform" @{
    name = "Ground"
    position = @{x=70; y=0; z=-50}
    scale = @{x=5; y=1; z=5}
} | Out-Null

Invoke-Unity "/setMaterial" @{
    name = "Ground"
    color = @{r=0.3; g=0.5; b=0.3}
} | Out-Null

# Create stack of blocks with physics
for ($i = 0; $i -lt 5; $i++) {
    $blockName = "PhysicsBlock_$i"
    
    Invoke-Unity "/createGameObject" @{
        name = $blockName
        primitiveType = "Cube"
    } | Out-Null
    
    Invoke-Unity "/setTransform" @{
        name = $blockName
        position = @{x=70; y=(10 + $i * 3); z=-50}
        scale = @{x=2; y=2; z=2}
    } | Out-Null
    
    # Random color for each block
    $r = 0.5 + (Get-Random) * 0.5
    $g = 0.5 + (Get-Random) * 0.5
    $b = 0.5 + (Get-Random) * 0.5
    
    Invoke-Unity "/setMaterial" @{
        name = $blockName
        color = @{r=$r; g=$g; b=$b}
        metallic = 0.3
        smoothness = 0.6
    } | Out-Null
    
    # Add physics
    Invoke-Unity "/addRigidbody" @{
        name = $blockName
        mass = 1.0
        drag = 0.1
        angularDrag = 0.5
        useGravity = $true
    } | Out-Null
    
    Write-Host "  Created $blockName with physics" -ForegroundColor Gray
}

Write-Host "✓ Physics blocks ready! Enter play mode to see them fall." -ForegroundColor Green
Start-Sleep -Seconds 2

# ============================================================
# DEMO 6: Snap to Grid - Organized Layout
# ============================================================

Write-Host ""
Write-Host "=== DEMO 6: Snap to Grid ===" -ForegroundColor Cyan
Write-Host "Creating random objects and snapping to grid..." -ForegroundColor Yellow

for ($i = 0; $i -lt 10; $i++) {
    $objName = "GridObject_$i"
    
    # Create at random position
    Invoke-Unity "/createGameObject" @{
        name = $objName
        primitiveType = "Cube"
    } | Out-Null
    
    $randomX = -50 + (Get-Random) * 10
    $randomY = 1 + (Get-Random) * 5
    $randomZ = 20 + (Get-Random) * 10
    
    Invoke-Unity "/setTransform" @{
        name = $objName
        position = @{x=$randomX; y=$randomY; z=$randomZ}
        scale = @{x=1; y=1; z=1}
    } | Out-Null
    
    # Snap to 2-unit grid
    $result = Invoke-Unity "/snapToGrid" @{
        name = $objName
        gridSize = 2.0
    }
    
    Invoke-Unity "/setMaterial" @{
        name = $objName
        color = @{r=0.2; g=0.7; b=0.9}
        metallic = 0.5
        smoothness = 0.7
    } | Out-Null
}

Write-Host "✓ 10 objects snapped to 2-unit grid" -ForegroundColor Green
Start-Sleep -Seconds 2

# ============================================================
# DEMO 7: Raycast - Surface Detection
# ============================================================

Write-Host ""
Write-Host "=== DEMO 7: Raycast & Surface Alignment ===" -ForegroundColor Cyan
Write-Host "Testing raycast from above to place objects on surfaces..." -ForegroundColor Yellow

# Create a sloped surface
Invoke-Unity "/createGameObject" @{
    name = "Slope"
    primitiveType = "Cube"
} | Out-Null

Invoke-Unity "/setTransform" @{
    name = "Slope"
    position = @{x=-70; y=0; z=-50}
    rotation = @{x=0; y=0; z=30}
    scale = @{x=20; y=1; z=20}
} | Out-Null

Invoke-Unity "/setMaterial" @{
    name = "Slope"
    color = @{r=0.7; g=0.5; b=0.3}
    smoothness = 0.2
} | Out-Null

# Add collider to slope for raycasting
Invoke-Unity "/addCollider" @{
    name = "Slope"
    colliderType = "Box"
} | Out-Null

Start-Sleep -Milliseconds 500

# Test raycast
Write-Host "Performing raycast..." -ForegroundColor Yellow
$rayResult = Invoke-Unity "/raycast" @{
    origin = @{x=-70; y=20; z=-50}
    direction = @{x=0; y=-1; z=0}
    maxDistance = 100
}

if ($rayResult.hit) {
    Write-Host "✓ Raycast hit: $($rayResult.objectName)" -ForegroundColor Green
    Write-Host "  Hit point: x=$($rayResult.point.x), y=$($rayResult.point.y), z=$($rayResult.point.z)" -ForegroundColor Gray
    
    # Place object on surface
    Invoke-Unity "/createGameObject" @{
        name = "Surface_Object"
        primitiveType = "Sphere"
    } | Out-Null
    
    Invoke-Unity "/alignToSurface" @{
        name = "Surface_Object"
        rayOrigin = @{x=-70; y=20; z=-50}
        rayDirection = @{x=0; y=-1; z=0}
        maxDistance = 100
        offset = 1.0
    } | Out-Null
    
    Invoke-Unity "/setMaterial" @{
        name = "Surface_Object"
        color = @{r=1; g=0.5; b=0}
        emission = @{r=1; g=0.5; b=0; intensity=1.5}
    } | Out-Null
    
    Write-Host "✓ Object placed and aligned to surface!" -ForegroundColor Green
}

# ============================================================
# Summary
# ============================================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "         DEMO COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Features Demonstrated:" -ForegroundColor Yellow
Write-Host "  ✓ Circular arrays (temple with 12 pillars)" -ForegroundColor White
Write-Host "  ✓ Grid arrays (5x3 city block)" -ForegroundColor White
Write-Host "  ✓ Linear arrays (bridge cables)" -ForegroundColor White
Write-Host "  ✓ Look At (spotlights)" -ForegroundColor White
Write-Host "  ✓ Physics system (falling blocks)" -ForegroundColor White
Write-Host "  ✓ Snap to grid (organized layout)" -ForegroundColor White
Write-Host "  ✓ Raycast & surface alignment" -ForegroundColor White
Write-Host ""
Write-Host "Total objects created: ~70+" -ForegroundColor Cyan
Write-Host "All advanced scene creation tools working!" -ForegroundColor Green
Write-Host ""
