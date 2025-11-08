# Parkour Course System - Complete Guide

## Overview

The **Ultimate Parkour Course** is a comprehensive 7-phase parkour system designed to integrate seamlessly with the Ultimate Complete World. It features over 270+ parkour-specific objects including roads, platforms, bridges, checkpoints, and visual guides.

## Quick Start

### Prerequisites
1. Unity MCP server running (`http://localhost:8765`)
2. Ultimate Complete World created (`create-ultimate-complete-world.ps1`)
3. Unity scene active and ready

### Installation
```powershell
cd UnityMCP
. .\unity-helpers-v2.ps1
.\create-parkour-course.ps1
```

**Generation Time:** 2-4 minutes  
**Total Objects:** 270+ parkour elements  
**Performance:** Optimized for smooth gameplay

---

## Phase Breakdown

### Phase 2: Ground Road System (92 objects)

**Purpose:** Create main road network connecting all major landmarks

**Features:**
- 4 main roads to cardinal portals (60 segments total)
  - North Road: Castle → North Portal
  - South Road: Castle → South Portal  
  - East Road: Castle → East Portal
  - West Road: Castle → West Portal
- 16 decorative road markers with glowing checkpoint orbs
- Organic curved segments for natural flow
- Gray stone road material with metallic finish

**Technical Details:**
- Road segment size: 6×0.4×8 units
- Road marker posts: 0.5×3 units (cylinders)
- Glowing orbs: 1.5 unit spheres with green emission (intensity 3.0)
- Marker spacing: Every 50 units along roads

---

### Phase 3: Elevated Parkour Elements (33 objects)

**Purpose:** Vertical progression from castle to cathedral

**Features:**

#### Castle to Tower Bridge (5 platforms)
- Progressive height increase: 28→32→34→36→38 units
- Platform size: 6×0.8×6 units
- Material: Brown/tan stone with metallic finish
- Spacing: 4 units apart for jumpable gaps

#### Bridge to Cathedral (4 platforms)
- Height progression: 42→48→54→60 units
- Platform size: 5×0.8×5 units
- Material: Purple/dark metallic
- Increased challenge with 6-unit height gaps

#### Aerial Stepping Stones (24 platforms)
- **To Island 1:** 8 stepping stones with sine wave pattern
- **To Island 2:** 8 stepping stones with higher amplitude
- **To Island 3:** 8 stepping stones from ground level
- Stone size: 3×0.6×3 units
- Random rotation for visual variety
- Unique colors per path (blue, magenta, green)

---

### Phase 4: Floating Island Enhancement (44+ objects)

**Purpose:** Add vegetation and inter-island connectivity

**Features:**

#### Island Trees (27+ objects)
- **4-5 trees per island** (randomized)
- Tree placement: Circular pattern around island perimeter
- Tree height: 10-14 units (randomized)
- Components per tree:
  - Trunk: 1.0 unit diameter cylinder (brown)
  - Canopy: 6 unit sphere (green)
- Total: ~14 trees, 28 objects (trunk + canopy)

#### Inter-Island Bridges (20 platforms)
- **Island 1 ↔ Island 2:** 8 platforms (purple)
- **Island 2 ↔ Island 3:** 6 platforms (orange)
- **Island 3 ↔ Island 1:** 6 platforms (green)
- Bridge segment size: 4×0.6×4 units
- Sine wave pattern for dynamic traversal
- Height adjusts smoothly between island elevations

---

### Phase 5: Tower Integration (40 objects)

**Purpose:** Connect towers to parkour flow with spiral mechanics

**Features:**

#### Spiral Platforms (16 platforms)
- **8 platforms per tower** (East & West)
- Spiral pattern: 2 full rotations ascending
- Height progression: 15→57 units (6 unit increments)
- Radius: 12 units from tower center
- Platform size: 4×0.8×6 units
- Tower-colored with emission matching tower core

#### Descending Paths (24 platforms)
- **Island 1 → East Tower:** 12 platforms
- **Island 2 → West Tower:** 12 platforms
- Height drop: 80→15 and 90→20 units
- Platform size: 3.5×0.6×3.5 units
- Color-coded to destination tower
- Smooth descent curve for safe navigation

---

