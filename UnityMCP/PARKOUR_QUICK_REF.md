# Parkour Course - Quick Reference Card

## One-Command Setup
```powershell
cd UnityMCP
. .\unity-helpers-v2.ps1
.\create-ultimate-complete-world.ps1  # Base world
.\create-parkour-course.ps1           # Parkour enhancement
```

## Object Counts by Phase

| Phase | Objects | Description |
|-------|---------|-------------|
| 2 | 92 | Ground roads + markers |
| 3 | 33 | Castle→Cathedral platforms |
| 4 | 44+ | Island trees + bridges |
| 5 | 40 | Tower spirals + descents |
| 6 | 14 | Forest platforms |
| 7 | 56 | Start/finish + checkpoints |
| **Total** | **279+** | Complete parkour system |

## Key Locations

### Start & Finish
- **Start:** Green platform at (0, 12, 30)
- **Finish:** Golden platform at (0, 12, -30)

### Major Checkpoints
- Castle walls: (0, 30, 45)
- Tower bridge: (0, 40, 70)
- Cathedral: (0, 62, 120)
- Island 1: (150, 82, 150)
- Island 2: (-150, 92, 150)
- Island 3: (150, 87, -150)
- East Tower: (200, 30, 0) & (200, 60, 0)
- West Tower: (-200, 30, 0) & (-200, 60, 0)

## Route Summary

### Full Course (5 min)
1. Start (green platform)
2. Castle walls (5 platforms)
3. Tower bridge crossing
4. Cathedral jump (4 platforms)
5. Aerial stones → Island 1 (8 stones)
6. Inter-island bridges
7. Tower spiral ascent
8. Tower descent
9. Ground roads to portals
10. Finish (golden platform)

### Speedrun (3 min)
1. Start → Castle → Bridge
2. Cathedral → Island 1 (stepping stones)
3. Island 1 → Island 3 (direct bridge)
4. Island 3 → East Tower (descent)
5. Ground sprint → Finish

## Quick Edits

### Adjust Difficulty
```powershell
# Edit create-parkour-course.ps1

# Platform sizes (line ~200):
-sx 6 -sy 0.8 -sz 6  # Default
-sx 8 -sy 0.8 -sz 8  # Easier
-sx 3 -sy 0.8 -sz 3  # Harder

# Height gaps (line ~250):
$height = 15 + ($i * 6)  # Default
$height = 15 + ($i * 4)  # Easier
$height = 15 + ($i * 8)  # Harder
```

### Add Checkpoint
```powershell
# Add to $checkpointLocations array (line ~565):
@{x = X; y = Y; z = Z; name = "CP_Custom"}
```

### Change Colors
```powershell
# Standard colors:
@{ r = 1.0; g = 0.0; b = 0.0 }  # Red
@{ r = 0.0; g = 1.0; b = 0.0 }  # Green
@{ r = 0.0; g = 0.0; b = 1.0 }  # Blue
@{ r = 1.0; g = 1.0; b = 0.0 }  # Yellow
@{ r = 1.0; g = 0.0; b = 1.0 }  # Magenta
@{ r = 0.0; g = 1.0; b = 1.0 }  # Cyan
```

## Material Profiles

### Emission Intensities
- Roads: No emission
- Checkpoints: 3.0
- Start beacon: 4.0
- Finish beacon: 5.0
- Arrows: 2.0
- Tower platforms: 1.5

### Metallic Values
- Roads: 0.1
- Platforms: 0.2-0.6
- Checkpoints: 0.8
- Beacons: 0.7-0.9

## Performance

### Default
- Draw calls: ~279
- FPS target: 60+
- Memory: ~50MB

### Optimized
```powershell
Optimize-Group -parentName "ParkourRoads"
Optimize-Group -parentName "ParkourPlatforms"
Optimize-Group -parentName "IslandBridges"
Optimize-Group -parentName "TowerParkour"
```
- Draw calls: ~15-20
- FPS: 120+
- Memory: ~30MB

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Objects missing | Run `create-ultimate-complete-world.ps1` first |
| Can't jump gaps | Increase platform sizes or reduce spacing |
| Low FPS | Run `Optimize-Group` on parent objects |
| Checkpoints invisible | Increase emission intensity |
| Roads not aligned | Adjust rotation in `New-RoadSegment` function |

## Advanced Features

### Custom Road Segment
```powershell
New-RoadSegment -x1 0 -z1 0 -x2 100 -z2 100 `
    -segments 20 -roadName "MyRoad" -parent "CustomRoads"
```

### Custom Platform Chain
```powershell
for ($i = 0; $i -lt 10; $i++) {
    Build-ColoredObject -name "Platform_$i" -type "Cube" `
        -x ($i * 5) -y (10 + $i * 2) -z 0 `
        -sx 4 -sy 0.8 -sz 4 `
        -color @{ r = 0.5; g = 0.5; b = 0.5 } `
        -parent "CustomPlatforms"
}
```

## Integration Notes

- Compatible with all existing world scripts
- Uses same material system as v2.0
- Follows naming conventions for optimization
- Parent groups for easy organization
- No dependencies on external packages

## Documentation

- **Full Guide:** `PARKOUR_COURSE_GUIDE.md`
- **API Docs:** `V2_DOCUMENTATION.md`
- **Quick Start:** `QUICKSTART.md`
- **Testing:** `TESTING.md`

## Version Info

- **Version:** 1.0
- **Last Update:** 2025-11
- **Compatibility:** Unity MCP v2.0+
- **Dependencies:** unity-helpers-v2.ps1
