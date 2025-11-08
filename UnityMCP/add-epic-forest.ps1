# ============================================================================
# ADD EPIC DETAILED FOREST TO WORLD
# Adds a massive detailed forest biome with multiple tree types
# ============================================================================

. ".\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  ADDING EPIC DETAILED FOREST" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

# Test connection
try {
    $null = Invoke-RestMethod -Uri "http://localhost:8765/ping" -Method POST -ContentType "application/json" -Body '{}' -UseBasicParsing -ErrorAction Stop
    Write-Host "[OK] Unity MCP server connected" -ForegroundColor Green
} catch {
    Write-Host "[FATAL] Unity MCP server not running!" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}

$totalObjects = 0
$startTime = Get-Date

# ============================================================================
# FOREST ZONE 1: OAK GROVE (Northeast quadrant)
# ============================================================================
Write-Host ""
Write-Host "=== FOREST ZONE 1: OAK GROVE ===" -ForegroundColor Magenta

New-Group -name "OakGrove"

# 15 Oak Trees with varied sizes
for ($i = 0; $i -lt 15; $i++) {
    $x = Get-Random -Minimum 140 -Maximum 200
    $z = Get-Random -Minimum 140 -Maximum 200
    
    $trunkHeight = Get-Random -Minimum 12 -Maximum 20
    $trunkWidth = Get-Random -Minimum 1.2 -Maximum 2.0
    $canopySize = Get-Random -Minimum 14 -Maximum 22
    
    Write-Host "[OAK $i] Creating at ($x, $z)..." -ForegroundColor Gray
    
    # Trunk - BROWN
    Build-ColoredObject -name "Oak_${i}_Trunk" -type "Cylinder" `
        -x $x -y ($trunkHeight / 2) -z $z `
        -sx $trunkWidth -sy $trunkHeight -sz $trunkWidth `
        -color @{ r = 0.4; g = 0.25; b = 0.1 } `
        -metallic 0.0 -smoothness 0.2 `
        -parent "OakGrove"
    $totalObjects++
    
    # Main Canopy - DARK GREEN
    Build-ColoredObject -name "Oak_${i}_Canopy" -type "Sphere" `
        -x $x -y ($trunkHeight + $canopySize/2) -z $z `
        -sx $canopySize -sy $canopySize -sz $canopySize `
        -color @{ r = 0.15; g = 0.5; b = 0.1 } `
        -metallic 0.0 -smoothness 0.1 `
        -parent "OakGrove"
    $totalObjects++
    
    # 3 Additional canopy layers for fullness
    for ($layer = 0; $layer -lt 3; $layer++) {
        $offsetX = Get-Random -Minimum -5 -Maximum 5
        $offsetZ = Get-Random -Minimum -5 -Maximum 5
        $layerSize = $canopySize * (0.6 + ($layer * 0.15))
        
        Build-ColoredObject -name "Oak_${i}_Layer_$layer" -type "Sphere" `
            -x ($x + $offsetX) -y ($trunkHeight + 6 + ($layer * 4)) -z ($z + $offsetZ) `
            -sx $layerSize -sy $layerSize -sz $layerSize `
            -color @{ r = (0.1 + $layer * 0.05); g = (0.45 + $layer * 0.05); b = 0.08 } `
            -metallic 0.0 -smoothness 0.1 `
            -parent "OakGrove"
        $totalObjects++
    }
    
    # Ground vegetation - small bushes
    for ($bush = 0; $bush -lt 2; $bush++) {
        $bushX = $x + (Get-Random -Minimum -8 -Maximum 8)
        $bushZ = $z + (Get-Random -Minimum -8 -Maximum 8)
        $bushSize = Get-Random -Minimum 2 -Maximum 4
        
        Build-ColoredObject -name "Oak_${i}_Bush_$bush" -type "Sphere" `
            -x $bushX -y ($bushSize/2) -z $bushZ `
            -sx $bushSize -sy $bushSize -sz $bushSize `
            -color @{ r = 0.1; g = 0.4; b = 0.08 } `
            -metallic 0.0 -smoothness 0.05 `
            -parent "OakGrove"
        $totalObjects++
    }
}

