# Space Rock Platforms - Quick Reference

**Three elemental battle arenas for aerial combat**

---

## ⚡ Quick Start

```powershell
cd UnityMCP
.\create-space-rock-platforms.ps1
```

**Build Time:** ~10-15 seconds | **Objects:** 264 | **Ready:** Immediately

---

## 🎮 The Three Platforms

### 1. Normal Skull Tower Platform
- **Position:** (-80, 50, 0)
- **Theme:** Classic gray asteroid
- **Gem:** Purple (0.7, 0.3, 0.9)
- **Features:** 8 skulls with glowing red eyes
- **Diameter:** 40 units

### 2. Fire Type Platform
- **Position:** (0, 50, 0) - CENTER
- **Theme:** Volcanic inferno
- **Gem:** Fiery red (1.0, 0.25, 0.1)
- **Features:** 12 lava veins, 4 flame pillars
- **Diameter:** 42 units (largest)
- **Tower Height:** 28 units (tallest)

### 3. Ice Type Platform
- **Position:** (80, 50, 0)
- **Theme:** Frozen wasteland
- **Gem:** Cyan ice (0.3, 0.85, 1.0)
- **Features:** 16 ice crystals, 12 mist particles, 4 stalactites
- **Diameter:** 40 units

---

## 🎯 Object Counts

| Platform | Base | Tower | Decorations | Total |
|----------|------|-------|-------------|-------|
| Normal   | 27   | 25    | 16          | 68    |
| Fire     | 27   | 25    | 28          | 80    |
| Ice      | 27   | 25    | 44          | 96    |
| **Total** | - | - | +20 stars | **264** |

---

## 🏗️ Structure

```
SpaceRockPlatforms
├── NormalPlatform (Gray + Purple)
│   ├── Normal_Base (comet structure)
│   ├── Normal_Tower (evil tower)
│   └── Skull decorations (8 skulls)
│
├── FirePlatform (Red + Orange)
│   ├── Fire_Base (volcanic structure)
│   ├── Fire_Tower (tallest)
│   └── Lava effects (veins + pillars)
│
├── IcePlatform (Blue + White)
│   ├── Ice_Base (frozen structure)
│   ├── Ice_Tower (icy)
│   └── Ice effects (crystals + mist)
│
└── SpaceEnvironment (20 stars)
```

---

## 🎨 Key Materials

| Element | Metallic | Smoothness | Emission |
|---------|----------|------------|----------|
| Rock Base | 0.2 | 0.3 | - |
| Battle Platform | 0.3 | 0.4 | - |
| Tower | 0.5 | 0.6 | - |
| **Gems** | **0.95** | **0.98** | **5.0** |
| Crystals | 0.8 | 0.9 | 2.0 |
| Lava Veins | 0.8 | 0.9 | 3.5 |
| Flames | 0.9 | 0.95 | 4.5 |

---

## 🎮 Gameplay Dimensions

```
Platform Diameter: 40-42 units
Battle Surface: Y = 66-67
Tower Height: 25-28 units
Gem Height: 70-74 units
Platform Spacing: 80 units apart
```

---

## 🛠️ Helper Functions

### Build-CometBase
Creates irregular asteroid with 27+ objects
```powershell
Build-CometBase -name "Custom" `
    -centerX 0 -centerY 50 -centerZ 0 `
    -size 40 `
    -primaryColor @{r=0.5; g=0.5; b=0.5} `
    -accentColor @{r=1.0; g=0.5; b=0.0} `
    -parent "MyGroup"
```

### Build-EvilTower
Creates tower with gem (25+ objects)
```powershell
Build-EvilTower -name "Custom" `
    -x 0 -y 66 -z 0 `
    -height 25 `
    -towerColor @{r=0.3; g=0.3; b=0.3} `
    -gemColor @{r=1.0; g=0.0; b=1.0} `
    -parent "MyGroup"
```

---

## ⚙️ Optimization

```powershell
# Optimize each platform (60x performance boost)
Optimize-Group -parentName "NormalPlatform"
Optimize-Group -parentName "FirePlatform"
Optimize-Group -parentName "IcePlatform"

# Result: 68 objects → 1-2 meshes per platform
```

---

## 🎨 Color Palettes

### Normal (Classic)
- **Rock:** (0.45, 0.45, 0.48) Gray
- **Accent:** (0.6, 0.5, 0.65) Purple tint
- **Tower:** (0.35, 0.32, 0.38) Dark gray
- **Gem:** (0.7, 0.3, 0.9) Purple

### Fire (Volcanic)
- **Rock:** (0.55, 0.18, 0.12) Dark red
- **Accent:** (1.0, 0.3, 0.1) Orange
- **Tower:** (0.3, 0.08, 0.05) Charred black
- **Gem:** (1.0, 0.25, 0.1) Fiery red

