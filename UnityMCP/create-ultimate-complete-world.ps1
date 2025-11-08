# ============================================================================
# ULTIMATE COMPLETE WORLD - EVERYTHING COMBINED
# Merges all elements: Cathedral, Towers, Portals, Islands, Forests, 
# Tower Bridge, Castle, and ambient elements
# ============================================================================

. ".\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  CREATING ULTIMATE COMPLETE WORLD" -ForegroundColor Cyan
Write-Host "  ALL ELEMENTS COMBINED INTO ONE EPIC SCENE" -ForegroundColor Cyan
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

Write-Host ""
Write-Host "[CLEANUP] Clearing old scene..." -ForegroundColor Yellow

# Delete everything except player
$groupsToDelete = @(
    "EpicGround", "FloatingIslands", "CrystalCathedral", "SciFiTowers", 
    "MagicalPortals", "EnergyBridges", "FloatingOrbs", "GroundDetails",
    "OakGrove", "PineForest", "BirchGrove", "MagicalWillows", "ForestUndergrowth"
)

foreach ($group in $groupsToDelete) {
    try {
        $null = Invoke-RestMethod -Uri "$UNITY_BASE/deleteGameObject" `
            -Method POST -ContentType "application/json" `
            -Body (@{ name = $group } | ConvertTo-Json) -UseBasicParsing
        Write-Host "  [DELETED] $group" -ForegroundColor DarkGray
    } catch {
        Write-Host "  [SKIP] $group" -ForegroundColor DarkGray
    }
}

Write-Host "[OK] Scene cleared" -ForegroundColor Green
Write-Host ""

$totalObjects = 0
$startTime = Get-Date

# ============================================================================
# SECTION 1: GROUND & TERRAIN
# ============================================================================
Write-Host "=== SECTION 1: GROUND & TERRAIN ===" -ForegroundColor Magenta

Build-ColoredObject -name "MainGround" -type "Plane" `
    -x 0 -y 0 -z 0 `
    -sx 150 -sy 1 -sz 150 `
    -color @{ r = 0.2; g = 0.5; b = 0.2 } `
    -metallic 0.0 -smoothness 0.2
$totalObjects++

Write-Host "[OK] Massive ground plane created (1500x1500 units)" -ForegroundColor Green

# ============================================================================
# SECTION 2: CENTRAL CASTLE (at origin)
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 2: MEDIEVAL CASTLE ===" -ForegroundColor Magenta

New-Group -name "MedievalCastle"

