# 🏰 Luxury Multi-Story Villa - Complete Guide

## Overview

An **extremely detailed 3-story Mediterranean villa** created using the Unity AI Scene Builder MCP system. This masterpiece showcases ALL available methods and demonstrates advanced architectural construction techniques.

---

## 🎯 Quick Start

```powershell
cd UnityMCP
.\build-luxury-villa.ps1
```

**Time:** ~2-3 minutes  
**Objects:** 400+ individual components  
**Rooms:** 8+ fully furnished spaces

---

## 🏛️ Villa Architecture

### Ground Floor (Floor 1)
**Height:** 0m - 7m  
**Features:**
- ✅ Grand entrance with twin columns and decorative arch
- ✅ Grand foyer with chandelier lighting
- ✅ Living room (left wing) with complete furniture set
- ✅ Dining room (right wing) with table and chairs
- ✅ Kitchen (back left) with counter and island
- ✅ 6 large windows with frames and glass panes
- ✅ Marble-like floor with realistic smoothness

**Room Count:** 4 rooms

### First Floor (Floor 2)
**Height:** 7m - 14m  
**Features:**
- ✅ Bedroom 1 (front left) with bed and furnishings
- ✅ Bedroom 2 (front right) with bed and furnishings
- ✅ Master bedroom (back center) with king bed and nightstands
- ✅ Front balcony with metal railings
- ✅ Side balcony with decorative metalwork
- ✅ 6 windows with cross dividers
- ✅ Polished wood-style flooring

**Room Count:** 3 bedrooms

### Second Floor (Roof Terrace)
**Height:** 14m - 20m  
**Features:**
- ✅ Open roof terrace (15m × 15m)
- ✅ Steel railings around perimeter
- ✅ Central penthouse suite (8m × 10m)
- ✅ Sloped Mediterranean-style roof (terra cotta)
- ✅ Decorative chimney with cap
- ✅ Panoramic views

**Room Count:** 1 penthouse

---

## 🛠️ Technical Specifications

### Object Breakdown
| Category | Count | Description |
|----------|-------|-------------|
| **Structural** | 100+ | Walls, floors, ceilings, foundation |
| **Windows** | 48+ | Frames, glass panes, dividers (4 parts each × 12) |
| **Doors** | 9+ | Frames, panels, handles (3 parts each × 3) |
| **Columns** | 6+ | Bases, shafts, capitals (3 parts each × 2) |
| **Balconies** | 20+ | Floors, railings, posts |
| **Furniture** | 50+ | Beds, tables, chairs, counters |
| **Lighting** | 24+ | Chandeliers, lamps, emissive elements |
| **Stairs** | 24 | Two staircases (12 steps each) |
| **Gardens** | 60+ | Trees, fountain, paths, hedges, planters |
| **Details** | 60+ | Cornices, pilasters, shutters |
| **TOTAL** | **400+** | Complete villa with all details |

### Material Palette
- **Walls:** Custom cream/beige (r=0.95, g=0.90, b=0.85)
- **Floors:** Polished stone (smoothness 0.5-0.6)
- **Windows:** Glass_Clear library material
- **Wood:** Wood_Oak library material
- **Metals:** Metal_Gold, Metal_Bronze, Metal_Steel
- **Roof:** Terra cotta red (r=0.7, g=0.3, b=0.2)
- **Gardens:** Natural greens and browns
- **Lights:** Warm white emission (r=1.0, g=0.9, b=0.7, intensity 2.0-3.0)

---

## 📐 Dimensions

### Overall Villa
- **Width:** 22m (including foundation)
- **Depth:** 22m (including foundation)
- **Height:** 20m (to chimney top)
- **Foundation:** 22m × 22m × 1m
- **Plot Size:** ~30m × 50m (including gardens)

### Room Sizes
- **Foyer:** 10m × 6m
- **Living Room:** 8m × 8m
- **Dining Room:** 8m × 8m
- **Kitchen:** 6m × 6m
- **Bedrooms:** 6m × 8m (standard), 8m × 8m (master)
- **Penthouse:** 8m × 10m
- **Balconies:** 8m × 2m (front), 8m × 2m (side)

---

## 🎨 Custom Functions Created

### `Build-Window`
Creates complete window assembly with:
- Outer frame (cream colored)
- Glass pane (transparent)
- Cross dividers (dark wood)
- Proper layering and depth

**Parameters:** name, x, y, z, ry (rotation), parent

### `Build-Door`
Creates complete door assembly with:
- Door frame (cream colored)
- Door panel (oak wood material)
- Handle (gold metal)

**Parameters:** name, x, y, z, ry (rotation), parent

### `Build-Column`
Creates classical column with:
- Decorative base (wider)
- Cylindrical shaft (smooth)
- Capital top (wider)

**Parameters:** name, x, y, z, height, radius, parent

### `Build-Balcony`
Creates balcony structure with:
- Floor platform
- 8 metal railings
- Top rail

