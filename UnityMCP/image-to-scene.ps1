# ============================================================
# IMAGE-TO-SCENE GENERATOR
# Upload any image and generate a Unity scene from it
# ============================================================

param(
    [Parameter(Mandatory=$true, HelpMessage="Path to the image file")]
    [string]$ImagePath,
    
    [Parameter(HelpMessage="Type of analysis: object, scene, architecture, environment")]
    [ValidateSet("object", "scene", "architecture", "environment")]
    [string]$AnalysisType = "scene",
    
    [Parameter(HelpMessage="Detail level (1-10): Higher = more objects and details")]
    [ValidateRange(1, 10)]
    [int]$DetailLevel = 5,
    
    [Parameter(HelpMessage="Output path for generated script")]
    [string]$OutputPath = "",
    
    [Parameter(HelpMessage="Skip VLM step and use example data (for testing)")]
    [switch]$UseExampleData
)

# Import helper library
. "$PSScriptRoot\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " IMAGE-TO-SCENE GENERATOR" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Validate image file exists
if (-not (Test-Path $ImagePath)) {
    Write-Host "[ERROR] Image file not found: $ImagePath" -ForegroundColor Red
    exit 1
}

$imageFullPath = (Resolve-Path $ImagePath).Path
Write-Host "[INFO] Image: $imageFullPath" -ForegroundColor Cyan
Write-Host "[INFO] Analysis Type: $AnalysisType" -ForegroundColor Cyan
Write-Host "[INFO] Detail Level: $DetailLevel" -ForegroundColor Cyan
Write-Host ""

# Test Unity connection
if (-not (Test-UnityConnection)) {
    exit 1
}

# ============================================================
# STEP 1: Prepare Image Analysis
# ============================================================

Write-Host "[STEP 1] Preparing image for analysis..." -ForegroundColor Yellow

# Read image as base64
$imageBytes = [System.IO.File]::ReadAllBytes($imageFullPath)
$imageBase64 = [System.Convert]::ToBase64String($imageBytes)
$imageExt = [System.IO.Path]::GetExtension($imageFullPath).ToLower()

# Determine MIME type
$mimeType = switch ($imageExt) {
    ".jpg"  { "image/jpeg" }
    ".jpeg" { "image/jpeg" }
    ".png"  { "image/png" }
    ".gif"  { "image/gif" }
    ".webp" { "image/webp" }
    default { "image/jpeg" }
}

Write-Host "[OK] Image loaded: $([math]::Round($imageBytes.Length / 1KB, 2)) KB" -ForegroundColor Green
Write-Host ""

# ============================================================
# STEP 2: Generate VLM Prompt
# ============================================================

Write-Host "[STEP 2] Generating VLM analysis prompt..." -ForegroundColor Yellow

$promptTemplate = @"
You are an expert at analyzing images and generating Unity scene descriptions.
Your task is to analyze the provided image and generate a structured JSON response that can be used to create a 3D scene in Unity.

Available Unity primitives: Cube, Sphere, Cylinder, Capsule, Plane, Quad
Available materials: Wood_Oak, Metal_Steel, Metal_Gold, Metal_Bronze, Glass_Clear, Brick_Red, Concrete, Stone_Gray, Grass_Green, Water_Blue, Rubber_Black, Plastic_White, Emissive_Blue, Emissive_Red
Available patterns: Linear array, Circular array, Grid array

ANALYSIS TYPE: $AnalysisType
DETAIL LEVEL: $DetailLevel (1=minimal, 10=maximum detail)
"@

# Add type-specific instructions
$typeInstructions = switch ($AnalysisType) {
    "object" {
        @"

FOCUS: Single object or statue
- Identify the main object
- Approximate its shape using Unity primitives
- Determine scale (small, medium, large)
- Identify material properties (color, metallic, smoothness)
- Break complex shapes into multiple primitive combinations

OUTPUT JSON FORMAT:
{
  "type": "single_object",
  "name": "ObjectName",
  "description": "Brief description",
  "components": [
    {
      "primitive": "Cube",
      "position": {"x": 0, "y": 0, "z": 0},
      "scale": {"x": 1, "y": 1, "z": 1},
      "rotation": {"x": 0, "y": 0, "z": 0},
      "material": {
        "preset": "Material_Name or null",
        "color": {"r": 0.5, "g": 0.5, "b": 0.5},
        "metallic": 0.5,
        "smoothness": 0.5
      }
    }
  ]
}
"@
    }
    "scene" {
        @"

FOCUS: Complete scene with multiple objects
- Identify all major objects and spatial relationships
- Detect patterns (rows, circles, grids)
- Determine ground/terrain type
- Identify lighting conditions
- Group related objects hierarchically

OUTPUT JSON FORMAT:
{
  "type": "complete_scene",
  "description": "Scene overview",
  "environment": {
    "terrain": "flat",
    "ground_material": "Grass_Green",
    "lighting": {
      "type": "Directional",
      "intensity": 1.0,
      "color": {"r": 1, "g": 1, "b": 1}
    }
  },
  "objects": [
    {
      "name": "ObjectName",
      "primitive": "Cube",
      "position": {"x": 0, "y": 0, "z": 0},
      "scale": {"x": 1, "y": 1, "z": 1},
      "material": {"preset": "Concrete"}
    }
  ]
}
"@
    }
    "architecture" {
        @"

FOCUS: Building or architectural structure
- Identify structural elements (walls, floors, roof, windows, doors)
- Detect architectural style
- Measure proportions
- Identify material types
- Detect repetitive elements

OUTPUT JSON FORMAT:
{
  "type": "architecture",
  "style": "Modern",
  "description": "Building description",
  "structure": {
    "walls": [
      {
        "position": {"x": 0, "y": 0, "z": 0},
        "scale": {"x": 10, "y": 5, "z": 0.5},
        "material": "Brick_Red"
      }
    ],
    "windows": [...],
    "roof": {...}
  }
}
"@
    }
    "environment" {
        @"

FOCUS: Natural or outdoor environment
- Identify environment type (forest, desert, city, etc.)
- Detect vegetation (trees, grass, bushes)
- Identify terrain features
- Determine atmosphere
- Count and distribute natural elements

OUTPUT JSON FORMAT:
{
  "type": "environment",
  "biome": "Forest",
  "description": "Environment overview",
  "terrain": {
    "type": "hilly",
    "size": {"x": 100, "z": 100}
  },
  "vegetation": [
    {
      "type": "tree",
      "count": 20,
      "distribution": "scattered"
    }
  ]
}
"@
    }
}

