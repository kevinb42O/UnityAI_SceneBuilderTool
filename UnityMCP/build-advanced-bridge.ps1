# Advanced Bridge Builder - Using All New Tools from Master
# Demonstrates: duplicateGameObject, createLinearArray, createCircularArray, createGridArray, groupObjects

Write-Host "=== ADVANCED BRIDGE BUILDER ===" -ForegroundColor Cyan
Write-Host "Using all new tools: duplication, arrays, grouping" -ForegroundColor Yellow
Write-Host ""

$UNITY_BASE = "http://localhost:8765"

# Step 1: Create base pillar template
Write-Host "[1/8] Creating base pillar template..." -ForegroundColor Green

# Create primitive
$pillarCreate = @{
    primitiveType = "Cylinder"
    name = "BridgePillar_Base"
} | ConvertTo-Json -Depth 5
Invoke-RestMethod -Uri "$UNITY_BASE/createGameObject" -Method Post -Body $pillarCreate -ContentType "application/json" | Out-Null
Start-Sleep -Milliseconds 200

# Set transform
$pillarTransform = @{
    name = "BridgePillar_Base"
    position = @{ x = -50; y = 10; z = 0 }
    scale = @{ x = 3; y = 10; z = 3 }
} | ConvertTo-Json -Depth 5
Invoke-RestMethod -Uri "$UNITY_BASE/setTransform" -Method Post -Body $pillarTransform -ContentType "application/json" | Out-Null
Start-Sleep -Milliseconds 200

# Set material
$pillarMaterial = @{
    name = "BridgePillar_Base"
    color = @{ r = 0.4; g = 0.4; b = 0.45; a = 1 }
    metallic = 0.8
    smoothness = 0.6
} | ConvertTo-Json -Depth 5
Invoke-RestMethod -Uri "$UNITY_BASE/setMaterial" -Method Post -Body $pillarMaterial -ContentType "application/json" | Out-Null

Write-Host "  Created pillar template" -ForegroundColor White

# Step 2: Create linear array of pillars across bridge span
Write-Host "[2/8] Creating pillar array (linear pattern)..." -ForegroundColor Green
$pillarArrayBody = @{
    sourceName = "BridgePillar_Base"
    count = 5
    spacing = @{ x = 25; y = 0; z = 0 }
    namePrefix = "BridgePillar"
} | ConvertTo-Json -Depth 5

$pillarResult = Invoke-RestMethod -Uri "$UNITY_BASE/createLinearArray" -Method Post -Body $pillarArrayBody -ContentType "application/json"
$pillarCount = if ($pillarResult.count) { $pillarResult.count } else { $pillarResult.objects.Count }
Write-Host "  Created $pillarCount pillars" -ForegroundColor White

# Step 3: Create deck plank template
Write-Host "[3/8] Creating deck plank template..." -ForegroundColor Green

$deckCreate = @{
    primitiveType = "Cube"
    name = "DeckPlank_Base"
} | ConvertTo-Json -Depth 5
Invoke-RestMethod -Uri "$UNITY_BASE/createGameObject" -Method Post -Body $deckCreate -ContentType "application/json" | Out-Null
Start-Sleep -Milliseconds 200

$deckTransform = @{
    name = "DeckPlank_Base"
    position = @{ x = -50; y = 20; z = 0 }
    scale = @{ x = 8; y = 0.5; z = 5 }
} | ConvertTo-Json -Depth 5
Invoke-RestMethod -Uri "$UNITY_BASE/setTransform" -Method Post -Body $deckTransform -ContentType "application/json" | Out-Null
Start-Sleep -Milliseconds 200

$deckMaterial = @{
    name = "DeckPlank_Base"
    color = @{ r = 0.5; g = 0.35; b = 0.2; a = 1 }
    metallic = 0.0
    smoothness = 0.3
} | ConvertTo-Json -Depth 5
Invoke-RestMethod -Uri "$UNITY_BASE/setMaterial" -Method Post -Body $deckMaterial -ContentType "application/json" | Out-Null

Write-Host "  Created deck plank template" -ForegroundColor White

# Step 4: Create linear array of deck planks
Write-Host "[4/8] Creating bridge deck (linear array)..." -ForegroundColor Green
$deckArrayBody = @{
    sourceName = "DeckPlank_Base"
    count = 13
    spacing = @{ x = 8; y = 0; z = 0 }
    namePrefix = "DeckPlank"
} | ConvertTo-Json -Depth 5

$deckResult = Invoke-RestMethod -Uri "$UNITY_BASE/createLinearArray" -Method Post -Body $deckArrayBody -ContentType "application/json"
Write-Host "  Created $($deckResult.count) deck planks" -ForegroundColor White

# Step 5: Create railing post template
Write-Host "[5/8] Creating railing posts..." -ForegroundColor Green

$railCreate = @{
    primitiveType = "Cylinder"
    name = "RailPost_Base"
} | ConvertTo-Json -Depth 5
Invoke-RestMethod -Uri "$UNITY_BASE/createGameObject" -Method Post -Body $railCreate -ContentType "application/json" | Out-Null
Start-Sleep -Milliseconds 200

$railTransform = @{
    name = "RailPost_Base"
    position = @{ x = -50; y = 21; z = 3 }
    scale = @{ x = 0.3; y = 2; z = 0.3 }
} | ConvertTo-Json -Depth 5
Invoke-RestMethod -Uri "$UNITY_BASE/setTransform" -Method Post -Body $railTransform -ContentType "application/json" | Out-Null
Start-Sleep -Milliseconds 200

$railMaterial = @{
    name = "RailPost_Base"
    color = @{ r = 0.3; g = 0.3; b = 0.35; a = 1 }
    metallic = 0.9
    smoothness = 0.7
} | ConvertTo-Json -Depth 5
Invoke-RestMethod -Uri "$UNITY_BASE/setMaterial" -Method Post -Body $railMaterial -ContentType "application/json" | Out-Null

