# Getting Started with World Generation

**From zero to complete world in 5 minutes**

---

## 📋 Prerequisites

✅ Unity 2021.3 or newer  
✅ Node.js 18+  
✅ PowerShell (Windows) or compatible shell  
✅ Repository cloned

---

## 🚀 5-Minute Quick Start

### Step 1: Setup Unity (1 minute)

1. Open Unity Editor
2. Copy `Assets/Editor/UnityMCPServer.cs` to your project's `Assets/Editor/` folder
3. Unity will auto-compile and start the MCP server
4. Look for console message: `[Unity MCP] Server started on port 8765`

✅ **Checkpoint:** Unity console shows server started message

### Step 2: Setup Node.js (1 minute)

```bash
cd UnityMCP
npm install
```

✅ **Checkpoint:** No errors, `node_modules` folder created

### Step 3: Test Connection (30 seconds)

```powershell
cd UnityMCP
. .\unity-helpers-v2.ps1
Test-UnityConnection
```

Expected output: `[OK] Unity connection successful`

✅ **Checkpoint:** Connection test passes

### Step 4: Generate Your First World (30 seconds)

```powershell
New-World -biome "Fantasy"
```

Watch Unity Editor - you'll see objects appearing in the scene!

✅ **Checkpoint:** Unity Scene view shows a world with terrain, trees, and crystals

### Step 5: Try More Worlds (2 minutes)

```powershell
# Clear scene
Invoke-RestMethod -Uri "http://localhost:8765/newScene" -Method POST

# Try different biomes
New-World -biome "Medieval"    # Castle and houses
New-World -biome "SciFi"       # Futuristic city
New-World -biome "Underwater"  # Coral reef
```

✅ **Checkpoint:** You've generated multiple complete worlds

---

## 🎯 What Just Happened?

You just:
1. **Generated complete worlds** with terrain, environment, props, and lighting
2. **Created 50-100+ objects** in 2-10 seconds each
3. **Used AI-powered generation** that understands natural language
4. **Experienced 60x performance optimization** with automatic mesh combining

---

## 🌍 Next Steps

### Experiment with Parameters

```powershell
# Make it bigger
New-World -biome "Forest" -worldSize 200

# Make it denser
New-World -biome "City" -density 80

# Make it reproducible
New-World -biome "Medieval" -seed "MyKingdom"

# Combine parameters
New-World -biome "SciFi" -worldSize 150 -density 70 -seed "Alpha01"
```

### Try All 10 Biomes

Run the demo script to see all biomes:

```powershell
.\demo-world-generation.ps1
```

This generates 3 different worlds (Fantasy, Medieval, SciFi).

### Learn Natural Language Commands

```powershell
.\ai-world-generation-examples.ps1
```

See how AI interprets phrases like:
- "Create a magical fantasy world"
- "Build a large medieval kingdom"
- "Generate a futuristic sci-fi city"

---

## 📖 Understanding Biomes

### Quick Biome Overview

| When You Want... | Use Biome |
|------------------|-----------|
| Nature, exploration | **Forest** |
| Survival, harsh | **Desert** |
| Urban, modern | **City** |
| Castles, RPG | **Medieval** |
| Futuristic, tech | **SciFi** |
| Magic, mystical | **Fantasy** |
| Ocean, aquatic | **Underwater** |
| Snow, frozen | **Arctic** |
| Dense nature | **Jungle** |
| Post-apocalyptic | **Wasteland** |

---

## ⚙️ Parameter Guide

### worldSize (Default: 100)

**What it does:** Sets the world dimensions in Unity units

```powershell
New-World -biome "Forest" -worldSize 50    # Small (50x50)
New-World -biome "Forest" -worldSize 100   # Medium (100x100)
New-World -biome "Forest" -worldSize 200   # Large (200x200)
```

**Guidelines:**
- 50-75: Mobile games, small arenas
- 100-150: Standard PC game levels
- 200-300: Open world sections
- 400-500: Stress testing (may be slow)

### density (Default: 50)

**What it does:** Controls how many objects are placed (0-100)

```powershell
New-World -biome "City" -density 30    # Sparse
New-World -biome "City" -density 50    # Normal
New-World -biome "City" -density 80    # Dense
```

**Guidelines:**
- 0-30: Minimalist, performance-focused
- 40-60: Balanced gameplay
- 70-90: Rich, detailed
- 90-100: Cinematic, stress test

### seed (Optional)

**What it does:** Makes worlds reproducible

```powershell
# These create DIFFERENT worlds
New-World -biome "Forest"
New-World -biome "Forest"

# These create IDENTICAL worlds
New-World -biome "Forest" -seed "MyForest"
New-World -biome "Forest" -seed "MyForest"
```

