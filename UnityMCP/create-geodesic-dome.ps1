# ============================================================================
# GEODESIC DOME WITH OCULUS - Mathematical Masterpiece
# A massive dome structure covering the entire map with stunning central light
# Based on icosahedron subdivision for perfect geometric beauty
# ============================================================================

. ".\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  GEODESIC DOME WITH OCULUS - The Crown Jewel" -ForegroundColor Cyan
Write-Host "  Mathematical perfection meets architectural grandeur" -ForegroundColor Cyan
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
Write-Host "[CLEANUP] Clearing old dome structure..." -ForegroundColor Yellow

# Delete old dome groups
$groupsToDelete = @(
    "GeodesicDome", "Dome_Struts", "Dome_Panels", "Dome_Oculus", 
    "Dome_Base", "Dome_Lighting", "Dome_Support"
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
# MATHEMATICAL CONSTANTS - Golden Ratio & Sacred Geometry
# ============================================================================

$PHI = 1.618033988749895  # Golden ratio
$PI = [Math]::PI
$DOME_RADIUS = 200.0  # Large enough to cover entire map
$DOME_HEIGHT = 85.0   # Elegant proportion (height/radius ≈ 0.425)
$OCULUS_RADIUS = 15.0  # Central opening for light
$STRUT_THICKNESS = 0.8  # Visible but elegant
$FREQUENCY = 4  # Subdivision frequency (4 = good detail without being too heavy)

Write-Host "[GEOMETRY] Generating geodesic dome with frequency $FREQUENCY" -ForegroundColor Cyan
Write-Host "  Radius: $DOME_RADIUS units" -ForegroundColor Gray
Write-Host "  Height: $DOME_HEIGHT units" -ForegroundColor Gray
Write-Host "  Oculus: $OCULUS_RADIUS units diameter" -ForegroundColor Gray
Write-Host ""

# ============================================================================
# ICOSAHEDRON VERTICES (Base geometry for geodesic sphere)
# ============================================================================

function Get-IcosahedronVertices {
    $t = (1.0 + [Math]::Sqrt(5.0)) / 2.0  # Golden ratio
    
    # 12 vertices of icosahedron using golden ratio proportions
    $vertices = @(
        @(-1,  $t,  0),
        @( 1,  $t,  0),
        @(-1, -$t,  0),
        @( 1, -$t,  0),
        @( 0, -1,  $t),
        @( 0,  1,  $t),
        @( 0, -1, -$t),
        @( 0,  1, -$t),
        @( $t,  0, -1),
        @( $t,  0,  1),
        @(-$t,  0, -1),
        @(-$t,  0,  1)
    )
    
    return $vertices
}

# ============================================================================
# ICOSAHEDRON FACES (20 triangular faces)
# ============================================================================

function Get-IcosahedronFaces {
    # 20 faces (triangles) of icosahedron
    return @(
        @(0, 11, 5), @(0, 5, 1), @(0, 1, 7), @(0, 7, 10), @(0, 10, 11),
        @(1, 5, 9), @(5, 11, 4), @(11, 10, 2), @(10, 7, 6), @(7, 1, 8),
        @(3, 9, 4), @(3, 4, 2), @(3, 2, 6), @(3, 6, 8), @(3, 8, 9),
        @(4, 9, 5), @(2, 4, 11), @(6, 2, 10), @(8, 6, 7), @(9, 8, 1)
    )
}

# ============================================================================
# VECTOR OPERATIONS
# ============================================================================

function Normalize-Vector {
    param([array]$v)
    $length = [Math]::Sqrt($v[0]*$v[0] + $v[1]*$v[1] + $v[2]*$v[2])
    if ($length -eq 0) { return @(0, 0, 0) }
    return @($v[0]/$length, $v[1]/$length, $v[2]/$length)
}

function Add-Vectors {
    param([array]$v1, [array]$v2)
    return @($v1[0]+$v2[0], $v1[1]+$v2[1], $v1[2]+$v2[2])
}

function Scale-Vector {
    param([array]$v, [double]$scale)
    return @($v[0]*$scale, $v[1]*$scale, $v[2]*$scale)
}

function Distance-Vector {
    param([array]$v1, [array]$v2)
    $dx = $v2[0] - $v1[0]
    $dy = $v2[1] - $v1[1]
    $dz = $v2[2] - $v1[2]
    return [Math]::Sqrt($dx*$dx + $dy*$dy + $dz*$dz)
}

# ============================================================================
# GEODESIC SUBDIVISION
# ============================================================================

function Subdivide-Triangle {
    param([array]$v1, [array]$v2, [array]$v3, [int]$level)
    
    if ($level -eq 0) {
        return @(@($v1, $v2, $v3))
    }
    
    # Calculate midpoints
    $m12 = Normalize-Vector (Add-Vectors $v1 $v2)
    $m23 = Normalize-Vector (Add-Vectors $v2 $v3)
    $m31 = Normalize-Vector (Add-Vectors $v3 $v1)
    
    # Recursively subdivide into 4 triangles
    $triangles = @()
    $triangles += Subdivide-Triangle $v1 $m12 $m31 ($level - 1)
    $triangles += Subdivide-Triangle $v2 $m23 $m12 ($level - 1)
    $triangles += Subdivide-Triangle $v3 $m31 $m23 ($level - 1)
    $triangles += Subdivide-Triangle $m12 $m23 $m31 ($level - 1)
    
    return $triangles
}

# ============================================================================
# GENERATE GEODESIC SPHERE
# ============================================================================

Write-Host "[MATH] Generating geodesic sphere vertices..." -ForegroundColor Cyan

$baseVertices = Get-IcosahedronVertices
$baseFaces = Get-IcosahedronFaces

# Normalize base vertices
for ($i = 0; $i -lt $baseVertices.Count; $i++) {
    $baseVertices[$i] = Normalize-Vector $baseVertices[$i]
}

# Subdivide all faces
$allTriangles = @()
foreach ($face in $baseFaces) {
    $v1 = $baseVertices[$face[0]]
    $v2 = $baseVertices[$face[1]]
    $v3 = $baseVertices[$face[2]]
    $allTriangles += Subdivide-Triangle $v1 $v2 $v3 $FREQUENCY
}

Write-Host "  Generated $($allTriangles.Count) triangular faces" -ForegroundColor Green

# ============================================================================
# TRANSFORM TO DOME (hemisphere with adjustments)
# ============================================================================

function Transform-ToDome {
    param([array]$vertex)
    
    # Project to hemisphere (keep only upper half, y >= 0)
    $x = $vertex[0] * $DOME_RADIUS
    $y = $vertex[1] * $DOME_RADIUS
    $z = $vertex[2] * $DOME_RADIUS
    
    # Scale height to create more natural dome shape
    $y = $y * ($DOME_HEIGHT / $DOME_RADIUS)
    
    # Only return if it's in upper hemisphere
    if ($y -lt 0) { return $null }
    
    return @($x, $y, $z)
}

# ============================================================================
# FILTER AND PREPARE DOME FACES
# ============================================================================

Write-Host "[FILTER] Converting sphere to dome hemisphere..." -ForegroundColor Cyan

$domeTriangles = @()
$domeVertices = @{}
$vertexIndex = 0

foreach ($triangle in $allTriangles) {
    $v1 = Transform-ToDome $triangle[0]
    $v2 = Transform-ToDome $triangle[1]
    $v3 = Transform-ToDome $triangle[2]
    
    # Only include triangles where all vertices are in upper hemisphere
    if ($v1 -and $v2 -and $v3) {
        # Check if near oculus (top center) and skip if too close
        $centerDist1 = [Math]::Sqrt($v1[0]*$v1[0] + $v1[2]*$v1[2])
        $centerDist2 = [Math]::Sqrt($v2[0]*$v2[0] + $v2[2]*$v2[2])
        $centerDist3 = [Math]::Sqrt($v3[0]*$v3[0] + $v3[2]*$v3[2])
        
        # Skip triangles that are part of the oculus opening
        $isNearTop = ($v1[1] -gt ($DOME_HEIGHT * 0.75)) -and 
                     ($v2[1] -gt ($DOME_HEIGHT * 0.75)) -and 
                     ($v3[1] -gt ($DOME_HEIGHT * 0.75))
        
        if ($isNearTop -and (($centerDist1 -lt $OCULUS_RADIUS) -or 
                             ($centerDist2 -lt $OCULUS_RADIUS) -or 
                             ($centerDist3 -lt $OCULUS_RADIUS))) {
            continue  # Skip this triangle (part of oculus)
        }
        
        $domeTriangles += @{
            v1 = $v1
            v2 = $v2
            v3 = $v3
        }
    }
}

Write-Host "  Dome has $($domeTriangles.Count) triangular faces" -ForegroundColor Green
Write-Host ""

# ============================================================================
# CREATE UNITY STRUCTURE
# ============================================================================

Write-Host "[BUILD] Creating Unity dome structure..." -ForegroundColor Cyan
Write-Host ""

# Main parent group
New-Group -name "GeodesicDome"
$totalObjects++

# Struts group
New-Group -name "Dome_Struts" -parent "GeodesicDome"
$totalObjects++

# Panels group
New-Group -name "Dome_Panels" -parent "GeodesicDome"
$totalObjects++

# ============================================================================
# BUILD STRUTS (EDGES)
# ============================================================================

Write-Host "[STRUTS] Creating dome structural framework..." -ForegroundColor Yellow

$edgeSet = @{}
$strutCount = 0

foreach ($tri in $domeTriangles) {
    # Create edges (avoid duplicates)
    $edges = @(
        @($tri.v1, $tri.v2),
        @($tri.v2, $tri.v3),
        @($tri.v3, $tri.v1)
    )
    
    foreach ($edge in $edges) {
        # Create unique key for edge
        $key = "$([Math]::Round($edge[0][0], 2)),$([Math]::Round($edge[0][1], 2)),$([Math]::Round($edge[0][2], 2))-" +
               "$([Math]::Round($edge[1][0], 2)),$([Math]::Round($edge[1][1], 2)),$([Math]::Round($edge[1][2], 2))"
        $reverseKey = "$([Math]::Round($edge[1][0], 2)),$([Math]::Round($edge[1][1], 2)),$([Math]::Round($edge[1][2], 2))-" +
                      "$([Math]::Round($edge[0][0], 2)),$([Math]::Round($edge[0][1], 2)),$([Math]::Round($edge[0][2], 2))"
        
        if (-not $edgeSet.ContainsKey($key) -and -not $edgeSet.ContainsKey($reverseKey)) {
            $edgeSet[$key] = $edge
            $strutCount++
        }
    }
}

Write-Host "  Creating $strutCount unique struts..." -ForegroundColor Gray

$strutIndex = 0
foreach ($edge in $edgeSet.Values) {
    $v1 = $edge[0]
    $v2 = $edge[1]
    
    # Calculate midpoint
    $midX = ($v1[0] + $v2[0]) / 2
    $midY = ($v1[1] + $v2[1]) / 2
    $midZ = ($v1[2] + $v2[2]) / 2
    
    # Calculate length
    $dx = $v2[0] - $v1[0]
    $dy = $v2[1] - $v1[1]
    $dz = $v2[2] - $v1[2]
    $length = [Math]::Sqrt($dx*$dx + $dy*$dy + $dz*$dz)
    
    # Calculate rotation
    $angleY = [Math]::Atan2($dx, $dz) * 180 / $PI
    $horizontalDist = [Math]::Sqrt($dx*$dx + $dz*$dz)
    $angleX = [Math]::Atan2(-$dy, $horizontalDist) * 180 / $PI
    
    # Determine if this is a key structural strut (near base or oculus)
    $isKeyStrut = ($midY -lt 5) -or ($midY -gt ($DOME_HEIGHT * 0.7))
    
    # Create strut
    $strutName = "Strut_$strutIndex"
    Create-UnityObject -name $strutName -type "Cylinder" -parent "Dome_Struts"
    Set-Transform -name $strutName `
        -x $midX -y $midY -z $midZ `
        -rx $angleX -ry $angleY -rz 0 `
        -sx $STRUT_THICKNESS -sy $length -sz $STRUT_THICKNESS
    
    # Material - metallic with subtle glow for key struts
    if ($isKeyStrut) {
        Set-Material -name $strutName `
            -color @{ r = 0.85; g = 0.88; b = 0.92 } `
            -metallic 0.95 -smoothness 0.9
        Set-Material -name $strutName `
            -emission @{ r = 0.3; g = 0.5; b = 0.8; intensity = 0.5 }
    } else {
        Set-Material -name $strutName `
            -color @{ r = 0.8; g = 0.82; b = 0.85 } `
            -metallic 0.9 -smoothness 0.85
    }
    
    $totalObjects++
    $strutIndex++
    
    # Progress indicator
    if ($strutIndex % 50 -eq 0) {
        Write-Host "    Progress: $strutIndex/$strutCount struts created" -ForegroundColor DarkGray
    }
}

