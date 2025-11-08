# Create Sci-Fi Humanoid Character
Write-Host "Creating Sci-Fi Character..." -ForegroundColor Cyan

# Parent container
$parent = "SciFiRobot"

# Head - Capsule
Write-Host "Creating head..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body "{`"name`": `"Head`", `"primitiveType`": `"Capsule`", `"parent`": `"`"}" -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"Head`", `"position`": {`"x`": 0, `"y`": 1.75, `"z`": 0}, `"scale`": {`"x`": 0.4, `"y`": 0.3, `"z`": 0.4}}" -UseBasicParsing | Out-Null

# Visor - Cube (sci-fi helmet visor)
Write-Host "Creating visor..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body "{`"name`": `"Visor`", `"primitiveType`": `"Cube`", `"parent`": `"`"}" -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"Visor`", `"position`": {`"x`": 0, `"y`": 1.8, `"z`": 0.15}, `"scale`": {`"x`": 0.35, `"y`": 0.15, `"z`": 0.05}}" -UseBasicParsing | Out-Null

# Torso - Cube
Write-Host "Creating torso..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body "{`"name`": `"Torso`", `"primitiveType`": `"Cube`", `"parent`": `"`"}" -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"Torso`", `"position`": {`"x`": 0, `"y`": 1.0, `"z`": 0}, `"scale`": {`"x`": 0.6, `"y`": 0.8, `"z`": 0.35}}" -UseBasicParsing | Out-Null

# Chest Plate - Cube (armor detail)
Write-Host "Creating chest plate..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body "{`"name`": `"ChestPlate`", `"primitiveType`": `"Cube`", `"parent`": `"`"}" -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"ChestPlate`", `"position`": {`"x`": 0, `"y`": 1.15, `"z`": 0.2}, `"scale`": {`"x`": 0.5, `"y`": 0.5, `"z`": 0.1}}" -UseBasicParsing | Out-Null

# Left Shoulder Pad
Write-Host "Creating left shoulder..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body "{`"name`": `"LeftShoulder`", `"primitiveType`": `"Cube`", `"parent`": `"`"}" -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"LeftShoulder`", `"position`": {`"x`": -0.45, `"y`": 1.4, `"z`": 0}, `"scale`": {`"x`": 0.3, `"y`": 0.25, `"z`": 0.35}}" -UseBasicParsing | Out-Null

# Right Shoulder Pad
Write-Host "Creating right shoulder..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body "{`"name`": `"RightShoulder`", `"primitiveType`": `"Cube`", `"parent`": `"`"}" -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"RightShoulder`", `"position`": {`"x`": 0.45, `"y`": 1.4, `"z`": 0}, `"scale`": {`"x`": 0.3, `"y`": 0.25, `"z`": 0.35}}" -UseBasicParsing | Out-Null

# Left Arm Upper
Write-Host "Creating left upper arm..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body "{`"name`": `"LeftArmUpper`", `"primitiveType`": `"Capsule`", `"parent`": `"`"}" -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"LeftArmUpper`", `"position`": {`"x`": -0.5, `"y`": 1.0, `"z`": 0}, `"scale`": {`"x`": 0.15, `"y`": 0.3, `"z`": 0.15}, `"rotation`": {`"x`": 0, `"y`": 0, `"z`": 90}}" -UseBasicParsing | Out-Null

# Right Arm Upper
Write-Host "Creating right upper arm..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body "{`"name`": `"RightArmUpper`", `"primitiveType`": `"Capsule`", `"parent`": `"`"}" -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"RightArmUpper`", `"position`": {`"x`": 0.5, `"y`": 1.0, `"z`": 0}, `"scale`": {`"x`": 0.15, `"y`": 0.3, `"z`": 0.15}, `"rotation`": {`"x`": 0, `"y`": 0, `"z`": 90}}" -UseBasicParsing | Out-Null

