# ============================================================================
# BUILDING 21 (B21) - Call of Duty DMZ Map Replica
# High-Security Military Research Facility - Multi-Story Complex
# ============================================================================
# Detailed recreation of the iconic Building 21 map from CoD DMZ/MW2
# Features: Underground levels, multiple floors, server rooms, laboratories,
# security checkpoints, rooftop access, and atmospheric lighting
# ============================================================================

. ".\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "========================================================================" -ForegroundColor Red
Write-Host "  BUILDING 21 (B21) - CLASSIFIED MILITARY RESEARCH FACILITY" -ForegroundColor Red
Write-Host "  Call of Duty DMZ Map Recreation" -ForegroundColor Red
Write-Host "========================================================================" -ForegroundColor Red
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

# Delete existing Building21 structure
$groupsToDelete = @(
    "Building21_Main", "B21_Underground", "B21_GroundFloor", "B21_Floor2", 
    "B21_Floor3", "B21_Floor4", "B21_Rooftop", "B21_Exterior", "B21_Details"
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
# BUILDING 21 SPECIFICATIONS
# ============================================================================
# Based on research of the Building 21 map from Call of Duty DMZ:
# - Multi-story high-security research facility
# - Underground levels (3 basement floors)
# - Ground floor with main entrance and lobby
# - Upper floors (4 stories) with laboratories and offices
# - Rooftop with helipad and maintenance structures
# - Server rooms, medical facilities, security checkpoints
# - Industrial/military aesthetic with concrete and metal
# ============================================================================

$buildingConfig = @{
    # Main building dimensions
    buildingWidth = 120    # X-axis
    buildingDepth = 100    # Z-axis
    floorHeight = 4.5      # Height per floor
    wallThickness = 0.5
    
    # Floor levels
    undergroundLevels = 3  # B1, B2, B3
    groundFloor = 1
    upperFloors = 4        # Floors 2-5
    
    # Building center position
    centerX = 0
    centerZ = 0
    
    # Colors (military/industrial palette)
    concreteColor = @{ r = 0.35; g = 0.35; b = 0.38 }
    darkConcreteColor = @{ r = 0.25; g = 0.25; b = 0.27 }
    metalColor = @{ r = 0.4; g = 0.4; b = 0.45 }
    floorColor = @{ r = 0.3; g = 0.3; b = 0.32 }
    windowColor = @{ r = 0.2; g = 0.3; b = 0.4 }
    emergencyLightColor = @{ r = 1.0; g = 0.2; b = 0.0; intensity = 1.5 }
    serverLightColor = @{ r = 0.0; g = 0.6; b = 1.0; intensity = 2.0 }
}

# Helper function for creating doors
function New-Door {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [float]$rotation = 0,
        [string]$parent,
        [string]$doorType = "Standard"  # Standard, Security, Lab, Vault
    )
    
    $doorWidth = 2
    $doorHeight = 3
    $doorColor = @{ r = 0.3; g = 0.3; b = 0.35 }
    
    if ($doorType -eq "Security") {
        $doorColor = @{ r = 0.4; g = 0.4; b = 0.45 }
        $metallic = 0.7
    } elseif ($doorType -eq "Vault") {
        $doorColor = @{ r = 0.5; g = 0.5; b = 0.5 }
        $metallic = 0.9
        $doorWidth = 2.5
    } elseif ($doorType -eq "Lab") {
        $doorColor = @{ r = 0.35; g = 0.4; b = 0.45 }
        $metallic = 0.5
    } else {
        $metallic = 0.4
    }
    
    # Door frame
    Build-ColoredObject -name "$name`_Frame" -type "Cube" `
        -x $x -y $y -z $z `
        -sx ($doorWidth + 0.4) -sy ($doorHeight + 0.2) -sz 0.3 `
        -ry $rotation `
        -color $buildingConfig.metalColor `
        -metallic 0.5 -smoothness 0.3 `
        -parent $parent
    $script:totalObjects++
    
    # Door panel
    Build-ColoredObject -name "$name`_Panel" -type "Cube" `
        -x $x -y $y -z $z `
        -sx $doorWidth -sy $doorHeight -sz 0.2 `
        -ry $rotation `
        -color $doorColor `
        -metallic $metallic -smoothness 0.4 `
        -parent $parent
    $script:totalObjects++
    
    # Door handle
    Build-ColoredObject -name "$name`_Handle" -type "Sphere" `
        -x ($x + 0.7) -y ($y - 0.3) -z $z `
        -sx 0.15 -sy 0.3 -sz 0.15 `
        -ry $rotation `
        -color $buildingConfig.metalColor `
        -metallic 0.8 -smoothness 0.6 `
        -parent $parent
    $script:totalObjects++
}

# Helper function for creating signage
function New-Sign {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [string]$text,
        [float]$rotation = 0,
        [string]$parent,
        [bool]$illuminated = $false
    )
    
    # Sign background
    Build-ColoredObject -name "$name`_Sign" -type "Cube" `
        -x $x -y $y -z $z `
        -sx 2 -sy 0.8 -sz 0.1 `
        -ry $rotation `
        -color @{ r = 0.15; g = 0.15; b = 0.15 } `
        -metallic 0.1 -smoothness 0.5 `
        -parent $parent
    $script:totalObjects++
    
    # Text panel (lighter color to simulate text)
    Build-ColoredObject -name "$name`_Text" -type "Cube" `
        -x $x -y $y -z ($z + 0.06) `
        -sx 1.8 -sy 0.6 -sz 0.05 `
        -ry $rotation `
        -color @{ r = 0.9; g = 0.9; b = 0.9 } `
        -metallic 0.0 -smoothness 0.8 `
        -parent $parent
    
    if ($illuminated) {
        Set-Material -name "$name`_Text" `
            -emission @{ r = 0.8; g = 1.0; b = 0.8; intensity = 1.0 }
    }
    $script:totalObjects++
}

# Helper function for security cameras
function New-SecurityCamera {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [float]$rotation = 0,
        [string]$parent
    )
    
    # Camera body
    Build-ColoredObject -name "$name`_Body" -type "Cube" `
        -x $x -y $y -z $z `
        -sx 0.3 -sy 0.2 -sz 0.4 `
        -rx -20 -ry $rotation `
        -color @{ r = 0.15; g = 0.15; b = 0.15 } `
        -metallic 0.5 -smoothness 0.6 `
        -parent $parent
    $script:totalObjects++
    
    # Camera lens
    Build-ColoredObject -name "$name`_Lens" -type "Sphere" `
        -x $x -y ($y - 0.15) -z ($z - 0.15) `
        -sx 0.12 -sy 0.12 -sz 0.12 `
        -color @{ r = 0.05; g = 0.05; b = 0.1 } `
        -metallic 0.9 -smoothness 0.9 `
        -parent $parent
    $script:totalObjects++
    
    # Camera indicator light
    Build-ColoredObject -name "$name`_LED" -type "Sphere" `
        -x ($x + 0.12) -y $y -z ($z - 0.1) `
        -sx 0.05 -sy 0.05 -sz 0.05 `
        -color @{ r = 1.0; g = 0.0; b = 0.0 } `
        -parent $parent
    
    Set-Material -name "$name`_LED" `
        -emission @{ r = 1.0; g = 0.0; b = 0.0; intensity = 1.5 }
    $script:totalObjects++
}

# Helper function for furniture (desk)
function New-Desk {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [float]$rotation = 0,
        [string]$parent
    )
    
    # Desk top
    Build-ColoredObject -name "$name`_Top" -type "Cube" `
        -x $x -y ($y + 0.75) -z $z `
        -sx 2 -sy 0.1 -sz 1 `
        -ry $rotation `
        -color @{ r = 0.5; g = 0.35; b = 0.2 } `
        -metallic 0.0 -smoothness 0.3 `
        -parent $parent
    $script:totalObjects++
    
    # Desk legs (4)
    $legPositions = @(
        @{x = 0.9; z = 0.45},
        @{x = -0.9; z = 0.45},
        @{x = 0.9; z = -0.45},
        @{x = -0.9; z = -0.45}
    )
    
    foreach ($leg in $legPositions) {
        Build-ColoredObject -name "$name`_Leg_$($leg.x)_$($leg.z)" -type "Cube" `
            -x ($x + $leg.x) -y ($y + 0.35) -z ($z + $leg.z) `
            -sx 0.08 -sy 0.7 -sz 0.08 `
            -ry $rotation `
            -color @{ r = 0.45; g = 0.32; b = 0.18 } `
            -metallic 0.1 -smoothness 0.2 `
            -parent $parent
        $script:totalObjects++
    }
}

# Helper function for chair
function New-Chair {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [float]$rotation = 0,
        [string]$parent
    )
    
    # Seat
    Build-ColoredObject -name "$name`_Seat" -type "Cube" `
        -x $x -y ($y + 0.5) -z $z `
        -sx 0.5 -sy 0.1 -sz 0.5 `
        -ry $rotation `
        -color @{ r = 0.2; g = 0.2; b = 0.25 } `
        -metallic 0.2 -smoothness 0.4 `
        -parent $parent
    $script:totalObjects++
    
    # Backrest
    Build-ColoredObject -name "$name`_Back" -type "Cube" `
        -x $x -y ($y + 0.9) -z ($z - 0.2) `
        -sx 0.5 -sy 0.7 -sz 0.1 `
        -ry $rotation `
        -color @{ r = 0.2; g = 0.2; b = 0.25 } `
        -metallic 0.2 -smoothness 0.4 `
        -parent $parent
    $script:totalObjects++
    
    # Base
    Build-ColoredObject -name "$name`_Base" -type "Cylinder" `
        -x $x -y ($y + 0.15) -z $z `
        -sx 0.3 -sy 0.15 -sz 0.3 `
        -color @{ r = 0.3; g = 0.3; b = 0.35 } `
        -metallic 0.6 -smoothness 0.5 `
        -parent $parent
    $script:totalObjects++
}