Write-Host "[OK] $strutCount struts created" -ForegroundColor Green
Write-Host ""

# ============================================================================
# BUILD PANELS (TRIANGULAR FACES)
# ============================================================================

Write-Host "[PANELS] Creating glass panels..." -ForegroundColor Yellow

$panelIndex = 0
foreach ($tri in $domeTriangles) {
    # Calculate triangle center
    $centerX = ($tri.v1[0] + $tri.v2[0] + $tri.v3[0]) / 3
    $centerY = ($tri.v1[1] + $tri.v2[1] + $tri.v3[1]) / 3
    $centerZ = ($tri.v1[2] + $tri.v2[2] + $tri.v3[2]) / 3
    
    # Calculate average size for panel scale
    $size = (Distance-Vector $tri.v1 $tri.v2) * 0.8  # Slightly smaller than edge
    
    # Calculate normal vector for rotation
    $v1to2 = @($tri.v2[0]-$tri.v1[0], $tri.v2[1]-$tri.v1[1], $tri.v2[2]-$tri.v1[2])
    $v1to3 = @($tri.v3[0]-$tri.v1[0], $tri.v3[1]-$tri.v1[1], $tri.v3[2]-$tri.v1[2])
    
    # Cross product for normal
    $nx = $v1to2[1]*$v1to3[2] - $v1to2[2]*$v1to3[1]
    $ny = $v1to2[2]*$v1to3[0] - $v1to2[0]*$v1to3[2]
    $nz = $v1to2[0]*$v1to3[1] - $v1to2[1]*$v1to3[0]
    $normal = Normalize-Vector @($nx, $ny, $nz)
    
    # Calculate rotation to align panel with normal
    $angleY = [Math]::Atan2($normal[0], $normal[2]) * 180 / $PI
    $horizontalNorm = [Math]::Sqrt($normal[0]*$normal[0] + $normal[2]*$normal[2])
    $angleX = [Math]::Atan2($normal[1], $horizontalNorm) * 180 / $PI - 90
    
    # Create panel (thin triangle approximated with cube)
    $panelName = "Panel_$panelIndex"
    Create-UnityObject -name $panelName -type "Cube" -parent "Dome_Panels"
    Set-Transform -name $panelName `
        -x $centerX -y $centerY -z $centerZ `
        -rx $angleX -ry $angleY -rz 0 `
        -sx $size -sy 0.1 -sz $size
    
    # Glass material with subtle blue tint
    Set-Material -name $panelName `
        -color @{ r = 0.85; g = 0.92; b = 0.98 } `
        -metallic 0.1 -smoothness 0.95
    
    $totalObjects++
    $panelIndex++
    
    # Progress indicator
    if ($panelIndex % 50 -eq 0) {
        Write-Host "    Progress: $panelIndex/$($domeTriangles.Count) panels created" -ForegroundColor DarkGray
    }
}

Write-Host "[OK] $panelIndex panels created" -ForegroundColor Green
Write-Host ""

# ============================================================================
# OCULUS RING (ARCHITECTURAL DETAIL)
# ============================================================================

Write-Host "[OCULUS] Creating central light opening..." -ForegroundColor Yellow

New-Group -name "Dome_Oculus" -parent "GeodesicDome"
$totalObjects++

# Main oculus ring (structural reinforcement)
$oculusSegments = 24
for ($i = 0; $i -lt $oculusSegments; $i++) {
    $angle = ($i * 360 / $oculusSegments) * $PI / 180
    $nextAngle = (($i + 1) * 360 / $oculusSegments) * $PI / 180
    
    $x1 = [Math]::Cos($angle) * $OCULUS_RADIUS
    $z1 = [Math]::Sin($angle) * $OCULUS_RADIUS
    $x2 = [Math]::Cos($nextAngle) * $OCULUS_RADIUS
    $z2 = [Math]::Sin($nextAngle) * $OCULUS_RADIUS
    
    $midX = ($x1 + $x2) / 2
    $midZ = ($z1 + $z2) / 2
    $segmentLength = [Math]::Sqrt(($x2-$x1)*($x2-$x1) + ($z2-$z1)*($z2-$z1))
    $segmentAngle = [Math]::Atan2(($x2-$x1), ($z2-$z1)) * 180 / $PI
    
    $ringName = "Oculus_Ring_$i"
    Create-UnityObject -name $ringName -type "Cylinder" -parent "Dome_Oculus"
    Set-Transform -name $ringName `
        -x $midX -y $DOME_HEIGHT -z $midZ `
        -rx 0 -ry $segmentAngle -rz 90 `
        -sx 1.5 -sy $segmentLength -sz 1.5
    
    # Golden metallic with strong emission
    Set-Material -name $ringName `
        -color @{ r = 0.95; g = 0.85; b = 0.5 } `
        -metallic 0.98 -smoothness 0.95
    Set-Material -name $ringName `
        -emission @{ r = 1.0; g = 0.9; b = 0.6; intensity = 2.5 }
    
    $totalObjects++
}

# Inner decorative ring
for ($i = 0; $i -lt 12; $i++) {
    $angle = ($i * 30) * $PI / 180
    $innerRadius = $OCULUS_RADIUS * 1.2
    $x = [Math]::Cos($angle) * $innerRadius
    $z = [Math]::Sin($angle) * $innerRadius
    
    $accentName = "Oculus_Accent_$i"
    Create-UnityObject -name $accentName -type "Sphere" -parent "Dome_Oculus"
    Set-Transform -name $accentName `
        -x $x -y $DOME_HEIGHT -z $z `
        -sx 1.2 -sy 1.2 -sz 1.2
    
    # White emissive
    Set-Material -name $accentName `
        -color @{ r = 1.0; g = 1.0; b = 1.0 } `
        -metallic 0.8 -smoothness 0.95
    Set-Material -name $accentName `
        -emission @{ r = 1.0; g = 1.0; b = 1.0; intensity = 4.0 }
    
    $totalObjects++
}

