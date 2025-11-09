# ============================================================
# GENERATE SCENE FROM VLM JSON
# Takes VLM analysis JSON and generates Unity scene
# ============================================================

param(
    [Parameter(Mandatory=$true, HelpMessage="Path to VLM analysis JSON file")]
    [string]$JsonPath,
    
    [Parameter(HelpMessage="Execute the scene immediately")]
    [switch]$Execute
)

# Import helper library
. "$PSScriptRoot\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " SCENE GENERATION FROM VLM ANALYSIS" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Validate JSON file exists
if (-not (Test-Path $JsonPath)) {
    Write-Host "[ERROR] JSON file not found: $JsonPath" -ForegroundColor Red
    exit 1
}

# Load JSON
Write-Host "[INFO] Loading analysis data..." -ForegroundColor Cyan
$analysisResult = Get-Content $JsonPath -Raw | ConvertFrom-Json

Write-Host "[OK] Analysis loaded: $($analysisResult.type)" -ForegroundColor Green
Write-Host ""

# Test Unity connection
if (-not (Test-UnityConnection)) {
    exit 1
}

# ============================================================
# Generate PowerShell Script
# ============================================================

Write-Host "[INFO] Generating scene script..." -ForegroundColor Yellow

$scriptContent = @"
# ============================================================
# AUTO-GENERATED UNITY SCENE SCRIPT
# Generated from VLM image analysis
# Type: $($analysisResult.type)
# ============================================================

# Import helper library
. "`$PSScriptRoot\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " VLM-to-Scene Generation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test connection
if (-not (Test-UnityConnection)) {
    exit 1
}

Write-Host ""
Write-Host "[INFO] Generating scene from VLM analysis..." -ForegroundColor Green
Write-Host "[INFO] Type: $($analysisResult.type)" -ForegroundColor Cyan
Write-Host ""

"@

# Generate based on type
switch ($analysisResult.type) {
    "single_object" {
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
            } else {
                $scriptContent += "Set-Material -name `"$compName`" ``
    -color @{ r = $($component.material.color.r); g = $($component.material.color.g); b = $($component.material.color.b) } ``
    -metallic $($component.material.metallic) -smoothness $($component.material.smoothness)`n"
            }
            
            $scriptContent += "Write-Host `"  [OK] Created $compName`" -ForegroundColor Green`n"
            $scriptContent += "Start-Sleep -Milliseconds 100`n`n"
            
            $componentIndex++
        }
        
        $scriptContent += @"
Write-Host ""
Write-Host "[PHASE 2] Optimizing object..." -ForegroundColor Yellow
Optimize-Group -parentName "$($analysisResult.name)"
Write-Host "[OK] Object complete with $($analysisResult.components.Count) components" -ForegroundColor Green
Write-Host ""

