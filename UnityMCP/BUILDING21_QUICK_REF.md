# Building 21 (B21) - Quick Reference Card

## 🚀 One-Line Deploy
```powershell
cd UnityMCP && .\Building21.ps1
```

---

## 📊 At a Glance

| Metric | Value |
|--------|-------|
| **Total Objects** | ~850+ |
| **Total Floors** | 8 levels (B3 to Roof) |
| **Building Size** | 120m × 100m × 35m |
| **Build Time** | 25-40 seconds |
| **Draw Calls** | 850+ (15+ optimized) |

---

## 🏗️ Floor Layout

```
Roof (22.5m)    🚁 Helipad + HVAC + Antennas
─────────────────────────────────────────────
Floor 5 (20m)   👔 Executive Offices
Floor 4 (16m)   📊 Offices + Conference
Floor 3 (11m)   🔬 Research Labs
Floor 2 (7m)    🔬 Research Labs
─────────────────────────────────────────────
Ground (0m)     🚪 Lobby + Security + Offices
─────────────────────────────────────────────
B1 (-4m)        🔒 Security + Labs + Medical
B2 (-8m)        💾 Server Rooms (12 racks)
B3 (-11m)       📦 Storage + Vault + Mechanical
```

---

## 🎯 Key Rooms

### Underground
- **B3 Vault** - Secure storage (0, -11, -35)
- **B2 Server Room 1** - 12 racks (-30, -7.5, 0)
- **B1 Security** - Checkpoint (0, -4, 0)

### Ground Floor
- **Main Lobby** - Reception (0, 2.25, 35)
- **Cafeteria** - Break room (-35, 2.25, 10)

### Upper Floors
- **Labs** - Floors 2-3 (varies)
- **Conference** - Floors 4-5 (0, varies, -30)

### Rooftop
- **Helipad** - 20m diameter (0, 22.8, 20)

---

## 📸 Camera Presets

| View | Position | Rotation | Purpose |
|------|----------|----------|---------|
| **Overview** | (0, 50, -150) | (20, 0, 0) | Full building |
| **Entrance** | (0, 5, 80) | (5, 180, 0) | Main facade |
| **Rooftop** | (0, 42, 0) | (60, 0, 0) | Helipad view |
| **Servers** | (-30, -7.5, 0) | (0, 90, 0) | B2 interior |
| **Aerial** | (150, 30, 0) | (15, -90, 0) | Side profile |

---

## 🎨 Color Codes

```powershell
Concrete:        @{ r = 0.35; g = 0.35; b = 0.38 }
Metal:           @{ r = 0.4; g = 0.4; b = 0.45 }
Windows:         @{ r = 0.2; g = 0.3; b = 0.4 }
Emergency Light: @{ r = 1.0; g = 0.2; b = 0.0; intensity = 1.5 }
Server Light:    @{ r = 0.0; g = 0.6; b = 1.0; intensity = 2.0 }
```

---

## ⚡ Quick Optimizations

```powershell
# Optimize by floor (recommended)
Optimize-Group -parentName "B21_GroundFloor"
Optimize-Group -parentName "B21_Floor2"
Optimize-Group -parentName "B21_Underground"

# Optimize entire building (aggressive)
Optimize-Group -parentName "Building21_Main"
# Result: 500+ draw calls → ~10 draw calls
```

---

## 🔧 Quick Customizations

### Change Building Colors
```powershell
# Edit line ~80 in Building21.ps1
concreteColor = @{ r = 0.4; g = 0.4; b = 0.4 }  # Lighter
```

### Add More Floors
```powershell
# Edit line ~650 in Building21.ps1
for ($floor = 2; $floor -le 7; $floor++) {  # Was 5
```

### Adjust Room Sizes
```powershell
New-Room -name "BigRoom" -x 0 -y 2.25 -z 0 `
    -width 40 -depth 30 -height 5 -parent "B21_GroundFloor"
