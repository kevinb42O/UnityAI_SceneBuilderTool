# ============================================================================
# EPIC WORLD GENERATOR - For Current Scene
# Generates around existing player
# ============================================================================

. ".\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  EPIC WORLD GENERATOR - CURRENT SCENE MODE" -ForegroundColor Cyan
Write-Host "  Preserving your player and adding epic world around you!" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-UnityConnection)) {
    Write-Host "[FATAL] Unity MCP server not running!" -ForegroundColor Red
    exit 1
}

Write-Host "[INIT] Checking current scene..." -ForegroundColor Yellow

# Query current scene to find player
$allObjects = Find-Objects
$playerFound = $false
foreach ($obj in $allObjects) {
    if ($obj.name -like "*Player*" -or $obj.name -like "*Character*" -or $obj.tag -eq "Player") {
        Write-Host "[FOUND] Player detected: $($obj.name)" -ForegroundColor Green
        $playerFound = $true
        break
    }
}

if ($playerFound) {
    Write-Host "[INFO] Player found! Building world around you..." -ForegroundColor Green
} else {
    Write-Host "[INFO] No player detected, building full world..." -ForegroundColor Yellow
}

$totalObjects = 0
$startTime = Get-Date

# ============================================================================
# SECTION 1: GROUND PLANE
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 1: CREATING GROUND ===" -ForegroundColor Magenta
Write-Host ""

Build-ColoredObject -name "EpicGround" -type "Plane" `
    -x 0 -y 0 -z 0 `
    -sx 100 -sy 1 -sz 100 `
    -color @{ r = 0.2; g = 0.5; b = 0.2 } `
    -metallic 0.0 -smoothness 0.2
$totalObjects++

Write-Host "[GROUND] Created massive ground plane" -ForegroundColor Green

# ============================================================================
# SECTION 2: FLOATING FANTASY ISLANDS
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 2: FLOATING ISLANDS ===" -ForegroundColor Magenta
Write-Host ""

New-Group -name "FloatingIslands"

for ($i = 0; $i -lt 5; $i++) {
    $angle = ($i * 72) * [Math]::PI / 180
    $radius = 150
    $x = [Math]::Cos($angle) * $radius
    $z = [Math]::Sin($angle) * $radius
    $height = 60 + ($i * 15)
    
    Write-Host "[ISLAND $i] Creating at ($x, $height, $z)..." -ForegroundColor Green
    
    # Island base
    Build-ColoredObject -name "Island_${i}_Base" -type "Sphere" `
        -x $x -y $height -z $z `
        -sx 40 -sy 20 -sz 40 `
        -color @{ r = 0.25; g = 0.35; b = 0.22 } `
        -metallic 0.0 -smoothness 0.3 `
        -parent "FloatingIslands"
    $totalObjects++
    
    # Glowing crystals
    for ($j = 0; $j -lt 7; $j++) {
        $crystalAngle = ($j * 51.43) * [Math]::PI / 180
        $crystalRadius = 8
        $cx = $x + ([Math]::Cos($crystalAngle) * $crystalRadius)
        $cz = $z + ([Math]::Sin($crystalAngle) * $crystalRadius)
        $crystalSize = Get-Random -Minimum 6 -Maximum 14
        
        $colors = @(
            @{ r = 1.0; g = 0.0; b = 1.0 },
            @{ r = 0.0; g = 1.0; b = 1.0 },
            @{ r = 1.0; g = 1.0; b = 0.0 }
        )
        $chosenColor = $colors | Get-Random
        
        Build-ColoredObject -name "Island_${i}_Crystal_$j" -type "Cube" `
            -x $cx -y ($height + 25) -z $cz `
            -rx (Get-Random -Minimum -15 -Maximum 15) `
            -ry (Get-Random -Minimum 0 -Maximum 360) `
            -sx 1.5 -sy $crystalSize -sz 1.5 `
            -color $chosenColor `
            -metallic 0.2 -smoothness 0.95 `
            -parent "FloatingIslands"
        
        Set-Material -name "Island_${i}_Crystal_$j" `
            -emission @{ r = $chosenColor.r; g = $chosenColor.g; b = $chosenColor.b; intensity = 3.0 }
        
        $totalObjects++
    }
    
    # Magic tree
    $treeX = $x - 10
    $treeZ = $z - 10
    
    Build-ColoredObject -name "Island_${i}_Tree_Trunk" -type "Cylinder" `
        -x $treeX -y ($height + 15) -z $treeZ `
        -sx 2.0 -sy 12 -sz 2.0 `
        -color @{ r = 0.4; g = 0.1; b = 0.6 } `
        -metallic 0.0 -smoothness 0.3 `
        -parent "FloatingIslands"
    $totalObjects++
    
    Build-ColoredObject -name "Island_${i}_Tree_Canopy" -type "Sphere" `
        -x $treeX -y ($height + 32) -z $treeZ `
        -sx 18 -sy 18 -sz 18 `
        -color @{ r = 0.6; g = 0.2; b = 0.9 } `
        -metallic 0.0 -smoothness 0.4 `
        -parent "FloatingIslands"
    
    Set-Material -name "Island_${i}_Tree_Canopy" `
        -emission @{ r = 0.4; g = 0.1; b = 0.6; intensity = 1.5 }
    $totalObjects++
}

