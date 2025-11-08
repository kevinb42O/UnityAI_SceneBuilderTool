# Stick Figure Dance Animation - 1000 FPS Ultra Smooth
Write-Host "Starting Stick Figure Dance!" -ForegroundColor Cyan
Write-Host "Resetting to base pose..." -ForegroundColor Yellow
Write-Host ""

# RESET TO BASE POSITIONS
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "Head", "position": {"x": 0, "y": 1.75, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 0.3, "y": 0.3, "z": 0.3}}' -UseBasicParsing | Out-Null
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "Torso", "position": {"x": 0, "y": 1.1, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 0.15, "y": 0.35, "z": 0.15}}' -UseBasicParsing | Out-Null
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "LeftArm", "position": {"x": -0.4, "y": 1.3, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 90}, "scale": {"x": 0.08, "y": 0.3, "z": 0.08}}' -UseBasicParsing | Out-Null
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "RightArm", "position": {"x": 0.4, "y": 1.3, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 90}, "scale": {"x": 0.08, "y": 0.3, "z": 0.08}}' -UseBasicParsing | Out-Null
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "LeftLeg", "position": {"x": -0.12, "y": 0.4, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 0.1, "y": 0.4, "z": 0.1}}' -UseBasicParsing | Out-Null
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "RightLeg", "position": {"x": 0.12, "y": 0.4, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 0.1, "y": 0.4, "z": 0.1}}' -UseBasicParsing | Out-Null

Write-Host "3..." -ForegroundColor Green
Start-Sleep -Seconds 1
Write-Host "2..." -ForegroundColor Green
Start-Sleep -Seconds 1
Write-Host "1..." -ForegroundColor Green
Start-Sleep -Seconds 1
Write-Host "LET'S DANCE!" -ForegroundColor Magenta
Write-Host ""
Write-Host "Running at 1000 FPS - ULTRA SMOOTH!" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

$frame = 0

while ($true) {
    $time = $frame * 0.001  # 1000 FPS
    
    # Wave calculations
    $beat = [Math]::Sin($time * 3)
    $slowWave = [Math]::Sin($time * 1.5)
    $bounce = [Math]::Abs([Math]::Sin($time * 6))
    
    # HEAD - Bob and sway
    $headY = 1.75 + ($bounce * 0.2)
    $headRotZ = $beat * 15
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"Head`", `"position`": {`"x`": 0, `"y`": $headY, `"z`": 0}, `"rotation`": {`"x`": 0, `"y`": 0, `"z`": $headRotZ}}" -UseBasicParsing | Out-Null
    
    # TORSO - Twist and bounce
    $torsoY = 1.1 + ($bounce * 0.2)
    $torsoRotY = $slowWave * 20
    $torsoRotZ = $beat * 8
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"Torso`", `"position`": {`"x`": 0, `"y`": $torsoY, `"z`": 0}, `"rotation`": {`"x`": 0, `"y`": $torsoRotY, `"z`": $torsoRotZ}}" -UseBasicParsing | Out-Null
    
    # ARMS - Wave independently
    $leftArmY = 1.3 + ($bounce * 0.15)
    $rightArmY = 1.3 + ($bounce * 0.15)
    $leftArmRotX = $beat * 50
    $rightArmRotX = $slowWave * 50
    $leftArmRotY = [Math]::Sin($time * 4) * 30
    $rightArmRotY = [Math]::Sin(($time * 4) + 3.14) * 30
    
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"LeftArm`", `"position`": {`"x`": -0.4, `"y`": $leftArmY, `"z`": 0}, `"rotation`": {`"x`": $leftArmRotX, `"y`": $leftArmRotY, `"z`": 90}}" -UseBasicParsing | Out-Null
    
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"RightArm`", `"position`": {`"x`": 0.4, `"y`": $rightArmY, `"z`": 0}, `"rotation`": {`"x`": $rightArmRotX, `"y`": $rightArmRotY, `"z`": 90}}" -UseBasicParsing | Out-Null
    
    # LEGS - Step and bounce
    $legY = 0.4 + ($bounce * 0.1)
    $leftLegRotX = [Math]::Sin($time * 4) * 30
    $rightLegRotX = [Math]::Sin(($time * 4) + 3.14) * 30
    
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"LeftLeg`", `"position`": {`"x`": -0.12, `"y`": $legY, `"z`": 0}, `"rotation`": {`"x`": $leftLegRotX, `"y`": 0, `"z`": 0}}" -UseBasicParsing | Out-Null
    
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"RightLeg`", `"position`": {`"x`": 0.12, `"y`": $legY, `"z`": 0}, `"rotation`": {`"x`": $rightLegRotX, `"y`": 0, `"z`": 0}}" -UseBasicParsing | Out-Null
    
    # Progress
    if ($frame % 100 -eq 0) {
        $danceSymbols = @("*", "~", "+", "=", "*", "~", "+", "=")
        $symbol = $danceSymbols[($frame / 100) % 8]
        Write-Host "`rDancing $symbol Frame: $frame (1000 FPS)" -NoNewline -ForegroundColor Magenta
    }
    
    $frame++
    Start-Sleep -Milliseconds 1
}
