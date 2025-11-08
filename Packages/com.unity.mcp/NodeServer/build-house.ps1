$baseUrl = "http://localhost:8765"
Write-Host "Building Brick House..." -ForegroundColor Cyan

# Helper function
function Create-Brick($name, $parent, $x, $y, $z) {
    $createBody = @{name=$name; primitiveType="Cube"; parent=$parent} | ConvertTo-Json -Compress
    curl -Method POST -Uri "$baseUrl/createGameObject" -ContentType "application/json" -Body $createBody -UseBasicParsing | Out-Null
    
    $transformBody = @{name=$name; position=@{x=$x;y=$y;z=$z}; scale=@{x=0.48;y=0.24;z=0.48}} | ConvertTo-Json -Compress
    curl -Method POST -Uri "$baseUrl/setTransform" -ContentType "application/json" -Body $transformBody -UseBasicParsing | Out-Null
}

# Create container
$body = '{"name": "BrickHouse"}'
curl -Method POST -Uri "$baseUrl/createGameObject" -ContentType "application/json" -Body $body -UseBasicParsing | Out-Null

$brickCount = 0

# Foundation (80 bricks - 20x4 grid)
Write-Host "Building foundation..." -ForegroundColor Yellow
for ($x = 0; $x -lt 20; $x++) {
    for ($z = 0; $z -lt 4; $z++) {
        Create-Brick "Foundation_$x`_$z" "BrickHouse" ($x*0.5) 0.12 ($z*0.5)
        $brickCount++
    }
}

# Front wall (60 bricks - 20 wide x 3 high)
Write-Host "Building front wall..." -ForegroundColor Yellow
for ($row = 0; $row -lt 3; $row++) {
    for ($i = 0; $i -lt 20; $i++) {
        Create-Brick "Front_$i`_$row" "BrickHouse" ($i*0.5) ($row*0.25+0.37) 0
        $brickCount++
    }
}

# Back wall (60 bricks)
Write-Host "Building back wall..." -ForegroundColor Yellow
for ($row = 0; $row -lt 3; $row++) {
    for ($i = 0; $i -lt 20; $i++) {
        Create-Brick "Back_$i`_$row" "BrickHouse" ($i*0.5) ($row*0.25+0.37) 2
        $brickCount++
    }
}

# Left wall (40 bricks - 4 deep x 10 high, with door gap)
Write-Host "Building left wall..." -ForegroundColor Yellow
for ($row = 0; $row -lt 10; $row++) {
    for ($i = 0; $i -lt 4; $i++) {
        if (-not ($row -lt 5 -and $i -eq 1)) {  # Door gap
            Create-Brick "Left_$i`_$row" "BrickHouse" 0 ($row*0.25+0.37) ($i*0.5)
            $brickCount++
        }
    }
}

# Right wall (40 bricks)
Write-Host "Building right wall..." -ForegroundColor Yellow
for ($row = 0; $row -lt 10; $row++) {
    for ($i = 0; $i -lt 4; $i++) {
        Create-Brick "Right_$i`_$row" "BrickHouse" 9.5 ($row*0.25+0.37) ($i*0.5)
        $brickCount++
    }
}

# Roof (100 bricks - slanted)
Write-Host "Building roof..." -ForegroundColor Yellow
for ($i = 0; $i -lt 20; $i++) {
    for ($side = 0; $side -lt 5; $side++) {
        $roofY = 2.87 + ($side * 0.2)
        $roofZ = 1 + ($side * 0.2 * ($side % 2 * 2 - 1))
        Create-Brick "Roof_$i`_$side" "BrickHouse" ($i*0.5) $roofY $roofZ
        $brickCount++
    }
}

# Chimney (20 bricks)
Write-Host "Building chimney..." -ForegroundColor Yellow
for ($row = 0; $row -lt 5; $row++) {
    for ($i = 0; $i -lt 2; $i++) {
        for ($j = 0; $j -lt 2; $j++) {
            Create-Brick "Chimney_$i`_$j`_$row" "BrickHouse" (8+$i*0.5) (3.5+$row*0.25) (0.5+$j*0.5)
            $brickCount++
        }
    }
}

# Lantern post (10 bricks vertical + light)
Write-Host "Building lantern..." -ForegroundColor Yellow
for ($i = 0; $i -lt 8; $i++) {
    Create-Brick "LanternPost_$i" "BrickHouse" -2 ($i*0.25+0.12) 1
    $brickCount++
}
$body = '{"name": "Lantern", "primitiveType": "Sphere", "parent": "BrickHouse"}'
curl -Method POST -Uri "$baseUrl/createGameObject" -ContentType "application/json" -Body $body -UseBasicParsing | Out-Null
$body = '{"name": "Lantern", "position": {"x": -2, "y": 2.2, "z": 1}, "scale": {"x": 0.4, "y": 0.4, "z": 0.4}}'
curl -Method POST -Uri "$baseUrl/setTransform" -ContentType "application/json" -Body $body -UseBasicParsing | Out-Null

# Road (60 bricks - 20x3 in front of house)
Write-Host "Building road..." -ForegroundColor Yellow
for ($x = 0; $x -lt 20; $x++) {
    for ($z = 0; $z -lt 3; $z++) {
        Create-Brick "Road_$x`_$z" "BrickHouse" ($x*0.5) 0.01 (-1.5-$z*0.5)
        $brickCount++
    }
}

Write-Host "`n=== CONSTRUCTION COMPLETE ===" -ForegroundColor Green
Write-Host "Total bricks used: $brickCount" -ForegroundColor Cyan
Write-Host "House with foundation, walls, roof, chimney, lantern, and road" -ForegroundColor White
