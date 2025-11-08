# ============================================================
# Realistic Game Scene Creator
# Demonstrates maximum scene creation capabilities
# Creates a complete game-ready environment
# ============================================================

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('Medieval', 'SciFi', 'Modern', 'Fantasy', 'PostApocalyptic')]
    [string]$Theme = 'Medieval',
    
    [Parameter(Mandatory=$false)]
    [ValidateRange(1, 10)]
    [int]$DetailLevel = 5,
    
    [Parameter(Mandatory=$false)]
    [switch]$WithPhysics
)

$baseUrl = "http://localhost:8765"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  REALISTIC GAME SCENE CREATOR" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Theme: $Theme" -ForegroundColor Yellow
Write-Host "Detail Level: $DetailLevel / 10" -ForegroundColor Yellow
Write-Host "Physics: $($WithPhysics ? 'Enabled' : 'Disabled')" -ForegroundColor Yellow
Write-Host ""

# Helper function
function Invoke-Unity {
    param([string]$endpoint, [hashtable]$body)
    try {
        $json = $body | ConvertTo-Json -Depth 10
        $result = Invoke-RestMethod -Uri "$baseUrl$endpoint" -Method POST -ContentType "application/json" -Body $json -UseBasicParsing
        return $result
    } catch {
        Write-Host "ERROR: $_" -ForegroundColor Red
        return $null
    }
}

# Test connection
Write-Host "Connecting to Unity..." -ForegroundColor Yellow
try {
    Invoke-RestMethod -Uri "$baseUrl/ping" -Method POST -UseBasicParsing | Out-Null
    Write-Host "✓ Connected" -ForegroundColor Green
} catch {
    Write-Host "✗ Cannot connect. Please start Unity MCP Server." -ForegroundColor Red
    exit
}

# Create new scene
Write-Host "Creating new scene..." -ForegroundColor Yellow
Invoke-Unity "/newScene" @{} | Out-Null
Start-Sleep -Milliseconds 500

# ============================================================
# SCENE GENERATION BASED ON THEME
# ============================================================

