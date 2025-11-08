# Parkour Road System - Complete Guide

## Overview

The **Parkour Road System** is an advanced, organic course integrated into the Ultimate Complete World. It creates a challenging 3D platforming experience that connects all major world features through a carefully designed progression of platforms, roads, and aerial pathways.

---

## Course Statistics

| Metric | Value |
|--------|-------|
| **Total Platforms** | ~250 |
| **Course Length** | ~800 units |
| **Vertical Range** | 0m (ground) to 85m (tower summit) |
| **Checkpoints** | 20+ glowing markers |
| **Estimated Completion Time** | 3-5 minutes (skilled player) |
| **Difficulty Curve** | Progressive (easy → hard) |

---

## Course Sections

### 1. Ground Road Network (Entry Level)
**Objects:** 80 (60 road segments + 20 markers)  
**Difficulty:** ⭐ Easy  
**Location:** Castle center → 4 cardinal portals

**Features:**
- 4 curved organic roads extending from castle
- Roads to North, South, East, and West portals
- Sine-wave curves create natural, flowing paths
- Glowing cyan checkpoints every 50 units
- Road width: 8 units (comfortable running)

**Purpose:** Introduces players to the world layout and checkpoint system.

---

### 2. Castle Elevation (Beginner)
**Objects:** 10 (5 platforms + 5 markers)  
**Difficulty:** ⭐⭐ Easy-Medium  
**Location:** Castle roof → Tower Bridge

**Features:**
- 5 ascending platforms from castle keep roof
- Height progression: 42m → 56m
- Orange glowing edge markers for visibility
- Platform size: 5×5 units
- Gap distance: 4-6 units between platforms

**Purpose:** First vertical challenge, teaches jumping mechanics.

---

### 3. Bridge Traverse (Medium)
**Objects:** 4 platforms  
**Difficulty:** ⭐⭐ Medium  
**Location:** Tower Bridge → Crystal Cathedral

**Features:**
- 4 platforms ascending to cathedral level
- Height range: 58m → 70m
- Platforms positioned between bridge towers
- Requires precise timing and direction

**Purpose:** Mid-air navigation practice.

---

### 4. Aerial Island Routes (Advanced)
**Objects:** 36 (24 platforms + 12 checkpoints)  
**Difficulty:** ⭐⭐⭐ Hard  
**Location:** Cathedral → 3 Floating Islands

**Features:**
- 3 separate paths to 3 different islands
- 8 stepping stone platforms per path
- Dynamic height variation (sin-wave pattern)
- Checkpoint spheres every 2 platforms (orange glow)
- Platform rotation: randomized 0-360° for challenge
- Platform size: 5×5 units

**Island Heights:**
- Island 0 (Northeast): 80m
- Island 1 (Northwest): 90m
- Island 2 (Southeast): 85m

**Purpose:** Major skill check - precise aerial movement required.

---

### 5. Floating Island Trees (Exploration)
**Objects:** 28 (14 trees with trunks + canopies)  
**Difficulty:** N/A (Scenic)  
**Location:** On each floating island

**Features:**
- 4-5 trees per island (randomized)
- Tree heights: 8-12 units
- Canopy size: 6 units diameter
- Organic placement around island perimeter
- Color: Brown trunks, green canopies

**Purpose:** Visual enhancement, provides landing spots and atmosphere.

---

### 6. Inter-Island Bridges (Expert)
**Objects:** 20 platforms  
**Difficulty:** ⭐⭐⭐⭐ Very Hard  
**Location:** Between floating islands

**Features:**
- **Bridge 0→1:** 10 platforms (horizontal at z=150)
- **Bridge 0→2:** 10 platforms (horizontal at x=150)
- Gentle sine-wave undulation (±3m vertical)
- Platform size: 4×4 units (smaller = harder)
- No safety rails or markers (expert navigation)

**Purpose:** Optional challenge route, connects all islands.

---

### 7. Island-to-Tower Descent (Expert)
**Objects:** 24 platforms  
**Difficulty:** ⭐⭐⭐⭐ Very Hard  
**Location:** Floating Islands → Sci-Fi Towers

**Features:**
- 2 routes (Island 0 → East Tower, Island 1 → West Tower)
- 12 platforms per route
- **Phase 1 (first 6):** Descending straight path
- **Phase 2 (last 6):** Spiral around tower (30° increments)
- Height drop: 80m → 20m
- Spiral radius: 15 units from tower center

**Purpose:** Controlled descent with increasing complexity.

---

### 8. Tower Spiral Ascent (Master)
**Objects:** 16 platforms  
**Difficulty:** ⭐⭐⭐⭐⭐ Master  
**Location:** Around Sci-Fi Towers (East & West)

**Features:**
- 8 platforms per tower
- Circular arrangement (45° increments)
- Height progression: 15m → 63m (6m per level)
- Platform size: 5×3 units (rectangular)
- Facing: Platforms face tangent to tower
- Final platform connects to tower summit

**Purpose:** Final challenge before finish line.

