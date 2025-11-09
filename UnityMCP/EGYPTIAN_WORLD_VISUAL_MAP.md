# 🗺️ Egyptian Pyramid World - Visual Map & Layout

**Complete visual reference for the Egyptian world scene**

---

## 🌍 World Overview (Top View)

```
                    NORTH (Z+)
                        ↑
                        
    (-150,-120)         |         (150,-120)
    ┌──────────────────┼──────────────────┐
    │   Grand Temple   |    Marketplace   │
    │                  |                   │
    │  (-70,90)        |         (150,0)  │
    │  Pyramid 2    Obelisk              │
    │                  |                   │
    │              (0,50)                 │
WEST│  Sphinx       Obelisk         EAST │
(-) │  (-90,0)         |            (+)   │
────┼──────────────────┼──────────────────┼──── Z-axis
    │                  |                   │
    │  Obelisk      ALTAR      Obelisk   │
    │  (-50,0)       (0,0)       (50,0)  │
    │                  |                   │
    │              (0,-50)                │
    │                Obelisk              │
    │                  |                   │
    │  Pyramid 3       |      Pyramid 1   │
    │  (75,-75)        |       (80,80)    │
    │                  |                   │
    └──────────────────┼──────────────────┘
                       |
                       ↓
                    SOUTH (Z-)

    Map Scale: 2500x2500 units (250 unit grid)
```

---

## 🏛️ Major Structure Locations

### Pyramids
```
1. Great Pyramid (Khufu)     : ( 80,  0,  80) - 70x50 units
2. Second Pyramid (Khafre)   : (-70,  0,  90) - 60x43 units
3. Third Pyramid (Menkaure)  : ( 75,  0, -75) - 45x32 units
4. Queen's Pyramid 1         : (120,  0,  50) - 20x15 units
5. Queen's Pyramid 2         : (130,  0,  70) - 20x15 units
6. Queen's Pyramid 3         : (140,  0,  90) - 20x15 units
```

### Monuments
```
Great Sphinx        : (-90,  0,   0) - 35x60 unit statue
Battle Altar        : (  0,  0,   0) - 40x40 unit platform
Grand Temple        : (-150, 0,-120) - 40x60 unit complex
Marketplace         : (150,  0,-120) - 50x50 unit square
```

### Obelisks (25 units tall)
```
1. East Obelisk     : ( 50,  0,   0)
2. West Obelisk     : (-50,  0,   0)
3. North Obelisk    : (  0,  0,  50)
4. South Obelisk    : (  0,  0, -50)
5. NorthWest Obelisk: (-120, 0, 120)
6. SouthEast Obelisk: (120,  0,-120)
```

---

## 🚪 Pyramid Interior Layout (Great Pyramid Example)

### Side View (Cross-Section)
```
       /\  ← Golden Capstone (50 units high)
      /  \
     /    \
    / #### \  ← 20 Layers (limestone)
   /  ####  \
  /   ####   \
 /    ####    \
/█████████████\  ← Ground Level
|             |
|   [ENTRY]   |  ← Entrance (4x5 opening)
|      |      |
|   ▓▓▓▓▓▓    |  ← Corridor (8 segments deep)
|   ▓▓▓▓▓▓    |     with torch lighting
|      |      |
|   ┌─────┐   |  ← Treasure Chamber (15x15)
|   │ ☐ ☐ │   |     ☐ = Treasure chests
|   │ ▓▓▓ │   |     ▓ = Sarcophagus
|   │ ☐ ☐ │   |     ⚡ = Brazier fires
|   └─────┘   |
```

### Chamber Details
- **Entrance:** 4 units wide, 5 units tall
- **Corridor:** 8 segments × 2 units deep
- **Chamber:** 15×15 units
- **Height:** 12 units from floor to ceiling
- **Torches:** Every 2 corridor segments
- **Chests:** 4 corners + central sarcophagus
- **Braziers:** 4 corners (emissive flames)

---

## 🏺 Palm Tree Distribution

### Oasis Clusters
```
Sphinx Oasis (5 trees):
  (-110,-30), (-105,-25), (-115,-28), (-108,-35), (-112,-22)

Great Pyramid Grove (3 trees):
  (100,110), (95,105), (105,108)

Altar Perimeter (4 trees):
  (30,35), (-30,35), (30,-35), (-30,-35)

Scattered (13 trees):
  Various locations across map
```

---

## 🔥 Lighting System Layout

### Central Altar (8 pillar torches)
```
         ⚡
    ⚡         ⚡
         
⚡     ALTAR    ⚡

    ⚡         ⚡
         ⚡

Positions: 28° intervals around altar
Height: 22 units above ground
Intensity: 2.5
```

