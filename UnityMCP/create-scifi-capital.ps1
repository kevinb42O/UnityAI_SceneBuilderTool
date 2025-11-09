# ============================================================================
# SCI-FI CAPITAL OF THE FUTURE
# The Ultimate Ropeswing Paradise - Extreme Verticality
# Futuristic city with ultra-tall buildings, neon accents, and perfect connectivity
# ============================================================================

. ".\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  SCI-FI CAPITAL OF THE FUTURE" -ForegroundColor Cyan
Write-Host "  The Ultimate Ropeswing Paradise - Where Spider-Man is Jealous" -ForegroundColor Cyan
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
Write-Host "[CLEANUP] Clearing old scene..." -ForegroundColor Yellow

# Delete everything except player
$groupsToDelete = @(
    "SciFiCapital", "Buildings", "Streets", "Vehicles", "Lighting",
    "Skyways", "NeonSigns", "Infrastructure", "GroundLevel", "Rooftops"
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
# HELPER FUNCTIONS FOR FUTURISTIC CITY
# ============================================================================

function Build-Skyscraper {
    param(
        [string]$name,
        [float]$x, [float]$z,
        [float]$height = 100,
        [float]$width = 15,
        [float]$depth = 15,
        [string]$style = "Modern", # Modern, Cylindrical, Pyramid, Setback
        [hashtable]$primaryColor = @{ r = 0.15; g = 0.15; b = 0.2 },
        [hashtable]$accentColor = @{ r = 0.0; g = 0.8; b = 1.0 },
        [string]$parent = "Buildings"
    )
    
    $buildingGroup = "${name}_Building"
    New-Group -name $buildingGroup -parent $parent
    
    if ($style -eq "Modern") {
        # Main tower body
        Build-ColoredObject -name "${name}_Tower" -type "Cube" `
            -x $x -y ($height / 2) -z $z `
            -sx $width -sy $height -sz $depth `
            -color $primaryColor `
            -metallic 0.8 -smoothness 0.9 `
            -parent $buildingGroup
        $script:totalObjects++
        
        # Glowing edge strips (4 vertical edges)
        $edgeOffsets = @(
            @{x = $width/2; z = $depth/2},
            @{x = -$width/2; z = $depth/2},
            @{x = $width/2; z = -$depth/2},
            @{x = -$width/2; z = -$depth/2}
        )
        
        foreach ($edge in $edgeOffsets) {
            Build-ColoredObject -name "${name}_EdgeGlow_$($edge.x)_$($edge.z)" -type "Cube" `
                -x ($x + $edge.x) -y ($height / 2) -z ($z + $edge.z) `
                -sx 0.3 -sy $height -sz 0.3 `
                -color $accentColor `
                -metallic 0.9 -smoothness 0.95 `
                -parent $buildingGroup
            
            Set-Material -name "${name}_EdgeGlow_$($edge.x)_$($edge.z)" `
                -emission @{ r = $accentColor.r; g = $accentColor.g; b = $accentColor.b; intensity = 3.0 }
            $script:totalObjects++
        }
        
    } elseif ($style -eq "Cylindrical") {
        # Cylindrical tower
        Build-ColoredObject -name "${name}_Tower" -type "Cylinder" `
            -x $x -y ($height / 2) -z $z `
            -sx ($width * 0.7) -sy $height -sz ($width * 0.7) `
            -color $primaryColor `
            -metallic 0.85 -smoothness 0.9 `
            -parent $buildingGroup
        $script:totalObjects++
        
        # Horizontal glowing rings (8 levels)
        for ($i = 1; $i -le 8; $i++) {
            $ringHeight = ($height / 9) * $i
            Build-ColoredObject -name "${name}_Ring_$i" -type "Cylinder" `
                -x $x -y $ringHeight -z $z `
                -sx ($width * 0.75) -sy 0.5 -sz ($width * 0.75) `
                -color $accentColor `
                -metallic 0.9 -smoothness 0.95 `
                -parent $buildingGroup
            
            Set-Material -name "${name}_Ring_$i" `
                -emission @{ r = $accentColor.r; g = $accentColor.g; b = $accentColor.b; intensity = 2.5 }
            $script:totalObjects++
        }
        
    } elseif ($style -eq "Pyramid") {
        # Create stepped pyramid effect with decreasing width
        $levels = 8
        for ($i = 0; $i -lt $levels; $i++) {
            $levelHeight = $height / $levels
            $levelWidth = $width * (1 - ($i * 0.08))
            $levelDepth = $depth * (1 - ($i * 0.08))
            $levelY = ($i * $levelHeight) + ($levelHeight / 2)
            
            Build-ColoredObject -name "${name}_Level_$i" -type "Cube" `
                -x $x -y $levelY -z $z `
                -sx $levelWidth -sy $levelHeight -sz $levelDepth `
                -color $primaryColor `
                -metallic 0.8 -smoothness 0.9 `
                -parent $buildingGroup
            $script:totalObjects++
            
            # Edge glow for each level
            if ($i % 2 -eq 0) {
                Build-ColoredObject -name "${name}_LevelGlow_$i" -type "Cube" `
                    -x $x -y ($levelY + $levelHeight/2) -z $z `
                    -sx ($levelWidth + 0.5) -sy 0.3 -sz ($levelDepth + 0.5) `
                    -color $accentColor `
                    -metallic 0.9 -smoothness 0.95 `
                    -parent $buildingGroup
                
                Set-Material -name "${name}_LevelGlow_$i" `
                    -emission @{ r = $accentColor.r; g = $accentColor.g; b = $accentColor.b; intensity = 2.0 }
                $script:totalObjects++
            }
        }
        
    } elseif ($style -eq "Setback") {
        # Modern setback skyscraper (3 tiers)
        $tier1H = $height * 0.4
        Build-ColoredObject -name "${name}_Tier1" -type "Cube" `
            -x $x -y ($tier1H / 2) -z $z `
            -sx $width -sy $tier1H -sz $depth `
            -color $primaryColor `
            -metallic 0.8 -smoothness 0.9 `
            -parent $buildingGroup
        $script:totalObjects++
        
        $tier2H = $height * 0.35
        $tier2W = $width * 0.7
        Build-ColoredObject -name "${name}_Tier2" -type "Cube" `
            -x $x -y ($tier1H + $tier2H / 2) -z $z `
            -sx $tier2W -sy $tier2H -sz ($depth * 0.7) `
            -color $primaryColor `
            -metallic 0.8 -smoothness 0.9 `
            -parent $buildingGroup
        $script:totalObjects++
        
        $tier3H = $height * 0.25
        $tier3W = $width * 0.4
        Build-ColoredObject -name "${name}_Tier3" -type "Cube" `
            -x $x -y ($tier1H + $tier2H + $tier3H / 2) -z $z `
            -sx $tier3W -sy $tier3H -sz ($depth * 0.4) `
            -color $primaryColor `
            -metallic 0.8 -smoothness 0.9 `
            -parent $buildingGroup
        $script:totalObjects++
        
        # Glowing tier separators
        Build-ColoredObject -name "${name}_TierGlow1" -type "Cube" `
            -x $x -y $tier1H -z $z `
            -sx ($width + 1) -sy 0.5 -sz ($depth + 1) `
            -color $accentColor `
            -metallic 0.9 -smoothness 0.95 `
            -parent $buildingGroup
        Set-Material -name "${name}_TierGlow1" `
            -emission @{ r = $accentColor.r; g = $accentColor.g; b = $accentColor.b; intensity = 3.5 }
        $script:totalObjects++
        
        Build-ColoredObject -name "${name}_TierGlow2" -type "Cube" `
            -x $x -y ($tier1H + $tier2H) -z $z `
            -sx ($tier2W + 1) -sy 0.5 -sz ($depth * 0.7 + 1) `
            -color $accentColor `
            -metallic 0.9 -smoothness 0.95 `
            -parent $buildingGroup
        Set-Material -name "${name}_TierGlow2" `
            -emission @{ r = $accentColor.r; g = $accentColor.g; b = $accentColor.b; intensity = 3.5 }
        $script:totalObjects++
    }
    
    # Add rooftop elements
    Build-ColoredObject -name "${name}_Helipad" -type "Cylinder" `
        -x $x -y ($height + 1) -z $z `
        -sx ($width * 0.4) -sy 0.3 -sz ($width * 0.4) `
        -color @{ r = 0.8; g = 0.8; b = 0.0 } `
        -metallic 0.7 -smoothness 0.8 `
        -parent $buildingGroup
    Set-Material -name "${name}_Helipad" `
        -emission @{ r = 0.8; g = 0.8; b = 0.0; intensity = 2.0 }
    $script:totalObjects++
    
    # Antenna spire
    Build-ColoredObject -name "${name}_Antenna" -type "Cylinder" `
        -x $x -y ($height + 5) -z $z `
        -sx 0.3 -sy 5 -sz 0.3 `
        -color @{ r = 0.9; g = 0.1; b = 0.1 } `
        -metallic 0.9 -smoothness 0.95 `
        -parent $buildingGroup
    Set-Material -name "${name}_Antenna" `
        -emission @{ r = 1.0; g = 0.0; b = 0.0; intensity = 4.0 }
    $script:totalObjects++
    
    # Antenna beacon
    Build-ColoredObject -name "${name}_Beacon" -type "Sphere" `
        -x $x -y ($height + 10) -z $z `
        -sx 1.5 -sy 1.5 -sz 1.5 `
        -color @{ r = 1.0; g = 0.0; b = 0.0 } `
        -metallic 0.3 -smoothness 0.95 `
        -parent $buildingGroup
    Set-Material -name "${name}_Beacon" `
        -emission @{ r = 1.0; g = 0.0; b = 0.0; intensity = 5.0 }
    $script:totalObjects++
}

function Build-Skyway {
    param(
        [string]$name,
        [float]$x1, [float]$y, [float]$z1,
        [float]$x2, [float]$z2,
        [float]$width = 4,
        [hashtable]$color = @{ r = 0.2; g = 0.2; b = 0.25 },
        [string]$parent = "Skyways"
    )
    
    # Calculate midpoint and length
    $midX = ($x1 + $x2) / 2
    $midZ = ($z1 + $z2) / 2
    $dx = $x2 - $x1
    $dz = $z2 - $z1
    $length = [Math]::Sqrt($dx*$dx + $dz*$dz)
    $angle = [Math]::Atan2($dx, $dz) * 180 / [Math]::PI
    
    # Bridge platform
    Build-ColoredObject -name "${name}_Platform" -type "Cube" `
        -x $midX -y $y -z $midZ `
        -ry $angle `
        -sx $width -sy 0.5 -sz $length `
        -color $color `
        -metallic 0.7 -smoothness 0.8 `
        -parent $parent
    $script:totalObjects++
    
    # Glowing edge rails
    Build-ColoredObject -name "${name}_Rail_L" -type "Cube" `
        -x $midX -y ($y + 1) -z $midZ `
        -ry $angle `
        -sx 0.2 -sy 2 -sz $length `
        -color @{ r = 0.0; g = 0.6; b = 1.0 } `
        -metallic 0.9 -smoothness 0.95 `
        -parent $parent
    Set-Material -name "${name}_Rail_L" `
        -emission @{ r = 0.0; g = 0.6; b = 1.0; intensity = 2.0 }
    $script:totalObjects++
}

function Build-Vehicle {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [float]$rotation = 0,
        [string]$type = "Car", # Car, Hover, Truck
        [hashtable]$color = @{ r = 0.8; g = 0.2; b = 0.2 },
        [string]$parent = "Vehicles"
    )
    
    if ($type -eq "Hover") {
        # Futuristic hovering vehicle
        Build-ColoredObject -name "${name}_Body" -type "Cube" `
            -x $x -y ($y + 1.5) -z $z `
            -ry $rotation `
            -sx 2 -sy 1 -sz 4 `
            -color $color `
            -metallic 0.9 -smoothness 0.95 `
            -parent $parent
        $script:totalObjects++
        
        # Glowing underside
        Build-ColoredObject -name "${name}_HoverGlow" -type "Cube" `
            -x $x -y ($y + 0.8) -z $z `
            -ry $rotation `
            -sx 2.2 -sy 0.3 -sz 4.2 `
            -color @{ r = 0.0; g = 0.8; b = 1.0 } `
            -metallic 0.5 -smoothness 0.95 `
            -parent $parent
        Set-Material -name "${name}_HoverGlow" `
            -emission @{ r = 0.0; g = 0.8; b = 1.0; intensity = 3.0 }
        $script:totalObjects++
    } else {
        # Standard ground vehicle
        Build-ColoredObject -name "${name}_Body" -type "Cube" `
            -x $x -y ($y + 0.8) -z $z `
            -ry $rotation `
            -sx 2 -sy 1.2 -sz 4.5 `
            -color $color `
            -metallic 0.8 -smoothness 0.85 `
            -parent $parent
        $script:totalObjects++
        
        # Wheels
        for ($i = 0; $i -lt 4; $i++) {
            $wheelX = $x + ((($i % 2) * 2) - 1) * 1.2
            $wheelZ = $z + ((($i / 2) * 2) - 1) * 1.8
            
            Build-ColoredObject -name "${name}_Wheel_$i" -type "Cylinder" `
                -x $wheelX -y ($y + 0.4) -z $wheelZ `
                -rx 0 -ry $rotation -rz 90 `
                -sx 0.4 -sy 0.3 -sz 0.4 `
                -color @{ r = 0.1; g = 0.1; b = 0.1 } `
                -metallic 0.3 -smoothness 0.6 `
                -parent $parent
            $script:totalObjects++
        }
    }
    
    # Headlights
    Build-ColoredObject -name "${name}_Lights" -type "Cube" `
        -x $x -y ($y + 0.7) -z ($z + 2.3) `
        -ry $rotation `
        -sx 1.5 -sy 0.3 -sz 0.2 `
        -color @{ r = 1.0; g = 1.0; b = 1.0 } `
        -metallic 0.9 -smoothness 0.95 `
        -parent $parent
    Set-Material -name "${name}_Lights" `
        -emission @{ r = 1.0; g = 1.0; b = 0.9; intensity = 4.0 }
    $script:totalObjects++
}

function Build-NeonSign {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [float]$width = 8,
        [float]$height = 3,
        [hashtable]$color = @{ r = 1.0; g = 0.0; b = 1.0 },
        [string]$parent = "NeonSigns"
    )
    
    # Sign backing
    Build-ColoredObject -name "${name}_Back" -type "Cube" `
        -x $x -y $y -z $z `
        -sx $width -sy $height -sz 0.3 `
        -color @{ r = 0.1; g = 0.1; b = 0.1 } `
        -metallic 0.5 -smoothness 0.4 `
        -parent $parent
    $script:totalObjects++
    
    # Glowing front
    Build-ColoredObject -name "${name}_Glow" -type "Cube" `
        -x $x -y $y -z ($z + 0.2) `
        -sx ($width - 0.5) -sy ($height - 0.5) -sz 0.1 `
        -color $color `
        -metallic 0.2 -smoothness 0.95 `
        -parent $parent
    Set-Material -name "${name}_Glow" `
        -emission @{ r = $color.r; g = $color.g; b = $color.b; intensity = 4.0 }
    $script:totalObjects++
    
    # Border strips
    for ($i = 0; $i -lt 4; $i++) {
        $borderX = $x
        $borderY = $y
        if ($i -eq 0) { $borderY = $y + $height/2 }
        elseif ($i -eq 1) { $borderY = $y - $height/2 }
        elseif ($i -eq 2) { $borderX = $x - $width/2 }
        else { $borderX = $x + $width/2 }
        
        $stripWidth = if ($i -lt 2) { $width } else { 0.3 }
        $stripHeight = if ($i -lt 2) { 0.3 } else { $height }
        
        Build-ColoredObject -name "${name}_Border_$i" -type "Cube" `
            -x $borderX -y $borderY -z ($z + 0.25) `
            -sx $stripWidth -sy $stripHeight -sz 0.1 `
            -color $color `
            -metallic 0.3 -smoothness 0.95 `
            -parent $parent
        Set-Material -name "${name}_Border_$i" `
            -emission @{ r = $color.r; g = $color.g; b = $color.b; intensity = 5.0 }
        $script:totalObjects++
    }
}

# ============================================================================
# SECTION 1: GROUND PLANE
# ============================================================================
Write-Host "=== SECTION 1: CITY FOUNDATION ===" -ForegroundColor Magenta

New-Group -name "SciFiCapital"
New-Group -name "GroundLevel" -parent "SciFiCapital"

# Massive ground plane (darker, urban)
Build-ColoredObject -name "CityGround" -type "Plane" `
    -x 0 -y 0 -z 0 `
    -sx 200 -sy 1 -sz 200 `
    -color @{ r = 0.08; g = 0.08; b = 0.1 } `
    -metallic 0.2 -smoothness 0.7 `
    -parent "GroundLevel"
$totalObjects++

Write-Host "[OK] City foundation created (2000x2000 units)" -ForegroundColor Green

# ============================================================================
# SECTION 2: ULTRA-TALL SKYSCRAPERS
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 2: ULTRA-TALL SKYSCRAPERS ===" -ForegroundColor Magenta

New-Group -name "Buildings" -parent "SciFiCapital"

# Cyan District (Northwest) - 5 buildings
Write-Host "  [DISTRICT] Cyan Tech District..." -ForegroundColor Cyan
$cyanColor = @{ r = 0.0; g = 0.8; b = 1.0 }

Build-Skyscraper -name "CyanTower01" -x -80 -z 80 -height 150 -width 18 -depth 18 `
    -style "Modern" -accentColor $cyanColor
Write-Host "    [+] CyanTower01 (150 units)" -ForegroundColor DarkCyan

Build-Skyscraper -name "CyanTower02" -x -80 -z 40 -height 120 -width 15 -depth 15 `
    -style "Cylindrical" -accentColor $cyanColor
Write-Host "    [+] CyanTower02 (120 units)" -ForegroundColor DarkCyan

Build-Skyscraper -name "CyanTower03" -x -40 -z 80 -height 110 -width 14 -depth 14 `
    -style "Setback" -accentColor $cyanColor
Write-Host "    [+] CyanTower03 (110 units)" -ForegroundColor DarkCyan

Build-Skyscraper -name "CyanTower04" -x -40 -z 40 -height 95 -width 12 -depth 12 `
    -style "Pyramid" -accentColor $cyanColor
Write-Host "    [+] CyanTower04 (95 units)" -ForegroundColor DarkCyan

Build-Skyscraper -name "CyanTower05" -x -60 -z 60 -height 130 -width 16 -depth 16 `
    -style "Modern" -accentColor $cyanColor
Write-Host "    [+] CyanTower05 (130 units)" -ForegroundColor DarkCyan

# Magenta District (Northeast) - 5 buildings
Write-Host "  [DISTRICT] Magenta Business District..." -ForegroundColor Magenta
$magentaColor = @{ r = 1.0; g = 0.0; b = 1.0 }

Build-Skyscraper -name "MagentaTower01" -x 80 -z 80 -height 145 -width 17 -depth 17 `
    -style "Cylindrical" -accentColor $magentaColor
Write-Host "    [+] MagentaTower01 (145 units)" -ForegroundColor DarkMagenta

Build-Skyscraper -name "MagentaTower02" -x 80 -z 40 -height 125 -width 16 -depth 16 `
    -style "Setback" -accentColor $magentaColor
Write-Host "    [+] MagentaTower02 (125 units)" -ForegroundColor DarkMagenta

Build-Skyscraper -name "MagentaTower03" -x 40 -z 80 -height 105 -width 13 -depth 13 `
    -style "Modern" -accentColor $magentaColor
Write-Host "    [+] MagentaTower03 (105 units)" -ForegroundColor DarkMagenta

Build-Skyscraper -name "MagentaTower04" -x 40 -z 40 -height 100 -width 14 -depth 14 `
    -style "Pyramid" -accentColor $magentaColor
Write-Host "    [+] MagentaTower04 (100 units)" -ForegroundColor DarkMagenta

Build-Skyscraper -name "MagentaTower05" -x 60 -z 60 -height 135 -width 15 -depth 15 `
    -style "Cylindrical" -accentColor $magentaColor
Write-Host "    [+] MagentaTower05 (135 units)" -ForegroundColor DarkMagenta

# Yellow District (Southeast) - 5 buildings
Write-Host "  [DISTRICT] Yellow Commerce District..." -ForegroundColor Yellow
$yellowColor = @{ r = 1.0; g = 0.9; b = 0.0 }

Build-Skyscraper -name "YellowTower01" -x 80 -z -80 -height 140 -width 19 -depth 19 `
    -style "Setback" -accentColor $yellowColor
Write-Host "    [+] YellowTower01 (140 units)" -ForegroundColor DarkYellow

Build-Skyscraper -name "YellowTower02" -x 80 -z -40 -height 115 -width 15 -depth 15 `
    -style "Modern" -accentColor $yellowColor
Write-Host "    [+] YellowTower02 (115 units)" -ForegroundColor DarkYellow

Build-Skyscraper -name "YellowTower03" -x 40 -z -80 -height 108 -width 13 -depth 13 `
    -style "Pyramid" -accentColor $yellowColor
Write-Host "    [+] YellowTower03 (108 units)" -ForegroundColor DarkYellow

Build-Skyscraper -name "YellowTower04" -x 40 -z -40 -height 92 -width 12 -depth 12 `
    -style "Cylindrical" -accentColor $yellowColor
Write-Host "    [+] YellowTower04 (92 units)" -ForegroundColor DarkYellow

Build-Skyscraper -name "YellowTower05" -x 60 -z -60 -height 128 -width 16 -depth 16 `
    -style "Modern" -accentColor $yellowColor
Write-Host "    [+] YellowTower05 (128 units)" -ForegroundColor DarkYellow

# Orange District (Southwest) - 5 buildings
Write-Host "  [DISTRICT] Orange Residential District..." -ForegroundColor DarkYellow
$orangeColor = @{ r = 1.0; g = 0.5; b = 0.0 }

Build-Skyscraper -name "OrangeTower01" -x -80 -z -80 -height 135 -width 18 -depth 18 `
    -style "Pyramid" -accentColor $orangeColor
Write-Host "    [+] OrangeTower01 (135 units)" -ForegroundColor DarkYellow

Build-Skyscraper -name "OrangeTower02" -x -80 -z -40 -height 118 -width 14 -depth 14 `
    -style "Cylindrical" -accentColor $orangeColor
Write-Host "    [+] OrangeTower02 (118 units)" -ForegroundColor DarkYellow

Build-Skyscraper -name "OrangeTower03" -x -40 -z -80 -height 102 -width 13 -depth 13 `
    -style "Setback" -accentColor $orangeColor
Write-Host "    [+] OrangeTower03 (102 units)" -ForegroundColor DarkYellow

Build-Skyscraper -name "OrangeTower04" -x -40 -z -40 -height 98 -width 12 -depth 12 `
    -style "Modern" -accentColor $orangeColor
Write-Host "    [+] OrangeTower04 (98 units)" -ForegroundColor DarkYellow

Build-Skyscraper -name "OrangeTower05" -x -60 -z -60 -height 125 -width 15 -depth 15 `
    -style "Setback" -accentColor $orangeColor
Write-Host "    [+] OrangeTower05 (125 units)" -ForegroundColor DarkYellow

Write-Host "[OK] 20 Ultra-Tall Skyscrapers built (heights: 92-150 units)" -ForegroundColor Green

# ============================================================================
# SECTION 3: SKYWAY NETWORK (The Ropeswing Infrastructure!)
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 3: SKYWAY NETWORK ===" -ForegroundColor Magenta

New-Group -name "Skyways" -parent "SciFiCapital"

Write-Host "  [SKYWAYS] Building connection infrastructure..." -ForegroundColor Gray

# High-level skyways (80-120 units height) - Perfect for swinging!
Build-Skyway -name "Skyway_C1_C5" -x1 -80 -y 100 -z1 80 -x2 -60 -z2 60 -width 5
Build-Skyway -name "Skyway_C2_C3" -x1 -80 -y 90 -z1 40 -x2 -40 -z2 80 -width 5
Build-Skyway -name "Skyway_M1_M5" -x1 80 -y 105 -z1 80 -x2 60 -z2 60 -width 5
Build-Skyway -name "Skyway_M2_M3" -x1 80 -y 95 -z1 40 -x2 40 -z2 80 -width 5
Build-Skyway -name "Skyway_Y1_Y5" -x1 80 -y 98 -z1 -80 -x2 60 -z2 -60 -width 5
Build-Skyway -name "Skyway_Y2_Y3" -x1 80 -y 88 -z1 -40 -x2 40 -z2 -80 -width 5
Build-Skyway -name "Skyway_O1_O5" -x1 -80 -y 92 -z1 -80 -x2 -60 -z2 -60 -width 5
Build-Skyway -name "Skyway_O2_O3" -x1 -80 -y 85 -z1 -40 -x2 -40 -z2 -80 -width 5

# Cross-district skyways (epic long swings!)
Build-Skyway -name "Skyway_Cross_CM" -x1 -60 -y 110 -z1 60 -x2 60 -z2 60 -width 6
Build-Skyway -name "Skyway_Cross_MY" -x1 60 -y 110 -z1 60 -x2 60 -z2 -60 -width 6
Build-Skyway -name "Skyway_Cross_YO" -x1 60 -y 110 -z1 -60 -x2 -60 -z2 -60 -width 6
Build-Skyway -name "Skyway_Cross_OC" -x1 -60 -y 110 -z1 -60 -x2 -60 -z2 60 -width 6

# Mid-level skyways (60 units)
Build-Skyway -name "Skyway_Mid_1" -x1 -80 -y 60 -z1 40 -x2 -40 -z2 40 -width 4
Build-Skyway -name "Skyway_Mid_2" -x1 80 -y 60 -z1 40 -x2 40 -z2 40 -width 4
Build-Skyway -name "Skyway_Mid_3" -x1 80 -y 60 -z1 -40 -x2 40 -z2 -40 -width 4
Build-Skyway -name "Skyway_Mid_4" -x1 -80 -y 60 -z1 -40 -x2 -40 -z2 -40 -width 4

Write-Host "[OK] Skyway Network: 16 high-altitude bridges (perfect for swinging!)" -ForegroundColor Green

# ============================================================================
# SECTION 4: STREET LEVEL INFRASTRUCTURE
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 4: STREET LEVEL ===" -ForegroundColor Magenta

New-Group -name "Streets" -parent "SciFiCapital"

Write-Host "  [STREETS] Creating road grid..." -ForegroundColor Gray

# Main avenue (north-south)
for ($i = -4; $i -le 4; $i++) {
    $z = $i * 20
    Build-ColoredObject -name "Street_NS_$i" -type "Cube" `
        -x 0 -y 0.1 -z $z `
        -sx 12 -sy 0.2 -sz 19 `
        -color @{ r = 0.12; g = 0.12; b = 0.12 } `
        -metallic 0.3 -smoothness 0.7 `
        -parent "Streets"
    $totalObjects++
}

