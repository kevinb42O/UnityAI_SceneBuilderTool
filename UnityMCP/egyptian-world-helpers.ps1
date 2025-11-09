# ============================================================================
# Egyptian World Helper Functions - Advanced Construction Tools
# Essential tools for building complex ancient structures
# ============================================================================

# Import base helpers
. "$PSScriptRoot\unity-helpers-v2.ps1"

# ============================================================================
# ARCHITECTURAL ELEMENTS
# ============================================================================

function Build-Archway {
    <#
    .SYNOPSIS
    Creates an architectural archway/doorway
    
    .DESCRIPTION
    Builds a complete archway with pillars, lintel, and optional arch curvature
    
    .PARAMETER name
    Base name for the archway objects
    
    .PARAMETER x, y, z
    Position of the archway center
    
    .PARAMETER width
    Width of the opening (default: 4)
    
    .PARAMETER height
    Height of the opening (default: 6)
    
    .PARAMETER thickness
    Depth/thickness of the arch (default: 1)
    
    .PARAMETER rotation
    Y-axis rotation in degrees (default: 0)
    
    .PARAMETER archType
    Type of arch: "Square", "Rounded", "Pointed" (default: "Rounded")
    
    .PARAMETER color
    Color hashtable for the arch material
    
    .PARAMETER parent
    Parent group name
    
    .EXAMPLE
    Build-Archway -name "MainGate" -x 0 -y 0 -z 10 -width 5 -height 8
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$name,
        
        [float]$x = 0, [float]$y = 0, [float]$z = 0,
        [float]$width = 4,
        [float]$height = 6,
        [float]$thickness = 1,
        [float]$rotation = 0,
        [ValidateSet("Square", "Rounded", "Pointed")]
        [string]$archType = "Rounded",
        [hashtable]$color = @{ r = 0.90; g = 0.85; b = 0.75 },
        [string]$parent = ""
    )
    
    $objectsCreated = 0
    
    # Left pillar
    Build-ColoredObject -name "${name}_Pillar_L" -type "Cube" `
        -x ($x - $width/2 - 0.5) -y ($y + $height/2) -z $z `
        -ry $rotation `
        -sx 1 -sy $height -sz $thickness `
        -color $color -metallic 0.0 -smoothness 0.2 `
        -parent $parent
    $objectsCreated++
    
    # Right pillar
    Build-ColoredObject -name "${name}_Pillar_R" -type "Cube" `
        -x ($x + $width/2 + 0.5) -y ($y + $height/2) -z $z `
        -ry $rotation `
        -sx 1 -sy $height -sz $thickness `
        -color $color -metallic 0.0 -smoothness 0.2 `
        -parent $parent
    $objectsCreated++
    
    if ($archType -eq "Square") {
        # Simple lintel
        Build-ColoredObject -name "${name}_Lintel" -type "Cube" `
            -x $x -y ($y + $height + 0.5) -z $z `
            -ry $rotation `
            -sx ($width + 2) -sy 1 -sz $thickness `
            -color $color -metallic 0.0 -smoothness 0.2 `
            -parent $parent
        $objectsCreated++
    }
    elseif ($archType -eq "Rounded") {
        # Curved arch with segments
        $archSegments = 8
        for ($i = 0; $i -lt $archSegments; $i++) {
            $angle = ($i / ($archSegments - 1)) * [Math]::PI
            $archX = $x + ([Math]::Cos($angle - [Math]::PI/2) * $width/2)
            $archY = $y + $height + ([Math]::Sin($angle - [Math]::PI/2) * $width/2)
            
            Build-ColoredObject -name "${name}_Arch_$i" -type "Cube" `
                -x $archX -y $archY -z $z `
                -ry $rotation `
                -sx 0.8 -sy 0.5 -sz $thickness `
                -color $color -metallic 0.0 -smoothness 0.2 `
                -parent $parent
            $objectsCreated++
        }
    }
    elseif ($archType -eq "Pointed") {
        # Gothic/pointed arch
        # Left half
        for ($i = 0; $i -lt 5; $i++) {
            $t = $i / 4
            $archX = $x - ($width/2 * (1 - $t))
            $archY = $y + $height + ($width/2 * $t)
            
            Build-ColoredObject -name "${name}_Arch_L_$i" -type "Cube" `
                -x $archX -y $archY -z $z `
                -ry $rotation `
                -sx 0.8 -sy 0.5 -sz $thickness `
                -color $color -metallic 0.0 -smoothness 0.2 `
                -parent $parent
            $objectsCreated++
        }
        
        # Right half
        for ($i = 0; $i -lt 5; $i++) {
            $t = $i / 4
            $archX = $x + ($width/2 * (1 - $t))
            $archY = $y + $height + ($width/2 * $t)
            
            Build-ColoredObject -name "${name}_Arch_R_$i" -type "Cube" `
                -x $archX -y $archY -z $z `
                -ry $rotation `
                -sx 0.8 -sy 0.5 -sz $thickness `
                -color $color -metallic 0.0 -smoothness 0.2 `
                -parent $parent
            $objectsCreated++
        }
    }
    
    Write-Host "[ARCHWAY] Created $name ($archType, $objectsCreated objects)" -ForegroundColor Green
    return $objectsCreated
}

