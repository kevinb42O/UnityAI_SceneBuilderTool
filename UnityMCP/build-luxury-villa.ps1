# ============================================================
# LUXURY MULTI-STORY VILLA BUILDER
# Ultra-Detailed 3-Story Mediterranean Villa with Gardens
# Showcases ALL Unity MCP capabilities + custom methods
# ============================================================

# Import helper library
. "$PSScriptRoot\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  LUXURY VILLA CONSTRUCTION SYSTEM" -ForegroundColor Cyan
Write-Host "  Multi-Story Mediterranean Masterpiece" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test connection
if (-not (Test-UnityConnection)) {
    Write-Host "[ERROR] Cannot connect to Unity!" -ForegroundColor Red
    exit 1
}

Write-Host "[VILLA] Starting construction..." -ForegroundColor Green
Write-Host ""

$global:objectCount = 0
$global:roomCount = 0

# ============================================================
# HELPER FUNCTIONS FOR VILLA CONSTRUCTION
# ============================================================

function Build-Window {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [float]$ry = 0,
        [string]$parent = ""
    )
    
    # Window frame
    Build-ColoredObject -name "$name-Frame" -type "Cube" `
        -x $x -y $y -z $z -ry $ry `
        -sx 2.2 -sy 2.5 -sz 0.2 `
        -parent $parent
    Set-Material -name "$name-Frame" `
        -color @{r=0.9; g=0.85; b=0.75} -metallic 0.0 -smoothness 0.4
    
    # Glass pane
    Build-ColoredObject -name "$name-Glass" -type "Cube" `
        -x $x -y $y -z $z -ry $ry `
        -sx 2.0 -sy 2.3 -sz 0.1 `
        -parent $parent
    Apply-Material -name "$name-Glass" -materialName "Glass_Clear"
    
    # Window divider (cross)
    Build-ColoredObject -name "$name-DivV" -type "Cube" `
        -x $x -y $y -z $z -ry $ry `
        -sx 0.1 -sy 2.3 -sz 0.15 `
        -parent $parent
    Set-Material -name "$name-DivV" `
        -color @{r=0.3; g=0.25; b=0.2} -metallic 0.0 -smoothness 0.3
    
    Build-ColoredObject -name "$name-DivH" -type "Cube" `
        -x $x -y $y -z $z -ry $ry `
        -sx 2.0 -sy 0.1 -sz 0.15 `
        -parent $parent
    Set-Material -name "$name-DivH" `
        -color @{r=0.3; g=0.25; b=0.2} -metallic 0.0 -smoothness 0.3
    
    $global:objectCount += 4
}

function Build-Door {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [float]$ry = 0,
        [string]$parent = ""
    )
    
    # Door frame
    Build-ColoredObject -name "$name-Frame" -type "Cube" `
        -x $x -y $y -z $z -ry $ry `
        -sx 1.5 -sy 3.5 -sz 0.3 `
        -parent $parent
    Set-Material -name "$name-Frame" `
        -color @{r=0.9; g=0.85; b=0.75} -metallic 0.0 -smoothness 0.4
    
    # Door
    Build-ColoredObject -name "$name-Door" -type "Cube" `
        -x $x -y $y -z $z -ry $ry `
        -sx 1.3 -sy 3.3 -sz 0.2 `
        -parent $parent
    Apply-Material -name "$name-Door" -materialName "Wood_Oak"
    
    # Door handle
    Build-ColoredObject -name "$name-Handle" -type "Sphere" `
        -x ($x + 0.5) -y $y -z $z -ry $ry `
        -sx 0.15 -sy 0.15 -sz 0.15 `
        -parent $parent
    Apply-Material -name "$name-Handle" -materialName "Metal_Gold"
    
    $global:objectCount += 3
}

function Build-Column {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [float]$height = 8,
        [float]$radius = 0.5,
        [string]$parent = ""
    )
    
    # Column base
    Build-ColoredObject -name "$name-Base" -type "Cylinder" `
        -x $x -y ($y - $height/2 + 0.3) -z $z `
        -sx ($radius * 1.4) -sy 0.3 -sz ($radius * 1.4) `
        -parent $parent
    Set-Material -name "$name-Base" `
        -color @{r=0.95; g=0.92; b=0.85} -metallic 0.0 -smoothness 0.6
    
    # Column shaft
    Build-ColoredObject -name "$name-Shaft" -type "Cylinder" `
        -x $x -y $y -z $z `
        -sx $radius -sy ($height/2) -sz $radius `
        -parent $parent
    Set-Material -name "$name-Shaft" `
        -color @{r=0.98; g=0.95; b=0.90} -metallic 0.0 -smoothness 0.5
    
    # Column capital
    Build-ColoredObject -name "$name-Capital" -type "Cylinder" `
        -x $x -y ($y + $height/2 - 0.3) -z $z `
        -sx ($radius * 1.4) -sy 0.3 -sz ($radius * 1.4) `
        -parent $parent
    Set-Material -name "$name-Capital" `
        -color @{r=0.95; g=0.92; b=0.85} -metallic 0.0 -smoothness 0.6
    
    $global:objectCount += 3
}

function Build-Balcony {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [float]$width = 6,
        [float]$depth = 2,
        [float]$ry = 0,
        [string]$parent = ""
    )
    
    # Balcony floor
    Build-ColoredObject -name "$name-Floor" -type "Cube" `
        -x $x -y $y -z $z -ry $ry `
        -sx $width -sy 0.2 -sz $depth `
        -parent $parent
    Set-Material -name "$name-Floor" `
        -color @{r=0.85; g=0.80; b=0.70} -metallic 0.0 -smoothness 0.4
    
    # Railings
    for ($i = 0; $i -lt 8; $i++) {
        $railX = $x - $width/2 + ($i * $width/7)
        Build-ColoredObject -name "$name-Rail$i" -type "Cylinder" `
            -x $railX -y ($y + 0.6) -z ($z + $depth/2) -ry $ry `
            -sx 0.08 -sy 0.6 -sz 0.08 `
            -parent $parent
        Apply-Material -name "$name-Rail$i" -materialName "Metal_Bronze"
    }
    
    # Top rail
    Build-ColoredObject -name "$name-TopRail" -type "Cube" `
        -x $x -y ($y + 1.2) -z ($z + $depth/2) -ry $ry `
        -sx $width -sy 0.1 -sz 0.15 `
        -parent $parent
    Apply-Material -name "$name-TopRail" -materialName "Metal_Bronze"
    
    $global:objectCount += 10
}

function Build-Chandelier {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [string]$parent = ""
    )
    
    # Ceiling mount
    Build-ColoredObject -name "$name-Mount" -type "Cylinder" `
        -x $x -y ($y + 0.3) -z $z `
        -sx 0.2 -sy 0.3 -sz 0.2 `
        -parent $parent
    Apply-Material -name "$name-Mount" -materialName "Metal_Gold"
    
    # Central sphere
    Build-ColoredObject -name "$name-Center" -type "Sphere" `
        -x $x -y $y -z $z `
        -sx 0.6 -sy 0.6 -sz 0.6 `
        -parent $parent
    Set-Material -name "$name-Center" `
        -color @{r=1.0; g=0.95; b=0.7} `
        -emission @{r=1.0; g=0.9; b=0.6; intensity=2.5}
    
    # Light bulbs around
    for ($i = 0; $i -lt 6; $i++) {
        $angle = ($i * 60) * [Math]::PI / 180
        $bulbX = $x + [Math]::Cos($angle) * 1.2
        $bulbZ = $z + [Math]::Sin($angle) * 1.2
        
        Build-ColoredObject -name "$name-Bulb$i" -type "Sphere" `
            -x $bulbX -y ($y - 0.5) -z $bulbZ `
            -sx 0.3 -sy 0.3 -sz 0.3 `
            -parent $parent
        Set-Material -name "$name-Bulb$i" `
            -color @{r=1.0; g=0.9; b=0.7} `
            -emission @{r=1.0; g=0.85; b=0.5; intensity=3.0}
    }
    
    $global:objectCount += 8
}