Write-Host "[ISLANDS] Created 5 floating islands with 45 objects" -ForegroundColor Green

# ============================================================================
# SECTION 3: CRYSTAL CATHEDRAL
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 3: CRYSTAL CATHEDRAL ===" -ForegroundColor Magenta
Write-Host ""

New-Group -name "CrystalCathedral"

Build-ColoredObject -name "Cathedral_Platform" -type "Cylinder" `
    -x 0 -y 1 -z 0 `
    -sx 60 -sy 2 -sz 60 `
    -color @{ r = 0.15; g = 0.15; b = 0.18 } `
    -metallic 0.8 -smoothness 0.7 `
    -parent "CrystalCathedral"
$totalObjects++

# Corner pillars
$pillarPositions = @(
    @{x = 25; z = 25}, @{x = -25; z = 25},
    @{x = 25; z = -25}, @{x = -25; z = -25}
)

foreach ($pos in $pillarPositions) {
    Build-ColoredObject -name "Cathedral_Pillar_$($pos.x)_$($pos.z)" -type "Cylinder" `
        -x $pos.x -y 35 -z $pos.z `
        -sx 4 -sy 35 -sz 4 `
        -color @{ r = 0.2; g = 0.2; b = 0.25 } `
        -metallic 0.9 -smoothness 0.85 `
        -parent "CrystalCathedral"
    $totalObjects++
    
    Build-ColoredObject -name "Cathedral_Cap_$($pos.x)_$($pos.z)" -type "Cube" `
        -x $pos.x -y 72 -z $pos.z `
        -sx 5 -sy 8 -sz 5 `
        -rx 45 -ry 45 `
        -color @{ r = 0.0; g = 0.8; b = 1.0 } `
        -metallic 0.3 -smoothness 0.95 `
        -parent "CrystalCathedral"
    
    Set-Material -name "Cathedral_Cap_$($pos.x)_$($pos.z)" `
        -emission @{ r = 0.0; g = 0.8; b = 1.0; intensity = 4.0 }
    $totalObjects++
}

# Central spire (12 layers)
for ($layer = 0; $layer -lt 12; $layer++) {
    $layerHeight = 5 + ($layer * 8)
    $layerSize = 15 - ($layer * 0.8)
    if ($layerSize -lt 3) { $layerSize = 3 }
    
    $layerColor = if ($layer % 2 -eq 0) {
        @{ r = 0.1; g = 0.5; b = 1.0 }
    } else {
        @{ r = 1.0; g = 0.1; b = 1.0 }
    }
    
    Build-ColoredObject -name "Cathedral_Spire_$layer" -type "Cube" `
        -x 0 -y $layerHeight -z 0 `
        -ry ($layer * 15) `
        -sx $layerSize -sy 6 -sz $layerSize `
        -color $layerColor `
        -metallic 0.5 -smoothness 0.9 `
        -parent "CrystalCathedral"
    
    Set-Material -name "Cathedral_Spire_$layer" `
        -emission @{ r = $layerColor.r; g = $layerColor.g; b = $layerColor.b; intensity = 2.5 }
    $totalObjects++
}

Build-ColoredObject -name "Cathedral_TopCrystal" -type "Cube" `
    -x 0 -y 105 -z 0 `
    -rx 45 -ry 45 `
    -sx 6 -sy 12 -sz 6 `
    -color @{ r = 1.0; g = 1.0; b = 1.0 } `
    -metallic 0.0 -smoothness 1.0 `
    -parent "CrystalCathedral"

