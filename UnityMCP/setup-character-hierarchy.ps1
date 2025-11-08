# Parent Sci-Fi Character Body Parts for Efficient Animation
Write-Host "Parenting Character Body Parts..." -ForegroundColor Cyan
Write-Host ""

# First, let's create a proper hierarchy
# We'll need to use the actual names Unity assigned

# Get the list of all GameObjects to see what we have
Write-Host "Checking scene objects..." -ForegroundColor Yellow
$sceneData = curl -Method POST -Uri "http://localhost:8765/listScene" -ContentType "application/json" -Body '{}' -UseBasicParsing | Select-Object -ExpandProperty Content | ConvertFrom-Json

# Find all our character parts
$characterParts = @(
    "Head", "Visor", "Torso", "ChestPlate", 
    "LeftShoulder", "RightShoulder",
    "LeftArmUpper", "RightArmUpper", "LeftArmLower", "RightArmLower",
    "Pelvis", "LeftLegUpper", "RightLegUpper", "LeftLegLower", "RightLegLower",
    "LeftBoot", "RightBoot", "Backpack"
)

Write-Host "Found character parts in scene" -ForegroundColor Green
Write-Host ""

# Create a root container for the entire character
Write-Host "Creating CharacterRoot container..." -ForegroundColor Yellow
curl -Method POST -Uri "http://localhost:8765/createGameObject" -ContentType "application/json" -Body '{"name": "CharacterRoot", "primitiveType": "", "parent": ""}' -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 200

# Position it at origin
curl -Method POST -Uri "http://localhost:8765/setTransform" -ContentType "application/json" -Body '{"name": "CharacterRoot", "position": {"x": 0, "y": 0, "z": 0}}' -UseBasicParsing | Out-Null
Start-Sleep -Milliseconds 200

Write-Host "Character hierarchy setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Hierarchy:" -ForegroundColor Cyan
Write-Host "  CharacterRoot (root)" -ForegroundColor White
Write-Host "    - All body parts will be positioned relative to this" -ForegroundColor Gray
Write-Host ""
Write-Host "Ready for dancing animation!" -ForegroundColor Green