function Build-Stairs {
    param(
        [string]$name,
        [float]$x, [float]$y, [float]$z,
        [int]$steps = 12,
        [float]$ry = 0,
        [string]$parent = ""
    )
    
    $stepHeight = 0.3
    $stepDepth = 0.5
    
    for ($i = 0; $i -lt $steps; $i++) {
        $stepY = $y + ($i * $stepHeight)
        $stepZ = $z + ($i * $stepDepth)
        
        Build-ColoredObject -name "$name-Step$i" -type "Cube" `
            -x $x -y $stepY -z $stepZ -ry $ry `
            -sx 3.0 -sy ($stepHeight) -sz ($stepDepth * 1.2) `
            -parent $parent
        Set-Material -name "$name-Step$i" `
            -color @{r=0.75; g=0.70; b=0.65} -metallic 0.0 -smoothness 0.3
        
        $global:objectCount++
    }
}

function Build-Furniture-Set {
    param(
        [string]$roomName,
        [float]$x, [float]$y, [float]$z,
        [string]$parent = ""
    )
    
    # Table
    Build-ColoredObject -name "$roomName-Table" -type "Cube" `
        -x $x -y ($y + 0.8) -z $z `
        -sx 2.0 -sy 0.1 -sz 1.2 `
        -parent $parent
    Apply-Material -name "$roomName-Table" -materialName "Wood_Oak"
    
    # Table legs
    for ($i = 0; $i -lt 4; $i++) {
        $legX = $x + (($i % 2) * 1.8 - 0.9)
        $legZ = $z + (($i / 2) * 1.0 - 0.5)
        Build-ColoredObject -name "$roomName-Leg$i" -type "Cylinder" `
            -x $legX -y ($y + 0.4) -z $legZ `
            -sx 0.1 -sy 0.4 -sz 0.1 `
            -parent $parent
        Apply-Material -name "$roomName-Leg$i" -materialName "Wood_Oak"
    }
    
    # Chairs
    for ($i = 0; $i -lt 4; $i++) {
        $chairX = $x + (($i % 2) * 3.0 - 1.5)
        $chairZ = $z + (($i / 2) * 2.0 - 1.0)
        
        # Chair seat
        Build-ColoredObject -name "$roomName-Chair$i-Seat" -type "Cube" `
            -x $chairX -y ($y + 0.5) -z $chairZ `
            -sx 0.5 -sy 0.1 -sz 0.5 `
            -parent $parent
        Set-Material -name "$roomName-Chair$i-Seat" `
            -color @{r=0.4; g=0.2; b=0.1} -metallic 0.0 -smoothness 0.4
        
        # Chair back
        Build-ColoredObject -name "$roomName-Chair$i-Back" -type "Cube" `
            -x $chairX -y ($y + 0.9) -z ($chairZ - 0.2) `
            -sx 0.5 -sy 0.8 -sz 0.1 `
            -parent $parent
        Set-Material -name "$roomName-Chair$i-Back" `
            -color @{r=0.4; g=0.2; b=0.1} -metallic 0.0 -smoothness 0.4
    }
    
    $global:objectCount += 13
}

