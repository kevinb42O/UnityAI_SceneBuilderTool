# World Generation Quick Reference Card

**One command. Complete world. 2-10 seconds.**

---

## 🚀 Quick Start

```powershell
# Load helpers
. .\unity-helpers-v2.ps1

# Generate world
New-World -biome "Fantasy"
```

---

## 🌍 10 Biomes

| Biome | Description | Time | Objects |
|-------|-------------|------|---------|
| **Forest** 🌲 | Trees, grass | 3-5s | 50-100 |
| **Desert** 🏜️ | Dunes, cacti | 2-4s | 30-60 |
| **City** 🏙️ | Buildings, grid | 5-8s | 25-100 |
| **Medieval** 🏰 | Castle, houses | 4-7s | 30-70 |
| **SciFi** 🚀 | Metallic, glow | 4-8s | 25-80 |
| **Fantasy** ✨ | Magic, crystals | 5-9s | 50-120 |
| **Underwater** 🌊 | Coral, fog | 3-6s | 50-100 |
| **Arctic** ❄️ | Ice, snow | 3-5s | 30-60 |
| **Jungle** 🌴 | Dense plants | 6-10s | 100-200 |
| **Wasteland** 💀 | Ruins, debris | 3-6s | 25-50 |

---

## ⚙️ Parameters

```powershell
New-World `
    -biome "Medieval" `      # Required: Biome type
    -worldSize 150 `         # Default: 100 (50-500)
    -density 70 `            # Default: 50 (0-100)
    -includeTerrain $true `  # Default: true
    -includeLighting $true ` # Default: true
    -includeProps $true `    # Default: true
    -optimizeMeshes $true `  # Default: true
    -seed "MyWorld123"       # Optional: reproducible
```

---

## 💡 Common Commands

```powershell
# Standard world
New-World -biome "Forest"

# Large dense world
New-World -biome "City" -worldSize 200 -density 80

# Reproducible world
New-World -biome "Medieval" -seed "Kingdom1"

# Performance test
New-World -biome "SciFi" -density 100 -optimizeMeshes $true
```

---

## 🎯 Size Guide

- **Tiny** (50): Quick tests, mobile games
- **Small** (75): Indoor levels, arenas
- **Medium** (100): Standard game levels
- **Large** (150): Open world sections
- **Huge** (200-300): MMO-scale
- **Massive** (400-500): Stress tests

---

## 📊 Density Guide

- **0-20**: Minimal, empty
- **20-40**: Sparse, survival
- **40-60**: Standard, balanced
- **60-80**: Dense, detailed
- **80-100**: Maximum, cinematic

---

## 🎨 What's Generated

Every world includes:
- ✅ **Terrain** - Ground, hills, elevation
- ✅ **Environment** - Trees/buildings/structures
- ✅ **Props** - Rocks, details
- ✅ **Lighting** - Biome-specific
- ✅ **Optimization** - Auto mesh combine

---

## ⚡ Performance

| Density | Objects | Gen Time | Draw Calls |
|---------|---------|----------|------------|
| 25 | 20-40 | 2-3s | 1-2 |
| 50 | 50-100 | 4-6s | 1-3 |
| 75 | 80-150 | 7-10s | 2-4 |
| 100 | 100-200 | 10-15s | 3-5 |

*After optimization: 60x fewer draw calls*

---

## 🔮 AI Natural Language

AI understands these phrases:

**Biome Selection:**
- "magical forest" → Fantasy
- "medieval castle" → Medieval
- "futuristic city" → SciFi
- "desert survival" → Desert
- "underwater level" → Underwater
- "frozen wasteland" → Arctic
- "dense jungle" → Jungle
- "post-apocalyptic" → Wasteland

**Size Indicators:**
- "small", "tiny" → worldSize 50-75
- "medium", "standard" → worldSize 100
- "large", "big" → worldSize 150-200
- "massive", "huge" → worldSize 250-400

**Density Hints:**
- "sparse", "empty" → density 20-30
- "normal", "balanced" → density 50
- "dense", "crowded" → density 70-80
- "packed", "full" → density 90-100

**Reproducibility:**
- "same every time" → Add seed
- "reproducible" → Add seed
- "random" → No seed

---

## 📝 Examples

### Example 1: Quick Test
```powershell
New-World -biome "Forest"
```
Creates 100x100 forest with 50 trees in 3 seconds.

### Example 2: Game Level
```powershell
New-World -biome "Medieval" -worldSize 150 -density 70
```
Creates 150x150 medieval level with castle and ~40 houses in 7 seconds.

### Example 3: Reproducible
```powershell
New-World -biome "SciFi" -seed "Alpha01"
```
Creates identical world every time with same seed.

### Example 4: Stress Test
```powershell
New-World -biome "City" -worldSize 300 -density 100
```
Creates massive 300x300 city with maximum density in 15 seconds.

---

## 🐛 Troubleshooting

**Empty world?**
→ Increase density parameter

**Too slow?**
→ Reduce worldSize and density

**Too dense?**
→ Decrease density parameter

**Want identical world?**
→ Use seed parameter

**Performance issues?**
→ Keep optimizeMeshes enabled

---

## 📚 More Info

- **Full Guide:** `WORLD_GENERATION_GUIDE.md`
- **Examples:** `demo-world-generation.ps1`
- **AI Examples:** `ai-world-generation-examples.ps1`
- **Main Docs:** `V2_DOCUMENTATION.md`

---

**Build worlds with words.** 🌍✨