### Strategic Torches (8 large stands)
```
    (0,80)⚡
         
⚡(-80,0)  🏛️  (80,0)⚡
    ALTAR
⚡(-40,-40) (40,-40)⚡
    
    (0,-80)⚡
    
⚡(-40,40) (40,40)⚡

Height: 9.5 units
Bowl size: 0.8 units
Flame: 1.2×1.6×1.2 units
```

---

## 🛤️ Stone Pathway Network

### Main Paths (20 segments each)
```
Path 1: Altar → Great Pyramid
  (0,0) ════════════▶ (80,80)

Path 2: Altar → Second Pyramid  
  (0,0) ════════════▶ (-70,90)

Path 3: Altar → Third Pyramid
  (0,0) ════════════▶ (75,-75)

Path 4: Altar → Sphinx
  (0,0) ════════════▶ (-90,0)

Each segment: 5×5 units
Total width: 5 units
Color: Dark stone gray
```

---

## 🏛️ Temple Complex (Enhancement)

### Grand Temple Layout
```
                NORTH (stairs)
                   ║║║
    ╔═══════════════╩═════════════╗
    ║ 🔥                       🔥 ║ ← Braziers
    ║  ○  ○  ○  ○  ○  ○  ○  ○  ║ ← Front Colonnade
    ║                              ║
    ║ ○                          ○ ║ ← Side Colonnades
    ║ ○     [TEMPLE INTERIOR]   ○ ║    (6 columns each)
    ║ ○                          ○ ║
    ║ ○          🚪              ○ ║ ← Main Gate (archway)
    ║ ○                          ○ ║
    ║ ○                          ○ ║
    ║                              ║
    ║ 🔥                       🔥 ║
    ╚══════════════════════════════╝
    
    Platform: 40×60 units
    Columns: 8 front + 6 per side = 20 total
    Height: 12 units
    Entrance: 8×10 rounded archway
```

---

## ⚔️ Battle Altar Detail

### Platform Layout (Side View)
```
              ┌──────────────────┐
              │  Anubis Statue   │  22 units
              └───────┬──────────┘
                      │
         🔥 ○ ──────┴────── ○ 🔥  20 units (pillars)
              
    ╔═══════════════════════════╗  6 units (main platform)
    ║      ALTAR PLATFORM       ║
    ║     [Sacrificial Stone]   ║  
    ╠═══════════════════════════╣  
   ╔╩═══════════════════════════╩╗ 4.5 units (step 3)
  ╔╩═════════════════════════════╩╗ 3 units (step 2)
 ╔╩═══════════════════════════════╩╗ 1.5 units (step 1)
╔╩═════════════════════════════════╩╗ Ground level
```

### Top View
```
        (0,22) N
           ⚡○⚡
    ⚡○            ○⚡
(-22,0)W     🩸    E(22,0)
             ▓     (altar stone)
    ⚡○            ○⚡
           ⚡○⚡
        (0,-22) S

Legend:
○ = Pillar
⚡ = Torch flame
🩸 = Sacrificial altar (blood red)
▓ = Platform area

4 Anubis Statues: N, S, E, W (at cardinal points)
8 Pillars with torches: 45° intervals
Platform: 40×40 units, 4 steps
```

---

## 🛍️ Marketplace Layout (Enhancement)

### Market Square
```
    ENTRANCE GATE
         ║║║
    ╔════╩══════════════╗
    ║  🔥  🔥  🔥  🔥  ║ ← Braziers
    ║                   ║
    ║  [▓] [▓] [▓] [▓] ║ ← Row 1 (4 stalls)
    ║                   ║
    ║  [▓] [▓] [▓] [▓] ║ ← Row 2 (4 stalls)
    ║                   ║
    ╚═══════════════════╝
    
    Square: 50×50 units
    Stalls: 8 total (2 rows × 4 columns)
    Each stall: 5×5 units
    Posts: 4 per stall
    Roof: Tan/brown material
    Goods: 3 pottery items per stall
```

---

## 🌀 Ritual Circle (Enhancement)

### Dual Ring System
```
              Outer Ring (Gaps)
         ⊚═══○═══⊚═══○═══⊚
       ⊚                     ⊚
     ○                         ○
    ⊚     Inner Ring           ⊚
    ○       (Pillars)          ○
   ⊚       ○ ○ ○ ○ ○          ⊚
   ○      ○           ○         ○
   ⊚     ○    ALTAR    ○       ⊚
   ○      ○           ○         ○
   ⊚       ○ ○ ○ ○ ○          ⊚
    ○                           ○
    ⊚                         ⊚
     ○                         ○
       ⊚                     ⊚
         ⊚═══○═══⊚═══○═══⊚

Inner Ring:
  Radius: 55 units
  Segments: 24 pillars
  Height: 6 units

Outer Ring:
  Radius: 70 units
  Segments: 32 (alternating gaps)
  Height: 4 units
```

---

## 📐 Scale Reference

