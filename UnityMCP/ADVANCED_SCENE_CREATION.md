# Advanced Scene Creation Guide

**Maximize Possibilities - Real World AI Game World Creation**

---

## 🎯 Overview

This guide covers the advanced scene creation tools designed for maximum realism and detail in AI-driven game world generation. These tools prioritize **rotation precision**, **relative positioning**, and **real-world physics**.

### Key Capabilities

1. **Advanced Rotation** - Quaternions, look-at, surface alignment
2. **Object Duplication** - Linear, circular, and 3D grid arrays
3. **Relative Positioning** - Local transforms, grid snapping
4. **Lighting System** - Full light control with shadows
5. **Physics System** - Rigidbodies, colliders, raycasting
6. **Organization** - Layers, tags, bounds detection

---

## 🔄 Advanced Rotation System

### Quaternion Rotation

**Why use quaternions?** No gimbal lock, smooth interpolation, precise orientation.

```javascript
// MCP Tool: unity_set_rotation_quaternion
{
  name: 'MyObject',
  quaternion: {
    x: 0,
    y: 0.7071,  // 90 degrees around Y
    z: 0,
    w: 0.7071
  }
}
```

**Use cases:**
- Complex 3D rotations
- Animation interpolation
- Avoiding gimbal lock in flight simulators
- Precise camera control

### Look At Target

**Make objects face targets automatically.**

```javascript
// MCP Tool: unity_look_at
{
  name: 'Camera',
  targetName: 'Player',  // OR targetPosition: {x, y, z}
  upVector: {x: 0, y: 1, z: 0}  // Optional, default is up
}
```

**Use cases:**
- Camera following player
- Spotlights tracking targets
- Enemy AI facing player
- Billboard sprites
- Turrets aiming at targets

### Align to Surface

**Place objects on terrain/walls with correct orientation.**

```javascript
// MCP Tool: unity_align_to_surface
{
  name: 'Tree',
  rayOrigin: {x: 10, y: 100, z: 20},  // Start high
  rayDirection: {x: 0, y: -1, z: 0},  // Cast down
  maxDistance: 200,
  offset: 0.5  // Lift 0.5 units above surface
}
```

**Use cases:**
- Placing trees on terrain
- Sticking decals to walls
- Spawning objects on slopes
- Procedural object placement
- Terrain decoration

---

## 📦 Object Duplication & Arrays

### Single Duplication

```javascript
// MCP Tool: unity_duplicate_object
{
  sourceName: 'MasterObject',
  newName: 'Clone_1',
  offset: {x: 5, y: 0, z: 0},
  parent: 'Group'  // Optional
}
```

### Linear Arrays

**Create rows/lines of objects with consistent spacing.**

```javascript
// MCP Tool: unity_create_linear_array
{
  sourceName: 'Pillar',
  count: 20,
  spacing: {x: 5, y: 0, z: 0},  // 5 units apart on X axis
  namePrefix: 'Pillar',
  parent: 'Colonnade'
}
```

**Result:** `Pillar_0, Pillar_1, ..., Pillar_19` spaced 5 units apart

**Use cases:**
- Fences and walls
- Street lights
- Colonnades and pillars
- Road barriers
- Railroad tracks

### Circular Arrays

**Create radial patterns around a center point.**

```javascript
// MCP Tool: unity_create_circular_array
{
  sourceName: 'Column',
  count: 12,
  radius: 20,
  center: {x: 0, y: 0, z: 0},
  rotateToCenter: true,  // Face inward
  namePrefix: 'Column',
  parent: 'Temple'
}
```

**Result:** 12 columns evenly distributed in a circle

**Use cases:**
- Temple columns (Greek/Roman architecture)
- Stonehenge-style structures
- Stadium seating
- Fountain surrounds
- Defense towers
- Clock face markers

### Grid Arrays

**Create 3D grids of objects (buildings, tiles, etc.).**

```javascript
// MCP Tool: unity_create_grid_array
{
  sourceName: 'Building',
  countX: 5,
  countY: 3,
  countZ: 5,
  spacingX: 10,
  spacingY: 15,
  spacingZ: 10,
  namePrefix: 'Building',
  parent: 'City'
}
```

**Result:** 5×3×5 = 75 buildings in a grid

**Use cases:**
- City blocks (urban planning)
- Apartment complexes
- Tiled floors/ceilings
- Forest grids (procedural trees)
- Industrial storage
- Voxel-based structures

---

## 📍 Relative Positioning

### Local Transform

**Position/rotate/scale relative to parent.**

```javascript
// MCP Tool: unity_set_local_transform
{
  name: 'ChildObject',
  localPosition: {x: 2, y: 1, z: 0},  // Relative to parent
  localRotation: {x: 0, y: 45, z: 0},
  localScale: {x: 1, y: 1, z: 1}
}
```