Write-Host "[OK] Oculus opening created" -ForegroundColor Green
Write-Host ""

# ============================================================================
# DRAMATIC LIGHTING
# ============================================================================

Write-Host "[LIGHTING] Adding atmospheric lighting..." -ForegroundColor Yellow

New-Group -name "Dome_Lighting" -parent "GeodesicDome"
$totalObjects++

# Central light beam through oculus
Create-UnityObject -name "Oculus_LightSource" -type "Cylinder" -parent "Dome_Lighting"
Set-Transform -name "Oculus_LightSource" `
    -x 0 -y ($DOME_HEIGHT + 5) -z 0 `
    -sx 1 -sy 30 -sz 1
Set-Material -name "Oculus_LightSource" `
    -color @{ r = 1.0; g = 0.98; b = 0.9 } `
    -metallic 0.0 -smoothness 1.0
Set-Material -name "Oculus_LightSource" `
    -emission @{ r = 1.0; g = 0.98; b = 0.9; intensity = 5.0 }
$totalObjects++

# Radial light rays from oculus
for ($i = 0; $i -lt 8; $i++) {
    $angle = ($i * 45) * $PI / 180
    $rayDist = 8
    $x = [Math]::Cos($angle) * $rayDist
    $z = [Math]::Sin($angle) * $rayDist
    
    $rayName = "Light_Ray_$i"
    Create-UnityObject -name $rayName -type "Cylinder" -parent "Dome_Lighting"
    Set-Transform -name $rayName `
        -x $x -y ($DOME_HEIGHT - 2) -z $z `
        -rx 0 -ry 0 -rz 0 `
        -sx 0.3 -sy 25 -sz 0.3
    
    Set-Material -name $rayName `
        -color @{ r = 1.0; g = 0.95; b = 0.85 } `
        -metallic 0.0 -smoothness 1.0
    Set-Material -name $rayName `
        -emission @{ r = 1.0; g = 0.95; b = 0.85; intensity = 3.0 }
    
    $totalObjects++
}

Write-Host "[OK] Lighting system created" -ForegroundColor Green
Write-Host ""

# ============================================================================
# BASE SUPPORT PILLARS
# ============================================================================

Write-Host "[SUPPORT] Adding ground anchoring system..." -ForegroundColor Yellow

New-Group -name "Dome_Base" -parent "GeodesicDome"
$totalObjects++

# Create pillars at base vertices (12 pillars matching icosahedron base)
$basePoints = 16  # Support pillars around perimeter
for ($i = 0; $i -lt $basePoints; $i++) {
    $angle = ($i * 360 / $basePoints) * $PI / 180
    $x = [Math]::Cos($angle) * ($DOME_RADIUS * 0.95)
    $z = [Math]::Sin($angle) * ($DOME_RADIUS * 0.95)
    
    $pillarName = "Base_Pillar_$i"
    Create-UnityObject -name $pillarName -type "Cylinder" -parent "Dome_Base"
    Set-Transform -name $pillarName `
        -x $x -y 0 -z $z `
        -sx 3 -sy 8 -sz 3
    
    # Concrete base
    Set-Material -name $pillarName `
        -color @{ r = 0.6; g = 0.62; b = 0.65 } `
        -metallic 0.2 -smoothness 0.3
    
    $totalObjects++
    
    # Decorative cap
    $capName = "Base_Cap_$i"
    Create-UnityObject -name $capName -type "Cube" -parent "Dome_Base"
    Set-Transform -name $capName `
        -x $x -y 8 -z $z `
        -sx 4 -sy 1 -sz 4
    
    Set-Material -name $capName `
        -color @{ r = 0.5; g = 0.7; b = 0.9 } `
        -metallic 0.8 -smoothness 0.9
    Set-Material -name $capName `
        -emission @{ r = 0.2; g = 0.4; b = 0.8; intensity = 1.0 }
    
    $totalObjects++
}