# Helper function for computer
function New-Computer {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [float]$rotation = 0,
        [string]$parent,
        [bool]$powered = $true
    )
    
    # Monitor
    Build-ColoredObject -name "$name`_Monitor" -type "Cube" `
        -x $x -y ($y + 0.4) -z $z `
        -sx 0.6 -sy 0.4 -sz 0.05 `
        -ry $rotation `
        -color @{ r = 0.1; g = 0.1; b = 0.12 } `
        -metallic 0.7 -smoothness 0.8 `
        -parent $parent
    $script:totalObjects++
    
    # Screen (emissive if powered)
    Build-ColoredObject -name "$name`_Screen" -type "Cube" `
        -x $x -y ($y + 0.4) -z ($z + 0.03) `
        -sx 0.55 -sy 0.35 -sz 0.02 `
        -ry $rotation `
        -color @{ r = 0.1; g = 0.2; b = 0.3 } `
        -metallic 0.0 -smoothness 0.9 `
        -parent $parent
    
    if ($powered) {
        Set-Material -name "$name`_Screen" `
            -emission @{ r = 0.2; g = 0.4; b = 0.6; intensity = 0.8 }
    }
    $script:totalObjects++
    
    # Monitor stand
    Build-ColoredObject -name "$name`_Stand" -type "Cube" `
        -x $x -y ($y + 0.1) -z $z `
        -sx 0.15 -sy 0.2 -sz 0.15 `
        -ry $rotation `
        -color @{ r = 0.15; g = 0.15; b = 0.17 } `
        -metallic 0.5 -smoothness 0.5 `
        -parent $parent
    $script:totalObjects++
}

# Helper function for lab equipment
function New-LabEquipment {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [string]$type,  # Microscope, Centrifuge, Beaker, Terminal
        [string]$parent
    )
    
    if ($type -eq "Microscope") {
        # Base
        Build-ColoredObject -name "$name`_Base" -type "Cylinder" `
            -x $x -y ($y + 0.05) -z $z `
            -sx 0.3 -sy 0.05 -sz 0.3 `
            -color @{ r = 0.3; g = 0.3; b = 0.35 } `
            -metallic 0.6 -smoothness 0.6 `
            -parent $parent
        $script:totalObjects++
        
        # Body
        Build-ColoredObject -name "$name`_Body" -type "Cylinder" `
            -x $x -y ($y + 0.25) -z $z `
            -sx 0.15 -sy 0.25 -sz 0.15 `
            -color @{ r = 0.2; g = 0.2; b = 0.25 } `
            -metallic 0.7 -smoothness 0.7 `
            -parent $parent
        $script:totalObjects++
        
        # Lens
        Build-ColoredObject -name "$name`_Lens" -type "Sphere" `
            -x $x -y ($y + 0.55) -z $z `
            -sx 0.12 -sy 0.12 -sz 0.12 `
            -color @{ r = 0.8; g = 0.8; b = 0.9 } `
            -metallic 0.0 -smoothness 0.95 `
            -parent $parent
        $script:totalObjects++
    }
    elseif ($type -eq "Centrifuge") {
        # Main body
        Build-ColoredObject -name "$name`_Body" -type "Cylinder" `
            -x $x -y ($y + 0.3) -z $z `
            -sx 0.35 -sy 0.3 -sz 0.35 `
            -color @{ r = 0.85; g = 0.85; b = 0.9 } `
            -metallic 0.3 -smoothness 0.6 `
            -parent $parent
        $script:totalObjects++
        
        # Control panel
        Build-ColoredObject -name "$name`_Panel" -type "Cube" `
            -x ($x + 0.3) -y ($y + 0.4) -z $z `
            -sx 0.2 -sy 0.15 -sz 0.15 `
            -color @{ r = 0.1; g = 0.1; b = 0.12 } `
            -parent $parent
        
        Set-Material -name "$name`_Panel" `
            -emission @{ r = 0.0; g = 0.8; b = 0.4; intensity = 1.0 }
        $script:totalObjects++
    }
    elseif ($type -eq "Terminal") {
        # Terminal base
        Build-ColoredObject -name "$name`_Base" -type "Cube" `
            -x $x -y ($y + 0.15) -z $z `
            -sx 0.5 -sy 0.3 -sz 0.4 `
            -color @{ r = 0.15; g = 0.15; b = 0.18 } `
            -metallic 0.6 -smoothness 0.5 `
            -parent $parent
        $script:totalObjects++
        
        # Screen
        Build-ColoredObject -name "$name`_Screen" -type "Cube" `
            -x $x -y ($y + 0.4) -z ($z + 0.15) `
            -sx 0.4 -sy 0.25 -sz 0.05 `
            -color @{ r = 0.0; g = 0.3; b = 0.0 } `
            -parent $parent
        
        Set-Material -name "$name`_Screen" `
            -emission @{ r = 0.0; g = 1.0; b = 0.0; intensity = 1.2 }
        $script:totalObjects++
    }
}

# Helper function for parking spaces
function New-ParkingSpace {
    param(
        [string]$name,
        [float]$x, [float]$z,
        [float]$rotation = 0,
        [string]$parent
    )
    
    # Parking lines
    $lines = @(
        @{xOffset = -2; zOffset = 0; sx = 0.15; sz = 5},
        @{xOffset = 2; zOffset = 0; sx = 0.15; sz = 5},
        @{xOffset = 0; zOffset = -2.5; sx = 4; sz = 0.15},
        @{xOffset = 0; zOffset = 2.5; sx = 4; sz = 0.15}
    )
    
    foreach ($line in $lines) {
        Build-ColoredObject -name "$name`_Line_$($line.xOffset)_$($line.zOffset)" -type "Cube" `
            -x ($x + $line.xOffset) -y 0.02 -z ($z + $line.zOffset) `
            -sx $line.sx -sy 0.04 -sz $line.sz `
            -ry $rotation `
            -color @{ r = 1.0; g = 1.0; b = 0.0 } `
            -metallic 0.0 -smoothness 0.6 `
            -parent $parent
        $script:totalObjects++
    }
}

# Helper function for creating rooms
function New-Room {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [float]$width, [float]$depth, [float]$height,
        [string]$parent,
        [bool]$addDoor = $true,
        [bool]$addWindows = $false
    )
    
    $halfWidth = $width / 2
    $halfDepth = $depth / 2
    $halfHeight = $height / 2
    $wallThick = $buildingConfig.wallThickness
    
    # Floor
    Build-ColoredObject -name "$name`_Floor" -type "Cube" `
        -x $x -y ($y - $halfHeight) -z $z `
        -sx $width -sy 0.2 -sz $depth `
        -color $buildingConfig.floorColor `
        -metallic 0.1 -smoothness 0.3 `
        -parent $parent
    $script:totalObjects++
    
    # Ceiling
    Build-ColoredObject -name "$name`_Ceiling" -type "Cube" `
        -x $x -y ($y + $halfHeight) -z $z `
        -sx $width -sy 0.2 -sz $depth `
        -color $buildingConfig.concreteColor `
        -metallic 0.0 -smoothness 0.1 `
        -parent $parent
    $script:totalObjects++
    
    # Walls (North, South, East, West)
    # North wall (+Z)
    Build-ColoredObject -name "$name`_Wall_N" -type "Cube" `
        -x $x -y $y -z ($z + $halfDepth) `
        -sx $width -sy $height -sz $wallThick `
        -color $buildingConfig.concreteColor `
        -metallic 0.0 -smoothness 0.2 `
        -parent $parent
    $script:totalObjects++
    
    # South wall (-Z)
    Build-ColoredObject -name "$name`_Wall_S" -type "Cube" `
        -x $x -y $y -z ($z - $halfDepth) `
        -sx $width -sy $height -sz $wallThick `
        -color $buildingConfig.concreteColor `
        -metallic 0.0 -smoothness 0.2 `
        -parent $parent
    $script:totalObjects++
    
    # East wall (+X)
    Build-ColoredObject -name "$name`_Wall_E" -type "Cube" `
        -x ($x + $halfWidth) -y $y -z $z `
        -sx $wallThick -sy $height -sz $depth `
        -color $buildingConfig.concreteColor `
        -metallic 0.0 -smoothness 0.2 `
        -parent $parent
    $script:totalObjects++
    
    # West wall (-X)
    Build-ColoredObject -name "$name`_Wall_W" -type "Cube" `
        -x ($x - $halfWidth) -y $y -z $z `
        -sx $wallThick -sy $height -sz $depth `
        -color $buildingConfig.concreteColor `
        -metallic 0.0 -smoothness 0.2 `
        -parent $parent
    $script:totalObjects++
    
    # Add door if requested (on south wall by default)
    if ($addDoor) {
        New-Door -name "$name`_Door" `
            -x $x -y ($y - $halfHeight + 1.5) -z ($z - $halfDepth + 0.2) `
            -rotation 0 `
            -parent $parent `
            -doorType "Standard"
    }
}

