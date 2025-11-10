# Point Cloud & Procedural Mesh - Quick Reference

**The 2-Minute Cheat Sheet**

---

## 🚀 Quick Commands

### Point Cloud Terrain
```powershell
# Rolling hills
New-PointCloudTerrain -name "Hills" -pointCount 10000 -noiseAmplitude 12

# Mountain range
New-PointCloudTerrain -name "Mountains" -pointCount 20000 -noiseAmplitude 40 -noiseScale 0.05

# Flat plains
New-PointCloudTerrain -name "Plains" -pointCount 8000 -noiseAmplitude 3
```

### Procedural Terrain (5 Noise Types)
```powershell
# Natural terrain (Perlin)
New-ProceduralTerrain -name "Valley" -noiseType "Perlin" -amplitude 15

# Sharp mountains (Ridged)
New-ProceduralTerrain -name "Alps" -noiseType "Ridged" -amplitude 25 -octaves 6

# Alien world (Voronoi)
New-ProceduralTerrain -name "Alien" -noiseType "Voronoi" -amplitude 10

# Soft hills (Billow)
New-ProceduralTerrain -name "Clouds" -noiseType "Billow" -amplitude 12

# Enhanced detail (Simplex)
New-ProceduralTerrain -name "Enhanced" -noiseType "Simplex" -amplitude 18 -octaves 5
```

### Buildings
```powershell
# Office building
New-BuildingFacade -name "Office" -floors 5 -windowsPerFloor 6

# Apartment with balconies
New-BuildingFacade -name "Apartment" -floors 8 -addBalconies $true

# Skyscraper
New-BuildingFacade -name "Tower" -floors 20 -windowsPerFloor 8

# City block (10 buildings)
New-ProceduralCityBlock -name "City" -buildingCount 10 -minFloors 5 -maxFloors 12
```

### Trees (L-Systems)
```powershell
# Oak tree
New-LSystemTree -name "Oak" -preset "tree" -iterations 4

# Pine tree
New-LSystemTree -name "Pine" -iterations 5 -angle 18

# Wide tree
New-LSystemTree -name "Wide" -iterations 4 -angle 35

# Forest (30 trees + terrain)
New-ProceduralForest -name "Forest" -treeCount 30 -areaSize 150
```

---

## 📊 Parameter Reference

### Point Cloud Terrain

| Parameter | Range | Default | Effect |
|-----------|-------|---------|--------|
| `pointCount` | 5k-50k | 10000 | More points = smoother |
| `areaSize` | 50-500 | 100 | Terrain size |
| `noiseAmplitude` | 1-100 | 10 | Max height |
| `noiseScale` | 0.01-0.5 | 0.1 | Feature size (smaller = bigger) |
| `gridResolution` | 20-100 | 50 | Mesh detail |

### Procedural Terrain

| Parameter | Range | Default | Effect |
|-----------|-------|---------|--------|
| `width/height` | 50-500 | 100 | Terrain size |
| `amplitude` | 5-100 | 10 | Max height |
| `octaves` | 1-8 | 4 | Detail layers |
| `persistence` | 0.3-0.7 | 0.5 | Roughness |
| `lacunarity` | 1.5-3.0 | 2.0 | Feature scaling |

### Buildings

| Parameter | Range | Default | Effect |
|-----------|-------|---------|--------|
| `floors` | 1-30 | 5 | Building height |
| `windowsPerFloor` | 1-10 | 4 | Window density |
| `floorHeight` | 2.5-4.0 | 3.0 | Floor spacing |
| `addBalconies` | bool | false | Add balconies |

### L-System Trees

| Parameter | Range | Default | Effect |
|-----------|-------|---------|--------|
| `iterations` | 2-6 | 4 | Complexity |
| `angle` | 15-45 | 25 | Branch spread |
| `segmentLength` | 0.5-3.0 | 1.0 | Branch length |

---

## 🎨 Noise Type Guide

| Type | Best For | Characteristics |
|------|----------|-----------------|
| **Perlin** | Natural terrain | Smooth, organic |
| **Simplex** | Enhanced terrain | Smoother than Perlin |
| **Voronoi** | Alien/cellular | Sharp boundaries |
| **Ridged** | Mountains | Sharp peaks, deep valleys |
| **Billow** | Clouds/soft | Rounded, fluffy |

---

## ⚡ Performance Tips

### Point Count
- **Small (50 units):** 5,000-10,000 points
- **Medium (100 units):** 10,000-20,000 points
- **Large (200+ units):** 20,000-50,000 points

### Grid Resolution
- **Low detail:** 20-30
- **Medium detail:** 40-60 (recommended)
- **High detail:** 70-100

### Optimization
```powershell
# After generating multiple objects
Optimize-Group -parentName "ParentName"
```

**Result:** 60× draw call reduction

---

