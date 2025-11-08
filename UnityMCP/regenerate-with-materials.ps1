# ============================================================================
# REGENERATE WORLD WITH PROPER MATERIALS
# Clears old generated objects and creates new ones with correct colors
# ============================================================================

. ".\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  REGENERATING WORLD WITH PROPER MATERIALS" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

# Test connection with simple ping
try {
    $ping = Invoke-RestMethod -Uri "http://localhost:8765/ping" -Method POST -ContentType "application/json" -Body '{}' -UseBasicParsing -TimeoutSec 2
    Write-Host "[OK] Unity MCP server connected on port 8765" -ForegroundColor Green
} catch {
    Write-Host "[FATAL] Unity MCP server not running!" -ForegroundColor Red
    exit 1
}

# ============================================================================
# STEP 1: DELETE OLD GENERATED CONTENT
# ============================================================================
Write-Host "[CLEANUP] Removing old generated objects..." -ForegroundColor Yellow

$objectsToDelete = @(
    "EpicGround",
    "FloatingIslands",
    "CrystalCathedral", 
    "SciFiTowers",
    "MagicalPortals",
    "EnergyBridges",
    "FloatingOrbs",
    "GroundDetails"
)

foreach ($obj in $objectsToDelete) {
    try {
        $result = Invoke-RestMethod -Uri "$UNITY_BASE/deleteGameObject" `
            -Method POST `
            -ContentType "application/json" `
            -Body (@{ name = $obj } | ConvertTo-Json) `
            -UseBasicParsing
        Write-Host "  [DELETED] $obj" -ForegroundColor DarkGray
    } catch {
        Write-Host "  [SKIP] $obj not found" -ForegroundColor DarkGray
    }
}

Write-Host "[CLEANUP] Old objects removed" -ForegroundColor Green
Write-Host ""

Start-Sleep -Seconds 1

# ============================================================================
# STEP 2: GENERATE NEW WORLD WITHOUT OPTIMIZATION
# ============================================================================
Write-Host "[GENERATE] Creating world with proper materials..." -ForegroundColor Yellow
Write-Host "[INFO] Skipping mesh optimization to preserve colors!" -ForegroundColor Cyan
Write-Host ""

$totalObjects = 0
$startTime = Get-Date

# ============================================================================
# GROUND
# ============================================================================
Write-Host "=== GROUND ===" -ForegroundColor Magenta

Build-ColoredObject -name "EpicGround" -type "Plane" `
    -x 0 -y 0 -z 0 `
    -sx 100 -sy 1 -sz 100 `
    -color @{ r = 0.2; g = 0.5; b = 0.2 } `
    -metallic 0.0 -smoothness 0.2
$totalObjects++

Write-Host "[OK] Ground created" -ForegroundColor Green

# ============================================================================
# FLOATING ISLANDS (Simplified - 3 islands with crystals)
# ============================================================================
Write-Host ""
Write-Host "=== FLOATING ISLANDS ===" -ForegroundColor Magenta

New-Group -name "FloatingIslands"