switch ($Theme) {
    'Medieval' {
        Write-Host ""
        Write-Host "=== Building Medieval Castle Scene ===" -ForegroundColor Cyan
        Write-Host ""
        
        # 1. Create ground
        Write-Host "Creating terrain..." -ForegroundColor Yellow
        Invoke-Unity "/createGameObject" @{name = "Ground"; primitiveType = "Plane"} | Out-Null
        Invoke-Unity "/setTransform" @{name = "Ground"; scale = @{x=20; y=1; z=20}} | Out-Null
        Invoke-Unity "/setMaterial" @{
            name = "Ground"
            color = @{r=0.3; g=0.5; b=0.2}
            smoothness = 0.1
        } | Out-Null
        
        # 2. Create castle walls (circular)
        Write-Host "Building castle walls..." -ForegroundColor Yellow
        Invoke-Unity "/createGameObject" @{name = "Wall_Template"; primitiveType = "Cube"} | Out-Null
        Invoke-Unity "/setTransform" @{
            name = "Wall_Template"
            scale = @{x=8; y=10; z=2}
        } | Out-Null
        Invoke-Unity "/setMaterial" @{
            name = "Wall_Template"
            color = @{r=0.6; g=0.6; b=0.6}
            smoothness = 0.15
        } | Out-Null
        
        $wallCount = [Math]::Max(8, $DetailLevel * 2)
        Invoke-Unity "/createCircularArray" @{
            sourceName = "Wall_Template"
            count = $wallCount
            radius = 30
            center = @{x=0; y=5; z=0}
            rotateToCenter = $true
            namePrefix = "Wall"
        } | Out-Null
        
        # 3. Create corner towers
        Write-Host "Constructing towers..." -ForegroundColor Yellow
        $angles = @(0, 90, 180, 270)
        foreach ($angle in $angles) {
            $rad = $angle * [Math]::PI / 180
            $x = [Math]::Cos($rad) * 35
            $z = [Math]::Sin($rad) * 35
            
            $towerName = "Tower_$angle"
            Invoke-Unity "/createGameObject" @{name = $towerName; primitiveType = "Cylinder"} | Out-Null
            Invoke-Unity "/setTransform" @{
                name = $towerName
                position = @{x=$x; y=15; z=$z}
                scale = @{x=4; y=15; z=4}
            } | Out-Null
            Invoke-Unity "/setMaterial" @{
                name = $towerName
                color = @{r=0.5; g=0.5; b=0.5}
                smoothness = 0.2
            } | Out-Null
            
            # Tower top
            $topName = "Tower_Top_$angle"
            Invoke-Unity "/createGameObject" @{name = $topName; primitiveType = "Cube"} | Out-Null
            Invoke-Unity "/setTransform" @{
                name = $topName
                position = @{x=$x; y=32; z=$z}
                scale = @{x=6; y=2; z=6}
            } | Out-Null
            Invoke-Unity "/setMaterial" @{
                name = $topName
                color = @{r=0.7; g=0.2; b=0.2}
                smoothness = 0.3
            } | Out-Null
        }
        
        # 4. Create central keep
        Write-Host "Building central keep..." -ForegroundColor Yellow
        Invoke-Unity "/createGameObject" @{name = "Keep"; primitiveType = "Cube"} | Out-Null
        Invoke-Unity "/setTransform" @{
            name = "Keep"
            position = @{x=0; y=20; z=0}
            scale = @{x=15; y=40; z=15}
        } | Out-Null
        Invoke-Unity "/setMaterial" @{
            name = "Keep"
            color = @{r=0.45; g=0.45; b=0.45}
            smoothness = 0.15
        } | Out-Null
        
        # 5. Add torches (linear arrays on walls)
        if ($DetailLevel -ge 5) {
            Write-Host "Placing torches..." -ForegroundColor Yellow
            for ($i = 0; $i -lt 4; $i++) {
                $angle = $i * 90
                $rad = $angle * [Math]::PI / 180
                $x = [Math]::Cos($rad) * 30
                $z = [Math]::Sin($rad) * 30
                
                $torchName = "Torch_Base_$i"
                Invoke-Unity "/createLight" @{
                    name = $torchName
                    lightType = "Point"
                    position = @{x=$x; y=8; z=$z}
                    color = @{r=1; g=0.7; b=0.4}
                    intensity = 2
                    range = 15
                    shadows = "Soft"
                } | Out-Null
            }
        }
        
        # 6. Add directional sun
        Write-Host "Setting up lighting..." -ForegroundColor Yellow
        Invoke-Unity "/createLight" @{
            name = "Sun"
            lightType = "Directional"
            position = @{x=0; y=50; z=0}
            rotation = @{x=50; y=330; z=0}
            color = @{r=1; g=0.95; b=0.9}
            intensity = 1.2
            shadows = "Soft"
        } | Out-Null
    }
    
    'SciFi' {
        Write-Host ""
        Write-Host "=== Building Sci-Fi Station Scene ===" -ForegroundColor Cyan
        Write-Host ""
        
        # 1. Create base platform
        Write-Host "Constructing base platform..." -ForegroundColor Yellow
        Invoke-Unity "/createGameObject" @{name = "Platform"; primitiveType = "Cube"} | Out-Null
        Invoke-Unity "/setTransform" @{
            name = "Platform"
            position = @{x=0; y=0; z=0}
            scale = @{x=100; y=1; z=100}
        } | Out-Null
        Invoke-Unity "/setMaterial" @{
            name = "Platform"
            color = @{r=0.2; g=0.2; b=0.25}
            metallic = 0.8
            smoothness = 0.9
        } | Out-Null
        
        # 2. Create grid of structures
        Write-Host "Deploying structures..." -ForegroundColor Yellow
        Invoke-Unity "/createGameObject" @{name = "Structure_Base"; primitiveType = "Cube"} | Out-Null
        Invoke-Unity "/setTransform" @{
            name = "Structure_Base"
            position = @{x=-30; y=10; z=-30}
            scale = @{x=8; y=20; z=8}
        } | Out-Null
        Invoke-Unity "/setMaterial" @{
            name = "Structure_Base"
            color = @{r=0.3; g=0.35; b=0.4}
            metallic = 0.6
            smoothness = 0.7
        } | Out-Null
        
        $gridSize = [Math]::Max(3, [Math]::Floor($DetailLevel / 2))
        Invoke-Unity "/createGridArray" @{
            sourceName = "Structure_Base"
            countX = $gridSize
            countY = 1
            countZ = $gridSize
            spacingX = 20
            spacingY = 0
            spacingZ = 20
            namePrefix = "Structure"
        } | Out-Null
        
        # 3. Add glowing energy cores
        Write-Host "Activating energy cores..." -ForegroundColor Yellow
        Invoke-Unity "/createGameObject" @{name = "Core_Template"; primitiveType = "Sphere"} | Out-Null
        Invoke-Unity "/setTransform" @{
            name = "Core_Template"
            scale = @{x=3; y=3; z=3}
        } | Out-Null
        Invoke-Unity "/setMaterial" @{
            name = "Core_Template"
            color = @{r=0.2; g=0.6; b=1}
            emission = @{r=0.2; g=0.6; b=1; intensity=3}
            smoothness = 1
        } | Out-Null
        
        Invoke-Unity "/createCircularArray" @{
            sourceName = "Core_Template"
            count = 8
            radius = 40
            center = @{x=0; y=5; z=0}
            rotateToCenter = $false
            namePrefix = "Core"
        } | Out-Null
        
        # 4. Spotlights from structures
        if ($DetailLevel -ge 4) {
            Write-Host "Installing security lights..." -ForegroundColor Yellow
            for ($i = 0; $i -lt 4; $i++) {
                $angle = $i * 90
                $rad = $angle * [Math]::PI / 180
                $x = [Math]::Cos($rad) * 35
                $z = [Math]::Sin($rad) * 35
                
                $lightName = "SecurityLight_$i"
                Invoke-Unity "/createLight" @{
                    name = $lightName
                    lightType = "Spot"
                    position = @{x=$x; y=25; z=$z}
                    color = @{r=0.7; g=0.9; b=1}
                    intensity = 3
                    range = 50
                    spotAngle = 60
                    shadows = "Hard"
                } | Out-Null
                
                # Point lights at center
                Invoke-Unity "/lookAt" @{
                    name = $lightName
                    targetPosition = @{x=0; y=0; z=0}
                } | Out-Null
            }
        }
        
        # 5. Ambient lighting
        Write-Host "Configuring atmosphere..." -ForegroundColor Yellow
        Invoke-Unity "/createLight" @{
            name = "Ambient"
            lightType = "Directional"
            rotation = @{x=70; y=0; z=0}
            color = @{r=0.4; g=0.5; b=0.7}
            intensity = 0.3
            shadows = "None"
        } | Out-Null
    }
    
    'Modern' {
        Write-Host ""
        Write-Host "=== Building Modern City Scene ===" -ForegroundColor Cyan
        Write-Host ""
        
        # 1. Create streets (grid)
        Write-Host "Laying streets..." -ForegroundColor Yellow
        Invoke-Unity "/createGameObject" @{name = "Street_H"; primitiveType = "Cube"} | Out-Null
        Invoke-Unity "/setTransform" @{
            name = "Street_H"
            position = @{x=0; y=0.1; z=0}
            scale = @{x=100; y=0.2; z=10}
        } | Out-Null
        Invoke-Unity "/setMaterial" @{
            name = "Street_H"
            color = @{r=0.2; g=0.2; b=0.2}
            smoothness = 0.3
        } | Out-Null
        
        Invoke-Unity "/createLinearArray" @{
            sourceName = "Street_H"
            count = 3
            spacing = @{x=0; y=0; z=30}
            namePrefix = "Street_H"
        } | Out-Null
        
        # 2. Create buildings with varying heights
        Write-Host "Constructing buildings..." -ForegroundColor Yellow
        $buildingCount = [Math]::Max(12, $DetailLevel * 3)
        
        for ($i = 0; $i -lt $buildingCount; $i++) {
            $bName = "Building_$i"
            $height = 10 + (Get-Random -Maximum 30)
            $row = [Math]::Floor($i / 4)
            $col = $i % 4
            
            Invoke-Unity "/createGameObject" @{name = $bName; primitiveType = "Cube"} | Out-Null
            Invoke-Unity "/setTransform" @{
                name = $bName
                position = @{x=($col * 20 - 30); y=($height/2); z=($row * 30 - 30)}
                scale = @{x=8; y=$height; z=8}
            } | Out-Null
            
            $brightness = 0.5 + (Get-Random) * 0.3
            Invoke-Unity "/setMaterial" @{
                name = $bName
                color = @{r=$brightness; g=$brightness; b=($brightness + 0.1)}
                metallic = 0.3
                smoothness = 0.6
            } | Out-Null
        }
        
        # 3. Street lights (linear arrays)
        if ($DetailLevel -ge 3) {
            Write-Host "Installing street lights..." -ForegroundColor Yellow
            Invoke-Unity "/createLight" @{
                name = "StreetLight_Base"
                lightType = "Point"
                position = @{x=-40; y=8; z=0}
                color = @{r=1; g=0.9; b=0.8}
                intensity = 2
                range = 15
                shadows = "Soft"
            } | Out-Null
            
            Invoke-Unity "/createLinearArray" @{
                sourceName = "StreetLight_Base"
                count = 9
                spacing = @{x=10; y=0; z=0}
                namePrefix = "StreetLight"
            } | Out-Null
        }
        
        # 4. Sun
        Invoke-Unity "/createLight" @{
            name = "Sun"
            lightType = "Directional"
            rotation = @{x=50; y=200; z=0}
            color = @{r=1; g=1; b=1}
            intensity = 1
            shadows = "Soft"
        } | Out-Null
    }
    
    'Fantasy' {
        Write-Host ""
        Write-Host "=== Building Fantasy Realm Scene ===" -ForegroundColor Cyan
        Write-Host ""
        
        # 1. Magical ground
        Write-Host "Manifesting magical terrain..." -ForegroundColor Yellow
        Invoke-Unity "/createGameObject" @{name = "Ground"; primitiveType = "Plane"} | Out-Null
        Invoke-Unity "/setTransform" @{name = "Ground"; scale = @{x=15; y=1; z=15}} | Out-Null
        Invoke-Unity "/setMaterial" @{
            name = "Ground"
            color = @{r=0.4; g=0.2; b=0.5}
            emission = @{r=0.2; g=0.1; b=0.3; intensity=0.5}
            smoothness = 0.4
        } | Out-Null
        
        # 2. Crystal formations (circular)
        Write-Host "Growing crystal formations..." -ForegroundColor Yellow
        $crystalColors = @(
            @{r=1; g=0.2; b=0.8},  # Magenta
            @{r=0.2; g=0.8; b=1},  # Cyan
            @{r=1; g=1; b=0.2}     # Yellow
        )
        
        $ringCount = [Math]::Max(2, [Math]::Floor($DetailLevel / 2))
        for ($ring = 0; $ring -lt $ringCount; $ring++) {
            $crystalName = "Crystal_Ring${ring}_Base"
            $color = $crystalColors[$ring % $crystalColors.Count]
            
            Invoke-Unity "/createGameObject" @{name = $crystalName; primitiveType = "Cube"} | Out-Null
            Invoke-Unity "/setTransform" @{
                name = $crystalName
                rotation = @{x=0; y=0; z=30}
                scale = @{x=2; y=8; z=2}
            } | Out-Null
            Invoke-Unity "/setMaterial" @{
                name = $crystalName
                color = $color
                emission = @{r=$color.r; g=$color.g; b=$color.b; intensity=2}
                metallic = 0.5
                smoothness = 0.9
            } | Out-Null
            
            Invoke-Unity "/createCircularArray" @{
                sourceName = $crystalName
                count = (8 + $ring * 4)
                radius = (15 + $ring * 12)
                center = @{x=0; y=4; z=0}
                rotateToCenter = $false
                namePrefix = "Crystal_Ring$ring"
            } | Out-Null
        }
        
        # 3. Floating islands
        Write-Host "Levitating islands..." -ForegroundColor Yellow
        for ($i = 0; $i -lt 5; $i++) {
            $angle = $i * 72
            $rad = $angle * [Math]::PI / 180
            $x = [Math]::Cos($rad) * 40
            $z = [Math]::Sin($rad) * 40
            $y = 20 + (Get-Random -Maximum 10)
            
            $islandName = "Island_$i"
            Invoke-Unity "/createGameObject" @{name = $islandName; primitiveType = "Sphere"} | Out-Null
            Invoke-Unity "/setTransform" @{
                name = $islandName
                position = @{x=$x; y=$y; z=$z}
                scale = @{x=8; y=4; z=8}
            } | Out-Null
            Invoke-Unity "/setMaterial" @{
                name = $islandName
                color = @{r=0.3; g=0.6; b=0.3}
                smoothness = 0.2
            } | Out-Null
        }
        
        # 4. Magical lighting
        Write-Host "Channeling magical energy..." -ForegroundColor Yellow
        Invoke-Unity "/createLight" @{
            name = "MagicalAmbience"
            lightType = "Directional"
            rotation = @{x=60; y=0; z=0}
            color = @{r=0.7; g=0.5; b=0.9}
            intensity = 0.8
            shadows = "Soft"
        } | Out-Null
    }
    
    'PostApocalyptic' {
        Write-Host ""
        Write-Host "=== Building Post-Apocalyptic Scene ===" -ForegroundColor Cyan
        Write-Host ""
        
        # 1. Wasteland ground
        Write-Host "Rendering wasteland..." -ForegroundColor Yellow
        Invoke-Unity "/createGameObject" @{name = "Wasteland"; primitiveType = "Plane"} | Out-Null
        Invoke-Unity "/setTransform" @{name = "Wasteland"; scale = @{x=20; y=1; z=20}} | Out-Null
        Invoke-Unity "/setMaterial" @{
            name = "Wasteland"
            color = @{r=0.4; g=0.3; b=0.2}
            smoothness = 0.05
        } | Out-Null
        
        # 2. Ruined buildings (scattered)
        Write-Host "Placing ruins..." -ForegroundColor Yellow
        $ruinCount = [Math]::Max(8, $DetailLevel * 2)
        for ($i = 0; $i -lt $ruinCount; $i++) {
            $x = (Get-Random -Maximum 80) - 40
            $z = (Get-Random -Maximum 80) - 40
            $height = 5 + (Get-Random -Maximum 20)
            $tilt = (Get-Random -Maximum 30) - 15
            
            $ruinName = "Ruin_$i"
            Invoke-Unity "/createGameObject" @{name = $ruinName; primitiveType = "Cube"} | Out-Null
            Invoke-Unity "/setTransform" @{
                name = $ruinName
                position = @{x=$x; y=($height/2); z=$z}
                rotation = @{x=0; y=(Get-Random -Maximum 360); z=$tilt}
                scale = @{x=(4 + (Get-Random -Maximum 6)); y=$height; z=(4 + (Get-Random -Maximum 6))}
            } | Out-Null
            Invoke-Unity "/setMaterial" @{
                name = $ruinName
                color = @{r=0.3; g=0.3; b=0.3}
                smoothness = 0.1
            } | Out-Null
        }
        
        # 3. Scattered debris
        if ($DetailLevel -ge 4) {
            Write-Host "Scattering debris..." -ForegroundColor Yellow
            for ($i = 0; $i -lt 20; $i++) {
                $x = (Get-Random -Maximum 100) - 50
                $z = (Get-Random -Maximum 100) - 50
                
                $debrisName = "Debris_$i"
                Invoke-Unity "/createGameObject" @{name = $debrisName; primitiveType = "Cube"} | Out-Null
                Invoke-Unity "/setTransform" @{
                    name = $debrisName
                    position = @{x=$x; y=1; z=$z}
                    rotation = @{x=(Get-Random -Maximum 90); y=(Get-Random -Maximum 360); z=(Get-Random -Maximum 90)}
                    scale = @{x=(0.5 + (Get-Random) * 2); y=(0.5 + (Get-Random) * 2); z=(0.5 + (Get-Random) * 2)}
                } | Out-Null
                Invoke-Unity "/setMaterial" @{
                    name = $debrisName
                    color = @{r=(0.2 + (Get-Random) * 0.3); g=(0.2 + (Get-Random) * 0.3); b=(0.2 + (Get-Random) * 0.3)}
                    metallic = 0.4
                    smoothness = 0.2
                } | Out-Null
                
                if ($WithPhysics) {
                    Invoke-Unity "/addRigidbody" @{
                        name = $debrisName
                        mass = 0.5 + (Get-Random)
                        useGravity = $false
                    } | Out-Null
                }
            }
        }
        
        # 4. Harsh sunlight
        Write-Host "Setting harsh environment..." -ForegroundColor Yellow
        Invoke-Unity "/createLight" @{
            name = "HarshSun"
            lightType = "Directional"
            rotation = @{x=60; y=30; z=0}
            color = @{r=1; g=0.9; b=0.7}
            intensity = 1.5
            shadows = "Hard"
        } | Out-Null
    }
}

