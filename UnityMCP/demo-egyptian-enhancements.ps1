# ============================================================================
# Egyptian World Enhancements Demo
# Showcases new architectural tools on the pyramid world
# ============================================================================

. ".\egyptian-world-helpers.ps1"

Write-Host ""
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host "  EGYPTIAN WORLD ENHANCEMENTS DEMO" -ForegroundColor Cyan
Write-Host "  Testing Advanced Construction Tools" -ForegroundColor Cyan
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host ""

# Test connection
if (-not (Test-UnityConnection)) {
    Write-Host "[ERROR] Cannot connect to Unity!" -ForegroundColor Red
    exit 1
}

$totalObjects = 0
$startTime = Get-Date

Write-Host "[INFO] Adding enhancements to Egyptian world..." -ForegroundColor Yellow
Write-Host ""

# ============================================================================
# ENHANCEMENT 1: GRAND TEMPLE WITH COLONNADE
# ============================================================================
Write-Host "=== ENHANCEMENT 1: GRAND TEMPLE ===" -ForegroundColor Magenta

New-Group -name "GrandTemple"

# Temple platform
Build-ColoredObject -name "Temple_Platform" -type "Cube" `
    -x -150 -y 1 -z -120 `
    -sx 40 -sy 2 -sz 60 `
    -color @{ r = 0.35; g = 0.30; b = 0.25 } `
    -metallic 0.0 -smoothness 0.3 `
    -parent "GrandTemple"
$totalObjects++

# Front colonnade
$colonnade1 = Build-Colonnade -name "Temple_Front_Colonnade" `
    -x1 -170 -z1 -150 -x2 -130 -z2 -150 `
    -y 2 -columns 8 -columnHeight 12 `
    -parent "GrandTemple"
$totalObjects += $colonnade1

# Side colonnades
$colonnade2 = Build-Colonnade -name "Temple_Left_Colonnade" `
    -x1 -170 -z1 -150 -x2 -170 -z2 -90 `
    -y 2 -columns 6 -columnHeight 12 `
    -parent "GrandTemple"
$totalObjects += $colonnade2

$colonnade3 = Build-Colonnade -name "Temple_Right_Colonnade" `
    -x1 -130 -z1 -150 -x2 -130 -z2 -90 `
    -y 2 -columns 6 -columnHeight 12 `
    -parent "GrandTemple"
$totalObjects += $colonnade3

# Temple entrance archway
$arch1 = Build-Archway -name "Temple_MainGate" `
    -x -150 -y 2 -z -90 `
    -width 8 -height 10 -archType "Rounded" `
    -parent "GrandTemple"
$totalObjects += $arch1

# Stairs to temple entrance
$stairs1 = Build-Staircase -name "Temple_Stairs" `
    -x -150 -y 0 -z -155 `
    -steps 8 -stepWidth 10 -stepHeight 0.25 -direction "North" `
    -parent "GrandTemple"
$totalObjects += $stairs1

Write-Host "[OK] Grand Temple completed" -ForegroundColor Green

# ============================================================================
# ENHANCEMENT 2: RITUAL CIRCLE AROUND ALTAR
# ============================================================================
Write-Host ""
Write-Host "=== ENHANCEMENT 2: RITUAL CIRCLE ===" -ForegroundColor Magenta

New-Group -name "RitualCircle"

# Inner circle of pillars
$circle1 = Build-CircularWall -name "RitualCircle_Inner" `
    -x 0 -y 0 -z 0 `
    -radius 55 -segments 24 -height 6 -wallType "Pillars" `
    -parent "RitualCircle"
$totalObjects += $circle1

# Outer circle with gaps
$circle2 = Build-CircularWall -name "RitualCircle_Outer" `
    -x 0 -y 0 -z 0 `
    -radius 70 -segments 32 -height 4 -wallType "Gaps" `
    -parent "RitualCircle"
$totalObjects += $circle2

Write-Host "[OK] Ritual Circle completed" -ForegroundColor Green

# ============================================================================
# ENHANCEMENT 3: PYRAMID ENTRANCE IMPROVEMENTS
# ============================================================================
Write-Host ""
Write-Host "=== ENHANCEMENT 3: PYRAMID ENTRANCES ===" -ForegroundColor Magenta

New-Group -name "PyramidEntrances"

