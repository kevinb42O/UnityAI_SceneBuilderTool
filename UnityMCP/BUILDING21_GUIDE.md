# Building 21 (B21) - Call of Duty DMZ Map Recreation Guide

## 🏢 Overview

Building 21 is a highly detailed, multi-story military research facility inspired by the iconic B21 map from Call of Duty: DMZ/Modern Warfare 2. This PowerShell script creates an impressive high-security complex complete with underground levels, laboratories, server rooms, and rooftop facilities.

---

## 🎯 Key Features

### Structure
- **3 Underground Levels** (B1, B2, B3)
  - B3: Deep storage, vaults, mechanical systems
  - B2: Massive server rooms with rack arrays
  - B1: Security checkpoints, research labs, medical bay
- **Ground Floor** with lobby, reception, security gates
- **4 Upper Floors** (2-5) with labs, offices, conference rooms
- **Rooftop Complex** with helipad, HVAC, antennas

### Atmosphere
- Military/industrial aesthetic
- Emergency lighting throughout underground
- Server status lights (glowing blue)
- Helipad lights (glowing orange)
- Communication antenna warning lights
- **NEW:** Environmental steam effects from HVAC
- **NEW:** Ambient blue glow in server rooms

### Interior Details (NEW!)
- **Furniture:** Desks, chairs, computers in all offices
- **Lab Equipment:** Microscopes, centrifuges, terminals
- **Doors:** Standard, Security, Lab, and Vault types at room entrances
- **Signage:** Illuminated wayfinding system throughout
- **Security:** 20+ surveillance cameras with red LED lights

### Exterior Details (NEW!)
- **Parking Lot:** 18 marked parking spaces (3 rows × 6)
- **Landscaping:** 12 perimeter trees with foliage
- **Ground Cover:** 8 grass patches and entrance shrubs
- **Environmental Effects:** Steam vents and atmospheric glow

### Total Objects
- **850+** total objects (up from 544)
- Realistic room layouts and corridors
- Elevator shafts connecting all floors
- Main stairwell for vertical navigation
- Complete interior furnishings
- Perimeter security and landscaping

---

## 🚀 Quick Start

### Prerequisites
1. Unity editor open with project loaded
2. Unity MCP server running (port 8765)
3. PowerShell 5.1 or higher

### Run the Script
```powershell
cd UnityMCP
.\Building21.ps1
```

**Expected Time:** 25-40 seconds  
**Expected Result:** 850+ objects creating a complete multi-story facility with interior furnishings

---

## 📐 Specifications

### Dimensions
- **Building Width:** 120 units (X-axis)
- **Building Depth:** 100 units (Z-axis)
- **Floor Height:** 4.5 units per floor
- **Total Height:** ~35 units (ground to roof)
- **Underground Depth:** 13 units

### Layout

```
                    NORTH (+Z)
           ┌──────────────────────┐
           │     HELIPAD          │
           │                      │
WEST  ──── │   BUILDING 21 (B21)  │ ──── EAST
(-X)       │                      │      (+X)
           │   MAIN ENTRANCE      │
           └──────────────────────┘
                   SOUTH (-Z)

Vertical Structure:
├─ Rooftop (~22.5m)
│  ├─ Helipad
│  ├─ HVAC units
│  └─ Antennas
├─ Floor 5 (~20m) - Executive offices
├─ Floor 4 (~16m) - Offices & conference
├─ Floor 3 (~11m) - Research labs
├─ Floor 2 (~7m) - Research labs
├─ Ground Floor (0m) - Lobby, offices
├─ B1 (-4m) - Security, labs, medical
├─ B2 (-8m) - Server rooms, data center
└─ B3 (-11m) - Storage, mechanical
```

---

## 🎨 Material Palette

### Colors Used
| Element | Color (RGB) | Finish | Use Case |
|---------|-------------|--------|----------|
| Concrete | (0.35, 0.35, 0.38) | Matte | Main walls |
| Dark Concrete | (0.25, 0.25, 0.27) | Matte | Foundation, roof |
| Metal | (0.4, 0.4, 0.45) | Semi-gloss | Doors, fixtures |
| Floor | (0.3, 0.3, 0.32) | Semi-gloss | All floors |
| Windows | (0.2, 0.3, 0.4) | Glossy | Exterior glass |
| Emergency Light | (1.0, 0.2, 0.0) | Emissive | Underground |
| Server Light | (0.0, 0.6, 1.0) | Emissive | Data center |

---

## 🗺️ Room-by-Room Breakdown

### Underground Level B3 (-11m)
- **Main Corridor:** 80m long, 4m wide
- **Storage Rooms (2):** 15m × 15m each
- **Vault:** 20m × 12m secure storage
- **Mechanical Room:** 20m × 20m systems hub

