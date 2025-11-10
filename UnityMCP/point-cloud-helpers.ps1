# Point Cloud and Procedural Mesh Helper Functions for Unity MCP
# Requires: Unity MCP Server running on port 8765

$UNITY_BASE = "http://localhost:8765"

<#
.SYNOPSIS
    Generates a terrain point cloud with Perlin noise
.DESCRIPTION
    Creates a realistic terrain representation using point cloud data with noise-based height generation
.EXAMPLE
    New-PointCloudTerrain -name "Mountain" -pointCount 20000 -areaSize 200 -noiseAmplitude 30
#>
function New-PointCloudTerrain {
    param(
        [string]$name = "PointCloudTerrain",
        [int]$pointCount = 10000,
        [float]$areaSize = 100.0,
        [float]$heightVariation = 20.0,
        [bool]$usePerlinNoise = $true,
        [float]$noiseScale = 0.1,
        [float]$noiseAmplitude = 10.0,
        [int]$seed = 0,
        [bool]$colorByHeight = $true,
        [bool]$generateNormals = $true,
        [bool]$asSurface = $true,
        [int]$gridResolution = 50
    )

    try {
        $body = @{
            name = $name
            pointCount = $pointCount
            areaSize = $areaSize
            heightVariation = $heightVariation
            usePerlinNoise = $usePerlinNoise
            noiseScale = $noiseScale
            noiseAmplitude = $noiseAmplitude
            seed = $seed
            colorByHeight = $colorByHeight
            generateNormals = $generateNormals
            asSurface = $asSurface
            gridResolution = $gridResolution
        } | ConvertTo-Json

        $response = Invoke-RestMethod -Uri "$UNITY_BASE/generatePointCloud" -Method Post -Body $body -ContentType "application/json"
        
        if ($response.success) {
            Write-Host "[SUCCESS] Generated point cloud terrain: $($response.name) with $($response.pointCount) points" -ForegroundColor Green
            return $response
        } else {
            Write-Host "[ERROR] Failed to generate point cloud: $($response.error)" -ForegroundColor Red
            return $null
        }
    }
    catch {
        Write-Host "[ERROR] Failed to create point cloud terrain: $_" -ForegroundColor Red
        return $null
    }
}

<#
.SYNOPSIS
    Generates procedural terrain using advanced noise algorithms
.DESCRIPTION
    Creates highly detailed terrain meshes with multiple noise types (Perlin, Simplex, Voronoi, Ridged, Billow)
.EXAMPLE
    New-ProceduralTerrain -name "Valley" -width 200 -height 200 -noiseType "Ridged" -octaves 6
#>
function New-ProceduralTerrain {
    param(
        [string]$name = "ProceduralTerrain",
        [int]$width = 100,
        [int]$height = 100,
        [float]$scale = 20.0,
        [float]$amplitude = 10.0,
        [int]$octaves = 4,
        [float]$persistence = 0.5,
        [float]$lacunarity = 2.0,
        [ValidateSet("Perlin", "Simplex", "Voronoi", "Ridged", "Billow")]
        [string]$noiseType = "Perlin",
        [int]$seed = 0,
        [bool]$colorByHeight = $true
    )

    try {
        $body = @{
            name = $name
            width = $width
            height = $height
            scale = $scale
            amplitude = $amplitude
            octaves = $octaves
            persistence = $persistence
            lacunarity = $lacunarity
            noiseType = $noiseType
            seed = $seed
            colorByHeight = $colorByHeight
        } | ConvertTo-Json

        $response = Invoke-RestMethod -Uri "$UNITY_BASE/generateProceduralTerrain" -Method Post -Body $body -ContentType "application/json"
        
        if ($response.success) {
            Write-Host "[SUCCESS] Generated procedural terrain: $($response.name) with $($response.vertices) vertices" -ForegroundColor Green
            return $response
        } else {
            Write-Host "[ERROR] Failed to generate terrain: $($response.error)" -ForegroundColor Red
            return $null
        }
    }
    catch {
        Write-Host "[ERROR] Failed to create procedural terrain: $_" -ForegroundColor Red
        return $null
    }
}

<#
.SYNOPSIS
    Generates a procedural building facade with windows and details