# Main avenue (east-west)
for ($i = -4; $i -le 4; $i++) {
    $x = $i * 20
    Build-ColoredObject -name "Street_EW_$i" -type "Cube" `
        -x $x -y 0.1 -z 0 `
        -sx 19 -sy 0.2 -sz 12 `
        -color @{ r = 0.12; g = 0.12; b = 0.12 } `
        -metallic 0.3 -smoothness 0.7 `
        -parent "Streets"
    $totalObjects++
}

# Street lights (40 total)
Write-Host "  [LIGHTS] Installing street lights..." -ForegroundColor Gray
for ($x = -80; $x -le 80; $x += 40) {
    for ($z = -80; $z -le 80; $z += 40) {
        if ($x -eq 0 -or $z -eq 0) {
            # Light post
            Build-ColoredObject -name "StreetLight_${x}_${z}_Post" -type "Cylinder" `
                -x ($x + 8) -y 5 -z ($z + 8) `
                -sx 0.3 -sy 5 -sz 0.3 `
                -color @{ r = 0.3; g = 0.3; b = 0.3 } `
                -metallic 0.8 -smoothness 0.6 `
                -parent "Streets"
            $totalObjects++
            
            # Light globe
            Build-ColoredObject -name "StreetLight_${x}_${z}_Light" -type "Sphere" `
                -x ($x + 8) -y 10.5 -z ($z + 8) `
                -sx 1.2 -sy 1.2 -sz 1.2 `
                -color @{ r = 1.0; g = 0.95; b = 0.8 } `
                -metallic 0.2 -smoothness 0.95 `
                -parent "Streets"
            Set-Material -name "StreetLight_${x}_${z}_Light" `
                -emission @{ r = 1.0; g = 0.95; b = 0.8; intensity = 3.0 }
            $totalObjects++
        }
    }
}