# Castle base platform
Build-ColoredObject -name "Castle_Foundation" -type "Cube" `
    -x 0 -y 1.5 -z 0 `
    -sx 80 -sy 3 -sz 80 `
    -color @{ r = 0.4; g = 0.38; b = 0.35 } `
    -metallic 0.0 -smoothness 0.1 `
    -parent "MedievalCastle"
$totalObjects++

# 4 Corner towers (larger)
$castleTowers = @(
    @{x = 35; z = 35; name = "NE"},
    @{x = -35; z = 35; name = "NW"},
    @{x = 35; z = -35; name = "SE"},
    @{x = -35; z = -35; name = "SW"}
)

foreach ($tower in $castleTowers) {
    Write-Host "  [TOWER] Castle $($tower.name)..." -ForegroundColor Gray
    
    # Tower base
    Build-ColoredObject -name "CastleTower_$($tower.name)_Base" -type "Cylinder" `
        -x $tower.x -y 20 -z $tower.z `
        -sx 8 -sy 20 -sz 8 `
        -color @{ r = 0.45; g = 0.4; b = 0.35 } `
        -metallic 0.0 -smoothness 0.15 `
        -parent "MedievalCastle"
    $totalObjects++
    
    # Battlements (4 per tower)
    for ($i = 0; $i -lt 4; $i++) {
        $angle = ($i * 90) * [Math]::PI / 180
        $bx = $tower.x + ([Math]::Cos($angle) * 5)
        $bz = $tower.z + ([Math]::Sin($angle) * 5)
        
        Build-ColoredObject -name "CastleTower_$($tower.name)_Battlement_$i" -type "Cube" `
            -x $bx -y 41 -z $bz `
            -sx 2 -sy 3 -sz 2 `
            -color @{ r = 0.5; g = 0.45; b = 0.4 } `
            -metallic 0.0 -smoothness 0.1 `
            -parent "MedievalCastle"
        $totalObjects++
    }
    
    # Tower flag
    Build-ColoredObject -name "CastleTower_$($tower.name)_Flag" -type "Cube" `
        -x $tower.x -y 48 -z $tower.z `
        -sx 0.3 -sy 8 -sz 0.3 `
        -color @{ r = 0.2; g = 0.15; b = 0.1 } `
        -metallic 0.0 -smoothness 0.2 `
        -parent "MedievalCastle"
    $totalObjects++
    
    Build-ColoredObject -name "CastleTower_$($tower.name)_Banner" -type "Cube" `
        -x ($tower.x + 1.5) -y 50 -z $tower.z `
        -sx 3 -sy 2 -sz 0.1 `
        -color @{ r = 0.8; g = 0.1; b = 0.1 } `
        -metallic 0.0 -smoothness 0.3 `
        -parent "MedievalCastle"
    $totalObjects++
}

# Castle walls (4 sides)
$wallPositions = @(
    @{x = 0; z = 35; rx = 0; ry = 0; sx = 70; sz = 3},
    @{x = 0; z = -35; rx = 0; ry = 0; sx = 70; sz = 3},
    @{x = 35; z = 0; rx = 0; ry = 90; sx = 70; sz = 3},
    @{x = -35; z = 0; rx = 0; ry = 90; sx = 70; sz = 3}
)

foreach ($wall in $wallPositions) {
    Build-ColoredObject -name "Castle_Wall_$($wall.x)_$($wall.z)" -type "Cube" `
        -x $wall.x -y 18 -z $wall.z `
        -ry $wall.ry `
        -sx $wall.sx -sy 15 -sz $wall.sz `
        -color @{ r = 0.42; g = 0.38; b = 0.33 } `
        -metallic 0.0 -smoothness 0.1 `
        -parent "MedievalCastle"
    $totalObjects++
}

# Central keep
Build-ColoredObject -name "Castle_Keep" -type "Cube" `
    -x 0 -y 22 -z 0 `
    -sx 30 -sy 25 -sz 30 `
    -color @{ r = 0.48; g = 0.43; b = 0.38 } `
    -metallic 0.0 -smoothness 0.15 `
    -parent "MedievalCastle"
$totalObjects++

# Keep roof
Build-ColoredObject -name "Castle_Keep_Roof" -type "Cube" `
    -x 0 -y 36 -z 0 `
    -rx 45 -ry 45 `
    -sx 20 -sy 6 -sz 20 `
    -color @{ r = 0.3; g = 0.15; b = 0.1 } `
    -metallic 0.0 -smoothness 0.2 `
    -parent "MedievalCastle"
$totalObjects++

Write-Host "[OK] Medieval Castle: 35+ objects" -ForegroundColor Green

# ============================================================================
# SECTION 3: CRYSTAL CATHEDRAL (elevated, north of castle)
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 3: CRYSTAL CATHEDRAL ===" -ForegroundColor Magenta

New-Group -name "CrystalCathedral"

# Platform at elevation
Build-ColoredObject -name "Cathedral_Platform" -type "Cylinder" `
    -x 0 -y 61 -z 120 `
    -sx 50 -sy 2 -sz 50 `
    -color @{ r = 0.15; g = 0.15; b = 0.18 } `
    -metallic 0.8 -smoothness 0.7 `
    -parent "CrystalCathedral"
$totalObjects++

# 4 Corner pillars
$cathedralCorners = @(
    @{x = 20; z = 20}, @{x = -20; z = 20},
    @{x = 20; z = -20}, @{x = -20; z = -20}
)

foreach ($corner in $cathedralCorners) {
    Build-ColoredObject -name "Cathedral_Pillar_$($corner.x)_$($corner.z)" -type "Cylinder" `
        -x $corner.x -y 90 -z (120 + $corner.z) `
        -sx 3 -sy 30 -sz 3 `
        -color @{ r = 0.25; g = 0.25; b = 0.28 } `
        -metallic 0.9 -smoothness 0.85 `
        -parent "CrystalCathedral"
    $totalObjects++
    
    Build-ColoredObject -name "Cathedral_Cap_$($corner.x)_$($corner.z)" -type "Cube" `
        -x $corner.x -y 122 -z (120 + $corner.z) `
        -rx 45 -ry 45 -sx 4 -sy 4 -sz 4 `
        -color @{ r = 0.0; g = 0.8; b = 1.0 } `
        -metallic 0.3 -smoothness 0.95 `
        -parent "CrystalCathedral"
    
    Set-Material -name "Cathedral_Cap_$($corner.x)_$($corner.z)" `
        -emission @{ r = 0.0; g = 0.8; b = 1.0; intensity = 4.0 }
    $totalObjects++
}

