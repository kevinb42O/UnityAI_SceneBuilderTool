# World Generation Feature

**Build complete worlds in seconds**

---

## 🌍 What Is This?

The **World Generation** feature allows you to create entire playable worlds with a single command. Each world includes:

- 🏞️ **Terrain** - Ground, hills, elevation
- 🏗️ **Environment** - Biome-specific structures (trees, buildings, etc.)
- 🎨 **Props** - Details and decorations
- 💡 **Lighting** - Biome-appropriate lighting setup
- ⚡ **Optimization** - Automatic 60x performance boost

---

## ⚡ Quick Example

```powershell
# Load helpers
. .\unity-helpers-v2.ps1

# Generate a fantasy world
New-World -biome "Fantasy"
```

**Result:** Complete fantasy world with magical trees and glowing crystals in 5 seconds.

---

## 🎨 10 Biomes Available

| Biome | Best For | Generation Time |
|-------|----------|-----------------|
| 🌲 **Forest** | Nature, exploration | 3-5s |
| 🏜️ **Desert** | Survival, harsh environments | 2-4s |
| 🏙️ **City** | Urban, modern | 5-8s |
| 🏰 **Medieval** | RPG, fantasy | 4-7s |
| 🚀 **SciFi** | Futuristic, tech | 4-8s |
| ✨ **Fantasy** | Magic, mystical | 5-9s |
| 🌊 **Underwater** | Ocean, aquatic | 3-6s |
| ❄️ **Arctic** | Frozen, survival | 3-5s |
| 🌴 **Jungle** | Dense, exploration | 6-10s |
| 💀 **Wasteland** | Post-apocalyptic | 3-6s |

---

## 📖 Documentation

### For Beginners
**[WORLD_GENERATION_GETTING_STARTED.md](WORLD_GENERATION_GETTING_STARTED.md)**
- 5-minute quick start
- Step-by-step setup
- First world generation
- Common issues

### For Reference
**[WORLD_GEN_QUICK_REF.md](WORLD_GEN_QUICK_REF.md)**
- One-page cheat sheet
- All commands
- Parameter guide
- Quick tips

### For Deep Dive
**[WORLD_GENERATION_GUIDE.md](WORLD_GENERATION_GUIDE.md)**
- Complete reference
- All biomes detailed
- Performance metrics
- Advanced usage
- Integration examples

---

## 🎮 Try It Now

### 1. Demo Script
See 3 different worlds generated:
```powershell
.\demo-world-generation.ps1
```

### 2. AI Examples
See natural language in action:
```powershell
.\ai-world-generation-examples.ps1
```

### 3. Your First World
```powershell
. .\unity-helpers-v2.ps1
New-World -biome "Fantasy"
```

---

## 🤖 AI Integration

Works with natural language:

**You say:** "Create a magical fantasy world"  
**AI generates:** Fantasy biome with default settings

**You say:** "Build a large medieval kingdom"  
**AI generates:** Medieval biome, large size, high density

**You say:** "Generate a futuristic sci-fi city"  
**AI generates:** SciFi biome with metallic structures

---

## ⚙️ All Parameters

```powershell
New-World `
    -biome "Medieval" `      # Biome type (required)
    -worldSize 150 `         # World size (default: 100)
    -density 70 `            # Object density 0-100 (default: 50)
    -includeTerrain $true `  # Generate terrain (default: true)
    -includeLighting $true ` # Setup lighting (default: true)
    -includeProps $true `    # Add props (default: true)
    -optimizeMeshes $true `  # Optimize performance (default: true)
    -seed "MyWorld"          # Reproducible seed (optional)
```

---

## 📊 What You Get

### Small World (density 50)
- **Objects:** 50-100
- **Time:** 3-6 seconds
- **Draw Calls:** 1-2 (after optimization)

### Medium World (density 50, size 150)
- **Objects:** 75-150
- **Time:** 5-8 seconds
- **Draw Calls:** 2-3 (after optimization)

### Large World (density 80, size 200)
- **Objects:** 120-200+
- **Time:** 8-12 seconds
- **Draw Calls:** 3-5 (after optimization)

---

## 🎯 Use Cases

### Rapid Prototyping
Generate 10 different worlds in 5 minutes to test layouts.

### Level Design
Create base world, then customize with materials and objects.

### Game Testing
Test character controllers in different environments quickly.

### AI-Powered Creation
Let AI understand your description and generate appropriate worlds.

---

## 💡 Pro Tips

1. **Start small** - Test with size 50, density 30
2. **Use seeds** - Lock in good layouts with reproducible seeds
3. **Profile performance** - Check Unity Profiler to verify optimization
4. **Layer generation** - Generate base world, then add custom elements
5. **AI integration** - Use natural language for intuitive creation

---

## 🔥 Why This Matters

**Before:** Hours to build a level by hand  
**After:** 2-10 seconds for complete world

**Before:** Manual placement of hundreds of objects  
**After:** Automatic procedural placement

**Before:** Complex scripting required  
**After:** One simple command or natural language

**Before:** Performance issues with many objects  
**After:** Automatic 60x optimization

---

## 📞 Get Help

- **Issues?** See troubleshooting in [WORLD_GENERATION_GUIDE.md](WORLD_GENERATION_GUIDE.md)
- **Questions?** Check [WORLD_GENERATION_GETTING_STARTED.md](WORLD_GENERATION_GETTING_STARTED.md)
- **Quick lookup?** Use [WORLD_GEN_QUICK_REF.md](WORLD_GEN_QUICK_REF.md)

---

## 🌟 Example Results

### Fantasy World
```powershell
New-World -biome "Fantasy" -density 60
```
**Creates:**
- Green grass terrain with hills
- 40+ glowing magic crystals
- 20+ magical purple trees
- Mystical purple lighting
- Optimized to 2-3 draw calls

### Medieval Village
```powershell
New-World -biome "Medieval" -worldSize 150 -density 70
```
**Creates:**
- Central castle with 4 towers
- 20+ village houses with roofs
- Stone and wood materials
- Neutral lighting
- Optimized to 2-3 draw calls

### Sci-Fi City
```powershell
New-World -biome "SciFi" -worldSize 200 -density 80
```
**Creates:**
- Metallic gray ground
- 40+ futuristic buildings
- 20+ glowing blue energy cores
- Cool blue-tinted lighting
- Optimized to 3-4 draw calls

---

## ✨ The Future of Unity Level Design

This is **text-to-world generation**. Speak your vision, see it built.

**Try it now:**
```powershell
New-World -biome "Fantasy"
```

---

**Build worlds with your words.** 🌍✨