"@
    }
    
    "complete_scene" {
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

Write-Host "[PHASE 2] Creating objects ($($analysisResult.objects.Count) total)..." -ForegroundColor Yellow
Write-Host ""

"@

        foreach ($obj in $analysisResult.objects) {
            $scriptContent += @"
# Object: $($obj.name)
Create-UnityObject -name "$($obj.name)" -type "$($obj.primitive)"
Set-Transform -name "$($obj.name)" ``
    -x $($obj.position.x) -y $($obj.position.y) -z $($obj.position.z) ``
    -sx $($obj.scale.x) -sy $($obj.scale.y) -sz $($obj.scale.z)

"@

            if ($obj.material.preset) {
                $scriptContent += "Apply-Material -name `"$($obj.name)`" -materialName `"$($obj.material.preset)`"`n"
            } else {
                $scriptContent += "Set-Material -name `"$($obj.name)`" ``
    -color @{ r = $($obj.material.color.r); g = $($obj.material.color.g); b = $($obj.material.color.b) } ``
    -metallic $($obj.material.metallic) -smoothness $($obj.material.smoothness)`n"
            }
            
            $scriptContent += "Write-Host `"  [OK] Created $($obj.name)`" -ForegroundColor Green`n"
            $scriptContent += "Start-Sleep -Milliseconds 100`n`n"
        }
    }
    
    "architecture" {
        $scriptContent += @"
# ============================================================
# ARCHITECTURE: $($analysisResult.style) Style
# Description: $($analysisResult.description)
# ============================================================

Write-Host "[PHASE 1] Creating building structure..." -ForegroundColor Yellow
Write-Host ""

# Create building group
New-Group -name "Building"

"@

        # Foundation
        if ($analysisResult.structure.foundation) {
            $scriptContent += @"
# Foundation
Create-UnityObject -name "Foundation" -type "Cube" -parent "Building"
Set-Transform -name "Foundation" -y -0.5 -sx 15 -sy 0.5 -sz 15
Apply-Material -name "Foundation" -materialName "Concrete"
Write-Host "  [OK] Foundation created" -ForegroundColor Green

"@
        }

        # Walls
        if ($analysisResult.structure.walls) {
            $scriptContent += @"
# Walls
New-Group -name "Walls" -parent "Building"

"@

            $wallIndex = 1
            foreach ($wall in $analysisResult.structure.walls) {
                $wallName = "Wall_$wallIndex"
                $scriptContent += @"
Create-UnityObject -name "$wallName" -type "Cube" -parent "Walls"
Set-Transform -name "$wallName" ``
    -x $($wall.position.x) -y $($wall.position.y) -z $($wall.position.z) ``
    -sx $($wall.scale.x) -sy $($wall.scale.y) -sz $($wall.scale.z)
Apply-Material -name "$wallName" -materialName "$($wall.material)"
Write-Host "  [OK] $wallName created" -ForegroundColor Green

"@
                $wallIndex++
            }
        }

        # Windows
        if ($analysisResult.structure.windows) {
            $scriptContent += @"
# Windows
New-Group -name "Windows" -parent "Building"

"@

            $winIndex = 1
            foreach ($window in $analysisResult.structure.windows) {
                $winName = "Window_$winIndex"
                $scriptContent += @"
Create-UnityObject -name "$winName" -type "Cube" -parent "Windows"
Set-Transform -name "$winName" ``
    -x $($window.position.x) -y $($window.position.y) -z $($window.position.z) ``
    -sx $($window.scale.x) -sy $($window.scale.y) -sz $($window.scale.z)
Apply-Material -name "$winName" -materialName "Glass_Clear"
Write-Host "  [OK] $winName created" -ForegroundColor Green

"@
                $winIndex++
            }
        }

        $scriptContent += @"

Write-Host ""
Write-Host "[PHASE 2] Optimizing building..." -ForegroundColor Yellow
Optimize-Group -parentName "Building"
Write-Host "[OK] Building complete" -ForegroundColor Green
Write-Host ""

"@
    }
    
    "environment" {
        $scriptContent += @"
# ============================================================
# ENVIRONMENT: $($analysisResult.biome) Biome
# Description: $($analysisResult.description)
# ============================================================

"@

        # Check if we can use world generation
        $recognizedBiomes = @('Forest', 'Desert', 'City', 'Medieval', 'SciFi', 'Fantasy', 'Underwater', 'Arctic', 'Jungle', 'Wasteland')
        if ($recognizedBiomes -contains $analysisResult.biome) {
            $scriptContent += @"
Write-Host "[INFO] Using world generation for $($analysisResult.biome) biome..." -ForegroundColor Cyan
Write-Host ""

# Generate world using built-in biome
New-World -biome "$($analysisResult.biome)" -worldSize $($analysisResult.terrain.size.x) -density 70

Write-Host ""
Write-Host "[OK] $($analysisResult.biome) world generated" -ForegroundColor Green
Write-Host ""

"@
        } else {
            $scriptContent += @"
Write-Host "[PHASE 1] Creating custom environment..." -ForegroundColor Yellow
Write-Host ""

# Create terrain
Create-UnityObject -name "Terrain" -type "Plane"
Set-Transform -name "Terrain" -sx $([math]::Round($analysisResult.terrain.size.x / 10, 2)) -sz $([math]::Round($analysisResult.terrain.size.z / 10, 2))
Apply-Material -name "Terrain" -materialName "Grass_Green"
Write-Host "  [OK] Terrain created" -ForegroundColor Green
Write-Host ""

"@
        }
    }
}

$scriptContent += @"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host " Scene Generation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
"@

# Save script
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$outputPath = "generated-scene-$timestamp.ps1"
$scriptContent | Out-File -FilePath $outputPath -Encoding UTF8

Write-Host "[OK] Script generated: $outputPath" -ForegroundColor Green
Write-Host ""

# Execute if requested
if ($Execute) {
    Write-Host "Executing scene generation..." -ForegroundColor Green
    Write-Host ""
    & $outputPath
} else {
    Write-Host "To create the scene in Unity, run:" -ForegroundColor Cyan
    Write-Host "  .\$outputPath" -ForegroundColor White
    Write-Host ""
}

Write-Host "============================================================" -ForegroundColor Green
Write-Host " COMPLETE!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