# Central spire (8 layers)
for ($layer = 0; $layer -lt 8; $layer++) {
    $layerHeight = 65 + ($layer * 10)
    $layerSize = 12 - ($layer * 1.0)
    if ($layerSize -lt 3) { $layerSize = 3 }
    
    $layerColor = if ($layer % 2 -eq 0) {
        @{ r = 0.1; g = 0.5; b = 1.0 }
    } else {
        @{ r = 1.0; g = 0.1; b = 1.0 }
    }
    
    Build-ColoredObject -name "Cathedral_Spire_$layer" -type "Cube" `
        -x 0 -y $layerHeight -z 120 `
        -ry ($layer * 20) `
        -sx $layerSize -sy 5 -sz $layerSize `
        -color $layerColor `
        -metallic 0.5 -smoothness 0.9 `
        -parent "CrystalCathedral"
    
    Set-Material -name "Cathedral_Spire_$layer" `
        -emission @{ r = $layerColor.r; g = $layerColor.g; b = $layerColor.b; intensity = 2.5 }
    $totalObjects++
}

# Top crystal
Build-ColoredObject -name "Cathedral_TopCrystal" -type "Cube" `
    -x 0 -y 150 -z 120 `
    -rx 45 -ry 45 `
    -sx 5 -sy 10 -sz 5 `
    -color @{ r = 1.0; g = 1.0; b = 1.0 } `
    -metallic 0.0 -smoothness 1.0 `
    -parent "CrystalCathedral"

Set-Material -name "Cathedral_TopCrystal" `
    -emission @{ r = 1.0; g = 1.0; b = 1.0; intensity = 5.0 }
$totalObjects++

Write-Host "[OK] Crystal Cathedral: 22 objects" -ForegroundColor Green

# ============================================================================
# SECTION 4: TOWER BRIDGE (connecting castle to cathedral)
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 4: TOWER BRIDGE ===" -ForegroundColor Magenta

New-Group -name "TowerBridge"

# Bridge tower 1 (near castle)
Build-ColoredObject -name "Bridge_Tower1_Base" -type "Cube" `
    -x 0 -y 25 -z 45 `
    -sx 12 -sy 40 -sz 12 `
    -color @{ r = 0.4; g = 0.35; b = 0.3 } `
    -metallic 0.0 -smoothness 0.2 `
    -parent "TowerBridge"
$totalObjects++

Build-ColoredObject -name "Bridge_Tower1_Top" -type "Cube" `
    -x 0 -y 47 -z 45 `
    -rx 45 -ry 45 `
    -sx 10 -sy 4 -sz 10 `
    -color @{ r = 0.35; g = 0.3; b = 0.25 } `
    -metallic 0.0 -smoothness 0.15 `
    -parent "TowerBridge"
$totalObjects++

# Bridge tower 2 (near cathedral)
Build-ColoredObject -name "Bridge_Tower2_Base" -type "Cube" `
    -x 0 -y 45 -z 95 `
    -sx 12 -sy 40 -sz 12 `
    -color @{ r = 0.4; g = 0.35; b = 0.3 } `
    -metallic 0.0 -smoothness 0.2 `
    -parent "TowerBridge"
$totalObjects++

Build-ColoredObject -name "Bridge_Tower2_Top" -type "Cube" `
    -x 0 -y 67 -z 95 `
    -rx 45 -ry 45 `
    -sx 10 -sy 4 -sz 10 `
    -color @{ r = 0.35; g = 0.3; b = 0.25 } `
    -metallic 0.0 -smoothness 0.15 `
    -parent "TowerBridge"
$totalObjects++

# Bridge walkway (elevated path)
Build-ColoredObject -name "Bridge_Walkway" -type "Cube" `
    -x 0 -y 36 -z 70 `
    -sx 8 -sy 1 -sz 50 `
    -color @{ r = 0.45; g = 0.4; b = 0.35 } `
    -metallic 0.0 -smoothness 0.2 `
    -parent "TowerBridge"
$totalObjects++

# Bridge cables
for ($i = 0; $i -lt 8; $i++) {
    $cableZ = 50 + ($i * 6)
    $cableHeight = 47 - ([Math]::Abs($i - 3.5) * 3)
    
    Build-ColoredObject -name "Bridge_Cable_L_$i" -type "Cylinder" `
        -x -5 -y $cableHeight -z $cableZ `
        -rx 0 -ry 0 -rz 0 `
        -sx 0.3 -sy ($cableHeight - 36) -sz 0.3 `
        -color @{ r = 0.3; g = 0.3; b = 0.3 } `
        -metallic 0.7 -smoothness 0.6 `
        -parent "TowerBridge"
    $totalObjects++
    
    Build-ColoredObject -name "Bridge_Cable_R_$i" -type "Cylinder" `
        -x 5 -y $cableHeight -z $cableZ `
        -rx 0 -ry 0 -rz 0 `
        -sx 0.3 -sy ($cableHeight - 36) -sz 0.3 `
        -color @{ r = 0.3; g = 0.3; b = 0.3 } `
        -metallic 0.7 -smoothness 0.6 `
        -parent "TowerBridge"
    $totalObjects++
}

Write-Host "[OK] Tower Bridge: 21 objects" -ForegroundColor Green

# ============================================================================
# SECTION 5: SCI-FI TOWERS (East and West)
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 5: SCI-FI TOWERS ===" -ForegroundColor Magenta

New-Group -name "SciFiTowers"

$scifiTowers = @(
    @{x = 200; z = 0; name = "East"; color = @{r = 0.0; g = 1.0; b = 1.0}},
    @{x = -200; z = 0; name = "West"; color = @{r = 1.0; g = 0.5; b = 0.0}}
)

foreach ($tower in $scifiTowers) {
    Write-Host "  [SCIFI] Tower $($tower.name)..." -ForegroundColor Gray
    
    Build-ColoredObject -name "SciFi_$($tower.name)_Base" -type "Cylinder" `
        -x $tower.x -y 5 -z $tower.z `
        -sx 10 -sy 5 -sz 10 `
        -color @{ r = 0.2; g = 0.2; b = 0.22 } `
        -metallic 0.9 -smoothness 0.8 `
        -parent "SciFiTowers"
    $totalObjects++
    
    Build-ColoredObject -name "SciFi_$($tower.name)_Shaft" -type "Cylinder" `
        -x $tower.x -y 35 -z $tower.z `
        -sx 4 -sy 30 -sz 4 `
        -color @{ r = 0.18; g = 0.18; b = 0.2 } `
        -metallic 0.85 -smoothness 0.85 `
        -parent "SciFiTowers"
    $totalObjects++
    
    Build-ColoredObject -name "SciFi_$($tower.name)_Pod" -type "Sphere" `
        -x $tower.x -y 68 -z $tower.z `
        -sx 12 -sy 10 -sz 12 `
        -color @{ r = 0.3; g = 0.3; b = 0.35 } `
        -metallic 0.7 -smoothness 0.9 `
        -parent "SciFiTowers"
    $totalObjects++
    
    Build-ColoredObject -name "SciFi_$($tower.name)_Core" -type "Sphere" `
        -x $tower.x -y 68 -z $tower.z `
        -sx 5 -sy 5 -sz 5 `
        -color $tower.color `
        -metallic 0.2 -smoothness 0.95 `
        -parent "SciFiTowers"
    
    Set-Material -name "SciFi_$($tower.name)_Core" `
        -emission @{ r = $tower.color.r; g = $tower.color.g; b = $tower.color.b; intensity = 4.0 }
    $totalObjects++
    
    for ($ring = 0; $ring -lt 4; $ring++) {
        Build-ColoredObject -name "SciFi_$($tower.name)_Ring_$ring" -type "Sphere" `
            -x $tower.x -y (20 + ($ring * 12)) -z $tower.z `
            -sx (6 + $ring) -sy 0.6 -sz (6 + $ring) `
            -color $tower.color `
            -metallic 0.8 -smoothness 0.95 `
            -parent "SciFiTowers"
        
        Set-Material -name "SciFi_$($tower.name)_Ring_$ring" `
            -emission @{ r = $tower.color.r; g = $tower.color.g; b = $tower.color.b; intensity = 2.0 }
        $totalObjects++
    }
}

