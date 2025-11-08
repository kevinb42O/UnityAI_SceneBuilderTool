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
    "OakGrove", "PineForest", "BirchGrove", "MagicalWillows", "ForestUndergrowth",
    "MedievalCastle", "TowerBridge", "AmbientDetails", "ParcoursSystem"
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
    
    # Add trees to floating islands (4-5 per island)
    $treeCount = Get-Random -Minimum 4 -Maximum 6
    for ($t = 0; $t -lt $treeCount; $t++) {
        $tAngle = (Get-Random -Minimum 0 -Maximum 360) * [Math]::PI / 180
        $tRadius = Get-Random -Minimum 8 -Maximum 14
        $tx = $island.x + ([Math]::Cos($tAngle) * $tRadius)
        $tz = $island.z + ([Math]::Sin($tAngle) * $tRadius)
        $treeHeight = Get-Random -Minimum 8 -Maximum 12
        
        # Tree trunk
        Build-ColoredObject -name "Island_${islandIndex}_Tree_${t}_Trunk" -type "Cylinder" `
            -x $tx -y ($island.h + 8 + $treeHeight/2) -z $tz `
            -sx 0.8 -sy $treeHeight -sz 0.8 `
            -color @{ r = 0.35; g = 0.22; b = 0.1 } `
            -metallic 0.0 -smoothness 0.2 `
            -parent "FloatingIslands"
        $totalObjects++
        
        # Tree canopy
        Build-ColoredObject -name "Island_${islandIndex}_Tree_${t}_Canopy" -type "Sphere" `
            -x $tx -y ($island.h + 8 + $treeHeight + 4) -z $tz `
            -sx 6 -sy 6 -sz 6 `
            -color @{ r = 0.1; g = 0.45; b = 0.15 } `
            -metallic 0.0 -smoothness 0.1 `
            -parent "FloatingIslands"
        $totalObjects++
    }
    
    $islandIndex++
}

Write-Host "[OK] Floating Islands: ~40 objects (with trees)" -ForegroundColor Green

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
# SECTION 8B: FALLEN TRUNKS & ENHANCED FOREST FLOOR
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 8B: FALLEN TRUNKS & FOREST FLOOR ===" -ForegroundColor Magenta
Write-Host "  Creating realistic fallen logs, stumps, and forest debris..." -ForegroundColor Gray

New-Group -name "FallenTrunks"

# Oak Grove fallen logs (NE quadrant)
Write-Host "  [LOGS] Oak Grove fallen trunks..." -ForegroundColor DarkGreen
for ($i = 0; $i -lt 8; $i++) {
    $x = Get-Random -Minimum 180 -Maximum 280
    $z = Get-Random -Minimum 180 -Maximum 280
    $logLength = Get-Random -Minimum 8 -Maximum 16
    $logWidth = Get-Random -Minimum 1.2 -Maximum 2.0
    $rotY = Get-Random -Minimum 0 -Maximum 360
    $rotZ = Get-Random -Minimum 80 -Maximum 100  # Nearly horizontal
    
    # Main fallen trunk - rotated to lie on ground
    Build-ColoredObject -name "FallenOak_$i" -type "Cylinder" `
        -x $x -y ($logWidth * 0.6) -z $z `
        -rx 0 -ry $rotY -rz $rotZ `
        -sx $logWidth -sy $logLength -sz $logWidth `
        -color @{ r = 0.35; g = 0.22; b = 0.08 } `
        -metallic 0.0 -smoothness 0.15 `
        -parent "FallenTrunks"
    $totalObjects++
    
    # Moss patches on log (2-3 per log)
    $mossCount = Get-Random -Minimum 2 -Maximum 4
    for ($m = 0; $m -lt $mossCount; $m++) {
        $mossOffset = (($m / $mossCount) - 0.5) * $logLength * 0.8
        $mossAngle = $rotY * [Math]::PI / 180
        $mx = $x + ([Math]::Cos($mossAngle) * $mossOffset)
        $mz = $z + ([Math]::Sin($mossAngle) * $mossOffset)
        
        Build-ColoredObject -name "FallenOak_${i}_Moss_$m" -type "Sphere" `
            -x $mx -y ($logWidth * 0.8) -z $mz `
            -sx ($logWidth * 0.6) -sy 0.4 -sz ($logWidth * 0.6) `
            -color @{ r = 0.1; g = 0.45; b = 0.15 } `
            -metallic 0.0 -smoothness 0.1 `
            -parent "FallenTrunks"
        $totalObjects++
    }
    
    # Cut stump near some logs
    if ($i % 3 -eq 0) {
        $stumpX = $x + (Get-Random -Minimum -5 -Maximum 5)
        $stumpZ = $z + (Get-Random -Minimum -5 -Maximum 5)
        $stumpHeight = Get-Random -Minimum 1.5 -Maximum 3.0
        
        Build-ColoredObject -name "OakStump_$i" -type "Cylinder" `
            -x $stumpX -y ($stumpHeight / 2) -z $stumpZ `
            -sx 1.8 -sy $stumpHeight -sz 1.8 `
            -color @{ r = 0.4; g = 0.25; b = 0.1 } `
            -metallic 0.0 -smoothness 0.1 `
            -parent "FallenTrunks"
        $totalObjects++
    }
}