# Helper function for corridors
function New-Corridor {
    param(
        [string]$name,
        [float]$x1, [float]$y, [float]$z1,
        [float]$x2, [float]$z2,
        [float]$width,
        [float]$height,
        [string]$parent
    )
    
    $length = [Math]::Sqrt(($x2 - $x1) * ($x2 - $x1) + ($z2 - $z1) * ($z2 - $z1))
    $midX = ($x1 + $x2) / 2
    $midZ = ($z1 + $z2) / 2
    $angle = [Math]::Atan2(($x2 - $x1), ($z2 - $z1)) * 180 / [Math]::PI
    
    # Corridor floor
    Build-ColoredObject -name "$name`_Floor" -type "Cube" `
        -x $midX -y ($y - $height/2) -z $midZ `
        -sx $width -sy 0.2 -sz $length `
        -ry $angle `
        -color $buildingConfig.floorColor `
        -metallic 0.1 -smoothness 0.3 `
        -parent $parent
    $script:totalObjects++
    
    # Corridor ceiling
    Build-ColoredObject -name "$name`_Ceiling" -type "Cube" `
        -x $midX -y ($y + $height/2) -z $midZ `
        -sx $width -sy 0.2 -sz $length `
        -ry $angle `
        -color $buildingConfig.concreteColor `
        -metallic 0.0 -smoothness 0.1 `
        -parent $parent
    $script:totalObjects++
}

# ============================================================================
# SECTION 1: MAIN STRUCTURE & EXTERIOR
# ============================================================================
Write-Host "=== SECTION 1: EXTERIOR STRUCTURE ===" -ForegroundColor Cyan

New-Group -name "Building21_Main"
New-Group -name "B21_Exterior" -parent "Building21_Main"

Write-Host "  [BUILDING] Foundation and exterior walls..." -ForegroundColor Gray

# Foundation/basement slab
Build-ColoredObject -name "B21_Foundation" -type "Cube" `
    -x 0 -y -14 -z 0 `
    -sx $buildingConfig.buildingWidth -sy 2 -sz $buildingConfig.buildingDepth `
    -color $buildingConfig.darkConcreteColor `
    -metallic 0.0 -smoothness 0.1 `
    -parent "B21_Exterior"
$totalObjects++

# Main exterior walls (ground to roof)
$exteriorHeight = ($buildingConfig.upperFloors + 1) * $buildingConfig.floorHeight

# North exterior wall
Build-ColoredObject -name "B21_Exterior_North" -type "Cube" `
    -x 0 -y ($exteriorHeight / 2) -z ($buildingConfig.buildingDepth / 2) `
    -sx $buildingConfig.buildingWidth -sy $exteriorHeight -sz 1 `
    -color $buildingConfig.concreteColor `
    -metallic 0.0 -smoothness 0.15 `
    -parent "B21_Exterior"
$totalObjects++

# South exterior wall
Build-ColoredObject -name "B21_Exterior_South" -type "Cube" `
    -x 0 -y ($exteriorHeight / 2) -z (-$buildingConfig.buildingDepth / 2) `
    -sx $buildingConfig.buildingWidth -sy $exteriorHeight -sz 1 `
    -color $buildingConfig.concreteColor `
    -metallic 0.0 -smoothness 0.15 `
    -parent "B21_Exterior"
$totalObjects++

# East exterior wall
Build-ColoredObject -name "B21_Exterior_East" -type "Cube" `
    -x ($buildingConfig.buildingWidth / 2) -y ($exteriorHeight / 2) -z 0 `
    -sx 1 -sy $exteriorHeight -sz $buildingConfig.buildingDepth `
    -color $buildingConfig.concreteColor `
    -metallic 0.0 -smoothness 0.15 `
    -parent "B21_Exterior"
$totalObjects++

# West exterior wall
Build-ColoredObject -name "B21_Exterior_West" -type "Cube" `
    -x (-$buildingConfig.buildingWidth / 2) -y ($exteriorHeight / 2) -z 0 `
    -sx 1 -sy $exteriorHeight -sz $buildingConfig.buildingDepth `
    -color $buildingConfig.concreteColor `
    -metallic 0.0 -smoothness 0.15 `
    -parent "B21_Exterior"
$totalObjects++

Write-Host "  [BUILDING] Adding exterior windows..." -ForegroundColor Gray

# Windows on each floor (North face)
for ($floor = 1; $floor -le $buildingConfig.upperFloors; $floor++) {
    $windowY = $floor * $buildingConfig.floorHeight
    
    for ($i = 0; $i -lt 8; $i++) {
        $windowX = -50 + ($i * 14)
        
        Build-ColoredObject -name "B21_Window_N_F$floor`_$i" -type "Cube" `
            -x $windowX -y $windowY -z ($buildingConfig.buildingDepth / 2 + 0.3) `
            -sx 2.5 -sy 2 -sz 0.3 `
            -color $buildingConfig.windowColor `
            -metallic 0.3 -smoothness 0.8 `
            -parent "B21_Exterior"
        $totalObjects++
    }
}

# Windows on East and West faces
for ($floor = 1; $floor -le $buildingConfig.upperFloors; $floor++) {
    $windowY = $floor * $buildingConfig.floorHeight
    
    for ($i = 0; $i -lt 6; $i++) {
        $windowZ = -40 + ($i * 16)
        
        # East face
        Build-ColoredObject -name "B21_Window_E_F$floor`_$i" -type "Cube" `
            -x ($buildingConfig.buildingWidth / 2 + 0.3) -y $windowY -z $windowZ `
            -sx 0.3 -sy 2 -sz 2.5 `
            -color $buildingConfig.windowColor `
            -metallic 0.3 -smoothness 0.8 `
            -parent "B21_Exterior"
        $totalObjects++
        
        # West face
        Build-ColoredObject -name "B21_Window_W_F$floor`_$i" -type "Cube" `
            -x (-$buildingConfig.buildingWidth / 2 - 0.3) -y $windowY -z $windowZ `
            -sx 0.3 -sy 2 -sz 2.5 `
            -color $buildingConfig.windowColor `
            -metallic 0.3 -smoothness 0.8 `
            -parent "B21_Exterior"
        $totalObjects++
    }
}

Write-Host "[OK] Exterior structure complete ($totalObjects objects)" -ForegroundColor Green

# ============================================================================
# SECTION 2: UNDERGROUND LEVELS (B1, B2, B3)
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 2: UNDERGROUND LEVELS ===" -ForegroundColor Cyan

New-Group -name "B21_Underground" -parent "Building21_Main"

# B3 Level (Deepest - Secure Storage & Systems)
Write-Host "  [UNDERGROUND] B3 Level - Deep Storage..." -ForegroundColor Gray
New-Group -name "B21_B3" -parent "B21_Underground"

$b3Y = -11

# B3 Main corridor (North-South)
New-Corridor -name "B3_MainCorridor" `
    -x1 0 -y $b3Y -z1 -40 `
    -x2 0 -z2 40 `
    -width 4 -height 3.5 `
    -parent "B21_B3"

# B3 Storage rooms
New-Room -name "B3_Storage_1" -x -25 -y $b3Y -z -25 `
    -width 15 -depth 15 -height 3.5 -parent "B21_B3"

New-Room -name "B3_Storage_2" -x 25 -y $b3Y -z -25 `
    -width 15 -depth 15 -height 3.5 -parent "B21_B3"

New-Room -name "B3_Vault" -x 0 -y $b3Y -z -35 `
    -width 20 -depth 12 -height 3.5 -parent "B21_B3"

# B3 Mechanical room
New-Room -name "B3_Mechanical" -x -25 -y $b3Y -z 25 `
    -width 20 -depth 20 -height 3.5 -parent "B21_B3"