for ($i = 0; $i -lt 3; $i++) {
    $angle = ($i * 120) * [Math]::PI / 180
    $radius = 120
    $x = [Math]::Cos($angle) * $radius
    $z = [Math]::Sin($angle) * $radius
    $height = 70
    
    Write-Host "[ISLAND $i] Creating..." -ForegroundColor Gray
    
    # Island base - GREEN
    Build-ColoredObject -name "Island_${i}_Base" -type "Sphere" `
        -x $x -y $height -z $z `
        -sx 30 -sy 15 -sz 30 `
        -color @{ r = 0.15; g = 0.4; b = 0.15 } `
        -metallic 0.0 -smoothness 0.3 `
        -parent "FloatingIslands"
    $totalObjects++
    
    # Crystal 1 - MAGENTA with emission
    Build-ColoredObject -name "Island_${i}_Crystal1" -type "Cube" `
        -x ($x - 8) -y ($height + 20) -z $z `
        -ry 45 -sx 2 -sy 12 -sz 2 `
        -color @{ r = 1.0; g = 0.0; b = 1.0 } `
        -metallic 0.2 -smoothness 0.95 `
        -parent "FloatingIslands"
    
    Set-Material -name "Island_${i}_Crystal1" `
        -emission @{ r = 1.0; g = 0.0; b = 1.0; intensity = 3.0 }
    $totalObjects++
    
    # Crystal 2 - CYAN with emission
    Build-ColoredObject -name "Island_${i}_Crystal2" -type "Cube" `
        -x ($x + 8) -y ($height + 18) -z $z `
        -ry -45 -sx 2 -sy 10 -sz 2 `
        -color @{ r = 0.0; g = 1.0; b = 1.0 } `
        -metallic 0.2 -smoothness 0.95 `
        -parent "FloatingIslands"
    
    Set-Material -name "Island_${i}_Crystal2" `
        -emission @{ r = 0.0; g = 1.0; b = 1.0; intensity = 3.0 }
    $totalObjects++
    
    # Crystal 3 - YELLOW with emission
    Build-ColoredObject -name "Island_${i}_Crystal3" -type "Cube" `
        -x $x -y ($height + 22) -z ($z + 8) `
        -rx 15 -ry 30 -sx 2 -sy 14 -sz 2 `
        -color @{ r = 1.0; g = 1.0; b = 0.0 } `
        -metallic 0.2 -smoothness 0.95 `
        -parent "FloatingIslands"
    
    Set-Material -name "Island_${i}_Crystal3" `
        -emission @{ r = 1.0; g = 1.0; b = 0.0; intensity = 3.0 }
    $totalObjects++
}

Write-Host "[OK] 3 islands with 12 objects" -ForegroundColor Green

# ============================================================================
# CRYSTAL CATHEDRAL
# ============================================================================
Write-Host ""
Write-Host "=== CRYSTAL CATHEDRAL ===" -ForegroundColor Magenta

New-Group -name "CrystalCathedral"

# Platform - DARK GRAY metallic
Build-ColoredObject -name "Cathedral_Platform" -type "Cylinder" `
    -x 0 -y 1 -z 0 `
    -sx 50 -sy 2 -sz 50 `
    -color @{ r = 0.15; g = 0.15; b = 0.18 } `
    -metallic 0.8 -smoothness 0.7 `
    -parent "CrystalCathedral"
$totalObjects++

# 4 Corner pillars - GRAY metallic
$corners = @(
    @{x = 20; z = 20}, @{x = -20; z = 20}, 
    @{x = 20; z = -20}, @{x = -20; z = -20}
)

foreach ($corner in $corners) {
    Build-ColoredObject -name "Cathedral_Pillar_$($corner.x)_$($corner.z)" -type "Cylinder" `
        -x $corner.x -y 30 -z $corner.z `
        -sx 3 -sy 30 -sz 3 `
        -color @{ r = 0.25; g = 0.25; b = 0.28 } `
        -metallic 0.9 -smoothness 0.85 `
        -parent "CrystalCathedral"
    $totalObjects++
    
    # CYAN glowing cap
    Build-ColoredObject -name "Cathedral_Cap_$($corner.x)_$($corner.z)" -type "Cube" `
        -x $corner.x -y 62 -z $corner.z `
        -rx 45 -ry 45 -sx 4 -sy 4 -sz 4 `
        -color @{ r = 0.0; g = 0.8; b = 1.0 } `
        -metallic 0.3 -smoothness 0.95 `
        -parent "CrystalCathedral"
    
    Set-Material -name "Cathedral_Cap_$($corner.x)_$($corner.z)" `
        -emission @{ r = 0.0; g = 0.8; b = 1.0; intensity = 4.0 }
    $totalObjects++
}

# Spire layers - Alternating BLUE and MAGENTA
for ($layer = 0; $layer -lt 8; $layer++) {
    $layerHeight = 5 + ($layer * 10)
    $layerSize = 12 - ($layer * 1.0)
    if ($layerSize -lt 3) { $layerSize = 3 }
    
    if ($layer % 2 -eq 0) {
        $layerColor = @{ r = 0.1; g = 0.5; b = 1.0 }
    } else {
        $layerColor = @{ r = 1.0; g = 0.1; b = 1.0 }
    }
    
    Build-ColoredObject -name "Cathedral_Spire_$layer" -type "Cube" `
        -x 0 -y $layerHeight -z 0 `
        -ry ($layer * 20) `
        -sx $layerSize -sy 5 -sz $layerSize `
        -color $layerColor `
        -metallic 0.5 -smoothness 0.9 `
        -parent "CrystalCathedral"
    
    Set-Material -name "Cathedral_Spire_$layer" `
        -emission @{ r = $layerColor.r; g = $layerColor.g; b = $layerColor.b; intensity = 2.5 }
    $totalObjects++
}

# WHITE glowing top crystal
Build-ColoredObject -name "Cathedral_TopCrystal" -type "Cube" `
    -x 0 -y 90 -z 0 `
    -rx 45 -ry 45 `
    -sx 5 -sy 10 -sz 5 `
    -color @{ r = 1.0; g = 1.0; b = 1.0 } `
    -metallic 0.0 -smoothness 1.0 `
    -parent "CrystalCathedral"

Set-Material -name "Cathedral_TopCrystal" `
    -emission @{ r = 1.0; g = 1.0; b = 1.0; intensity = 5.0 }
$totalObjects++

Write-Host "[OK] Cathedral with $totalObjects objects" -ForegroundColor Green

# ============================================================================
# SCI-FI TOWERS (2 towers)
# ============================================================================
Write-Host ""
Write-Host "=== SCI-FI TOWERS ===" -ForegroundColor Magenta

New-Group -name "SciFiTowers"

$towers = @(
    @{x = 100; z = 0; name = "East"; color = @{r = 0.0; g = 1.0; b = 1.0}},
    @{x = -100; z = 0; name = "West"; color = @{r = 1.0; g = 0.5; b = 0.0}}
)

foreach ($tower in $towers) {
    Write-Host "[TOWER] $($tower.name)..." -ForegroundColor Gray
    
    # GRAY base
    Build-ColoredObject -name "Tower_$($tower.name)_Base" -type "Cylinder" `
        -x $tower.x -y 5 -z $tower.z `
        -sx 8 -sy 5 -sz 8 `
        -color @{ r = 0.2; g = 0.2; b = 0.22 } `
        -metallic 0.9 -smoothness 0.8 `
        -parent "SciFiTowers"
    $totalObjects++
    
    # GRAY shaft
    Build-ColoredObject -name "Tower_$($tower.name)_Shaft" -type "Cylinder" `
        -x $tower.x -y 30 -z $tower.z `
        -sx 3 -sy 25 -sz 3 `
        -color @{ r = 0.18; g = 0.18; b = 0.2 } `
        -metallic 0.85 -smoothness 0.85 `
        -parent "SciFiTowers"
    $totalObjects++
    
    # GRAY pod
    Build-ColoredObject -name "Tower_$($tower.name)_Pod" -type "Sphere" `
        -x $tower.x -y 58 -z $tower.z `
        -sx 10 -sy 8 -sz 10 `
        -color @{ r = 0.3; g = 0.3; b = 0.35 } `
        -metallic 0.7 -smoothness 0.9 `
        -parent "SciFiTowers"
    $totalObjects++
    
    # COLORED glowing core
    Build-ColoredObject -name "Tower_$($tower.name)_Core" -type "Sphere" `
        -x $tower.x -y 58 -z $tower.z `
        -sx 4 -sy 4 -sz 4 `
        -color $tower.color `
        -metallic 0.2 -smoothness 0.95 `
        -parent "SciFiTowers"
    
    Set-Material -name "Tower_$($tower.name)_Core" `
        -emission @{ r = $tower.color.r; g = $tower.color.g; b = $tower.color.b; intensity = 4.0 }
    $totalObjects++
    
    # 3 colored rings
    for ($ring = 0; $ring -lt 3; $ring++) {
        Build-ColoredObject -name "Tower_$($tower.name)_Ring_$ring" -type "Sphere" `
            -x $tower.x -y (20 + ($ring * 15)) -z $tower.z `
            -sx (5 + $ring) -sy 0.5 -sz (5 + $ring) `
            -color $tower.color `
            -metallic 0.8 -smoothness 0.95 `
            -parent "SciFiTowers"
        
        Set-Material -name "Tower_$($tower.name)_Ring_$ring" `
            -emission @{ r = $tower.color.r; g = $tower.color.g; b = $tower.color.b; intensity = 2.0 }
        $totalObjects++
    }
}

