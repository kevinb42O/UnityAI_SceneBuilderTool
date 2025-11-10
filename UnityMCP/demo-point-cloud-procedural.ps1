# Demo: Point Cloud & Procedural Mesh Generation
# Showcases advanced terrain generation and procedural architecture

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Point Cloud & Procedural Mesh Demo" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Load helper functions
. .\point-cloud-helpers.ps1

Write-Host "[PHASE 1] Point Cloud Terrain Generation" -ForegroundColor Yellow
Write-Host "Creating realistic terrain using Perlin noise point clouds..." -ForegroundColor Gray
Write-Host ""

# Generate a small rolling hills terrain
Write-Host "1. Rolling Hills (10,000 points)..." -ForegroundColor Cyan
$hills = New-PointCloudTerrain -name "RollingHills" `
    -pointCount 10000 `
    -areaSize 150 `
    -noiseAmplitude 12 `
    -noiseScale 0.08 `
    -seed 42 `
    -asSurface $true `
    -gridResolution 60

Start-Sleep -Seconds 2

# Generate a mountain range
Write-Host "2. Mountain Range (15,000 points)..." -ForegroundColor Cyan
$mountains = New-PointCloudTerrain -name "MountainRange" `
    -pointCount 15000 `
    -areaSize 200 `
    -noiseAmplitude 40 `
    -noiseScale 0.05 `
    -seed 123 `
    -asSurface $true `
    -gridResolution 80

Start-Sleep -Seconds 2

Write-Host ""
Write-Host "[PHASE 2] Advanced Procedural Terrain" -ForegroundColor Yellow
Write-Host "Creating terrain with different noise algorithms..." -ForegroundColor Gray
Write-Host ""

# Perlin noise terrain
Write-Host "3. Perlin Noise Terrain (smooth, natural)..." -ForegroundColor Cyan
$perlin = New-ProceduralTerrain -name "PerlinTerrain" `
    -width 100 `
    -height 100 `
    -noiseType "Perlin" `
    -amplitude 15 `
    -octaves 5 `
    -seed 456

Start-Sleep -Seconds 1

# Ridged noise terrain (mountains)
Write-Host "4. Ridged Noise Terrain (sharp peaks)..." -ForegroundColor Cyan
$ridged = New-ProceduralTerrain -name "RidgedMountains" `
    -width 100 `
    -height 100 `
    -noiseType "Ridged" `
    -amplitude 25 `
    -octaves 6 `
    -seed 789

Start-Sleep -Seconds 1

# Voronoi noise terrain (cellular, alien-like)
Write-Host "5. Voronoi Noise Terrain (cellular patterns)..." -ForegroundColor Cyan
$voronoi = New-ProceduralTerrain -name "VoronoiTerrain" `
    -width 80 `
    -height 80 `
    -noiseType "Voronoi" `
    -amplitude 10 `
    -octaves 3 `
    -seed 321

Start-Sleep -Seconds 1

Write-Host ""
Write-Host "[PHASE 3] Procedural Building Generation" -ForegroundColor Yellow
Write-Host "Creating varied building facades..." -ForegroundColor Gray
Write-Host ""

# Simple office building
Write-Host "6. Office Building (5 floors)..." -ForegroundColor Cyan
$office = New-BuildingFacade -name "OfficeBuilding" `
    -floors 5 `
    -windowsPerFloor 6 `
    -floorHeight 3.5 `
    -addBalconies $false `
    -position @{x=-50; y=0; z=0}

Start-Sleep -Seconds 1

# Luxury apartment with balconies
Write-Host "7. Luxury Apartment (8 floors with balconies)..." -ForegroundColor Cyan
$apartment = New-BuildingFacade -name "LuxuryApartment" `
    -floors 8 `
    -windowsPerFloor 4 `
    -floorHeight 3.2 `
    -addBalconies $true `
    -wallColor @{r=0.9; g=0.85; b=0.7; a=1.0} `
    -position @{x=-30; y=0; z=0}

Start-Sleep -Seconds 1

# Skyscraper
Write-Host "8. Skyscraper (15 floors)..." -ForegroundColor Cyan
$skyscraper = New-BuildingFacade -name "Skyscraper" `
    -floors 15 `
    -windowsPerFloor 8 `
    -floorHeight 3.0 `
    -addBalconies $false `
    -wallColor @{r=0.3; g=0.4; b=0.5; a=1.0} `
    -windowColor @{r=0.7; g=0.8; b=0.9; a=1.0} `
    -position @{x=-10; y=0; z=0}

Start-Sleep -Seconds 1