**Parameters:** name, x, y, z, width, depth, ry, parent

### `Build-Chandelier`
Creates lighting fixture with:
- Ceiling mount
- Central sphere (emissive)
- 6 surrounding light bulbs (emissive)

**Parameters:** name, x, y, z, parent

### `Build-Stairs`
Creates staircase with:
- Configurable number of steps
- Proper rise and run ratios
- Stone/concrete material

**Parameters:** name, x, y, z, steps, ry, parent

### `Build-Furniture-Set`
Creates complete furniture group:
- Table with 4 legs
- 4 chairs with seats and backs
- All properly positioned

**Parameters:** roomName, x, y, z, parent

---

## 🌳 Garden Features

### Front Garden
- **Path:** 10 stone pavers leading to entrance
- **Trees:** 6 cypress-style trees (trunk + foliage)
- **Fountain:** 3-tier decorative fountain with water effect
- **Lighting:** 4 lamp posts with emissive globes
- **Hedges:** 8 decorative hedge sections
- **Planters:** 2 entrance planters with plants

### Total Garden Objects: 60+

---

## 🎭 Architectural Details

### Decorative Elements
- **Cornices:** 20+ trim pieces along roof line
- **Pilasters:** 8 decorative columns at corners (2 levels × 4 corners)
- **Shutters:** 12 window shutters (6 windows × 2 shutters)
- **Arch:** Grand entrance arch above main door
- **Railings:** 32+ balcony rail posts

### Lighting Effects
- **Chandeliers:** 3 (foyer, living room, dining room)
- **Lamp Posts:** 4 in garden
- **Fountain Light:** 1 central water feature
- **Total Emissive Objects:** 30+ with HDR emission

---

## 📊 Performance Metrics

### Rendering Stats (Estimated)
- **Draw Calls:** 400+ (before optimization)
- **Vertices:** ~80,000 (all primitives)
- **Materials:** ~30 unique materials
- **Memory:** ~15MB (textures + meshes)

### Optimization Potential
Run `Optimize-Group` on these groups:
- **Foundation:** 5 objects → 1 mesh
- **GF-Walls:** 20+ objects → 2-3 meshes
- **FF-Walls:** 10+ objects → 2 meshes
- **Details:** 60+ objects → 5-10 meshes

**Expected Draw Call Reduction:** 400+ → 30-50

---

## 📸 Recommended Camera Angles

### 1. Hero Shot (Front View)
```
Position: (0, 12, -35)
Rotation: (15, 0, 0)
```
Shows entire villa front with gardens and fountain.

### 2. Bird's Eye View
```
Position: (0, 40, 0)
Rotation: (90, 0, 0)
```
Top-down view showing roof terrace and layout.

### 3. Ground Level Approach
```
Position: (0, 2, -40)
Rotation: (0, 0, 0)
```
Human eye level approaching entrance.

### 4. Side Elevation
```
Position: (30, 15, 0)
Rotation: (20, -90, 0)
```
Shows depth and balconies.

### 5. Interior Foyer
```
Position: (0, 3, -5)
Rotation: (10, 0, 0)
```
Looking up at chandelier in entrance.

### 6. Rooftop Terrace
```
Position: (0, 15, 0)
Rotation: (0, 0, 0)
```
Standing on terrace with city views.

### 7. Garden View
```
Position: (0, 3, -30)
Rotation: (5, 0, 0)
```
Fountain and trees with villa backdrop.

---

## 🎓 Learning from This Villa

### Unity MCP Techniques Demonstrated

#### 1. Hierarchical Organization
```
LuxuryVilla
├── Foundation
├── GroundFloor
│   ├── GF-Walls
│   ├── GF-Columns
│   └── GF-Rooms
│       ├── GF-Foyer
│       ├── GF-LivingRoom
│       ├── GF-DiningRoom
│       └── GF-Kitchen
├── FirstFloor
│   ├── FF-Walls
│   ├── FF-Rooms
│   └── FF-Balconies
├── SecondFloor
│   ├── SF-Terrace
│   └── SF-Penthouse
├── Staircases
├── Gardens
│   ├── Garden-Front
│   ├── Garden-Features
│   └── Garden-Fountain
└── Details
```

**Why This Matters:** 
- Easy to find objects in Unity hierarchy
- Can hide/show entire sections
- Can optimize groups independently
- Professional organization

#### 2. Reusable Component Functions
Instead of copying 48+ window creation blocks, we have:
```powershell
function Build-Window { ... }
Build-Window -name "GF-Window-L1" -x -10.3 -y 4 -z -5 -ry 90
```

**Benefits:**
- Consistent quality across all instances
- Easy to modify all windows at once
- Reduces script length by 80%
- Industry best practice

#### 3. Material System Mastery
```powershell
# Custom PBR material
Set-Material -name "Object" `
    -color @{r=0.95; g=0.90; b=0.85} `
    -metallic 0.0 -smoothness 0.4

# Library material
Apply-Material -name "Object" -materialName "Wood_Oak"

# Emissive (glowing)
Set-Material -name "Light" `
    -emission @{r=1.0; g=0.9; b=0.7; intensity=2.5}