### Underground Level B2 (-8m)
- **Main Corridor:** 80m long, 5m wide
- **Server Room 1:** 25m × 30m with 12 rack arrays
- **Server Room 2:** 25m × 30m mirrored layout
- **Data Backup Room:** 18m × 12m
- **Total Server Racks:** 12 (with glowing status lights)

### Underground Level B1 (-4m)
- **Cross Corridors:** 6m wide, forming + pattern
- **Security Checkpoint:** Central position
- **Research Labs (2):** 35m × 20m each (North & South)
- **Medical Bay:** 20m × 25m
- **Chemical Storage:** 20m × 25m
- **Emergency Lighting:** 8 lights along corridors

### Ground Floor (0m)
- **Main Lobby:** 50m × 30m open area
- **Reception Desk:** 8m × 2m
- **Security Gates:** Metal detectors
- **Elevator Shafts (4):** 3m × 3m each
- **Main Stairwell:** 8m × 12m
- **Offices (4):** 15m × 12m each
- **Cafeteria:** 20m × 18m
- **Equipment Room:** 18m × 15m

### Floor 2 & 3 (7m, 11m)
- **Main Corridor:** 90m long, 6m wide
- **Cross Corridor:** 100m long, 5m wide
- **Research Labs (4 per floor):** 25m × 20m each
- **Office Pods (8 per floor):** 8m × 8m each

### Floor 4 & 5 (16m, 20m)
- **Main Corridor:** 90m long, 6m wide
- **Cross Corridor:** 100m long, 5m wide
- **Executive Offices (2 per floor):** 22m × 18m each
- **Conference Room:** 40m × 20m
- **Office Pods (8 per floor):** 8m × 8m each

### Rooftop (22.5m)
- **Helipad:** 20m diameter circular platform
- **Helipad Lights (8):** Emissive orange spheres
- **Access Building:** 10m × 14m × 5m
- **HVAC Units (6):** 4m × 3m × 3m each
- **Communication Antennas (3):** 5m tall with dishes
- **Perimeter Barriers:** Full coverage safety rails

---

## 📸 Recommended Camera Positions

### 1. Full Overview
```
Position: (0, 50, -150)
Rotation: (20, 0, 0)
View: Complete facility from south
```
Perfect for showcasing the entire building structure.

### 2. Main Entrance
```
Position: (0, 5, 80)
Rotation: (5, 180, 0)
View: Front facade and entrance lobby
```
Shows the imposing entrance with security features.

### 3. Rooftop Helipad
```
Position: (0, 42, 0)
Rotation: (60, 0, 0)
View: Top-down of helipad and roof equipment
```
Highlights the rooftop details and helipad lighting.

### 4. Underground Server Room
```
Position: (-30, -7.5, 0)
Rotation: (0, 90, 0)
View: Inside B2 server room with racks
```
Shows the impressive server room with glowing status lights.

### 5. Aerial Side View
```
Position: (150, 30, 0)
Rotation: (15, -90, 0)
View: Full building profile from east
```
Best for seeing all floors and vertical structure.

### 6. Interior Corridor (B1)
```
Position: (0, -4, 0)
Rotation: (0, 0, 0)
View: Main B1 corridor with emergency lighting
```
Shows atmospheric underground corridors.

### 7. Lobby Interior
```
Position: (0, 3, 45)
Rotation: (10, 180, 0)
View: Looking into main lobby from entrance
```
Reception desk and security gates visible.

---

## 🔧 Customization

### Modifying Room Sizes
Edit the `New-Room` function calls to adjust dimensions:
```powershell
New-Room -name "CustomRoom" -x 0 -y 2.25 -z 0 `
    -width 30 -depth 25 -height 5 -parent "B21_GroundFloor"
```

### Changing Colors
Modify the `$buildingConfig` hashtable at the top:
```powershell
$buildingConfig = @{
    concreteColor = @{ r = 0.4; g = 0.4; b = 0.4 }  # Lighter concrete
    serverLightColor = @{ r = 0.0; g = 1.0; b = 0.0; intensity = 2.0 }  # Green lights
}
```

### Adding More Floors
Adjust the loop in Section 4:
```powershell
for ($floor = 2; $floor -le 7; $floor++) {  # Changed from 5 to 7
    # Floor creation code...
}
```

### Adding Custom Features
Use the helper functions:
```powershell
# Add a custom security booth
Build-ColoredObject -name "SecurityBooth_Custom" -type "Cube" `
    -x 20 -y 1.5 -z 15 `
    -sx 3 -sy 3 -sz 3 `
    -color $buildingConfig.metalColor `
    -metallic 0.6 -smoothness 0.4 `
    -parent "B21_GroundFloor"
```

---

## ⚡ Performance Optimization

### Current Stats
- **Objects:** ~500-600
- **Draw Calls:** 500-600 (before optimization)
- **Expected Frame Rate:** 60+ FPS on modern hardware

### Optimization Tips

