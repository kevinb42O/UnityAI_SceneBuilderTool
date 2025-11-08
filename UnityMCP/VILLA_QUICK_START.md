# 🏰 Luxury Villa - Quick Start Guide

## Run the Villa Builder

```powershell
cd UnityMCP
.\build-luxury-villa.ps1
```

**Time:** 2-3 minutes  
**Result:** 400+ object Mediterranean villa

---

## What You Get

### 🏠 Structure
- **Ground Floor:** Foyer, living room, dining room, kitchen
- **First Floor:** 3 bedrooms with beds and furniture
- **Second Floor:** Roof terrace with penthouse
- **Vertical:** 2 internal staircases connecting floors

### 🎨 Details
- 12 windows with frames and glass
- 3 doors with handles
- 2 columns at entrance
- 2 balconies with railings
- 3 chandeliers (emissive lighting)

### 🌳 Gardens
- 6 trees (trunk + foliage)
- 3-tier fountain with water effect
- 4 lamp posts with lights
- 10-piece stone walkway
- 8 decorative hedges
- 2 entrance planters

### ✨ Extras
- 20+ cornices (decorative trim)
- 8 pilasters (corner decorations)
- 12 window shutters
- 60+ architectural details
- Terra cotta roof with chimney

---

## Best Camera Views

### Front Hero Shot
```
Position: (0, 12, -35)
Rotation: (15, 0, 0)
```

### Bird's Eye
```
Position: (0, 40, 0)
Rotation: (90, 0, 0)
```

### Ground Level
```
Position: (0, 2, -40)
Rotation: (0, 0, 0)
```

---

## Key Features Showcased

✅ **Hierarchical Organization** - Professional scene structure  
✅ **Custom Functions** - Reusable components (windows, doors, etc.)  
✅ **PBR Materials** - Realistic surfaces with metallic/smoothness  
✅ **Material Library** - Glass, wood, metal from library  
✅ **Emissive Lighting** - HDR glowing lights and chandeliers  
✅ **Complex Geometry** - Multi-level architecture  
✅ **Landscaping** - Gardens, trees, decorative elements  
✅ **Architectural Details** - Trim, shutters, columns  

---

## Statistics

| Metric | Value |
|--------|-------|
| Total Objects | 400+ |
| Rooms | 8+ |
| Floors | 3 |
| Windows | 12 |
| Doors | 3 |
| Lights | 30+ |
| Garden Elements | 60+ |

---

## Optimization (Optional)

After building, combine meshes for better performance:

```powershell
Optimize-Group -parentName "Foundation"
Optimize-Group -parentName "GF-Walls"
Optimize-Group -parentName "FF-Walls"
Optimize-Group -parentName "Details"
```

**Result:** 400+ draw calls → 30-50 draw calls

---

## Customization Tips

### Change Wall Color
Find in script:
```powershell
Set-Material -name "GF-FrontWall-$i" `
    -color @{r=0.95; g=0.90; b=0.85}
```

### Add More Rooms
Copy room creation pattern:
```powershell
New-Group -name "GF-NewRoom" -parent "GF-Rooms"
Build-Furniture-Set -roomName "GF-NewRoom" -x X -y Y -z Z
```

### Change Lighting
Adjust emission intensity:
```powershell
-emission @{r=1.0; g=0.9; b=0.7; intensity=3.0}
```

---

## Troubleshooting

**Error: "Cannot connect to Unity!"**
1. Start Unity
2. Tools → Unity MCP → Start Server
3. Run script again

**Objects in wrong place?**
- Check Unity scene is at origin (0,0,0)
- Verify scale (1 unit = 1 meter)

**Script too slow?**
- Normal! 400+ objects = 2-3 minutes
- Each object needs API call + material setup

---

## Complete Documentation

For full details, see: `LUXURY_VILLA_GUIDE.md`

---

**Built with Unity AI Scene Builder MCP v2.0** ✨