# B2 Level (Server Rooms & Data Center)
Write-Host "  [UNDERGROUND] B2 Level - Server Rooms..." -ForegroundColor Gray
New-Group -name "B21_B2" -parent "B21_Underground"

$b2Y = -7.5

# B2 Main corridor
New-Corridor -name "B2_MainCorridor" `
    -x1 0 -y $b2Y -z1 -40 `
    -x2 0 -z2 40 `
    -width 5 -height 3.5 `
    -parent "B21_B2"

# Server Room 1 (with racks)
New-Room -name "B2_ServerRoom_1" -x -30 -y $b2Y -z 0 `
    -width 25 -depth 30 -height 3.5 -parent "B21_B2"

Write-Host "    [SERVERS] Adding server racks..." -ForegroundColor DarkGray

# Server racks in rows
for ($row = 0; $row -lt 3; $row++) {
    for ($col = 0; $col -lt 4; $col++) {
        $rackX = -38 + ($col * 4)
        $rackZ = -12 + ($row * 8)
        
        # Server rack
        Build-ColoredObject -name "B2_ServerRack_$row`_$col" -type "Cube" `
            -x $rackX -y $b2Y -z $rackZ `
            -sx 2 -sy 3 -sz 1 `
            -color $buildingConfig.metalColor `
            -metallic 0.7 -smoothness 0.4 `
            -parent "B21_B2"
        $totalObjects++
        
        # Server status lights
        Build-ColoredObject -name "B2_ServerLight_$row`_$col" -type "Sphere" `
            -x ($rackX - 0.8) -y ($b2Y + 1.2) -z $rackZ `
            -sx 0.15 -sy 0.15 -sz 0.15 `
            -color $buildingConfig.serverLightColor `
            -parent "B21_B2"
        
        Set-Material -name "B2_ServerLight_$row`_$col" `
            -emission $buildingConfig.serverLightColor
        $totalObjects++
    }
}

# Server Room 2
New-Room -name "B2_ServerRoom_2" -x 30 -y $b2Y -z 0 `
    -width 25 -depth 30 -height 3.5 -parent "B21_B2"

# Data backup room
New-Room -name "B2_DataBackup" -x 0 -y $b2Y -z -35 `
    -width 18 -depth 12 -height 3.5 -parent "B21_B2"

# B1 Level (Security & Labs)
Write-Host "  [UNDERGROUND] B1 Level - Security & Labs..." -ForegroundColor Gray
New-Group -name "B21_B1" -parent "B21_Underground"

$b1Y = -4

# B1 Main corridor (cross pattern)
New-Corridor -name "B1_Corridor_NS" `
    -x1 0 -y $b1Y -z1 -45 `
    -x2 0 -z2 45 `
    -width 6 -height 4 `
    -parent "B21_B1"

New-Corridor -name "B1_Corridor_EW" `
    -x1 -55 -y $b1Y -z1 0 `
    -x2 55 -z2 0 `
    -width 6 -height 4 `
    -parent "B21_B1"

# Security checkpoint at center
Build-ColoredObject -name "B1_Security_Desk" -type "Cube" `
    -x 0 -y $b1Y -z 0 `
    -sx 3 -sy 1.5 -sz 3 `
    -color $buildingConfig.metalColor `
    -metallic 0.5 -smoothness 0.6 `
    -parent "B21_B1"
$totalObjects++

# Research laboratories
New-Room -name "B1_Lab_North" -x 0 -y $b1Y -z 30 `
    -width 35 -depth 20 -height 4 -parent "B21_B1"

New-Room -name "B1_Lab_South" -x 0 -y $b1Y -z -30 `
    -width 35 -depth 20 -height 4 -parent "B21_B1"

# Medical bay
New-Room -name "B1_Medical" -x -35 -y $b1Y -z 0 `
    -width 20 -depth 25 -height 4 -parent "B21_B1"

# Chemical storage
New-Room -name "B1_ChemStorage" -x 35 -y $b1Y -z 0 `
    -width 20 -depth 25 -height 4 -parent "B21_B1"

# Emergency lights in underground
Write-Host "    [LIGHTING] Adding emergency lights..." -ForegroundColor DarkGray

for ($i = 0; $i -lt 8; $i++) {
    $lightZ = -35 + ($i * 10)
    
    # B1 lights
    Build-ColoredObject -name "B1_EmergencyLight_$i" -type "Sphere" `
        -x 0 -y ($b1Y + 1.8) -z $lightZ `
        -sx 0.3 -sy 0.3 -sz 0.3 `
        -color $buildingConfig.emergencyLightColor `
        -parent "B21_B1"
    
    Set-Material -name "B1_EmergencyLight_$i" `
        -emission $buildingConfig.emergencyLightColor
    $totalObjects++
}

Write-Host "[OK] Underground levels complete ($totalObjects objects)" -ForegroundColor Green

# ============================================================================
# SECTION 3: GROUND FLOOR
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 3: GROUND FLOOR ===" -ForegroundColor Cyan

New-Group -name "B21_GroundFloor" -parent "Building21_Main"

$groundY = 2.25

# Main lobby (large open area)
Write-Host "  [GROUND] Main entrance lobby..." -ForegroundColor Gray

# Lobby floor
Build-ColoredObject -name "GF_Lobby_Floor" -type "Cube" `
    -x 0 -y 0.1 -z 35 `
    -sx 50 -sy 0.2 -sz 30 `
    -color $buildingConfig.floorColor `
    -metallic 0.2 -smoothness 0.6 `
    -parent "B21_GroundFloor"
$totalObjects++

# Reception desk
Build-ColoredObject -name "GF_Reception_Desk" -type "Cube" `
    -x 0 -y 1.2 -z 30 `
    -sx 8 -sy 2.4 -sz 2 `
    -color $buildingConfig.metalColor `
    -metallic 0.4 -smoothness 0.5 `
    -parent "B21_GroundFloor"
$totalObjects++

# Security gates
Build-ColoredObject -name "GF_SecurityGate_L" -type "Cube" `
    -x -3 -y 1.5 -z 20 `
    -sx 0.3 -sy 3 -sz 1 `
    -color $buildingConfig.metalColor `
    -metallic 0.7 -smoothness 0.3 `
    -parent "B21_GroundFloor"
$totalObjects++

Build-ColoredObject -name "GF_SecurityGate_R" -type "Cube" `
    -x 3 -y 1.5 -z 20 `
    -sx 0.3 -sy 3 -sz 1 `
    -color $buildingConfig.metalColor `
    -metallic 0.7 -smoothness 0.3 `
    -parent "B21_GroundFloor"
$totalObjects++

# Main corridors
New-Corridor -name "GF_MainCorridor" `
    -x1 0 -y $groundY -z1 10 `
    -x2 0 -z2 -45 `
    -width 7 -height 4.5 `
    -parent "B21_GroundFloor"

# Elevator shafts (4 total)
Write-Host "  [GROUND] Elevator shafts..." -ForegroundColor Gray

$elevatorPositions = @(
    @{x = -10; z = 0},
    @{x = 10; z = 0},
    @{x = -10; z = -10},
    @{x = 10; z = -10}
)

foreach ($pos in $elevatorPositions) {
    Build-ColoredObject -name "GF_Elevator_$($pos.x)_$($pos.z)" -type "Cube" `
        -x $pos.x -y ($exteriorHeight / 2) -z $pos.z `
        -sx 3 -sy $exteriorHeight -sz 3 `
        -color $buildingConfig.metalColor `
        -metallic 0.6 -smoothness 0.4 `
        -parent "B21_GroundFloor"
    $totalObjects++
}

# Stairwell (main)
Write-Host "  [GROUND] Stairwell structure..." -ForegroundColor Gray

Build-ColoredObject -name "GF_Stairwell_Shaft" -type "Cube" `
    -x 45 -y ($exteriorHeight / 2) -z 35 `
    -sx 8 -sy $exteriorHeight -sz 12 `
    -color $buildingConfig.concreteColor `
    -metallic 0.0 -smoothness 0.2 `
    -parent "B21_GroundFloor"
$totalObjects++

# Offices and rooms
New-Room -name "GF_Office_East_1" -x 35 -y $groundY -z -20 `
    -width 15 -depth 12 -height 4.5 -parent "B21_GroundFloor"

New-Room -name "GF_Office_East_2" -x 35 -y $groundY -z -35 `
    -width 15 -depth 12 -height 4.5 -parent "B21_GroundFloor"

New-Room -name "GF_Office_West_1" -x -35 -y $groundY -z -20 `
    -width 15 -depth 12 -height 4.5 -parent "B21_GroundFloor"

New-Room -name "GF_Office_West_2" -x -35 -y $groundY -z -35 `
    -width 15 -depth 12 -height 4.5 -parent "B21_GroundFloor"

# Break room / Cafeteria
New-Room -name "GF_Cafeteria" -x -35 -y $groundY -z 10 `
    -width 20 -depth 18 -height 4.5 -parent "B21_GroundFloor"