Set-Material -name "Cathedral_TopCrystal" `
    -emission @{ r = 1.0; g = 1.0; b = 1.0; intensity = 5.0 }
$totalObjects++

Write-Host "[CATHEDRAL] Created 18-layer crystal spire" -ForegroundColor Green

# ============================================================================
# SECTION 4: SCI-FI TOWERS
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 4: SCI-FI TOWERS ===" -ForegroundColor Magenta
Write-Host ""

New-Group -name "SciFiTowers"

$towerPositions = @(
    @{x = 120; z = 0; color = @{r = 0.0; g = 1.0; b = 1.0}},
    @{x = -120; z = 0; color = @{r = 1.0; g = 0.5; b = 0.0}},
    @{x = 0; z = 120; color = @{r = 1.0; g = 0.0; b = 1.0}},
    @{x = 0; z = -120; color = @{r = 0.0; g = 1.0; b = 0.5}}
)

foreach ($tower in $towerPositions) {
    $tName = "Tower_$($tower.x)_$($tower.z)"
    
    Build-ColoredObject -name "${tName}_Base" -type "Cylinder" `
        -x $tower.x -y 5 -z $tower.z `
        -sx 8 -sy 5 -sz 8 `
        -color @{ r = 0.2; g = 0.2; b = 0.22 } `
        -metallic 0.9 -smoothness 0.8 `
        -parent "SciFiTowers"
    $totalObjects++
    
    Build-ColoredObject -name "${tName}_Shaft" -type "Cylinder" `
        -x $tower.x -y 30 -z $tower.z `
        -sx 3 -sy 25 -sz 3 `
        -color @{ r = 0.15; g = 0.15; b = 0.18 } `
        -metallic 0.85 -smoothness 0.85 `
        -parent "SciFiTowers"
    $totalObjects++
    
    Build-ColoredObject -name "${tName}_Pod" -type "Sphere" `
        -x $tower.x -y 58 -z $tower.z `
        -sx 10 -sy 8 -sz 10 `
        -color @{ r = 0.3; g = 0.3; b = 0.35 } `
        -metallic 0.7 -smoothness 0.9 `
        -parent "SciFiTowers"
    $totalObjects++
    
    Build-ColoredObject -name "${tName}_Core" -type "Sphere" `
        -x $tower.x -y 58 -z $tower.z `
        -sx 4 -sy 4 -sz 4 `
        -color $tower.color `
        -metallic 0.2 -smoothness 0.95 `
        -parent "SciFiTowers"
    
    Set-Material -name "${tName}_Core" `
        -emission @{ r = $tower.color.r; g = $tower.color.g; b = $tower.color.b; intensity = 4.0 }
    $totalObjects++
    
    for ($ring = 0; $ring -lt 5; $ring++) {
        Build-ColoredObject -name "${tName}_Ring_$ring" -type "Sphere" `
            -x $tower.x -y (15 + ($ring * 10)) -z $tower.z `
            -sx (5 + ($ring * 0.5)) -sy 0.5 -sz (5 + ($ring * 0.5)) `
            -color $tower.color `
            -metallic 0.8 -smoothness 0.95 `
            -parent "SciFiTowers"
        
        Set-Material -name "${tName}_Ring_$ring" `
            -emission @{ r = $tower.color.r; g = $tower.color.g; b = $tower.color.b; intensity = 2.0 }
        $totalObjects++
    }
}

Write-Host "[TOWERS] Created 4 towers with 36 objects" -ForegroundColor Green

# ============================================================================
# SECTION 5: MAGICAL PORTALS
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 5: MAGICAL PORTALS ===" -ForegroundColor Magenta
Write-Host ""

New-Group -name "MagicalPortals"

$portalPositions = @(
    @{x = 90; z = 90; color = @{r = 1.0; g = 0.0; b = 1.0}},
    @{x = -90; z = 90; color = @{r = 0.0; g = 1.0; b = 1.0}},
    @{x = 90; z = -90; color = @{r = 1.0; g = 1.0; b = 0.0}},
    @{x = -90; z = -90; color = @{r = 1.0; g = 0.5; b = 0.0}}
)

