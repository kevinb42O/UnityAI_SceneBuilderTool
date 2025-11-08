# ============================================================================
# DEMO: FALLEN TRUNKS & ENHANCED FOREST FLOOR
# Demonstrates the new fallen trunk system with genius combinations
# ============================================================================

. ".\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  DEMO: FALLEN TRUNKS & ENHANCED FOREST FLOOR" -ForegroundColor Cyan
Write-Host "  Showcasing genius combinations of existing systems" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

# Test connection
try {
    $null = Invoke-RestMethod -Uri "http://localhost:8765/ping" -Method POST -ContentType "application/json" -Body '{}' -UseBasicParsing -ErrorAction Stop
    Write-Host "[OK] Unity MCP server connected" -ForegroundColor Green
} catch {
    Write-Host "[FATAL] Unity MCP server not running!" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[CLEANUP] Clearing demo area..." -ForegroundColor Yellow

# Clear previous demo
try {
    $null = Invoke-RestMethod -Uri "$UNITY_BASE/deleteGameObject" `
        -Method POST -ContentType "application/json" `
        -Body (@{ name = "FallenTrunksDemo" } | ConvertTo-Json) -UseBasicParsing
} catch {}

$totalObjects = 0
$startTime = Get-Date

# ============================================================================
# DEMO 1: Basic Fallen Logs
# ============================================================================
Write-Host ""
Write-Host "=== DEMO 1: BASIC FALLEN LOGS ===" -ForegroundColor Magenta

New-Group -name "FallenTrunksDemo"

# Oak log with moss
Write-Host "  [1] Oak log with moss patches..." -ForegroundColor DarkGreen
Build-ColoredObject -name "Demo_OakLog" -type "Cylinder" `
    -x 10 -y 1.2 -z 0 `
    -rx 0 -ry 45 -rz 90 `
    -sx 1.5 -sy 12 -sz 1.5 `
    -color @{ r = 0.35; g = 0.22; b = 0.08 } `
    -metallic 0.0 -smoothness 0.15 `
    -parent "FallenTrunksDemo"
$totalObjects++

for ($m = 0; $m -lt 3; $m++) {
    $mossX = 10 + (($m - 1) * 3)
    $mossZ = 0 + (($m - 1) * 3)
    
    Build-ColoredObject -name "Demo_OakLog_Moss_$m" -type "Sphere" `
        -x $mossX -y 1.5 -z $mossZ `
        -sx 1.0 -sy 0.4 -sz 1.0 `
        -color @{ r = 0.1; g = 0.45; b = 0.15 } `
        -metallic 0.0 -smoothness 0.1 `
        -parent "FallenTrunksDemo"
    $totalObjects++
}

# Pine log with branches
Write-Host "  [2] Pine log with scattered branches..." -ForegroundColor DarkGreen
Build-ColoredObject -name "Demo_PineLog" -type "Cylinder" `
    -x 10 -y 0.8 -z 15 `
    -rx 0 -ry -30 -rz 88 `
    -sx 1.2 -sy 15 -sz 1.2 `
    -color @{ r = 0.28; g = 0.18; b = 0.06 } `
    -metallic 0.0 -smoothness 0.1 `
    -parent "FallenTrunksDemo"
$totalObjects++

for ($b = 0; $b -lt 4; $b++) {
    $branchAngle = -30 * [Math]::PI / 180
    $branchOffset = (($b / 4.0) - 0.5) * 15
    $bx = 10 + ([Math]::Cos($branchAngle) * $branchOffset)
    $bz = 15 + ([Math]::Sin($branchAngle) * $branchOffset)
    
    Build-ColoredObject -name "Demo_PineLog_Branch_$b" -type "Cylinder" `
        -x $bx -y 1.2 -z $bz `
        -rx (Get-Random -Minimum 60 -Maximum 90) `
        -ry (Get-Random -Minimum 0 -Maximum 360) `
        -sx 0.25 -sy 2.5 -sz 0.25 `
        -color @{ r = 0.25; g = 0.15; b = 0.05 } `
        -metallic 0.0 -smoothness 0.05 `
        -parent "FallenTrunksDemo"
    $totalObjects++
}

# Birch log with stripes
Write-Host "  [3] Birch log with black stripes..." -ForegroundColor Gray
Build-ColoredObject -name "Demo_BirchLog" -type "Cylinder" `
    -x 25 -y 0.9 -z 7 `
    -rx 0 -ry 60 -rz 92 `
    -sx 1.0 -sy 14 -sz 1.0 `
    -color @{ r = 0.9; g = 0.9; b = 0.85 } `
    -metallic 0.0 -smoothness 0.25 `
    -parent "FallenTrunksDemo"
$totalObjects++

for ($stripe = 0; $stripe -lt 4; $stripe++) {
    $stripeAngle = 60 * [Math]::PI / 180
    $stripeOffset = (($stripe / 4.0) - 0.5) * 14 * 0.7
    $sx = 25 + ([Math]::Cos($stripeAngle) * $stripeOffset)
    $sz = 7 + ([Math]::Sin($stripeAngle) * $stripeOffset)
    
    Build-ColoredObject -name "Demo_BirchLog_Stripe_$stripe" -type "Cube" `
        -x $sx -y 1.0 -z $sz `
        -ry 60 -rz 92 `
        -sx 1.2 -sy 0.6 -sz 1.2 `
        -color @{ r = 0.15; g = 0.15; b = 0.15 } `
        -metallic 0.0 -smoothness 0.2 `
        -parent "FallenTrunksDemo"
    $totalObjects++
}

Write-Host "  [OK] Basic logs: 12 objects" -ForegroundColor Green

# ============================================================================
# DEMO 2: Magical Willow Log with Glowing Moss
# ============================================================================
Write-Host ""
Write-Host "=== DEMO 2: GLOWING MOSS (Genius Combo!) ===" -ForegroundColor Magenta

Write-Host "  [4] Willow log with GLOWING moss patches..." -ForegroundColor Cyan
Build-ColoredObject -name "Demo_WillowLog" -type "Cylinder" `
    -x 40 -y 1.4 -z 7 `
    -rx 0 -ry 20 -rz 88 `
    -sx 1.8 -sy 16 -sz 1.8 `
    -color @{ r = 0.35; g = 0.18; b = 0.25 } `
    -metallic 0.0 -smoothness 0.15 `
    -parent "FallenTrunksDemo"
$totalObjects++

for ($gm = 0; $gm -lt 5; $gm++) {
    $gmAngle = 20 * [Math]::PI / 180
    $gmOffset = (($gm / 5.0) - 0.5) * 16 * 0.8
    $gmx = 40 + ([Math]::Cos($gmAngle) * $gmOffset)
    $gmz = 7 + ([Math]::Sin($gmAngle) * $gmOffset)
    
    Build-ColoredObject -name "Demo_WillowLog_GlowMoss_$gm" -type "Sphere" `
        -x $gmx -y 1.8 -z $gmz `
        -sx 1.0 -sy 0.3 -sz 1.0 `
        -color @{ r = 0.2; g = 0.6; b = 0.5 } `
        -metallic 0.0 -smoothness 0.3 `
        -parent "FallenTrunksDemo"
    
    Set-Material -name "Demo_WillowLog_GlowMoss_$gm" `
        -emission @{ r = 0.2; g = 0.6; b = 0.5; intensity = 2.5 }
    $totalObjects++
}

Write-Host "  [OK] Glowing log: 6 objects" -ForegroundColor Green

# ============================================================================
# DEMO 3: Natural Log Bridge
# ============================================================================
Write-Host ""
Write-Host "=== DEMO 3: LOG BRIDGE (Parkour Integration!) ===" -ForegroundColor Magenta

Write-Host "  [5] Natural log bridge with support logs..." -ForegroundColor Yellow
Build-ColoredObject -name "Demo_LogBridge_Main" -type "Cylinder" `
    -x 15 -y 3.5 -z 30 `
    -rx 0 -ry 45 -rz 86 `
    -sx 1.6 -sy 22 -sz 1.6 `
    -color @{ r = 0.38; g = 0.24; b = 0.09 } `
    -metallic 0.0 -smoothness 0.2 `
    -parent "FallenTrunksDemo"
$totalObjects++

# Support pile
for ($pile = 0; $pile -lt 4; $pile++) {
    $pileX = 15 + (Get-Random -Minimum -2 -Maximum 2)
    $pileZ = 30 + (Get-Random -Minimum -2 -Maximum 2)
    
    Build-ColoredObject -name "Demo_LogBridge_Support_$pile" -type "Cylinder" `
        -x $pileX -y 1.5 -z $pileZ `
        -rx (Get-Random -Minimum 0 -Maximum 30) `
        -ry (Get-Random -Minimum 0 -Maximum 360) `
        -rz (Get-Random -Minimum 70 -Maximum 110) `
        -sx 0.9 -sy 6 -sz 0.9 `
        -color @{ r = 0.35; g = 0.22; b = 0.08 } `
        -metallic 0.0 -smoothness 0.1 `
        -parent "FallenTrunksDemo"
    $totalObjects++
}

Write-Host "  [OK] Log bridge: 5 objects" -ForegroundColor Green

# ============================================================================
# DEMO 4: Hollow Log Tunnel
# ============================================================================
Write-Host ""
Write-Host "=== DEMO 4: HOLLOW LOG TUNNEL (Genius Feature!) ===" -ForegroundColor Magenta

Write-Host "  [6] Explorable hollow log tunnel..." -ForegroundColor Yellow
Build-ColoredObject -name "Demo_HollowLog" -type "Cylinder" `
    -x 55 -y 2.5 -z 15 `
    -rx 0 -ry 30 -rz 90 `
    -sx 2.5 -sy 14 -sz 2.5 `
    -color @{ r = 0.32; g = 0.20; b = 0.07 } `
    -metallic 0.0 -smoothness 0.1 `
    -parent "FallenTrunksDemo"
$totalObjects++

# Glowing opening markers
for ($opening = 0; $opening -lt 2; $opening++) {
    $openAngle = 30 * [Math]::PI / 180
    $openOffset = ($opening - 0.5) * 14
    $ox = 55 + ([Math]::Cos($openAngle) * $openOffset)
    $oz = 15 + ([Math]::Sin($openAngle) * $openOffset)
    
    Build-ColoredObject -name "Demo_HollowLog_Opening_$opening" -type "Sphere" `
        -x $ox -y 2.5 -z $oz `
        -sx 1.2 -sy 1.2 -sz 1.2 `
        -color @{ r = 1.0; g = 0.8; b = 0.3 } `
        -metallic 0.0 -smoothness 0.9 `
        -parent "FallenTrunksDemo"
    
    Set-Material -name "Demo_HollowLog_Opening_$opening" `
        -emission @{ r = 1.0; g = 0.8; b = 0.3; intensity = 2.0 }
    $totalObjects++
}

Write-Host "  [OK] Hollow tunnel: 3 objects" -ForegroundColor Green

# ============================================================================
# DEMO 5: Log Pile Structure
# ============================================================================
Write-Host ""
Write-Host "=== DEMO 5: LOG PILE (Complex Stacking!) ===" -ForegroundColor Magenta

Write-Host "  [7] Complex log pile structure..." -ForegroundColor Yellow
for ($log = 0; $log -lt 7; $log++) {
    $layerHeight = 0.8 + ($log * 1.3)
    $offsetX = Get-Random -Minimum -2 -Maximum 2
    $offsetZ = Get-Random -Minimum -2 -Maximum 2
    $logLen = Get-Random -Minimum 5 -Maximum 8
    $logW = Get-Random -Minimum 0.7 -Maximum 1.1
    
    Build-ColoredObject -name "Demo_Pile_Log_$log" -type "Cylinder" `
        -x (70 + $offsetX) -y $layerHeight -z (15 + $offsetZ) `
        -rx (Get-Random -Minimum -20 -Maximum 20) `
        -ry (Get-Random -Minimum 0 -Maximum 360) `
        -rz (Get-Random -Minimum 70 -Maximum 110) `
        -sx $logW -sy $logLen -sz $logW `
        -color @{ r = 0.35; g = 0.22; b = 0.08 } `
        -metallic 0.0 -smoothness 0.12 `
        -parent "FallenTrunksDemo"
    $totalObjects++
}

Write-Host "  [OK] Log pile: 7 objects" -ForegroundColor Green

# ============================================================================
# DEMO 6: Log Bench with Backrest
# ============================================================================
Write-Host ""
Write-Host "=== DEMO 6: LOG BENCH (Natural Furniture!) ===" -ForegroundColor Magenta

Write-Host "  [8] Natural log bench with backrest..." -ForegroundColor Yellow
Build-ColoredObject -name "Demo_Bench_Seat" -type "Cylinder" `
    -x 85 -y 1.5 -z 15 `
    -rx 0 -ry 0 -rz 90 `
    -sx 1.0 -sy 8 -sz 1.0 `
    -color @{ r = 0.38; g = 0.24; b = 0.09 } `
    -metallic 0.0 -smoothness 0.2 `
    -parent "FallenTrunksDemo"
$totalObjects++

Build-ColoredObject -name "Demo_Bench_Back" -type "Cylinder" `
    -x 85 -y 2.8 -z 14 `
    -rx 20 -ry 0 -rz 90 `
    -sx 0.8 -sy 7.5 -sz 0.8 `
    -color @{ r = 0.36; g = 0.23; b = 0.08 } `
    -metallic 0.0 -smoothness 0.18 `
    -parent "FallenTrunksDemo"
$totalObjects++

Write-Host "  [OK] Log bench: 2 objects" -ForegroundColor Green

# ============================================================================
# DEMO 7: Scattered Branches
# ============================================================================
Write-Host ""
Write-Host "=== DEMO 7: SCATTERED BRANCHES (Forest Floor!) ===" -ForegroundColor Magenta

Write-Host "  [9] Scattered branches and twigs..." -ForegroundColor DarkGray
for ($scatter = 0; $scatter -lt 15; $scatter++) {
    $sx = Get-Random -Minimum 5 -Maximum 90
    $sz = Get-Random -Minimum 0 -Maximum 35
    $branchLen = Get-Random -Minimum 1.5 -Maximum 4.0
    $branchW = Get-Random -Minimum 0.15 -Maximum 0.35
    
    Build-ColoredObject -name "Demo_Branch_$scatter" -type "Cylinder" `
        -x $sx -y ($branchW * 0.5) -z $sz `
        -rx (Get-Random -Minimum 0 -Maximum 30) `
        -ry (Get-Random -Minimum 0 -Maximum 360) `
        -rz (Get-Random -Minimum 70 -Maximum 110) `
        -sx $branchW -sy $branchLen -sz $branchW `
        -color @{ r = 0.3; g = 0.18; b = 0.06 } `
        -metallic 0.0 -smoothness 0.05 `
        -parent "FallenTrunksDemo"
    $totalObjects++
}

Write-Host "  [OK] Scattered branches: 15 objects" -ForegroundColor Green

# ============================================================================
# DEMO 8: Tree Stump
# ============================================================================
Write-Host ""
Write-Host "=== DEMO 8: TREE STUMP (Cut Logs!) ===" -ForegroundColor Magenta

Write-Host "  [10] Tree stump..." -ForegroundColor DarkYellow
Build-ColoredObject -name "Demo_Stump" -type "Cylinder" `
    -x 50 -y 1.2 -z 30 `
    -sx 2.2 -sy 2.4 -sz 2.2 `
    -color @{ r = 0.4; g = 0.25; b = 0.1 } `
    -metallic 0.0 -smoothness 0.1 `
    -parent "FallenTrunksDemo"
$totalObjects++

Write-Host "  [OK] Stump: 1 object" -ForegroundColor Green

# ============================================================================
# FINAL STATS
# ============================================================================
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  FALLEN TRUNKS DEMO COMPLETE!" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

$duration = (Get-Date) - $startTime
$minutes = [Math]::Floor($duration.TotalMinutes)
$seconds = $duration.Seconds

Write-Host "  Total Demo Objects: $totalObjects" -ForegroundColor White
Write-Host "  Creation Time: ${minutes}m ${seconds}s" -ForegroundColor White
Write-Host ""
Write-Host "  FEATURES DEMONSTRATED:" -ForegroundColor Yellow
Write-Host "    1. Basic Fallen Logs (Oak)" -ForegroundColor DarkGreen
Write-Host "    2. Pine Log with Branches" -ForegroundColor DarkGreen
Write-Host "    3. Birch Log with Stripes" -ForegroundColor Gray
Write-Host "    4. Glowing Moss (Willow)" -ForegroundColor Cyan
Write-Host "    5. Natural Log Bridge" -ForegroundColor Yellow
Write-Host "    6. Hollow Log Tunnel" -ForegroundColor Yellow
Write-Host "    7. Log Pile Structure" -ForegroundColor Yellow
Write-Host "    8. Log Bench with Backrest" -ForegroundColor Yellow
Write-Host "    9. Scattered Branches" -ForegroundColor DarkGray
Write-Host "   10. Tree Stump" -ForegroundColor DarkYellow
Write-Host ""
Write-Host "  GENIUS COMBINATIONS:" -ForegroundColor Magenta
Write-Host "    * Rotated cylinders = horizontal logs" -ForegroundColor White
Write-Host "    * Emission + color = glowing moss" -ForegroundColor White
Write-Host "    * Stacked cylinders = complex piles" -ForegroundColor White
Write-Host "    * Log positioning = parkour bridges" -ForegroundColor White
Write-Host "    * Cylinder geometry = hollow tunnels" -ForegroundColor White
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  Explore the demo area in Unity!" -ForegroundColor Green
Write-Host "  Camera suggestion: Position at (50, 15, 0) looking at (50, 0, 15)" -ForegroundColor Gray
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""