function Build-Staircase {
    <#
    .SYNOPSIS
    Creates a staircase
    
    .DESCRIPTION
    Builds a complete staircase with specified number of steps
    
    .PARAMETER name
    Base name for the staircase objects
    
    .PARAMETER x, y, z
    Starting position (bottom of stairs)
    
    .PARAMETER steps
    Number of steps (default: 10)
    
    .PARAMETER stepWidth
    Width of each step (default: 3)
    
    .PARAMETER stepDepth
    Depth of each step (default: 1)
    
    .PARAMETER stepHeight
    Height of each step (default: 0.5)
    
    .PARAMETER direction
    Direction stairs face: "North", "South", "East", "West" (default: "North")
    
    .PARAMETER color
    Color hashtable for the steps
    
    .PARAMETER parent
    Parent group name
    
    .EXAMPLE
    Build-Staircase -name "PyramidStairs" -x 0 -y 0 -z 0 -steps 20 -direction "North"
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$name,
        
        [float]$x = 0, [float]$y = 0, [float]$z = 0,
        [int]$steps = 10,
        [float]$stepWidth = 3,
        [float]$stepDepth = 1,
        [float]$stepHeight = 0.5,
        [ValidateSet("North", "South", "East", "West")]
        [string]$direction = "North",
        [hashtable]$color = @{ r = 0.35; g = 0.30; b = 0.25 },
        [string]$parent = ""
    )
    
    $rotation = switch ($direction) {
        "North" { 0 }
        "East"  { 90 }
        "South" { 180 }
        "West"  { 270 }
    }
    
    for ($i = 0; $i -lt $steps; $i++) {
        $stepX = $x
        $stepY = $y + ($i * $stepHeight) + ($stepHeight / 2)
        $stepZ = $z
        
        # Calculate position based on direction
        switch ($direction) {
            "North" { $stepZ = $z + ($i * $stepDepth) }
            "South" { $stepZ = $z - ($i * $stepDepth) }
            "East"  { $stepX = $x + ($i * $stepDepth) }
            "West"  { $stepX = $x - ($i * $stepDepth) }
        }
        
        Build-ColoredObject -name "${name}_Step_$i" -type "Cube" `
            -x $stepX -y $stepY -z $stepZ `
            -ry $rotation `
            -sx $stepWidth -sy $stepHeight -sz $stepDepth `
            -color $color -metallic 0.0 -smoothness 0.3 `
            -parent $parent
    }
    
    Write-Host "[STAIRCASE] Created $name ($steps steps)" -ForegroundColor Green
    return $steps
}

function Build-CircularWall {
    <#
    .SYNOPSIS
    Creates a circular wall or colonnade
    
    .DESCRIPTION
    Builds a circular arrangement of pillars or wall segments
    
    .PARAMETER name
    Base name for the wall objects
    
    .PARAMETER x, y, z
    Center position
    
    .PARAMETER radius
    Radius of the circle (default: 10)
    
    .PARAMETER segments
    Number of wall segments or pillars (default: 12)
    
    .PARAMETER height
    Height of the wall/pillars (default: 8)
    
    .PARAMETER thickness
    Thickness of wall segments (default: 0.5)
    
    .PARAMETER wallType
    Type: "Solid", "Pillars", "Gaps" (default: "Pillars")
    
    .PARAMETER color
    Color hashtable
    
    .PARAMETER parent
    Parent group name
    
    .EXAMPLE
    Build-CircularWall -name "ArenaWall" -x 0 -y 0 -z 0 -radius 20 -segments 16 -wallType "Pillars"
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$name,
        
        [float]$x = 0, [float]$y = 0, [float]$z = 0,
        [float]$radius = 10,
        [int]$segments = 12,
        [float]$height = 8,
        [float]$thickness = 0.5,
        [ValidateSet("Solid", "Pillars", "Gaps")]
        [string]$wallType = "Pillars",
        [hashtable]$color = @{ r = 0.90; g = 0.85; b = 0.75 },
        [string]$parent = ""
    )
    
    for ($i = 0; $i -lt $segments; $i++) {
        $angle = ($i / $segments) * 2 * [Math]::PI
        $segX = $x + ([Math]::Cos($angle) * $radius)
        $segZ = $z + ([Math]::Sin($angle) * $radius)
        $segRotation = ($angle * 180 / [Math]::PI) + 90
        
        if ($wallType -eq "Pillars") {
            # Create pillar
            Build-ColoredObject -name "${name}_Pillar_$i" -type "Cylinder" `
                -x $segX -y ($y + $height/2) -z $segZ `
                -sx ($thickness * 2) -sy ($height/2) -sz ($thickness * 2) `
                -color $color -metallic 0.0 -smoothness 0.2 `
                -parent $parent
        }
        elseif ($wallType -eq "Solid") {
            # Create wall segment
            $segmentWidth = (2 * [Math]::PI * $radius) / $segments
            Build-ColoredObject -name "${name}_Segment_$i" -type "Cube" `
                -x $segX -y ($y + $height/2) -z $segZ `
                -ry $segRotation `
                -sx $segmentWidth -sy $height -sz $thickness `
                -color $color -metallic 0.0 -smoothness 0.2 `
                -parent $parent
        }
        elseif ($wallType -eq "Gaps") {
            # Create wall with gaps (every other segment)
            if ($i % 2 -eq 0) {
                $segmentWidth = (2 * [Math]::PI * $radius) / $segments
                Build-ColoredObject -name "${name}_Segment_$i" -type "Cube" `
                    -x $segX -y ($y + $height/2) -z $segZ `
                    -ry $segRotation `
                    -sx $segmentWidth -sy $height -sz $thickness `
                    -color $color -metallic 0.0 -smoothness 0.2 `
                    -parent $parent
            }
        }
    }
    
    Write-Host "[CIRCULAR WALL] Created $name ($segments segments, $wallType)" -ForegroundColor Green
    return $segments
}

function Build-Colonnade {
    <#
    .SYNOPSIS
    Creates a colonnade (row of columns with roof)
    
    .DESCRIPTION
    Builds a series of columns with connecting roof structure
    
    .PARAMETER name
    Base name for the colonnade objects
    
    .PARAMETER x1, z1, x2, z2
    Start and end positions
    
    .PARAMETER y
    Ground level (default: 0)
    
    .PARAMETER columns
    Number of columns (default: 8)
    
    .PARAMETER columnHeight
    Height of columns (default: 10)
    
    .PARAMETER columnRadius
    Radius of columns (default: 0.5)
    
    .PARAMETER roofThickness
    Thickness of roof (default: 0.5)
    
    .PARAMETER color
    Color hashtable
    
    .PARAMETER parent
    Parent group name
    
    .EXAMPLE
    Build-Colonnade -name "TempleColonnade" -x1 -20 -z1 0 -x2 20 -z2 0 -columns 10
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$name,
        
        [float]$x1, [float]$z1,
        [float]$x2, [float]$z2,
        [float]$y = 0,
        [int]$columns = 8,
        [float]$columnHeight = 10,
        [float]$columnRadius = 0.5,
        [float]$roofThickness = 0.5,
        [hashtable]$color = @{ r = 0.90; g = 0.85; b = 0.75 },
        [string]$parent = ""
    )
    
    # Create columns
    for ($i = 0; $i -lt $columns; $i++) {
        $t = $i / ($columns - 1)
        $colX = $x1 + (($x2 - $x1) * $t)
        $colZ = $z1 + (($z2 - $z1) * $t)
        
        # Column base
        Build-ColoredObject -name "${name}_Column_${i}_Base" -type "Cylinder" `
            -x $colX -y ($y + 0.5) -z $colZ `
            -sx ($columnRadius * 1.5) -sy 0.5 -sz ($columnRadius * 1.5) `
            -color $color -metallic 0.0 -smoothness 0.3 `
            -parent $parent
        
        # Column shaft
        Build-ColoredObject -name "${name}_Column_${i}_Shaft" -type "Cylinder" `
            -x $colX -y ($y + $columnHeight/2) -z $colZ `
            -sx $columnRadius -sy ($columnHeight/2) -sz $columnRadius `
            -color $color -metallic 0.0 -smoothness 0.2 `
            -parent $parent
        
        # Column capital
        Build-ColoredObject -name "${name}_Column_${i}_Capital" -type "Cylinder" `
            -x $colX -y ($y + $columnHeight - 0.5) -z $colZ `
            -sx ($columnRadius * 1.5) -sy 0.5 -sz ($columnRadius * 1.5) `
            -color $color -metallic 0.0 -smoothness 0.3 `
            -parent $parent
    }
    
    # Create roof
    $length = [Math]::Sqrt([Math]::Pow($x2 - $x1, 2) + [Math]::Pow($z2 - $z1, 2))
    $midX = ($x1 + $x2) / 2
    $midZ = ($z1 + $z2) / 2
    $angle = [Math]::Atan2($x2 - $x1, $z2 - $z1) * 180 / [Math]::PI
    
    Build-ColoredObject -name "${name}_Roof" -type "Cube" `
        -x $midX -y ($y + $columnHeight + $roofThickness/2) -z $midZ `
        -ry $angle `
        -sx ($columnRadius * 4) -sy $roofThickness -sz $length `
        -color $color -metallic 0.0 -smoothness 0.2 `
        -parent $parent
    
    $objectsCreated = ($columns * 3) + 1
    Write-Host "[COLONNADE] Created $name ($columns columns)" -ForegroundColor Green
    return $objectsCreated
}

function Build-Brazier {
    <#
    .SYNOPSIS
    Creates a decorative brazier with fire
    
    .DESCRIPTION
    Builds a standing brazier with emissive flame
    
    .PARAMETER name
    Name for the brazier
    
    .PARAMETER x, y, z
    Position
    
    .PARAMETER height
    Height of the stand (default: 4)
    
    .PARAMETER flameIntensity
    Emission intensity (default: 2.0)
    
    .PARAMETER parent
    Parent group name
    
    .EXAMPLE
    Build-Brazier -name "EntranceFire" -x 10 -y 0 -z 5
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$name,
        
        [float]$x = 0, [float]$y = 0, [float]$z = 0,
        [float]$height = 4,
        [float]$flameIntensity = 2.0,
        [string]$parent = ""
    )
    
    # Stand
    Build-ColoredObject -name "${name}_Stand" -type "Cylinder" `
        -x $x -y ($y + $height/2) -z $z `
        -sx 0.3 -sy ($height/2) -sz 0.3 `
        -color @{ r = 0.3; g = 0.2; b = 0.1 } `
        -metallic 0.0 -smoothness 0.1 `
        -parent $parent
    
    # Bowl
    Build-ColoredObject -name "${name}_Bowl" -type "Cylinder" `
        -x $x -y ($y + $height + 0.3) -z $z `
        -sx 0.8 -sy 0.3 -sz 0.8 `
        -color @{ r = 0.4; g = 0.3; b = 0.2 } `
        -metallic 0.3 -smoothness 0.2 `
        -parent $parent
    
    # Flame
    Build-ColoredObject -name "${name}_Flame" -type "Sphere" `
        -x $x -y ($y + $height + 1) -z $z `
        -sx 0.6 -sy 0.8 -sz 0.6 `
        -parent $parent
    Set-Material -name "${name}_Flame" `
        -emission @{ r = 1.0; g = 0.5; b = 0.0; intensity = $flameIntensity }
    
    Write-Host "[BRAZIER] Created $name" -ForegroundColor Green
    return 3
}

