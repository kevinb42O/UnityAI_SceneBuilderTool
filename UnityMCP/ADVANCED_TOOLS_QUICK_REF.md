# Advanced Scene Creation Tools - Quick Reference

**17 New Tools for Maximum Scene Creation Possibilities**

---

## 🔄 ROTATION (3 tools)

```javascript
// Quaternion (precise, no gimbal lock)
unity_set_rotation_quaternion({name: 'Obj', quaternion: {x, y, z, w}})

// Look At (cameras, spotlights)
unity_look_at({name: 'Camera', targetName: 'Player'})
unity_look_at({name: 'Light', targetPosition: {x, y, z}})

// Surface Alignment (terrain, walls)
unity_align_to_surface({name: 'Tree', rayOrigin: {x, y, z}, offset: 0.5})
```

---

## 📦 ARRAYS (4 tools)

```javascript
// Single Duplication
unity_duplicate_object({sourceName: 'Obj', newName: 'Clone', offset: {x, y, z}})

// Linear Array (fences, roads, pillars)
unity_create_linear_array({
  sourceName: 'Pillar',
  count: 20,
  spacing: {x: 5, y: 0, z: 0}
})

// Circular Array (temples, stadiums)
unity_create_circular_array({
  sourceName: 'Column',
  count: 12,
  radius: 20,
  center: {x: 0, y: 0, z: 0}
})

// Grid Array (cities, buildings, tiles)
unity_create_grid_array({
  sourceName: 'Building',
  countX: 5, countY: 3, countZ: 5,
  spacingX: 10, spacingY: 15, spacingZ: 10
})
```

---

## 📍 POSITIONING (2 tools)

```javascript
// Local Transform (relative to parent)
unity_set_local_transform({
  name: 'Child',
  localPosition: {x: 2, y: 1, z: 0},
  localRotation: {x: 0, y: 45, z: 0}
})

// Snap to Grid (clean alignment)
unity_snap_to_grid({name: 'Wall', gridSize: 2.0})
```

---

## 💡 LIGHTING (1 tool)

```javascript
// Create Light (Directional, Point, Spot, Area)
unity_create_light({
  name: 'Sun',
  lightType: 'Directional',
  position: {x: 0, y: 50, z: 0},
  color: {r: 1, g: 0.95, b: 0.9},
  intensity: 1.5,
  shadows: 'Soft'
})
```

---

## ⚙️ PHYSICS (2 tools)

```javascript
// Add Rigidbody (mass, gravity, constraints)
unity_add_rigidbody({
  name: 'Boulder',
  mass: 100,
  useGravity: true,
  constraints: {freezePositionY: false}
})

// Add Collider (Box, Sphere, Capsule, Mesh)
unity_add_collider({
  name: 'Wall',
  colliderType: 'Box',
  size: {x: 10, y: 5, z: 1},
  isTrigger: false
})
```

---

## 🎯 QUERIES (2 tools)

```javascript
// Get Bounds (size, center, min, max)
unity_get_bounds({name: 'Building'})
// Returns: {center, size, min, max}

// Raycast (line of sight, ground detection)
unity_raycast({
  origin: {x: 0, y: 10, z: 0},
  direction: {x: 0, y: -1, z: 0},
  maxDistance: 100
})
// Returns: {hit, distance, point, normal, objectName}
```

---

## 🏷️ ORGANIZATION (2 tools)

```javascript
// Set Layer (rendering, physics, raycasting)
unity_set_layer({name: 'Player', layer: 'Player', recursive: true})

// Set Tag (identification, searching)
unity_set_tag({name: 'Enemy', tag: 'Enemy'})
```

---

## 🎨 COMMON PATTERNS

### Pattern 1: Temple with Pillars
```javascript
// 1. Create base pillar
createGameObject({name: 'Pillar', primitiveType: 'Cylinder'})
setTransform({name: 'Pillar', scale: {x: 1, y: 10, z: 1}})

// 2. Circular array
createCircularArray({
  sourceName: 'Pillar',
  count: 12,
  radius: 20,
  center: {x: 0, y: 0, z: 0}
})
```

