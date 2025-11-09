# 🏜️ Egyptian Pyramid World - Quick Start

**Ultra-fast guide to creating your ancient civilization scene**

---

## ⚡ 30-Second Setup

```powershell
cd UnityMCP
.\create-egyptian-pyramid-world.ps1
```

**Done!** Scene created in 30-60 seconds.

---

## 🎯 What You Get

| Feature | Count | Details |
|---------|-------|---------|
| **Pyramids** | 6 | 3 Great + 3 Queen's |
| **Interiors** | 3 | Full corridors & treasure chambers |
| **Sphinx** | 1 | Massive guardian statue |
| **Battle Altar** | 1 | Central combat arena |
| **Obelisks** | 6 | 25-unit tall monuments |
| **Palm Trees** | 25 | Scattered oases |
| **Objects** | 1000+ | Complete scene |

---

## 📍 Key Locations

```
Map Layout (Top View):
┌──────────────────────────────┐
│  Pyramid2    Obelisk   Sphinx│
│    (-70,90)   (0,50)  (-90,0)│
│                              │
│  Obelisk    ALTAR    Obelisk│
│  (-50,0)     (0,0)    (50,0) │
│                              │
│  Pyramid3   Obelisk  Pyramid1│
│  (75,-75)    (0,-50)  (80,80)│
└──────────────────────────────┘
       2500x2500 units
```

---

## 🚪 Entering Pyramids

**Great Pyramid (80, 0, 80):**
1. Find entrance on South face
2. Walk through corridor (8 segments)
3. Reach treasure chamber
4. Find sarcophagus and 4 chests

**Torch-lit corridors** - Easy to navigate

---

## ⚔️ Battle Altar

**Location:** Center (0, 0, 0)
**Features:**
- 40x40 unit elevated platform
- 4-level stepped access
- 8 Pillars with fire
- 4 Anubis guardian statues

**Perfect for:** Boss fights, PvP, ceremonies

---

## 🔥 Performance Boost

**After creation, optimize:**

```powershell
Optimize-Group -parentName "PalmTrees"
Optimize-Group -parentName "StonePaths"
Optimize-Group -parentName "Decorations"
```

**Result:** 60x performance improvement

---

## 🎨 Customize Quick

### Add Pyramid
```powershell
Build-Pyramid -name "MyPyramid" `
    -x 150 -y 0 -z 150 `
    -baseSize 50 -height 35 `
    -parent "Pyramids"
```

### Add Palm Tree
```powershell
Build-PalmTree -name "MyPalm" `
    -x 100 -y 0 -z 100 `
    -parent "PalmTrees"
```

### Add Obelisk
```powershell
Build-Obelisk -name "MyObelisk" `
    -x 200 -y 0 -z 200 `
    -height 30 `
    -parent "Obelisks"
```

---

## 🐛 Quick Fixes

| Problem | Solution |
|---------|----------|
| Server not running | Start Unity, run MCP server |
| Can't see objects | Move camera to (0, 50, -150) |
| Low FPS | Run `Optimize-Group` commands |
| Dark interiors | Add directional light in Unity |

---

## 📊 Stats

- **Creation Time:** 30-60 seconds
- **Total Objects:** 1000+
- **Playable Area:** 2500x2500 units
- **Tallest Structure:** 50 units (Great Pyramid)
- **Torch Lights:** 50+ emissive flames

---

## 🎮 Gameplay Ideas

**Exploration:**
- Discover all pyramid interiors
- Find hidden treasure chests
- Tour all 6 obelisks

**Combat:**
- Defend the altar
- Sphinx boss fight
- Pyramid ambush tactics

**Speedrun:**
- Collect all treasures (fastest time)
- Visit all landmarks
- Altar to pyramid races

---

## 📚 Learn More

- **Full Guide:** `EGYPTIAN_PYRAMID_WORLD_GUIDE.md`
- **Script Source:** `create-egyptian-pyramid-world.ps1`
- **Helper Functions:** `unity-helpers-v2.ps1`

---

## ✨ Pro Tips

1. **Explore from above first** - Bird's eye view shows layout
2. **Follow stone paths** - Connect all major structures
3. **Use altar as waypoint** - Central reference point
4. **Torches mark important areas** - Navigation aids
5. **Palm groves = oases** - Rest areas

---

**Ready to explore ancient Egypt? Run the script now!** 🏜️⚡

```powershell
.\create-egyptian-pyramid-world.ps1
```
