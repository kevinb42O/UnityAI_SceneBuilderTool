# ============================================================
# Unity MCP Enhanced Helper Library v2.0
# Materials + Hierarchy + Scene Intelligence
# ============================================================

$UNITY_BASE = "http://localhost:8765"

# ============================================================
# CORE CREATION (Legacy Support)
# ============================================================

function Create-UnityObject {
    param(
        [string]$name,
        [string]$type = "Cube",
        [string]$parent = ""
    )
    
    $body = @{
        name = $name
        primitiveType = $type
    }
    
    if ($parent) {
        $body.parent = $parent
    }
    
    $json = $body | ConvertTo-Json
    
    try {
        Invoke-RestMethod `
            -Uri "$UNITY_BASE/createGameObject" `
            -Method POST `
            -ContentType "application/json" `
            -Body $json `
            -UseBasicParsing | Out-Null
    }
    catch {
        Write-Host "[ERROR] Failed to create $name : $_" -ForegroundColor Red
    }
}

function Set-Transform {
    param(
        [string]$name,
        [float]$x = 0, [float]$y = 0, [float]$z = 0,
        [float]$rx = 0, [float]$ry = 0, [float]$rz = 0,
        [float]$sx = 1, [float]$sy = 1, [float]$sz = 1
    )
    
    $body = @{
        name = $name
        position = @{ x = $x; y = $y; z = $z }
        rotation = @{ x = $rx; y = $ry; z = $rz }
        scale = @{ x = $sx; y = $sy; z = $sz }
    } | ConvertTo-Json
    
    try {
        Invoke-RestMethod `
            -Uri "$UNITY_BASE/setTransform" `
            -Method POST `
            -ContentType "application/json" `
            -Body $body `
            -UseBasicParsing | Out-Null
    }
    catch {
        Write-Host "[ERROR] Failed to set transform for $name : $_" -ForegroundColor Red
    }
}

# ============================================================
# MATERIALS SYSTEM - Production Grade
# ============================================================

function Set-Material {
    param(
        [string]$name,
        [hashtable]$color = $null,
        [float]$metallic = -1,
        [float]$smoothness = -1,
        [hashtable]$emission = $null,
        [hashtable]$tiling = $null,
        [hashtable]$offset = $null
    )
    
    $body = @{ name = $name }
    
    if ($color) { $body.color = $color }
    if ($metallic -ge 0) { $body.metallic = $metallic }
    if ($smoothness -ge 0) { $body.smoothness = $smoothness }
    if ($emission) { $body.emission = $emission }
    if ($tiling) { $body.tiling = $tiling }
    if ($offset) { $body.offset = $offset }
    
    $json = $body | ConvertTo-Json -Depth 5
    
    try {
        $result = Invoke-RestMethod `
            -Uri "$UNITY_BASE/setMaterial" `
            -Method POST `
            -ContentType "application/json" `
            -Body $json `
            -UseBasicParsing
        return $result
    }
    catch {
        Write-Host "[ERROR] Failed to set material on $name : $_" -ForegroundColor Red
    }
}

function Apply-Material {
    param(
        [string]$name,
        [ValidateSet(
            "Wood_Oak", "Metal_Steel", "Metal_Gold", "Metal_Bronze",
            "Glass_Clear", "Brick_Red", "Concrete", "Stone_Gray",
            "Grass_Green", "Water_Blue", "Rubber_Black", "Plastic_White",
            "Emissive_Blue", "Emissive_Red"
        )]
        [string]$materialName
    )
    
    $body = @{
        name = $name
        materialName = $materialName
    } | ConvertTo-Json
    
    try {
        Invoke-RestMethod `
            -Uri "$UNITY_BASE/applyMaterial" `
            -Method POST `
            -ContentType "application/json" `
            -Body $body `
            -UseBasicParsing | Out-Null
    }
    catch {
        Write-Host "[ERROR] Failed to apply material $materialName to $name : $_" -ForegroundColor Red
    }
}

