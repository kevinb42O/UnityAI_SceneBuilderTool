# 🛠️ Egyptian World Helper Tools - Complete Reference

**Advanced construction tools for building complex ancient structures**

---

## 📚 Overview

The `egyptian-world-helpers.ps1` library provides specialized functions for creating architectural elements commonly found in ancient civilizations. These tools complement the base Unity MCP helpers and enable rapid construction of complex structures.

---

## 🏛️ Architectural Elements

### Build-Archway

Creates a complete archway with pillars and curved/pointed/square top.

**Syntax:**
```powershell
Build-Archway -name <string> -x <float> -y <float> -z <float> `
    [-width <float>] [-height <float>] [-thickness <float>] `
    [-rotation <float>] [-archType <string>] [-color <hashtable>] `
    [-parent <string>]
```

**Parameters:**
- `name` (required) - Base name for archway objects
- `x, y, z` (required) - Position of archway center
- `width` - Opening width (default: 4)
- `height` - Opening height (default: 6)
- `thickness` - Depth of arch (default: 1)
- `rotation` - Y-axis rotation in degrees (default: 0)
- `archType` - "Square", "Rounded", or "Pointed" (default: "Rounded")
- `color` - Color hashtable (default: limestone color)
- `parent` - Parent group name

**Example:**
```powershell
# Egyptian temple entrance
Build-Archway -name "TempleGate" `
    -x 0 -y 0 -z 10 `
    -width 8 -height 12 `
    -archType "Rounded" `
    -color @{ r = 0.90; g = 0.85; b = 0.75 }

# Gothic style arch
Build-Archway -name "CathedralArch" `
    -x 20 -y 0 -z 0 `
    -width 6 -height 10 `
    -archType "Pointed"
```

**Objects Created:** 2-10 (depending on arch type)

**Use Cases:**
- Temple entrances
- Pyramid doorways
- Palace gates
- Decorative passages

---

### Build-Staircase

Creates a multi-step staircase in any cardinal direction.

**Syntax:**
```powershell
Build-Staircase -name <string> -x <float> -y <float> -z <float> `
    [-steps <int>] [-stepWidth <float>] [-stepDepth <float>] `
    [-stepHeight <float>] [-direction <string>] [-color <hashtable>] `
    [-parent <string>]
```

**Parameters:**
- `name` (required) - Base name for staircase objects
- `x, y, z` (required) - Starting position (bottom)
- `steps` - Number of steps (default: 10)
- `stepWidth` - Width of each step (default: 3)
- `stepDepth` - Depth of each step (default: 1)
- `stepHeight` - Height of each step (default: 0.5)
- `direction` - "North", "South", "East", or "West" (default: "North")
- `color` - Color hashtable (default: dark stone)
- `parent` - Parent group name

**Example:**
```powershell
# Pyramid entrance stairs
Build-Staircase -name "PyramidSteps" `
    -x 0 -y 0 -z 30 `
    -steps 20 -stepWidth 10 -stepHeight 0.5 `
    -direction "North"

# Temple stairs (wide and grand)
Build-Staircase -name "TempleStairs" `
    -x -50 -y 0 -z 0 `
    -steps 15 -stepWidth 20 -stepDepth 1.5 `
    -direction "East"
```

**Objects Created:** Equal to number of steps

**Use Cases:**
- Pyramid access
- Temple approaches
- Altar platforms
- Ziggurat levels

---

### Build-CircularWall

Creates circular arrangements of walls or pillars.

**Syntax:**
```powershell
Build-CircularWall -name <string> -x <float> -y <float> -z <float> `
    [-radius <float>] [-segments <int>] [-height <float>] `
    [-thickness <float>] [-wallType <string>] [-color <hashtable>] `
    [-parent <string>]
```

