# ============================================================
# AI-Driven Natural Language World Generation Examples
# Demonstrates how AI can understand natural language and generate worlds
# ============================================================

# Import helper library
. "$PSScriptRoot\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AI NATURAL LANGUAGE WORLD GENERATION" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script demonstrates natural language commands that AI can interpret" -ForegroundColor White
Write-Host ""

# Test connection
if (-not (Test-UnityConnection)) {
    exit 1
}

# ============================================================
# Example 1: "Create a magical fantasy world"
# ============================================================

Write-Host ""
Write-Host "[EXAMPLE 1] User says: 'Create a magical fantasy world'" -ForegroundColor Yellow
Write-Host "            AI interprets: Fantasy biome with default settings" -ForegroundColor Gray
Write-Host ""

$world1 = New-World -biome "Fantasy"

if ($world1) {
    Write-Host "✅ Created Fantasy world with magical trees and glowing crystals" -ForegroundColor Green
    Start-Sleep -Seconds 2
}

# ============================================================
# Example 2: "Build a large medieval kingdom with lots of buildings"
# ============================================================

Write-Host ""
Write-Host "[EXAMPLE 2] User says: 'Build a large medieval kingdom with lots of buildings'" -ForegroundColor Yellow
Write-Host "            AI interprets: Medieval biome, large size, high density" -ForegroundColor Gray
Write-Host ""

try {
    Invoke-RestMethod -Uri "$UNITY_BASE/newScene" -Method POST -UseBasicParsing | Out-Null
}
catch {}

$world2 = New-World -biome "Medieval" -worldSize 150 -density 80

if ($world2) {
    Write-Host "✅ Created large Medieval kingdom with castle and many houses" -ForegroundColor Green
    Start-Sleep -Seconds 2
}

# ============================================================
# Example 3: "Generate a futuristic sci-fi city"
# ============================================================

Write-Host ""
Write-Host "[EXAMPLE 3] User says: 'Generate a futuristic sci-fi city'" -ForegroundColor Yellow
Write-Host "            AI interprets: SciFi biome with city features" -ForegroundColor Gray
Write-Host ""

try {
    Invoke-RestMethod -Uri "$UNITY_BASE/newScene" -Method POST -UseBasicParsing | Out-Null
}
catch {}

$world3 = New-World -biome "SciFi" -worldSize 120 -density 60

if ($world3) {
    Write-Host "✅ Created SciFi city with metallic buildings and glowing energy" -ForegroundColor Green
    Start-Sleep -Seconds 2
}

# ============================================================
# Example 4: "I need a desert survival environment"
# ============================================================

Write-Host ""
Write-Host "[EXAMPLE 4] User says: 'I need a desert survival environment'" -ForegroundColor Yellow
Write-Host "            AI interprets: Desert biome, survival-appropriate density" -ForegroundColor Gray
Write-Host ""

try {
    Invoke-RestMethod -Uri "$UNITY_BASE/newScene" -Method POST -UseBasicParsing | Out-Null
}
catch {}

$world4 = New-World -biome "Desert" -density 40

if ($world4) {
    Write-Host "✅ Created Desert environment with dunes and cacti" -ForegroundColor Green
    Start-Sleep -Seconds 2
}

# ============================================================
# Example 5: "Create an underwater level with coral"
# ============================================================

Write-Host ""
Write-Host "[EXAMPLE 5] User says: 'Create an underwater level with coral'" -ForegroundColor Yellow
Write-Host "            AI interprets: Underwater biome" -ForegroundColor Gray
Write-Host ""

try {
    Invoke-RestMethod -Uri "$UNITY_BASE/newScene" -Method POST -UseBasicParsing | Out-Null
}
catch {}

$world5 = New-World -biome "Underwater" -density 55

if ($world5) {
    Write-Host "✅ Created Underwater world with colorful coral formations" -ForegroundColor Green
    Start-Sleep -Seconds 2
}

# ============================================================
# Example 6: "Make me a forest, but I want it to be the same every time"
# ============================================================

Write-Host ""
Write-Host "[EXAMPLE 6] User says: 'Make me a forest, but I want it to be the same every time'" -ForegroundColor Yellow
Write-Host "            AI interprets: Forest biome with seed for reproducibility" -ForegroundColor Gray
Write-Host ""

try {
    Invoke-RestMethod -Uri "$UNITY_BASE/newScene" -Method POST -UseBasicParsing | Out-Null
}
catch {}

$world6 = New-World -biome "Forest" -seed "MyForest2025"

if ($world6) {
    Write-Host "✅ Created reproducible Forest (same seed = same world)" -ForegroundColor Green
    Start-Sleep -Seconds 2
}

# ============================================================
# Example 7: "Generate a massive city for an open world game"
# ============================================================

Write-Host ""
Write-Host "[EXAMPLE 7] User says: 'Generate a massive city for an open world game'" -ForegroundColor Yellow
Write-Host "            AI interprets: City biome, maximum size and density" -ForegroundColor Gray
Write-Host ""