# Equipment room
New-Room -name "GF_Equipment" -x 35 -y $groundY -z 10 `
    -width 18 -depth 15 -height 4.5 -parent "B21_GroundFloor"

Write-Host "[OK] Ground floor complete ($totalObjects objects)" -ForegroundColor Green

# ============================================================================
# SECTION 4: UPPER FLOORS (2-5)
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 4: UPPER FLOORS ===" -ForegroundColor Cyan

for ($floor = 2; $floor -le 5; $floor++) {
    Write-Host "  [FLOOR $floor] Building level $floor..." -ForegroundColor Gray
    
    New-Group -name "B21_Floor$floor" -parent "Building21_Main"
    
    $floorY = $floor * $buildingConfig.floorHeight - ($buildingConfig.floorHeight / 2)
    
    # Floor slab
    Build-ColoredObject -name "F$floor`_FloorSlab" -type "Cube" `
        -x 0 -y ($floorY - $buildingConfig.floorHeight / 2) -z 0 `
        -sx $buildingConfig.buildingWidth -sy 0.3 -sz $buildingConfig.buildingDepth `
        -color $buildingConfig.floorColor `
        -metallic 0.1 -smoothness 0.3 `
        -parent "B21_Floor$floor"
    $totalObjects++
    
    # Main corridor
    New-Corridor -name "F$floor`_MainCorridor" `
        -x1 0 -y $floorY -z1 -45 `
        -x2 0 -z2 45 `
        -width 6 -height 4 `
        -parent "B21_Floor$floor"
    
    # Cross corridor
    New-Corridor -name "F$floor`_CrossCorridor" `
        -x1 -50 -y $floorY -z1 0 `
        -x2 50 -z2 0 `
        -width 5 -height 4 `
        -parent "B21_Floor$floor"
    
    # Office/Lab rooms (varies by floor)
    if ($floor -eq 2 -or $floor -eq 3) {
        # Labs and research spaces
        New-Room -name "F$floor`_Lab_NE" -x 30 -y $floorY -z 25 `
            -width 25 -depth 20 -height 4 -parent "B21_Floor$floor"
        
        New-Room -name "F$floor`_Lab_NW" -x -30 -y $floorY -z 25 `
            -width 25 -depth 20 -height 4 -parent "B21_Floor$floor"
        
        New-Room -name "F$floor`_Lab_SE" -x 30 -y $floorY -z -25 `
            -width 25 -depth 20 -height 4 -parent "B21_Floor$floor"
        
        New-Room -name "F$floor`_Lab_SW" -x -30 -y $floorY -z -25 `
            -width 25 -depth 20 -height 4 -parent "B21_Floor$floor"
    }
    elseif ($floor -eq 4 -or $floor -eq 5) {
        # Executive offices and meeting rooms
        New-Room -name "F$floor`_Office_NE" -x 30 -y $floorY -z 25 `
            -width 22 -depth 18 -height 4 -parent "B21_Floor$floor"
        
        New-Room -name "F$floor`_Office_NW" -x -30 -y $floorY -z 25 `
            -width 22 -depth 18 -height 4 -parent "B21_Floor$floor"
        
        New-Room -name "F$floor`_Conference_S" -x 0 -y $floorY -z -30 `
            -width 40 -depth 20 -height 4 -parent "B21_Floor$floor"
    }
    
    # Small office pods along corridors
    for ($i = 0; $i -lt 4; $i++) {
        $podZ = -30 + ($i * 20)
        
        New-Room -name "F$floor`_Pod_E_$i" -x 48 -y $floorY -z $podZ `
            -width 8 -depth 8 -height 4 -parent "B21_Floor$floor"
        
        New-Room -name "F$floor`_Pod_W_$i" -x -48 -y $floorY -z $podZ `
            -width 8 -depth 8 -height 4 -parent "B21_Floor$floor"
    }
}

Write-Host "[OK] Upper floors complete ($totalObjects objects)" -ForegroundColor Green

# ============================================================================
# SECTION 5: ROOFTOP & HELIPAD
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 5: ROOFTOP STRUCTURES ===" -ForegroundColor Cyan

New-Group -name "B21_Rooftop" -parent "Building21_Main"

$roofY = ($buildingConfig.upperFloors + 1) * $buildingConfig.floorHeight

# Roof deck
Build-ColoredObject -name "Roof_Deck" -type "Cube" `
    -x 0 -y $roofY -z 0 `
    -sx $buildingConfig.buildingWidth -sy 0.5 -sz $buildingConfig.buildingDepth `
    -color $buildingConfig.darkConcreteColor `
    -metallic 0.1 -smoothness 0.2 `
    -parent "B21_Rooftop"
$totalObjects++

# Helipad
Write-Host "  [ROOFTOP] Helipad construction..." -ForegroundColor Gray

$helipadY = $roofY + 0.3

# Helipad platform
Build-ColoredObject -name "Roof_Helipad_Platform" -type "Cylinder" `
    -x 0 -y $helipadY -z 20 `
    -sx 20 -sy 0.3 -sz 20 `
    -color @{ r = 0.8; g = 0.2; b = 0.0 } `
    -metallic 0.2 -smoothness 0.4 `
    -parent "B21_Rooftop"
$totalObjects++

# Helipad center marker
Build-ColoredObject -name "Roof_Helipad_Center" -type "Cylinder" `
    -x 0 -y ($helipadY + 0.2) -z 20 `
    -sx 3 -sy 0.1 -sz 3 `
    -color @{ r = 1.0; g = 1.0; b = 1.0 } `
    -metallic 0.0 -smoothness 0.6 `
    -parent "B21_Rooftop"
$totalObjects++

# Helipad lights
for ($i = 0; $i -lt 8; $i++) {
    $angle = $i * 45
    $rad = $angle * [Math]::PI / 180
    $lightX = 10 * [Math]::Sin($rad)
    $lightZ = 20 + (10 * [Math]::Cos($rad))
    
    Build-ColoredObject -name "Roof_Helipad_Light_$i" -type "Sphere" `
        -x $lightX -y ($helipadY + 0.3) -z $lightZ `
        -sx 0.4 -sy 0.4 -sz 0.4 `
        -color @{ r = 1.0; g = 0.3; b = 0.0 } `
        -parent "B21_Rooftop"
    
    Set-Material -name "Roof_Helipad_Light_$i" `
        -emission @{ r = 1.0; g = 0.3; b = 0.0; intensity = 2.0 }
    $totalObjects++
}

# Rooftop access structure
Build-ColoredObject -name "Roof_Access_Building" -type "Cube" `
    -x 45 -y ($roofY + 2.5) -z 35 `
    -sx 10 -sy 5 -sz 14 `
    -color $buildingConfig.concreteColor `
    -metallic 0.0 -smoothness 0.2 `
    -parent "B21_Rooftop"
$totalObjects++

# HVAC units
Write-Host "  [ROOFTOP] HVAC and mechanical equipment..." -ForegroundColor Gray

for ($i = 0; $i -lt 6; $i++) {
    $hvacX = -40 + ($i * 16)
    $hvacZ = -30
    
    Build-ColoredObject -name "Roof_HVAC_$i" -type "Cube" `
        -x $hvacX -y ($roofY + 1.5) -z $hvacZ `
        -sx 4 -sy 3 -sz 3 `
        -color $buildingConfig.metalColor `
        -metallic 0.5 -smoothness 0.3 `
        -parent "B21_Rooftop"
    $totalObjects++
}

# Communication antennas
for ($i = 0; $i -lt 3; $i++) {
    $antennaX = -35 + ($i * 35)
    
    Build-ColoredObject -name "Roof_Antenna_$i" -type "Cylinder" `
        -x $antennaX -y ($roofY + 5) -z -40 `
        -sx 0.3 -sy 5 -sz 0.3 `
        -color $buildingConfig.metalColor `
        -metallic 0.8 -smoothness 0.6 `
        -parent "B21_Rooftop"
    $totalObjects++
    
    # Antenna top (dish/emitter)
    Build-ColoredObject -name "Roof_Antenna_Top_$i" -type "Sphere" `
        -x $antennaX -y ($roofY + 10.5) -z -40 `
        -sx 1.5 -sy 0.5 -sz 1.5 `
        -color $buildingConfig.metalColor `
        -metallic 0.9 -smoothness 0.7 `
        -parent "B21_Rooftop"
    $totalObjects++
    
    # Antenna warning light
    Build-ColoredObject -name "Roof_Antenna_Light_$i" -type "Sphere" `
        -x $antennaX -y ($roofY + 11) -z -40 `
        -sx 0.3 -sy 0.3 -sz 0.3 `
        -color @{ r = 1.0; g = 0.0; b = 0.0 } `
        -parent "B21_Rooftop"
    
    Set-Material -name "Roof_Antenna_Light_$i" `
        -emission @{ r = 1.0; g = 0.0; b = 0.0; intensity = 3.0 }
    $totalObjects++
}

# Rooftop perimeter barrier
Write-Host "  [ROOFTOP] Safety barriers..." -ForegroundColor Gray

# North barrier
for ($i = 0; $i -lt 24; $i++) {
    $barrierX = -58 + ($i * 5)
    
    Build-ColoredObject -name "Roof_Barrier_N_$i" -type "Cube" `
        -x $barrierX -y ($roofY + 1) -z 48 `
        -sx 0.2 -sy 2 -sz 1 `
        -color $buildingConfig.metalColor `
        -metallic 0.6 -smoothness 0.3 `
        -parent "B21_Rooftop"
    $totalObjects++
}

# South barrier
for ($i = 0; $i -lt 24; $i++) {
    $barrierX = -58 + ($i * 5)
    
    Build-ColoredObject -name "Roof_Barrier_S_$i" -type "Cube" `
        -x $barrierX -y ($roofY + 1) -z -48 `
        -sx 0.2 -sy 2 -sz 1 `
        -color $buildingConfig.metalColor `
        -metallic 0.6 -smoothness 0.3 `
        -parent "B21_Rooftop"
    $totalObjects++
}

Write-Host "[OK] Rooftop structures complete ($totalObjects objects)" -ForegroundColor Green

# ============================================================================
# SECTION 6: DETAILS & ATMOSPHERE
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 6: DETAILS & ATMOSPHERE ===" -ForegroundColor Cyan

New-Group -name "B21_Details" -parent "Building21_Main"

# Ground level security barriers
Write-Host "  [DETAILS] Security barriers and fencing..." -ForegroundColor Gray

# Perimeter fence posts
for ($i = 0; $i -lt 30; $i++) {
    $postX = -75 + ($i * 5)
    
    Build-ColoredObject -name "Security_Fence_N_$i" -type "Cylinder" `
        -x $postX -y 1.5 -z 65 `
        -sx 0.2 -sy 3 -sz 0.2 `
        -color $buildingConfig.metalColor `
        -metallic 0.7 -smoothness 0.3 `
        -parent "B21_Details"
    $totalObjects++
}

# Entrance bollards
for ($i = 0; $i -lt 8; $i++) {
    $bollardX = -14 + ($i * 4)
    
    Build-ColoredObject -name "Entrance_Bollard_$i" -type "Cylinder" `
        -x $bollardX -y 0.8 -z 55 `
        -sx 0.4 -sy 1.6 -sz 0.4 `
        -color @{ r = 0.9; g = 0.9; b = 0.0 } `
        -metallic 0.3 -smoothness 0.6 `
        -parent "B21_Details"
    $totalObjects++
}

# External lighting posts
Write-Host "  [DETAILS] External lighting..." -ForegroundColor Gray

$lightPositions = @(
    @{x = -50; z = 60},
    @{x = 0; z = 60},
    @{x = 50; z = 60},
    @{x = -50; z = -60},
    @{x = 0; z = -60},
    @{x = 50; z = -60}
)

foreach ($pos in $lightPositions) {
    # Light post
    Build-ColoredObject -name "ExtLight_Post_$($pos.x)_$($pos.z)" -type "Cylinder" `
        -x $pos.x -y 4 -z $pos.z `
        -sx 0.3 -sy 8 -sz 0.3 `
        -color $buildingConfig.metalColor `
        -metallic 0.6 -smoothness 0.4 `
        -parent "B21_Details"
    $totalObjects++
    
    # Light fixture
    Build-ColoredObject -name "ExtLight_Fixture_$($pos.x)_$($pos.z)" -type "Sphere" `
        -x $pos.x -y 8.5 -z $pos.z `
        -sx 1 -sy 1 -sz 1 `
        -color @{ r = 1.0; g = 0.95; b = 0.8 } `
        -parent "B21_Details"
    
    Set-Material -name "ExtLight_Fixture_$($pos.x)_$($pos.z)" `
        -emission @{ r = 1.0; g = 0.95; b = 0.8; intensity = 2.5 }
    $totalObjects++
}

# Ground markings (parking lines, etc.)
Write-Host "  [DETAILS] Ground markings..." -ForegroundColor Gray

for ($i = 0; $i -lt 10; $i++) {
    $lineX = -70 + ($i * 8)
    
    Build-ColoredObject -name "Parking_Line_$i" -type "Cube" `
        -x $lineX -y 0.05 -z 70 `
        -sx 0.2 -sy 0.1 -sz 5 `
        -color @{ r = 1.0; g = 1.0; b = 1.0 } `
        -metallic 0.0 -smoothness 0.8 `
        -parent "B21_Details"
    $totalObjects++
}

Write-Host "[OK] Details and atmosphere complete ($totalObjects objects)" -ForegroundColor Green

# ============================================================================
# SECTION 7: INTERIOR FURNITURE & WORKSTATIONS
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 7: INTERIOR FURNITURE ===" -ForegroundColor Cyan

New-Group -name "B21_Furniture" -parent "Building21_Main"

Write-Host "  [FURNITURE] Ground floor offices..." -ForegroundColor Gray

# Ground floor office furniture (4 offices)
$officePositions = @(
    @{name = "GF_Office_East_1"; x = 35; z = -20},
    @{name = "GF_Office_East_2"; x = 35; z = -35},
    @{name = "GF_Office_West_1"; x = -35; z = -20},
    @{name = "GF_Office_West_2"; x = -35; z = -35}
)

foreach ($office in $officePositions) {
    # Desk and chair
    New-Desk -name "$($office.name)_Desk" `
        -x $office.x -y $groundY -z $office.z `
        -rotation 90 -parent "B21_Furniture"
    
    New-Chair -name "$($office.name)_Chair" `
        -x ($office.x - 1) -y $groundY -z $office.z `
        -rotation 90 -parent "B21_Furniture"
    
    New-Computer -name "$($office.name)_Computer" `
        -x ($office.x + 0.7) -y ($groundY + 0.8) -z $office.z `
        -rotation 90 -powered $true -parent "B21_Furniture"
}

# Cafeteria tables and chairs
Write-Host "  [FURNITURE] Cafeteria seating..." -ForegroundColor Gray

for ($i = 0; $i -lt 3; $i++) {
    $tableX = -38 + ($i * 3)
    $tableZ = 10
    
    # Table (use desk as table)
    New-Desk -name "Cafeteria_Table_$i" `
        -x $tableX -y $groundY -z $tableZ `
        -parent "B21_Furniture"
    
    # 4 chairs around table
    $chairOffsets = @(
        @{x = 1.5; z = 0; rot = 270},
        @{x = -1.5; z = 0; rot = 90},
        @{x = 0; z = 0.8; rot = 180},
        @{x = 0; z = -0.8; rot = 0}
    )
    
    foreach ($offset in $chairOffsets) {
        New-Chair -name "Cafeteria_Chair_$i`_$($offset.x)_$($offset.z)" `
            -x ($tableX + $offset.x) -y $groundY -z ($tableZ + $offset.z) `
            -rotation $offset.rot -parent "B21_Furniture"
    }
}

# Upper floor office furniture (select rooms on floors 4-5)
Write-Host "  [FURNITURE] Executive offices..." -ForegroundColor Gray

for ($floor = 4; $floor -le 5; $floor++) {
    $floorY = $floor * $buildingConfig.floorHeight - ($buildingConfig.floorHeight / 2)
    
    # Executive desk in NE office
    New-Desk -name "F$floor`_Executive_Desk_NE" `
        -x 32 -y $floorY -z 28 `
        -rotation 180 -parent "B21_Furniture"
    
    New-Chair -name "F$floor`_Executive_Chair_NE" `
        -x 32 -y $floorY -z 29.5 `
        -rotation 180 -parent "B21_Furniture"
    
    New-Computer -name "F$floor`_Executive_Computer_NE" `
        -x 31.3 -y ($floorY + 0.8) -z 28 `
        -rotation 180 -powered $true -parent "B21_Furniture"
}

Write-Host "[OK] Furniture complete ($totalObjects objects)" -ForegroundColor Green

# ============================================================================
# SECTION 8: LAB EQUIPMENT & RESEARCH STATIONS
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 8: LAB EQUIPMENT ===" -ForegroundColor Cyan

New-Group -name "B21_LabEquipment" -parent "Building21_Main"

Write-Host "  [LAB] B1 research equipment..." -ForegroundColor Gray

# B1 Lab equipment (North lab)
$b1LabEquipment = @(
    @{x = 5; z = 35; type = "Microscope"},
    @{x = 10; z = 35; type = "Centrifuge"},
    @{x = 15; z = 35; type = "Terminal"},
    @{x = -5; z = 35; type = "Microscope"},
    @{x = -10; z = 35; type = "Terminal"}
)

foreach ($equip in $b1LabEquipment) {
    New-LabEquipment -name "B1_Lab_$($equip.type)_$($equip.x)" `
        -x $equip.x -y $b1Y -z $equip.z `
        -type $equip.type -parent "B21_LabEquipment"
}

# Floor 2 & 3 lab equipment
Write-Host "  [LAB] Upper floor research stations..." -ForegroundColor Gray

for ($floor = 2; $floor -le 3; $floor++) {
    $floorY = $floor * $buildingConfig.floorHeight - ($buildingConfig.floorHeight / 2)
    
    # Lab stations in each quadrant
    $labStations = @(
        @{x = 32; z = 28; type = "Terminal"},
        @{x = 36; z = 28; type = "Microscope"},
        @{x = -32; z = 28; type = "Centrifuge"},
        @{x = -36; z = 28; type = "Terminal"}
    )
    
    foreach ($station in $labStations) {
        New-LabEquipment -name "F$floor`_Lab_$($station.type)_$($station.x)" `
            -x $station.x -y $floorY -z $station.z `
            -type $station.type -parent "B21_LabEquipment"
    }
}

Write-Host "[OK] Lab equipment complete ($totalObjects objects)" -ForegroundColor Green

# ============================================================================
# SECTION 9: SECURITY SYSTEMS (Cameras & Sensors)
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 9: SECURITY SYSTEMS ===" -ForegroundColor Cyan

New-Group -name "B21_Security" -parent "Building21_Main"

Write-Host "  [SECURITY] Installing surveillance cameras..." -ForegroundColor Gray

# Ground floor corridor cameras
for ($i = 0; $i -lt 6; $i++) {
    $camZ = -40 + ($i * 16)
    
    # Cameras on ceiling pointing down corridor
    New-SecurityCamera -name "GF_Camera_Corridor_$i" `
        -x 0 -y ($groundY + 1.8) -z $camZ `
        -rotation 0 -parent "B21_Security"
}

# Entrance cameras
New-SecurityCamera -name "GF_Camera_Entrance_L" `
    -x -5 -y ($groundY + 2) -z 25 `
    -rotation 225 -parent "B21_Security"

New-SecurityCamera -name "GF_Camera_Entrance_R" `
    -x 5 -y ($groundY + 2) -z 25 `
    -rotation 135 -parent "B21_Security"

# Underground level cameras (high security areas)
Write-Host "  [SECURITY] Underground surveillance..." -ForegroundColor Gray

# B2 server room cameras
for ($i = 0; $i -lt 4; $i++) {
    $camX = -35 + ($i * 10)
    
    New-SecurityCamera -name "B2_Camera_ServerRoom_$i" `
        -x $camX -y ($b2Y + 1.5) -z 0 `
        -rotation (90 * $i) -parent "B21_Security"
}

# B1 security checkpoint camera
New-SecurityCamera -name "B1_Camera_Checkpoint" `
    -x 0 -y ($b1Y + 1.9) -z 0 `
    -rotation 0 -parent "B21_Security"

# Upper floor cameras (1 per floor)
for ($floor = 2; $floor -le 5; $floor++) {
    $floorY = $floor * $buildingConfig.floorHeight - ($buildingConfig.floorHeight / 2)
    
    New-SecurityCamera -name "F$floor`_Camera_Main" `
        -x 0 -y ($floorY + 1.8) -z 0 `
        -rotation 45 -parent "B21_Security"
}

# Rooftop security cameras
New-SecurityCamera -name "Roof_Camera_Helipad" `
    -x 0 -y ($roofY + 1) -z 10 `
    -rotation 180 -parent "B21_Security"

Write-Host "[OK] Security systems complete ($totalObjects objects)" -ForegroundColor Green

# ============================================================================
# SECTION 10: SIGNAGE & WAYFINDING
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 10: SIGNAGE SYSTEM ===" -ForegroundColor Cyan

New-Group -name "B21_Signage" -parent "Building21_Main"

Write-Host "  [SIGNAGE] Installing directional signs..." -ForegroundColor Gray

# Ground floor signs
$groundSigns = @(
    @{name = "GF_Sign_Lobby"; x = 0; z = 22; text = "MAIN LOBBY"; illuminated = $true},
    @{name = "GF_Sign_Security"; x = 0; z = 18; text = "SECURITY CHECKPOINT"; illuminated = $true},
    @{name = "GF_Sign_Cafeteria"; x = -25; z = 10; text = "CAFETERIA"; illuminated = $false},
    @{name = "GF_Sign_Elevators"; x = -5; z = -5; text = "ELEVATORS"; illuminated = $true},
    @{name = "GF_Sign_Stairs"; x = 40; z = 35; text = "EMERGENCY EXIT"; illuminated = $true}
)

foreach ($sign in $groundSigns) {
    New-Sign -name $sign.name `
        -x $sign.x -y ($groundY + 2) -z $sign.z `
        -text $sign.text `
        -illuminated $sign.illuminated `
        -parent "B21_Signage"
}

# Underground level signs
$undergroundSigns = @(
    @{name = "B1_Sign_Labs"; x = 0; z = 35; y = $b1Y; text = "RESEARCH LABS"},
    @{name = "B1_Sign_Medical"; x = -25; z = 0; y = $b1Y; text = "MEDICAL BAY"},
    @{name = "B2_Sign_ServerRoom"; x = -20; z = 5; y = $b2Y; text = "SERVER ROOM 1"; illuminated = $true},
    @{name = "B3_Sign_Vault"; x = 0; z = -30; y = $b3Y; text = "SECURE VAULT"; illuminated = $true}
)

foreach ($sign in $undergroundSigns) {
    New-Sign -name $sign.name `
        -x $sign.x -y ($sign.y + 1.8) -z $sign.z `
        -text $sign.text `
        -illuminated ($null -ne $sign.illuminated -and $sign.illuminated) `
        -parent "B21_Signage"
}

# Floor number signs at elevator areas
for ($floor = 2; $floor -le 5; $floor++) {
    $floorY = $floor * $buildingConfig.floorHeight - ($buildingConfig.floorHeight / 2)
    
    New-Sign -name "F$floor`_Sign_FloorNumber" `
        -x -8 -y ($floorY + 1.5) -z 2 `
        -text "FLOOR $floor" `
        -illuminated $true `
        -parent "B21_Signage"
}

# Rooftop signs
New-Sign -name "Roof_Sign_Helipad" `
    -x 0 -y ($roofY + 0.5) -z 10 `
    -text "HELIPAD - KEEP CLEAR" `
    -illuminated $true `
    -parent "B21_Signage"

Write-Host "[OK] Signage complete ($totalObjects objects)" -ForegroundColor Green

# ============================================================================
# SECTION 11: PARKING LOT & GROUND LANDSCAPING
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 11: EXTERIOR GROUNDS ===" -ForegroundColor Cyan

New-Group -name "B21_Grounds" -parent "Building21_Main"

Write-Host "  [GROUNDS] Parking lot construction..." -ForegroundColor Gray

# Parking lot ground
Build-ColoredObject -name "ParkingLot_Ground" -type "Plane" `
    -x 0 -y 0 -z 90 `
    -sx 25 -sy 1 -sz 20 `
    -color @{ r = 0.15; g = 0.15; b = 0.15 } `
    -metallic 0.1 -smoothness 0.4 `
    -parent "B21_Grounds"
$totalObjects++

# Parking spaces (3 rows of 6)
for ($row = 0; $row -lt 3; $row++) {
    for ($col = 0; $col -lt 6; $col++) {
        $parkX = -60 + ($col * 21)
        $parkZ = 70 + ($row * 13)
        
        New-ParkingSpace -name "Parking_R$row`_C$col" `
            -x $parkX -z $parkZ `
            -rotation 0 `
            -parent "B21_Grounds"
    }
}

# Landscaping - Trees around perimeter
Write-Host "  [GROUNDS] Landscaping and greenery..." -ForegroundColor Gray

$treePositions = @(
    @{x = -80; z = 50},
    @{x = -80; z = 20},
    @{x = -80; z = -10},
    @{x = -80; z = -40},
    @{x = 80; z = 50},
    @{x = 80; z = 20},
    @{x = 80; z = -10},
    @{x = 80; z = -40},
    @{x = -50; z = -70},
    @{x = -20; z = -70},
    @{x = 20; z = -70},
    @{x = 50; z = -70}
)

foreach ($tree in $treePositions) {
    # Tree trunk
    Build-ColoredObject -name "Tree_Trunk_$($tree.x)_$($tree.z)" -type "Cylinder" `
        -x $tree.x -y 4 -z $tree.z `
        -sx 0.8 -sy 8 -sz 0.8 `
        -color @{ r = 0.4; g = 0.25; b = 0.15 } `
        -metallic 0.0 -smoothness 0.2 `
        -parent "B21_Grounds"
    $totalObjects++
    
    # Tree foliage
    Build-ColoredObject -name "Tree_Foliage_$($tree.x)_$($tree.z)" -type "Sphere" `
        -x $tree.x -y 9 -z $tree.z `
        -sx 6 -sy 6 -sz 6 `
        -color @{ r = 0.2; g = 0.6; b = 0.2 } `
        -metallic 0.0 -smoothness 0.3 `
        -parent "B21_Grounds"
    $totalObjects++
}

# Ground grass patches
Write-Host "  [GROUNDS] Grass and ground cover..." -ForegroundColor Gray

for ($i = 0; $i -lt 8; $i++) {
    $grassX = -90 + ($i * 25)
    
    Build-ColoredObject -name "Grass_Patch_$i" -type "Plane" `
        -x $grassX -y 0 -z -75 `
        -sx 4 -sy 1 -sz 4 `
        -color @{ r = 0.2; g = 0.5; b = 0.2 } `
        -metallic 0.0 -smoothness 0.1 `
        -parent "B21_Grounds"
    $totalObjects++
}

# Shrubs near entrance
for ($i = 0; $i -lt 6; $i++) {
    $shrubX = -12 + ($i * 5)
    
    Build-ColoredObject -name "Shrub_$i" -type "Sphere" `
        -x $shrubX -y 0.8 -z 58 `
        -sx 1.5 -sy 1.5 -sz 1.5 `
        -color @{ r = 0.15; g = 0.5; b = 0.15 } `
        -metallic 0.0 -smoothness 0.2 `
        -parent "B21_Grounds"
    $totalObjects++
}

Write-Host "[OK] Exterior grounds complete ($totalObjects objects)" -ForegroundColor Green

# ============================================================================
# SECTION 12: ENVIRONMENTAL EFFECTS (Steam, Particles)
# ============================================================================
Write-Host ""
Write-Host "=== SECTION 12: ENVIRONMENTAL EFFECTS ===" -ForegroundColor Cyan

New-Group -name "B21_Effects" -parent "Building21_Main"

Write-Host "  [EFFECTS] Steam vents and atmospheric effects..." -ForegroundColor Gray

# Rooftop steam vents (from HVAC units)
for ($i = 0; $i -lt 6; $i++) {
    $hvacX = -40 + ($i * 16)
    $hvacZ = -30
    
    # Steam particle representation (glowing sphere)
    Build-ColoredObject -name "Roof_Steam_$i" -type "Sphere" `
        -x $hvacX -y ($roofY + 3.5) -z $hvacZ `
        -sx 0.8 -sy 1.2 -sz 0.8 `
        -color @{ r = 0.8; g = 0.8; b = 0.9 } `
        -metallic 0.0 -smoothness 0.8 `
        -parent "B21_Effects"
    
    Set-Material -name "Roof_Steam_$i" `
        -emission @{ r = 0.9; g = 0.9; b = 1.0; intensity = 0.5 }
    $totalObjects++
}

# Underground steam pipes (B3 mechanical)
for ($i = 0; $i -lt 3; $i++) {
    $pipeX = -28 + ($i * 3)
    
    Build-ColoredObject -name "B3_Steam_Pipe_$i" -type "Sphere" `
        -x $pipeX -y ($b3Y + 1.5) -z 28 `
        -sx 0.5 -sy 0.8 -sz 0.5 `
        -color @{ r = 0.9; g = 0.9; b = 0.95 } `
        -metallic 0.0 -smoothness 0.7 `
        -parent "B21_Effects"
    
    Set-Material -name "B3_Steam_Pipe_$i" `
        -emission @{ r = 0.8; g = 0.8; b = 0.9; intensity = 0.4 }
    $totalObjects++
}

# Ambient glow effects in server rooms
Write-Host "  [EFFECTS] Ambient server room glow..." -ForegroundColor Gray

for ($i = 0; $i -lt 4; $i++) {
    $glowX = -30 + ($i * 20)
    
    Build-ColoredObject -name "B2_Ambient_Glow_$i" -type "Sphere" `
        -x $glowX -y ($b2Y + 2) -z 0 `
        -sx 2 -sy 2 -sz 2 `
        -color @{ r = 0.0; g = 0.4; b = 0.8 } `
        -metallic 0.0 -smoothness 1.0 `
        -parent "B21_Effects"
    
    Set-Material -name "B2_Ambient_Glow_$i" `
        -emission @{ r = 0.0; g = 0.5; b = 1.0; intensity = 0.6 }
    $totalObjects++
}

Write-Host "[OK] Environmental effects complete ($totalObjects objects)" -ForegroundColor Green

# ============================================================================
# FINAL STATISTICS & COMPLETION
# ============================================================================
Write-Host ""
Write-Host "========================================================================" -ForegroundColor Green
Write-Host "  BUILDING 21 CONSTRUCTION COMPLETE - 100% PERFECT!" -ForegroundColor Green
Write-Host "========================================================================" -ForegroundColor Green

$endTime = Get-Date
$duration = ($endTime - $startTime).TotalSeconds

Write-Host ""
Write-Host "STATISTICS:" -ForegroundColor Cyan
Write-Host "  Total Objects Created: $totalObjects" -ForegroundColor White
Write-Host "  Construction Time: $([Math]::Round($duration, 1)) seconds" -ForegroundColor White
Write-Host "  Average Speed: $([Math]::Round($totalObjects / $duration, 1)) objects/sec" -ForegroundColor White
Write-Host ""

Write-Host "STRUCTURE BREAKDOWN:" -ForegroundColor Cyan
Write-Host "  Underground Levels: 3 (B1, B2, B3)" -ForegroundColor White
Write-Host "  Ground Floor: 1" -ForegroundColor White
Write-Host "  Upper Floors: 4 (Floors 2-5)" -ForegroundColor White
Write-Host "  Rooftop Features: Helipad, HVAC, Antennas" -ForegroundColor White
Write-Host "  Total Building Height: ~$([Math]::Round($roofY + 11, 1)) units" -ForegroundColor White
Write-Host ""

Write-Host "KEY FEATURES:" -ForegroundColor Cyan
Write-Host "  [✓] Multi-story military research facility" -ForegroundColor Green
Write-Host "  [✓] 3 underground levels with server rooms" -ForegroundColor Green
Write-Host "  [✓] Security checkpoints and controlled access" -ForegroundColor Green
Write-Host "  [✓] Laboratory and research spaces" -ForegroundColor Green
Write-Host "  [✓] Rooftop helipad with lighting" -ForegroundColor Green
Write-Host "  [✓] HVAC and communication systems" -ForegroundColor Green
Write-Host "  [✓] Emergency lighting throughout" -ForegroundColor Green
Write-Host "  [✓] Realistic military/industrial materials" -ForegroundColor Green
Write-Host ""
Write-Host "NEW ENHANCED FEATURES:" -ForegroundColor Magenta
Write-Host "  [✓] Interior furniture (desks, chairs, computers)" -ForegroundColor Green
Write-Host "  [✓] Door objects at room entrances" -ForegroundColor Green
Write-Host "  [✓] Room signage and wayfinding system" -ForegroundColor Green
Write-Host "  [✓] Security cameras and surveillance" -ForegroundColor Green
Write-Host "  [✓] Environmental effects (steam, ambient glow)" -ForegroundColor Green
Write-Host "  [✓] Detailed lab equipment (microscopes, centrifuges)" -ForegroundColor Green
Write-Host "  [✓] Exterior parking lot with marked spaces" -ForegroundColor Green
Write-Host "  [✓] Ground landscaping (trees, grass, shrubs)" -ForegroundColor Green
Write-Host ""

Write-Host "RECOMMENDED CAMERA POSITIONS:" -ForegroundColor Cyan
Write-Host "  1. Overview: (0, 50, -150) | Rotation: (20, 0, 0)" -ForegroundColor Yellow
Write-Host "  2. Entrance: (0, 5, 80) | Rotation: (5, 180, 0)" -ForegroundColor Yellow
Write-Host "  3. Rooftop: (0, $($roofY + 20), 0) | Rotation: (60, 0, 0)" -ForegroundColor Yellow
Write-Host "  4. Underground: (0, -8, 0) | Rotation: (0, 0, 0)" -ForegroundColor Yellow
Write-Host "  5. Aerial Side: (150, 30, 0) | Rotation: (15, -90, 0)" -ForegroundColor Yellow
Write-Host ""

Write-Host "========================================================================" -ForegroundColor Green
Write-Host "  CLASSIFIED FACILITY READY FOR DEPLOYMENT" -ForegroundColor Red
Write-Host "  Building 21 (B21) - DMZ Operative Training Complete" -ForegroundColor Red
Write-Host "========================================================================" -ForegroundColor Green
Write-Host ""

Write-Host "[TIP] Use Optimize-Group to combine meshes for better performance!" -ForegroundColor Cyan
Write-Host "[TIP] Adjust materials with Set-Material for custom appearance!" -ForegroundColor Cyan
Write-Host ""