.DESCRIPTION
    Creates realistic building exteriors with customizable floors, windows, doors, and balconies
.EXAMPLE
    New-BuildingFacade -name "OfficeBuilding" -floors 10 -windowsPerFloor 6 -addBalconies $true
#>
function New-BuildingFacade {
    param(
        [string]$name = "Building",
        [int]$floors = 5,
        [float]$floorHeight = 3.0,
        [int]$windowsPerFloor = 4,
        [float]$windowWidth = 1.5,
        [float]$windowHeight = 2.0,
        [float]$wallThickness = 0.3,
        [bool]$addDoor = $true,
        [bool]$addBalconies = $false,
        [hashtable]$wallColor = @{r=0.8; g=0.8; b=0.8; a=1.0},
        [hashtable]$windowColor = @{r=0.2; g=0.3; b=0.4; a=1.0},
        [hashtable]$position = $null
    )

    try {
        $body = @{
            name = $name
            floors = $floors
            floorHeight = $floorHeight
            windowsPerFloor = $windowsPerFloor
            windowWidth = $windowWidth
            windowHeight = $windowHeight
            wallThickness = $wallThickness
            addDoor = $addDoor
            addBalconies = $addBalconies
            wallColor = $wallColor
            windowColor = $windowColor
        }

        if ($position) {
            $body.position = $position
        }

        $body = $body | ConvertTo-Json

        $response = Invoke-RestMethod -Uri "$UNITY_BASE/generateBuildingFacade" -Method Post -Body $body -ContentType "application/json"
        
        if ($response.success) {
            Write-Host "[SUCCESS] Generated building facade: $($response.name) with $($response.floors) floors" -ForegroundColor Green
            return $response
        } else {
            Write-Host "[ERROR] Failed to generate building: $($response.error)" -ForegroundColor Red
            return $null
        }
    }
    catch {
        Write-Host "[ERROR] Failed to create building facade: $_" -ForegroundColor Red
        return $null
    }
}

<#
.SYNOPSIS
    Generates a procedural tree using L-System grammar
.DESCRIPTION
    Creates complex, organic tree structures using Lindenmayer system rules for realistic branching patterns
.EXAMPLE
    New-LSystemTree -name "Oak" -iterations 5 -angle 30 -preset "tree"
#>
function New-LSystemTree {
    param(
        [string]$name = "Tree",
        [string]$preset = "tree",
        [string]$axiom = "F",
        [int]$iterations = 4,
        [float]$segmentLength = 1.0,
        [float]$angle = 25.0,
        [float]$radiusReduction = 0.8,
        [float]$initialRadius = 0.3,
        [array]$rules = $null,
        [hashtable]$trunkColor = @{r=0.4; g=0.3; b=0.2; a=1.0},
        [hashtable]$leafColor = @{r=0.2; g=0.6; b=0.2; a=1.0},
        [hashtable]$position = $null
    )

    try {
        $body = @{
            name = $name
            preset = $preset
            axiom = $axiom
            iterations = $iterations
            segmentLength = $segmentLength
            angle = $angle
            radiusReduction = $radiusReduction
            initialRadius = $initialRadius
            trunkColor = $trunkColor
            leafColor = $leafColor
        }

        if ($rules) {
            $body.rules = $rules
        }

        if ($position) {
            $body.position = $position
        }

        $body = $body | ConvertTo-Json -Depth 10

        $response = Invoke-RestMethod -Uri "$UNITY_BASE/generateLSystemTree" -Method Post -Body $body -ContentType "application/json"
        
        if ($response.success) {
            Write-Host "[SUCCESS] Generated L-System tree: $($response.name) with $($response.branches) branches" -ForegroundColor Green
            return $response
        } else {
            Write-Host "[ERROR] Failed to generate tree: $($response.error)" -ForegroundColor Red
            return $null
        }
    }
    catch {
        Write-Host "[ERROR] Failed to create L-System tree: $_" -ForegroundColor Red
        return $null
    }
}

<#
.SYNOPSIS
    Creates a complete procedural city block
.DESCRIPTION
    Generates multiple buildings with variation to create a realistic city environment
.EXAMPLE
    New-ProceduralCityBlock -blockSize 100 -buildingCount 10