### Phase 6: Forest Integration (14 objects)

**Purpose:** Optional forest shortcuts and exploration paths

**Features:**

#### Oak Grove Platforms (8 platforms)
- Location: Northeast quadrant (180-280, 190-280)
- Height: 12-18 units (tree canopy level)
- Platform size: 4×0.5×4 units
- Material: Wood-like brown
- Randomized placement for natural feel

#### Pine Forest Platforms (6 platforms)
- Location: Northwest quadrant (-270 to -190, 190-280)
- Height: 15-22 units (higher for taller pines)
- Platform size: 4×0.5×4 units
- Material: Dark wood brown
- Elevated challenge for advanced players

---

### Phase 7: Finalization (56 objects)

**Purpose:** Course markers, checkpoints, and visual guidance

**Features:**

#### Start & Finish (4 objects)
- **Start Platform:**
  - Location: (0, 12, 30)
  - Size: 10 unit diameter cylinder
  - Color: Green with emission (intensity 2.5)
  - Beacon: 6 unit tall cylinder (intensity 4.0)

- **Finish Platform:**
  - Location: (0, 12, -30)
  - Size: 12 unit diameter cylinder
  - Color: Golden yellow with emission (intensity 3.5)
  - Beacon: 8 unit tall cylinder (intensity 5.0)

#### Checkpoint System (42 objects - 21 checkpoints)
Each checkpoint consists of:
- **Pillar:** 1×4×1 cube (blue metallic)
- **Orb:** 2 unit sphere with cyan emission (intensity 3.0)

**Checkpoint Locations:**
1. **Castle Area:** 3 checkpoints
2. **Cathedral:** 1 checkpoint
3. **Floating Islands:** 3 checkpoints (one per island)
4. **Tower Areas:** 4 checkpoints (mid + top for each tower)
5. **Portal Areas:** 4 checkpoints (one per portal)
6. **Forest Areas:** 4 checkpoints (one per forest type)
7. **Bridge Connections:** 3 checkpoints (inter-island bridges)

#### Directional Arrows (10 objects - 5 arrows)
Each arrow consists of:
- **Shaft:** 0.5×3×0.5 cube (yellow, intensity 2.0)
- **Head:** 1.5 unit rotated cube (yellow, intensity 2.0)

**Arrow Positions:**
1. Start platform direction
2. Bridge pathway
3. To floating islands
4. To sci-fi towers
5. Finish line direction

---

## Parkour Route Guide

### Recommended Path (Full Course)

1. **Start:** Green platform near castle (0, 12, 30)
2. **Ascend:** 5 platforms up castle walls
3. **Bridge:** Cross tower bridge at elevation
4. **Jump:** 4 platforms toward cathedral
5. **Aerial:** Navigate 8 stepping stones to Island 1
6. **Island 1:** Explore trees, collect checkpoint
7. **Bridge:** Cross 8-platform bridge to Island 2
8. **Island 2:** Navigate elevated area
9. **Descent:** 12 platforms down to West Tower
10. **Spiral:** Ascend 8 spiral platforms around tower
11. **Tower Top:** Reach highest point, collect checkpoint
12. **Return:** Use inter-island bridges or descend to ground
13. **Roads:** Follow glowing markers on ground roads
14. **Portals:** Visit cardinal portals for checkpoints
15. **Forests:** Optional - explore elevated forest platforms
16. **Finish:** Return to golden finish platform (0, 12, -30)

### Speedrun Route (Advanced)

1. Start → Castle walls → Bridge
2. Cathedral jump → Island 1 stepping stones
3. Island 1 → Island 3 bridge (shortcut)
4. Island 3 → East Tower descent
5. Ground sprint → Finish

**Estimated Time:** 3-5 minutes for full course

---

## Technical Specifications

### Object Count Summary
- **Phase 2:** 92 objects (roads + markers)
- **Phase 3:** 33 objects (platforms + stepping stones)
- **Phase 4:** 44+ objects (trees + bridges)
- **Phase 5:** 40 objects (spirals + descents)
- **Phase 6:** 14 objects (forest platforms)
- **Phase 7:** 56 objects (start + finish + checkpoints + arrows)

**Total:** 279+ parkour objects

