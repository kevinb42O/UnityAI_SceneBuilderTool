# Unity MCP v2.0 - Quick Reference

**Essential commands for rapid development**

---

## Setup (Do Once)

```powershell
# Import helpers
. "path\to\unity-helpers-v2.ps1"

# Test connection
Test-UnityConnection
```

---

## Materials

### Quick Color
```powershell
Build-ColoredObject -name "RedCube" -type "Cube" `
    -x 10 -y 5 -z 0 -colorName "Red"
```

### Library Material
```powershell
Apply-Material -name "MyWall" -materialName "Brick_Red"
```

### Custom PBR
```powershell
Set-Material -name "MyObject" `
    -color @{ r = 0.8; g = 0.4; b = 0.1 } `
    -metallic 0.9 -smoothness 0.8
```

### Emissive (Glowing)
```powershell
Set-Material -name "EnergyCore" `
    -emission @{ r = 0.0; g = 1.0; b = 1.0; intensity = 2.0 }
```

---

## Hierarchy

### Create Group
```powershell
New-Group -name "Building"
New-Group -name "Walls" -parent "Building"
```

### Parent Object
```powershell
Create-UnityObject -name "Wall_1" -parent "Walls"
# Or after creation:
Set-Parent -childName "Wall_1" -parentName "Walls"
```

### Optimize (Combine Meshes)
```powershell
Optimize-Group -parentName "StaticProps"
# 60 objects → 1 mesh = 60x performance boost
```

---

## Scene Queries

### Find by Name
```powershell
$walls = Find-Objects -query "Wall"
```

### Find Nearby
```powershell
$nearby = Find-Objects -radius 50 -position @{ x = 0; y = 0; z = 0 }
```

### Get All
```powershell
$all = Find-Objects
```

---

## Advanced

### Diagonal Connection
```powershell
Build-DiagonalObject -name "Cable" -type "Cylinder" `
    -x1 0 -y1 20 -z1 0 -x2 50 -y2 40 -z2 30 `
    -thickness 0.3
```

### Batch Operations
```powershell
# Apply material to all walls
$walls = Find-Objects -query "Wall"
foreach ($wall in $walls) {
    Apply-Material -name $wall.name -materialName "Brick_Red"
}
```

---

## Material Library

| Name | Look | Use |
|------|------|-----|
| `Wood_Oak` | Brown, rough | Structures |
| `Metal_Steel` | Gray, shiny | Industrial |
| `Metal_Gold` | Gold, mirror | Decorative |
| `Brick_Red` | Red, rough | Buildings |
| `Concrete` | Gray, matte | Foundations |
| `Glass_Clear` | Transparent | Windows |
| `Grass_Green` | Green, matte | Ground |
| `Emissive_Blue` | Glowing blue | Sci-fi |

**See all:** `Get-MaterialLibrary`

---

## Performance Tips

1. **Group related objects:**
   ```powershell
   New-Group -name "StaticProps"
   # Create 100+ objects in group
   Optimize-Group -parentName "StaticProps"
   ```

2. **Use library materials** (consistency + speed):
   ```powershell
   Apply-Material -name "Wall" -materialName "Brick_Red"
   ```

3. **Query before creating** (avoid duplicates):
   ```powershell
   $existing = Find-Objects -query "Door"
   if ($existing.Count -eq 0) { Create-UnityObject -name "Door" }
   ```

---

## Common Patterns

### Building with Hierarchy
```powershell
New-Group -name "House"
New-Group -name "Foundation" -parent "House"
New-Group -name "Walls" -parent "House"
New-Group -name "Roof" -parent "House"

# Create objects in each group...

Optimize-Group -parentName "House"
```

### Material Variation
```powershell
for ($i = 0; $i -lt 10; $i++) {
    Create-UnityObject -name "Brick_$i"
    Set-Transform -name "Brick_$i" -x ($i * 2) -y 1 -z 0
    
    # Vary smoothness for realism
    $smoothness = 0.1 + (Get-Random) * 0.1
    Set-Material -name "Brick_$i" `
        -color @{ r = 0.7; g = 0.2; b = 0.15 } `
        -smoothness $smoothness
}
```

### Context-Aware Placement
```powershell
# Find walls, add windows
$walls = Find-Objects -query "Wall"
foreach ($wall in $walls) {
    $pos = $wall.position
    Build-ColoredObject -name "Window_on_$($wall.name)" -type "Cube" `
        -x $pos.x -y ($pos.y + 2) -z $pos.z `
        -sx 2 -sy 2 -sz 0.2
    
    Apply-Material -name "Window_on_$($wall.name)" -materialName "Glass_Clear"
}
```

---

## Error Handling

```powershell
if (-not (Test-UnityConnection)) {
    Write-Host "Unity not connected!" -ForegroundColor Red
    exit 1
}

try {
    Build-ColoredObject -name "Test" -type "Cube"
}
catch {
    Write-Host "Failed: $_" -ForegroundColor Red
}
```

---

## Workflow Example

```powershell
# 1. Structure first (fast iteration)
New-Group -name "Level"
for ($i = 0; $i -lt 100; $i++) {
    Create-UnityObject -name "Object_$i" -parent "Level"
    Set-Transform -name "Object_$i" -x ($i * 2) -y 1 -z 0
}

# 2. Materials second (batch operations)
$objects = Find-Objects -query "Object"
foreach ($obj in $objects) {
    Apply-Material -name $obj.name -materialName "Concrete"
}

# 3. Optimize last (single mesh)
Optimize-Group -parentName "Level"
```

---

## PBR Values Guide

### Metallic
- **0.0** = Non-metal (wood, plastic, stone)
- **1.0** = Metal (steel, gold, aluminum)

### Smoothness
- **0.0-0.2** = Very rough (concrete, brick, bark)
- **0.3-0.5** = Medium (wood, leather, rubber)
- **0.6-0.8** = Smooth (plastic, paint, polished stone)
- **0.9-1.0** = Mirror (chrome, glass, water)

### Emission Intensity
- **0.5-1.0** = Subtle glow (UI, indicators)
- **1.0-2.0** = Noticeable glow (screens, lights)
- **2.0-5.0** = Strong glow (energy, magic)

---

## File Locations

- **Helper Library:** `unity-helpers-v2.ps1`
- **Documentation:** `V2_DOCUMENTATION.md`
- **Demo Script:** `demo-v2-features.ps1`
- **Unity Server:** `Assets/Editor/UnityMCPServer.cs`
- **MCP Server:** `index.js`

---

**Pro Tip:** Always optimize groups before final builds. The performance difference is massive (60x+).

**Remember:** Structure → Materials → Optimize. In that order.
