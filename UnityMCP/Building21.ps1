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
# FINAL STATISTICS & COMPLETION
# ============================================================================
Write-Host ""
Write-Host "========================================================================" -ForegroundColor Green
Write-Host "  BUILDING 21 CONSTRUCTION COMPLETE!" -ForegroundColor Green
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