Write-Host "[OK] Sci-Fi Towers: 18 objects" -ForegroundColor Green

# ============================================================================
# SECTION 6: FLOATING ISLANDS (around perimeter)
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 6: FLOATING ISLANDS ===" -ForegroundColor Magenta

New-Group -name "FloatingIslands"

$islandPositions = @(
    @{x = 150; z = 150; h = 80},
    @{x = -150; z = 150; h = 90},
    @{x = 150; z = -150; h = 85}
)

$islandIndex = 0
foreach ($island in $islandPositions) {
    Write-Host "  [ISLAND] $islandIndex..." -ForegroundColor Gray
    
    Build-ColoredObject -name "Island_${islandIndex}_Base" -type "Sphere" `
        -x $island.x -y $island.h -z $island.z `
        -sx 35 -sy 18 -sz 35 `
        -color @{ r = 0.15; g = 0.4; b = 0.15 } `
        -metallic 0.0 -smoothness 0.3 `
        -parent "FloatingIslands"
    $totalObjects++
    
    # 3 crystals per island
    $crystalColors = @(
        @{ r = 1.0; g = 0.0; b = 1.0 },
        @{ r = 0.0; g = 1.0; b = 1.0 },
        @{ r = 1.0; g = 1.0; b = 0.0 }
    )
    
    for ($c = 0; $c -lt 3; $c++) {
        $cAngle = ($c * 120) * [Math]::PI / 180
        $cx = $island.x + ([Math]::Cos($cAngle) * 10)
        $cz = $island.z + ([Math]::Sin($cAngle) * 10)
        
        Build-ColoredObject -name "Island_${islandIndex}_Crystal_$c" -type "Cube" `
            -x $cx -y ($island.h + 22) -z $cz `
            -ry (Get-Random -Minimum 0 -Maximum 360) `
            -sx 2 -sy 12 -sz 2 `
            -color $crystalColors[$c] `
            -metallic 0.2 -smoothness 0.95 `
            -parent "FloatingIslands"
        
        Set-Material -name "Island_${islandIndex}_Crystal_$c" `
            -emission @{ r = $crystalColors[$c].r; g = $crystalColors[$c].g; b = $crystalColors[$c].b; intensity = 3.0 }
        $totalObjects++
    }
    
    $islandIndex++
}