# ============================================================
# MAIN VILLA CONSTRUCTION
# ============================================================

Write-Host "[PHASE 1] Creating Villa Foundation..." -ForegroundColor Yellow
New-Group -name "LuxuryVilla"
New-Group -name "Foundation" -parent "LuxuryVilla"

# Large foundation platform (20x20m)
Build-ColoredObject -name "Foundation-Base" -type "Cube" `
    -x 0 -y 0.5 -z 0 `
    -sx 22 -sy 1.0 -sz 22 `
    -parent "Foundation"
Set-Material -name "Foundation-Base" `
    -color @{r=0.7; g=0.65; b=0.60} -metallic 0.0 -smoothness 0.3

# Foundation corners with decorative stones
for ($i = 0; $i -lt 4; $i++) {
    $cornerX = (($i % 2) * 22 - 11)
    $cornerZ = (($i / 2) * 22 - 11)
    Build-ColoredObject -name "Foundation-Corner$i" -type "Cube" `
        -x $cornerX -y 1.2 -z $cornerZ `
        -sx 1.5 -sy 1.4 -sz 1.5 `
        -parent "Foundation"
    Set-Material -name "Foundation-Corner$i" `
        -color @{r=0.8; g=0.75; b=0.70} -metallic 0.0 -smoothness 0.4
}

$global:objectCount += 5
Write-Host "  [OK] Foundation complete: $global:objectCount objects" -ForegroundColor Green
Write-Host ""

# ============================================================
# GROUND FLOOR CONSTRUCTION
# ============================================================

Write-Host "[PHASE 2] Building Ground Floor..." -ForegroundColor Yellow
New-Group -name "GroundFloor" -parent "LuxuryVilla"
New-Group -name "GF-Walls" -parent "GroundFloor"
New-Group -name "GF-Columns" -parent "GroundFloor"
New-Group -name "GF-Rooms" -parent "GroundFloor"

# Exterior walls (4 main walls with openings)
# Front wall (with grand entrance)
for ($i = 0; $i -lt 5; $i++) {
    if ($i -ne 2) {  # Skip center for door
        $wallX = -10 + ($i * 5)
        Build-ColoredObject -name "GF-FrontWall-$i" -type "Cube" `
            -x $wallX -y 4 -z -10 `
            -sx 4.5 -sy 6 -sz 0.4 `
            -parent "GF-Walls"
        Set-Material -name "GF-FrontWall-$i" `
            -color @{r=0.95; g=0.90; b=0.85} -metallic 0.0 -smoothness 0.4
        $global:objectCount++
    }
}

# Back wall (solid)
for ($i = 0; $i -lt 5; $i++) {
    $wallX = -10 + ($i * 5)
    Build-ColoredObject -name "GF-BackWall-$i" -type "Cube" `
        -x $wallX -y 4 -z 10 `
        -sx 4.5 -sy 6 -sz 0.4 `
        -parent "GF-Walls"
    Set-Material -name "GF-BackWall-$i" `
        -color @{r=0.95; g=0.90; b=0.85} -metallic 0.0 -smoothness 0.4
    $global:objectCount++
}

# Left wall (with windows)
for ($i = 0; $i -lt 5; $i++) {
    $wallZ = -10 + ($i * 5)
    Build-ColoredObject -name "GF-LeftWall-$i" -type "Cube" `
        -x -10 -y 4 -z $wallZ -ry 90 `
        -sx 4.5 -sy 6 -sz 0.4 `
        -parent "GF-Walls"
    Set-Material -name "GF-LeftWall-$i" `
        -color @{r=0.95; g=0.90; b=0.85} -metallic 0.0 -smoothness 0.4
    $global:objectCount++
}

# Right wall (with windows)
for ($i = 0; $i -lt 5; $i++) {
    $wallZ = -10 + ($i * 5)
    Build-ColoredObject -name "GF-RightWall-$i" -type "Cube" `
        -x 10 -y 4 -z $wallZ -ry 90 `
        -sx 4.5 -sy 6 -sz 0.4 `
        -parent "GF-Walls"
    Set-Material -name "GF-RightWall-$i" `
        -color @{r=0.95; g=0.90; b=0.85} -metallic 0.0 -smoothness 0.4
    $global:objectCount++
}

# Grand entrance with columns
Build-Door -name "GF-MainDoor" -x 0 -y 2.5 -z -10.3 -parent "GF-Walls"
Build-Column -name "GF-EntranceCol-L" -x -2 -y 4 -z -10.5 -height 6 -parent "GF-Columns"
Build-Column -name "GF-EntranceCol-R" -x 2 -y 4 -z -10.5 -height 6 -parent "GF-Columns"

# Decorative arch above entrance
Build-ColoredObject -name "GF-EntranceArch" -type "Cube" `
    -x 0 -y 6.5 -z -10.3 `
    -sx 5 -sy 0.5 -sz 0.5 `
    -parent "GF-Walls"
Set-Material -name "GF-EntranceArch" `
    -color @{r=0.9; g=0.85; b=0.75} -metallic 0.0 -smoothness 0.5
$global:objectCount++