**Difference from world transform:**
- `position` = absolute world coordinates
- `localPosition` = relative to parent

**Use cases:**
- Attaching weapons to character hands
- Door hinges (child of door frame)
- Vehicle wheels (child of car body)
- Hierarchical robot joints
- UI elements relative to canvas

### Snap to Grid

**Align objects to a grid for clean level design.**

```javascript
// MCP Tool: unity_snap_to_grid
{
  name: 'Wall_Section',
  gridSize: 2.0  // Snap to 2-unit grid
}
```

**Before:** Position (5.37, 1.92, 8.14)  
**After:** Position (6.0, 2.0, 8.0)

**Use cases:**
- Level editor alignment
- Tile-based games
- Modular construction
- Clean architectural lines
- Minecraft-style building

---

## 💡 Lighting System

### Create Lights

**Full control over all light types.**

```javascript
// MCP Tool: unity_create_light
{
  name: 'MainSun',
  lightType: 'Directional',  // or Point, Spot, Area
  position: {x: 0, y: 50, z: 0},
  rotation: {x: 50, y: 330, z: 0},
  color: {r: 1, g: 0.95, b: 0.9},  // Warm sunlight
  intensity: 1.5,
  range: 50,  // Point/Spot only
  spotAngle: 45,  // Spot only
  shadows: 'Soft'  // None, Hard, Soft
}
```

### Light Types

| Type | Best For | Shadows | Range |
|------|----------|---------|-------|
| **Directional** | Sun, moon, global lighting | Yes | Infinite |
| **Point** | Lamps, torches, explosions | Yes | Limited radius |
| **Spot** | Flashlights, car headlights, spotlights | Yes | Cone shape |
| **Area** | Soft lighting, skylights (baked only) | Baked | Limited area |

### Lighting Examples

**Daylight scene:**
```javascript
// Sun
{lightType: 'Directional', intensity: 1.5, color: {r:1, g:0.95, b:0.9}}

// Sky ambient
{lightType: 'Directional', intensity: 0.3, color: {r:0.5, g:0.6, b:0.8}}
```

**Night street:**
```javascript
// Street lamp array
for (let i = 0; i < 10; i++) {
  createLight({
    name: `StreetLamp_${i}`,
    lightType: 'Point',
    position: {x: i * 10, y: 8, z: 0},
    color: {r: 1, g: 0.9, b: 0.7},
    intensity: 2,
    range: 15
  });
}
```

**Spotlight tracking:**
```javascript
// Create spotlight
createLight({name: 'Spotlight', lightType: 'Spot', ...});

// Make it look at target
lookAt({name: 'Spotlight', targetName: 'Actor'});
```

---

## ⚙️ Physics System

### Add Rigidbody

**Enable realistic physics simulation.**

```javascript
// MCP Tool: unity_add_rigidbody
{
  name: 'Boulder',
  mass: 100,  // kg
  drag: 0.5,  // Air resistance
  angularDrag: 0.5,  // Rotation damping
  useGravity: true,
  isKinematic: false,  // true = no physics, moved by script
  constraints: {
    freezePositionX: false,
    freezePositionY: false,
    freezePositionZ: false,
    freezeRotationX: false,
    freezeRotationY: true,  // Prevent Y-axis rotation
    freezeRotationZ: false
  }
}
```

**Physics Properties Explained:**

- **mass**: Heavier objects resist acceleration more
- **drag**: Linear damping (0 = no drag, 10 = very slow)
- **angularDrag**: Rotational damping (stops spinning)
- **useGravity**: Falls down if true
- **isKinematic**: Controlled by script, ignores physics forces
- **constraints**: Freeze specific axes (e.g., 2D platformer locks Z)

### Add Colliders

**Define physical boundaries and triggers.**

```javascript
// MCP Tool: unity_add_collider
{
  name: 'Wall',
  colliderType: 'Box',  // Box, Sphere, Capsule, Mesh
  isTrigger: false,  // true = no collision, just detection
  center: {x: 0, y: 0, z: 0},
  size: {x: 10, y: 5, z: 1},  // Box only
  radius: 2,  // Sphere/Capsule only
  height: 5,  // Capsule only
  convex: true  // Mesh only, required for rigidbody
}
```

### Collider Types

| Type | Use Case | Physics | Complexity |
|------|----------|---------|------------|
| **Box** | Buildings, walls, crates | Fast | Low |
| **Sphere** | Balls, planets, explosions | Fastest | Lowest |
| **Capsule** | Characters, pillars | Fast | Low |
| **Mesh** | Complex shapes, terrain | Slow | High |