# Left Arm Lower
Write-Host "Creating left forearm..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body "{`"name`": `"LeftArmLower`", `"primitiveType`": `"Capsule`", `"parent`": `"`"}" -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"LeftArmLower`", `"position`": {`"x`": -0.85, `"y`": 1.0, `"z`": 0}, `"scale`": {`"x`": 0.13, `"y`": 0.25, `"z`": 0.13}, `"rotation`": {`"x`": 0, `"y`": 0, `"z`": 90}}" -UseBasicParsing | Out-Null

# Right Arm Lower
Write-Host "Creating right forearm..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body "{`"name`": `"RightArmLower`", `"primitiveType`": `"Capsule`", `"parent`": `"`"}" -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"RightArmLower`", `"position`": {`"x`": 0.85, `"y`": 1.0, `"z`": 0}, `"scale`": {`"x`": 0.13, `"y`": 0.25, `"z`": 0.13}, `"rotation`": {`"x`": 0, `"y`": 0, `"z`": 90}}" -UseBasicParsing | Out-Null

# Pelvis
Write-Host "Creating pelvis..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body "{`"name`": `"Pelvis`", `"primitiveType`": `"Cube`", `"parent`": `"`"}" -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"Pelvis`", `"position`": {`"x`": 0, `"y`": 0.55, `"z`": 0}, `"scale`": {`"x`": 0.5, `"y`": 0.3, `"z`": 0.35}}" -UseBasicParsing | Out-Null

# Left Leg Upper
Write-Host "Creating left thigh..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body "{`"name`": `"LeftLegUpper`", `"primitiveType`": `"Capsule`", `"parent`": `"`"}" -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"LeftLegUpper`", `"position`": {`"x`": -0.15, `"y`": 0.15, `"z`": 0}, `"scale`": {`"x`": 0.18, `"y`": 0.25, `"z`": 0.18}}" -UseBasicParsing | Out-Null

# Right Leg Upper
Write-Host "Creating right thigh..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body "{`"name`": `"RightLegUpper`", `"primitiveType`": `"Capsule`", `"parent`": `"`"}" -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"RightLegUpper`", `"position`": {`"x`": 0.15, `"y`": 0.15, `"z`": 0}, `"scale`": {`"x`": 0.18, `"y`": 0.25, `"z`": 0.18}}" -UseBasicParsing | Out-Null

# Left Leg Lower
Write-Host "Creating left shin..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body "{`"name`": `"LeftLegLower`", `"primitiveType`": `"Capsule`", `"parent`": `"`"}" -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"LeftLegLower`", `"position`": {`"x`": -0.15, `"y`": -0.35, `"z`": 0}, `"scale`": {`"x`": 0.15, `"y`": 0.3, `"z`": 0.15}}" -UseBasicParsing | Out-Null

# Right Leg Lower
Write-Host "Creating right shin..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body "{`"name`": `"RightLegLower`", `"primitiveType`": `"Capsule`", `"parent`": `"`"}" -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"RightLegLower`", `"position`": {`"x`": 0.15, `"y`": -0.35, `"z`": 0}, `"scale`": {`"x`": 0.15, `"y`": 0.3, `"z`": 0.15}}" -UseBasicParsing | Out-Null

# Left Boot
Write-Host "Creating left boot..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body "{`"name`": `"LeftBoot`", `"primitiveType`": `"Cube`", `"parent`": `"`"}" -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"LeftBoot`", `"position`": {`"x`": -0.15, `"y`": -0.75, `"z`": 0.05}, `"scale`": {`"x`": 0.2, `"y`": 0.15, `"z`": 0.3}}" -UseBasicParsing | Out-Null

# Right Boot
Write-Host "Creating right boot..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body "{`"name`": `"RightBoot`", `"primitiveType`": `"Cube`", `"parent`": `"`"}" -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"RightBoot`", `"position`": {`"x`": 0.15, `"y`": -0.75, `"z`": 0.05}, `"scale`": {`"x`": 0.2, `"y`": 0.15, `"z`": 0.3}}" -UseBasicParsing | Out-Null

# Backpack (sci-fi detail)
Write-Host "Creating backpack..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body "{`"name`": `"Backpack`", `"primitiveType`": `"Cube`", `"parent`": `"`"}" -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 100
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body "{`"name`": `"Backpack`", `"position`": {`"x`": 0, `"y`": 1.05, `"z`": -0.25}, `"scale`": {`"x`": 0.45, `"y`": 0.6, `"z`": 0.2}}" -UseBasicParsing | Out-Null

Write-Host ""
Write-Host "Sci-Fi Character Created!" -ForegroundColor Green
Write-Host "Total parts: 19 primitives" -ForegroundColor Cyan