Write-Host "[OK] Street Level: Grid roads + 20 street lights" -ForegroundColor Green

# ============================================================================
# SECTION 5: VEHICLES
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 5: VEHICLES ===" -ForegroundColor Magenta

New-Group -name "Vehicles" -parent "SciFiCapital"

Write-Host "  [VEHICLES] Populating streets with vehicles..." -ForegroundColor Gray

# Parked vehicles
$parkingSpots = @(
    @{x = -70; z = 15; rot = 90; type = "Hover"; color = @{r=0.8; g=0.1; b=0.1}},
    @{x = -70; z = 25; rot = 90; type = "Car"; color = @{r=0.2; g=0.2; b=0.8}},
    @{x = -30; z = 15; rot = 90; type = "Hover"; color = @{r=0.1; g=0.8; b=0.1}},
    @{x = 30; z = 15; rot = 90; type = "Car"; color = @{r=0.9; g=0.9; b=0.1}},
    @{x = 70; z = 15; rot = 90; type = "Hover"; color = @{r=1.0; g=0.5; b=0.0}},
    @{x = -70; z = -15; rot = 270; type = "Car"; color = @{r=0.6; g=0.0; b=0.6}},
    @{x = -30; z = -15; rot = 270; type = "Hover"; color = @{r=0.0; g=0.8; b=0.8}},
    @{x = 30; z = -15; rot = 270; type = "Car"; color = @{r=0.9; g=0.4; b=0.1}},
    @{x = 70; z = -15; rot = 270; type = "Hover"; color = @{r=0.8; g=0.8; b=0.8}},
    # Cross street vehicles
    @{x = 15; z = -70; rot = 0; type = "Hover"; color = @{r=0.1; g=0.1; b=0.9}},
    @{x = 15; z = -30; rot = 0; type = "Car"; color = @{r=0.9; g=0.1; b=0.4}},
    @{x = 15; z = 30; rot = 0; type = "Hover"; color = @{r=0.4; g=0.9; b=0.1}},
    @{x = 15; z = 70; rot = 0; type = "Car"; color = @{r=0.8; g=0.2; b=0.8}},
    @{x = -15; z = -70; rot = 180; type = "Hover"; color = @{r=0.1; g=0.9; b=0.9}},
    @{x = -15; z = -30; rot = 180; type = "Car"; color = @{r=0.9; g=0.5; b=0.1}},
    @{x = -15; z = 30; rot = 180; type = "Hover"; color = @{r=0.2; g=0.7; b=0.9}}
)