---

### 9. Start & Finish Markers (Landmarks)
**Objects:** 4 (2 platforms + 2 beacons)  
**Difficulty:** N/A  
**Location:** Castle courtyard (start), East Tower summit (finish)

**START MARKER:**
- Location: (0, 6, 0) - Castle center
- Platform: 12-unit diameter cylinder (green)
- Beacon: 40-unit tall glowing green pillar
- Emission: Bright green (intensity 4.0)

**FINISH MARKER:**
- Location: (200, 72, 0) - East Tower summit
- Platform: 10-unit diameter cylinder (golden)
- Beacon: 30-unit tall glowing orange pillar
- Emission: Bright orange (intensity 5.0)

---

### 10. Directional Guides (Navigation)
**Objects:** 5 arrow markers  
**Difficulty:** N/A (Assistance)  
**Location:** Key path junctions

**Positions:**
1. Castle North Exit (0, 8, 40) → Points to bridge
2. Bridge Approach (0, 8, 80) → Points to cathedral
3. Cathedral Base (0, 8, 110) → Points up
4. Cathedral Exit (50, 8, 130) → Points to Island 0
5. Near Island 0 (100, 8, 140) → Points to island

**Features:**
- Yellow glowing arrows (3×5 units)
- Rotated to point toward next objective
- Emission: Yellow (intensity 2.0)

---

## Design Philosophy

### Organic Integration
- **No straight lines:** All paths use curves, sine waves, or spirals
- **Natural flow:** Course follows world architecture logically
- **Height variety:** Constant elevation changes keep movement dynamic

### Progressive Difficulty
1. **Ground (Easy):** Learn controls, explore world
2. **Elevated (Medium):** Basic jumping and platforming
3. **Aerial (Hard):** Precision jumping, air control
4. **Spiral (Expert):** Complex 3D navigation
5. **Bridges (Master):** Minimal safety, maximum challenge

### Visual Feedback System
- **Green:** Start point (you are here)
- **Cyan:** Ground checkpoints (progress markers)
- **Orange:** Platform markers (jump here)
- **Yellow:** Directional guides (go this way)
- **Golden:** Finish line (goal)

### Preserved World Content
- **Zero modifications** to original 320+ objects
- Parkour system in separate "ParcoursSystem" group
- Easy to disable/enable via Unity hierarchy
- All platforms use non-colliding default materials

---

## Technical Implementation

### Platform Types

| Type | Primitive | Typical Size | Use Case |
|------|-----------|--------------|----------|
| Road Segment | Cube | 8×0.2×variable | Ground paths |
| Standard Platform | Cube | 5×0.5×5 | General platforming |
| Small Platform | Cube | 4×0.4×4 | Challenge jumps |
| Spiral Platform | Cube | 5×0.5×3 | Tower ascent |
| Checkpoint | Cylinder | 1×2.5×1 | Progress markers |
| Guide Arrow | Cube | 3×0.3×5 | Navigation |

### Material Specifications

**Road Material:**
- Color: RGB(0.35, 0.32, 0.3) - Dark gray
- Metallic: 0.1
- Smoothness: 0.3
- Purpose: Non-reflective, realistic road

**Platform Material:**
- Color: RGB(0.25, 0.25, 0.28) - Industrial gray
- Metallic: 0.7
- Smoothness: 0.6
- Purpose: Sci-fi aesthetic matching towers

**Checkpoint Material:**
- Color: RGB(0.2, 0.8, 1.0) - Cyan
- Metallic: 0.5
- Smoothness: 0.9
- Emission: Cyan (intensity 3.0)
- Purpose: High visibility

**Marker Material:**
- Color: RGB(1.0, 0.6, 0.2) - Orange
- Metallic: 0.3
- Smoothness: 0.9
- Emission: Orange (intensity 2.5)
- Purpose: Edge definition

---

## Route Optimization Strategies

### Speed Run Route (Estimated 2:30)
1. Start → Skip ground roads
2. Castle walls (jump to 3rd platform)
3. Bridge → Cathedral (skip 2 platforms)
4. Direct jump to Island 0 (skip stepping stones)
5. Island 0 → East Tower (straight line, ignore spiral)
6. Tower spiral (skip even-numbered platforms)
7. Finish

### Scenic Route (Estimated 5:00)
1. Explore all 4 ground roads to portals
2. Visit each checkpoint
3. Castle → Bridge → Cathedral (all platforms)
4. Visit all 3 islands via stepping stones
5. Explore island trees
6. Cross inter-island bridges
7. Descend both tower spirals
8. Finish

### Challenge Route (Estimated 8:00)
1. Complete all ground roads
2. No checkpoint skipping
3. Touch all 3 islands
4. Complete both inter-island bridges
5. Visit both towers (full spirals)
6. Return to east tower for finish

---

## Customization Guide

### Adjusting Difficulty

