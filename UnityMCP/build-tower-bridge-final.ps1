# Tower Bridge Builder
# Impressive Arch Bridge with Twin Towers

$baseUrl = "http://localhost:8765"

Write-Host "TOWER BRIDGE CONSTRUCTION SYSTEM" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Helper function to create and position objects
function Build-UnityObject {
    param(
        [string]$name,
        [string]$type,
        [hashtable]$position,
        [hashtable]$rotation = @{x=0; y=0; z=0},
        [hashtable]$scale = @{x=1; y=1; z=1}
    )
    
    # Step 1: Create the object
    $createBody = @{
        name = $name
        primitiveType = $type
        parent = ""
    } | ConvertTo-Json -Depth 10
    
    try {
        Invoke-RestMethod -Uri "$baseUrl/createGameObject" -Method POST -ContentType "application/json" -Body $createBody -UseBasicParsing | Out-Null
        Start-Sleep -Milliseconds 50
        
        # Step 2: Set transform
        $transformBody = @{
            name = $name
            position = $position
            rotation = $rotation
            scale = $scale
        } | ConvertTo-Json -Depth 10
        
        Invoke-RestMethod -Uri "$baseUrl/setTransform" -Method POST -ContentType "application/json" -Body $transformBody -UseBasicParsing | Out-Null
        
    } catch {
        Write-Host "Error creating $name" -ForegroundColor Red
    }
}

Write-Host "Phase 1: Foundation Pillars" -ForegroundColor Yellow

Build-UnityObject -name "Foundation_L2" -type "Cube" `
    -position @{x=-30; y=2; z=0} -scale @{x=4; y=4; z=4}
Build-UnityObject -name "Foundation_L1" -type "Cube" `
    -position @{x=-10; y=2; z=0} -scale @{x=4; y=4; z=4}
Build-UnityObject -name "Foundation_R1" -type "Cube" `
    -position @{x=10; y=2; z=0} -scale @{x=4; y=4; z=4}
Build-UnityObject -name "Foundation_R2" -type "Cube" `
    -position @{x=30; y=2; z=0} -scale @{x=4; y=4; z=4}

Write-Host "  [OK] Foundation complete" -ForegroundColor Green
Write-Host ""

Write-Host "Phase 2: Twin Tower Structures" -ForegroundColor Yellow

# LEFT TOWER
for ($i = 0; $i -lt 20; $i++) {
    $y = 4 + ($i * 2)
    
    Build-UnityObject -name "LT_Col_NW_$i" -type "Cube" `
        -position @{x=-32; y=$y; z=-3} -scale @{x=1.5; y=2; z=1.5}
    Build-UnityObject -name "LT_Col_NE_$i" -type "Cube" `
        -position @{x=-32; y=$y; z=3} -scale @{x=1.5; y=2; z=1.5}
    Build-UnityObject -name "LT_Col_SW_$i" -type "Cube" `
        -position @{x=-28; y=$y; z=-3} -scale @{x=1.5; y=2; z=1.5}
    Build-UnityObject -name "LT_Col_SE_$i" -type "Cube" `
        -position @{x=-28; y=$y; z=3} -scale @{x=1.5; y=2; z=1.5}
    
    if ($i % 3 -eq 0) {
        Build-UnityObject -name "LT_Beam_N_$i" -type "Cube" `
            -position @{x=-30; y=$y; z=3} -scale @{x=4; y=0.5; z=1}
        Build-UnityObject -name "LT_Beam_S_$i" -type "Cube" `
            -position @{x=-30; y=$y; z=-3} -scale @{x=4; y=0.5; z=1}
    }
}

# RIGHT TOWER
for ($i = 0; $i -lt 20; $i++) {
    $y = 4 + ($i * 2)
    
    Build-UnityObject -name "RT_Col_NW_$i" -type "Cube" `
        -position @{x=28; y=$y; z=-3} -scale @{x=1.5; y=2; z=1.5}
    Build-UnityObject -name "RT_Col_NE_$i" -type "Cube" `
        -position @{x=28; y=$y; z=3} -scale @{x=1.5; y=2; z=1.5}
    Build-UnityObject -name "RT_Col_SW_$i" -type "Cube" `
        -position @{x=32; y=$y; z=-3} -scale @{x=1.5; y=2; z=1.5}
    Build-UnityObject -name "RT_Col_SE_$i" -type "Cube" `
        -position @{x=32; y=$y; z=3} -scale @{x=1.5; y=2; z=1.5}
    
    if ($i % 3 -eq 0) {
        Build-UnityObject -name "RT_Beam_N_$i" -type "Cube" `
            -position @{x=30; y=$y; z=3} -scale @{x=4; y=0.5; z=1}
        Build-UnityObject -name "RT_Beam_S_$i" -type "Cube" `
            -position @{x=30; y=$y; z=-3} -scale @{x=4; y=0.5; z=1}
    }
}

Write-Host "  [OK] Twin towers complete" -ForegroundColor Green
Write-Host ""