# Ground floor windows
Build-Window -name "GF-Window-L1" -x -10.3 -y 4 -z -5 -ry 90 -parent "GF-Walls"
Build-Window -name "GF-Window-L2" -x -10.3 -y 4 -z 0 -ry 90 -parent "GF-Walls"
Build-Window -name "GF-Window-L3" -x -10.3 -y 4 -z 5 -ry 90 -parent "GF-Walls"
Build-Window -name "GF-Window-R1" -x 10.3 -y 4 -z -5 -ry 90 -parent "GF-Walls"
Build-Window -name "GF-Window-R2" -x 10.3 -y 4 -z 0 -ry 90 -parent "GF-Walls"
Build-Window -name "GF-Window-R3" -x 10.3 -y 4 -z 5 -ry 90 -parent "GF-Walls"

# Interior floor
Build-ColoredObject -name "GF-Floor" -type "Cube" `
    -x 0 -y 1.1 -z 0 `
    -sx 19.5 -sy 0.2 -sz 19.5 `
    -parent "GroundFloor"
Set-Material -name "GF-Floor" `
    -color @{r=0.82; g=0.75; b=0.65} -metallic 0.0 -smoothness 0.6
$global:objectCount++

# Grand foyer room
New-Group -name "GF-Foyer" -parent "GF-Rooms"
Build-Chandelier -name "GF-Foyer-Light" -x 0 -y 6.5 -z -5 -parent "GF-Foyer"
$global:roomCount++

# Living room (left side)
New-Group -name "GF-LivingRoom" -parent "GF-Rooms"
Build-Furniture-Set -roomName "GF-Living" -x -5 -y 1.1 -z 0 -parent "GF-LivingRoom"
Build-Chandelier -name "GF-Living-Light" -x -5 -y 6.5 -z 0 -parent "GF-LivingRoom"
$global:roomCount++

# Dining room (right side)
New-Group -name "GF-DiningRoom" -parent "GF-Rooms"
Build-Furniture-Set -roomName "GF-Dining" -x 5 -y 1.1 -z 0 -parent "GF-DiningRoom"
Build-Chandelier -name "GF-Dining-Light" -x 5 -y 6.5 -z 0 -parent "GF-DiningRoom"
$global:roomCount++

# Kitchen (back left)
New-Group -name "GF-Kitchen" -parent "GF-Rooms"
# Kitchen counter
Build-ColoredObject -name "GF-Kitchen-Counter" -type "Cube" `
    -x -5 -y 2 -z 7 `
    -sx 3 -sy 1.0 -sz 1.5 `
    -parent "GF-Kitchen"
Apply-Material -name "GF-Kitchen-Counter" -materialName "Concrete"
# Kitchen island
Build-ColoredObject -name "GF-Kitchen-Island" -type "Cube" `
    -x -5 -y 2 -z 4 `
    -sx 2.5 -sy 1.0 -sz 1.0 `
    -parent "GF-Kitchen"
Set-Material -name "GF-Kitchen-Island" `
    -color @{r=0.3; g=0.25; b=0.2} -metallic 0.0 -smoothness 0.5
$global:objectCount += 2
$global:roomCount++

Write-Host "  [OK] Ground floor complete: $global:roomCount rooms" -ForegroundColor Green
Write-Host ""

# ============================================================
# FIRST FLOOR CONSTRUCTION
# ============================================================

Write-Host "[PHASE 3] Building First Floor..." -ForegroundColor Yellow
New-Group -name "FirstFloor" -parent "LuxuryVilla"
New-Group -name "FF-Walls" -parent "FirstFloor"
New-Group -name "FF-Rooms" -parent "FirstFloor"
New-Group -name "FF-Balconies" -parent "FirstFloor"

# First floor platform
Build-ColoredObject -name "FF-Floor" -type "Cube" `
    -x 0 -y 7.5 -z 0 `
    -sx 19.5 -sy 0.3 -sz 19.5 `
    -parent "FirstFloor"
Set-Material -name "FF-Floor" `
    -color @{r=0.85; g=0.78; b=0.68} -metallic 0.0 -smoothness 0.5
$global:objectCount++

# Exterior walls (first floor)
for ($i = 0; $i -lt 5; $i++) {
    # Front wall
    $wallX = -10 + ($i * 5)
    Build-ColoredObject -name "FF-FrontWall-$i" -type "Cube" `
        -x $wallX -y 10.5 -z -10 `
        -sx 4.5 -sy 6 -sz 0.4 `
        -parent "FF-Walls"
    Set-Material -name "FF-FrontWall-$i" `
        -color @{r=0.93; g=0.88; b=0.83} -metallic 0.0 -smoothness 0.4
    
    # Back wall
    Build-ColoredObject -name "FF-BackWall-$i" -type "Cube" `
        -x $wallX -y 10.5 -z 10 `
        -sx 4.5 -sy 6 -sz 0.4 `
        -parent "FF-Walls"
    Set-Material -name "FF-BackWall-$i" `
        -color @{r=0.93; g=0.88; b=0.83} -metallic 0.0 -smoothness 0.4
    
    $global:objectCount += 2
}

# First floor windows (more windows than ground floor)
Build-Window -name "FF-Window-F1" -x -7.5 -y 10.5 -z -10.3 -parent "FF-Walls"
Build-Window -name "FF-Window-F2" -x -2.5 -y 10.5 -z -10.3 -parent "FF-Walls"
Build-Window -name "FF-Window-F3" -x 2.5 -y 10.5 -z -10.3 -parent "FF-Walls"
Build-Window -name "FF-Window-F4" -x 7.5 -y 10.5 -z -10.3 -parent "FF-Walls"
Build-Window -name "FF-Window-B1" -x -5 -y 10.5 -z 10.3 -parent "FF-Walls"
Build-Window -name "FF-Window-B2" -x 5 -y 10.5 -z 10.3 -parent "FF-Walls"

# Bedroom 1 (front left)
New-Group -name "FF-Bedroom1" -parent "FF-Rooms"
# Bed
Build-ColoredObject -name "FF-Bed1-Frame" -type "Cube" `
    -x -5 -y 8.5 -z -5 `
    -sx 2.5 -sy 1.0 -sz 3.5 `
    -parent "FF-Bedroom1"