**Make Easier:**
```powershell
# Increase platform size
-sx 7 -sy 0.5 -sz 7  # Instead of 5×5

# Reduce gaps
for ($step = 0; $step -lt 12; $step++)  # Instead of 8
```

**Make Harder:**
```powershell
# Decrease platform size
-sx 3 -sy 0.3 -sz 3  # Instead of 5×5

# Increase gaps
for ($step = 0; $step -lt 6; $step++)  # Instead of 8
```

### Adding Sections

**New Platform Group Template:**
```powershell
# Example: Add forest canopy walkway
for ($i = 0; $i -lt 10; $i++) {
    $x = 200 + ($i * 8)
    $z = 220
    $y = 25  # Above tree canopy
    
    Build-ColoredObject -name "ForestWalk_$i" -type "Cube" `
        -x $x -y $y -z $z `
        -sx 4 -sy 0.4 -sz 4 `
        -color @{ r = 0.25; g = 0.25; b = 0.28 } `
        -metallic 0.7 -smoothness 0.6 `
        -parent "ParcoursSystem"
    $totalObjects++
}
```

---

## Performance Considerations

### Object Budget
- Current: ~250 parkour objects
- Recommended max: 500 total parkour objects
- Each platform: ~100 vertices
- Total vertex budget: ~25,000 vertices

### Optimization Tips
1. **Use mesh combining** for static platforms (not recommended initially to preserve editability)
2. **Reduce emission intensity** on far checkpoints (LOD simulation)
3. **Disable shadows** on small markers
4. **Use occlusion culling** for interior platforms

### Draw Call Analysis
- Unoptimized: ~250 draw calls (one per platform)
- With batching: ~50 draw calls (grouped by material)
- Recommended: Keep platforms separated for gameplay tweaking

---

## Testing Checklist

Before marking as complete, verify:

- [ ] All 4 ground roads connect to portals
- [ ] Castle platforms lead to bridge
- [ ] Bridge platforms reach cathedral
- [ ] All 3 island routes are jumpable
- [ ] Inter-island bridges are traversable
- [ ] Tower spirals reach summit
- [ ] Start marker is visible from spawn
- [ ] Finish marker is at tower top
- [ ] All checkpoints emit light
- [ ] No overlapping platforms
- [ ] Platform gaps are consistent (4-6 units)
- [ ] Heights match island elevations
- [ ] Trees don't block platform landings

---

## Troubleshooting

### Issue: Platforms too far apart
**Solution:** Reduce step count in loops (line ~900-1000)
```powershell
$steps = 10  # Change to 12 for closer platforms
```

### Issue: Start marker not visible
**Solution:** Increase beacon height and emission
```powershell
-sy 30 -sz 1.5  # Taller beacon
-emission @{ intensity = 5.0 }  # Brighter
```

### Issue: Island trees block platforms
**Solution:** Adjust tree radius in island section
```powershell
$tRadius = Get-Random -Minimum 12 -Maximum 15  # Further from center
```

### Issue: Course too easy
**Solution:** Add rotation to platforms
```powershell
-rx (Get-Random -Minimum -15 -Maximum 15)
```

---

## Future Enhancements

### Planned Features
- [ ] Forest canopy integration (tree-to-tree platforms)
- [ ] Underground cavern route (ground level alternative)
- [ ] Moving platforms (animation system required)
- [ ] Rotating platforms (physics challenges)
- [ ] Boost pads (accelerate player forward)
- [ ] Checkpoint teleport system (respawn at last checkpoint)

### Community Suggestions
- Timed challenge mode with countdown
- Collectible orbs on platforms (score system)
- Alternate paths with difficulty ratings
- Night mode with different lighting
- Multiplayer race mode

---

## Credits & Version

**Version:** 1.0  
**Created:** 2025  
**Author:** Unity AI Scene Builder Team  
**Script:** `create-ultimate-complete-world.ps1`  
**Dependencies:** `unity-helpers-v2.ps1`

---

## License

This parkour system is part of the Unity AI Scene Builder Tool project.  
Licensed under MIT License - see repository LICENSE file for details.

---

## Quick Reference

### Key Coordinates
| Location | X | Y | Z |
|----------|---|---|---|
| Start (Castle) | 0 | 6 | 0 |
| Bridge Tower 1 | 0 | 25 | 45 |
| Cathedral Base | 0 | 61 | 120 |
| Island 0 (NE) | 150 | 80 | 150 |
| Island 1 (NW) | -150 | 90 | 150 |
| Island 2 (SE) | 150 | 85 | -150 |
| East Tower | 200 | 68 | 0 |
| West Tower | -200 | 68 | 0 |
| Finish (Tower Top) | 200 | 72 | 0 |

### Color Codes
- Start: `#33FF33` (Bright Green)
- Checkpoints: `#33CCFF` (Cyan)
- Platforms: `#404046` (Industrial Gray)
- Markers: `#FF9933` (Orange)
- Arrows: `#FFFF33` (Yellow)
- Finish: `#FFCC00` (Golden)

---

**Happy Parkour Building! 🏃‍♂️✨**