# Great Pyramid entrance archway
$arch2 = Build-Archway -name "GreatPyramid_Gate" `
    -x 80 -y 0 -z 113 `
    -width 6 -height 8 -thickness 2 -archType "Pointed" `
    -parent "PyramidEntrances"
$totalObjects += $arch2

# Entrance stairs
$stairs2 = Build-Staircase -name "GreatPyramid_EntranceStairs" `
    -x 80 -y 0 -z 120 `
    -steps 5 -stepWidth 8 -stepHeight 0.5 -direction "South" `
    -parent "PyramidEntrances"
$totalObjects += $stairs2

# Second Pyramid entrance
$arch3 = Build-Archway -name "SecondPyramid_Gate" `
    -x -70 -y 0 -z 118 `
    -width 5 -height 7 -thickness 2 -archType "Rounded" `
    -parent "PyramidEntrances"
$totalObjects += $arch3

Write-Host "[OK] Pyramid entrances enhanced" -ForegroundColor Green

# ============================================================================
# ENHANCEMENT 4: CEREMONIAL BRAZIERS
# ============================================================================
Write-Host ""
Write-Host "=== ENHANCEMENT 4: CEREMONIAL BRAZIERS ===" -ForegroundColor Magenta

New-Group -name "CeremonialBraziers"

# Braziers around the altar (8 positions)
$brazierPositions = @(
    @{x = 28; z = 28}, @{x = -28; z = 28}, @{x = 28; z = -28}, @{x = -28; z = -28},
    @{x = 40; z = 0}, @{x = -40; z = 0}, @{x = 0; z = 40}, @{x = 0; z = -40}
)

foreach ($pos in $brazierPositions) {
    $brazier = Build-Brazier -name "Ceremonial_Brazier_$($pos.x)_$($pos.z)" `
        -x $pos.x -y 0 -z $pos.z `
        -height 5 -flameIntensity 2.5 `
        -parent "CeremonialBraziers"
    $totalObjects += $brazier
}