# ============================================================================
# TERRAIN HELPERS
# ============================================================================

function Build-TerrainMound {
    <#
    .SYNOPSIS
    Creates a terrain mound or hill
    
    .DESCRIPTION
    Builds a rounded mound using stacked spheres
    
    .PARAMETER name
    Name for the mound
    
    .PARAMETER x, y, z
    Base position
    
    .PARAMETER width, height, depth
    Dimensions (default: 20, 8, 20)
    
    .PARAMETER color
    Color hashtable
    
    .PARAMETER parent
    Parent group name
    
    .EXAMPLE
    Build-TerrainMound -name "Hill1" -x 50 -y 0 -z 50 -width 30 -height 10
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$name,
        
        [float]$x = 0, [float]$y = 0, [float]$z = 0,
        [float]$width = 20,
        [float]$height = 8,
        [float]$depth = 20,
        [hashtable]$color = @{ r = 0.76; g = 0.60; b = 0.42 },
        [string]$parent = ""
    )
    
    # Create base
    Build-ColoredObject -name "${name}_Base" -type "Sphere" `
        -x $x -y ($y + $height/3) -z $z `
        -sx $width -sy $height -sz $depth `
        -color $color -metallic 0.0 -smoothness 0.1 `
        -parent $parent
    
    Write-Host "[MOUND] Created $name" -ForegroundColor Green
    return 1
}

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