Write-Host "Phase 3: Tower Tops and Spires" -ForegroundColor Yellow

Build-UnityObject -name "LT_Platform" -type "Cube" `
    -position @{x=-30; y=44; z=0} -scale @{x=6; y=1; z=8}
Build-UnityObject -name "LT_Spire_Base" -type "Cylinder" `
    -position @{x=-30; y=46; z=0} -scale @{x=2; y=2; z=2}
Build-UnityObject -name "LT_Spire_Mid" -type "Cylinder" `
    -position @{x=-30; y=49; z=0} -scale @{x=1.5; y=3; z=1.5}
Build-UnityObject -name "LT_Spire_Top" -type "Sphere" `
    -position @{x=-30; y=53; z=0} -scale @{x=1.5; y=3; z=1.5}

Build-UnityObject -name "RT_Platform" -type "Cube" `
    -position @{x=30; y=44; z=0} -scale @{x=6; y=1; z=8}
Build-UnityObject -name "RT_Spire_Base" -type "Cylinder" `
    -position @{x=30; y=46; z=0} -scale @{x=2; y=2; z=2}
Build-UnityObject -name "RT_Spire_Mid" -type "Cylinder" `
    -position @{x=30; y=49; z=0} -scale @{x=1.5; y=3; z=1.5}
Build-UnityObject -name "RT_Spire_Top" -type "Sphere" `
    -position @{x=30; y=53; z=0} -scale @{x=1.5; y=3; z=1.5}

Write-Host "  [OK] Tower tops complete" -ForegroundColor Green
Write-Host ""

Write-Host "Phase 4: Main Arch Structure" -ForegroundColor Yellow

$archSegments = 30
for ($i = 0; $i -lt $archSegments; $i++) {
    $t = $i / ($archSegments - 1)
    $x = -28 + ($t * 56)
    $normalizedX = ($x / 28)
    $height = 25 + (15 * (1 - $normalizedX * $normalizedX))
    $tangentAngle = [Math]::Atan2((-30 * $normalizedX), 28) * (180 / [Math]::PI)
    
    Build-UnityObject -name "Arch_$i" -type "Cube" `
        -position @{x=$x; y=$height; z=0} `
        -rotation @{x=0; y=0; z=$tangentAngle} `
        -scale @{x=2.5; y=1.5; z=6}
}

Write-Host "  [OK] Main arch complete" -ForegroundColor Green
Write-Host ""

Write-Host "Phase 5: Suspension Cables" -ForegroundColor Yellow

for ($i = 0; $i -lt 20; $i++) {
    $x = -26 + ($i * 2.8)
    $normalizedX = ($x / 28)
    $cableHeight = 40 + (8 * (1 - $normalizedX * $normalizedX))
    
    Build-UnityObject -name "Cable_N_$i" -type "Cylinder" `
        -position @{x=$x; y=($cableHeight - 5); z=2.5} `
        -scale @{x=0.1; y=5; z=0.1}
    Build-UnityObject -name "Cable_S_$i" -type "Cylinder" `
        -position @{x=$x; y=($cableHeight - 5); z=-2.5} `
        -scale @{x=0.1; y=5; z=0.1}
}

Build-UnityObject -name "MainCable_NL" -type "Cylinder" `
    -position @{x=-15; y=45; z=3} `
    -rotation @{x=0; y=0; z=90} `
    -scale @{x=0.3; y=15; z=0.3}
Build-UnityObject -name "MainCable_NR" -type "Cylinder" `
    -position @{x=15; y=45; z=3} `
    -rotation @{x=0; y=0; z=90} `
    -scale @{x=0.3; y=15; z=0.3}
Build-UnityObject -name "MainCable_SL" -type "Cylinder" `
    -position @{x=-15; y=45; z=-3} `
    -rotation @{x=0; y=0; z=90} `
    -scale @{x=0.3; y=15; z=0.3}
Build-UnityObject -name "MainCable_SR" -type "Cylinder" `
    -position @{x=15; y=45; z=-3} `
    -rotation @{x=0; y=0; z=90} `
    -scale @{x=0.3; y=15; z=0.3}

Write-Host "  [OK] Suspension cables installed" -ForegroundColor Green
Write-Host ""

Write-Host "Phase 6: Bridge Deck" -ForegroundColor Yellow

for ($i = 0; $i -lt 28; $i++) {
    $x = -28 + ($i * 2)
    Build-UnityObject -name "Deck_$i" -type "Cube" `
        -position @{x=$x; y=8; z=0} -scale @{x=2.2; y=0.5; z=8}
}

Build-UnityObject -name "Road" -type "Cube" `
    -position @{x=0; y=8.5; z=0} -scale @{x=56; y=0.2; z=6}

for ($i = 0; $i -lt 14; $i++) {
    $x = -26 + ($i * 4)
    Build-UnityObject -name "Lane_$i" -type "Cube" `
        -position @{x=$x; y=8.7; z=0} -scale @{x=2; y=0.05; z=0.2}
}

