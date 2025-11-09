# ============================================================================
# ULTIMATE SPACE ROCK PLATFORMS - THE GEM OF THE PROJECT
# Three Elemental Battle Arenas on Comet-Like Asteroids
# Designed for aerial combat with flying skull enemies
# ============================================================================

. ".\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  ULTIMATE SPACE ROCK PLATFORMS" -ForegroundColor Cyan
Write-Host "  The Gem of the Project - Where Legends Are Made" -ForegroundColor Cyan
Write-Host "  3 Elemental Battle Arenas: Normal | Fire | Ice" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

# Test connection
try {
    $null = Invoke-RestMethod -Uri "http://localhost:8765/ping" -Method POST -ContentType "application/json" -Body '{}' -UseBasicParsing -ErrorAction Stop
    Write-Host "[OK] Unity MCP server connected" -ForegroundColor Green
} catch {
    Write-Host "[FATAL] Unity MCP server not running!" -ForegroundColor Red
    Write-Host "Please start Unity and ensure the MCP server is active" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[CLEANUP] Clearing old platforms..." -ForegroundColor Yellow

# Delete old platforms if they exist
$groupsToDelete = @(
    "SpaceRockPlatforms", "NormalPlatform", "FirePlatform", "IcePlatform",
    "NormalTower", "FireTower", "IceTower"
)

foreach ($group in $groupsToDelete) {
    try {
        $null = Invoke-RestMethod -Uri "$UNITY_BASE/deleteGameObject" `
            -Method POST -ContentType "application/json" `
            -Body (@{ name = $group } | ConvertTo-Json) -UseBasicParsing
        Write-Host "  [DELETED] $group" -ForegroundColor DarkGray
    } catch {
        Write-Host "  [SKIP] $group (not found)" -ForegroundColor DarkGray
    }
}

Write-Host "[OK] Scene cleared" -ForegroundColor Green
Write-Host ""

$totalObjects = 0
$startTime = Get-Date

# ============================================================================
# HELPER FUNCTIONS FOR SPACE ROCK PLATFORMS
# ============================================================================

function Build-CometBase {
    param(
        [string]$name,
        [float]$centerX, [float]$centerY, [float]$centerZ,
        [float]$size = 40,
        [hashtable]$primaryColor,
        [hashtable]$accentColor = $null,
        [string]$parent
    )
    
    Write-Host "  [COMET BASE] Building $name asteroid base..." -ForegroundColor Gray
    
    # Create main irregular rocky base (multiple spheres)
    $baseGroup = "${name}_Base"
    New-Group -name $baseGroup -parent $parent
    
    # Central core (largest sphere)
    Build-ColoredObject -name "${name}_Core" -type "Sphere" `
        -x $centerX -y $centerY -z $centerZ `
        -sx $size -sy ($size * 0.8) -sz $size `
        -color $primaryColor `
        -metallic 0.2 -smoothness 0.3 `
        -parent $baseGroup
    $script:totalObjects++
    
    # 8 rocky protrusions for irregular comet shape
    $angles = @(0, 45, 90, 135, 180, 225, 270, 315)
    foreach ($angle in $angles) {
        $rad = $angle * [Math]::PI / 180
        $distance = $size * 0.5
        $offsetX = [Math]::Cos($rad) * $distance
        $offsetZ = [Math]::Sin($rad) * $distance
        $rockSize = $size * (0.3 + (Get-Random -Minimum 0 -Maximum 20) / 100)
        
        Build-ColoredObject -name "${name}_Rock_$angle" -type "Sphere" `
            -x ($centerX + $offsetX) -y ($centerY + (Get-Random -Minimum -5 -Maximum 5)) -z ($centerZ + $offsetZ) `
            -sx $rockSize -sy ($rockSize * 0.9) -sz $rockSize `
            -color $primaryColor `
            -metallic 0.15 -smoothness 0.25 `
            -parent $baseGroup
        $script:totalObjects++
    }
    
    # 12 smaller debris pieces around the platform
    for ($i = 0; $i -lt 12; $i++) {
        $angle = ($i * 30) * [Math]::PI / 180
        $distance = $size * (0.8 + (Get-Random -Minimum 0 -Maximum 30) / 100)
        $offsetX = [Math]::Cos($angle) * $distance
        $offsetZ = [Math]::Sin($angle) * $distance
        $debrisSize = $size * (0.1 + (Get-Random -Minimum 0 -Maximum 15) / 100)
        
        Build-ColoredObject -name "${name}_Debris_$i" -type "Sphere" `
            -x ($centerX + $offsetX) -y ($centerY + (Get-Random -Minimum -3 -Maximum 8)) -z ($centerZ + $offsetZ) `
            -sx $debrisSize -sy ($debrisSize * 0.8) -sz $debrisSize `
            -color $primaryColor `
            -metallic 0.1 -smoothness 0.2 `
            -parent $baseGroup
        $script:totalObjects++
    }
    
    # Flat battle platform on top
    Build-ColoredObject -name "${name}_BattlePlatform" -type "Cylinder" `
        -x $centerX -y ($centerY + $size * 0.4) -z $centerZ `
        -sx ($size * 0.7) -sy 1 -sz ($size * 0.7) `
        -color $primaryColor `
        -metallic 0.3 -smoothness 0.4 `
        -parent $baseGroup
    $script:totalObjects++
    
    # Add accent glowing crystals if accent color provided
    if ($accentColor) {
        for ($i = 0; $i -lt 6; $i++) {
            $angle = ($i * 60) * [Math]::PI / 180
            $distance = $size * 0.3
            $offsetX = [Math]::Cos($angle) * $distance
            $offsetZ = [Math]::Sin($angle) * $distance
            
            Build-ColoredObject -name "${name}_Crystal_$i" -type "Sphere" `
                -x ($centerX + $offsetX) -y ($centerY + $size * 0.4) -z ($centerZ + $offsetZ) `
                -sx 2 -sy 4 -sz 2 `
                -color $accentColor `
                -metallic 0.8 -smoothness 0.9 `
                -parent $baseGroup
            
            Set-Material -name "${name}_Crystal_$i" `
                -emission @{ r = $accentColor.r; g = $accentColor.g; b = $accentColor.b; intensity = 2.0 }
            $script:totalObjects++
        }
    }
    
    Write-Host "  [OK] $name base complete: 27+ objects" -ForegroundColor Green
}

function Build-EvilTower {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [float]$height = 25,
        [hashtable]$towerColor,
        [hashtable]$gemColor,
        [string]$parent
    )
    
    Write-Host "  [EVIL TOWER] Building $name tower with gem..." -ForegroundColor Gray
    
    $towerGroup = "${name}_Tower"
    New-Group -name $towerGroup -parent $parent
    
    # Tower base (wider foundation)
    Build-ColoredObject -name "${name}_Base" -type "Cube" `
        -x $x -y $y -z $z `
        -sx 8 -sy 3 -sz 8 `
        -color $towerColor `
        -metallic 0.5 -smoothness 0.6 `
        -parent $towerGroup
    $script:totalObjects++
    
    # Main tower shaft (tapered)
    $towerY = $y + 1.5
    for ($i = 0; $i -lt 5; $i++) {
        $segmentHeight = $height / 5
        $segmentY = $towerY + ($i * $segmentHeight) + ($segmentHeight / 2)
        $taper = 1 - ($i * 0.12)
        $segmentWidth = 6 * $taper
        
        Build-ColoredObject -name "${name}_Segment_$i" -type "Cube" `
            -x $x -y $segmentY -z $z `
            -sx $segmentWidth -sy $segmentHeight -sz $segmentWidth `
            -color $towerColor `
            -metallic 0.5 -smoothness 0.6 `
            -parent $towerGroup
        $script:totalObjects++
        
        # Add dark detail bands
        if ($i % 2 -eq 0) {
            Build-ColoredObject -name "${name}_Band_$i" -type "Cube" `
                -x $x -y ($segmentY + $segmentHeight/2) -z $z `
                -sx ($segmentWidth + 0.3) -sy 0.5 -sz ($segmentWidth + 0.3) `
                -color @{ r = 0.1; g = 0.1; b = 0.1 } `
                -metallic 0.7 -smoothness 0.8 `
                -parent $towerGroup
            $script:totalObjects++
        }
    }
    
    # Tower top platform
    $topY = $towerY + $height
    Build-ColoredObject -name "${name}_TopPlatform" -type "Cylinder" `
        -x $x -y $topY -z $z `
        -sx 5 -sy 0.5 -sz 5 `
        -color $towerColor `
        -metallic 0.6 -smoothness 0.7 `
        -parent $towerGroup
    $script:totalObjects++
    
    # 4 Corner spikes on top
    $spikePositions = @(
        @{x = 2; z = 2}, @{x = -2; z = 2},
        @{x = 2; z = -2}, @{x = -2; z = -2}
    )
    foreach ($spike in $spikePositions) {
        Build-ColoredObject -name "${name}_Spike_$($spike.x)_$($spike.z)" -type "Cube" `
            -x ($x + $spike.x) -y ($topY + 2) -z ($z + $spike.z) `
            -sx 0.5 -sy 4 -sz 0.5 `
            -color @{ r = 0.1; g = 0.1; b = 0.1 } `
            -metallic 0.8 -smoothness 0.9 `
            -parent $towerGroup
        $script:totalObjects++
    }
    
    # LEGENDARY GEM (DIAMOND) - The Prize!
    Build-ColoredObject -name "${name}_GEM_DIAMOND" -type "Sphere" `
        -x $x -y ($topY + 4) -z $z `
        -sx 3 -sy 4 -sz 3 `
        -color $gemColor `
        -metallic 0.95 -smoothness 0.98 `
        -parent $towerGroup
    
    # Extreme emission for the gem
    Set-Material -name "${name}_GEM_DIAMOND" `
        -emission @{ r = $gemColor.r; g = $gemColor.g; b = $gemColor.b; intensity = 5.0 }
    $script:totalObjects++
    
    # Gem support prongs (4 prongs holding the diamond)
    for ($i = 0; $i -lt 4; $i++) {
        $angle = ($i * 90) * [Math]::PI / 180
        $prongX = [Math]::Cos($angle) * 1.8
        $prongZ = [Math]::Sin($angle) * 1.8
        
        Build-ColoredObject -name "${name}_GemProng_$i" -type "Cylinder" `
            -x ($x + $prongX) -y ($topY + 2.5) -z ($z + $prongZ) `
            -rx (25 * [Math]::Cos($angle)) -rz (25 * [Math]::Sin($angle)) `
            -sx 0.3 -sy 2 -sz 0.3 `
            -color @{ r = 0.8; g = 0.7; b = 0.2 } `
            -metallic 0.9 -smoothness 0.85 `
            -parent $towerGroup
        $script:totalObjects++
    }
    
    # Rotating energy rings around gem
    for ($i = 0; $i -lt 3; $i++) {
        $ringY = ($topY + 4) + (($i - 1) * 1.5)
        $ringSize = 5 + ($i * 0.5)
        
        Build-ColoredObject -name "${name}_GemRing_$i" -type "Cylinder" `
            -x $x -y $ringY -z $z `
            -rx 90 `
            -sx $ringSize -sy 0.1 -sz $ringSize `
            -color $gemColor `
            -metallic 0.9 -smoothness 0.95 `
            -parent $towerGroup
        
        Set-Material -name "${name}_GemRing_$i" `
            -emission @{ r = $gemColor.r; g = $gemColor.g; b = $gemColor.b; intensity = 3.0 }
        $script:totalObjects++
    }
    
    Write-Host "  [OK] $name tower complete: 25+ objects" -ForegroundColor Green
}

# ============================================================================
# MAIN SCENE - MASTER ROOT GROUP
# ============================================================================

Write-Host ""
Write-Host "=== CREATING MASTER SCENE GROUP ===" -ForegroundColor Magenta

New-Group -name "SpaceRockPlatforms"

# ============================================================================
# PLATFORM 1: NORMAL SKULL TOWER PLATFORM
# Classic gray asteroid with neutral purple gem
# ============================================================================

Write-Host ""
Write-Host "=== PLATFORM 1: NORMAL SKULL TOWER PLATFORM ===" -ForegroundColor Magenta
Write-Host "Position: Center-Left | Theme: Classic Asteroid" -ForegroundColor Gray

New-Group -name "NormalPlatform" -parent "SpaceRockPlatforms"

# Normal platform at (-80, 50, 0)
Build-CometBase -name "Normal" `
    -centerX -80 -centerY 50 -centerZ 0 `
    -size 40 `
    -primaryColor @{ r = 0.45; g = 0.45; b = 0.48 } `
    -accentColor @{ r = 0.6; g = 0.5; b = 0.65 } `
    -parent "NormalPlatform"

# Build evil tower with purple gem
Build-EvilTower -name "Normal" `
    -x -80 -y 66 -z 0 `
    -height 25 `
    -towerColor @{ r = 0.35; g = 0.32; b = 0.38 } `
    -gemColor @{ r = 0.7; g = 0.3; b = 0.9 } `
    -parent "NormalPlatform"

# Add skull decorations (8 skulls around platform)
Write-Host "  [SKULLS] Adding decorative skull markers..." -ForegroundColor Gray
for ($i = 0; $i -lt 8; $i++) {
    $angle = ($i * 45) * [Math]::PI / 180
    $skullX = -80 + ([Math]::Cos($angle) * 25)
    $skullZ = ([Math]::Sin($angle) * 25)
    
    # Skull head (sphere)
    Build-ColoredObject -name "Normal_Skull_$i" -type "Sphere" `
        -x $skullX -y 68 -z $skullZ `
        -sx 2 -sy 2.5 -sz 2 `
        -color @{ r = 0.85; g = 0.85; b = 0.8 } `
        -metallic 0.2 -smoothness 0.3 `
        -parent "NormalPlatform"
    $totalObjects++
    
    # Skull eye glow (small spheres)
    Build-ColoredObject -name "Normal_Skull_Eye_$i" -type "Sphere" `
        -x $skullX -y 68.5 -z $skullZ `
        -sx 0.3 -sy 0.3 -sz 0.3 `
        -color @{ r = 1.0; g = 0.2; b = 0.2 } `
        -metallic 0.9 -smoothness 0.95 `
        -parent "NormalPlatform"
    
    Set-Material -name "Normal_Skull_Eye_$i" `
        -emission @{ r = 1.0; g = 0.2; b = 0.2; intensity = 4.0 }
    $totalObjects++
}

Write-Host "[OK] Normal Skull Tower Platform Complete!" -ForegroundColor Green

# ============================================================================
# PLATFORM 2: FIRE TYPE PLATFORM
# Red/orange volcanic asteroid with fiery red gem
# ============================================================================

Write-Host ""
Write-Host "=== PLATFORM 2: FIRE TYPE PLATFORM ===" -ForegroundColor Magenta
Write-Host "Position: Center | Theme: Volcanic Inferno" -ForegroundColor Gray

New-Group -name "FirePlatform" -parent "SpaceRockPlatforms"

# Fire platform at (0, 50, 0) - center position
Build-CometBase -name "Fire" `
    -centerX 0 -centerY 50 -centerZ 0 `
    -size 42 `
    -primaryColor @{ r = 0.55; g = 0.18; b = 0.12 } `
    -accentColor @{ r = 1.0; g = 0.3; b = 0.1 } `
    -parent "FirePlatform"

# Build evil tower with fiery gem
Build-EvilTower -name "Fire" `
    -x 0 -y 66 -z 0 `
    -height 28 `
    -towerColor @{ r = 0.3; g = 0.08; b = 0.05 } `
    -gemColor @{ r = 1.0; g = 0.25; b = 0.1 } `
    -parent "FirePlatform"

# Add lava veins (glowing cracks)
Write-Host "  [LAVA VEINS] Adding volcanic features..." -ForegroundColor Gray
for ($i = 0; $i -lt 12; $i++) {
    $angle = ($i * 30) * [Math]::PI / 180
    $veinX = ([Math]::Cos($angle) * 22)
    $veinZ = ([Math]::Sin($angle) * 22)
    
    Build-ColoredObject -name "Fire_LavaVein_$i" -type "Cube" `
        -x $veinX -y 67 -z $veinZ `
        -ry ($i * 30) `
        -sx 2 -sy 0.3 -sz 8 `
        -color @{ r = 1.0; g = 0.4; b = 0.1 } `
        -metallic 0.8 -smoothness 0.9 `
        -parent "FirePlatform"
    
    Set-Material -name "Fire_LavaVein_$i" `
        -emission @{ r = 1.0; g = 0.35; b = 0.05; intensity = 3.5 }
    $totalObjects++
}

# Fire pillars (4 corners)
Write-Host "  [FIRE PILLARS] Adding corner flame effects..." -ForegroundColor Gray
$firePillars = @(
    @{x = 22; z = 22}, @{x = -22; z = 22},
    @{x = 22; z = -22}, @{x = -22; z = -22}
)
foreach ($pillar in $firePillars) {
    # Pillar base
    Build-ColoredObject -name "Fire_Pillar_$($pillar.x)_$($pillar.z)" -type "Cylinder" `
        -x $pillar.x -y 70 -z $pillar.z `
        -sx 2 -sy 8 -sz 2 `
        -color @{ r = 0.4; g = 0.12; b = 0.08 } `
        -metallic 0.6 -smoothness 0.7 `
        -parent "FirePlatform"
    $totalObjects++
    
    # Flame effect on top
    Build-ColoredObject -name "Fire_Flame_$($pillar.x)_$($pillar.z)" -type "Sphere" `
        -x $pillar.x -y 78 -z $pillar.z `
        -sx 3 -sy 5 -sz 3 `
        -color @{ r = 1.0; g = 0.5; b = 0.1 } `
        -metallic 0.9 -smoothness 0.95 `
        -parent "FirePlatform"
    
    Set-Material -name "Fire_Flame_$($pillar.x)_$($pillar.z)" `
        -emission @{ r = 1.0; g = 0.4; b = 0.05; intensity = 4.5 }
    $totalObjects++
}

Write-Host "[OK] Fire Type Platform Complete!" -ForegroundColor Green

# ============================================================================
# PLATFORM 3: ICE TYPE PLATFORM
# Blue/white frozen asteroid with icy cyan gem
# ============================================================================

Write-Host ""
Write-Host "=== PLATFORM 3: ICE TYPE PLATFORM ===" -ForegroundColor Magenta
Write-Host "Position: Center-Right | Theme: Frozen Wasteland" -ForegroundColor Gray

New-Group -name "IcePlatform" -parent "SpaceRockPlatforms"

# Ice platform at (80, 50, 0)
Build-CometBase -name "Ice" `
    -centerX 80 -centerY 50 -centerZ 0 `
    -size 40 `
    -primaryColor @{ r = 0.75; g = 0.85; b = 0.95 } `
    -accentColor @{ r = 0.4; g = 0.8; b = 1.0 } `
    -parent "IcePlatform"

# Build evil tower with icy gem
Build-EvilTower -name "Ice" `
    -x 80 -y 66 -z 0 `
    -height 25 `
    -towerColor @{ r = 0.5; g = 0.6; b = 0.75 } `
    -gemColor @{ r = 0.3; g = 0.85; b = 1.0 } `
    -parent "IcePlatform"

# Add ice crystals (sharp spikes)
Write-Host "  [ICE CRYSTALS] Adding frozen formations..." -ForegroundColor Gray
for ($i = 0; $i -lt 16; $i++) {
    $angle = ($i * 22.5) * [Math]::PI / 180
    $crystalX = 80 + ([Math]::Cos($angle) * 24)
    $crystalZ = ([Math]::Sin($angle) * 24)
    $crystalHeight = 3 + (Get-Random -Minimum 0 -Maximum 4)
    
    Build-ColoredObject -name "Ice_Crystal_$i" -type "Cube" `
        -x $crystalX -y (67 + $crystalHeight/2) -z $crystalZ `
        -rx (Get-Random -Minimum -15 -Maximum 15) `
        -ry (Get-Random -Minimum 0 -Maximum 360) `
        -rz (Get-Random -Minimum -15 -Maximum 15) `
        -sx 1.2 -sy $crystalHeight -sz 1.2 `
        -color @{ r = 0.7; g = 0.9; b = 1.0 } `
        -metallic 0.85 -smoothness 0.95 `
        -parent "IcePlatform"
    
    Set-Material -name "Ice_Crystal_$i" `
        -emission @{ r = 0.5; g = 0.9; b = 1.0; intensity = 2.0 }
    $totalObjects++
}

# Frozen mist effect (floating ice particles)
Write-Host "  [FROZEN MIST] Adding atmospheric ice particles..." -ForegroundColor Gray
for ($i = 0; $i -lt 12; $i++) {
    $mistX = 80 + (Get-Random -Minimum -20 -Maximum 20)
    $mistY = 60 + (Get-Random -Minimum 0 -Maximum 15)
    $mistZ = (Get-Random -Minimum -20 -Maximum 20)
    
    Build-ColoredObject -name "Ice_Mist_$i" -type "Sphere" `
        -x $mistX -y $mistY -z $mistZ `
        -sx 1.5 -sy 1.5 -sz 1.5 `
        -color @{ r = 0.85; g = 0.95; b = 1.0 } `
        -metallic 0.9 -smoothness 0.98 `
        -parent "IcePlatform"
    
    Set-Material -name "Ice_Mist_$i" `
        -emission @{ r = 0.7; g = 0.9; b = 1.0; intensity = 1.5 }
    $totalObjects++
}

# Ice stalactites hanging (4 positions)
Write-Host "  [STALACTITES] Adding hanging ice formations..." -ForegroundColor Gray
$stalactitePositions = @(
    @{x = 85; z = 8}, @{x = 75; z = 8},
    @{x = 85; z = -8}, @{x = 75; z = -8}
)
foreach ($pos in $stalactitePositions) {
    Build-ColoredObject -name "Ice_Stalactite_$($pos.x)_$($pos.z)" -type "Cube" `
        -x $pos.x -y 75 -z $pos.z `
        -sx 1 -sy 8 -sz 1 `
        -color @{ r = 0.65; g = 0.85; b = 0.98 } `
        -metallic 0.9 -smoothness 0.95 `
        -parent "IcePlatform"
    $totalObjects++
}

Write-Host "[OK] Ice Type Platform Complete!" -ForegroundColor Green

# ============================================================================
# AMBIENT SPACE ENVIRONMENT
# ============================================================================

Write-Host ""
Write-Host "=== ADDING SPACE ENVIRONMENT ===" -ForegroundColor Magenta

New-Group -name "SpaceEnvironment" -parent "SpaceRockPlatforms"

# Distant stars/lights
Write-Host "  [STARS] Adding distant stellar objects..." -ForegroundColor Gray
for ($i = 0; $i -lt 20; $i++) {
    $starX = Get-Random -Minimum -200 -Maximum 200
    $starY = Get-Random -Minimum 20 -Maximum 120
    $starZ = Get-Random -Minimum -150 -Maximum 150
    
    # Skip if too close to platforms
    $nearPlatform = $false
    if ([Math]::Abs($starX + 80) -lt 50 -or [Math]::Abs($starX) -lt 50 -or [Math]::Abs($starX - 80) -lt 50) {
        if ([Math]::Abs($starZ) -lt 50) {
            $nearPlatform = $true
        }
    }
    
    if (-not $nearPlatform) {
        $starColor = @(
            @{ r = 1.0; g = 1.0; b = 0.9 },
            @{ r = 0.9; g = 0.95; b = 1.0 },
            @{ r = 1.0; g = 0.9; b = 0.8 }
        )[(Get-Random -Minimum 0 -Maximum 3)]
        
        Build-ColoredObject -name "Star_$i" -type "Sphere" `
            -x $starX -y $starY -z $starZ `
            -sx 1.5 -sy 1.5 -sz 1.5 `
            -color $starColor `
            -metallic 0.95 -smoothness 0.98 `
            -parent "SpaceEnvironment"
        
        Set-Material -name "Star_$i" `
            -emission @{ r = $starColor.r; g = $starColor.g; b = $starColor.b; intensity = 3.0 }
        $totalObjects++
    }
}

Write-Host "[OK] Space Environment Complete!" -ForegroundColor Green

# ============================================================================
# COMPLETION SUMMARY
# ============================================================================

$endTime = Get-Date
$duration = ($endTime - $startTime).TotalSeconds

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  ULTIMATE SPACE ROCK PLATFORMS - COMPLETE!" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Total Objects Created: $totalObjects" -ForegroundColor Green
Write-Host "Time Elapsed: $([Math]::Round($duration, 2)) seconds" -ForegroundColor Green
Write-Host ""
Write-Host "PLATFORMS CREATED:" -ForegroundColor Yellow
Write-Host "  1. Normal Skull Tower Platform (-80, 50, 0)" -ForegroundColor White
Write-Host "     - Classic gray asteroid with purple gem" -ForegroundColor Gray
Write-Host "     - Skull decorations with glowing eyes" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. Fire Type Platform (0, 50, 0)" -ForegroundColor White
Write-Host "     - Volcanic asteroid with fiery red gem" -ForegroundColor Gray
Write-Host "     - Lava veins and flame pillars" -ForegroundColor Gray
Write-Host ""
Write-Host "  3. Ice Type Platform (80, 50, 0)" -ForegroundColor White
Write-Host "     - Frozen asteroid with cyan gem" -ForegroundColor Gray
Write-Host "     - Ice crystals and frozen mist" -ForegroundColor Gray
Write-Host ""
Write-Host "FEATURES:" -ForegroundColor Yellow
Write-Host "  - Comet-like irregular asteroid bases" -ForegroundColor Gray
Write-Host "  - Evil towers with legendary gems (diamonds)" -ForegroundColor Gray
Write-Host "  - Large movement areas for aerial combat" -ForegroundColor Gray
Write-Host "  - Themed visual elements per platform" -ForegroundColor Gray
Write-Host "  - Space environment with distant stars" -ForegroundColor Gray
Write-Host ""
Write-Host "Ready for battle! Destroy the towers and claim the gems!" -ForegroundColor Green
Write-Host ""