function Copy-Object {
    <#
    .SYNOPSIS
    Duplicates an existing object
    
    .DESCRIPTION
    Creates a copy of an existing Unity object at a new position
    
    .PARAMETER sourceName
    Name of object to copy
    
    .PARAMETER newName
    Name for the new copy
    
    .PARAMETER offsetX, offsetY, offsetZ
    Position offset from original (default: 0, 0, 0)
    
    .EXAMPLE
    Copy-Object -sourceName "Pyramid1" -newName "Pyramid2" -offsetX 100
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$sourceName,
        
        [Parameter(Mandatory=$true)]
        [string]$newName,
        
        [float]$offsetX = 0,
        [float]$offsetY = 0,
        [float]$offsetZ = 0
    )
    
    $body = @{
        sourceName = $sourceName
        newName = $newName
        offset = @{
            x = $offsetX
            y = $offsetY
            z = $offsetZ
        }
    } | ConvertTo-Json -Depth 5
    
    try {
        $result = Invoke-RestMethod `
            -Uri "$UNITY_BASE/duplicateObject" `
            -Method POST `
            -ContentType "application/json" `
            -Body $body `
            -UseBasicParsing
        
        Write-Host "[COPY] Duplicated $sourceName -> $newName" -ForegroundColor Green
        return $result
    }
    catch {
        Write-Host "[ERROR] Failed to copy object: $_" -ForegroundColor Red
        return $null
    }
}

# ============================================================================
# EXPORT FUNCTIONS
# ============================================================================

Write-Host "[LOADED] Egyptian World Helper Library" -ForegroundColor Cyan
Write-Host "         Advanced Construction Tools for Complex Scenes" -ForegroundColor Cyan
Write-Host ""
Write-Host "Available Functions:" -ForegroundColor Yellow
Write-Host "  - Build-Archway" -ForegroundColor Gray
Write-Host "  - Build-Staircase" -ForegroundColor Gray
Write-Host "  - Build-CircularWall" -ForegroundColor Gray
Write-Host "  - Build-Colonnade" -ForegroundColor Gray
Write-Host "  - Build-Brazier" -ForegroundColor Gray
Write-Host "  - Build-TerrainMound" -ForegroundColor Gray
Write-Host "  - Copy-Object" -ForegroundColor Gray
Write-Host ""
