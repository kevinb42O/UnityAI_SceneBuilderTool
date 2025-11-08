# Dancing Animation - Full Body Movement
Write-Host "Starting Dance Animation! 🕺💃" -ForegroundColor Cyan
Write-Host "Resetting character to base pose..." -ForegroundColor Yellow
Write-Host ""

# RESET ALL BODY PARTS TO BASE POSITIONS FIRST!
Write-Host "Resetting Head..." -ForegroundColor Gray
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "Head", "position": {"x": 0, "y": 1.75, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 0.4, "y": 0.3, "z": 0.4}}' -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 50

Write-Host "Resetting Visor..." -ForegroundColor Gray
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "Visor", "position": {"x": 0, "y": 1.8, "z": 0.15}, "rotation": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 0.35, "y": 0.15, "z": 0.05}}' -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 50

Write-Host "Resetting Torso..." -ForegroundColor Gray
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "Torso", "position": {"x": 0, "y": 1.0, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 0.6, "y": 0.8, "z": 0.35}}' -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 50

Write-Host "Resetting ChestPlate..." -ForegroundColor Gray
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "ChestPlate", "position": {"x": 0, "y": 1.15, "z": 0.2}, "rotation": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 0.5, "y": 0.5, "z": 0.1}}' -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 50

Write-Host "Resetting Shoulders..." -ForegroundColor Gray
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "LeftShoulder", "position": {"x": -0.45, "y": 1.4, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 0.3, "y": 0.25, "z": 0.35}}' -UseBasicParsing | Out-Null
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "RightShoulder", "position": {"x": 0.45, "y": 1.4, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 0.3, "y": 0.25, "z": 0.35}}' -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 50

Write-Host "Resetting Arms..." -ForegroundColor Gray
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "LeftArmUpper", "position": {"x": -0.5, "y": 1.0, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 90}, "scale": {"x": 0.15, "y": 0.3, "z": 0.15}}' -UseBasicParsing | Out-Null
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "RightArmUpper", "position": {"x": 0.5, "y": 1.0, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 90}, "scale": {"x": 0.15, "y": 0.3, "z": 0.15}}' -UseBasicParsing | Out-Null
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "LeftArmLower", "position": {"x": -0.85, "y": 1.0, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 90}, "scale": {"x": 0.13, "y": 0.25, "z": 0.13}}' -UseBasicParsing | Out-Null
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "RightArmLower", "position": {"x": 0.85, "y": 1.0, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 90}, "scale": {"x": 0.13, "y": 0.25, "z": 0.13}}' -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 50

Write-Host "Resetting Pelvis..." -ForegroundColor Gray
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "Pelvis", "position": {"x": 0, "y": 0.55, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 0.5, "y": 0.3, "z": 0.35}}' -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 50

Write-Host "Resetting Legs..." -ForegroundColor Gray
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "LeftLegUpper", "position": {"x": -0.15, "y": 0.15, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 0.18, "y": 0.25, "z": 0.18}}' -UseBasicParsing | Out-Null
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "RightLegUpper", "position": {"x": 0.15, "y": 0.15, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 0.18, "y": 0.25, "z": 0.18}}' -UseBasicParsing | Out-Null
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "LeftLegLower", "position": {"x": -0.15, "y": -0.35, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 0.15, "y": 0.3, "z": 0.15}}' -UseBasicParsing | Out-Null
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "RightLegLower", "position": {"x": 0.15, "y": -0.35, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 0.15, "y": 0.3, "z": 0.15}}' -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 50

Write-Host "Resetting Boots..." -ForegroundColor Gray
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "LeftBoot", "position": {"x": -0.15, "y": -0.75, "z": 0.05}, "rotation": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 0.2, "y": 0.15, "z": 0.3}}' -UseBasicParsing | Out-Null
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "RightBoot", "position": {"x": 0.15, "y": -0.75, "z": 0.05}, "rotation": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 0.2, "y": 0.15, "z": 0.3}}' -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 50

Write-Host "Resetting Backpack..." -ForegroundColor Gray
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "Backpack", "position": {"x": 0, "y": 1.05, "z": -0.25}, "rotation": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 0.45, "y": 0.6, "z": 0.2}}' -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 50