# Pine Forest fallen logs (NW quadrant)
Write-Host "  [LOGS] Pine Forest fallen trunks..." -ForegroundColor DarkGreen
for ($i = 0; $i -lt 6; $i++) {
    $x = Get-Random -Minimum -280 -Maximum -180
    $z = Get-Random -Minimum 180 -Maximum 280
    $logLength = Get-Random -Minimum 12 -Maximum 20
    $logWidth = Get-Random -Minimum 0.9 -Maximum 1.4
    $rotY = Get-Random -Minimum 0 -Maximum 360
    $rotZ = Get-Random -Minimum 85 -Maximum 95
    
    Build-ColoredObject -name "FallenPine_$i" -type "Cylinder" `
        -x $x -y ($logWidth * 0.5) -z $z `
        -rx 0 -ry $rotY -rz $rotZ `
        -sx $logWidth -sy $logLength -sz $logWidth `
        -color @{ r = 0.28; g = 0.18; b = 0.06 } `
        -metallic 0.0 -smoothness 0.1 `
        -parent "FallenTrunks"
    $totalObjects++
    
    # Scattered pine needles/branches
    for ($b = 0; $b -lt 3; $b++) {
        $branchOffset = (($b / 3.0) - 0.5) * $logLength * 0.7
        $branchAngle = $rotY * [Math]::PI / 180
        $bx = $x + ([Math]::Cos($branchAngle) * $branchOffset)
        $bz = $z + ([Math]::Sin($branchAngle) * $branchOffset)
        
        Build-ColoredObject -name "FallenPine_${i}_Branch_$b" -type "Cylinder" `
            -x $bx -y 0.8 -z $bz `
            -rx (Get-Random -Minimum 60 -Maximum 90) `
            -ry (Get-Random -Minimum 0 -Maximum 360) `
            -sx 0.3 -sy 2.5 -sz 0.3 `
            -color @{ r = 0.25; g = 0.15; b = 0.05 } `
            -metallic 0.0 -smoothness 0.05 `
            -parent "FallenTrunks"
        $totalObjects++
    }
}

# Birch Grove fallen logs (SW quadrant)
Write-Host "  [LOGS] Birch Grove fallen trunks..." -ForegroundColor DarkGreen
for ($i = 0; $i -lt 5; $i++) {
    $x = Get-Random -Minimum -280 -Maximum -180
    $z = Get-Random -Minimum -280 -Maximum -180
    $logLength = Get-Random -Minimum 10 -Maximum 16
    $logWidth = Get-Random -Minimum 0.8 -Maximum 1.2
    $rotY = Get-Random -Minimum 0 -Maximum 360
    $rotZ = Get-Random -Minimum 82 -Maximum 98
    
    # White birch log
    Build-ColoredObject -name "FallenBirch_$i" -type "Cylinder" `
        -x $x -y ($logWidth * 0.5) -z $z `
        -rx 0 -ry $rotY -rz $rotZ `
        -sx $logWidth -sy $logLength -sz $logWidth `
        -color @{ r = 0.9; g = 0.9; b = 0.85 } `
        -metallic 0.0 -smoothness 0.25 `
        -parent "FallenTrunks"
    $totalObjects++
    
    # Black stripes on fallen birch
    for ($stripe = 0; $stripe -lt 3; $stripe++) {
        $stripeOffset = (($stripe / 3.0) - 0.5) * $logLength * 0.6
        $stripeAngle = $rotY * [Math]::PI / 180
        $sx = $x + ([Math]::Cos($stripeAngle) * $stripeOffset)
        $sz = $z + ([Math]::Sin($stripeAngle) * $stripeOffset)
        
        Build-ColoredObject -name "FallenBirch_${i}_Stripe_$stripe" -type "Cube" `
            -x $sx -y ($logWidth * 0.6) -z $sz `
            -ry $rotY -rz $rotZ `
            -sx ($logWidth * 1.2) -sy 0.8 -sz ($logWidth * 1.2) `
            -color @{ r = 0.15; g = 0.15; b = 0.15 } `
            -metallic 0.0 -smoothness 0.2 `
            -parent "FallenTrunks"
        $totalObjects++
    }
}

# Willow Grove fallen logs with GLOWING MOSS (SE quadrant)
Write-Host "  [LOGS] Magical Willow fallen trunks..." -ForegroundColor Cyan
for ($i = 0; $i -lt 4; $i++) {
    $x = Get-Random -Minimum 180 -Maximum 280
    $z = Get-Random -Minimum -280 -Maximum -180
    $logLength = Get-Random -Minimum 12 -Maximum 18
    $logWidth = Get-Random -Minimum 1.4 -Maximum 2.0
    $rotY = Get-Random -Minimum 0 -Maximum 360
    $rotZ = Get-Random -Minimum 84 -Maximum 96
    
    Build-ColoredObject -name "FallenWillow_$i" -type "Cylinder" `
        -x $x -y ($logWidth * 0.6) -z $z `
        -rx 0 -ry $rotY -rz $rotZ `
        -sx $logWidth -sy $logLength -sz $logWidth `
        -color @{ r = 0.35; g = 0.18; b = 0.25 } `
        -metallic 0.0 -smoothness 0.15 `
        -parent "FallenTrunks"
    $totalObjects++
    
    # GLOWING moss patches (magical!)
    $glowMossCount = Get-Random -Minimum 3 -Maximum 5
    for ($gm = 0; $gm -lt $glowMossCount; $gm++) {
        $gmOffset = (($gm / $glowMossCount) - 0.5) * $logLength * 0.8
        $gmAngle = $rotY * [Math]::PI / 180
        $gmx = $x + ([Math]::Cos($gmAngle) * $gmOffset)
        $gmz = $z + ([Math]::Sin($gmAngle) * $gmOffset)
        
        Build-ColoredObject -name "FallenWillow_${i}_GlowMoss_$gm" -type "Sphere" `
            -x $gmx -y ($logWidth * 0.9) -z $gmz `
            -sx ($logWidth * 0.5) -sy 0.3 -sz ($logWidth * 0.5) `
            -color @{ r = 0.2; g = 0.6; b = 0.5 } `
            -metallic 0.0 -smoothness 0.3 `
            -parent "FallenTrunks"
        
        Set-Material -name "FallenWillow_${i}_GlowMoss_$gm" `
            -emission @{ r = 0.2; g = 0.6; b = 0.5; intensity = 2.0 }
        $totalObjects++
    }
}

# LOG BRIDGES - Genius parkour integration!
Write-Host "  [BRIDGES] Natural log bridges between zones..." -ForegroundColor Yellow

# Log bridge from Oak Grove toward Castle
$logBridgeX = 100
$logBridgeZ = 100
Build-ColoredObject -name "LogBridge_OakToCastle" -type "Cylinder" `
    -x $logBridgeX -y 2.5 -z $logBridgeZ `
    -rx 0 -ry 45 -rz 88 `
    -sx 1.5 -sy 25 -sz 1.5 `
    -color @{ r = 0.38; g = 0.24; b = 0.09 } `
    -metallic 0.0 -smoothness 0.2 `
    -parent "FallenTrunks"
$totalObjects++

# Supporting logs for bridge (pile structure)
for ($pile = 0; $pile -lt 3; $pile++) {
    $pileX = $logBridgeX + (Get-Random -Minimum -2 -Maximum 2)
    $pileZ = $logBridgeZ + (Get-Random -Minimum -2 -Maximum 2)
    
    Build-ColoredObject -name "LogBridge_Support_$pile" -type "Cylinder" `
        -x $pileX -y 1.2 -z $pileZ `
        -rx (Get-Random -Minimum 0 -Maximum 30) `
        -ry (Get-Random -Minimum 0 -Maximum 360) `
        -rz (Get-Random -Minimum 70 -Maximum 110) `
        -sx 0.8 -sy 5 -sz 0.8 `
        -color @{ r = 0.35; g = 0.22; b = 0.08 } `
        -metallic 0.0 -smoothness 0.1 `
        -parent "FallenTrunks"
    $totalObjects++
}

# Log bridge from Pine Forest
$logBridgeX2 = -100
$logBridgeZ2 = 100
Build-ColoredObject -name "LogBridge_PineToCastle" -type "Cylinder" `
    -x $logBridgeX2 -y 2.8 -z $logBridgeZ2 `
    -rx 0 -ry -45 -rz 87 `
    -sx 1.4 -sy 28 -sz 1.4 `
    -color @{ r = 0.28; g = 0.18; b = 0.06 } `
    -metallic 0.0 -smoothness 0.15 `
    -parent "FallenTrunks"
$totalObjects++

# HOLLOW LOG TUNNELS - Genius feature!
Write-Host "  [TUNNELS] Creating hollow log tunnels..." -ForegroundColor Yellow

# Tunnel in Oak Grove
$tunnelX = 220
$tunnelZ = 220
Build-ColoredObject -name "HollowLog_Oak" -type "Cylinder" `
    -x $tunnelX -y 2.5 -z $tunnelZ `
    -rx 0 -ry 30 -rz 90 `
    -sx 2.5 -sy 12 -sz 2.5 `
    -color @{ r = 0.32; g = 0.20; b = 0.07 } `
    -metallic 0.0 -smoothness 0.1 `
    -parent "FallenTrunks"
$totalObjects++

# Tunnel opening markers (glowing for visibility)
for ($opening = 0; $opening -lt 2; $opening++) {
    $openOffset = ($opening - 0.5) * 12
    $openAngle = 30 * [Math]::PI / 180
    $ox = $tunnelX + ([Math]::Cos($openAngle) * $openOffset)
    $oz = $tunnelZ + ([Math]::Sin($openAngle) * $openOffset)
    
    Build-ColoredObject -name "HollowLog_Oak_Opening_$opening" -type "Sphere" `
        -x $ox -y 2.5 -z $oz `
        -sx 1.0 -sy 1.0 -sz 1.0 `
        -color @{ r = 1.0; g = 0.8; b = 0.3 } `
        -metallic 0.0 -smoothness 0.9 `
        -parent "FallenTrunks"
    
    Set-Material -name "HollowLog_Oak_Opening_$opening" `
        -emission @{ r = 1.0; g = 0.8; b = 0.3; intensity = 1.5 }
    $totalObjects++
}

# Tunnel in Pine Forest
$tunnelX2 = -220
$tunnelZ2 = 220
Build-ColoredObject -name "HollowLog_Pine" -type "Cylinder" `
    -x $tunnelX2 -y 2.8 -z $tunnelZ2 `
    -rx 0 -ry -35 -rz 90 `
    -sx 2.2 -sy 15 -sz 2.2 `
    -color @{ r = 0.25; g = 0.16; b = 0.05 } `
    -metallic 0.0 -smoothness 0.08 `
    -parent "FallenTrunks"
$totalObjects++

# LOG PILE OBSTACLES - Complex structures
Write-Host "  [PILES] Creating log pile structures..." -ForegroundColor Yellow

$pileLocations = @(
    @{x = 160; z = 160; count = 6; name = "OakPile1"},
    @{x = -160; z = 160; count = 5; name = "PinePile1"},
    @{x = 200; z = -200; name = "WillowPile1"; count = 4}
)

foreach ($pileLocation in $pileLocations) {
    $baseX = $pileLocation.x
    $baseZ = $pileLocation.z
    $logCount = $pileLocation.count
    $pileName = $pileLocation.name
    
    for ($log = 0; $log -lt $logCount; $log++) {
        $layerHeight = 0.8 + ($log * 1.2)
        $offsetX = Get-Random -Minimum -2 -Maximum 2
        $offsetZ = Get-Random -Minimum -2 -Maximum 2
        $logLen = Get-Random -Minimum 4 -Maximum 7
        $logW = Get-Random -Minimum 0.6 -Maximum 1.0
        
        Build-ColoredObject -name "${pileName}_Log_$log" -type "Cylinder" `
            -x ($baseX + $offsetX) -y $layerHeight -z ($baseZ + $offsetZ) `
            -rx (Get-Random -Minimum -20 -Maximum 20) `
            -ry (Get-Random -Minimum 0 -Maximum 360) `
            -rz (Get-Random -Minimum 70 -Maximum 110) `
            -sx $logW -sy $logLen -sz $logW `
            -color @{ r = 0.35; g = 0.22; b = 0.08 } `
            -metallic 0.0 -smoothness 0.12 `
            -parent "FallenTrunks"
        $totalObjects++
    }
}

# NATURAL LOG BENCHES near key locations
Write-Host "  [BENCHES] Adding log benches near landmarks..." -ForegroundColor Yellow

$benchLocations = @(
    @{x = 45; z = 45; name = "CastleCourtyard"},
    @{x = 15; z = 100; name = "BridgeViewpoint"},
    @{x = -180; z = 0; name = "WestTowerBase"}
)

foreach ($benchLoc in $benchLocations) {
    # Main bench log
    Build-ColoredObject -name "LogBench_$($benchLoc.name)" -type "Cylinder" `
        -x $benchLoc.x -y 1.5 -z $benchLoc.z `
        -rx 0 -ry 45 -rz 90 `
        -sx 1.0 -sy 6 -sz 1.0 `
        -color @{ r = 0.38; g = 0.24; b = 0.09 } `
        -metallic 0.0 -smoothness 0.2 `
        -parent "FallenTrunks"
    $totalObjects++
    
    # Backrest log
    Build-ColoredObject -name "LogBench_$($benchLoc.name)_Back" -type "Cylinder" `
        -x $benchLoc.x -y 2.5 -z ($benchLoc.z - 0.8) `
        -rx 20 -ry 45 -rz 90 `
        -sx 0.7 -sy 5.5 -sz 0.7 `
        -color @{ r = 0.36; g = 0.23; b = 0.08 } `
        -metallic 0.0 -smoothness 0.18 `
        -parent "FallenTrunks"
    $totalObjects++
}

# SCATTERED BRANCHES throughout
Write-Host "  [SCATTER] Adding scattered branches and twigs..." -ForegroundColor DarkGray

for ($scatter = 0; $scatter -lt 40; $scatter++) {
    # Distribute across all quadrants
    $quadrant = Get-Random -Minimum 0 -Maximum 4
    switch ($quadrant) {
        0 { $sx = Get-Random -Minimum 140 -Maximum 280; $sz = Get-Random -Minimum 140 -Maximum 280 }
        1 { $sx = Get-Random -Minimum -280 -Maximum -140; $sz = Get-Random -Minimum 140 -Maximum 280 }
        2 { $sx = Get-Random -Minimum -280 -Maximum -140; $sz = Get-Random -Minimum -280 -Maximum -140 }
        3 { $sx = Get-Random -Minimum 140 -Maximum 280; $sz = Get-Random -Minimum -280 -Maximum -140 }
    }
    
    $branchLen = Get-Random -Minimum 1.5 -Maximum 4.0
    $branchW = Get-Random -Minimum 0.15 -Maximum 0.4
    
    Build-ColoredObject -name "Branch_Scatter_$scatter" -type "Cylinder" `
        -x $sx -y ($branchW * 0.5) -z $sz `
        -rx (Get-Random -Minimum 0 -Maximum 30) `
        -ry (Get-Random -Minimum 0 -Maximum 360) `
        -rz (Get-Random -Minimum 70 -Maximum 110) `
        -sx $branchW -sy $branchLen -sz $branchW `
        -color @{ r = 0.3; g = 0.18; b = 0.06 } `
        -metallic 0.0 -smoothness 0.05 `
        -parent "FallenTrunks"
    $totalObjects++
}

Write-Host "[OK] Fallen Trunks & Forest Floor: ~150 objects" -ForegroundColor Green

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
# SECTION 9B: ADVANCED FOREST BIOME (Procedurally Generated)
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 9B: ADVANCED FOREST BIOME ===" -ForegroundColor Magenta
Write-Host "  Generating massive realistic temperate deciduous forest..." -ForegroundColor Gray
Write-Host "  This uses Unity's procedural world generation API" -ForegroundColor Gray
Write-Host ""

# Position the advanced forest in a new area (far corner)
$forestOffsetX = -400
$forestOffsetZ = -400

Write-Host "  [BIOME] Positioning advanced forest at ($forestOffsetX, $forestOffsetZ)..." -ForegroundColor Yellow
Write-Host "  [BIOME] World Size: 120m x 120m" -ForegroundColor Gray
Write-Host "  [BIOME] Density: 80 (Dense temperate forest)" -ForegroundColor Gray
Write-Host "  [BIOME] Features: Multi-layered canopy, fallen logs, stumps, boulders" -ForegroundColor Gray
Write-Host ""

$advancedForestSettings = @{
    biome = "Forest"
    worldSize = 120
    density = 80
    includeTerrain = $true
    includeLighting = $false  # We already have lighting
    includeProps = $true
    optimizeMeshes = $false
    seed = "UltimateWorldForest2025"
    offsetX = $forestOffsetX
    offsetZ = $forestOffsetZ
} | ConvertTo-Json

$forestStartTime = Get-Date

try {
    Write-Host "  [GENERATING] Please wait, creating realistic forest ecosystem..." -ForegroundColor Yellow
    
    $forestResult = Invoke-RestMethod -Uri "$UNITY_BASE/generateWorld" `
        -Method POST `
        -ContentType "application/json" `
        -Body $advancedForestSettings `
        -UseBasicParsing `
        -TimeoutSec 300
    
    if ($forestResult.success) {
        $forestDuration = (Get-Date) - $forestStartTime
        $forestSeconds = [math]::Round($forestDuration.TotalSeconds, 1)
        
        Write-Host ""
        Write-Host "  [SUCCESS] ADVANCED FOREST GENERATED!" -ForegroundColor Green
        Write-Host ""
        Write-Host "  Generation Statistics:" -ForegroundColor Cyan
        Write-Host "  =====================" -ForegroundColor Cyan
        Write-Host "  Total Forest Objects: $($forestResult.totalObjects)" -ForegroundColor White
        Write-Host "  Generation Time: ${forestSeconds}s" -ForegroundColor White
        Write-Host "  Biome Type: $($forestResult.biome)" -ForegroundColor White
        Write-Host "  World Name: $($forestResult.worldName)" -ForegroundColor White
        Write-Host ""
        
        # Add forest objects to total count
        $advancedForestObjects = $forestResult.totalObjects
        $totalObjects += $advancedForestObjects
        
        Write-Host "  [BIOME] Advanced Forest Features:" -ForegroundColor Yellow
        Write-Host "    - 4 Tree Species (Oak, Maple, Birch, Pine)" -ForegroundColor DarkGreen
        Write-Host "    - Multi-layered canopy system" -ForegroundColor DarkGreen
        Write-Host "    - Understory vegetation (saplings, bushes, ferns)" -ForegroundColor DarkGreen
        Write-Host "    - Forest floor debris (fallen logs, stumps, boulders)" -ForegroundColor DarkGreen
        Write-Host "    - Natural clearings with wildflowers" -ForegroundColor DarkGreen
        Write-Host "    - Realistic tree proportions and distributions" -ForegroundColor DarkGreen
        Write-Host ""
        Write-Host "[OK] Advanced Forest Biome: $advancedForestObjects objects" -ForegroundColor Green
        
    } else {
        Write-Host ""
        Write-Host "  [WARNING] Advanced forest generation failed: $($forestResult.error)" -ForegroundColor Yellow
        Write-Host "  [INFO] Continuing with rest of world generation..." -ForegroundColor Yellow
        Write-Host ""
        $advancedForestObjects = 0
    }
} catch {
    Write-Host ""
    Write-Host "  [WARNING] Could not generate advanced forest: $_" -ForegroundColor Yellow
    Write-Host "  [INFO] This feature requires Unity API endpoint /generateWorld" -ForegroundColor Gray
    Write-Host "  [INFO] Continuing with rest of world generation..." -ForegroundColor Yellow
    Write-Host ""
    $advancedForestObjects = 0
}

# ============================================================================
# SECTION 10: PARKOUR ROAD SYSTEM
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 10: PARKOUR ROAD SYSTEM ===" -ForegroundColor Magenta

New-Group -name "ParcoursSystem"

# Main ground road network (star pattern from castle to portals)
Write-Host "  [PARCOURS] Ground road network..." -ForegroundColor Gray

$roadColor = @{ r = 0.35; g = 0.32; b = 0.3 }
$roadWidth = 8

# Roads to each portal (4 main roads)
$roadDestinations = @(
    @{x = 0; z = 250; name = "North"},     # To North Portal
    @{x = 0; z = -250; name = "South"},    # To South Portal
    @{x = 250; z = 0; name = "East"},      # To East Portal
    @{x = -250; z = 0; name = "West"}      # To West Portal
)

foreach ($dest in $roadDestinations) {
    # Calculate segments for curved organic path
    $segments = 15
    for ($seg = 0; $seg -lt $segments; $seg++) {
        $progress = $seg / $segments
        $nextProgress = ($seg + 1) / $segments
        
        # Add organic curve
        $curveFactor = [Math]::Sin($progress * [Math]::PI) * 15
        
        $segX = $dest.x * $progress
        $segZ = $dest.z * $progress
        $nextX = $dest.x * $nextProgress
        $nextZ = $dest.z * $nextProgress
        
        # Apply perpendicular offset for curve
        if ([Math]::Abs($dest.x) -gt [Math]::Abs($dest.z)) {
            $segZ += $curveFactor
            $nextZ += [Math]::Sin($nextProgress * [Math]::PI) * 15
        } else {
            $segX += $curveFactor
            $nextX += [Math]::Sin($nextProgress * [Math]::PI) * 15
        }
        
        # Calculate road segment parameters
        $midX = ($segX + $nextX) / 2
        $midZ = ($segZ + $nextZ) / 2
        $length = [Math]::Sqrt(($nextX - $segX)*($nextX - $segX) + ($nextZ - $segZ)*($nextZ - $segZ))
        $angle = [Math]::Atan2(($nextX - $segX), ($nextZ - $segZ)) * 180 / [Math]::PI
        
        Build-ColoredObject -name "Road_$($dest.name)_$seg" -type "Cube" `
            -x $midX -y 0.1 -z $midZ `
            -ry $angle `
            -sx $roadWidth -sy 0.2 -sz $length `
            -color $roadColor `
            -metallic 0.1 -smoothness 0.3 `
            -parent "ParcoursSystem"
        $totalObjects++
    }
    
    # Road markers at intervals
    for ($marker = 1; $marker -lt 5; $marker++) {
        $markerProgress = $marker / 5.0
        $mx = $dest.x * $markerProgress
        $mz = $dest.z * $markerProgress
        
        # Glowing checkpoint marker
        Build-ColoredObject -name "RoadMarker_$($dest.name)_$marker" -type "Cylinder" `
            -x $mx -y 2.5 -z $mz `
            -sx 1.0 -sy 2.5 -sz 1.0 `
            -color @{ r = 0.2; g = 0.8; b = 1.0 } `
            -metallic 0.5 -smoothness 0.9 `
            -parent "ParcoursSystem"
        
        Set-Material -name "RoadMarker_$($dest.name)_$marker" `
            -emission @{ r = 0.2; g = 0.8; b = 1.0; intensity = 3.0 }
        $totalObjects++
    }
}

Write-Host "  [OK] Ground roads: ~80 objects" -ForegroundColor DarkGreen

# Elevated platforms from castle to floating islands
Write-Host "  [PARCOURS] Elevated platform system..." -ForegroundColor Gray

# Platform color scheme
$platformColor = @{ r = 0.25; g = 0.25; b = 0.28 }
$glowColor = @{ r = 1.0; g = 0.6; b = 0.2 }

# Castle roof to cathedral bridge connection
for ($i = 0; $i -lt 5; $i++) {
    $px = -10 + ($i * 2)
    $py = 42 + ($i * 3)
    $pz = 38 + ($i * 4)
    
    Build-ColoredObject -name "Platform_CastleToBridge_$i" -type "Cube" `
        -x $px -y $py -z $pz `
        -sx 5 -sy 0.5 -sz 5 `
        -color $platformColor `
        -metallic 0.7 -smoothness 0.6 `
        -parent "ParcoursSystem"
    $totalObjects++
    
    # Glowing edge marker
    Build-ColoredObject -name "Platform_CastleToBridge_${i}_Marker" -type "Cylinder" `
        -x $px -y ($py + 1.5) -z $pz `
        -sx 0.3 -sy 1.5 -sz 0.3 `
        -color $glowColor `
        -metallic 0.3 -smoothness 0.9 `
        -parent "ParcoursSystem"
    
    Set-Material -name "Platform_CastleToBridge_${i}_Marker" `
        -emission @{ r = $glowColor.r; g = $glowColor.g; b = $glowColor.b; intensity = 2.5 }
    $totalObjects++
}

# Bridge to Cathedral platforms
for ($i = 0; $i -lt 4; $i++) {
    $px = 0
    $py = 58 + ($i * 4)
    $pz = 100 + ($i * 3)
    
    Build-ColoredObject -name "Platform_BridgeToCathedral_$i" -type "Cube" `
        -x $px -y $py -z $pz `
        -sx 6 -sy 0.5 -sz 6 `
        -color $platformColor `
        -metallic 0.7 -smoothness 0.6 `
        -parent "ParcoursSystem"
    $totalObjects++
}

# Cathedral to Floating Islands (3 paths, one to each island)
$islandConnections = @(
    @{x = 150; z = 150; h = 80},   # Island 0
    @{x = -150; z = 150; h = 90},  # Island 1
    @{x = 150; z = -150; h = 85}   # Island 2
)

$islandIdx = 0
foreach ($island in $islandConnections) {
    Write-Host "  [PARCOURS] Path to Island $islandIdx..." -ForegroundColor Gray
    
    # Create stepping stone platforms from cathedral height to island
    $steps = 8
    $startX = 0
    $startZ = 120
    $startY = 70
    
    for ($step = 0; $step -lt $steps; $step++) {
        $progress = ($step + 1) / $steps
        $px = $startX + ($island.x - $startX) * $progress
        $pz = $startZ + ($island.z - $startZ) * $progress
        $py = $startY + ($island.h - $startY) * $progress
        
        # Add some vertical variation for challenge
        $py += [Math]::Sin($step * 0.8) * 5
        
        Build-ColoredObject -name "Platform_ToIsland${islandIdx}_$step" -type "Cube" `
            -x $px -y $py -z $pz `
            -rx (Get-Random -Minimum -5 -Maximum 5) `
            -ry (Get-Random -Minimum 0 -Maximum 360) `
            -sx 5 -sy 0.5 -sz 5 `
            -color $platformColor `
            -metallic 0.7 -smoothness 0.6 `
            -parent "ParcoursSystem"
        $totalObjects++
        
        # Checkpoint every other platform
        if ($step % 2 -eq 0) {
            Build-ColoredObject -name "Platform_ToIsland${islandIdx}_${step}_Checkpoint" -type "Sphere" `
                -x $px -y ($py + 2) -z $pz `
                -sx 1.2 -sy 1.2 -sz 1.2 `
                -color $glowColor `
                -metallic 0.2 -smoothness 0.95 `
                -parent "ParcoursSystem"
            
            Set-Material -name "Platform_ToIsland${islandIdx}_${step}_Checkpoint" `
                -emission @{ r = $glowColor.r; g = $glowColor.g; b = $glowColor.b; intensity = 3.0 }
            $totalObjects++
        }
    }
    
    $islandIdx++
}

# Inter-island connecting bridges
Write-Host "  [PARCOURS] Inter-island bridges..." -ForegroundColor Gray

# Bridge from Island 0 to Island 1
$bridgeSteps = 10
for ($i = 0; $i -lt $bridgeSteps; $i++) {
    $progress = $i / $bridgeSteps
    $bx = 150 + (-150 - 150) * $progress
    $bz = 150
    $by = 80 + (90 - 80) * $progress + [Math]::Sin($i * 0.5) * 3
    
    Build-ColoredObject -name "InterIslandBridge_0to1_$i" -type "Cube" `
        -x $bx -y $by -z $bz `
        -sx 4 -sy 0.4 -sz 4 `
        -color $platformColor `
        -metallic 0.6 -smoothness 0.7 `
        -parent "ParcoursSystem"
    $totalObjects++
}

# Bridge from Island 0 to Island 2
for ($i = 0; $i -lt $bridgeSteps; $i++) {
    $progress = $i / $bridgeSteps
    $bx = 150
    $bz = 150 + (-150 - 150) * $progress
    $by = 80 + (85 - 80) * $progress + [Math]::Sin($i * 0.5) * 3
    
    Build-ColoredObject -name "InterIslandBridge_0to2_$i" -type "Cube" `
        -x $bx -y $by -z $bz `
        -sx 4 -sy 0.4 -sz 4 `
        -color $platformColor `
        -metallic 0.6 -smoothness 0.7 `
        -parent "ParcoursSystem"
    $totalObjects++
}

Write-Host "  [OK] Inter-island bridges: 20 objects" -ForegroundColor DarkGreen

# Floating islands to Sci-Fi towers
Write-Host "  [PARCOURS] Island to tower connections..." -ForegroundColor Gray

# From Island 0 (150, 150) to East Tower (200, 0)
$spiralSteps = 12
for ($i = 0; $i -lt $spiralSteps; $i++) {
    $progress = $i / $spiralSteps
    $sx = 150 + (200 - 150) * $progress
    $sz = 150 + (0 - 150) * $progress
    $sy = 80 - ($progress * 60) + 20  # Descend from island to tower base
    
    # Spiral around tower as we approach
    if ($progress -gt 0.5) {
        $spiralAngle = ($i - $spiralSteps/2) * 30 * [Math]::PI / 180
        $spiralRadius = 15
        $sx = 200 + [Math]::Cos($spiralAngle) * $spiralRadius
        $sz = 0 + [Math]::Sin($spiralAngle) * $spiralRadius
        $sy = 20 + ($i - $spiralSteps/2) * 4
    }
    
    Build-ColoredObject -name "Platform_Island0ToEastTower_$i" -type "Cube" `
        -x $sx -y $sy -z $sz `
        -sx 4 -sy 0.4 -sz 4 `
        -color $platformColor `
        -metallic 0.7 -smoothness 0.6 `
        -parent "ParcoursSystem"
    $totalObjects++
}

# From Island 1 (-150, 150) to West Tower (-200, 0)
for ($i = 0; $i -lt $spiralSteps; $i++) {
    $progress = $i / $spiralSteps
    $sx = -150 + (-200 - (-150)) * $progress
    $sz = 150 + (0 - 150) * $progress
    $sy = 90 - ($progress * 70) + 20
    
    if ($progress -gt 0.5) {
        $spiralAngle = ($i - $spiralSteps/2) * 30 * [Math]::PI / 180
        $spiralRadius = 15
        $sx = -200 + [Math]::Cos($spiralAngle) * $spiralRadius
        $sz = 0 + [Math]::Sin($spiralAngle) * $spiralRadius
        $sy = 20 + ($i - $spiralSteps/2) * 4
    }
    
    Build-ColoredObject -name "Platform_Island1ToWestTower_$i" -type "Cube" `
        -x $sx -y $sy -z $sz `
        -sx 4 -sy 0.4 -sz 4 `
        -color $platformColor `
        -metallic 0.7 -smoothness 0.6 `
        -parent "ParcoursSystem"
    $totalObjects++
}

Write-Host "  [OK] Tower connections: 24 objects" -ForegroundColor DarkGreen

# Spiral platforms around sci-fi towers
Write-Host "  [PARCOURS] Tower spiral platforms..." -ForegroundColor Gray

$towers = @(
    @{x = 200; z = 0; name = "East"},
    @{x = -200; z = 0; name = "West"}
)

foreach ($tower in $towers) {
    for ($level = 0; $level -lt 8; $level++) {
        $angle = $level * 45 * [Math]::PI / 180
        $radius = 12
        $px = $tower.x + [Math]::Cos($angle) * $radius
        $pz = $tower.z + [Math]::Sin($angle) * $radius
        $py = 15 + ($level * 6)
        
        Build-ColoredObject -name "TowerSpiral_$($tower.name)_$level" -type "Cube" `
            -x $px -y $py -z $pz `
            -ry ($angle * 180 / [Math]::PI) `
            -sx 5 -sy 0.5 -sz 3 `
            -color $platformColor `
            -metallic 0.8 -smoothness 0.7 `
            -parent "ParcoursSystem"
        $totalObjects++
    }
}

Write-Host "  [OK] Tower spirals: 16 objects" -ForegroundColor DarkGreen

# Start/Finish markers
Write-Host "  [PARCOURS] Start and finish markers..." -ForegroundColor Gray

# Start platform at castle courtyard
Build-ColoredObject -name "Parcours_Start_Platform" -type "Cylinder" `
    -x 0 -y 6 -z 0 `
    -sx 12 -sy 3 -sz 12 `
    -color @{ r = 0.2; g = 1.0; b = 0.2 } `
    -metallic 0.5 -smoothness 0.8 `
    -parent "ParcoursSystem"

Set-Material -name "Parcours_Start_Platform" `
    -emission @{ r = 0.2; g = 1.0; b = 0.2; intensity = 3.0 }
$totalObjects++

# Start marker beam
Build-ColoredObject -name "Parcours_Start_Beacon" -type "Cylinder" `
    -x 0 -y 20 -z 0 `
    -sx 1.5 -sy 20 -sz 1.5 `
    -color @{ r = 0.0; g = 1.0; b = 0.0 } `
    -metallic 0.3 -smoothness 0.95 `
    -parent "ParcoursSystem"

Set-Material -name "Parcours_Start_Beacon" `
    -emission @{ r = 0.0; g = 1.0; b = 0.0; intensity = 4.0 }
$totalObjects++

# Finish platform at top of East Tower
Build-ColoredObject -name "Parcours_Finish_Platform" -type "Cylinder" `
    -x 200 -y 72 -z 0 `
    -sx 10 -sy 2 -sz 10 `
    -color @{ r = 1.0; g = 0.8; b = 0.0 } `
    -metallic 0.6 -smoothness 0.9 `
    -parent "ParcoursSystem"

Set-Material -name "Parcours_Finish_Platform" `
    -emission @{ r = 1.0; g = 0.8; b = 0.0; intensity = 4.0 }
$totalObjects++

# Finish beacon
Build-ColoredObject -name "Parcours_Finish_Beacon" -type "Cylinder" `
    -x 200 -y 85 -z 0 `
    -sx 2.0 -sy 15 -sz 2.0 `
    -color @{ r = 1.0; g = 0.5; b = 0.0 } `
    -metallic 0.3 -smoothness 0.95 `
    -parent "ParcoursSystem"

Set-Material -name "Parcours_Finish_Beacon" `
    -emission @{ r = 1.0; g = 0.5; b = 0.0; intensity = 5.0 }
$totalObjects++

# Directional guide arrows on main paths
Write-Host "  [PARCOURS] Directional markers..." -ForegroundColor Gray

$guidePositions = @(
    @{x = 0; z = 40; ry = 0},      # North from castle
    @{x = 0; z = 80; ry = 0},      # Toward bridge
    @{x = 0; z = 110; ry = 0},     # Before cathedral
    @{x = 50; z = 130; ry = 45},   # Toward Island 0
    @{x = 100; z = 140; ry = 30}   # Near Island 0
)

$arrowIdx = 0
foreach ($pos in $guidePositions) {
    Build-ColoredObject -name "Guide_Arrow_$arrowIdx" -type "Cube" `
        -x $pos.x -y 8 -z $pos.z `
        -ry $pos.ry `
        -sx 3 -sy 0.3 -sz 5 `
        -color @{ r = 1.0; g = 1.0; b = 0.2 } `
        -metallic 0.4 -smoothness 0.8 `
        -parent "ParcoursSystem"
    
    Set-Material -name "Guide_Arrow_$arrowIdx" `
        -emission @{ r = 1.0; g = 1.0; b = 0.2; intensity = 2.0 }
    $totalObjects++
    
    $arrowIdx++
}

Write-Host "[OK] Parkour System: ~250 objects" -ForegroundColor Green

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
Write-Host "    5. Floating Islands (3 corners, with crystals & TREES)" -ForegroundColor Gray
Write-Host "    6. Magical Portals (4 cardinal directions)" -ForegroundColor Gray
Write-Host "    7. Oak Grove (NE quadrant)" -ForegroundColor Gray
Write-Host "    8. Pine Forest (NW quadrant)" -ForegroundColor Gray
Write-Host "    9. Birch Grove (SW quadrant)" -ForegroundColor Gray
Write-Host "   10. Magical Willows (SE quadrant, glowing vines)" -ForegroundColor Gray
Write-Host "   11. Floating Orbs (ambient magic)" -ForegroundColor Gray
Write-Host "   12. Glowing Mushrooms (forest floor)" -ForegroundColor Gray
Write-Host ""
Write-Host "  FALLEN TRUNKS & FOREST FLOOR (NEW!):" -ForegroundColor Yellow
Write-Host "   13. Fallen Oak Logs (8+ with moss patches)" -ForegroundColor DarkGreen
Write-Host "   14. Fallen Pine Logs (6+ with scattered branches)" -ForegroundColor DarkGreen
Write-Host "   15. Fallen Birch Logs (5+ with black stripes)" -ForegroundColor Gray
Write-Host "   16. Fallen Willow Logs (4+ with GLOWING moss)" -ForegroundColor Cyan
Write-Host "   17. Natural Log Bridges (parkour-integrated)" -ForegroundColor Yellow
Write-Host "   18. Hollow Log Tunnels (explorable)" -ForegroundColor Yellow
Write-Host "   19. Log Pile Structures (complex stacks)" -ForegroundColor DarkYellow
Write-Host "   20. Log Benches (near landmarks)" -ForegroundColor DarkYellow
Write-Host "   21. Tree Stumps (cut logs)" -ForegroundColor DarkYellow
Write-Host "   22. Scattered Branches (40+ twigs)" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  ADVANCED FOREST BIOME (PROCEDURAL - NEW!):" -ForegroundColor Yellow
if ($advancedForestObjects -gt 0) {
    Write-Host "   23. Temperate Deciduous Forest (120m x 120m)" -ForegroundColor DarkGreen
    Write-Host "       - Located at far corner (-400, -400)" -ForegroundColor Gray
    Write-Host "       - 4 Tree Species: Oak (35%), Pine (25%), Birch (20%), Maple (20%)" -ForegroundColor Gray
    Write-Host "       - Multi-layered ecosystem: Canopy, Understory, Forest Floor" -ForegroundColor Gray
    Write-Host "       - $advancedForestObjects procedurally generated objects" -ForegroundColor Gray
    Write-Host "       - Realistic tree distributions with age variation" -ForegroundColor Gray
    Write-Host "       - Natural clearings, fallen logs, moss-covered boulders" -ForegroundColor Gray
    Write-Host "       - Inspired by Appalachian Mountain forests" -ForegroundColor Gray
} else {
    Write-Host "   23. Advanced Forest Biome (skipped - requires Unity API)" -ForegroundColor DarkGray
}
Write-Host ""
Write-Host "  PARKOUR COURSE FEATURES:" -ForegroundColor Yellow
Write-Host "   [START] Castle Courtyard (green glowing platform)" -ForegroundColor Cyan
Write-Host "    -> Ground roads to all 4 portals (organic curved paths)" -ForegroundColor Gray
Write-Host "    -> Castle roof platforms to tower bridge" -ForegroundColor Gray
Write-Host "    -> Bridge platforms to cathedral" -ForegroundColor Gray
Write-Host "    -> Aerial platforms to 3 floating islands" -ForegroundColor Gray
Write-Host "    -> Inter-island connecting bridges" -ForegroundColor Gray
Write-Host "    -> Island-to-tower spiral descents" -ForegroundColor Gray
Write-Host "    -> Tower spiral platforms (ascending)" -ForegroundColor Gray
Write-Host "   [FINISH] East Tower Top (golden glowing platform)" -ForegroundColor Cyan
Write-Host ""
Write-Host "  COURSE STATS:" -ForegroundColor Yellow
Write-Host "    - Total Platforms: ~250" -ForegroundColor White
Write-Host "    - Vertical Range: Ground (0m) to Tower Top (85m)" -ForegroundColor White
Write-Host "    - Course Length: ~800 units of traversal" -ForegroundColor White
Write-Host "    - Checkpoints: 20+ glowing markers" -ForegroundColor White
Write-Host "    - Difficulty: Progressive (easy ground -> hard aerial)" -ForegroundColor White
Write-Host ""
Write-Host ""
Write-Host "  GENIUS COMBINATIONS IMPLEMENTED:" -ForegroundColor Magenta
Write-Host "    * Fallen trunks as traversable parkour bridges" -ForegroundColor White
Write-Host "    * Glowing moss on magical willow logs (emission + color)" -ForegroundColor White
Write-Host "    * Hollow log tunnels using cylinder geometry" -ForegroundColor White
Write-Host "    * Complex log pile structures (stacked cylinders)" -ForegroundColor White
Write-Host "    * Natural log benches with backrests" -ForegroundColor White
Write-Host "    * Forest floor scatter distribution system" -ForegroundColor White
Write-Host "    * Procedural forest biome using Unity world generation API" -ForegroundColor White
Write-Host ""
Write-Host "  PLAYABLE AREA: 3500x3500 units (expanded with forest biome)" -ForegroundColor White
Write-Host "  BASE OBJECTS: ~720 (structures + fallen trunks)" -ForegroundColor White
Write-Host "  PARKOUR OBJECTS: ~283" -ForegroundColor White
if ($advancedForestObjects -gt 0) {
    Write-Host "  ADVANCED FOREST: ~$advancedForestObjects (procedural)" -ForegroundColor White
    $grandTotal = 720 + 283 + $advancedForestObjects
    Write-Host "  GRAND TOTAL: ~$grandTotal OBJECTS!" -ForegroundColor Cyan
    Write-Host "  STATUS: ABSOLUTE MASTERPIECE!" -ForegroundColor Magenta
} else {
    Write-Host "  GRAND TOTAL: ~1003 OBJECTS!" -ForegroundColor Cyan
    Write-Host "  STATUS: MIND-BLOWING!" -ForegroundColor Magenta
}
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
if ($advancedForestObjects -gt 0) {
    Write-Host "  ULTIMATE COMPLETE WORLD + ADVANCED FOREST CREATED!" -ForegroundColor Green
    Write-Host "  Largest ecosystem: 120m x 120m procedural temperate forest!" -ForegroundColor Green
} else {
    Write-Host "  MIND-BLOWING COMPLETE WORLD CREATED!" -ForegroundColor Green
}
Write-Host "  Ultimate realism with fallen trunks, hollow logs & natural bridges!" -ForegroundColor Green
Write-Host "  Follow the glowing markers for an EPIC adventure!" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""
if ($advancedForestObjects -gt 0) {
    Write-Host "EXPLORATION TIP:" -ForegroundColor Yellow
    Write-Host "  Visit the Advanced Forest Biome at coordinates (-400, 0, -400)" -ForegroundColor White
    Write-Host "  See realistic 4-species temperate deciduous forest ecosystem!" -ForegroundColor White
    Write-Host "  Features: Multi-layer canopy, natural clearings, fallen logs, stumps" -ForegroundColor White
    Write-Host ""
}
Write-Host "CAMERA SUGGESTIONS:" -ForegroundColor Yellow
Write-Host "  Castle Overview: (0, 80, -100) rotation (35, 0, 0)" -ForegroundColor Gray
Write-Host "  Forest Floor: (220, 5, 220) rotation (10, -45, 0)" -ForegroundColor Gray
if ($advancedForestObjects -gt 0) {
    Write-Host "  Advanced Forest: (-400, 25, -400) rotation (25, 0, 0)" -ForegroundColor Gray
}
Write-Host "  Full World: (0, 200, 0) rotation (90, 0, 0)" -ForegroundColor Gray
Write-Host ""