**Use when:**
- Testing specific layouts
- Sharing worlds with team
- Creating procedural campaigns

---

## 🎮 Use Cases

### Rapid Prototyping

```powershell
# Test 3 different medieval layouts
New-World -biome "Medieval" -seed "Layout1"
# Review in Unity
New-World -biome "Medieval" -seed "Layout2"
# Review in Unity
New-World -biome "Medieval" -seed "Layout3"
# Pick your favorite
```

### Level Design Pipeline

```powershell
# 1. Generate base world
New-World -biome "SciFi" -worldSize 150 -density 60

# 2. Query and modify specific objects
$buildings = Find-Objects -query "Building"

# 3. Apply custom materials
Apply-Material -name "Building_0_0" -materialName "Glass_Clear"
Apply-Material -name "Building_1_1" -materialName "Metal_Gold"
```

### Game Testing

```powershell
# Test different biomes for your game
$biomes = @("Forest", "Desert", "Arctic")
foreach ($biome in $biomes) {
    Write-Host "Testing $biome biome..."
    New-World -biome $biome
    # Test your character controller here
    Start-Sleep -Seconds 30
    Invoke-RestMethod -Uri "http://localhost:8765/newScene" -Method POST
}
```

---

## 💡 Pro Tips

### Tip 1: Start Small
Always generate a small test world first:
```powershell
New-World -biome "City" -worldSize 50 -density 30
```

### Tip 2: Use Seeds for Iteration
Lock in a good world layout:
```powershell
New-World -biome "Medieval" -seed "GoodLayout1"
```

### Tip 3: Combine with Manual Edits
Generate base, then customize:
```powershell
New-World -biome "Fantasy" -density 40  # Base world
# Then manually add special features
```

### Tip 4: Profile Performance
Check Unity Profiler after generation to see optimization:
- Window → Analysis → Profiler
- Look for draw call reduction
- Verify mesh combining worked

### Tip 5: Save Good Worlds
```powershell
New-World -biome "SciFi" -seed "Alpha01"
# In Unity: File → Save Scene As → "SciFi_Alpha01.unity"
```

---

## 🐛 Common Issues

### Issue: "Cannot connect to Unity"

**Problem:** Server not running  
**Solution:**
1. Check Unity console for server start message
2. Restart Unity if needed
3. Run `Test-UnityConnection` again

### Issue: World is empty

**Problem:** Density too low  
**Solution:**
```powershell
New-World -biome "Forest" -density 70  # Increase density
```

### Issue: Generation is slow

**Problem:** World too large/dense  
**Solution:**
```powershell
New-World -biome "City" -worldSize 80 -density 50  # Reduce parameters
```

### Issue: Worlds look identical

**Problem:** Using same seed  
**Solution:** Don't specify seed, or use different seeds:
```powershell
New-World -biome "Forest" -seed "World1"
New-World -biome "Forest" -seed "World2"
```

### Issue: Poor performance in Unity

**Problem:** Optimization disabled  
**Solution:**
```powershell
New-World -biome "SciFi" -optimizeMeshes $true  # Enable optimization
```

---

## 📚 Learning Path

### Beginner (Day 1)
1. ✅ Generate your first world
2. ✅ Try all 10 biomes
3. ✅ Experiment with worldSize and density
4. ✅ Run demo scripts

### Intermediate (Week 1)
1. Use seeds for reproducibility
2. Combine world generation with material system
3. Query and modify generated objects
4. Integrate into game projects

### Advanced (Month 1)
1. Create custom generation scripts
2. Integrate with game logic
3. Build level generation pipelines
4. Optimize for target platforms

---

## 🎯 Success Checklist

- [ ] Unity MCP server running
- [ ] Connection test passes
- [ ] Generated first world successfully
- [ ] Tried at least 3 different biomes
- [ ] Experimented with parameters
- [ ] Ran demo script
- [ ] Understand seed usage
- [ ] Can generate reproducible worlds
- [ ] Verified optimization works
- [ ] Ready to integrate into project

---

## 🚀 You're Ready!

You now know how to:
- ✅ Generate complete worlds in seconds
- ✅ Use all 10 biome types
- ✅ Adjust size and density
- ✅ Create reproducible worlds
- ✅ Optimize for performance

**Next:** Check out the full guides:
- `WORLD_GENERATION_GUIDE.md` - Complete reference
- `WORLD_GEN_QUICK_REF.md` - Quick reference card
- `V2_DOCUMENTATION.md` - Full system documentation

---

**Start building worlds!** 🌍✨