Write-Host "[OK] 2 towers created" -ForegroundColor Green

# ============================================================================
# MAGICAL PORTALS (2 portals)
# ============================================================================
Write-Host ""
Write-Host "=== MAGICAL PORTALS ===" -ForegroundColor Magenta

New-Group -name "MagicalPortals"

$portals = @(
    @{x = 70; z = 70; name = "NE"; color = @{r = 1.0; g = 0.0; b = 1.0}},
    @{x = -70; z = -70; name = "SW"; color = @{r = 1.0; g = 1.0; b = 0.0}}
)

foreach ($portal in $portals) {
    Write-Host "[PORTAL] $($portal.name)..." -ForegroundColor Gray
    
    # DARK frame (4 sides)
    for ($side = 0; $side -lt 4; $side++) {
        $frameSX = if ($side % 2 -eq 0) { 2 } else { 12 }
        $frameSZ = if ($side % 2 -eq 0) { 12 } else { 2 }
        $frameX = $portal.x
        $frameZ = $portal.z
        if ($side -eq 0) { $frameZ += 5 }
        if ($side -eq 1) { $frameX += 5 }
        if ($side -eq 2) { $frameZ -= 5 }
        if ($side -eq 3) { $frameX -= 5 }
        
        Build-ColoredObject -name "Portal_$($portal.name)_Frame_$side" -type "Cube" `
            -x $frameX -y 10 -z $frameZ `
            -sx $frameSX -sy 18 -sz $frameSZ `
            -color @{ r = 0.1; g = 0.05; b = 0.15 } `
            -metallic 0.8 -smoothness 0.7 `
            -parent "MagicalPortals"
        $totalObjects++
    }
    
    # COLORED glowing field
    Build-ColoredObject -name "Portal_$($portal.name)_Field" -type "Cube" `
        -x $portal.x -y 10 -z $portal.z `
        -sx 0.5 -sy 16 -sz 8 `
        -color $portal.color `
        -metallic 0.3 -smoothness 0.95 `
        -parent "MagicalPortals"
    
    Set-Material -name "Portal_$($portal.name)_Field" `
        -emission @{ r = $portal.color.r; g = $portal.color.g; b = $portal.color.b; intensity = 3.5 }
    $totalObjects++
    
    # 4 floating runes
    for ($rune = 0; $rune -lt 4; $rune++) {
        $runeAngle = ($rune * 90) * [Math]::PI / 180
        $runeX = $portal.x + ([Math]::Cos($runeAngle) * 8)
        $runeZ = $portal.z + ([Math]::Sin($runeAngle) * 8)
        
        Build-ColoredObject -name "Portal_$($portal.name)_Rune_$rune" -type "Cube" `
            -x $runeX -y (10 + ($rune * 2)) -z $runeZ `
            -ry ($rune * 90) `
            -sx 1.5 -sy 1.5 -sz 0.3 `
            -color $portal.color `
            -metallic 0.2 -smoothness 0.9 `
            -parent "MagicalPortals"
        
        Set-Material -name "Portal_$($portal.name)_Rune_$rune" `
            -emission @{ r = $portal.color.r; g = $portal.color.g; b = $portal.color.b; intensity = 2.0 }
        $totalObjects++
    }
}