$vehicleIndex = 0
foreach ($spot in $parkingSpots) {
    Build-Vehicle -name "Vehicle_$vehicleIndex" `
        -x $spot.x -y 0.5 -z $spot.z `
        -rotation $spot.rot -type $spot.type -color $spot.color
    $vehicleIndex++
}

Write-Host "[OK] Vehicles: 16 parked (mix of hover and ground vehicles)" -ForegroundColor Green

# ============================================================================
# SECTION 6: NEON SIGNS AND ADVERTISEMENTS
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 6: NEON SIGNAGE ===" -ForegroundColor Magenta

New-Group -name "NeonSigns" -parent "SciFiCapital"

Write-Host "  [NEON] Installing billboard advertisements..." -ForegroundColor Gray

# Large billboards on buildings (mid-height, ~50 units)
$signPlacements = @(
    @{name="CyanAd1"; x=-80; y=50; z=88; w=12; h=6; color=@{r=0.0; g=0.8; b=1.0}},
    @{name="CyanAd2"; x=-88; y=50; z=40; w=10; h=5; color=@{r=0.0; g=0.8; b=1.0}},
    @{name="MagentaAd1"; x=80; y=55; z=88; w=14; h=7; color=@{r=1.0; g=0.0; b=1.0}},
    @{name="MagentaAd2"; x=88; y=55; z=40; w=12; h=6; color=@{r=1.0; g=0.0; b=1.0}},
    @{name="YellowAd1"; x=80; y=48; z=-88; w=13; h=6; color=@{r=1.0; g=0.9; b=0.0}},
    @{name="YellowAd2"; x=88; y=48; z=-40; w=11; h=5; color=@{r=1.0; g=0.9; b=0.0}},
    @{name="OrangeAd1"; x=-80; y=52; z=-88; w=12; h=6; color=@{r=1.0; g=0.5; b=0.0}},
    @{name="OrangeAd2"; x=-88; y=52; z=-40; w=10; h=5; color=@{r=1.0; g=0.5; b=0.0}}
)