Apply-Material -name "FF-Bed1-Frame" -materialName "Wood_Oak"
Build-ColoredObject -name "FF-Bed1-Mattress" -type "Cube" `
    -x -5 -y 9.0 -z -5 `
    -sx 2.3 -sy 0.4 -sz 3.3 `
    -parent "FF-Bedroom1"
Set-Material -name "FF-Bed1-Mattress" `
    -color @{r=0.9; g=0.85; b=0.8} -metallic 0.0 -smoothness 0.3
$global:objectCount += 2
$global:roomCount++

# Bedroom 2 (front right)
New-Group -name "FF-Bedroom2" -parent "FF-Rooms"
Build-ColoredObject -name "FF-Bed2-Frame" -type "Cube" `
    -x 5 -y 8.5 -z -5 `
    -sx 2.5 -sy 1.0 -sz 3.5 `
    -parent "FF-Bedroom2"
Apply-Material -name "FF-Bed2-Frame" -materialName "Wood_Oak"
Build-ColoredObject -name "FF-Bed2-Mattress" -type "Cube" `
    -x 5 -y 9.0 -z -5 `
    -sx 2.3 -sy 0.4 -sz 3.3 `
    -parent "FF-Bedroom2"
Set-Material -name "FF-Bed2-Mattress" `
    -color @{r=0.8; g=0.9; b=0.85} -metallic 0.0 -smoothness 0.3
$global:objectCount += 2
$global:roomCount++

# Master bedroom (back center)
New-Group -name "FF-MasterBedroom" -parent "FF-Rooms"
Build-ColoredObject -name "FF-MasterBed-Frame" -type "Cube" `
    -x 0 -y 8.5 -z 7 `
    -sx 3.5 -sy 1.2 -sz 4.0 `
    -parent "FF-MasterBedroom"
Apply-Material -name "FF-MasterBed-Frame" -materialName "Wood_Oak"
Build-ColoredObject -name "FF-MasterBed-Mattress" -type "Cube" `
    -x 0 -y 9.2 -z 7 `
    -sx 3.3 -sy 0.5 -sz 3.8 `
    -parent "FF-MasterBedroom"
Set-Material -name "FF-MasterBed-Mattress" `
    -color @{r=0.85; g=0.8; b=0.9} -metallic 0.0 -smoothness 0.4
# Nightstands
Build-ColoredObject -name "FF-Nightstand-L" -type "Cube" `
    -x -2.5 -y 8 -z 7 `
    -sx 0.6 -sy 0.8 -sz 0.6 `
    -parent "FF-MasterBedroom"
Apply-Material -name "FF-Nightstand-L" -materialName "Wood_Oak"
Build-ColoredObject -name "FF-Nightstand-R" -type "Cube" `
    -x 2.5 -y 8 -z 7 `
    -sx 0.6 -sy 0.8 -sz 0.6 `
    -parent "FF-MasterBedroom"
Apply-Material -name "FF-Nightstand-R" -materialName "Wood_Oak"
$global:objectCount += 4
$global:roomCount++

# Balconies
Build-Balcony -name "FF-Balcony-Front" -x 0 -y 7.5 -z -12 -width 8 -depth 2 -parent "FF-Balconies"
Build-Balcony -name "FF-Balcony-Left" -x -12 -y 7.5 -z 0 -width 8 -depth 2 -ry 90 -parent "FF-Balconies"

Write-Host "  [OK] First floor complete: $global:roomCount total rooms" -ForegroundColor Green
Write-Host ""

# ============================================================
# SECOND FLOOR / ROOF TERRACE
# ============================================================

Write-Host "[PHASE 4] Building Second Floor & Roof..." -ForegroundColor Yellow
New-Group -name "SecondFloor" -parent "LuxuryVilla"
New-Group -name "SF-Terrace" -parent "SecondFloor"

# Second floor platform (smaller - terrace style)
Build-ColoredObject -name "SF-Floor" -type "Cube" `
    -x 0 -y 14 -z 0 `
    -sx 15 -sy 0.3 -sz 15 `
    -parent "SecondFloor"
Set-Material -name "SF-Floor" `
    -color @{r=0.75; g=0.70; b=0.65} -metallic 0.0 -smoothness 0.3
$global:objectCount++