Write-Host "[OK] Floating Islands: 12 objects" -ForegroundColor Green

# ============================================================================
# SECTION 7: MAGICAL PORTALS (4 cardinal directions, far out)
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 7: MAGICAL PORTALS ===" -ForegroundColor Magenta

New-Group -name "MagicalPortals"

$portals = @(
    @{x = 0; z = 250; name = "North"; color = @{r = 1.0; g = 0.0; b = 1.0}},
    @{x = 0; z = -250; name = "South"; color = @{r = 1.0; g = 1.0; b = 0.0}},
    @{x = 250; z = 0; name = "East"; color = @{r = 0.0; g = 1.0; b = 1.0}},
    @{x = -250; z = 0; name = "West"; color = @{r = 1.0; g = 0.5; b = 0.0}}
)

foreach ($portal in $portals) {
    Write-Host "  [PORTAL] $($portal.name)..." -ForegroundColor Gray
    
    # Frame (4 sides)
    for ($side = 0; $side -lt 4; $side++) {
        $frameSX = if ($side % 2 -eq 0) { 2 } else { 14 }
        $frameSZ = if ($side % 2 -eq 0) { 14 } else { 2 }
        $frameX = $portal.x
        $frameZ = $portal.z
        if ($side -eq 0) { $frameZ += 6 }
        if ($side -eq 1) { $frameX += 6 }
        if ($side -eq 2) { $frameZ -= 6 }
        if ($side -eq 3) { $frameX -= 6 }
        
        Build-ColoredObject -name "Portal_$($portal.name)_Frame_$side" -type "Cube" `
            -x $frameX -y 12 -z $frameZ `
            -sx $frameSX -sy 20 -sz $frameSZ `
            -color @{ r = 0.1; g = 0.05; b = 0.15 } `
            -metallic 0.8 -smoothness 0.7 `
            -parent "MagicalPortals"
        $totalObjects++
    }
    
    # Field
    Build-ColoredObject -name "Portal_$($portal.name)_Field" -type "Cube" `
        -x $portal.x -y 12 -z $portal.z `
        -sx 0.5 -sy 18 -sz 10 `
        -color $portal.color `
        -metallic 0.3 -smoothness 0.95 `
        -parent "MagicalPortals"
    
    Set-Material -name "Portal_$($portal.name)_Field" `
        -emission @{ r = $portal.color.r; g = $portal.color.g; b = $portal.color.b; intensity = 3.5 }
    $totalObjects++
}

Write-Host "[OK] Magical Portals: 20 objects" -ForegroundColor Green

# ============================================================================
# SECTION 8: FORESTS (4 quadrants)
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 8: EPIC FORESTS ===" -ForegroundColor Magenta

# OAK GROVE (Northeast)
Write-Host "  [FOREST] Oak Grove..." -ForegroundColor Gray
New-Group -name "OakGrove"

for ($i = 0; $i -lt 12; $i++) {
    $x = Get-Random -Minimum 180 -Maximum 280
    $z = Get-Random -Minimum 180 -Maximum 280
    $trunkHeight = Get-Random -Minimum 12 -Maximum 18
    $canopySize = Get-Random -Minimum 14 -Maximum 20
    
    Build-ColoredObject -name "Oak_${i}_Trunk" -type "Cylinder" `
        -x $x -y ($trunkHeight / 2) -z $z `
        -sx 1.5 -sy $trunkHeight -sz 1.5 `
        -color @{ r = 0.4; g = 0.25; b = 0.1 } `
        -metallic 0.0 -smoothness 0.2 `
        -parent "OakGrove"
    $totalObjects++
    
    Build-ColoredObject -name "Oak_${i}_Canopy" -type "Sphere" `
        -x $x -y ($trunkHeight + $canopySize/2) -z $z `
        -sx $canopySize -sy $canopySize -sz $canopySize `
        -color @{ r = 0.15; g = 0.5; b = 0.1 } `
        -metallic 0.0 -smoothness 0.1 `
        -parent "OakGrove"
    $totalObjects++
}

Write-Host "  [OK] Oak Grove: 24 objects" -ForegroundColor DarkGreen

# PINE FOREST (Northwest)
Write-Host "  [FOREST] Pine Forest..." -ForegroundColor Gray
New-Group -name "PineForest"

for ($i = 0; $i -lt 10; $i++) {
    $x = Get-Random -Minimum -280 -Maximum -180
    $z = Get-Random -Minimum 180 -Maximum 280
    $trunkHeight = Get-Random -Minimum 18 -Maximum 25
    
    Build-ColoredObject -name "Pine_${i}_Trunk" -type "Cylinder" `
        -x $x -y ($trunkHeight / 2) -z $z `
        -sx 1.0 -sy $trunkHeight -sz 1.0 `
        -color @{ r = 0.3; g = 0.2; b = 0.08 } `
        -metallic 0.0 -smoothness 0.15 `
        -parent "PineForest"
    $totalObjects++
    
    for ($layer = 0; $layer -lt 4; $layer++) {
        $layerHeight = $trunkHeight + 4 + ($layer * 4)
        $layerSize = 12 - ($layer * 2)
        
        Build-ColoredObject -name "Pine_${i}_Layer_$layer" -type "Cylinder" `
            -x $x -y $layerHeight -z $z `
            -sx $layerSize -sy 3 -sz $layerSize `
            -color @{ r = 0.08; g = 0.35; b = 0.08 } `
            -metallic 0.0 -smoothness 0.05 `
            -parent "PineForest"
        $totalObjects++
    }
}

Write-Host "  [OK] Pine Forest: 50 objects" -ForegroundColor DarkGreen

# BIRCH GROVE (Southwest)
Write-Host "  [FOREST] Birch Grove..." -ForegroundColor Gray
New-Group -name "BirchGrove"

for ($i = 0; $i -lt 8; $i++) {
    $x = Get-Random -Minimum -280 -Maximum -180
    $z = Get-Random -Minimum -280 -Maximum -180
    $trunkHeight = Get-Random -Minimum 14 -Maximum 20
    $canopySize = Get-Random -Minimum 10 -Maximum 15
    
    Build-ColoredObject -name "Birch_${i}_Trunk" -type "Cylinder" `
        -x $x -y ($trunkHeight / 2) -z $z `
        -sx 1.0 -sy $trunkHeight -sz 1.0 `
        -color @{ r = 0.95; g = 0.95; b = 0.9 } `
        -metallic 0.0 -smoothness 0.3 `
        -parent "BirchGrove"
    $totalObjects++
    
    Build-ColoredObject -name "Birch_${i}_Canopy" -type "Sphere" `
        -x $x -y ($trunkHeight + $canopySize/2) -z $z `
        -sx $canopySize -sy ($canopySize * 0.8) -sz $canopySize `
        -color @{ r = 0.5; g = 0.8; b = 0.3 } `
        -metallic 0.0 -smoothness 0.1 `
        -parent "BirchGrove"
    $totalObjects++
}

Write-Host "  [OK] Birch Grove: 16 objects" -ForegroundColor DarkGreen

# MAGICAL WILLOWS (Southeast)
Write-Host "  [FOREST] Magical Willows..." -ForegroundColor Gray
New-Group -name "MagicalWillows"

for ($i = 0; $i -lt 6; $i++) {
    $x = Get-Random -Minimum 180 -Maximum 280
    $z = Get-Random -Minimum -280 -Maximum -180
    $trunkHeight = Get-Random -Minimum 10 -Maximum 14
    
    Build-ColoredObject -name "Willow_${i}_Trunk" -type "Cylinder" `
        -x $x -y ($trunkHeight / 2) -z $z `
        -sx 1.8 -sy $trunkHeight -sz 1.8 `
        -color @{ r = 0.4; g = 0.2; b = 0.3 } `
        -metallic 0.0 -smoothness 0.2 `
        -parent "MagicalWillows"
    $totalObjects++
    
    Build-ColoredObject -name "Willow_${i}_Canopy" -type "Sphere" `
        -x $x -y ($trunkHeight + 4) -z $z `
        -sx 16 -sy 12 -sz 16 `
        -color @{ r = 0.2; g = 0.6; b = 0.5 } `
        -metallic 0.0 -smoothness 0.15 `
        -parent "MagicalWillows"
    $totalObjects++
    
    # Glowing vines
    for ($vine = 0; $vine -lt 4; $vine++) {
        $vAngle = ($vine * 90) * [Math]::PI / 180
        $vx = $x + ([Math]::Cos($vAngle) * 6)
        $vz = $z + ([Math]::Sin($vAngle) * 6)
        
        Build-ColoredObject -name "Willow_${i}_Vine_$vine" -type "Cylinder" `
            -x $vx -y ($trunkHeight - 2) -z $vz `
            -sx 0.3 -sy 8 -sz 0.3 `
            -color @{ r = 0.3; g = 0.8; b = 0.7 } `
            -metallic 0.0 -smoothness 0.4 `
            -parent "MagicalWillows"
        
        Set-Material -name "Willow_${i}_Vine_$vine" `
            -emission @{ r = 0.2; g = 0.6; b = 0.5; intensity = 1.5 }
        $totalObjects++
    }
}

Write-Host "  [OK] Magical Willows: 30 objects" -ForegroundColor DarkGreen

Write-Host "[OK] All Forests: 120 objects" -ForegroundColor Green

# ============================================================================
# SECTION 9: AMBIENT DETAILS
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 9: AMBIENT DETAILS ===" -ForegroundColor Magenta

New-Group -name "AmbientDetails"

# 20 Floating orbs
for ($i = 0; $i -lt 20; $i++) {
    $x = Get-Random -Minimum -200 -Maximum 200
    $z = Get-Random -Minimum -200 -Maximum 200
    $y = Get-Random -Minimum 20 -Maximum 80
    $size = Get-Random -Minimum 1.0 -Maximum 2.5
    
    $orbColors = @(
        @{ r = 1.0; g = 0.8; b = 0.2 },
        @{ r = 0.8; g = 0.2; b = 1.0 },
        @{ r = 0.2; g = 0.8; b = 1.0 }
    )
    $orbColor = $orbColors | Get-Random
    
    Build-ColoredObject -name "Orb_$i" -type "Sphere" `
        -x $x -y $y -z $z `
        -sx $size -sy $size -sz $size `
        -color $orbColor `
        -metallic 0.1 -smoothness 1.0 `
        -parent "AmbientDetails"
    
    Set-Material -name "Orb_$i" `
        -emission @{ r = $orbColor.r; g = $orbColor.g; b = $orbColor.b; intensity = 2.0 }
    $totalObjects++
}

# 15 Glowing mushrooms scattered
for ($i = 0; $i -lt 15; $i++) {
    $x = Get-Random -Minimum -250 -Maximum 250
    $z = Get-Random -Minimum -250 -Maximum 250
    
    Build-ColoredObject -name "Mushroom_${i}_Stem" -type "Cylinder" `
        -x $x -y 0.8 -z $z `
        -sx 0.4 -sy 0.8 -sz 0.4 `
        -color @{ r = 0.9; g = 0.85; b = 0.7 } `
        -metallic 0.0 -smoothness 0.2 `
        -parent "AmbientDetails"
    $totalObjects++
    
    $capColors = @(
        @{ r = 1.0; g = 0.2; b = 0.2 },
        @{ r = 0.8; g = 0.2; b = 1.0 }
    )
    $capColor = $capColors | Get-Random
    
    Build-ColoredObject -name "Mushroom_${i}_Cap" -type "Sphere" `
        -x $x -y 2.0 -z $z `
        -sx 2.0 -sy 1.0 -sz 2.0 `
        -color $capColor `
        -metallic 0.0 -smoothness 0.6 `
        -parent "AmbientDetails"
    
    Set-Material -name "Mushroom_${i}_Cap" `
        -emission @{ r = $capColor.r; g = $capColor.g; b = $capColor.b; intensity = 2.0 }
    $totalObjects++
}

Write-Host "[OK] Ambient Details: 50 objects" -ForegroundColor Green

# ============================================================================
# FINAL STATS
# ============================================================================
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  ULTIMATE COMPLETE WORLD CREATED!" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

$duration = (Get-Date) - $startTime
$minutes = [Math]::Floor($duration.TotalMinutes)
$seconds = $duration.Seconds

Write-Host "  Total Objects: $totalObjects" -ForegroundColor White
Write-Host "  Generation Time: ${minutes}m ${seconds}s" -ForegroundColor White
Write-Host ""
Write-Host "  WORLD FEATURES:" -ForegroundColor Yellow
Write-Host "    1. Medieval Castle (center, with keep & towers)" -ForegroundColor Gray
Write-Host "    2. Crystal Cathedral (north, elevated platform)" -ForegroundColor Gray
Write-Host "    3. Tower Bridge (connecting castle to cathedral)" -ForegroundColor Gray
Write-Host "    4. Sci-Fi Towers (east & west, glowing)" -ForegroundColor Gray
Write-Host "    5. Floating Islands (3 corners, with crystals)" -ForegroundColor Gray
Write-Host "    6. Magical Portals (4 cardinal directions)" -ForegroundColor Gray
Write-Host "    7. Oak Grove (NE quadrant)" -ForegroundColor Gray
Write-Host "    8. Pine Forest (NW quadrant)" -ForegroundColor Gray
Write-Host "    9. Birch Grove (SW quadrant)" -ForegroundColor Gray
Write-Host "   10. Magical Willows (SE quadrant, glowing vines)" -ForegroundColor Gray
Write-Host "   11. Floating Orbs (ambient magic)" -ForegroundColor Gray
Write-Host "   12. Glowing Mushrooms (forest floor)" -ForegroundColor Gray
Write-Host ""
Write-Host "  PLAYABLE AREA: 3000x3000 units" -ForegroundColor White
Write-Host "  DRAW CALLS: ~$totalObjects (unoptimized for color preservation)" -ForegroundColor White
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  This is the ULTIMATE world - EVERYTHING combined!" -ForegroundColor Green
Write-Host "  Run around with your player and explore!" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""