foreach ($sign in $signPlacements) {
    Build-NeonSign -name $sign.name -x $sign.x -y $sign.y -z $sign.z `
        -width $sign.w -height $sign.h -color $sign.color
}

# Smaller signs at street level
for ($i = 0; $i -lt 8; $i++) {
    $angle = ($i / 8.0) * 2 * [Math]::PI
    $x = [Math]::Cos($angle) * 45
    $z = [Math]::Sin($angle) * 45
    $colors = @(
        @{r=0.0; g=0.8; b=1.0},
        @{r=1.0; g=0.0; b=1.0},
        @{r=1.0; g=0.9; b=0.0},
        @{r=1.0; g=0.5; b=0.0}
    )
    $color = $colors[$i % 4]
    
    Build-NeonSign -name "StreetSign_$i" -x $x -y 8 -z $z `
        -width 4 -height 2 -color $color
}

Write-Host "[OK] Neon Signs: 16 billboards + advertisements" -ForegroundColor Green

# ============================================================================
# SECTION 7: ATMOSPHERIC LIGHTING
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 7: ATMOSPHERIC LIGHTING ===" -ForegroundColor Magenta

New-Group -name "Atmosphere" -parent "SciFiCapital"

Write-Host "  [ATMOSPHERE] Creating ambient lighting effects..." -ForegroundColor Gray