### Ice (Frozen)
- **Rock:** (0.75, 0.85, 0.95) Ice blue
- **Accent:** (0.4, 0.8, 1.0) Cyan
- **Tower:** (0.5, 0.6, 0.75) Icy gray
- **Gem:** (0.3, 0.85, 1.0) Bright cyan

---

## 🎯 Usage Examples

### Basic Creation
```powershell
# Run the script
.\create-space-rock-platforms.ps1

# Platforms appear at:
# Normal: (-80, 50, 0)
# Fire: (0, 50, 0)
# Ice: (80, 50, 0)
```

### Custom Position
```powershell
# Edit script lines to change positions:
# Line ~280: Normal centerX/Y/Z
# Line ~340: Fire centerX/Y/Z  
# Line ~420: Ice centerX/Y/Z
```

### Add Fourth Platform
```powershell
# At end of script, before completion:

New-Group -name "LightningPlatform" -parent "SpaceRockPlatforms"

Build-CometBase -name "Lightning" `
    -centerX 0 -centerY 50 -centerZ -80 `
    -size 40 `
    -primaryColor @{r=0.3; g=0.3; b=0.4} `
    -accentColor @{r=1.0; g=1.0; b=0.3} `
    -parent "LightningPlatform"

Build-EvilTower -name "Lightning" `
    -x 0 -y 66 -z -80 `
    -height 25 `
    -towerColor @{r=0.2; g=0.2; b=0.3} `
    -gemColor @{r=1.0; g=1.0; b=0.2} `
    -parent "LightningPlatform"
```

---

## 📊 Performance Stats

| Metric | Value |
|--------|-------|
| Total Objects | 264 |
| Estimated Vertices | ~50,000 |
| Draw Calls (before) | ~250 |
| Draw Calls (after optimize) | ~10-15 |
| Build Time | 10-15 seconds |
| Memory | Minimal |

---

## 🎮 Gameplay Features

### Platform Design
- ✅ Large movement area (40-42 units)
- ✅ Flat battle surface
- ✅ Clear sight lines to gem
- ✅ Edge decorations for cover
- ✅ Height variation for vertical gameplay

### Tower Destruction
1. **Base Phase** - Attack foundation
2. **Segment Phase** - Destroy sections (5)
3. **Spike Phase** - Clear defenses (4)
4. **Gem Phase** - Claim the prize!

### Enemy Integration
- Skulls fly around perimeter
- Use debris as cover
- Attack from multiple angles
- Converge on gem

---

## 🔧 Common Customizations

### Change Gem Emission
```powershell
# Find "Set-Material" calls for gems:
Set-Material -name "Normal_GEM_DIAMOND" `
    -emission @{ r = 0.7; g = 0.3; b = 0.9; intensity = 5.0 }
    # Change intensity: 5.0 → 10.0 for brighter
```

### Change Platform Size
```powershell
# Edit Build-CometBase size parameter:
-size 40    # Increase to 60 for larger platform
```

### Add More Decorations
```powershell
# After tower creation, add custom objects:
Build-ColoredObject -name "Custom_Prop" -type "Cube" `
    -x -80 -y 68 -z 10 `
    -sx 3 -sy 3 -sz 3 `
    -color @{r=1.0; g=0.5; b=0.0} `
    -parent "NormalPlatform"
```

---

## 🌟 Visual Identity

### Normal Platform
- **Mood:** Mysterious, balanced
- **Visual:** Dark gray with purple accents
- **Threat:** Moderate
- **Signature:** Skull decorations

### Fire Platform
- **Mood:** Aggressive, dangerous
- **Visual:** Red/orange lava effects
- **Threat:** High
- **Signature:** Flame pillars

### Ice Platform
- **Mood:** Beautiful, challenging
- **Visual:** Blue/white crystals
- **Threat:** Deceptive
- **Signature:** Frozen mist

---

## 📚 See Also

- **SPACE_ROCK_PLATFORMS_GUIDE.md** - Complete guide
- **V2_QUICK_REFERENCE.md** - Helper library
- **create-scifi-capital.ps1** - Similar complexity
- **create-parkour-course.ps1** - Platform design

---

## 🏆 Key Features

✅ **Quality Over Quantity** - Every object has purpose  
✅ **Thematic Consistency** - Clear visual identity  
✅ **Gameplay Focus** - Movement and combat optimized  
✅ **Reusable Functions** - Modular architecture  
✅ **Production Ready** - Proper hierarchy and materials  

---

**The Gem of the Project. Where Legends Are Made.** 🚀