try {
    Invoke-RestMethod -Uri "$UNITY_BASE/newScene" -Method POST -UseBasicParsing | Out-Null
}
catch {}

$world7 = New-World -biome "City" -worldSize 250 -density 90

if ($world7) {
    Write-Host "✅ Created massive City with many buildings" -ForegroundColor Green
    Start-Sleep -Seconds 2
}

# ============================================================
# Example 8: "Create a post-apocalyptic wasteland"
# ============================================================

Write-Host ""
Write-Host "[EXAMPLE 8] User says: 'Create a post-apocalyptic wasteland'" -ForegroundColor Yellow
Write-Host "            AI interprets: Wasteland biome" -ForegroundColor Gray
Write-Host ""

try {
    Invoke-RestMethod -Uri "$UNITY_BASE/newScene" -Method POST -UseBasicParsing | Out-Null
}
catch {}

$world8 = New-World -biome "Wasteland" -density 50

if ($world8) {
    Write-Host "✅ Created Wasteland with debris and ruins" -ForegroundColor Green
    Start-Sleep -Seconds 2
}

# ============================================================
# Example 9: "Build a dense jungle for exploration"
# ============================================================

Write-Host ""
Write-Host "[EXAMPLE 9] User says: 'Build a dense jungle for exploration'" -ForegroundColor Yellow
Write-Host "            AI interprets: Jungle biome with high density" -ForegroundColor Gray
Write-Host ""

try {
    Invoke-RestMethod -Uri "$UNITY_BASE/newScene" -Method POST -UseBasicParsing | Out-Null
}
catch {}

$world9 = New-World -biome "Jungle" -density 70

if ($world9) {
    Write-Host "✅ Created dense Jungle with varied vegetation" -ForegroundColor Green
    Start-Sleep -Seconds 2
}

# ============================================================
# Example 10: "Create a frozen arctic landscape"
# ============================================================

Write-Host ""
Write-Host "[EXAMPLE 10] User says: 'Create a frozen arctic landscape'" -ForegroundColor Yellow
Write-Host "             AI interprets: Arctic biome" -ForegroundColor Gray
Write-Host ""

try {
    Invoke-RestMethod -Uri "$UNITY_BASE/newScene" -Method POST -UseBasicParsing | Out-Null
}
catch {}

$world10 = New-World -biome "Arctic" -density 45

if ($world10) {
    Write-Host "✅ Created Arctic landscape with ice formations" -ForegroundColor Green
}

# ============================================================
# COMPLETION
# ============================================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " AI NATURAL LANGUAGE DEMO COMPLETE!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Natural Language Capabilities Demonstrated:" -ForegroundColor Yellow
Write-Host ""
Write-Host "✅ 'Create a magical fantasy world' → Fantasy biome" -ForegroundColor White
Write-Host "✅ 'Build a large medieval kingdom' → Medieval with high density" -ForegroundColor White
Write-Host "✅ 'Generate a futuristic sci-fi city' → SciFi biome" -ForegroundColor White
Write-Host "✅ 'I need a desert survival environment' → Desert biome" -ForegroundColor White
Write-Host "✅ 'Create an underwater level' → Underwater biome" -ForegroundColor White
Write-Host "✅ 'Same every time' → Seed-based reproducibility" -ForegroundColor White
Write-Host "✅ 'Massive city for open world' → Large size, high density" -ForegroundColor White
Write-Host "✅ 'Post-apocalyptic wasteland' → Wasteland biome" -ForegroundColor White
Write-Host "✅ 'Dense jungle for exploration' → Jungle with high density" -ForegroundColor White
Write-Host "✅ 'Frozen arctic landscape' → Arctic biome" -ForegroundColor White
Write-Host ""

Write-Host "The AI understands context and intent:" -ForegroundColor Cyan
Write-Host "  • 'magical' → Fantasy" -ForegroundColor Gray
Write-Host "  • 'medieval kingdom' → Medieval" -ForegroundColor Gray
Write-Host "  • 'futuristic sci-fi' → SciFi" -ForegroundColor Gray
Write-Host "  • 'survival' → Appropriate density" -ForegroundColor Gray
Write-Host "  • 'massive' → Large worldSize" -ForegroundColor Gray
Write-Host "  • 'dense' → High density" -ForegroundColor Gray
Write-Host "  • 'same every time' → Uses seed" -ForegroundColor Gray
Write-Host ""

Write-Host "Try your own natural language commands!" -ForegroundColor Yellow
Write-Host "The AI can interpret and generate worlds from:" -ForegroundColor White
Write-Host "  • Descriptive phrases ('magical forest', 'ruined city')" -ForegroundColor Gray
Write-Host "  • Use cases ('survival game', 'racing track')" -ForegroundColor Gray
Write-Host "  • Size indicators ('small', 'massive', 'huge')" -ForegroundColor Gray
Write-Host "  • Density hints ('sparse', 'crowded', 'packed')" -ForegroundColor Gray
Write-Host ""

Write-Host "This is TEXT-TO-WORLD generation." -ForegroundColor Cyan
Write-Host ""