Write-Host ""
Write-Host "Base pose set! Starting dance in 3..." -ForegroundColor Green
Start-Sleep -Seconds 1
Write-Host "2..." -ForegroundColor Green
Start-Sleep -Seconds 1
Write-Host "1..." -ForegroundColor Green
Start-Sleep -Seconds 1
Write-Host "LET'S DANCE! 🎉" -ForegroundColor Magenta
Write-Host ""
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

$frame = 0

while ($true) {
    $time = $frame * 0.001  # 1000 FPS time step for INSANELY SMOOTH animation!!!
    
    # Multiple sine waves for complex movement
    $beat = [Math]::Sin($time * 3)  # Fast beat
    $slowWave = [Math]::Sin($time * 1.5)  # Slow sway
    $bounce = [Math]::Abs([Math]::Sin($time * 6))  # Bounce rhythm
    
    # WHOLE BODY Y-POSITION (bounce)
    $bodyY = 1.0 + ($bounce * 0.3)
    
    # TORSO - Twist and lean
    $torsoRotY = $slowWave * 15  # Twist side to side
    $torsoRotZ = $beat * 10  # Lean
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"Torso`", `"position`": {`"x`": 0, `"y`": $bodyY, `"z`": 0}, `"rotation`": {`"x`": 0, `"y`": $torsoRotY, `"z`": $torsoRotZ}}" -UseBasicParsing | Out-Null
    
    # HEAD - Bob and groove
    $headY = 1.75 + ($bounce * 0.3) + 0.05
    $headRotZ = $beat * 20  # Head bop
    $headRotY = $slowWave * 10
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"Head`", `"position`": {`"x`": 0, `"y`": $headY, `"z`": 0}, `"rotation`": {`"x`": 0, `"y`": $headRotY, `"z`": $headRotZ}}" -UseBasicParsing | Out-Null
    
    # VISOR - Follow head
    $visorY = 1.8 + ($bounce * 0.3) + 0.05
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"Visor`", `"position`": {`"x`": 0, `"y`": $visorY, `"z`": 0.15}, `"rotation`": {`"x`": 0, `"y`": $headRotY, `"z`": $headRotZ}}" -UseBasicParsing | Out-Null
    
    # CHEST PLATE - Follow torso with slight delay
    $chestY = 1.15 + ($bounce * 0.3)
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"ChestPlate`", `"position`": {`"x`": 0, `"y`": $chestY, `"z`": 0.2}, `"rotation`": {`"x`": 0, `"y`": $torsoRotY, `"z`": $torsoRotZ}}" -UseBasicParsing | Out-Null
    
    # SHOULDERS - Pump up and down
    $shoulderY = 1.4 + ($bounce * 0.3) + ($beat * 0.1)
    $shoulderRotZ = $beat * 15
    
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"LeftShoulder`", `"position`": {`"x`": -0.45, `"y`": $shoulderY, `"z`": 0}, `"rotation`": {`"x`": 0, `"y`": 0, `"z`": $shoulderRotZ}}" -UseBasicParsing | Out-Null
    
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"RightShoulder`", `"position`": {`"x`": 0.45, `"y`": $shoulderY, `"z`": 0}, `"rotation`": {`"x`": 0, `"y`": 0, `"z`": $(-$shoulderRotZ)}}" -UseBasicParsing | Out-Null
    
    # ARMS - Wave and groove (opposite movements)
    $leftArmY = 1.0 + ($bounce * 0.3)
    $rightArmY = 1.0 + ($bounce * 0.3)
    $leftArmRotX = $beat * 45  # Big arm movement
    $rightArmRotX = $slowWave * 45
    $leftArmRotY = [Math]::Sin($time * 4) * 30
    $rightArmRotY = [Math]::Sin(($time * 4) + 3.14) * 30
    
    # Upper arms
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"LeftArmUpper`", `"position`": {`"x`": -0.5, `"y`": $leftArmY, `"z`": 0}, `"rotation`": {`"x`": $leftArmRotX, `"y`": $leftArmRotY, `"z`": 90}}" -UseBasicParsing | Out-Null
    
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"RightArmUpper`", `"position`": {`"x`": 0.5, `"y`": $rightArmY, `"z`": 0}, `"rotation`": {`"x`": $rightArmRotX, `"y`": $rightArmRotY, `"z`": 90}}" -UseBasicParsing | Out-Null
    
    # Lower arms - Follow with flex
    $armFlexL = [Math]::Sin($time * 5) * 20
    $armFlexR = [Math]::Sin(($time * 5) + 1.5) * 20
    
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"LeftArmLower`", `"position`": {`"x`": -0.85, `"y`": $leftArmY, `"z`": 0}, `"rotation`": {`"x`": $armFlexL, `"y`": 0, `"z`": 90}}" -UseBasicParsing | Out-Null
    
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"RightArmLower`", `"position`": {`"x`": 0.85, `"y`": $rightArmY, `"z`": 0}, `"rotation`": {`"x`": $armFlexR, `"y`": 0, `"z`": 90}}" -UseBasicParsing | Out-Null
    
    # PELVIS - Hip sway
    $pelvisY = 0.55 + ($bounce * 0.3)
    $pelvisRotZ = $slowWave * 20  # Hip sway
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"Pelvis`", `"position`": {`"x`": 0, `"y`": $pelvisY, `"z`": 0}, `"rotation`": {`"x`": 0, `"y`": 0, `"z`": $pelvisRotZ}}" -UseBasicParsing | Out-Null
    
    # LEGS - Step and bounce
    $legBounceL = [Math]::Sin($time * 4) * 25
    $legBounceR = [Math]::Sin(($time * 4) + 3.14) * 25
    $legY = 0.15 + ($bounce * 0.2)
    
    # Upper legs
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"LeftLegUpper`", `"position`": {`"x`": -0.15, `"y`": $legY, `"z`": 0}, `"rotation`": {`"x`": $legBounceL, `"y`": 0, `"z`": 0}}" -UseBasicParsing | Out-Null
    
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"RightLegUpper`", `"position`": {`"x`": 0.15, `"y`": $legY, `"z`": 0}, `"rotation`": {`"x`": $legBounceR, `"y`": 0, `"z`": 0}}" -UseBasicParsing | Out-Null
    
    # Lower legs - Bend with movement
    $legBendL = [Math]::Max(0, [Math]::Sin($time * 4) * 30)
    $legBendR = [Math]::Max(0, [Math]::Sin(($time * 4) + 3.14) * 30)
    $lowerLegY = -0.35 + ($bounce * 0.15)
    
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"LeftLegLower`", `"position`": {`"x`": -0.15, `"y`": $lowerLegY, `"z`": 0}, `"rotation`": {`"x`": $legBendL, `"y`": 0, `"z`": 0}}" -UseBasicParsing | Out-Null
    
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"RightLegLower`", `"position`": {`"x`": 0.15, `"y`": $lowerLegY, `"z`": 0}, `"rotation`": {`"x`": $legBendR, `"y`": 0, `"z`": 0}}" -UseBasicParsing | Out-Null
    
    # BOOTS - Step with attitude
    $bootY = -0.75 + ($bounce * 0.1)
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"LeftBoot`", `"position`": {`"x`": -0.15, `"y`": $bootY, `"z`": 0.05}}" -UseBasicParsing | Out-Null
    
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"RightBoot`", `"position`": {`"x`": 0.15, `"y`": $bootY, `"z`": 0.05}}" -UseBasicParsing | Out-Null
    
    # BACKPACK - Follow torso with slight shake
    $backpackY = 1.05 + ($bounce * 0.3)
    $backpackShake = [Math]::Sin($time * 8) * 3
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"Backpack`", `"position`": {`"x`": 0, `"y`": $backpackY, `"z`": -0.25}, `"rotation`": {`"x`": 0, `"y`": $torsoRotY, `"z`": $backpackShake}}" -UseBasicParsing | Out-Null
    
    # Progress indicator with dance emoji
    if ($frame % 5 -eq 0) {
        $danceEmojis = @("🕺", "💃", "🎵", "🎶", "✨", "🌟")
        $emoji = $danceEmojis[$frame % 6]
        Write-Host "`rDancing $emoji Frame: $frame" -NoNewline -ForegroundColor Magenta
    }
    
    $frame++
    Start-Sleep -Milliseconds 1  # 1000 FPS = ABSOLUTE MADNESS! 🚀🔥💯
}