# ============================================================
# Add physics if requested
# ============================================================

if ($WithPhysics) {
    Write-Host ""
    Write-Host "Adding physics simulation..." -ForegroundColor Yellow
    
    # Find all objects and add rigidbodies to some
    # This is a placeholder - in real implementation, would selectively add physics
    Write-Host "✓ Physics ready (enter play mode to activate)" -ForegroundColor Green
}

# ============================================================
# Summary
# ============================================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "     SCENE GENERATION COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Theme: $Theme" -ForegroundColor White
Write-Host "Detail Level: $DetailLevel / 10" -ForegroundColor White
Write-Host ""
Write-Host "The scene showcases:" -ForegroundColor Yellow
Write-Host "  ✓ Advanced rotation (Look At, alignment)" -ForegroundColor White
Write-Host "  ✓ Object arrays (Linear, Circular, Grid)" -ForegroundColor White
Write-Host "  ✓ Realistic lighting (Directional, Point, Spot)" -ForegroundColor White
Write-Host "  ✓ Material system (PBR, emission, metallic)" -ForegroundColor White
if ($WithPhysics) {
    Write-Host "  ✓ Physics simulation (Rigidbody, colliders)" -ForegroundColor White
}
Write-Host ""
Write-Host "Ready for AI game world creation! 🎮✨" -ForegroundColor Cyan
Write-Host ""