function Get-MaterialLibrary {
    try {
        $result = Invoke-RestMethod `
            -Uri "$UNITY_BASE/createMaterialLibrary" `
            -Method POST `
            -ContentType "application/json" `
            -Body "{}" `
            -UseBasicParsing
        return $result.materials
    }
    catch {
        Write-Host "[ERROR] Failed to get material library: $_" -ForegroundColor Red
    }
}

# Color presets for convenience
function Get-Color {
    param([string]$name)
    
    $colors = @{
        "Red" = @{ r = 1.0; g = 0.0; b = 0.0 }
        "Green" = @{ r = 0.0; g = 1.0; b = 0.0 }
        "Blue" = @{ r = 0.0; g = 0.0; b = 1.0 }
        "Yellow" = @{ r = 1.0; g = 1.0; b = 0.0 }
        "Cyan" = @{ r = 0.0; g = 1.0; b = 1.0 }
        "Magenta" = @{ r = 1.0; g = 0.0; b = 1.0 }
        "White" = @{ r = 1.0; g = 1.0; b = 1.0 }
        "Black" = @{ r = 0.0; g = 0.0; b = 0.0 }
        "Orange" = @{ r = 1.0; g = 0.5; b = 0.0 }
        "Purple" = @{ r = 0.5; g = 0.0; b = 0.5 }
        "Pink" = @{ r = 1.0; g = 0.75; b = 0.8 }
        "Brown" = @{ r = 0.6; g = 0.3; b = 0.1 }
        "Gray" = @{ r = 0.5; g = 0.5; b = 0.5 }
    }
    
    return $colors[$name]
}

# ============================================================
# HIERARCHY SYSTEM - Smart Organization
# ============================================================

function New-Group {
    param(
        [string]$name,
        [string]$parent = ""
    )
    
    $body = @{ name = $name }
    if ($parent) { $body.parent = $parent }
    
    $json = $body | ConvertTo-Json
    
    try {
        $result = Invoke-RestMethod `
            -Uri "$UNITY_BASE/createGroup" `
            -Method POST `
            -ContentType "application/json" `
            -Body $json `
            -UseBasicParsing
        return $result
    }
    catch {
        Write-Host "[ERROR] Failed to create group $name : $_" -ForegroundColor Red
    }
}

function Set-Parent {
    param(
        [string]$childName,
        [string]$parentName,
        [bool]$worldPositionStays = $true
    )
    
    $body = @{
        childName = $childName
        parentName = $parentName
        worldPositionStays = $worldPositionStays
    } | ConvertTo-Json
    
    try {
        Invoke-RestMethod `
            -Uri "$UNITY_BASE/setParent" `
            -Method POST `
            -ContentType "application/json" `
            -Body $body `
            -UseBasicParsing | Out-Null
    }
    catch {
        Write-Host "[ERROR] Failed to set parent: $_" -ForegroundColor Red
    }
}

function Optimize-Group {
    param(
        [string]$parentName,
        [bool]$destroyOriginals = $true,
        [bool]$generateCollider = $true
    )
    
    $body = @{
        parentName = $parentName
        destroyOriginals = $destroyOriginals
        generateCollider = $generateCollider
    } | ConvertTo-Json
    
    try {
        $result = Invoke-RestMethod `
            -Uri "$UNITY_BASE/combineChildren" `
            -Method POST `
            -ContentType "application/json" `
            -Body $body `
            -UseBasicParsing
        
        Write-Host "[OPTIMIZE] Combined $($result.originalCount) meshes into $($result.combinedMeshes) optimized mesh(es)" -ForegroundColor Green
        return $result
    }
    catch {
        Write-Host "[ERROR] Failed to optimize group $parentName : $_" -ForegroundColor Red
    }
}

# ============================================================
# SCENE QUERY SYSTEM - Context Intelligence
# ============================================================

