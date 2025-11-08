# Animate Sci-Fi Character - Simple walking animation
Write-Host "Starting Character Animation..." -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

$frame = 0
$speed = 0.5

while ($true) {
    $time = $frame * 0.1
    
    # Calculate sine wave for smooth movement
    $legSwing = [Math]::Sin($time * 2) * 20  # 20 degree swing
    $armSwing = [Math]::Sin($time * 2) * 15  # 15 degree swing (opposite of legs)
    $bobHeight = [Math]::Abs([Math]::Sin($time * 4)) * 0.05  # Slight vertical bob
    $walkForward = $time * $speed  # Move forward
    
    # Animate Left Leg Upper
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"LeftLegUpper`", `"rotation`": {`"x`": $legSwing, `"y`": 0, `"z`": 0}}" -UseBasicParsing | Out-Null
    
    # Animate Right Leg Upper (opposite phase)
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"RightLegUpper`", `"rotation`": {`"x`": $(-$legSwing), `"y`": 0, `"z`": 0}}" -UseBasicParsing | Out-Null
    
    # Animate Left Arm (opposite to right leg)
    $leftArmRot = -$legSwing * 0.75
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"LeftArmUpper`", `"rotation`": {`"x`": $leftArmRot, `"y`": 0, `"z`": 90}}" -UseBasicParsing | Out-Null
    
    # Animate Right Arm (opposite to left leg)
    $rightArmRot = $legSwing * 0.75
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"RightArmUpper`", `"rotation`": {`"x`": $rightArmRot, `"y`": 0, `"z`": 90}}" -UseBasicParsing | Out-Null
    
    # Bob the torso slightly
    $torsoY = 1.0 + $bobHeight
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"Torso`", `"position`": {`"x`": 0, `"y`": $torsoY, `"z`": $walkForward}}" -UseBasicParsing | Out-Null
    
    # Bob the head
    $headY = 1.75 + $bobHeight
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"Head`", `"position`": {`"x`": 0, `"y`": $headY, `"z`": $walkForward}}" -UseBasicParsing | Out-Null
    
    # Move visor with head
    $visorY = 1.8 + $bobHeight
    curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"Visor`", `"position`": {`"x`": 0, `"y`": $visorY, `"z`": $($walkForward + 0.15)}}" -UseBasicParsing | Out-Null
    
    # Progress indicator
    if ($frame % 10 -eq 0) {
        $distance = [Math]::Round($walkForward, 2)
        Write-Host "`rWalking... Distance: $distance units" -NoNewline -ForegroundColor Green
    }
    
    $frame++
    Start-Sleep -Milliseconds 100
}