foreach ($portal in $portalPositions) {
    $pName = "Portal_$($portal.x)_$($portal.z)"
    
    # Frame
    for ($side = 0; $side -lt 4; $side++) {
        $frameSX = if ($side % 2 -eq 0) { 2 } else { 14 }
        $frameSZ = if ($side % 2 -eq 0) { 14 } else { 2 }
        $frameX = $portal.x
        $frameZ = $portal.z
        if ($side -eq 0) { $frameZ += 6 }
        if ($side -eq 1) { $frameX += 6 }
        if ($side -eq 2) { $frameZ -= 6 }
        if ($side -eq 3) { $frameX -= 6 }
        
        Build-ColoredObject -name "${pName}_Frame_$side" -type "Cube" `
            -x $frameX -y 10 -z $frameZ `
            -sx $frameSX -sy 20 -sz $frameSZ `
            -color @{ r = 0.1; g = 0.05; b = 0.15 } `
            -metallic 0.8 -smoothness 0.7 `
            -parent "MagicalPortals"
        $totalObjects++
    }
    
    Build-ColoredObject -name "${pName}_Field" -type "Cube" `
        -x $portal.x -y 10 -z $portal.z `
        -sx 0.5 -sy 18 -sz 10 `
        -color $portal.color `
        -metallic 0.3 -smoothness 0.95 `
        -parent "MagicalPortals"
    
    Set-Material -name "${pName}_Field" `
        -emission @{ r = $portal.color.r; g = $portal.color.g; b = $portal.color.b; intensity = 3.5 }
    $totalObjects++
    
    # Runes
    for ($rune = 0; $rune -lt 8; $rune++) {
        $runeAngle = ($rune * 45) * [Math]::PI / 180
        $runeX = $portal.x + ([Math]::Cos($runeAngle) * 10)
        $runeZ = $portal.z + ([Math]::Sin($runeAngle) * 10)
        
        Build-ColoredObject -name "${pName}_Rune_$rune" -type "Cube" `
            -x $runeX -y (10 + ([Math]::Sin($rune) * 3)) -z $runeZ `
            -ry ($rune * 45) `
            -sx 1.5 -sy 1.5 -sz 0.3 `
            -color $portal.color `
            -metallic 0.2 -smoothness 0.9 `
            -parent "MagicalPortals"
        
        Set-Material -name "${pName}_Rune_$rune" `
            -emission @{ r = $portal.color.r; g = $portal.color.g; b = $portal.color.b; intensity = 2.0 }
        $totalObjects++
    }
}

Write-Host "[PORTALS] Created 4 portals with 52 objects" -ForegroundColor Green

# ============================================================================
# SECTION 6: ENERGY BRIDGES
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 6: ENERGY BRIDGES ===" -ForegroundColor Magenta
Write-Host ""

New-Group -name "EnergyBridges"

$bridges = @(
    @{x1 = 0; y1 = 50; z1 = 0; x2 = 120; y2 = 58; z2 = 0},
    @{x1 = 0; y1 = 50; z1 = 0; x2 = -120; y2 = 58; z2 = 0},
    @{x1 = 0; y1 = 50; z1 = 0; x2 = 0; y2 = 58; z2 = 120},
    @{x1 = 0; y1 = 50; z1 = 0; x2 = 0; y2 = 58; z2 = -120}
)

$bridgeIndex = 0
foreach ($b in $bridges) {
    Build-DiagonalObject -name "EnergyBridge_$bridgeIndex" -type "Cylinder" `
        -x1 $b.x1 -y1 $b.y1 -z1 $b.z1 `
        -x2 $b.x2 -y2 $b.y2 -z2 $b.z2 `
        -thickness 0.8 `
        -color @{ r = 0.3; g = 0.7; b = 1.0 } `
        -parent "EnergyBridges"
    
    Set-Material -name "EnergyBridge_$bridgeIndex" `
        -emission @{ r = 0.3; g = 0.7; b = 1.0; intensity = 2.5 }
    $totalObjects++
    $bridgeIndex++
}

Write-Host "[BRIDGES] Created 4 energy bridges" -ForegroundColor Green

# ============================================================================
# SECTION 7: FLOATING ORBS
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 7: AMBIENT ORBS ===" -ForegroundColor Magenta
Write-Host ""

New-Group -name "FloatingOrbs"