# Terrace railings
for ($side = 0; $side -lt 4; $side++) {
    $angle = $side * 90
    $x = [Math]::Cos($angle * [Math]::PI / 180) * 7.5
    $z = [Math]::Sin($angle * [Math]::PI / 180) * 7.5
    
    for ($i = 0; $i -lt 8; $i++) {
        $offset = ($i - 3.5) * 1.8
        $railX = $x + [Math]::Cos(($angle + 90) * [Math]::PI / 180) * $offset
        $railZ = $z + [Math]::Sin(($angle + 90) * [Math]::PI / 180) * $offset
        
        Build-ColoredObject -name "SF-Rail-$side-$i" -type "Cylinder" `
            -x $railX -y 14.6 -z $railZ `
            -sx 0.08 -sy 0.6 -sz 0.08 `
            -parent "SF-Terrace"
        Apply-Material -name "SF-Rail-$side-$i" -materialName "Metal_Steel"
        $global:objectCount++
    }
}

# Penthouse structure (central)
New-Group -name "SF-Penthouse" -parent "SecondFloor"
# Walls
Build-ColoredObject -name "SF-PH-FrontWall" -type "Cube" `
    -x 0 -y 16 -z -5 `
    -sx 8 -sy 3 -sz 0.3 `
    -parent "SF-Penthouse"
Set-Material -name "SF-PH-FrontWall" `
    -color @{r=0.90; g=0.85; b=0.80} -metallic 0.0 -smoothness 0.5
Build-ColoredObject -name "SF-PH-BackWall" -type "Cube" `
    -x 0 -y 16 -z 5 `
    -sx 8 -sy 3 -sz 0.3 `
    -parent "SF-Penthouse"
Set-Material -name "SF-PH-BackWall" `
    -color @{r=0.90; g=0.85; b=0.80} -metallic 0.0 -smoothness 0.5
Build-ColoredObject -name "SF-PH-LeftWall" -type "Cube" `
    -x -4 -y 16 -z 0 -ry 90 `
    -sx 10 -sy 3 -sz 0.3 `
    -parent "SF-Penthouse"
Set-Material -name "SF-PH-LeftWall" `
    -color @{r=0.90; g=0.85; b=0.80} -metallic 0.0 -smoothness 0.5
Build-ColoredObject -name "SF-PH-RightWall" -type "Cube" `
    -x 4 -y 16 -z 0 -ry 90 `
    -sx 10 -sy 3 -sz 0.3 `
    -parent "SF-Penthouse"
Set-Material -name "SF-PH-RightWall" `
    -color @{r=0.90; g=0.85; b=0.80} -metallic 0.0 -smoothness 0.5
$global:objectCount += 4

# Penthouse door
Build-Door -name "SF-PH-Door" -x 0 -y 15 -z -5.2 -parent "SF-Penthouse"

# Penthouse windows
Build-Window -name "SF-PH-Window-L" -x -4.2 -y 16 -z 0 -ry 90 -parent "SF-Penthouse"
Build-Window -name "SF-PH-Window-R" -x 4.2 -y 16 -z 0 -ry 90 -parent "SF-Penthouse"
$global:roomCount++

# Roof structure
Build-ColoredObject -name "SF-Roof" -type "Cube" `
    -x 0 -y 18 -z 0 -rx 15 `
    -sx 9 -sy 0.2 -sz 11 `
    -parent "SecondFloor"
Set-Material -name "SF-Roof" `
    -color @{r=0.7; g=0.3; b=0.2} -metallic 0.0 -smoothness 0.4
$global:objectCount++

# Chimney
Build-ColoredObject -name "SF-Chimney-Base" -type "Cube" `
    -x 3 -y 19 -z 0 `
    -sx 1.2 -sy 2 -sz 1.2 `
    -parent "SecondFloor"
Set-Material -name "SF-Chimney-Base" `
    -color @{r=0.6; g=0.3; b=0.2} -metallic 0.0 -smoothness 0.3
Build-ColoredObject -name "SF-Chimney-Top" -type "Cube" `
    -x 3 -y 20.5 -z 0 `
    -sx 1.5 -sy 0.3 -sz 1.5 `
    -parent "SecondFloor"
Set-Material -name "SF-Chimney-Top" `
    -color @{r=0.5; g=0.25; b=0.15} -metallic 0.0 -smoothness 0.3
$global:objectCount += 2

Write-Host "  [OK] Second floor & roof complete" -ForegroundColor Green
Write-Host ""

# ============================================================
# STAIRS BETWEEN FLOORS
# ============================================================

Write-Host "[PHASE 5] Building Staircases..." -ForegroundColor Yellow
New-Group -name "Staircases" -parent "LuxuryVilla"

# Ground to first floor stairs
Build-Stairs -name "Stairs-GF-FF" -x -7 -y 1.5 -z 7 -steps 12 -parent "Staircases"

# First to second floor stairs
Build-Stairs -name "Stairs-FF-SF" -x 7 -y 7.8 -z 7 -steps 12 -parent "Staircases"

Write-Host "  [OK] Staircases complete" -ForegroundColor Green
Write-Host ""

# ============================================================
# EXTERIOR GARDENS & LANDSCAPING
# ============================================================

Write-Host "[PHASE 6] Creating Gardens & Landscaping..." -ForegroundColor Yellow
New-Group -name "Gardens" -parent "LuxuryVilla"
New-Group -name "Garden-Front" -parent "Gardens"
New-Group -name "Garden-Features" -parent "Gardens"

# Front garden path
for ($i = 0; $i -lt 10; $i++) {
    Build-ColoredObject -name "Garden-Path-$i" -type "Cube" `
        -x 0 -y 0.05 -z (-15 - $i * 1.5) `
        -sx 2.5 -sy 0.05 -sz 1.3 `
        -parent "Garden-Front"
    Set-Material -name "Garden-Path-$i" `
        -color @{r=0.65; g=0.60; b=0.55} -metallic 0.0 -smoothness 0.3
    $global:objectCount++
}

# Garden trees (cypress style)
for ($i = 0; $i -lt 6; $i++) {
    $treeX = (($i % 2) * 16 - 8)
    $treeZ = -18 - (($i / 2) * 6)
    
    # Trunk
    Build-ColoredObject -name "Garden-Tree$i-Trunk" -type "Cylinder" `
        -x $treeX -y 2 -z $treeZ `
        -sx 0.3 -sy 2 -sz 0.3 `
        -parent "Garden-Front"
    Apply-Material -name "Garden-Tree$i-Trunk" -materialName "Wood_Oak"
    
    # Foliage (cone shaped)
    Build-ColoredObject -name "Garden-Tree$i-Foliage1" -type "Sphere" `
        -x $treeX -y 4.5 -z $treeZ `
        -sx 1.5 -sy 2.5 -sz 1.5 `
        -parent "Garden-Front"
    Set-Material -name "Garden-Tree$i-Foliage1" `
        -color @{r=0.1; g=0.5; b=0.2} -metallic 0.0 -smoothness 0.3
    
    $global:objectCount += 2
}

# Decorative fountain (front center)
New-Group -name "Garden-Fountain" -parent "Garden-Features"
# Fountain base
Build-ColoredObject -name "Fountain-Base" -type "Cylinder" `
    -x 0 -y 0.5 -z -25 `
    -sx 3 -sy 0.5 -sz 3 `
    -parent "Garden-Fountain"
Set-Material -name "Fountain-Base" `
    -color @{r=0.85; g=0.82; b=0.78} -metallic 0.0 -smoothness 0.6
# Fountain bowl
Build-ColoredObject -name "Fountain-Bowl" -type "Cylinder" `
    -x 0 -y 1.5 -z -25 `
    -sx 2.5 -sy 0.8 -sz 2.5 `
    -parent "Garden-Fountain"
Set-Material -name "Fountain-Bowl" `
    -color @{r=0.88; g=0.85; b=0.80} -metallic 0.0 -smoothness 0.7
# Fountain center piece
Build-ColoredObject -name "Fountain-Center" -type "Sphere" `
    -x 0 -y 2.5 -z -25 `
    -sx 0.8 -sy 0.8 -sz 0.8 `
    -parent "Garden-Fountain"
Set-Material -name "Fountain-Center" `
    -color @{r=0.6; g=0.8; b=0.9} `
    -emission @{r=0.4; g=0.7; b=1.0; intensity=1.5}
$global:objectCount += 3

# Garden lights (lamp posts)
for ($i = 0; $i -lt 4; $i++) {
    $lampX = (($i % 2) * 14 - 7)
    $lampZ = -16 - (($i / 2) * 10)
    
    # Post
    Build-ColoredObject -name "Garden-Lamp$i-Post" -type "Cylinder" `
        -x $lampX -y 2 -z $lampZ `
        -sx 0.15 -sy 2 -sz 0.15 `
        -parent "Garden-Features"
    Apply-Material -name "Garden-Lamp$i-Post" -materialName "Metal_Bronze"
    
    # Light
    Build-ColoredObject -name "Garden-Lamp$i-Light" -type "Sphere" `
        -x $lampX -y 4.2 -z $lampZ `
        -sx 0.5 -sy 0.5 -sz 0.5 `
        -parent "Garden-Features"
    Set-Material -name "Garden-Lamp$i-Light" `
        -color @{r=1.0; g=0.95; b=0.8} `
        -emission @{r=1.0; g=0.9; b=0.7; intensity=2.0}
    
    $global:objectCount += 2
}

# Garden hedge walls (decorative)
for ($i = 0; $i -lt 8; $i++) {
    $hedgeX = -14 + ($i * 4)
    Build-ColoredObject -name "Garden-Hedge$i" -type "Cube" `
        -x $hedgeX -y 1 -z -32 `
        -sx 3.5 -sy 2 -sz 1.0 `
        -parent "Garden-Features"
    Set-Material -name "Garden-Hedge$i" `
        -color @{r=0.15; g=0.45; b=0.2} -metallic 0.0 -smoothness 0.2
    $global:objectCount++
}

# Decorative planters at entrance
for ($i = 0; $i -lt 2; $i++) {
    $planterX = (($i * 2) - 1) * 5
    
    # Planter box
    Build-ColoredObject -name "Entrance-Planter$i-Box" -type "Cube" `
        -x $planterX -y 1 -z -12 `
        -sx 1.2 -sy 1.0 -sz 1.2 `
        -parent "Garden-Features"
    Set-Material -name "Entrance-Planter$i-Box" `
        -color @{r=0.6; g=0.3; b=0.2} -metallic 0.0 -smoothness 0.3
    
    # Plant
    Build-ColoredObject -name "Entrance-Planter$i-Plant" -type "Sphere" `
        -x $planterX -y 2.2 -z -12 `
        -sx 0.8 -sy 1.2 -sz 0.8 `
        -parent "Garden-Features"
    Set-Material -name "Entrance-Planter$i-Plant" `
        -color @{r=0.2; g=0.6; b=0.3} -metallic 0.0 -smoothness 0.3
    
    $global:objectCount += 2
}

Write-Host "  [OK] Gardens complete" -ForegroundColor Green
Write-Host ""

# ============================================================
# ARCHITECTURAL DETAILS
# ============================================================

Write-Host "[PHASE 7] Adding Architectural Details..." -ForegroundColor Yellow
New-Group -name "Details" -parent "LuxuryVilla"

# Cornices (decorative trim) on ground floor
for ($i = 0; $i -lt 20; $i++) {
    $x = -10 + ($i * 1)
    Build-ColoredObject -name "Detail-Cornice-F-$i" -type "Cube" `
        -x $x -y 7 -z -10.5 `
        -sx 1.2 -sy 0.3 -sz 0.3 `
        -parent "Details"
    Set-Material -name "Detail-Cornice-F-$i" `
        -color @{r=0.92; g=0.88; b=0.82} -metallic 0.0 -smoothness 0.5
    $global:objectCount++
}

# Decorative pilasters on corners
for ($corner = 0; $corner -lt 4; $corner++) {
    $cornerX = (($corner % 2) * 20 - 10)
    $cornerZ = (($corner / 2) * 20 - 10)
    
    for ($level = 0; $level -lt 2; $level++) {
        $y = 4 + ($level * 6.5)
        Build-ColoredObject -name "Detail-Pilaster-$corner-$level" -type "Cube" `
            -x $cornerX -y $y -z $cornerZ `
            -sx 0.6 -sy 6 -sz 0.6 `
            -parent "Details"
        Set-Material -name "Detail-Pilaster-$corner-$level" `
            -color @{r=0.88; g=0.83; b=0.78} -metallic 0.0 -smoothness 0.4
        $global:objectCount++
    }
}

# Window shutters
$shutterPositions = @(
    @{name="GF-L1"; x=-10.5; y=4; z=-5; ry=90},
    @{name="GF-L2"; x=-10.5; y=4; z=0; ry=90},
    @{name="GF-L3"; x=-10.5; y=4; z=5; ry=90},
    @{name="GF-R1"; x=10.5; y=4; z=-5; ry=90},
    @{name="GF-R2"; x=10.5; y=4; z=0; ry=90},
    @{name="GF-R3"; x=10.5; y=4; z=5; ry=90}
)

foreach ($pos in $shutterPositions) {
    # Left shutter
    Build-ColoredObject -name "Shutter-$($pos.name)-L" -type "Cube" `
        -x ($pos.x) -y ($pos.y) -z ($pos.z - 1.2) -ry ($pos.ry) `
        -sx 0.9 -sy 2.3 -sz 0.1 `
        -parent "Details"
    Set-Material -name "Shutter-$($pos.name)-L" `
        -color @{r=0.2; g=0.4; b=0.3} -metallic 0.0 -smoothness 0.3
    
    # Right shutter
    Build-ColoredObject -name "Shutter-$($pos.name)-R" -type "Cube" `
        -x ($pos.x) -y ($pos.y) -z ($pos.z + 1.2) -ry ($pos.ry) `
        -sx 0.9 -sy 2.3 -sz 0.1 `
        -parent "Details"
    Set-Material -name "Shutter-$($pos.name)-R" `
        -color @{r=0.2; g=0.4; b=0.3} -metallic 0.0 -smoothness 0.3
    
    $global:objectCount += 2
}

Write-Host "  [OK] Architectural details complete" -ForegroundColor Green
Write-Host ""

# ============================================================
# FINAL SUMMARY
# ============================================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  VILLA CONSTRUCTION COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Statistics:" -ForegroundColor Cyan
Write-Host "  Total Objects: $global:objectCount" -ForegroundColor White
Write-Host "  Total Rooms: $global:roomCount" -ForegroundColor White
Write-Host "  Floors: 3 (Ground, First, Second/Terrace)" -ForegroundColor White
Write-Host ""
Write-Host "Features:" -ForegroundColor Cyan
Write-Host "  ✓ Grand entrance with columns" -ForegroundColor White
Write-Host "  ✓ Multiple bedrooms with furniture" -ForegroundColor White
Write-Host "  ✓ Living room, dining room, kitchen" -ForegroundColor White
Write-Host "  ✓ Balconies with railings" -ForegroundColor White
Write-Host "  ✓ Roof terrace and penthouse" -ForegroundColor White
Write-Host "  ✓ Internal staircases" -ForegroundColor White
Write-Host "  ✓ Chandeliers and lighting" -ForegroundColor White
Write-Host "  ✓ Garden with fountain" -ForegroundColor White
Write-Host "  ✓ Trees and landscaping" -ForegroundColor White
Write-Host "  ✓ Decorative details and trim" -ForegroundColor White
Write-Host "  ✓ PBR materials throughout" -ForegroundColor White
Write-Host ""
Write-Host "Recommended Camera Position:" -ForegroundColor Cyan
Write-Host "  Position: (0, 12, -35)" -ForegroundColor White
Write-Host "  Rotation: (15, 0, 0)" -ForegroundColor White
Write-Host "  View: Full villa front view with gardens" -ForegroundColor White
Write-Host ""
Write-Host "Alternative Views:" -ForegroundColor Cyan
Write-Host "  Bird's Eye: (0, 40, 0) Rotation: (90, 0, 0)" -ForegroundColor White
Write-Host "  Ground Level: (0, 2, -40) Rotation: (0, 0, 0)" -ForegroundColor White
Write-Host "  Side View: (30, 15, 0) Rotation: (20, -90, 0)" -ForegroundColor White
Write-Host ""
Write-Host "This villa showcases ALL Unity MCP capabilities:" -ForegroundColor Green
Write-Host "  • Complex hierarchies and organization" -ForegroundColor Yellow
Write-Host "  • Custom PBR materials" -ForegroundColor Yellow
Write-Host "  • Material library integration" -ForegroundColor Yellow
Write-Host "  • Emissive lighting effects" -ForegroundColor Yellow
Write-Host "  • Diagonal connections and angles" -ForegroundColor Yellow
Write-Host "  • Reusable component functions" -ForegroundColor Yellow
Write-Host "  • Detailed architectural elements" -ForegroundColor Yellow
Write-Host ""
Write-Host "Enjoy your luxury villa! 🏰✨" -ForegroundColor Magenta
Write-Host ""