### Pattern 2: City Block
```javascript
// 1. Create building template
createGameObject({name: 'Building', primitiveType: 'Cube'})
setTransform({name: 'Building', scale: {x: 5, y: 10, z: 5}})

// 2. Grid array
createGridArray({
  sourceName: 'Building',
  countX: 5, countY: 1, countZ: 3,
  spacingX: 8, spacingY: 0, spacingZ: 8
})
```

### Pattern 3: Spotlight System
```javascript
// 1. Create target
createGameObject({name: 'Target', primitiveType: 'Sphere'})

// 2. Create spotlight
createLight({
  name: 'Spotlight',
  lightType: 'Spot',
  position: {x: 10, y: 20, z: 0}
})

// 3. Make it look at target
lookAt({name: 'Spotlight', targetName: 'Target'})
```

### Pattern 4: Physics Simulation
```javascript
// 1. Create ground
createGameObject({name: 'Ground', primitiveType: 'Plane'})

// 2. Create falling object
createGameObject({name: 'Ball', primitiveType: 'Sphere'})
setTransform({name: 'Ball', position: {x: 0, y: 20, z: 0}})

// 3. Add physics
addRigidbody({name: 'Ball', mass: 1, useGravity: true})
```

---

## 📊 PERFORMANCE HIERARCHY

**Fastest → Slowest**

1. **Primitive Colliders** (Box, Sphere, Capsule)
2. **Point Lights** (small range)
3. **Directional Lights** (no attenuation)
4. **Spot Lights** (cone shape)
5. **Mesh Colliders** (static only)
6. **Soft Shadows** (expensive)
7. **Area Lights** (baked only)

---

## 🔧 OPTIMIZATION TIPS

### ✅ DO
- Use arrays for repeated objects
- Snap to grid for clean geometry
- Use primitive colliders when possible
- Combine static meshes (existing tool)
- Use layers to control rendering

### ❌ DON'T
- Create objects one by one (use arrays!)
- Use Mesh colliders on moving objects
- Put lights everywhere (use baking)
- Ignore hierarchies (organize!)
- Forget to optimize after building

---

## 🎯 USE CASE MATRIX

| Feature | Use For |
|---------|---------|
| **Circular Array** | Temples, stadiums, turrets, clock faces |
| **Linear Array** | Fences, roads, pillars, railings |
| **Grid Array** | Cities, buildings, tiles, voxels |
| **Look At** | Cameras, spotlights, enemies, billboards |
| **Align Surface** | Trees on terrain, decals on walls |
| **Raycast** | Ground height, line of sight, mouse picking |
| **Physics** | Falling objects, vehicles, ragdolls |
| **Snap Grid** | Level design, modular building |

---

## 🚀 WORKFLOW

1. **Create Template** → Single well-designed object
2. **Duplicate with Arrays** → Linear, circular, or grid
3. **Align & Position** → Snap to grid, align to surfaces
4. **Add Details** → Lighting, physics, materials
5. **Organize** → Set layers, tags, hierarchies
6. **Optimize** → Combine meshes (existing tool)

---

## 💡 PRO TIPS

1. **Arrays First** - Think in batches, not individuals
2. **Look At Everything** - Easier than manual rotation
3. **Raycast for Placement** - Let physics find the ground
4. **Light Strategically** - 1 directional + few points = realism
5. **Grid Snapping** - Professional results = clean alignment
6. **Use Hierarchies** - Group arrays under parent GameObjects
7. **Layer Everything** - Control rendering and physics

---

## 📖 FULL DOCUMENTATION

- **Comprehensive Guide:** `ADVANCED_SCENE_CREATION.md`
- **Demo Script:** `demo-advanced-scene-creation.ps1`
- **Original Tools:** `V2_DOCUMENTATION.md`

---

**With these 17 tools + original 14 = 31 total scene creation tools, you can build ANY game world.** 🎮🚀