**Parameters:**
- `name` (required) - Base name for wall objects
- `x, y, z` (required) - Center position
- `radius` - Circle radius (default: 10)
- `segments` - Number of segments/pillars (default: 12)
- `height` - Wall/pillar height (default: 8)
- `thickness` - Wall thickness (default: 0.5)
- `wallType` - "Solid", "Pillars", or "Gaps" (default: "Pillars")
- `color` - Color hashtable (default: limestone)
- `parent` - Parent group name

**Example:**
```powershell
# Arena wall (solid)
Build-CircularWall -name "ArenaWall" `
    -x 0 -y 0 -z 0 `
    -radius 30 -segments 24 -height 10 `
    -wallType "Solid"

# Ritual circle (pillars only)
Build-CircularWall -name "RitualCircle" `
    -x 0 -y 0 -z 0 `
    -radius 40 -segments 16 -height 12 `
    -wallType "Pillars"

# Defensive wall (with gaps for archers)
Build-CircularWall -name "FortWall" `
    -x 0 -y 0 -z 0 `
    -radius 50 -segments 32 -height 15 `
    -wallType "Gaps"
```

**Objects Created:** Equal to number of segments

**Use Cases:**
- Combat arenas
- Ritual circles
- Defensive structures
- Coliseums
- Stone circles (Stonehenge-style)

---

### Build-Colonnade

Creates a row of columns with connecting roof structure.

**Syntax:**
```powershell
Build-Colonnade -name <string> -x1 <float> -z1 <float> `
    -x2 <float> -z2 <float> [-y <float>] [-columns <int>] `
    [-columnHeight <float>] [-columnRadius <float>] `
    [-roofThickness <float>] [-color <hashtable>] [-parent <string>]
```

**Parameters:**
- `name` (required) - Base name for colonnade objects
- `x1, z1` (required) - Start position
- `x2, z2` (required) - End position
- `y` - Ground level (default: 0)
- `columns` - Number of columns (default: 8)
- `columnHeight` - Height of columns (default: 10)
- `columnRadius` - Column thickness (default: 0.5)
- `roofThickness` - Roof thickness (default: 0.5)
- `color` - Color hashtable (default: limestone)
- `parent` - Parent group name

**Example:**
```powershell
# Temple front colonnade
Build-Colonnade -name "TempleFront" `
    -x1 -20 -z1 0 -x2 20 -z2 0 `
    -columns 10 -columnHeight 15

# Palace side colonnade
Build-Colonnade -name "PalaceHall" `
    -x1 0 -z1 -30 -x2 0 -z2 30 `
    -y 2 -columns 12 -columnHeight 12 `
    -columnRadius 0.7
```

**Objects Created:** (columns × 3) + 1 roof

**Use Cases:**
- Temple entrances
- Palace hallways
- Covered walkways
- Peristyle courtyards
- Greek/Roman colonnades

---

### Build-Brazier

Creates a standing brazier with emissive flame effect.

**Syntax:**
```powershell
Build-Brazier -name <string> -x <float> -y <float> -z <float> `
    [-height <float>] [-flameIntensity <float>] [-parent <string>]
```

**Parameters:**
- `name` (required) - Name for the brazier
- `x, y, z` (required) - Position
- `height` - Height of stand (default: 4)
- `flameIntensity` - Emission intensity (default: 2.0)
- `parent` - Parent group name

**Example:**
```powershell
# Entrance brazier
Build-Brazier -name "GateFire" `
    -x 10 -y 0 -z 5 `
    -height 5 -flameIntensity 3.0

# Small altar brazier
Build-Brazier -name "AltarFlame" `
    -x 0 -y 2 -z 0 `
    -height 2 -flameIntensity 2.5
```

**Objects Created:** 3 (stand, bowl, flame)

**Use Cases:**
- Entrance lighting
- Altar fires
- Perimeter lighting
- Ceremonial flames
- Ambient lighting

---

## 🏔️ Terrain Helpers

### Build-TerrainMound

Creates a rounded terrain mound or hill.

**Syntax:**
```powershell
Build-TerrainMound -name <string> -x <float> -y <float> -z <float> `
    [-width <float>] [-height <float>] [-depth <float>] `
    [-color <hashtable>] [-parent <string>]
```