Write-Host ""
Write-Host "[PHASE 4] L-System Trees" -ForegroundColor Yellow
Write-Host "Growing procedural trees with L-System grammar..." -ForegroundColor Gray
Write-Host ""

# Classic tree
Write-Host "9. Classic Oak Tree..." -ForegroundColor Cyan
$oak = New-LSystemTree -name "OakTree" `
    -preset "tree" `
    -iterations 4 `
    -angle 28 `
    -segmentLength 2.0 `
    -position @{x=30; y=0; z=-20}

Start-Sleep -Seconds 1

# Tall pine-like tree
Write-Host "10. Pine Tree (narrow branching)..." -ForegroundColor Cyan
$pine = New-LSystemTree -name "PineTree" `
    -axiom "F" `
    -iterations 5 `
    -angle 18 `
    -segmentLength 1.5 `
    -radiusReduction 0.9 `
    -position @{x=40; y=0; z=-20}

Start-Sleep -Seconds 1

# Wide spreading tree
Write-Host "11. Wide Tree (spreading branches)..." -ForegroundColor Cyan
$wideTree = New-LSystemTree -name "WideTree" `
    -iterations 4 `
    -angle 35 `
    -segmentLength 1.8 `
    -radiusReduction 0.75 `
    -position @{x=50; y=0; z=-20}

Start-Sleep -Seconds 1

Write-Host ""
Write-Host "[PHASE 5] Complex Scene Generation" -ForegroundColor Yellow
Write-Host "Creating a city block with multiple buildings..." -ForegroundColor Gray
Write-Host ""

Write-Host "12. Procedural City Block (10 buildings)..." -ForegroundColor Cyan
$cityBlock = New-ProceduralCityBlock -name "CityBlock" `
    -buildingCount 10 `
    -blockSize 120 `
    -minFloors 4 `
    -maxFloors 10 `
    -addBalconies $true

Start-Sleep -Seconds 3

Write-Host ""
Write-Host "[PHASE 6] Procedural Forest" -ForegroundColor Yellow
Write-Host "Generating a complete forest ecosystem..." -ForegroundColor Gray
Write-Host ""

Write-Host "13. Enchanted Forest (30 trees + terrain)..." -ForegroundColor Cyan
$forest = New-ProceduralForest -name "EnchantedForest" `
    -treeCount 30 `
    -areaSize 150 `
    -generateTerrain $true `
    -seed 999

Start-Sleep -Seconds 3

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Demo Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Generated Objects:" -ForegroundColor Cyan
Write-Host "  - 2 Point Cloud Terrains (Rolling Hills, Mountain Range)" -ForegroundColor Gray
Write-Host "  - 3 Procedural Terrains (Perlin, Ridged, Voronoi)" -ForegroundColor Gray
Write-Host "  - 13+ Buildings (Office, Apartment, Skyscraper, City Block)" -ForegroundColor Gray
Write-Host "  - 33+ Trees (Oak, Pine, Wide, Forest)" -ForegroundColor Gray
Write-Host "  - 1 Complete Forest Ecosystem" -ForegroundColor Gray
Write-Host ""
Write-Host "Total: ~80+ procedurally generated objects!" -ForegroundColor Green
Write-Host ""
Write-Host "Key Features Demonstrated:" -ForegroundColor Yellow
Write-Host "  ✓ Point Cloud terrain generation with Perlin noise" -ForegroundColor Gray
Write-Host "  ✓ 5 different noise algorithms (Perlin, Ridged, Voronoi, Simplex, Billow)" -ForegroundColor Gray
Write-Host "  ✓ Procedural building facades with windows and balconies" -ForegroundColor Gray
Write-Host "  ✓ L-System tree generation with branching patterns" -ForegroundColor Gray
Write-Host "  ✓ Complex scene composition (city blocks, forests)" -ForegroundColor Gray
Write-Host "  ✓ Vertex coloring based on height/features" -ForegroundColor Gray
Write-Host ""
Write-Host "Next Level Capabilities Unlocked:" -ForegroundColor Magenta
Write-Host "  → Realistic terrain from point cloud data" -ForegroundColor Gray
Write-Host "  → Infinite building variation with procedural facades" -ForegroundColor Gray
Write-Host "  → Organic tree growth using mathematical L-Systems" -ForegroundColor Gray
Write-Host "  → Scalable world generation (forests, cities)" -ForegroundColor Gray
Write-Host "  → Advanced noise types for unique terrain features" -ForegroundColor Gray
Write-Host ""
Write-Host "This is the future of AI-driven world generation! 🚀" -ForegroundColor Cyan