```

---

## 🎮 Strategic Points

### Entry Points
- Main Entrance (South)
- Rooftop Helipad (Top)
- Underground Access (B1)

### Vertical Paths
- **4 Elevators** at (±10, varies, 0) and (±10, varies, -10)
- **Main Stairwell** at (45, varies, 35)

### Objectives
- B3 Vault
- B2 Server Rooms
- B1 Research Labs
- Rooftop Communications

---

## 📦 Object Breakdown

| Section | Count | % |
|---------|-------|---|
| Exterior | 150 | 18% |
| Underground | 130 | 15% |
| Ground | 70 | 8% |
| Upper Floors | 120 | 14% |
| Rooftop | 50 | 6% |
| Furniture | 100 | 12% |
| Lab Equipment | 30 | 4% |
| Security | 25 | 3% |
| Signage | 20 | 2% |
| Parking & Landscape | 100 | 12% |
| Effects | 15 | 2% |
| Details | 40 | 5% |

---

## 🔍 Finding Objects

```powershell
# Get all B2 server racks
$racks = Find-Objects -query "B2_ServerRack"

# Get all windows
$windows = Find-Objects -query "Window"

# Get objects near helipad
$near = Find-Objects -radius 25 -position @{ x = 0; y = 22; z = 20 }
```

---

## ⚠️ Troubleshooting

| Problem | Solution |
|---------|----------|
| Server not connected | Check Unity MCP server on port 8765 |
| Too slow | Run `Optimize-Group` commands |
| Materials missing | Verify `unity-helpers-v2.ps1` loaded |
| Objects disappearing | Check Unity console for errors |

---

## 📚 Full Documentation

- **Building21.ps1** - Main script (1000+ lines)
- **BUILDING21_GUIDE.md** - Complete guide (11KB)
- **unity-helpers-v2.ps1** - Helper functions
- **V2_DOCUMENTATION.md** - API reference

---

## 🌟 New Enhanced Features

### Interior Furnishings
- **Desks & Chairs**: 40+ complete workstations
- **Computers**: Glowing blue screens in offices
- **Lab Equipment**: Microscopes, centrifuges, terminals
- **Doors**: 4 types (Standard, Security, Lab, Vault)

### Security & Wayfinding
- **Cameras**: 20+ surveillance cameras
- **Signage**: Illuminated directional signs
- **LED Indicators**: Red lights on all cameras

### Exterior Enhancements
- **Parking Lot**: 18 marked spaces
- **Trees**: 12 perimeter trees with foliage
- **Landscaping**: Grass patches and shrubs

### Environmental Effects
- **Steam Vents**: HVAC steam effects
- **Ambient Glow**: Server room atmosphere
- **Particle Effects**: Environmental realism

---

## 🎯 Best Practices

1. **Build in stages** - Run script, then optimize sections
2. **Test cameras** - Use preset positions to verify structure
3. **Customize gradually** - Small changes, test often
4. **Optimize late** - After all changes are complete
5. **Save often** - Unity scene saves after major sections

---

## 💡 Pro Tips

- Use `Write-Host` for progress tracking
- Group related objects for easier optimization
- Test with different lighting conditions
- Add custom rooms using `New-Room` function
- Emissive materials create great atmosphere

---

## 🏆 Achievement: B21 Complete

You've deployed one of the most complex Unity AI Scene Builder structures!

**Stats:**
- ✅ 8 levels of vertical gameplay
- ✅ 500+ carefully placed objects
- ✅ Realistic military facility design
- ✅ Optimized for performance
- ✅ Ready for game deployment

---

**Need help?** Check `BUILDING21_GUIDE.md` for detailed information!

**Want more?** Combine with other scripts:
```powershell
.\Building21.ps1
.\create-parkour-course.ps1  # Add parkour around building
.\generate-realistic-forest.ps1  # Add surrounding forest
```