### Performance Metrics
- **Draw Calls:** ~279 (unoptimized)
- **Optimization Potential:** Can combine static platforms into ~20 meshes
- **Target Framerate:** 60+ FPS on mid-range hardware
- **Collision:** All platforms have colliders for proper physics

### Material Categories
1. **Roads:** Gray stone (metallic 0.1, smoothness 0.6)
2. **Platforms:** Varied colors by zone
3. **Checkpoints:** Cyan emission (intensity 3.0)
4. **Start:** Green emission (intensity 2.5)
5. **Finish:** Golden emission (intensity 3.5)
6. **Arrows:** Yellow emission (intensity 2.0)
7. **Trees:** Brown trunks, green canopies

---

## Customization Guide

### Adjusting Difficulty

#### Make Easier:
```powershell
# In create-parkour-course.ps1, increase platform sizes:
-sx 6 -sy 0.8 -sz 6  # Change to: -sx 8 -sy 0.8 -sz 8

# Reduce gaps between platforms:
$height = 15 + ($i * 4)  # Change to: $height = 15 + ($i * 3)
```

#### Make Harder:
```powershell
# Decrease platform sizes:
-sx 3 -sy 0.6 -sz 3  # Change to: -sx 2 -sy 0.6 -sz 2

# Increase gaps:
$height = 15 + ($i * 6)  # Change to: $height = 15 + ($i * 8)
```

### Adding Custom Checkpoints

```powershell
# Add to $checkpointLocations array:
@{x = 100; y = 50; z = 100; name = "CP_Custom"}
```

### Changing Colors

```powershell
# Modify color hashtables:
-color @{ r = 1.0; g = 0.0; b = 0.0 }  # Red
-color @{ r = 0.0; g = 1.0; b = 0.0 }  # Green
-color @{ r = 0.0; g = 0.0; b = 1.0 }  # Blue
```

---

## Troubleshooting

### Common Issues

#### "Objects not appearing"
- Ensure `create-ultimate-complete-world.ps1` ran first
- Check Unity MCP server is running
- Verify no script errors in PowerShell console

#### "Performance issues"
- Use `Optimize-Group` on static platforms:
  ```powershell
  Optimize-Group -parentName "ParkourPlatforms"
  Optimize-Group -parentName "IslandBridges"
  ```

#### "Gaps too difficult"
- Adjust platform spacing in script
- Add intermediate platforms
- Increase platform sizes

#### "Can't find checkpoints"
- Enable glow/emission in Unity
- Adjust emission intensity values
- Check checkpoint coordinates

---

## Integration with Existing World

### Compatible Scripts
- `create-ultimate-complete-world.ps1` - Base world (required)
- `demo-v2-features.ps1` - Material testing
- `showcase-max-castle.ps1` - Additional castle detail

### Execution Order
1. Run `create-ultimate-complete-world.ps1`
2. Run `create-parkour-course.ps1`
3. Optional: Run optimization scripts
4. Optional: Add custom elements

### World Size
- **Ground Plane:** 1500×1500 units (150×150 Unity scale)
- **Parkour Coverage:** Full world (-250 to 250 units)
- **Max Height:** 92 units (cathedral top)
- **Min Height:** 0.2 units (ground roads)

---

## Future Enhancements

### Planned Features
- [ ] Moving platforms (animated)
- [ ] Rotating obstacles
- [ ] Timed gates/doors
- [ ] Boost pads for super jumps
- [ ] Wall-running sections
- [ ] Ziplines between towers
- [ ] Portal teleporters
- [ ] Collectible power-ups

### Community Requests
- Racing mode with lap timing
- Multiplayer synchronization
- Custom checkpoint scripting
- Difficulty presets (Easy/Medium/Hard/Insane)

---

## Credits

**Script Author:** Unity MCP Team  
**Version:** 1.0  
**Last Updated:** 2025-11  
**License:** Compatible with Unity AI Scene Builder Tool

---

## Support

For issues, feature requests, or questions:
- See main `README.md`
- Check `V2_DOCUMENTATION.md` for API reference
- Review `TESTING.md` for validation procedures

**Remember:** This parkour course is designed to be ABSOLUTELY STUNNING and PERFECT in every way! 🎮✨