$fullPrompt = $promptTemplate + $typeInstructions

Write-Host "[OK] Prompt generated" -ForegroundColor Green
Write-Host ""

# ============================================================
# STEP 3: VLM Analysis (Manual or Example)
# ============================================================

Write-Host "[STEP 3] Image analysis..." -ForegroundColor Yellow
Write-Host ""

if ($UseExampleData) {
    Write-Host "[INFO] Using example analysis data (testing mode)" -ForegroundColor Cyan
    
    # Example data based on analysis type
    $analysisResult = switch ($AnalysisType) {
        "object" {
            @{
                type = "single_object"
                name = "SimpleStatue"
                description = "A simple statue-like object"
                components = @(
                    @{
                        primitive = "Cylinder"
                        position = @{ x = 0; y = 1; z = 0 }
                        scale = @{ x = 1; y = 2; z = 1 }
                        rotation = @{ x = 0; y = 0; z = 0 }
                        material = @{
                            preset = "Stone_Gray"
                            color = $null
                            metallic = 0
                            smoothness = 0.3
                        }
                    },
                    @{
                        primitive = "Sphere"
                        position = @{ x = 0; y = 3; z = 0 }
                        scale = @{ x = 0.8; y = 0.8; z = 0.8 }
                        rotation = @{ x = 0; y = 0; z = 0 }
                        material = @{
                            preset = "Stone_Gray"
                            color = $null
                            metallic = 0
                            smoothness = 0.3
                        }
                    }
                )
            }
        }
        "scene" {
            @{
                type = "complete_scene"
                description = "Simple outdoor scene"
                environment = @{
                    terrain = "flat"
                    ground_material = "Grass_Green"
                    lighting = @{
                        type = "Directional"
                        intensity = 1.0
                        color = @{ r = 1; g = 1; b = 1 }
                        direction = @{ x = 0; y = -1; z = 0 }
                    }
                }
                objects = @(
                    @{
                        name = "Tree1"
                        primitive = "Cylinder"
                        position = @{ x = -5; y = 2; z = 0 }
                        scale = @{ x = 0.5; y = 4; z = 0.5 }
                        material = @{ preset = "Wood_Oak" }
                    },
                    @{
                        name = "Tree2"
                        primitive = "Cylinder"
                        position = @{ x = 5; y = 2; z = 0 }
                        scale = @{ x = 0.5; y = 4; z = 0.5 }
                        material = @{ preset = "Wood_Oak" }
                    }
                )
            }
        }
        default {
            @{
                type = "complete_scene"
                description = "Generic scene"
                environment = @{
                    ground_material = "Concrete"
                }
                objects = @()
            }
        }
    }
} else {
    Write-Host "============================================================" -ForegroundColor Magenta
    Write-Host " MANUAL VLM STEP REQUIRED" -ForegroundColor Magenta
    Write-Host "============================================================" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "To complete scene generation, follow these steps:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. Copy the prompt below" -ForegroundColor White
    Write-Host "2. Go to Claude (claude.ai) or ChatGPT with vision" -ForegroundColor White
    Write-Host "3. Upload your image: $imageFullPath" -ForegroundColor White
    Write-Host "4. Paste the prompt" -ForegroundColor White
    Write-Host "5. Copy the JSON response" -ForegroundColor White
    Write-Host "6. Save it to a file (e.g., analysis.json)" -ForegroundColor White
    Write-Host "7. Run: .\generate-scene-from-json.ps1 -JsonPath analysis.json" -ForegroundColor White
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "PROMPT (copy everything below this line):" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host $fullPrompt
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[INFO] Prompt has been saved to: image-analysis-prompt.txt" -ForegroundColor Green
    
    # Save prompt to file
    $fullPrompt | Out-File -FilePath "image-analysis-prompt.txt" -Encoding UTF8
    
    Write-Host ""
    Write-Host "[INFO] For testing without VLM, run with -UseExampleData flag" -ForegroundColor Cyan
    exit 0
}