Write-Host "[OK] Oak Grove: 15 trees with 90+ objects" -ForegroundColor Green

# ============================================================================
# FOREST ZONE 2: PINE FOREST (Northwest quadrant)
# ============================================================================
Write-Host ""
Write-Host "=== FOREST ZONE 2: PINE FOREST ===" -ForegroundColor Magenta

New-Group -name "PineForest"

# 12 Pine Trees - Tall and conical
for ($i = 0; $i -lt 12; $i++) {
    $x = Get-Random -Minimum -200 -Maximum -140
    $z = Get-Random -Minimum 140 -Maximum 200
    
    $trunkHeight = Get-Random -Minimum 18 -Maximum 28
    $trunkWidth = Get-Random -Minimum 0.8 -Maximum 1.4
    
    Write-Host "[PINE $i] Creating at ($x, $z)..." -ForegroundColor Gray
    
    # Trunk - DARK BROWN
    Build-ColoredObject -name "Pine_${i}_Trunk" -type "Cylinder" `
        -x $x -y ($trunkHeight / 2) -z $z `
        -sx $trunkWidth -sy $trunkHeight -sz $trunkWidth `
        -color @{ r = 0.3; g = 0.2; b = 0.08 } `
        -metallic 0.0 -smoothness 0.15 `
        -parent "PineForest"
    $totalObjects++
    
    # Conical canopy - 5 layers getting smaller
    for ($layer = 0; $layer -lt 5; $layer++) {
        $layerHeight = $trunkHeight + 4 + ($layer * 4)
        $layerSize = 14 - ($layer * 2.2)
        if ($layerSize -lt 3) { $layerSize = 3 }
        
        # DARK GREEN conical sections
        Build-ColoredObject -name "Pine_${i}_Layer_$layer" -type "Cylinder" `
            -x $x -y $layerHeight -z $z `
            -sx $layerSize -sy 3 -sz $layerSize `
            -color @{ r = 0.08; g = 0.35; b = 0.08 } `
            -metallic 0.0 -smoothness 0.05 `
            -parent "PineForest"
        $totalObjects++
    }
    
    # Forest floor moss patches
    $mossX = $x + (Get-Random -Minimum -6 -Maximum 6)
    $mossZ = $z + (Get-Random -Minimum -6 -Maximum 6)
    
    Build-ColoredObject -name "Pine_${i}_Moss" -type "Sphere" `
        -x $mossX -y 0.3 -z $mossZ `
        -sx 3 -sy 0.5 -sz 3 `
        -color @{ r = 0.15; g = 0.5; b = 0.15 } `
        -metallic 0.0 -smoothness 0.0 `
        -parent "PineForest"
    $totalObjects++
}

Write-Host "[OK] Pine Forest: 12 trees with 84+ objects" -ForegroundColor Green

# ============================================================================
# FOREST ZONE 3: BIRCH GROVE (Southwest quadrant)
# ============================================================================
Write-Host ""
Write-Host "=== FOREST ZONE 3: BIRCH GROVE ===" -ForegroundColor Magenta

New-Group -name "BirchGrove"

# 10 Birch Trees - White bark
for ($i = 0; $i -lt 10; $i++) {
    $x = Get-Random -Minimum -200 -Maximum -140
    $z = Get-Random -Minimum -200 -Maximum -140
    
    $trunkHeight = Get-Random -Minimum 14 -Maximum 22
    $trunkWidth = Get-Random -Minimum 0.8 -Maximum 1.2
    $canopySize = Get-Random -Minimum 10 -Maximum 16
    
    Write-Host "[BIRCH $i] Creating at ($x, $z)..." -ForegroundColor Gray
    
    # Trunk - WHITE with dark stripes effect
    Build-ColoredObject -name "Birch_${i}_Trunk" -type "Cylinder" `
        -x $x -y ($trunkHeight / 2) -z $z `
        -sx $trunkWidth -sy $trunkHeight -sz $trunkWidth `
        -color @{ r = 0.95; g = 0.95; b = 0.9 } `
        -metallic 0.0 -smoothness 0.3 `
        -parent "BirchGrove"
    $totalObjects++
    
    # Dark stripe (simulated)
    Build-ColoredObject -name "Birch_${i}_Stripe" -type "Cube" `
        -x $x -y ($trunkHeight * 0.6) -z $z `
        -sx ($trunkWidth * 1.1) -sy 1.5 -sz ($trunkWidth * 1.1) `
        -color @{ r = 0.1; g = 0.1; b = 0.1 } `
        -metallic 0.0 -smoothness 0.2 `
        -parent "BirchGrove"
    $totalObjects++
    
    # Light canopy - LIGHT GREEN
    Build-ColoredObject -name "Birch_${i}_Canopy" -type "Sphere" `
        -x $x -y ($trunkHeight + $canopySize/2) -z $z `
        -sx $canopySize -sy ($canopySize * 0.8) -sz $canopySize `
        -color @{ r = 0.5; g = 0.8; b = 0.3 } `
        -metallic 0.0 -smoothness 0.1 `
        -parent "BirchGrove"
    $totalObjects++
    
    # 2 Additional lighter canopy puffs
    for ($puff = 0; $puff -lt 2; $puff++) {
        $offsetX = Get-Random -Minimum -4 -Maximum 4
        $offsetZ = Get-Random -Minimum -4 -Maximum 4
        $puffSize = $canopySize * 0.6
        
        Build-ColoredObject -name "Birch_${i}_Puff_$puff" -type "Sphere" `
            -x ($x + $offsetX) -y ($trunkHeight + 6 + ($puff * 3)) -z ($z + $offsetZ) `
            -sx $puffSize -sy $puffSize -sz $puffSize `
            -color @{ r = 0.55; g = 0.85; b = 0.35 } `
            -metallic 0.0 -smoothness 0.1 `
            -parent "BirchGrove"
        $totalObjects++
    }
}

Write-Host "[OK] Birch Grove: 10 trees with 50+ objects" -ForegroundColor Green

# ============================================================================
# FOREST ZONE 4: MAGICAL WILLOW TREES (Southeast quadrant)
# ============================================================================
Write-Host ""
Write-Host "=== FOREST ZONE 4: MAGICAL WILLOWS ===" -ForegroundColor Magenta

New-Group -name "MagicalWillows"

# 8 Willow Trees with glowing elements
for ($i = 0; $i -lt 8; $i++) {
    $x = Get-Random -Minimum 140 -Maximum 200
    $z = Get-Random -Minimum -200 -Maximum -140
    
    $trunkHeight = Get-Random -Minimum 10 -Maximum 16
    $trunkWidth = Get-Random -Minimum 1.5 -Maximum 2.2
    
    Write-Host "[WILLOW $i] Creating at ($x, $z)..." -ForegroundColor Gray
    
    # Thick trunk - PURPLE-BROWN
    Build-ColoredObject -name "Willow_${i}_Trunk" -type "Cylinder" `
        -x $x -y ($trunkHeight / 2) -z $z `
        -sx $trunkWidth -sy $trunkHeight -sz $trunkWidth `
        -color @{ r = 0.4; g = 0.2; b = 0.3 } `
        -metallic 0.0 -smoothness 0.2 `
        -parent "MagicalWillows"
    $totalObjects++
    
    # Wide drooping canopy - TEAL
    Build-ColoredObject -name "Willow_${i}_Canopy" -type "Sphere" `
        -x $x -y ($trunkHeight + 4) -z $z `
        -sx 18 -sy 14 -sz 18 `
        -color @{ r = 0.2; g = 0.6; b = 0.5 } `
        -metallic 0.0 -smoothness 0.15 `
        -parent "MagicalWillows"
    $totalObjects++
    
    # 6 Hanging vine strands - GLOWING CYAN
    for ($vine = 0; $vine -lt 6; $vine++) {
        $vineAngle = ($vine * 60) * [Math]::PI / 180
        $vineX = $x + ([Math]::Cos($vineAngle) * 7)
        $vineZ = $z + ([Math]::Sin($vineAngle) * 7)
        $vineLength = Get-Random -Minimum 8 -Maximum 14
        
        Build-ColoredObject -name "Willow_${i}_Vine_$vine" -type "Cylinder" `
            -x $vineX -y (($trunkHeight + 4) - $vineLength/2) -z $vineZ `
            -sx 0.3 -sy $vineLength -sz 0.3 `
            -color @{ r = 0.3; g = 0.8; b = 0.7 } `
            -metallic 0.0 -smoothness 0.4 `
            -parent "MagicalWillows"
        
        Set-Material -name "Willow_${i}_Vine_$vine" `
            -emission @{ r = 0.2; g = 0.6; b = 0.5; intensity = 1.5 }
        $totalObjects++
    }
    
    # 3 Magical fireflies (glowing orbs)
    for ($fly = 0; $fly -lt 3; $fly++) {
        $flyX = $x + (Get-Random -Minimum -8 -Maximum 8)
        $flyZ = $z + (Get-Random -Minimum -8 -Maximum 8)
        $flyY = Get-Random -Minimum 4 -Maximum 12
        
        Build-ColoredObject -name "Willow_${i}_Firefly_$fly" -type "Sphere" `
            -x $flyX -y $flyY -z $flyZ `
            -sx 0.5 -sy 0.5 -sz 0.5 `
            -color @{ r = 1.0; g = 1.0; b = 0.3 } `
            -metallic 0.0 -smoothness 1.0 `
            -parent "MagicalWillows"
        
        Set-Material -name "Willow_${i}_Firefly_$fly" `
            -emission @{ r = 1.0; g = 1.0; b = 0.3; intensity = 3.0 }
        $totalObjects++
    }
}

Write-Host "[OK] Magical Willows: 8 trees with 80+ objects" -ForegroundColor Green

# ============================================================================
# FOREST UNDERGROWTH: Ferns, Mushrooms, Rocks
# ============================================================================
Write-Host ""
Write-Host "=== FOREST UNDERGROWTH ===" -ForegroundColor Magenta

New-Group -name "ForestUndergrowth"

# 20 Ferns scattered throughout
for ($i = 0; $i -lt 20; $i++) {
    $quadrant = Get-Random -Minimum 0 -Maximum 4
    
    switch ($quadrant) {
        0 { $x = Get-Random -Minimum 140 -Maximum 200; $z = Get-Random -Minimum 140 -Maximum 200 }
        1 { $x = Get-Random -Minimum -200 -Maximum -140; $z = Get-Random -Minimum 140 -Maximum 200 }
        2 { $x = Get-Random -Minimum -200 -Maximum -140; $z = Get-Random -Minimum -200 -Maximum -140 }
        3 { $x = Get-Random -Minimum 140 -Maximum 200; $z = Get-Random -Minimum -200 -Maximum -140 }
    }
    
    $fernSize = Get-Random -Minimum 1.5 -Maximum 3.0
    
    Build-ColoredObject -name "Fern_$i" -type "Cube" `
        -x $x -y ($fernSize/2) -z $z `
        -ry (Get-Random -Minimum 0 -Maximum 360) `
        -sx 0.5 -sy $fernSize -sz 2.0 `
        -color @{ r = 0.15; g = 0.45; b = 0.15 } `
        -metallic 0.0 -smoothness 0.05 `
        -parent "ForestUndergrowth"
    $totalObjects++
}

# 15 Glowing Mushrooms
for ($i = 0; $i -lt 15; $i++) {
    $quadrant = Get-Random -Minimum 0 -Maximum 4
    
    switch ($quadrant) {
        0 { $x = Get-Random -Minimum 140 -Maximum 200; $z = Get-Random -Minimum 140 -Maximum 200 }
        1 { $x = Get-Random -Minimum -200 -Maximum -140; $z = Get-Random -Minimum 140 -Maximum 200 }
        2 { $x = Get-Random -Minimum -200 -Maximum -140; $z = Get-Random -Minimum -200 -Maximum -140 }
        3 { $x = Get-Random -Minimum 140 -Maximum 200; $z = Get-Random -Minimum -200 -Maximum -140 }
    }
    
    # Mushroom stem
    Build-ColoredObject -name "Mushroom_${i}_Stem" -type "Cylinder" `
        -x $x -y 0.8 -z $z `
        -sx 0.3 -sy 0.8 -sz 0.3 `
        -color @{ r = 0.9; g = 0.85; b = 0.7 } `
        -metallic 0.0 -smoothness 0.2 `
        -parent "ForestUndergrowth"
    $totalObjects++
    
    # Mushroom cap - GLOWING
    $capColors = @(
        @{ r = 1.0; g = 0.2; b = 0.2 },
        @{ r = 0.8; g = 0.2; b = 1.0 },
        @{ r = 0.2; g = 0.8; b = 1.0 }
    )
    $capColor = $capColors | Get-Random
    
    Build-ColoredObject -name "Mushroom_${i}_Cap" -type "Sphere" `
        -x $x -y 1.8 -z $z `
        -sx 1.5 -sy 0.8 -sz 1.5 `
        -color $capColor `
        -metallic 0.0 -smoothness 0.6 `
        -parent "ForestUndergrowth"
    
    Set-Material -name "Mushroom_${i}_Cap" `
        -emission @{ r = $capColor.r; g = $capColor.g; b = $capColor.b; intensity = 2.0 }
    $totalObjects++
}

