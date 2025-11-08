# Create Simple Stick Figure Character
Write-Host "Creating Minimalist Stick Figure..." -ForegroundColor Cyan
Write-Host ""

# Delete old complex character parts first
Write-Host "Cleaning up old character..." -ForegroundColor Yellow
$oldParts = @(
    "Head", "Visor", "Torso", "ChestPlate", 
    "LeftShoulder", "RightShoulder",
    "LeftArmUpper", "RightArmUpper", "LeftArmLower", "RightArmLower",
    "Pelvis", "LeftLegUpper", "RightLegUpper", "LeftLegLower", "RightLegLower",
    "LeftBoot", "RightBoot", "Backpack", "SciFiCharacter", "CharacterRoot"
)

foreach ($part in $oldParts) {
    curl -Method POST -Uri "http://localhost:8765/deleteGameObject" -ContentType "application/json" -Body "{`"name`": `"$part`"}" -UseBasicParsing 2>$null | Out-Null
}
Start-Sleep -Milliseconds 500

Write-Host "Building stick figure..." -ForegroundColor Green
Write-Host ""

# HEAD - Small sphere
Write-Host "  + Head" -ForegroundColor White
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body '{"name": "Head", "primitiveType": "Sphere", "parent": ""}' -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "Head", "position": {"x": 0, "y": 1.75, "z": 0}, "scale": {"x": 0.3, "y": 0.3, "z": 0.3}}' -UseBasicParsing | Out-Null

# TORSO - Thin capsule
Write-Host "  + Torso" -ForegroundColor White
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body '{"name": "Torso", "primitiveType": "Capsule", "parent": ""}' -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "Torso", "position": {"x": 0, "y": 1.1, "z": 0}, "scale": {"x": 0.15, "y": 0.35, "z": 0.15}}' -UseBasicParsing | Out-Null

# LEFT ARM - Single capsule
Write-Host "  + Left Arm" -ForegroundColor White
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body '{"name": "LeftArm", "primitiveType": "Capsule", "parent": ""}' -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "LeftArm", "position": {"x": -0.4, "y": 1.3, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 90}, "scale": {"x": 0.08, "y": 0.3, "z": 0.08}}' -UseBasicParsing | Out-Null

# RIGHT ARM - Single capsule
Write-Host "  + Right Arm" -ForegroundColor White
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body '{"name": "RightArm", "primitiveType": "Capsule", "parent": ""}' -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "RightArm", "position": {"x": 0.4, "y": 1.3, "z": 0}, "rotation": {"x": 0, "y": 0, "z": 90}, "scale": {"x": 0.08, "y": 0.3, "z": 0.08}}' -UseBasicParsing | Out-Null

# LEFT LEG - Single capsule
Write-Host "  + Left Leg" -ForegroundColor White
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body '{"name": "LeftLeg", "primitiveType": "Capsule", "parent": ""}' -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "LeftLeg", "position": {"x": -0.12, "y": 0.4, "z": 0}, "scale": {"x": 0.1, "y": 0.4, "z": 0.1}}' -UseBasicParsing | Out-Null

# RIGHT LEG - Single capsule
Write-Host "  + Right Leg" -ForegroundColor White
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body '{"name": "RightLeg", "primitiveType": "Capsule", "parent": ""}' -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "RightLeg", "position": {"x": 0.12, "y": 0.4, "z": 0}, "scale": {"x": 0.1, "y": 0.4, "z": 0.1}}' -UseBasicParsing | Out-Null

Write-Host ""
Write-Host "Stick Figure Complete! [OK]" -ForegroundColor Green
Write-Host "Parts: 6 primitives (Head, Torso, 2 Arms, 2 Legs)" -ForegroundColor Cyan
Write-Host "Clean, minimal, and ready to dance!" -ForegroundColor Yellow