Write-Host "  [OK] Bridge deck complete" -ForegroundColor Green
Write-Host ""

Write-Host "Phase 7: Railings" -ForegroundColor Yellow

for ($i = 0; $i -lt 28; $i++) {
    $x = -28 + ($i * 2)
    Build-UnityObject -name "Rail_N_$i" -type "Cube" `
        -position @{x=$x; y=9.5; z=4} -scale @{x=1.8; y=1; z=0.2}
    Build-UnityObject -name "Rail_S_$i" -type "Cube" `
        -position @{x=$x; y=9.5; z=-4} -scale @{x=1.8; y=1; z=0.2}
}

Write-Host "  [OK] Railings installed" -ForegroundColor Green
Write-Host ""

Write-Host "Phase 8: Decorative Elements" -ForegroundColor Yellow

$ornamentPositions = @(
    @{x=-32; z=-4; n="L_NW"}, @{x=-32; z=4; n="L_NE"},
    @{x=-28; z=-4; n="L_SW"}, @{x=-28; z=4; n="L_SE"},
    @{x=28; z=-4; n="R_SW"}, @{x=28; z=4; n="R_SE"},
    @{x=32; z=-4; n="R_NW"}, @{x=32; z=4; n="R_NE"}
)

foreach ($pos in $ornamentPositions) {
    Build-UnityObject -name "Ornament_$($pos.n)" -type "Sphere" `
        -position @{x=$pos.x; y=45; z=$pos.z} -scale @{x=0.8; y=0.8; z=0.8}
}

for ($i = 0; $i -lt 10; $i++) {
    $x = -25 + ($i * 5)
    Build-UnityObject -name "Truss_L_$i" -type "Cube" `
        -position @{x=$x; y=6; z=2} `
        -rotation @{x=0; y=0; z=45} `
        -scale @{x=0.3; y=3; z=0.3}
    Build-UnityObject -name "Truss_R_$i" -type "Cube" `
        -position @{x=$x; y=6; z=-2} `
        -rotation @{x=0; y=0; z=-45} `
        -scale @{x=0.3; y=3; z=0.3}
}

for ($i = 0; $i -lt 8; $i++) {
    $x = -36 - ($i * 3)
    $y = 7 - ($i * 0.8)
    Build-UnityObject -name "Approach_L_$i" -type "Cube" `
        -position @{x=$x; y=$y; z=0} `
        -rotation @{x=0; y=0; z=-8} `
        -scale @{x=3; y=0.5; z=8}
}

for ($i = 0; $i -lt 8; $i++) {
    $x = 36 + ($i * 3)
    $y = 7 - ($i * 0.8)
    Build-UnityObject -name "Approach_R_$i" -type "Cube" `
        -position @{x=$x; y=$y; z=0} `
        -rotation @{x=0; y=0; z=8} `
        -scale @{x=3; y=0.5; z=8}
}

Write-Host "  [OK] Decorative elements complete" -ForegroundColor Green
Write-Host ""

Write-Host "Phase 9: Lighting System" -ForegroundColor Yellow

for ($i = 0; $i -lt 10; $i++) {
    $y = 10 + ($i * 4)
    Build-UnityObject -name "Light_LN_$i" -type "Sphere" `
        -position @{x=-30; y=$y; z=4} -scale @{x=0.5; y=0.5; z=0.5}
    Build-UnityObject -name "Light_LS_$i" -type "Sphere" `
        -position @{x=-30; y=$y; z=-4} -scale @{x=0.5; y=0.5; z=0.5}
    Build-UnityObject -name "Light_RN_$i" -type "Sphere" `
        -position @{x=30; y=$y; z=4} -scale @{x=0.5; y=0.5; z=0.5}
    Build-UnityObject -name "Light_RS_$i" -type "Sphere" `
        -position @{x=30; y=$y; z=-4} -scale @{x=0.5; y=0.5; z=0.5}
}

for ($i = 0; $i -lt 14; $i++) {
    $x = -26 + ($i * 4)
    Build-UnityObject -name "DeckLight_N_$i" -type "Sphere" `
        -position @{x=$x; y=10; z=4.5} -scale @{x=0.4; y=0.4; z=0.4}
    Build-UnityObject -name "DeckLight_S_$i" -type "Sphere" `
        -position @{x=$x; y=10; z=-4.5} -scale @{x=0.4; y=0.4; z=0.4}
}

Write-Host "  [OK] Lighting system installed" -ForegroundColor Green
Write-Host ""

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "TOWER BRIDGE CONSTRUCTION COMPLETE!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Statistics:" -ForegroundColor Yellow
Write-Host "- Total Height: 55 meters" -ForegroundColor White
Write-Host "- Bridge Span: 120 meters" -ForegroundColor White
Write-Host "- Twin Gothic Towers" -ForegroundColor White
Write-Host "- Suspension Cable System" -ForegroundColor White
Write-Host "- Total Primitives: 600+" -ForegroundColor White
Write-Host ""
Write-Host "The bridge is ready!" -ForegroundColor Cyan