function Find-Objects {
    param(
        [string]$query = "",
        [float]$radius = 0,
        [hashtable]$position = $null
    )
    
    $body = @{}
    if ($query) { $body.query = $query }
    if ($radius -gt 0) { 
        $body.radius = $radius 
        if ($position) { $body.position = $position }
    }
    
    $json = $body | ConvertTo-Json -Depth 5
    
    try {
        $result = Invoke-RestMethod `
            -Uri "$UNITY_BASE/queryScene" `
            -Method POST `
            -ContentType "application/json" `
            -Body $json `
            -UseBasicParsing
        return $result.results
    }
    catch {
        Write-Host "[ERROR] Failed to query scene: $_" -ForegroundColor Red
    }
}

# ============================================================
# HIGH-LEVEL BUILDERS - Convenience Functions
# ============================================================

function Build-ColoredObject {
    param(
        [string]$name,
        [string]$type = "Cube",
        [float]$x = 0, [float]$y = 0, [float]$z = 0,
        [float]$rx = 0, [float]$ry = 0, [float]$rz = 0,
        [float]$sx = 1, [float]$sy = 1, [float]$sz = 1,
        [hashtable]$color = $null,
        [string]$colorName = "",
        [float]$metallic = 0,
        [float]$smoothness = 0.5,
        [string]$parent = ""
    )
    
    # Create object
    Create-UnityObject -name $name -type $type -parent $parent
    
    # Set transform
    Set-Transform -name $name -x $x -y $y -z $z -rx $rx -ry $ry -rz $rz -sx $sx -sy $sy -sz $sz
    
    # Apply material
    if ($colorName) {
        $color = Get-Color -name $colorName
    }
    
    if ($color) {
        Set-Material -name $name -color $color -metallic $metallic -smoothness $smoothness
    }
}

function Build-Group {
    param(
        [string]$groupName,
        [scriptblock]$children,
        [bool]$optimize = $false
    )
    
    Write-Host "[GROUP] Creating $groupName..." -ForegroundColor Cyan
    
    # Create parent group
    New-Group -name $groupName
    
    # Execute children creation block
    & $children
    
    # Optimize if requested
    if ($optimize) {
        Write-Host "[GROUP] Optimizing $groupName..." -ForegroundColor Cyan
        Optimize-Group -parentName $groupName
    }
    
    Write-Host "[GROUP] Completed $groupName" -ForegroundColor Green
}

function Build-DiagonalObject {
    param(
        [string]$name,
        [string]$type = "Cylinder",
        [float]$x1, [float]$y1, [float]$z1,
        [float]$x2, [float]$y2, [float]$z2,
        [float]$thickness = 0.2,
        [hashtable]$color = $null,
        [string]$parent = ""
    )
    
    # Calculate midpoint
    $midX = ($x1 + $x2) / 2
    $midY = ($y1 + $y2) / 2
    $midZ = ($z1 + $z2) / 2
    
    # Calculate length
    $dx = $x2 - $x1
    $dy = $y2 - $y1
    $dz = $z2 - $z1
    $length = [Math]::Sqrt($dx*$dx + $dy*$dy + $dz*$dz)
    
    # Calculate rotation
    $angleY = [Math]::Atan2($dx, $dz) * 180 / [Math]::PI
    $horizontalDist = [Math]::Sqrt($dx*$dx + $dz*$dz)
    $angleX = [Math]::Atan2(-$dy, $horizontalDist) * 180 / [Math]::PI
    
    # Create and position
    Create-UnityObject -name $name -type $type -parent $parent
    Set-Transform -name $name `
        -x $midX -y $midY -z $midZ `
        -rx $angleX -ry $angleY -rz 0 `
        -sx $thickness -sy $length -sz $thickness
    
    # Apply color if provided
    if ($color) {
        Set-Material -name $name -color $color
    }
}

# ============================================================
# UTILITY FUNCTIONS
# ============================================================

function Test-UnityConnection {
    try {
        $result = Invoke-RestMethod `
            -Uri "$UNITY_BASE/ping" `
            -Method POST `
            -ContentType "application/json" `
            -Body "{}" `
            -UseBasicParsing `
            -TimeoutSec 2
        
        if ($result.status -eq "ok") {
            Write-Host "[OK] Unity MCP server connected on port 8765" -ForegroundColor Green
            return $true
        }
    }
    catch {
        Write-Host "[ERROR] Unity MCP server not responding on port 8765" -ForegroundColor Red
        Write-Host "       Make sure Unity is open and the MCP server is running" -ForegroundColor Yellow
        return $false
    }
}

function Show-Progress {
    param(
        [string]$activity,
        [int]$current,
        [int]$total
    )
    
    $percent = [int](($current / $total) * 100)
    Write-Progress -Activity $activity -Status "$current of $total" -PercentComplete $percent
}

# ============================================================
# EXPORT FUNCTIONS
# ============================================================

Export-ModuleMember -Function @(
    'Create-UnityObject',
    'Set-Transform',
    'Set-Material',
    'Apply-Material',
    'Get-MaterialLibrary',
    'Get-Color',
    'New-Group',
    'Set-Parent',
    'Optimize-Group',
    'Find-Objects',
    'Build-ColoredObject',
    'Build-Group',
    'Build-DiagonalObject',
    'Test-UnityConnection',
    'Show-Progress'
)

Write-Host "[LOADED] Unity MCP Enhanced Helper Library v2.0" -ForegroundColor Cyan
Write-Host "         Materials + Hierarchy + Scene Intelligence" -ForegroundColor Cyan