### Object Sizes
```
Smallest:  Pottery      = 0.8 units diameter
Small:     Torch Stand  = 4-5 units tall
Medium:    Pillar       = 10-12 units tall
Large:     Obelisk      = 25 units tall
Huge:      Pyramid      = 32-50 units tall
Massive:   Sphinx       = 60 units long
```

### Distance Reference
```
Adjacent Pyramids  = 100-150 units apart
Altar to Pyramid   = 80-90 units
Altar to Sphinx    = 90 units
Altar to Obelisk   = 50 units
Map Diameter       = 500 units
Map Diagonal       = ~700 units
```

---

## 🎮 Navigation Landmarks

### From Spawn (0, 0, 0 - Altar)
```
Look North (Z+):
  - North Obelisk (50 units)
  - Second Pyramid (90 units)

Look South (Z-):
  - South Obelisk (50 units)
  - Third Pyramid (75 units)

Look East (X+):
  - East Obelisk (50 units)
  - Great Pyramid (80 units)
  - Marketplace (150 units)

Look West (X-):
  - West Obelisk (50 units)
  - Sphinx (90 units)
  - Grand Temple (150 units)
```

---

## 🗺️ Exploration Routes

### Route 1: Pyramid Tour (15 minutes)
```
START: Altar (0,0)
  ↓ Follow East path
  1. Great Pyramid (80,80) - Enter & explore interior
  ↓ Walk North
  2. Queen's Pyramids (120-140, 50-90) - Exterior views
  ↓ Walk West
  3. Second Pyramid (-70,90) - Enter & explore interior
  ↓ Walk South
  4. Third Pyramid (75,-75) - Enter & explore interior
  ↓ Return to altar
END: Altar (0,0)
```

### Route 2: Monument Circuit (10 minutes)
```
START: Altar (0,0)
  ↓ Walk to each obelisk
  1. East Obelisk (50,0)
  2. NorthEast via Great Pyramid
  3. NorthWest Obelisk (-120,120)
  4. West Obelisk (-50,0)
  5. SouthEast Obelisk (120,-120)
  6. South Obelisk (0,-50)
END: Altar (0,0)
```

### Route 3: Structural Tour (20 minutes)
```
START: Altar (0,0)
  ↓ West path
  1. Sphinx (-90,0) - Admire from all angles
  ↓ Continue West
  2. Grand Temple (-150,-120) - Walk through colonnade
  ↓ Walk East across map
  3. Marketplace (150,-120) - Browse stalls
  ↓ North to pyramids
  4. Great Pyramid (80,80) - Full interior exploration
  ↓ Return via altar
END: Altar (0,0) - Battle arena test
```

---

## 🎯 Points of Interest (POI)

### High Priority (Must See)
1. ⭐ Great Pyramid Interior (treasure chamber)
2. ⭐ Great Sphinx (detailed statue)
3. ⭐ Battle Altar (central arena)
4. ⭐ Grand Temple (colonnade architecture)

### Medium Priority (Recommended)
5. Second Pyramid Interior
6. Third Pyramid Interior  
7. Ritual Circle (dual rings)
8. Marketplace (8 stalls)
9. Palm Oases (Sphinx area)

### Low Priority (Optional)
10. Queen's Pyramids (exterior)
11. Individual Obelisks (6 total)
12. Stone Pathways
13. Decorative Pillars
14. Scattered Pottery

---

## 🎨 Color Zones

### Warm Zone (Center)
```
- Battle Altar: Dark stone + gold accents
- Torches: Orange/red flames
- Altar stone: Blood red
```

### Neutral Zone (Pyramids)
```
- Limestone: Tan/beige
- Gold accents: Yellow/gold
- Interior: Dark brown stone
```

### Cool Zone (Desert)
```
- Sand: Warm tan
- Dunes: Darker tan
- Palm trees: Green + brown
```

### Accent Colors
```
- Emissive flames: Orange (R:1.0, G:0.5, B:0.0)
- Golden elements: Gold (R:0.85, G:0.65, B:0.13)
- Altar blood: Red (R:0.65, G:0.10, B:0.10)
```

---

## 📊 Performance Zones

### High Detail (Close Range)
- Pyramid interiors (when inside)
- Battle altar (player spawn)
- Temple colonnade

### Medium Detail (Mid Range)
- Pyramid exteriors
- Sphinx statue
- Obelisks
- Marketplace

### Low Detail (Far Range)
- Palm trees (distance)
- Decorative pillars
- Stone blocks
- Pottery

### Optimization Strategy
```
Group by distance from altar:
  Near (<50 units): Keep separate for detail
  Mid (50-150 units): Combine by material
  Far (>150 units): Aggressive combining

Expected Results:
  Before: 1000 draw calls
  After: 10-20 draw calls
  Improvement: 50-100x
```

---

**This visual map provides complete spatial reference for the Egyptian Pyramid World.**

Navigate with confidence! 🗺️✨