Write-Host "[OK] 2 portals created" -ForegroundColor Green

# ============================================================================
# FLOATING ORBS (15 colorful orbs)
# ============================================================================
Write-Host ""
Write-Host "=== FLOATING ORBS ===" -ForegroundColor Magenta

New-Group -name "FloatingOrbs"

$orbColors = @(
    @{ r = 1.0; g = 0.8; b = 0.2 },
    @{ r = 0.8; g = 0.2; b = 1.0 },
    @{ r = 0.2; g = 0.8; b = 1.0 },
    @{ r = 1.0; g = 0.2; b = 0.4 },
    @{ r = 0.2; g = 1.0; b = 0.4 }
)

for ($i = 0; $i -lt 15; $i++) {
    $x = Get-Random -Minimum -80 -Maximum 80
    $z = Get-Random -Minimum -80 -Maximum 80
    $y = Get-Random -Minimum 20 -Maximum 60
    $size = Get-Random -Minimum 1.0 -Maximum 2.5
    
    $orbColor = $orbColors[$i % $orbColors.Count]
    
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

Write-Host "[OK] 15 orbs created" -ForegroundColor Green

# ============================================================================
# FINAL STATS
# ============================================================================
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  WORLD REGENERATION COMPLETE!" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

$duration = (Get-Date) - $startTime
$minutes = [Math]::Floor($duration.TotalMinutes)
$seconds = $duration.Seconds

Write-Host "  Total Objects: $totalObjects" -ForegroundColor White
Write-Host "  Time: ${minutes}m ${seconds}s" -ForegroundColor White
Write-Host ""
Write-Host "  COLORS PRESERVED:" -ForegroundColor Yellow
Write-Host "    - Green ground" -ForegroundColor DarkGreen
Write-Host "    - Green island bases" -ForegroundColor DarkGreen
Write-Host "    - Magenta, Cyan, Yellow crystals (glowing)" -ForegroundColor Magenta
Write-Host "    - Gray metallic structures" -ForegroundColor Gray
Write-Host "    - Blue/Magenta cathedral spire (glowing)" -ForegroundColor Blue
Write-Host "    - Cyan/Orange tower cores (glowing)" -ForegroundColor Cyan
Write-Host "    - Magenta/Yellow portal fields (glowing)" -ForegroundColor Magenta
Write-Host "    - Multi-colored floating orbs (glowing)" -ForegroundColor Yellow
Write-Host ""
Write-Host "  NOTE: Mesh optimization DISABLED to preserve all colors!" -ForegroundColor Cyan
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""
