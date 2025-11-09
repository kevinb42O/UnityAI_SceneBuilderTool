# ============================================================================
# EGYPTIAN PYRAMID WORLD - Ultra-Complex Ancient Civilization Scene
# Features: Multiple pyramids with interiors, Great Sphinx, battle altar,
# obelisks, palm trees, torch lighting, hieroglyphics, and sand biome
# ============================================================================

. ".\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "========================================================================" -ForegroundColor Yellow
Write-Host "  EGYPTIAN PYRAMID WORLD - ANCIENT CIVILIZATION BUILDER" -ForegroundColor Yellow
Write-Host "  Ultra-Complex Scene with Interiors & Advanced Details" -ForegroundColor Yellow
Write-Host "========================================================================" -ForegroundColor Yellow
Write-Host ""

# Test connection
try {
    $null = Invoke-RestMethod -Uri "http://localhost:8765/ping" -Method POST -ContentType "application/json" -Body '{}' -UseBasicParsing -ErrorAction Stop
    Write-Host "[OK] Unity MCP server connected" -ForegroundColor Green
} catch {
    Write-Host "[FATAL] Unity MCP server not running!" -ForegroundColor Red
    Write-Host "       Start Unity and run the MCP server first" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "[CLEANUP] Clearing old scene..." -ForegroundColor Yellow

# Delete existing Egyptian world elements
$groupsToDelete = @(
    "EgyptianWorld", "Pyramids", "Sphinx", "BattleAltar", "Obelisks", 
    "PalmTrees", "DesertGround", "StonePaths", "Decorations", "TorchLights",
    "PyramidInteriors"
)

foreach ($group in $groupsToDelete) {
    try {
        $null = Invoke-RestMethod -Uri "$UNITY_BASE/deleteGameObject" `
            -Method POST -ContentType "application/json" `
            -Body (@{ name = $group } | ConvertTo-Json) -UseBasicParsing
        Write-Host "  [DELETED] $group" -ForegroundColor DarkGray
    } catch {
        Write-Host "  [SKIP] $group not found" -ForegroundColor DarkGray
    }
}

Write-Host "[OK] Scene cleared" -ForegroundColor Green
Write-Host ""

$totalObjects = 0
$startTime = Get-Date

# ============================================================================
# EGYPTIAN COLOR PALETTE
# ============================================================================
$colors = @{
    Sand = @{ r = 0.87; g = 0.72; b = 0.53 }
    SandDark = @{ r = 0.76; g = 0.60; b = 0.42 }
    Limestone = @{ r = 0.90; g = 0.85; b = 0.75 }
    GoldLeaf = @{ r = 0.85; g = 0.65; b = 0.13 }
    DarkStone = @{ r = 0.35; g = 0.30; b = 0.25 }
    PalmTrunk = @{ r = 0.45; g = 0.35; b = 0.25 }
    PalmLeaf = @{ r = 0.20; g = 0.50; b = 0.15 }
    TorchFire = @{ r = 1.0; g = 0.5; b = 0.0; intensity = 2.5 }
    BloodRed = @{ r = 0.65; g = 0.10; b = 0.10 }
}

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

function Build-Pyramid {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [float]$baseSize = 60,
        [float]$height = 40,
        [string]$parent = "",
        [bool]$createInterior = $true
    )
    
    Write-Host "  [PYRAMID] Building $name (${baseSize}x${height})..." -ForegroundColor Cyan
    
    # Create pyramid group
    $pyramidGroup = "${name}_Group"
    New-Group -name $pyramidGroup -parent $parent
    
    # Pyramid is made of stacked layers getting smaller
    $layers = 20
    for ($i = 0; $i -lt $layers; $i++) {
        $t = $i / $layers
        $layerY = $y + ($height * $t)
        $layerSize = $baseSize * (1 - $t * 0.95)  # Slight taper
        
        Build-ColoredObject -name "${name}_Layer_$i" -type "Cube" `
            -x $x -y $layerY -z $z `
            -sx $layerSize -sy ($height / $layers) -sz $layerSize `
            -color $colors.Limestone `
            -metallic 0.0 -smoothness 0.2 `
            -parent $pyramidGroup
        
        $script:totalObjects++
    }
    
    # Pyramid capstone (golden top)
    Build-ColoredObject -name "${name}_Capstone" -type "Cube" `
        -x $x -y ($y + $height + 1) -z $z `
        -sx 2 -sy 2 -sz 2 `
        -color $colors.GoldLeaf `
        -metallic 0.85 -smoothness 0.9 `
        -parent $pyramidGroup
    $script:totalObjects++
    
    if ($createInterior) {
        # Create entrance
        Build-ColoredObject -name "${name}_Entrance" -type "Cube" `
            -x $x -y ($y + 2) -z ($z + $baseSize/2 - 1) `
            -sx 4 -sy 5 -sz 2 `
            -color $colors.DarkStone `
            -metallic 0.0 -smoothness 0.1 `
            -parent $pyramidGroup
        $script:totalObjects++
        
        # Entrance corridor
        for ($i = 0; $i -lt 8; $i++) {
            $corridorZ = $z + ($baseSize/2 - 2) - ($i * 2)
            
            # Floor
            Build-ColoredObject -name "${name}_Corridor_Floor_$i" -type "Cube" `
                -x $x -y ($y + 0.5) -z $corridorZ `
                -sx 4 -sy 0.5 -sz 2 `
                -color $colors.DarkStone `
                -metallic 0.0 -smoothness 0.3 `
                -parent $pyramidGroup
            $script:totalObjects++
            
            # Walls
            Build-ColoredObject -name "${name}_Corridor_Wall_L_$i" -type "Cube" `
                -x ($x - 2.5) -y ($y + 3) -z $corridorZ `
                -sx 0.5 -sy 5 -sz 2 `
                -color $colors.Limestone `
                -metallic 0.0 -smoothness 0.2 `
                -parent $pyramidGroup
            $script:totalObjects++
            
            Build-ColoredObject -name "${name}_Corridor_Wall_R_$i" -type "Cube" `
                -x ($x + 2.5) -y ($y + 3) -z $corridorZ `
                -sx 0.5 -sy 5 -sz 2 `
                -color $colors.Limestone `
                -metallic 0.0 -smoothness 0.2 `
                -parent $pyramidGroup
            $script:totalObjects++
            
            # Ceiling
            Build-ColoredObject -name "${name}_Corridor_Ceiling_$i" -type "Cube" `
                -x $x -y ($y + 5.5) -z $corridorZ `
                -sx 5 -sy 0.5 -sz 2 `
                -color $colors.Limestone `
                -metallic 0.0 -smoothness 0.2 `
                -parent $pyramidGroup
            $script:totalObjects++
            
            # Add torch every 2 segments
            if ($i % 2 -eq 0) {
                # Torch left
                Build-ColoredObject -name "${name}_Torch_L_$i" -type "Cylinder" `
                    -x ($x - 2) -y ($y + 4) -z $corridorZ `
                    -sx 0.2 -sy 0.5 -sz 0.2 `
                    -color @{ r = 0.3; g = 0.2; b = 0.1 } `
                    -metallic 0.0 -smoothness 0.1 `
                    -parent $pyramidGroup
                $script:totalObjects++
                
                Build-ColoredObject -name "${name}_Flame_L_$i" -type "Sphere" `
                    -x ($x - 2) -y ($y + 5) -z $corridorZ `
                    -sx 0.3 -sy 0.4 -sz 0.3 `
                    -parent $pyramidGroup
                Set-Material -name "${name}_Flame_L_$i" -emission $colors.TorchFire
                $script:totalObjects++
                
                # Torch right
                Build-ColoredObject -name "${name}_Torch_R_$i" -type "Cylinder" `
                    -x ($x + 2) -y ($y + 4) -z $corridorZ `
                    -sx 0.2 -sy 0.5 -sz 0.2 `
                    -color @{ r = 0.3; g = 0.2; b = 0.1 } `
                    -metallic 0.0 -smoothness 0.1 `
                    -parent $pyramidGroup
                $script:totalObjects++
                
                Build-ColoredObject -name "${name}_Flame_R_$i" -type "Sphere" `
                    -x ($x + 2) -y ($y + 5) -z $corridorZ `
                    -sx 0.3 -sy 0.4 -sz 0.3 `
                    -parent $pyramidGroup
                Set-Material -name "${name}_Flame_R_$i" -emission $colors.TorchFire
                $script:totalObjects++
            }
        }
        
        # Central chamber (treasure room)
        $chamberZ = $z - 5
        
        # Chamber floor
        Build-ColoredObject -name "${name}_Chamber_Floor" -type "Cube" `
            -x $x -y ($y + 0.5) -z $chamberZ `
            -sx 15 -sy 0.5 -sz 15 `
            -color $colors.DarkStone `
            -metallic 0.0 -smoothness 0.3 `
            -parent $pyramidGroup
        $script:totalObjects++
        
        # Chamber walls (4 sides)
        Build-ColoredObject -name "${name}_Chamber_Wall_N" -type "Cube" `
            -x $x -y ($y + 6) -z ($chamberZ - 7.5) `
            -sx 15 -sy 11 -sz 0.5 `
            -color $colors.Limestone `
            -metallic 0.0 -smoothness 0.2 `
            -parent $pyramidGroup
        $script:totalObjects++
        
        Build-ColoredObject -name "${name}_Chamber_Wall_S" -type "Cube" `
            -x $x -y ($y + 6) -z ($chamberZ + 7.5) `
            -sx 15 -sy 11 -sz 0.5 `
            -color $colors.Limestone `
            -metallic 0.0 -smoothness 0.2 `
            -parent $pyramidGroup
        $script:totalObjects++
        
        Build-ColoredObject -name "${name}_Chamber_Wall_E" -type "Cube" `
            -x ($x + 7.5) -y ($y + 6) -z $chamberZ `
            -sx 0.5 -sy 11 -sz 15 `
            -color $colors.Limestone `
            -metallic 0.0 -smoothness 0.2 `
            -parent $pyramidGroup
        $script:totalObjects++
        
        Build-ColoredObject -name "${name}_Chamber_Wall_W" -type "Cube" `
            -x ($x - 7.5) -y ($y + 6) -z $chamberZ `
            -sx 0.5 -sy 11 -sz 15 `
            -color $colors.Limestone `
            -metallic 0.0 -smoothness 0.2 `
            -parent $pyramidGroup
        $script:totalObjects++
        
        # Chamber ceiling
        Build-ColoredObject -name "${name}_Chamber_Ceiling" -type "Cube" `
            -x $x -y ($y + 12) -z $chamberZ `
            -sx 15 -sy 0.5 -sz 15 `
            -color $colors.Limestone `
            -metallic 0.0 -smoothness 0.2 `
            -parent $pyramidGroup
        $script:totalObjects++
        
        # Sarcophagus in center
        Build-ColoredObject -name "${name}_Sarcophagus" -type "Cube" `
            -x $x -y ($y + 2) -z $chamberZ `
            -sx 3 -sy 2 -sz 6 `
            -color $colors.GoldLeaf `
            -metallic 0.7 -smoothness 0.8 `
            -parent $pyramidGroup
        $script:totalObjects++
        
        # Treasure chests in corners
        $chestPositions = @(
            @{x = $x - 5; z = $chamberZ - 5},
            @{x = $x + 5; z = $chamberZ - 5},
            @{x = $x - 5; z = $chamberZ + 5},
            @{x = $x + 5; z = $chamberZ + 5}
        )
        
        foreach ($pos in $chestPositions) {
            Build-ColoredObject -name "${name}_Chest_$($pos.x)_$($pos.z)" -type "Cube" `
                -x $pos.x -y ($y + 1.5) -z $pos.z `
                -sx 2 -sy 1.5 -sz 2 `
                -color @{ r = 0.4; g = 0.25; b = 0.1 } `
                -metallic 0.0 -smoothness 0.3 `
                -parent $pyramidGroup
            $script:totalObjects++
            
            # Gold accent on chest
            Build-ColoredObject -name "${name}_ChestGold_$($pos.x)_$($pos.z)" -type "Cube" `
                -x $pos.x -y ($y + 2) -z $pos.z `
                -sx 2.2 -sy 0.2 -sz 2.2 `
                -color $colors.GoldLeaf `
                -metallic 0.8 -smoothness 0.9 `
                -parent $pyramidGroup
            $script:totalObjects++
        }
        
        # Hieroglyphic panels on walls
        for ($i = 0; $i -lt 4; $i++) {
            $panelX = $x - 6 + ($i * 4)
            Build-ColoredObject -name "${name}_Hieroglyph_$i" -type "Cube" `
                -x $panelX -y ($y + 6) -z ($chamberZ - 7.3) `
                -sx 2 -sy 3 -sz 0.2 `
                -color $colors.GoldLeaf `
                -metallic 0.5 -smoothness 0.6 `
                -parent $pyramidGroup
            $script:totalObjects++
        }
        
        # Chamber braziers (4 corners, elevated)
        foreach ($pos in $chestPositions) {
            Build-ColoredObject -name "${name}_Brazier_$($pos.x)_$($pos.z)" -type "Cylinder" `
                -x $pos.x -y ($y + 4) -z $pos.z `
                -sx 0.5 -sy 1 -sz 0.5 `
                -color $colors.DarkStone `
                -metallic 0.3 -smoothness 0.2 `
                -parent $pyramidGroup
            $script:totalObjects++
            
            Build-ColoredObject -name "${name}_BrazierFire_$($pos.x)_$($pos.z)" -type "Sphere" `
                -x $pos.x -y ($y + 5.5) -z $pos.z `
                -sx 0.6 -sy 0.8 -sz 0.6 `
                -parent $pyramidGroup
            Set-Material -name "${name}_BrazierFire_$($pos.x)_$($pos.z)" -emission $colors.TorchFire
            $script:totalObjects++
        }
    }
    
    Write-Host "  [PYRAMID] $name completed with interior" -ForegroundColor Green
}

function Build-Obelisk {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [float]$height = 20,
        [string]$parent = ""
    )
    
    # Obelisk base
    Build-ColoredObject -name "${name}_Base" -type "Cube" `
        -x $x -y ($y + 1) -z $z `
        -sx 3 -sy 2 -sz 3 `
        -color $colors.DarkStone `
        -metallic 0.0 -smoothness 0.3 `
        -parent $parent
    $script:totalObjects++
    
    # Obelisk shaft (tapered)
    $segments = 10
    for ($i = 0; $i -lt $segments; $i++) {
        $t = $i / $segments
        $segmentY = $y + 2 + ($height * $t)
        $segmentSize = 2.0 * (1 - $t * 0.5)
        
        Build-ColoredObject -name "${name}_Shaft_$i" -type "Cube" `
            -x $x -y $segmentY -z $z `
            -sx $segmentSize -sy ($height / $segments) -sz $segmentSize `
            -color $colors.Limestone `
            -metallic 0.0 -smoothness 0.2 `
            -parent $parent
        $script:totalObjects++
    }
    
    # Pyramidion (golden top)
    Build-ColoredObject -name "${name}_Pyramidion" -type "Cube" `
        -x $x -y ($y + $height + 3) -z $z `
        -sx 1.5 -sy 2 -sz 1.5 `
        -color $colors.GoldLeaf `
        -metallic 0.9 -smoothness 0.95 `
        -parent $parent
    $script:totalObjects++
    
    # Hieroglyphic bands (3 decorative bands)
    for ($i = 0; $i -lt 3; $i++) {
        $bandY = $y + 5 + ($i * 6)
        Build-ColoredObject -name "${name}_Band_$i" -type "Cube" `
            -x $x -y $bandY -z $z `
            -sx 2.2 -sy 0.5 -sz 2.2 `
            -color $colors.GoldLeaf `
            -metallic 0.6 -smoothness 0.7 `
            -parent $parent
        $script:totalObjects++
    }
}

function Build-PalmTree {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [float]$height = 12,
        [string]$parent = ""
    )
    
    # Trunk (segmented for natural look)
    $trunkSegments = 6
    for ($i = 0; $i -lt $trunkSegments; $i++) {
        $segmentY = $y + ($height / $trunkSegments) * $i
        $segmentWidth = 0.8 - ($i * 0.05)
        
        Build-ColoredObject -name "${name}_Trunk_$i" -type "Cylinder" `
            -x $x -y $segmentY -z $z `
            -sx $segmentWidth -sy ($height / ($trunkSegments * 2)) -sz $segmentWidth `
            -color $colors.PalmTrunk `
            -metallic 0.0 -smoothness 0.2 `
            -parent $parent
        $script:totalObjects++
    }
    
    # Fronds (8 palm leaves radiating from top)
    for ($i = 0; $i -lt 8; $i++) {
        $angle = ($i * 45) * [Math]::PI / 180
        $frondX = $x + ([Math]::Cos($angle) * 2)
        $frondZ = $z + ([Math]::Sin($angle) * 2)
        
        Build-ColoredObject -name "${name}_Frond_$i" -type "Cube" `
            -x $frondX -y ($y + $height + 1) -z $frondZ `
            -rx (60) -ry ($i * 45) `
            -sx 0.3 -sy 4 -sz 1.5 `
            -color $colors.PalmLeaf `
            -metallic 0.0 -smoothness 0.1 `
            -parent $parent
        $script:totalObjects++
    }
    
    # Coconut cluster
    Build-ColoredObject -name "${name}_Coconuts" -type "Sphere" `
        -x $x -y ($y + $height - 1) -z $z `
        -sx 1.2 -sy 1.5 -sz 1.2 `
        -color @{ r = 0.4; g = 0.3; b = 0.2 } `
        -metallic 0.0 -smoothness 0.3 `
        -parent $parent
    $script:totalObjects++
}

# ============================================================================
# SECTION 1: DESERT GROUND
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 1: DESERT GROUND ===" -ForegroundColor Magenta

New-Group -name "DesertGround"

# Main sand terrain (massive)
Build-ColoredObject -name "MainSandPlane" -type "Plane" `
    -x 0 -y 0 -z 0 `
    -sx 250 -sy 1 -sz 250 `
    -color $colors.Sand `
    -metallic 0.0 -smoothness 0.1 `
    -parent "DesertGround"
$totalObjects++

# Sand dunes (10 scattered around)
$dunePositions = @(
    @{x = -150; z = -150}, @{x = -150; z = 150}, @{x = 150; z = -150}, @{x = 150; z = 150},
    @{x = -100; z = 0}, @{x = 100; z = 0}, @{x = 0; z = -100}, @{x = 0; z = 100},
    @{x = -120; z = -80}, @{x = 120; z = 80}
)

Write-Host "  [DUNES] Creating sand dunes..." -ForegroundColor Gray
foreach ($dune in $dunePositions) {
    Build-ColoredObject -name "Dune_$($dune.x)_$($dune.z)" -type "Sphere" `
        -x $dune.x -y 2 -z $dune.z `
        -sx 20 -sy 4 -sz 15 `
        -color $colors.SandDark `
        -metallic 0.0 -smoothness 0.1 `
        -parent "DesertGround"
    $totalObjects++
}

Write-Host "[OK] Desert terrain created (2500x2500 units)" -ForegroundColor Green

# ============================================================================
# SECTION 2: GREAT PYRAMIDS
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 2: GREAT PYRAMIDS ===" -ForegroundColor Magenta

New-Group -name "Pyramids"

# Main Great Pyramid (Khufu-inspired) - Northeast
Build-Pyramid -name "GreatPyramid" `
    -x 80 -y 0 -z 80 `
    -baseSize 70 -height 50 `
    -parent "Pyramids" -createInterior $true

# Second Pyramid (Khafre-inspired) - Northwest
Build-Pyramid -name "SecondPyramid" `
    -x -70 -y 0 -z 90 `
    -baseSize 60 -height 43 `
    -parent "Pyramids" -createInterior $true

# Third Pyramid (Menkaure-inspired) - Southeast
Build-Pyramid -name "ThirdPyramid" `
    -x 75 -y 0 -z -75 `
    -baseSize 45 -height 32 `
    -parent "Pyramids" -createInterior $true

# Smaller Queen's Pyramids (3 near the Great Pyramid)
Build-Pyramid -name "QueenPyramid1" `
    -x 120 -y 0 -z 50 `
    -baseSize 20 -height 15 `
    -parent "Pyramids" -createInterior $false

Build-Pyramid -name "QueenPyramid2" `
    -x 130 -y 0 -z 70 `
    -baseSize 20 -height 15 `
    -parent "Pyramids" -createInterior $false

Build-Pyramid -name "QueenPyramid3" `
    -x 140 -y 0 -z 90 `
    -baseSize 20 -height 15 `
    -parent "Pyramids" -createInterior $false

Write-Host "[OK] All pyramids constructed with interiors" -ForegroundColor Green

# ============================================================================
# SECTION 3: THE GREAT SPHINX
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 3: THE GREAT SPHINX ===" -ForegroundColor Magenta

New-Group -name "Sphinx"

$sphinxX = -90
$sphinxZ = 0

# Sphinx body (lion body)
Build-ColoredObject -name "Sphinx_Body" -type "Cube" `
    -x $sphinxX -y 8 -z $sphinxZ `
    -sx 35 -sy 10 -sz 60 `
    -color $colors.Limestone `
    -metallic 0.0 -smoothness 0.2 `
    -parent "Sphinx"
$totalObjects++

# Sphinx head (human head)
Build-ColoredObject -name "Sphinx_Head" -type "Cube" `
    -x ($sphinxX - 5) -y 18 -z ($sphinxZ + 25) `
    -sx 15 -sy 15 -sz 15 `
    -color $colors.Limestone `
    -metallic 0.0 -smoothness 0.2 `
    -parent "Sphinx"
$totalObjects++

# Sphinx nemes (headdress)
Build-ColoredObject -name "Sphinx_Nemes" -type "Cube" `
    -x ($sphinxX - 5) -y 22 -z ($sphinxZ + 25) `
    -sx 18 -sy 8 -sz 18 `
    -color $colors.GoldLeaf `
    -metallic 0.7 -smoothness 0.8 `
    -parent "Sphinx"
$totalObjects++

# Sphinx face details
Build-ColoredObject -name "Sphinx_Nose" -type "Cube" `
    -x ($sphinxX - 12) -y 17 -z ($sphinxZ + 25) `
    -sx 2 -sy 3 -sz 2 `
    -color $colors.Limestone `
    -metallic 0.0 -smoothness 0.2 `
    -parent "Sphinx"
$totalObjects++

# Sphinx eyes (2)
Build-ColoredObject -name "Sphinx_Eye_L" -type "Sphere" `
    -x ($sphinxX - 9) -y 19 -z ($sphinxZ + 28) `
    -sx 1.5 -sy 1.5 -sz 1 `
    -color $colors.DarkStone `
    -metallic 0.0 -smoothness 0.5 `
    -parent "Sphinx"
$totalObjects++

Build-ColoredObject -name "Sphinx_Eye_R" -type "Sphere" `
    -x ($sphinxX - 9) -y 19 -z ($sphinxZ + 22) `
    -sx 1.5 -sy 1.5 -sz 1 `
    -color $colors.DarkStone `
    -metallic 0.0 -smoothness 0.5 `
    -parent "Sphinx"
$totalObjects++

# Sphinx paws (4)
Build-ColoredObject -name "Sphinx_Paw_FL" -type "Cube" `
    -x ($sphinxX - 15) -y 3 -z ($sphinxZ + 25) `
    -sx 8 -sy 6 -sz 10 `
    -color $colors.Limestone `
    -metallic 0.0 -smoothness 0.2 `
    -parent "Sphinx"
$totalObjects++

Build-ColoredObject -name "Sphinx_Paw_FR" -type "Cube" `
    -x ($sphinxX + 5) -y 3 -z ($sphinxZ + 25) `
    -sx 8 -sy 6 -sz 10 `
    -color $colors.Limestone `
    -metallic 0.0 -smoothness 0.2 `
    -parent "Sphinx"
$totalObjects++

Build-ColoredObject -name "Sphinx_Paw_BL" -type "Cube" `
    -x ($sphinxX - 12) -y 3 -z ($sphinxZ - 20) `
    -sx 8 -sy 6 -sz 10 `
    -color $colors.Limestone `
    -metallic 0.0 -smoothness 0.2 `
    -parent "Sphinx"
$totalObjects++

Build-ColoredObject -name "Sphinx_Paw_BR" -type "Cube" `
    -x ($sphinxX + 2) -y 3 -z ($sphinxZ - 20) `
    -sx 8 -sy 6 -sz 10 `
    -color $colors.Limestone `
    -metallic 0.0 -smoothness 0.2 `
    -parent "Sphinx"
$totalObjects++

# Sphinx base platform
Build-ColoredObject -name "Sphinx_Platform" -type "Cube" `
    -x $sphinxX -y 0.5 -z $sphinxZ `
    -sx 45 -sy 1 -sz 70 `
    -color $colors.DarkStone `
    -metallic 0.0 -smoothness 0.3 `
    -parent "Sphinx"
$totalObjects++

Write-Host "[OK] Great Sphinx statue completed" -ForegroundColor Green

# ============================================================================
# SECTION 4: CENTRAL BATTLE ALTAR
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 4: CENTRAL BATTLE ALTAR ===" -ForegroundColor Magenta

New-Group -name "BattleAltar"

# Main altar platform (elevated)
Build-ColoredObject -name "Altar_MainPlatform" -type "Cube" `
    -x 0 -y 3 -z 0 `
    -sx 40 -sy 6 -sz 40 `
    -color $colors.DarkStone `
    -metallic 0.0 -smoothness 0.3 `
    -parent "BattleAltar"
$totalObjects++

# Altar steps (4 sides)
for ($i = 0; $i -lt 4; $i++) {
    $stepY = 1.5 + ($i * 1.5)
    $stepSize = 42 + ($i * 2)
    
    Build-ColoredObject -name "Altar_Step_$i" -type "Cube" `
        -x 0 -y $stepY -z 0 `
        -sx $stepSize -sy 1 -sz $stepSize `
        -color $colors.SandDark `
        -metallic 0.0 -smoothness 0.2 `
        -parent "BattleAltar"
    $totalObjects++
}

# Central altar stone (sacrificial table)
Build-ColoredObject -name "Altar_Stone" -type "Cube" `
    -x 0 -y 7 -z 0 `
    -sx 8 -sy 2 -sz 12 `
    -color $colors.BloodRed `
    -metallic 0.0 -smoothness 0.4 `
    -parent "BattleAltar"
$totalObjects++

# Altar pillars (8 around the platform)
for ($i = 0; $i -lt 8; $i++) {
    $angle = ($i * 45) * [Math]::PI / 180
    $pillarX = [Math]::Cos($angle) * 18
    $pillarZ = [Math]::Sin($angle) * 18
    
    Build-ColoredObject -name "Altar_Pillar_$i" -type "Cylinder" `
        -x $pillarX -y 10 -z $pillarZ `
        -sx 1.5 -sy 10 -sz 1.5 `
        -color $colors.Limestone `
        -metallic 0.0 -smoothness 0.2 `
        -parent "BattleAltar"
    $totalObjects++
    
    # Pillar capital
    Build-ColoredObject -name "Altar_Capital_$i" -type "Cylinder" `
        -x $pillarX -y 20 -z $pillarZ `
        -sx 2 -sy 1 -sz 2 `
        -color $colors.GoldLeaf `
        -metallic 0.7 -smoothness 0.8 `
        -parent "BattleAltar"
    $totalObjects++
    
    # Torch on top of each pillar
    Build-ColoredObject -name "Altar_Torch_$i" -type "Cylinder" `
        -x $pillarX -y 21.5 -z $pillarZ `
        -sx 0.3 -sy 0.5 -sz 0.3 `
        -color @{ r = 0.3; g = 0.2; b = 0.1 } `
        -metallic 0.0 -smoothness 0.1 `
        -parent "BattleAltar"
    $totalObjects++
    
    Build-ColoredObject -name "Altar_Flame_$i" -type "Sphere" `
        -x $pillarX -y 22.5 -z $pillarZ `
        -sx 0.5 -sy 0.7 -sz 0.5 `
        -parent "BattleAltar"
    Set-Material -name "Altar_Flame_$i" -emission $colors.TorchFire
    $totalObjects++
}

# Anubis statues (4 at cardinal directions)
$anubiPositions = @(
    @{x = 0; z = 22; ry = 0},
    @{x = 0; z = -22; ry = 180},
    @{x = 22; z = 0; ry = 270},
    @{x = -22; z = 0; ry = 90}
)

foreach ($pos in $anubiPositions) {
    # Statue base
    Build-ColoredObject -name "Anubis_Base_$($pos.x)_$($pos.z)" -type "Cylinder" `
        -x $pos.x -y 7 -z $pos.z `
        -ry $pos.ry `
        -sx 2 -sy 1 -sz 2 `
        -color $colors.DarkStone `
        -metallic 0.0 -smoothness 0.3 `
        -parent "BattleAltar"
    $totalObjects++
    
    # Anubis body
    Build-ColoredObject -name "Anubis_Body_$($pos.x)_$($pos.z)" -type "Cube" `
        -x $pos.x -y 10 -z $pos.z `
        -ry $pos.ry `
        -sx 2 -sy 5 -sz 1.5 `
        -color $colors.DarkStone `
        -metallic 0.5 -smoothness 0.6 `
        -parent "BattleAltar"
    $totalObjects++
    
    # Anubis head (jackal)
    Build-ColoredObject -name "Anubis_Head_$($pos.x)_$($pos.z)" -type "Cube" `
        -x $pos.x -y 14 -z $pos.z `
        -ry $pos.ry `
        -sx 1.5 -sy 2.5 -sz 2 `
        -color $colors.DarkStone `
        -metallic 0.5 -smoothness 0.6 `
        -parent "BattleAltar"
    $totalObjects++
    
    # Golden staff
    Build-ColoredObject -name "Anubis_Staff_$($pos.x)_$($pos.z)" -type "Cylinder" `
        -x $pos.x -y 11 -z ($pos.z - 1.5) `
        -ry $pos.ry `
        -sx 0.2 -sy 4 -sz 0.2 `
        -color $colors.GoldLeaf `
        -metallic 0.9 -smoothness 0.95 `
        -parent "BattleAltar"
    $totalObjects++
}

Write-Host "[OK] Battle Altar with statues completed" -ForegroundColor Green

# ============================================================================
# SECTION 5: OBELISKS
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 5: OBELISKS ===" -ForegroundColor Magenta

New-Group -name "Obelisks"

# Major obelisks at key locations (6 total)
$obeliskPositions = @(
    @{x = 50; z = 0; name = "East"},
    @{x = -50; z = 0; name = "West"},
    @{x = 0; z = 50; name = "North"},
    @{x = 0; z = -50; name = "South"},
    @{x = -120; z = 120; name = "NorthWest"},
    @{x = 120; z = -120; name = "SouthEast"}
)

foreach ($pos in $obeliskPositions) {
    Write-Host "  [OBELISK] Building $($pos.name) Obelisk..." -ForegroundColor Gray
    Build-Obelisk -name "Obelisk_$($pos.name)" `
        -x $pos.x -y 0 -z $pos.z `
        -height 25 `
        -parent "Obelisks"
}

Write-Host "[OK] All obelisks erected" -ForegroundColor Green

# ============================================================================
# SECTION 6: PALM TREES
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 6: PALM TREES ===" -ForegroundColor Magenta

New-Group -name "PalmTrees"

# Palm tree groves (25 trees scattered around)
$palmPositions = @(
    # Oasis near Sphinx
    @{x = -110; z = -30}, @{x = -105; z = -25}, @{x = -115; z = -28},
    @{x = -108; z = -35}, @{x = -112; z = -22},
    # Near Great Pyramid
    @{x = 100; z = 110}, @{x = 95; z = 105}, @{x = 105; z = 108},
    # Near Battle Altar
    @{x = 30; z = 35}, @{x = -30; z = 35}, @{x = 30; z = -35}, @{x = -30; z = -35},
    # Scattered around map
    @{x = -140; z = 60}, @{x = 140; z = -60}, @{x = -70; z = -100},
    @{x = 70; z = 100}, @{x = -150; z = -100}, @{x = 150; z = 100},
    # Additional scattered palms
    @{x = -50; z = 80}, @{x = 50; z = -80}, @{x = -90; z = -70},
    @{x = 90; z = 70}, @{x = -130; z = 30}, @{x = 130; z = -30},
    @{x = -60; z = -130}, @{x = 60; z = 130}
)

Write-Host "  [PALMS] Planting palm tree groves..." -ForegroundColor Gray
foreach ($palm in $palmPositions) {
    Build-PalmTree -name "Palm_$($palm.x)_$($palm.z)" `
        -x $palm.x -y 0 -z $palm.z `
        -height 12 `
        -parent "PalmTrees"
}

Write-Host "[OK] Palm trees planted (25 trees)" -ForegroundColor Green

# ============================================================================
# SECTION 7: STONE PATHWAYS
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 7: STONE PATHWAYS ===" -ForegroundColor Magenta

New-Group -name "StonePaths"

# Main paths connecting key structures
function Build-StonePath {
    param(
        [float]$x1, [float]$z1,
        [float]$x2, [float]$z2,
        [string]$pathName
    )
    
    $segments = 20
    for ($i = 0; $i -lt $segments; $i++) {
        $t = $i / $segments
        $x = $x1 + ($x2 - $x1) * $t
        $z = $z1 + ($z2 - $z1) * $t
        
        Build-ColoredObject -name "${pathName}_Segment_$i" -type "Cube" `
            -x $x -y 0.2 -z $z `
            -sx 5 -sy 0.3 -sz 5 `
            -color $colors.DarkStone `
            -metallic 0.0 -smoothness 0.4 `
            -parent "StonePaths"
        $script:totalObjects++
    }
}

# Paths from altar to major structures
Write-Host "  [PATHS] Creating stone pathways..." -ForegroundColor Gray
Build-StonePath -x1 0 -z1 0 -x2 80 -z2 80 -pathName "Path_ToGreatPyramid"
Build-StonePath -x1 0 -z1 0 -x2 -70 -z2 90 -pathName "Path_ToSecondPyramid"
Build-StonePath -x1 0 -z1 0 -x2 75 -z2 -75 -pathName "Path_ToThirdPyramid"
Build-StonePath -x1 0 -z1 0 -x2 -90 -z2 0 -pathName "Path_ToSphinx"

Write-Host "[OK] Stone pathways constructed" -ForegroundColor Green

# ============================================================================
# SECTION 8: DECORATIVE ELEMENTS
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 8: DECORATIVE ELEMENTS ===" -ForegroundColor Magenta

New-Group -name "Decorations"

# Stone pillars around pyramids (12 total)
$pillarPositions = @(
    @{x = 110; z = 110}, @{x = 50; z = 110}, @{x = 110; z = 50},
    @{x = -100; z = 120}, @{x = -40; z = 120}, @{x = -100; z = 60},
    @{x = 105; z = -105}, @{x = 45; z = -105}, @{x = 105; z = -45},
    @{x = -60; z = -60}, @{x = 60; z = 60}, @{x = -100; z = 100}
)

Write-Host "  [PILLARS] Adding decorative stone pillars..." -ForegroundColor Gray
foreach ($pos in $pillarPositions) {
    Build-ColoredObject -name "DecorPillar_$($pos.x)_$($pos.z)" -type "Cylinder" `
        -x $pos.x -y 5 -z $pos.z `
        -sx 1 -sy 5 -sz 1 `
        -color $colors.Limestone `
        -metallic 0.0 -smoothness 0.2 `
        -parent "Decorations"
    $totalObjects++
    
    # Capital
    Build-ColoredObject -name "DecorCapital_$($pos.x)_$($pos.z)" -type "Cylinder" `
        -x $pos.x -y 10.5 -z $pos.z `
        -sx 1.4 -sy 0.5 -sz 1.4 `
        -color $colors.GoldLeaf `
        -metallic 0.6 -smoothness 0.7 `
        -parent "Decorations"
    $totalObjects++
}

# Stone blocks scattered (debris/construction)
$blockPositions = @(
    @{x = 30; z = 60}, @{x = -30; z = 60}, @{x = 60; z = 30},
    @{x = -60; z = -30}, @{x = 90; z = -30}, @{x = -30; z = 90}
)

Write-Host "  [BLOCKS] Placing stone blocks..." -ForegroundColor Gray
foreach ($pos in $blockPositions) {
    Build-ColoredObject -name "StoneBlock_$($pos.x)_$($pos.z)" -type "Cube" `
        -x $pos.x -y 1 -z $pos.z `
        -rx (Get-Random -Minimum -5 -Maximum 5) `
        -ry (Get-Random -Minimum 0 -Maximum 360) `
        -sx 3 -sy 2 -sz 4 `
        -color $colors.Limestone `
        -metallic 0.0 -smoothness 0.2 `
        -parent "Decorations"
    $totalObjects++
}

# Pottery and urns near structures (16 scattered)
$potPositions = @(
    @{x = 75; z = 110}, @{x = 85; z = 108}, @{x = 78; z = 105},
    @{x = -65; z = 115}, @{x = -75; z = 118}, @{x = -68; z = 112},
    @{x = 80; z = -70}, @{x = 70; z = -80}, @{x = 73; z = -73},
    @{x = -95; z = 5}, @{x = -85; z = -5}, @{x = -90; z = 8},
    @{x = 25; z = 25}, @{x = -25; z = 25}, @{x = 25; z = -25}, @{x = -25; z = -25}
)

Write-Host "  [POTTERY] Adding pottery and urns..." -ForegroundColor Gray
foreach ($pos in $potPositions) {
    Build-ColoredObject -name "Pottery_$($pos.x)_$($pos.z)" -type "Cylinder" `
        -x $pos.x -y 0.8 -z $pos.z `
        -sx 0.6 -sy 0.8 -sz 0.6 `
        -color @{ r = 0.5; g = 0.3; b = 0.2 } `
        -metallic 0.0 -smoothness 0.3 `
        -parent "Decorations"
    $totalObjects++
}

Write-Host "[OK] Decorative elements placed" -ForegroundColor Green

# ============================================================================
# SECTION 9: LIGHTING SYSTEM
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 9: TORCH LIGHTING ===" -ForegroundColor Magenta

New-Group -name "TorchLights"

# Large torch stands at strategic locations (8 around map)
$torchStandPositions = @(
    @{x = 40; z = 40}, @{x = -40; z = 40}, @{x = 40; z = -40}, @{x = -40; z = -40},
    @{x = 80; z = 0}, @{x = -80; z = 0}, @{x = 0; z = 80}, @{x = 0; z = -80}
)

Write-Host "  [TORCHES] Setting up torch lighting..." -ForegroundColor Gray
foreach ($pos in $torchStandPositions) {
    # Torch stand
    Build-ColoredObject -name "TorchStand_$($pos.x)_$($pos.z)" -type "Cylinder" `
        -x $pos.x -y 4 -z $pos.z `
        -sx 0.4 -sy 4 -sz 0.4 `
        -color @{ r = 0.3; g = 0.2; b = 0.1 } `
        -metallic 0.0 -smoothness 0.1 `
        -parent "TorchLights"
    $totalObjects++
    
    # Torch basket
    Build-ColoredObject -name "TorchBasket_$($pos.x)_$($pos.z)" -type "Cylinder" `
        -x $pos.x -y 8.5 -z $pos.z `
        -sx 0.8 -sy 0.5 -sz 0.8 `
        -color $colors.DarkStone `
        -metallic 0.2 -smoothness 0.2 `
        -parent "TorchLights"
    $totalObjects++
    
    # Large flame
    Build-ColoredObject -name "TorchFlame_$($pos.x)_$($pos.z)" -type "Sphere" `
        -x $pos.x -y 9.5 -z $pos.z `
        -sx 1.2 -sy 1.6 -sz 1.2 `
        -parent "TorchLights"
    Set-Material -name "TorchFlame_$($pos.x)_$($pos.z)" -emission $colors.TorchFire
    $totalObjects++
}

Write-Host "[OK] Torch lighting system complete" -ForegroundColor Green

# ============================================================================
# FINAL STATISTICS
# ============================================================================
Write-Host ""
Write-Host "========================================================================" -ForegroundColor Yellow
Write-Host "  EGYPTIAN PYRAMID WORLD - CONSTRUCTION COMPLETE!" -ForegroundColor Yellow
Write-Host "========================================================================" -ForegroundColor Yellow
Write-Host ""

$endTime = Get-Date
$duration = ($endTime - $startTime).TotalSeconds

Write-Host "CONSTRUCTION STATISTICS:" -ForegroundColor Cyan
Write-Host "  Total Objects Created: $totalObjects" -ForegroundColor White
Write-Host "  Construction Time: $([Math]::Round($duration, 2)) seconds" -ForegroundColor White
Write-Host "  Objects per Second: $([Math]::Round($totalObjects / $duration, 2))" -ForegroundColor White
Write-Host ""

Write-Host "WORLD FEATURES:" -ForegroundColor Cyan
Write-Host "  - 6 Pyramids (3 Great + 3 Queen's)" -ForegroundColor Green
Write-Host "  - 3 Full Pyramid Interiors (corridors, chambers, treasures)" -ForegroundColor Green
Write-Host "  - Great Sphinx Statue (visible from distance)" -ForegroundColor Green
Write-Host "  - Central Battle Altar with Anubis statues" -ForegroundColor Green
Write-Host "  - 6 Obelisks with golden pyramidions" -ForegroundColor Green
Write-Host "  - 25 Palm Trees" -ForegroundColor Green
Write-Host "  - Stone pathways connecting structures" -ForegroundColor Green
Write-Host "  - Decorative pillars, blocks, and pottery" -ForegroundColor Green
Write-Host "  - Torch lighting system" -ForegroundColor Green
Write-Host "  - Sand desert biome (2500x2500 units)" -ForegroundColor Green
Write-Host ""

Write-Host "GAMEPLAY ELEMENTS:" -ForegroundColor Cyan
Write-Host "  - Enterable pyramids with treasure chambers" -ForegroundColor Yellow
Write-Host "  - Hidden sarcophagi and treasure chests" -ForegroundColor Yellow
Write-Host "  - Battle arena in center (Altar platform)" -ForegroundColor Yellow
Write-Host "  - Atmospheric torch lighting throughout" -ForegroundColor Yellow
Write-Host "  - Hieroglyphic decorations" -ForegroundColor Yellow
Write-Host ""

Write-Host "OPTIMIZATION RECOMMENDATIONS:" -ForegroundColor Magenta
Write-Host "  Consider using mesh optimization for static elements:" -ForegroundColor Gray
Write-Host "  Optimize-Group -parentName 'DesertGround'" -ForegroundColor DarkGray
Write-Host "  Optimize-Group -parentName 'StonePaths'" -ForegroundColor DarkGray
Write-Host "  Optimize-Group -parentName 'Decorations'" -ForegroundColor DarkGray
Write-Host ""

Write-Host "[DONE] Your Egyptian Pyramid World awaits exploration!" -ForegroundColor Yellow
Write-Host ""