# ============================================================
# STEP 4: Generate PowerShell Script
# ============================================================

Write-Host "[STEP 4] Generating PowerShell script..." -ForegroundColor Yellow

# Import the script generator
$scriptContent = @"
# ============================================================
# AUTO-GENERATED UNITY SCENE SCRIPT
# Generated from image analysis
# Type: $($analysisResult.type)
# ============================================================

# Import helper library
. "`$PSScriptRoot\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Image-to-Scene Generation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test connection
if (-not (Test-UnityConnection)) {
    exit 1
}

Write-Host ""
Write-Host "[INFO] Generating scene from image analysis..." -ForegroundColor Green
Write-Host "[INFO] Type: $($analysisResult.type)" -ForegroundColor Cyan
Write-Host ""

"@

# Generate based on type
if ($analysisResult.type -eq "single_object") {
    $scriptContent += @"
# ============================================================
# OBJECT: $($analysisResult.name)
# Description: $($analysisResult.description)
# ============================================================

Write-Host "[PHASE 1] Creating object..." -ForegroundColor Yellow
Write-Host ""

# Create parent group
New-Group -name "$($analysisResult.name)"

"@

    $componentIndex = 1
    foreach ($component in $analysisResult.components) {
        $compName = "$($analysisResult.name)_Part$componentIndex"
        $scriptContent += @"
# Component $componentIndex : $($component.primitive)
Create-UnityObject -name "$compName" -type "$($component.primitive)" -parent "$($analysisResult.name)"
Set-Transform -name "$compName" ``
    -x $($component.position.x) -y $($component.position.y) -z $($component.position.z) ``
    -sx $($component.scale.x) -sy $($component.scale.y) -sz $($component.scale.z)

"@

        if ($component.material.preset) {
            $scriptContent += "Apply-Material -name `"$compName`" -materialName `"$($component.material.preset)`"`n"
        }
        
        $scriptContent += "Write-Host `"  [OK] Created $compName`" -ForegroundColor Green`n"
        $scriptContent += "Start-Sleep -Milliseconds 100`n`n"
        
        $componentIndex++
    }
    
    $scriptContent += @"
Write-Host ""
Write-Host "[PHASE 2] Optimizing object..." -ForegroundColor Yellow
Optimize-Group -parentName "$($analysisResult.name)"
Write-Host "[OK] Object complete" -ForegroundColor Green
Write-Host ""

"@
} elseif ($analysisResult.type -eq "complete_scene") {
    $scriptContent += @"
# ============================================================
# SCENE: $($analysisResult.description)
# ============================================================

Write-Host "[PHASE 1] Setting up environment..." -ForegroundColor Yellow
Write-Host ""

# Create ground
Create-UnityObject -name "Ground" -type "Plane"
Set-Transform -name "Ground" -sx 50 -sz 50
Apply-Material -name "Ground" -materialName "$($analysisResult.environment.ground_material)"
Write-Host "  [OK] Ground created" -ForegroundColor Green
Write-Host ""

Write-Host "[PHASE 2] Creating objects..." -ForegroundColor Yellow
Write-Host ""

"@

    foreach ($obj in $analysisResult.objects) {
        $scriptContent += @"
# Object: $($obj.name)
Create-UnityObject -name "$($obj.name)" -type "$($obj.primitive)"
Set-Transform -name "$($obj.name)" ``
    -x $($obj.position.x) -y $($obj.position.y) -z $($obj.position.z) ``
    -sx $($obj.scale.x) -sy $($obj.scale.y) -sz $($obj.scale.z)
Apply-Material -name "$($obj.name)" -materialName "$($obj.material.preset)"
Write-Host "  [OK] Created $($obj.name)" -ForegroundColor Green
Start-Sleep -Milliseconds 100

"@
    }
}

$scriptContent += @"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host " Scene Generation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
"@

# Determine output path
if ($OutputPath -eq "") {
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $OutputPath = "generated-scene-$timestamp.ps1"
}

# Save script
$scriptContent | Out-File -FilePath $OutputPath -Encoding UTF8

Write-Host "[OK] Script generated: $OutputPath" -ForegroundColor Green
Write-Host ""

# ============================================================
# STEP 5: Execute Script (Optional)
# ============================================================

Write-Host "[STEP 5] Ready to execute..." -ForegroundColor Yellow
Write-Host ""
Write-Host "To create the scene in Unity, run:" -ForegroundColor Cyan
Write-Host "  .\$OutputPath" -ForegroundColor White
Write-Host ""
Write-Host "Or press Enter to execute now, Ctrl+C to cancel..." -ForegroundColor Yellow
$null = Read-Host

Write-Host ""
Write-Host "Executing scene generation..." -ForegroundColor Green
& $OutputPath

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host " IMAGE-TO-SCENE COMPLETE!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