**Performance tip:** Use primitive colliders (Box/Sphere/Capsule) whenever possible. Only use Mesh for complex static geometry.

### Triggers vs. Colliders

**Collider (isTrigger: false):**
- Physical collision (objects bounce off)
- Used for walls, floors, obstacles

**Trigger (isTrigger: true):**
- No physical collision (objects pass through)
- Detects overlap (pickup zones, doors, checkpoints)

---

## 🎯 Spatial Queries

### Get Bounds

**Get bounding box of objects for placement/collision.**

```javascript
// MCP Tool: unity_get_bounds
{
  name: 'Building'
}

// Returns:
{
  success: true,
  center: {x: 10, y: 5, z: 20},
  size: {x: 20, y: 10, z: 30},
  min: {x: 0, y: 0, z: 5},
  max: {x: 20, y: 10, z: 35}
}
```

**Use cases:**
- Calculate object dimensions
- Place objects without overlap
- Camera framing (fit object in view)
- Bounding box visualization
- Spatial partitioning

### Raycast

**Detect objects along a line (collision detection, line of sight).**

```javascript
// MCP Tool: unity_raycast
{
  origin: {x: 0, y: 10, z: 0},
  direction: {x: 0, y: -1, z: 0},  // Down
  maxDistance: 100,
  layerMask: 'Ground,Buildings'  // Optional filter
}

// Returns:
{
  hit: true,
  distance: 9.5,
  point: {x: 0, y: 0.5, z: 0},
  normal: {x: 0, y: 1, z: 0},
  objectName: 'Floor'
}
```

**Use cases:**
- Ground detection (find floor height)
- Line of sight (can player see enemy?)
- Weapon hit detection
- Mouse click on 3D objects
- Procedural placement (find surface height)

---

## 🏷️ Organization

### Layers

**Control rendering, physics, and raycasting.**

```javascript
// MCP Tool: unity_set_layer
{
  name: 'Player',
  layer: 'Player',  // or layer number
  recursive: true  // Apply to all children
}
```

**Common layers:**
- `Default` - General objects
- `TransparentFX` - Particles, glass
- `IgnoreRaycast` - Invisible to raycasts
- `Water` - Water surfaces
- `UI` - User interface elements

**Use cases:**
- Physics collision matrix (which layers collide)
- Camera culling (what cameras see)
- Raycast filtering (ignore certain objects)
- Post-processing effects per layer

### Tags

**Identify and find specific object types.**

```javascript
// MCP Tool: unity_set_tag
{
  name: 'MainCamera',
  tag: 'MainCamera'
}
```

**Common tags:**
- `Player`
- `MainCamera`
- `Respawn`
- `Finish`
- `EditorOnly`
- `Enemy`
- `Pickup`

**Use cases:**
- Find player: `GameObject.FindWithTag('Player')`
- Detect collisions: `if (other.tag == 'Enemy')`
- Scripting shortcuts

---

## 🎨 Real-World Examples

### Example 1: Procedural Forest

```javascript
// 1. Create tree template
createGameObject({name: 'Tree_Template', primitiveType: 'Cylinder'});
setTransform({name: 'Tree_Template', scale: {x: 1, y: 10, z: 1}});

// 2. Create circular clearings
for (let clearing = 0; clearing < 3; clearing++) {
  createCircularArray({
    sourceName: 'Tree_Template',
    count: 20,
    radius: 30 + clearing * 15,
    center: {x: 0, y: 0, z: 0},
    rotateToCenter: false
  });
}

// 3. Add random trees with raycasting
for (let i = 0; i < 50; i++) {
  let x = (Math.random() - 0.5) * 200;
  let z = (Math.random() - 0.5) * 200;
  
  // Raycast to find ground height
  let hit = raycast({
    origin: {x: x, y: 100, z: z},
    direction: {x: 0, y: -1, z: 0}
  });
  
  if (hit.hit) {
    duplicateObject({
      sourceName: 'Tree_Template',
      newName: `Tree_${i}`,
      offset: {x: x, y: hit.point.y, z: z}
    });
  }
}
```

### Example 2: Suspension Bridge