# Braziers at temple entrance
for ($i = 0; $i -lt 4; $i++) {
    $x = -165 + ($i * 10)
    $brazier = Build-Brazier -name "Temple_Brazier_$i" `
        -x $x -y 2 -z -155 `
        -height 4 -flameIntensity 2.0 `
        -parent "CeremonialBraziers"
    $totalObjects += $brazier
}

Write-Host "[OK] Ceremonial braziers placed" -ForegroundColor Green

# ============================================================================
# ENHANCEMENT 5: SPHINX TEMPLE
# ============================================================================
Write-Host ""
Write-Host "=== ENHANCEMENT 5: SPHINX TEMPLE ===" -ForegroundColor Magenta

New-Group -name "SphinxTemple"

# Platform in front of Sphinx
Build-ColoredObject -name "Sphinx_Temple_Platform" -type "Cube" `
    -x -90 -y 0.5 -z 50 `
    -sx 30 -sy 1 -sz 20 `
    -color @{ r = 0.35; g = 0.30; b = 0.25 } `
    -metallic 0.0 -smoothness 0.3 `
    -parent "SphinxTemple"
$totalObjects++

# Colonnade leading to Sphinx
$colonnade4 = Build-Colonnade -name "Sphinx_Approach" `
    -x1 -90 -z1 60 -x2 -90 -z2 35 `
    -y 1 -columns 6 -columnHeight 8 `
    -parent "SphinxTemple"
$totalObjects += $colonnade4

# Sphinx altar
Build-ColoredObject -name "Sphinx_Altar" -type "Cube" `
    -x -90 -y 2 -z 50 `
    -sx 4 -sy 1.5 -sz 6 `
    -color @{ r = 0.65; g = 0.10; b = 0.10 } `
    -metallic 0.0 -smoothness 0.4 `
    -parent "SphinxTemple"
$totalObjects++

# Braziers at Sphinx temple (4 corners)
$sphinxBraziers = @(
    @{x = -105; z = 60}, @{x = -75; z = 60},
    @{x = -105; z = 40}, @{x = -75; z = 40}
)

foreach ($pos in $sphinxBraziers) {
    $brazier = Build-Brazier -name "Sphinx_Brazier_$($pos.x)_$($pos.z)" `
        -x $pos.x -y 1 -z $pos.z `
        -height 3 -flameIntensity 2.0 `
        -parent "SphinxTemple"
    $totalObjects += $brazier
}

Write-Host "[OK] Sphinx temple completed" -ForegroundColor Green

# ============================================================================
# ENHANCEMENT 6: MARKETPLACE
# ============================================================================
Write-Host ""
Write-Host "=== ENHANCEMENT 6: MARKETPLACE ===" -ForegroundColor Magenta

New-Group -name "Marketplace"

# Market square platform
Build-ColoredObject -name "Market_Square" -type "Cube" `
    -x 150 -y 0.3 -z -120 `
    -sx 50 -sy 0.5 -sz 50 `
    -color @{ r = 0.76; g = 0.60; b = 0.42 } `
    -metallic 0.0 -smoothness 0.2 `
    -parent "Marketplace"
$totalObjects++

# Market stalls (8 stalls)
$stallPositions = @(
    @{x = 135; z = -110}, @{x = 145; z = -110}, @{x = 155; z = -110}, @{x = 165; z = -110},
    @{x = 135; z = -130}, @{x = 145; z = -130}, @{x = 155; z = -130}, @{x = 165; z = -130}
)

foreach ($pos in $stallPositions) {
    # Stall roof supports
    for ($i = 0; $i -lt 4; $i++) {
        $dx = if ($i -eq 0 -or $i -eq 2) { -2 } else { 2 }
        $dz = if ($i -lt 2) { -2 } else { 2 }
        
        Build-ColoredObject -name "Stall_$($pos.x)_$($pos.z)_Post_$i" -type "Cylinder" `
            -x ($pos.x + $dx) -y 2 -z ($pos.z + $dz) `
            -sx 0.2 -sy 2 -sz 0.2 `
            -color @{ r = 0.45; g = 0.35; b = 0.25 } `
            -metallic 0.0 -smoothness 0.1 `
            -parent "Marketplace"
        $totalObjects++
    }
    
    # Stall roof
    Build-ColoredObject -name "Stall_$($pos.x)_$($pos.z)_Roof" -type "Cube" `
        -x $pos.x -y 4.2 -z $pos.z `
        -sx 5 -sy 0.3 -sz 5 `
        -color @{ r = 0.7; g = 0.4; b = 0.2 } `
        -metallic 0.0 -smoothness 0.2 `
        -parent "Marketplace"
    $totalObjects++
    
    # Market goods (pottery)
    for ($j = 0; $j -lt 3; $j++) {
        Build-ColoredObject -name "Stall_$($pos.x)_$($pos.z)_Goods_$j" -type "Cylinder" `
            -x ($pos.x + ($j - 1)) -y 1 -z $pos.z `
            -sx 0.4 -sy 0.8 -sz 0.4 `
            -color @{ r = 0.5; g = 0.3; b = 0.2 } `
            -metallic 0.0 -smoothness 0.3 `
            -parent "Marketplace"
        $totalObjects++
    }
}

# Market entrance archway
$arch4 = Build-Archway -name "Market_Gate" `
    -x 125 -y 0 -z -120 `
    -width 10 -height 8 -archType "Square" `
    -parent "Marketplace"
$totalObjects += $arch4

Write-Host "[OK] Marketplace completed" -ForegroundColor Green

# ============================================================================
# FINAL STATISTICS
# ============================================================================
Write-Host ""
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host "  ENHANCEMENTS COMPLETE!" -ForegroundColor Cyan
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host ""

$endTime = Get-Date
$duration = ($endTime - $startTime).TotalSeconds

Write-Host "ENHANCEMENT STATISTICS:" -ForegroundColor Yellow
Write-Host "  Total New Objects: $totalObjects" -ForegroundColor White
Write-Host "  Construction Time: $([Math]::Round($duration, 2)) seconds" -ForegroundColor White
Write-Host ""

Write-Host "NEW FEATURES ADDED:" -ForegroundColor Yellow
Write-Host "  1. Grand Temple with Colonnades" -ForegroundColor Green
Write-Host "  2. Ritual Circle (dual ring of pillars)" -ForegroundColor Green
Write-Host "  3. Enhanced Pyramid Entrances" -ForegroundColor Green
Write-Host "  4. Ceremonial Braziers (20+ flames)" -ForegroundColor Green
Write-Host "  5. Sphinx Temple with Approach" -ForegroundColor Green
Write-Host "  6. Bustling Marketplace (8 stalls)" -ForegroundColor Green
Write-Host ""

Write-Host "TOOLS DEMONSTRATED:" -ForegroundColor Yellow
Write-Host "  - Build-Colonnade: 4 instances" -ForegroundColor Gray
Write-Host "  - Build-Archway: 4 instances" -ForegroundColor Gray
Write-Host "  - Build-Staircase: 2 instances" -ForegroundColor Gray
Write-Host "  - Build-CircularWall: 2 instances" -ForegroundColor Gray
Write-Host "  - Build-Brazier: 20+ instances" -ForegroundColor Gray
Write-Host ""

Write-Host "[DONE] Egyptian world enhanced with advanced architectural features!" -ForegroundColor Cyan
Write-Host ""