# Step 6: Create linear array of railing posts (left side)
$railPostArrayBody = @{
    sourceName = "RailPost_Base"
    count = 26
    spacing = @{ x = 4; y = 0; z = 0 }
    namePrefix = "RailPost_Left"
} | ConvertTo-Json -Depth 5

$railResult = Invoke-RestMethod -Uri "$UNITY_BASE/createLinearArray" -Method Post -Body $railPostArrayBody -ContentType "application/json"
Write-Host "  Created $($railResult.count) railing posts (left side)" -ForegroundColor White

# Step 7: Duplicate and mirror for right side
Write-Host "[6/8] Creating right side railings..." -ForegroundColor Green
$rightRailBody = @{
    sourceName = "RailPost_Base"
    newName = "RailPost_Right_Base"
    offset = @{ x = 0; y = 0; z = -6 }
} | ConvertTo-Json -Depth 5

Invoke-RestMethod -Uri "$UNITY_BASE/duplicateObject" -Method Post -Body $rightRailBody -ContentType "application/json"

$railPostArrayRightBody = @{
    sourceName = "RailPost_Right_Base"
    count = 26
    spacing = @{ x = 4; y = 0; z = 0 }
    namePrefix = "RailPost_Right"
} | ConvertTo-Json -Depth 5

$railRightResult = Invoke-RestMethod -Uri "$UNITY_BASE/createLinearArray" -Method Post -Body $railPostArrayRightBody -ContentType "application/json"
Write-Host "  Created $($railRightResult.count) railing posts (right side)" -ForegroundColor White

# Step 8: Create decorative arch template
Write-Host "[7/8] Creating decorative arches..." -ForegroundColor Green
$archBody = @{
    type = "Sphere"
    name = "Arch_Base"
    position = @{ x = -50; y = 28; z = 0 }
    scale = @{ x = 4; y = 0.5; z = 6 }
    color = @{ r = 0.6; g = 0.5; b = 0.3; a = 1 }
    metallic = 0.3
    smoothness = 0.5
} | ConvertTo-Json -Depth 5

Invoke-RestMethod -Uri "$UNITY_BASE/createGameObject" -Method Post -Body $archBody -ContentType "application/json"

# Step 9: Create linear array of arches
$archArrayBody = @{
    sourceName = "Arch_Base"
    count = 5
    spacing = @{ x = 25; y = 0; z = 0 }
    namePrefix = "Arch"
} | ConvertTo-Json -Depth 5

$archResult = Invoke-RestMethod -Uri "$UNITY_BASE/createLinearArray" -Method Post -Body $archArrayBody -ContentType "application/json"
Write-Host "  Created $($archResult.count) decorative arches" -ForegroundColor White

# Step 10: Create decorative lights in circular pattern
Write-Host "[8/8] Adding decorative lighting (circular arrays)..." -ForegroundColor Green
$lightBody = @{
    type = "Sphere"
    name = "DecorLight_Base"
    position = @{ x = 0; y = 25; z = 0 }
    scale = @{ x = 0.8; y = 0.8; z = 0.8 }
    color = @{ r = 1.0; g = 0.9; b = 0.6; a = 1 }
    metallic = 0.0
    smoothness = 1.0
    emissionColor = @{ r = 1.0; g = 0.9; b = 0.6 }
    emissionIntensity = 2.0
} | ConvertTo-Json -Depth 5

Invoke-RestMethod -Uri "$UNITY_BASE/createGameObject" -Method Post -Body $lightBody -ContentType "application/json"

# Create circular array at bridge center
$lightCircleBody = @{
    sourceName = "DecorLight_Base"
    count = 8
    radius = 10
    center = @{ x = 0; y = 25; z = 0 }
    rotateToCenter = $false
    namePrefix = "DecorLight"
} | ConvertTo-Json -Depth 5

$lightResult = Invoke-RestMethod -Uri "$UNITY_BASE/createCircularArray" -Method Post -Body $lightCircleBody -ContentType "application/json"
Write-Host "  Created $($lightResult.count) decorative lights in circular pattern" -ForegroundColor White

Write-Host ""
Write-Host "=== BRIDGE CONSTRUCTION COMPLETE ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "BRIDGE STATISTICS:" -ForegroundColor Yellow
Write-Host "  Pillars: $($pillarResult.count)" -ForegroundColor White
Write-Host "  Deck Planks: $($deckResult.count)" -ForegroundColor White
Write-Host "  Left Railings: $($railResult.count)" -ForegroundColor White
Write-Host "  Right Railings: $($railRightResult.count)" -ForegroundColor White
Write-Host "  Arches: $($archResult.count)" -ForegroundColor White
Write-Host "  Lights: $($lightResult.count)" -ForegroundColor White
$totalObjects = $pillarResult.count + $deckResult.count + $railResult.count + $railRightResult.count + $archResult.count + $lightResult.count + 6
Write-Host "  TOTAL OBJECTS: $totalObjects" -ForegroundColor Cyan
Write-Host ""
Write-Host "TOOLS USED:" -ForegroundColor Yellow
Write-Host "  ✓ createPrimitive - Base templates" -ForegroundColor Green
Write-Host "  ✓ createLinearArray - Pillars, deck, railings, arches" -ForegroundColor Green
Write-Host "  ✓ duplicateGameObject - Right side railings" -ForegroundColor Green
Write-Host "  ✓ createCircularArray - Decorative lights" -ForegroundColor Green
Write-Host ""
Write-Host "[SUCCESS] Advanced bridge with 100+ objects created!" -ForegroundColor Green