**Parameters:**
- `name` (required) - Name for the mound
- `x, y, z` (required) - Base position
- `width` - Mound width (default: 20)
- `height` - Mound height (default: 8)
- `depth` - Mound depth (default: 20)
- `color` - Color hashtable (default: dark sand)
- `parent` - Parent group name

**Example:**
```powershell
# Sand dune
Build-TerrainMound -name "Dune1" `
    -x 50 -y 0 -z 50 `
    -width 30 -height 10 -depth 25 `
    -color @{ r = 0.87; g = 0.72; b = 0.53 }

# Hill
Build-TerrainMound -name "Hill" `
    -x -100 -y 0 -z 100 `
    -width 50 -height 15 -depth 50
```

**Objects Created:** 1

**Use Cases:**
- Sand dunes
- Hills
- Burial mounds
- Terrain variation

---

## 🔧 Utility Functions

### Copy-Object

Duplicates an existing Unity object at a new position.

**Syntax:**
```powershell
Copy-Object -sourceName <string> -newName <string> `
    [-offsetX <float>] [-offsetY <float>] [-offsetZ <float>]
```

**Parameters:**
- `sourceName` (required) - Name of object to copy
- `newName` (required) - Name for the new copy
- `offsetX, offsetY, offsetZ` - Position offset (default: 0, 0, 0)

**Example:**
```powershell
# Duplicate a pyramid
Copy-Object -sourceName "Pyramid1" -newName "Pyramid2" `
    -offsetX 100 -offsetZ 50

# Copy decoration
Copy-Object -sourceName "Statue1" -newName "Statue2" `
    -offsetX 20
```

**Objects Created:** All objects in source hierarchy

**Use Cases:**
- Repeating structures
- Symmetrical designs
- Pattern replication
- Quick duplication

---

## 📐 Common Patterns

### Temple Complex

```powershell
New-Group -name "Temple"

# Platform
Build-ColoredObject -name "Temple_Platform" -type "Cube" `
    -x 0 -y 1 -z 0 -sx 50 -sy 2 -sz 70 `
    -parent "Temple"

# Front colonnade
Build-Colonnade -name "Temple_Front" `
    -x1 -20 -z1 35 -x2 20 -z2 35 `
    -y 2 -columns 10 -parent "Temple"

# Entrance
Build-Archway -name "Temple_Gate" `
    -x 0 -y 2 -z 35 `
    -width 8 -height 12 -archType "Rounded" `
    -parent "Temple"

# Stairs
Build-Staircase -name "Temple_Stairs" `
    -x 0 -y 0 -z 40 `
    -steps 10 -stepWidth 12 -direction "South" `
    -parent "Temple"

# Braziers
Build-Brazier -name "Temple_Brazier_L" -x -10 -y 2 -z 40 -parent "Temple"
Build-Brazier -name "Temple_Brazier_R" -x 10 -y 2 -z 40 -parent "Temple"
```

### Ritual Arena

```powershell
New-Group -name "Arena"

# Inner circle (pillars)
Build-CircularWall -name "Arena_Inner" `
    -x 0 -y 0 -z 0 -radius 30 -segments 16 `
    -wallType "Pillars" -parent "Arena"

# Outer wall (solid with gaps)
Build-CircularWall -name "Arena_Outer" `
    -x 0 -y 0 -z 0 -radius 45 -segments 24 `
    -height 12 -wallType "Gaps" -parent "Arena"

# Entrance gates (4 cardinal directions)
Build-Archway -name "Arena_North" -x 0 -y 0 -z 45 -parent "Arena"
Build-Archway -name "Arena_South" -x 0 -y 0 -z -45 -rotation 180 -parent "Arena"
Build-Archway -name "Arena_East" -x 45 -y 0 -z 0 -rotation 270 -parent "Arena"
Build-Archway -name "Arena_West" -x -45 -y 0 -z 0 -rotation 90 -parent "Arena"
```

### Marketplace