## 🌍 Complete Scene Examples

### Fantasy World
```powershell
# Terrain with magical look
New-ProceduralTerrain -name "MagicLand" -noiseType "Voronoi" -amplitude 15

# Enchanted forest
New-ProceduralForest -name "EnchantedForest" -treeCount 40 -generateTerrain $false

# Castle area (manual placement)
New-BuildingFacade -name "Castle" -floors 12 -position @{x=0; y=0; z=0}
```

### Modern City
```powershell
# Flat city base
New-ProceduralTerrain -name "CityBase" -noiseType "Perlin" -amplitude 3

# Downtown
New-ProceduralCityBlock -name "Downtown" -buildingCount 15 -minFloors 10 -maxFloors 20

# Residential
New-ProceduralCityBlock -name "Residential" -buildingCount 20 -minFloors 4 -maxFloors 8 -addBalconies $true
```

### Mountain Wilderness
```powershell
# Dramatic mountains
New-ProceduralTerrain -name "Mountains" -noiseType "Ridged" -amplitude 50 -octaves 7

# Pine forest
for ($i = 0; $i -lt 30; $i++) {
    New-LSystemTree -name "Pine_$i" -iterations 5 -angle 18 -position @{x=(Get-Random -Min -80 -Max 80); y=0; z=(Get-Random -Min -80 -Max 80)}
}
```

---

## 🔧 MCP Tool Names

For AI agents using MCP:

```json
"unity_generate_point_cloud"
"unity_generate_procedural_terrain"
"unity_generate_building_facade"
"unity_generate_lsystem_tree"
```

---

## 📈 Complexity Comparison

| Feature | Primitives Only | Point Cloud/Procedural | Speedup |
|---------|----------------|------------------------|---------|
| Terrain | 50+ cubes, 30 min | 1 command, 10 sec | **180×** |
| Building | 20+ cubes, 15 min | 1 command, 2 sec | **450×** |
| Tree | 10+ cylinders, 10 min | 1 command, 1 sec | **600×** |
| Forest | Manual, 2 hours | 1 command, 30 sec | **240×** |

---

## 🎯 Common Use Cases

### Game Jam (48 hours)
```powershell
# 5 minutes for entire world
New-ProceduralForest -name "World" -treeCount 50 -areaSize 200
New-ProceduralCityBlock -name "Village" -buildingCount 8 -minFloors 2 -maxFloors 4
```

### Prototyping
```powershell
# Quick terrain test
New-PointCloudTerrain -name "Test" -pointCount 5000 -seed 123

# Iterate with different seeds
New-PointCloudTerrain -name "Test2" -pointCount 5000 -seed 456
```

### Production
```powershell
# High quality, reproducible
New-ProceduralTerrain -name "MainTerrain" -width 200 -height 200 -octaves 7 -seed 12345
New-ProceduralForest -name "MainForest" -treeCount 100 -seed 12345 -generateTerrain $false
```

---

## 🐛 Troubleshooting

### "Cannot connect to Unity"
```powershell
# Check server status
Test-UnityConnection

# Restart Unity MCP Server
# Unity Editor → Tools → Unity MCP → Start Server
```

### Terrain too flat/steep
```powershell
# Adjust amplitude
New-PointCloudTerrain -noiseAmplitude 5   # Flat
New-PointCloudTerrain -noiseAmplitude 50  # Steep
```

### Too many/few details
```powershell
# Adjust octaves
New-ProceduralTerrain -octaves 2  # Smooth
New-ProceduralTerrain -octaves 7  # Detailed
```

### Trees too simple/complex
```powershell
# Adjust iterations
New-LSystemTree -iterations 3  # Simple
New-LSystemTree -iterations 6  # Complex (slow)
```

---

## 💡 Pro Tips

1. **Use seeds for consistency**
   ```powershell
   -seed 12345  # Same result every time
   ```

2. **Start with defaults, then customize**
   ```powershell
   New-PointCloudTerrain -name "Test"  # Default
   # If good, customize
   ```

3. **Combine for optimization**
   ```powershell
   Optimize-Group -parentName "World"  # 60× faster
   ```

4. **Layer complexity**
   ```powershell
   # Base → Details → Optimization
   New-ProceduralTerrain ...
   New-ProceduralForest ...
   Optimize-Group ...
   ```

5. **Experiment with noise types**
   ```powershell
   # Each gives unique aesthetic
   -noiseType "Perlin"   # Natural
   -noiseType "Ridged"   # Dramatic
   -noiseType "Voronoi"  # Alien
   ```

---

**Full Documentation:** `POINT_CLOUD_PROCEDURAL_GUIDE.md`  
**Demo Script:** `demo-point-cloud-procedural.ps1`  
**Helper Functions:** `point-cloud-helpers.ps1`

---

**Build worlds at the speed of thought.** 🚀