```

**Material Types Used:**
- Architectural surfaces (walls, floors)
- Natural materials (wood, stone)
- Transparent materials (glass)
- Metallic materials (railings, handles)
- Emissive materials (lights)

#### 4. Spatial Calculations
Window placement across walls:
```powershell
for ($i = 0; $i -lt 5; $i++) {
    $wallX = -10 + ($i * 5)  # Evenly spaced
    Build-ColoredObject -name "Wall-$i" -x $wallX ...
}
```

Circular arrangements (chandelier bulbs):
```powershell
for ($i = 0; $i -lt 6; $i++) {
    $angle = ($i * 60) * [Math]::PI / 180
    $x = [Math]::Cos($angle) * 1.2
    $z = [Math]::Sin($angle) * 1.2
    ...
}
```

#### 5. Progress Tracking
```powershell
$global:objectCount = 0
$global:roomCount = 0

# After each section:
$global:objectCount++

# At end:
Write-Host "Total Objects: $global:objectCount"
```

---

## 🔧 Customization Guide

### Changing Villa Size
Modify these scale factors at the top:
```powershell
$foundationScale = 22  # Default: 22m × 22m
$floorHeight = 6       # Default: 6m per floor
$roomWidth = 8         # Default: 8m rooms
```

### Changing Materials
Replace material calls:
```powershell
# Change all walls to brick:
Set-Material -name "...-Wall-..." `
    -color @{r=0.7; g=0.3; b=0.2} -metallic 0.0 -smoothness 0.3

# Or use library:
Apply-Material -name "...-Wall-..." -materialName "Brick_Red"
```

### Adding More Rooms
Copy room creation blocks and adjust positions:
```powershell
New-Group -name "GF-Library" -parent "GF-Rooms"
Build-Furniture-Set -roomName "GF-Library" -x 8 -y 1.1 -z 8
$global:roomCount++
```

### Changing Lighting
Adjust emission intensity:
```powershell
Set-Material -name "Light" `
    -emission @{r=1.0; g=0.9; b=0.7; intensity=5.0}  # Brighter
```

---

## 🐛 Troubleshooting

### "Cannot connect to Unity!"
1. Ensure Unity is running
2. Check Unity MCP server is started (Tools → Unity MCP → Start Server)
3. Verify port 8765 is not blocked
4. Run: `Test-UnityConnection` from PowerShell

### Objects appearing in wrong positions
- Check that Unity scene units match script (1 unit = 1 meter)
- Verify camera position and scale
- Check for previous objects with same names

### Script runs slowly
- This is normal! 400+ objects take time
- Each object = 1 API call + material call
- Typical runtime: 2-3 minutes
- Can optimize after with `Optimize-Group`

### Missing helper functions
Ensure you've imported the helper library:
```powershell
. "$PSScriptRoot\unity-helpers-v2.ps1"
```

---

## 🎯 Next Steps

### Optimization
```powershell
Optimize-Group -parentName "Foundation"
Optimize-Group -parentName "GF-Walls"
Optimize-Group -parentName "FF-Walls"
Optimize-Group -parentName "Details"
```

### Add More Features
- Swimming pool in back garden
- Garage with cars
- Interior wall art and decorations
- Rooftop solar panels
- Garden pergola or gazebo

### Export for Use
1. Select "LuxuryVilla" in hierarchy
2. Right-click → Export Package
3. Save as `LuxuryVilla.unitypackage`
4. Import into any project

---

## 📚 Related Documentation

- **Main Guide:** `V2_DOCUMENTATION.md` - Complete API reference
- **Quick Reference:** `V2_QUICK_REFERENCE.md` - Command cheat sheet
- **World Generation:** `ULTIMATE_WORLD_SUMMARY.md` - Larger worlds
- **Helper Library:** `unity-helpers-v2.ps1` - Function definitions

---

## 🏆 Achievement Unlocked

You've created a **professional-grade 3D architectural model** using:
- ✅ 400+ objects
- ✅ 8+ rooms across 3 floors
- ✅ Custom reusable functions
- ✅ PBR materials
- ✅ Emissive lighting
- ✅ Hierarchical organization
- ✅ Detailed landscaping
- ✅ Architectural detailing

**This demonstrates MASTERY of the Unity AI Scene Builder system!** 🎉

---

## 💬 Feedback & Improvements

Want to enhance this villa? Consider:
1. Adding interior doors between rooms
2. Creating a pool and deck area
3. Adding garage with vehicles
4. Creating multiple villa variants
5. Adding animated elements (flags, fountains)
6. Creating night-time lighting scenario

---

**Built with Unity AI Scene Builder MCP v2.0**  
*Text to 3D World Creation System*

**"From imagination to architecture in minutes."** ✨