```powershell
New-Group -name "Market"

# Create 8 stalls in 2 rows
for ($row = 0; $row -lt 2; $row++) {
    for ($col = 0; $col -lt 4; $col++) {
        $x = -15 + ($col * 10)
        $z = -5 + ($row * 10)
        
        # Stall posts
        foreach ($corner in @(-2, 2)) {
            foreach ($corner2 in @(-2, 2)) {
                Build-ColoredObject -name "Stall_${row}_${col}_Post" `
                    -type "Cylinder" `
                    -x ($x + $corner) -y 2 -z ($z + $corner2) `
                    -sx 0.2 -sy 2 -sz 0.2 `
                    -parent "Market"
            }
        }
        
        # Stall roof
        Build-ColoredObject -name "Stall_${row}_${col}_Roof" `
            -type "Cube" `
            -x $x -y 4 -z $z `
            -sx 5 -sy 0.2 -sz 5 `
            -parent "Market"
    }
}
```

---

## 🎯 Best Practices

### Performance
1. **Group objects:** Use parent groups for organization
2. **Optimize later:** Apply `Optimize-Group` after creation
3. **Limit segments:** More segments = more objects

### Design
1. **Consistent scale:** Match existing scene scale
2. **Color harmony:** Use color palette from main script
3. **Logical naming:** Use descriptive names with prefixes

### Workflow
1. **Test small:** Create one instance first
2. **Iterate:** Adjust parameters before mass creation
3. **Document:** Comment complex arrangements

---

## 📊 Performance Metrics

| Function | Objects/Call | Draw Calls | Optimization |
|----------|--------------|------------|--------------|
| Build-Archway | 2-10 | 2-10 | Combine meshes |
| Build-Staircase | 10-50 | 10-50 | Combine by direction |
| Build-CircularWall | 12-32 | 12-32 | Excellent for combining |
| Build-Colonnade | 25-50 | 25-50 | Combine columns |
| Build-Brazier | 3 | 3 | Keep separate (emissive) |

### Optimization Example
```powershell
# Before optimization: 300 objects, 300 draw calls
Build-CircularWall -name "Wall" -segments 100 -parent "Walls"

# After optimization: 100 objects, 1-2 draw calls
Optimize-Group -parentName "Walls"
```

---

## 🔗 Integration

### With Egyptian Pyramid World
```powershell
# Run main world first
.\create-egyptian-pyramid-world.ps1

# Then add enhancements
.\demo-egyptian-enhancements.ps1
```

### With Custom Scenes
```powershell
# Import helpers
. ".\egyptian-world-helpers.ps1"

# Use functions as needed
Build-Archway -name "MyGate" -x 0 -y 0 -z 0
```

---

## 📚 See Also

- **Main Script:** `create-egyptian-pyramid-world.ps1`
- **Base Helpers:** `unity-helpers-v2.ps1`
- **Demo Script:** `demo-egyptian-enhancements.ps1`
- **Guide:** `EGYPTIAN_PYRAMID_WORLD_GUIDE.md`

---

## 🎓 Learning Resources

### Tutorial 1: Build a Simple Temple
```powershell
New-Group -name "SimpleTemple"
Build-Colonnade -name "Front" -x1 -10 -z1 0 -x2 10 -z2 0 -parent "SimpleTemple"
Build-Archway -name "Gate" -x 0 -y 0 -z 0 -parent "SimpleTemple"
Build-Staircase -name "Steps" -x 0 -y 0 -z 5 -steps 5 -parent "SimpleTemple"
```

### Tutorial 2: Create an Arena
```powershell
New-Group -name "SimpleArena"
Build-CircularWall -name "Outer" -radius 20 -segments 16 -wallType "Solid" -parent "SimpleArena"
Build-CircularWall -name "Inner" -radius 15 -segments 12 -wallType "Pillars" -parent "SimpleArena"
```

---

**Version:** 1.0  
**Author:** Unity AI Scene Builder  
**Category:** Advanced Construction Tools