# Floating light orbs throughout the city
for ($i = 0; $i -lt 24; $i++) {
    $x = Get-Random -Minimum -90 -Maximum 90
    $z = Get-Random -Minimum -90 -Maximum 90
    $y = Get-Random -Minimum 30 -Maximum 100
    
    $lightColors = @(
        @{r=0.0; g=0.8; b=1.0},   # Cyan
        @{r=1.0; g=0.0; b=1.0},   # Magenta
        @{r=1.0; g=0.9; b=0.0},   # Yellow
        @{r=1.0; g=0.5; b=0.0}    # Orange
    )
    $color = $lightColors | Get-Random
    
    Build-ColoredObject -name "AmbientOrb_$i" -type "Sphere" `
        -x $x -y $y -z $z `
        -sx 2 -sy 2 -sz 2 `
        -color $color `
        -metallic 0.2 -smoothness 0.95 `
        -parent "Atmosphere"
    
    Set-Material -name "AmbientOrb_$i" `
        -emission @{ r = $color.r; g = $color.g; b = $color.b; intensity = 3.5 }
    $totalObjects++
}

# Searchlight beams from building tops
for ($i = 0; $i -lt 8; $i++) {
    $angle = ($i / 8.0) * 2 * [Math]::PI
    $x = [Math]::Cos($angle) * 60
    $z = [Math]::Sin($angle) * 60
    
    Build-ColoredObject -name "Searchlight_$i" -type "Cylinder" `
        -x $x -y 80 -z $z `
        -rx 45 -ry ($angle * 180 / [Math]::PI) `
        -sx 2 -sy 40 -sz 2 `
        -color @{ r = 1.0; g = 1.0; b = 1.0 } `
        -metallic 0.1 -smoothness 0.95 `
        -parent "Atmosphere"
    
    Set-Material -name "Searchlight_$i" `
        -emission @{ r = 1.0; g = 1.0; b = 0.95; intensity = 2.0 }
    $totalObjects++
}

Write-Host "[OK] Atmosphere: 24 floating orbs + 8 searchlights" -ForegroundColor Green

# ============================================================================
# FINAL STATS
# ============================================================================
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  SCI-FI CAPITAL OF THE FUTURE - COMPLETE!" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

$duration = (Get-Date) - $startTime
$minutes = [Math]::Floor($duration.TotalMinutes)
$seconds = $duration.Seconds

Write-Host "  Generation Time: ${minutes}m ${seconds}s" -ForegroundColor White
Write-Host "  Total Objects: $totalObjects" -ForegroundColor White
Write-Host ""
Write-Host "  CITY FEATURES:" -ForegroundColor Yellow
Write-Host "    - 20 Ultra-Tall Skyscrapers (92-150 units height)" -ForegroundColor White
Write-Host "    - 4 Color-Coded Districts (Cyan, Magenta, Yellow, Orange)" -ForegroundColor White
Write-Host "    - 16 High-Altitude Skyways (perfect for swinging!)" -ForegroundColor White
Write-Host "    - Grid Road Network with Street Lighting" -ForegroundColor White
Write-Host "    - 16 Vehicles (Hover Cars + Ground Cars)" -ForegroundColor White
Write-Host "    - 16 Neon Billboard Advertisements" -ForegroundColor White
Write-Host "    - 24 Floating Ambient Light Orbs" -ForegroundColor White
Write-Host "    - 8 Searchlight Beams" -ForegroundColor White
Write-Host "    - Rooftop Helipads on Every Building" -ForegroundColor White
Write-Host "    - Glowing Antenna Beacons" -ForegroundColor White
Write-Host ""
Write-Host "  ROPESWING PARADISE FEATURES:" -ForegroundColor Magenta
Write-Host "    * Extreme Verticality: Buildings up to 150 units tall" -ForegroundColor Cyan
Write-Host "    * Skyway Network: 16 connection points for aerial traversal" -ForegroundColor Cyan
Write-Host "    * Multi-Level City: Ground (0), Mid (60), High (100+)" -ForegroundColor Cyan
Write-Host "    * Perfect Spacing: Buildings 40 units apart for epic swings" -ForegroundColor Cyan
Write-Host "    * Visual Guides: Glowing edges show swing paths" -ForegroundColor Cyan
Write-Host "    * Rooftop Access: Helipads and antennas for top-level play" -ForegroundColor Cyan
Write-Host ""
Write-Host "  STYLE & ATMOSPHERE:" -ForegroundColor Yellow
Write-Host "    * Blade Runner / Cyberpunk 2077 Inspired" -ForegroundColor White
Write-Host "    * Neon-Soaked Streets and Buildings" -ForegroundColor White
Write-Host "    * Night City Vibe with Glowing Elements" -ForegroundColor White
Write-Host "    * PBR Materials: Metallic + Smooth Surfaces" -ForegroundColor White
Write-Host "    * Emission Lighting: 4.0-5.0 Intensity" -ForegroundColor White
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  SPIDER-MAN WOULD BE JEALOUS!" -ForegroundColor Green
Write-Host "  This city is the ULTIMATE ropeswing paradise!" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "RECOMMENDED CAMERA POSITIONS:" -ForegroundColor Yellow
Write-Host "  Overview: (0, 100, -150) Rotation: (25, 0, 0)" -ForegroundColor White
Write-Host "  Street Level: (0, 5, -50) Rotation: (5, 0, 0)" -ForegroundColor White
Write-Host "  Skyway Level: (0, 100, 0) Rotation: (45, 0, 0)" -ForegroundColor White
Write-Host "  Bird's Eye: (0, 180, 0) Rotation: (90, 0, 0)" -ForegroundColor White
Write-Host ""
Write-Host "SWINGING TIPS:" -ForegroundColor Magenta
Write-Host "  1. Start at building tops (140-150 units)" -ForegroundColor Gray
Write-Host "  2. Use skyways as mid-air platforms" -ForegroundColor Gray
Write-Host "  3. Buildings are 40 units apart - perfect swing distance!" -ForegroundColor Gray
Write-Host "  4. Follow the glowing neon paths" -ForegroundColor Gray
Write-Host "  5. Each district has unique color-coding for navigation" -ForegroundColor Gray
Write-Host ""