```javascript
// 1. Create towers
createGameObject({name: 'Tower_L', primitiveType: 'Cube'});
setTransform({name: 'Tower_L', position: {x: -50, y: 30, z: 0}, scale: {x: 5, y: 60, z: 5}});

createGameObject({name: 'Tower_R', primitiveType: 'Cube'});
setTransform({name: 'Tower_R', position: {x: 50, y: 30, z: 0}, scale: {x: 5, y: 60, z: 5}});

// 2. Create deck
createGameObject({name: 'Deck', primitiveType: 'Cube'});
setTransform({name: 'Deck', position: {x: 0, y: 20, z: 0}, scale: {x: 110, y: 1, z: 10}});

// 3. Create cable template
createGameObject({name: 'Cable', primitiveType: 'Cylinder'});
setTransform({
  name: 'Cable',
  position: {x: -50, y: 55, z: 5},
  rotation: {x: 0, y: 0, z: 85},
  scale: {x: 0.2, y: 30, z: 0.2}
});

// 4. Create linear array of cables
createLinearArray({
  sourceName: 'Cable',
  count: 10,
  spacing: {x: 10, y: 0, z: 0}
});

// 5. Add physics to deck for realistic sway
addRigidbody({
  name: 'Deck',
  mass: 1000,
  drag: 2,
  angularDrag: 5,
  constraints: {
    freezePositionX: true,
    freezePositionZ: true,
    freezeRotationX: true,
    freezeRotationZ: true
  }
});
```

### Example 3: Stadium with Lighting

```javascript
// 1. Create stadium ground
createGameObject({name: 'Field', primitiveType: 'Plane'});
setTransform({name: 'Field', scale: {x: 20, y: 1, z: 30}});

// 2. Create seating sections (circular)
for (let tier = 0; tier < 3; tier++) {
  createGameObject({name: `Seat_Template_${tier}`, primitiveType: 'Cube'});
  setTransform({
    name: `Seat_Template_${tier}`,
    scale: {x: 2, y: 1, z: 10}
  });
  
  createCircularArray({
    sourceName: `Seat_Template_${tier}`,
    count: 24,
    radius: 50 + tier * 10,
    center: {x: 0, y: tier * 5, z: 0},
    rotateToCenter: true
  });
}

// 3. Create floodlights (4 corners)
let corners = [
  {x: -60, z: -80},
  {x: 60, z: -80},
  {x: -60, z: 80},
  {x: 60, z: 80}
];

corners.forEach((corner, i) => {
  createLight({
    name: `Floodlight_${i}`,
    lightType: 'Spot',
    position: {x: corner.x, y: 40, z: corner.z},
    color: {r: 1, g: 1, b: 1},
    intensity: 5,
    range: 100,
    spotAngle: 60,
    shadows: 'Soft'
  });
  
  // Point lights at center
  lookAt({
    name: `Floodlight_${i}`,
    targetPosition: {x: 0, y: 0, z: 0}
  });
});
```

---

## 🚀 Performance Tips

### 1. Use Primitive Colliders
**Bad:** Mesh colliders on every object  
**Good:** Box/Sphere colliders for 90% of objects, Mesh only for complex static geometry

### 2. Layer Collision Matrix
Configure which layers collide:
- Bullets don't need to collide with other bullets
- Triggers don't need physics collision
- UI doesn't collide with world objects

### 3. Batch Array Operations
**Bad:** Create 100 objects individually with REST calls  
**Good:** Use array tools (linear/circular/grid) for batch creation

### 4. Grid Snapping
Snap objects to grid → easier to optimize → better performance

### 5. Use Hierarchies
Parent arrays under empty GameObjects → easier to manage → enable group optimization

---

## 📚 API Quick Reference

### Rotation
- `unity_set_rotation_quaternion` - Precise quaternion rotation
- `unity_look_at` - Point at target
- `unity_align_to_surface` - Raycast-based alignment

### Arrays
- `unity_duplicate_object` - Single duplication
- `unity_create_linear_array` - Row/line of objects
- `unity_create_circular_array` - Radial pattern
- `unity_create_grid_array` - 3D grid

### Positioning
- `unity_set_local_transform` - Relative to parent
- `unity_snap_to_grid` - Grid alignment

### Lighting
- `unity_create_light` - All light types

### Physics
- `unity_add_rigidbody` - Physics simulation
- `unity_add_collider` - Collision shapes

### Queries
- `unity_get_bounds` - Bounding box
- `unity_raycast` - Line collision detection

### Organization
- `unity_set_layer` - Layer assignment
- `unity_set_tag` - Tag assignment

---

## 🎓 Learning Path

1. **Start Simple:** Use circular arrays to create a temple
2. **Add Detail:** Use lighting to set mood
3. **Add Physics:** Make objects fall and interact
4. **Use Raycasting:** Place objects on terrain
5. **Combine Systems:** Build complex scenes with all tools

---

## 💡 Pro Tips

1. **Think in Templates:** Create one good object, then duplicate with arrays
2. **Use Look At:** Much easier than calculating rotation angles
3. **Raycast Everything:** Find positions, check line of sight, detect surfaces
4. **Layer Your Lighting:** Ambient + directional + point/spot = realistic
5. **Grid Snapping:** Clean alignment = professional results

---

**This is the foundation for real-world AI game world creation. Master these tools, and you can build anything.** 🚀