for ($i = 0; $i -lt 40; $i++) {
    $x = Get-Random -Minimum -130 -Maximum 130
    $z = Get-Random -Minimum -130 -Maximum 130
    $y = Get-Random -Minimum 15 -Maximum 70
    $size = Get-Random -Minimum 0.5 -Maximum 2.0
    
    $colors = @(
        @{ r = 1.0; g = 0.8; b = 0.2 },
        @{ r = 0.8; g = 0.2; b = 1.0 },
        @{ r = 0.2; g = 0.8; b = 1.0 }
    )
    $orbColor = $colors | Get-Random
    
    Build-ColoredObject -name "Orb_$i" -type "Sphere" `
        -x $x -y $y -z $z `
        -sx $size -sy $size -sz $size `
        -color $orbColor `
        -metallic 0.1 -smoothness 1.0 `
        -parent "FloatingOrbs"
    
    Set-Material -name "Orb_$i" `
        -emission @{ r = $orbColor.r; g = $orbColor.g; b = $orbColor.b; intensity = 2.0 }
    $totalObjects++
}

Write-Host "[ORBS] Created 40 floating orbs" -ForegroundColor Green

# ============================================================================
# SECTION 8: GROUND DETAILS
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 8: GROUND DETAILS ===" -ForegroundColor Magenta
Write-Host ""

New-Group -name "GroundDetails"

for ($i = 0; $i -lt 50; $i++) {
    $x = Get-Random -Minimum -160 -Maximum 160
    $z = Get-Random -Minimum -160 -Maximum 160
    $dist = [Math]::Sqrt($x * $x + $z * $z)
    if ($dist -lt 30) { continue }
    
    $size = Get-Random -Minimum 1.0 -Maximum 3.5
    
    Build-ColoredObject -name "Stone_$i" -type "Sphere" `
        -x $x -y ($size * 0.3) -z $z `
        -rx (Get-Random -Minimum -20 -Maximum 20) `
        -ry (Get-Random -Minimum 0 -Maximum 360) `
        -sx $size -sy ($size * 0.6) -sz ($size * 0.9) `
        -color @{ r = 0.3; g = 0.25; b = 0.35 } `
        -metallic 0.0 -smoothness 0.4 `
        -parent "GroundDetails"
    $totalObjects++
}

Write-Host "[GROUND] Scattered 50 stones" -ForegroundColor Green

# ============================================================================
# SECTION 9: OPTIMIZATION
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 9: OPTIMIZATION ===" -ForegroundColor Magenta
Write-Host ""

Write-Host "[OPTIMIZE] Combining meshes for performance..." -ForegroundColor Yellow

$groups = @("FloatingIslands", "SciFiTowers", "MagicalPortals", "FloatingOrbs", "GroundDetails")

foreach ($g in $groups) {
    try {
        Write-Host "  [OPTIMIZE] $g..." -ForegroundColor Gray
        $result = Optimize-Group -parentName $g
        if ($result) {
            Write-Host "    [OK] $g - $($result.originalCount) to $($result.combinedMeshes) meshes" -ForegroundColor DarkGreen
        }
    } catch {
        Write-Host "    [SKIP] $g - Mixed materials" -ForegroundColor DarkYellow
    }
}

# ============================================================================
# FINAL STATS
# ============================================================================
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  EPIC WORLD COMPLETE!" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

$duration = (Get-Date) - $startTime
$minutes = [Math]::Floor($duration.TotalMinutes)
$seconds = $duration.Seconds

Write-Host "  Total Objects: $totalObjects" -ForegroundColor White
Write-Host "  Time: ${minutes}m ${seconds}s" -ForegroundColor White
Write-Host ""
Write-Host "  FEATURES:" -ForegroundColor Yellow
Write-Host "    - Ground plane for walking" -ForegroundColor Gray
Write-Host "    - 5 Floating islands with crystals" -ForegroundColor Gray
Write-Host "    - Crystal cathedral (centerpiece)" -ForegroundColor Gray
Write-Host "    - 4 Sci-fi towers with cores" -ForegroundColor Gray
Write-Host "    - 4 Magical portals with runes" -ForegroundColor Gray
Write-Host "    - Energy bridges" -ForegroundColor Gray
Write-Host "    - 40 floating orbs" -ForegroundColor Gray
Write-Host "    - 50 ground stones" -ForegroundColor Gray
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  Run around and explore with your player!" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""