# 25 Forest rocks
for ($i = 0; $i -lt 25; $i++) {
    $quadrant = Get-Random -Minimum 0 -Maximum 4
    
    switch ($quadrant) {
        0 { $x = Get-Random -Minimum 140 -Maximum 200; $z = Get-Random -Minimum 140 -Maximum 200 }
        1 { $x = Get-Random -Minimum -200 -Maximum -140; $z = Get-Random -Minimum 140 -Maximum 200 }
        2 { $x = Get-Random -Minimum -200 -Maximum -140; $z = Get-Random -Minimum -200 -Maximum -140 }
        3 { $x = Get-Random -Minimum 140 -Maximum 200; $z = Get-Random -Minimum -200 -Maximum -140 }
    }
    
    $rockSize = Get-Random -Minimum 1.5 -Maximum 3.5
    
    Build-ColoredObject -name "ForestRock_$i" -type "Sphere" `
        -x $x -y ($rockSize * 0.4) -z $z `
        -rx (Get-Random -Minimum -15 -Maximum 15) `
        -ry (Get-Random -Minimum 0 -Maximum 360) `
        -sx $rockSize -sy ($rockSize * 0.7) -sz ($rockSize * 0.9) `
        -color @{ r = 0.4; g = 0.38; b = 0.35 } `
        -metallic 0.0 -smoothness 0.3 `
        -parent "ForestUndergrowth"
    $totalObjects++
}

Write-Host "[OK] Undergrowth: 60+ objects" -ForegroundColor Green

# ============================================================================
# FINAL STATS
# ============================================================================
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  EPIC FOREST COMPLETE!" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

$duration = (Get-Date) - $startTime
$minutes = [Math]::Floor($duration.TotalMinutes)
$seconds = $duration.Seconds

Write-Host "  Total Forest Objects: $totalObjects" -ForegroundColor White
Write-Host "  Time: ${minutes}m ${seconds}s" -ForegroundColor White
Write-Host ""
Write-Host "  FOREST ZONES:" -ForegroundColor Yellow
Write-Host "    - Oak Grove (NE): 15 trees, brown/green" -ForegroundColor DarkGreen
Write-Host "    - Pine Forest (NW): 12 trees, dark green conifers" -ForegroundColor DarkGreen
Write-Host "    - Birch Grove (SW): 10 trees, white bark/light green" -ForegroundColor Gray
Write-Host "    - Magical Willows (SE): 8 trees with glowing vines" -ForegroundColor Cyan
Write-Host "    - Undergrowth: 60+ ferns, mushrooms, rocks" -ForegroundColor DarkYellow
Write-Host ""
Write-Host "  TOTAL WORLD OBJECTS: ~400+" -ForegroundColor White
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  Your world is now COMPLETE with forest ecosystem!" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""