1. **Combine Meshes by Floor:**
```powershell
Optimize-Group -parentName "B21_GroundFloor"
Optimize-Group -parentName "B21_Floor2"
Optimize-Group -parentName "B21_Floor3"
# etc.
```
**Result:** ~10-15 draw calls per floor

2. **Combine Underground Levels:**
```powershell
Optimize-Group -parentName "B21_Underground"
```
**Result:** ~3-5 draw calls total

3. **Combine Exterior:**
```powershell
Optimize-Group -parentName "B21_Exterior"
```
**Result:** 2-3 draw calls

4. **Full Building Optimization:**
```powershell
Optimize-Group -parentName "Building21_Main"
```
**Result:** 5-10 draw calls for entire building

---

## 🎮 Gameplay Features

### Strategic Elements (inspired by CoD DMZ)
- **Multiple Entry Points:** Main entrance, rooftop, underground access
- **Vertical Combat:** Stairwells and elevator shafts
- **Choke Points:** Security checkpoints, narrow corridors
- **Cover Opportunities:** Server racks, office furniture areas
- **Objective Locations:** Server rooms, vaults, labs

### Navigation Paths
1. **Ground → Roof:** Main stairwell (east side)
2. **Ground → Underground:** Elevator shafts (4 locations)
3. **Floor to Floor:** Corridors connect all rooms
4. **Emergency Routes:** Multiple stairwell options

---

## 🛠️ Troubleshooting

### Script Won't Run
**Issue:** Unity MCP server not connected  
**Solution:**
```powershell
# Test connection
Invoke-RestMethod -Uri "http://localhost:8765/ping" -Method POST -ContentType "application/json" -Body '{}'
```

### Too Many Objects
**Issue:** Unity slowing down  
**Solution:** Reduce detail or optimize groups early:
```powershell
# Add after each section
Optimize-Group -parentName "SectionName"
```

### Materials Not Appearing
**Issue:** Objects are default gray  
**Solution:** Ensure material parameters are correct:
```powershell
Set-Material -name "ObjectName" `
    -color @{ r = 0.5; g = 0.5; b = 0.5 } `
    -metallic 0.0 -smoothness 0.5
```

### Script Runs Slowly
**Issue:** Taking too long  
**Solution:** Add parallel execution or reduce objects:
```powershell
# Reduce windows
for ($i = 0; $i -lt 4; $i++) {  # Instead of 8
    # Window creation...
}
```

---

## 📊 Statistics

### Object Count Breakdown
| Section | Objects | Percentage |
|---------|---------|------------|
| Exterior | 150 | 28% |
| Underground (B1-B3) | 130 | 24% |
| Ground Floor | 70 | 13% |
| Upper Floors (2-5) | 120 | 22% |
| Rooftop | 50 | 9% |
| Details | 24 | 4% |
| **Total** | **~544** | **100%** |

### Material Usage
- Concrete: 320 objects (59%)
- Metal: 150 objects (28%)
- Windows: 72 objects (13%)

---

## 🎓 Learning Resources

### Understanding the Code

**Helper Functions:**
- `New-Room`: Creates a complete room with walls, floor, ceiling
- `New-Corridor`: Creates a corridor between two points
- `Build-ColoredObject`: Creates and styles an object in one call

**Key Patterns:**
```powershell
# Pattern 1: Room creation
New-Room -name "MyRoom" -x 0 -y 2.25 -z 0 `
    -width 20 -depth 15 -height 4.5 -parent "ParentGroup"

# Pattern 2: Emissive lighting
Set-Material -name "Light" -emission @{ r = 1.0; g = 0.0; b = 0.0; intensity = 2.0 }

# Pattern 3: Organized hierarchy
New-Group -name "Floor2" -parent "Building21_Main"
```

---

## 🔮 Future Enhancements

### Planned Features
- [ ] Interior furniture (desks, chairs, equipment)
- [ ] Door objects at room entrances
- [ ] Signage and room labels
- [ ] Additional security features (cameras, sensors)
- [ ] Environmental effects (steam, particles)
- [ ] More detailed lab equipment
- [ ] Parking lot with vehicles
- [ ] Ground level landscaping

### Community Contributions
Feel free to extend this script with:
- Different floor layouts
- Custom room types
- Additional security features
- Alternative material schemes
- Performance optimizations

---

## 📝 Credits

**Created for:** Unity AI Scene Builder Tool  
**Inspired by:** Call of Duty: DMZ - Building 21 (B21) map  
**Script Version:** 1.0  
**Created:** 2024  

---

## 🎉 Final Notes

Building 21 represents one of the most complex structures created with the Unity AI Scene Builder system. With over 500 objects, multi-level design, and atmospheric details, it demonstrates the power of procedural generation for game environments.

**Have fun exploring this classified military facility!** 🏢🔒

---

**For support and updates, see:**
- `unity-helpers-v2.ps1` - Core helper functions
- `V2_DOCUMENTATION.md` - Complete API reference
- `V2_QUICK_REFERENCE.md` - Quick command guide