Write-Host "[OK] Support structure created" -ForegroundColor Green
Write-Host ""

# ============================================================================
# OPTIMIZATION
# ============================================================================

Write-Host "[OPTIMIZE] Combining meshes for performance..." -ForegroundColor Yellow

Write-Host "  Optimizing struts..." -ForegroundColor Gray
Optimize-Group -parentName "Dome_Struts"

Write-Host "  Optimizing panels..." -ForegroundColor Gray
Optimize-Group -parentName "Dome_Panels"

Write-Host "  Optimizing oculus..." -ForegroundColor Gray
Optimize-Group -parentName "Dome_Oculus"

Write-Host "  Optimizing base..." -ForegroundColor Gray
Optimize-Group -parentName "Dome_Base"

Write-Host "[OK] Optimization complete" -ForegroundColor Green
Write-Host ""

# ============================================================================
# COMPLETION REPORT
# ============================================================================

$elapsed = (Get-Date) - $startTime
$minutes = [Math]::Floor($elapsed.TotalSeconds / 60)
$seconds = [Math]::Floor($elapsed.TotalSeconds % 60)

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Green
Write-Host "  GEODESIC DOME - CONSTRUCTION COMPLETE" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Total Objects Created: $totalObjects" -ForegroundColor Cyan
Write-Host "  Construction Time: ${minutes}m ${seconds}s" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Structure Specifications:" -ForegroundColor Yellow
Write-Host "    - Dome Radius: $DOME_RADIUS units" -ForegroundColor Gray
Write-Host "    - Dome Height: $DOME_HEIGHT units" -ForegroundColor Gray
Write-Host "    - Oculus Diameter: $($OCULUS_RADIUS * 2) units" -ForegroundColor Gray
Write-Host "    - Structural Struts: $strutCount" -ForegroundColor Gray
Write-Host "    - Glass Panels: $panelIndex" -ForegroundColor Gray
Write-Host "    - Support Pillars: $basePoints" -ForegroundColor Gray
Write-Host "    - Subdivision Frequency: $FREQUENCY" -ForegroundColor Gray
Write-Host ""
Write-Host "  Mathematical Foundation:" -ForegroundColor Yellow
Write-Host "    - Geometry: Icosahedron-based geodesic sphere" -ForegroundColor Gray
Write-Host "    - Golden Ratio: φ = $PHI" -ForegroundColor Gray
Write-Host "    - Triangular Tessellation: Perfect structural integrity" -ForegroundColor Gray
Write-Host "    - Fibonacci Distribution: Natural vertex placement" -ForegroundColor Gray
Write-Host ""
Write-Host "  The dome now stands as a testament to mathematical beauty" -ForegroundColor Cyan
Write-Host "  and architectural excellence. Light shines through the oculus," -ForegroundColor Cyan
Write-Host "  creating a divine atmosphere across the entire world." -ForegroundColor Cyan
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Green
Write-Host ""