#>
function New-ProceduralCityBlock {
    param(
        [string]$name = "CityBlock",
        [int]$buildingCount = 8,
        [float]$blockSize = 100.0,
        [int]$minFloors = 3,
        [int]$maxFloors = 12,
        [bool]$addBalconies = $true
    )

    Write-Host "[INFO] Generating city block with $buildingCount buildings..." -ForegroundColor Cyan
    
    $buildings = @()
    $gridSize = [Math]::Ceiling([Math]::Sqrt($buildingCount))
    $spacing = $blockSize / $gridSize
    
    for ($i = 0; $i -lt $buildingCount; $i++) {
        $row = [Math]::Floor($i / $gridSize)
        $col = $i % $gridSize
        
        $x = ($col * $spacing) - ($blockSize / 2) + ($spacing / 2)
        $z = ($row * $spacing) - ($blockSize / 2) + ($spacing / 2)
        
        $floors = Get-Random -Minimum $minFloors -Maximum ($maxFloors + 1)
        $windows = Get-Random -Minimum 3 -Maximum 7
        
        $building = New-BuildingFacade -name "${name}_Building_$i" `
            -floors $floors `
            -windowsPerFloor $windows `
            -addBalconies $addBalconies `
            -position @{x=$x; y=0; z=$z}
        
        if ($building) {
            $buildings += $building
        }
    }
    
    Write-Host "[SUCCESS] Generated $($buildings.Count) buildings for city block" -ForegroundColor Green
    return $buildings
}

<#
.SYNOPSIS
    Creates a procedural forest using point clouds and L-Systems
.DESCRIPTION
    Generates realistic forest with varied terrain and multiple tree types
.EXAMPLE
    New-ProceduralForest -name "EnchantedForest" -treeCount 50 -areaSize 200
#>
function New-ProceduralForest {
    param(
        [string]$name = "Forest",
        [int]$treeCount = 30,
        [float]$areaSize = 100.0,
        [bool]$generateTerrain = $true,
        [int]$seed = 0
    )

    Write-Host "[INFO] Generating procedural forest with $treeCount trees..." -ForegroundColor Cyan
    
    # Generate terrain base
    if ($generateTerrain) {
        Write-Host "[INFO] Generating terrain..." -ForegroundColor Cyan
        $terrain = New-PointCloudTerrain -name "${name}_Terrain" `
            -pointCount 15000 `
            -areaSize $areaSize `
            -noiseAmplitude 8.0 `
            -seed $seed
    }
    
    # Generate trees
    Write-Host "[INFO] Planting trees..." -ForegroundColor Cyan
    $trees = @()
    $halfSize = $areaSize / 2
    
    for ($i = 0; $i -lt $treeCount; $i++) {
        $x = (Get-Random) * $areaSize - $halfSize
        $z = (Get-Random) * $areaSize - $halfSize
        $y = 0  # You could sample terrain height here
        
        $iterations = Get-Random -Minimum 3 -Maximum 6
        $angle = Get-Random -Minimum 20 -Maximum 35
        
        $tree = New-LSystemTree -name "${name}_Tree_$i" `
            -iterations $iterations `
            -angle $angle `
            -segmentLength (Get-Random -Minimum 0.8 -Maximum 1.5) `
            -position @{x=$x; y=$y; z=$z}
        
        if ($tree) {
            $trees += $tree
        }
    }
    
    Write-Host "[SUCCESS] Generated forest with $($trees.Count) trees" -ForegroundColor Green
    return @{
        terrain = $terrain
        trees = $trees
    }
}

# Export functions
Export-ModuleMember -Function @(
    'New-PointCloudTerrain',
    'New-ProceduralTerrain',
    'New-BuildingFacade',
    'New-LSystemTree',
    'New-ProceduralCityBlock',
    'New-ProceduralForest'
)

Write-Host "[INFO] Point Cloud & Procedural Mesh Helper Functions Loaded" -ForegroundColor Cyan
Write-Host "Available functions: New-PointCloudTerrain, New-ProceduralTerrain, New-BuildingFacade, New-LSystemTree, New-ProceduralCityBlock, New-ProceduralForest" -ForegroundColor Gray
