# Unity MCP Server - Advanced Scene Creation System

**31 Production-Grade Tools for Real-World AI Game World Generation**

Control Unity Editor with advanced capabilities: rotation precision, object arrays, physics simulation, lighting, and real-time scene creation. Purpose-built for AI-driven game development.

## Setup

1. **Install Node.js dependencies:**
   ```bash
   cd UnityMCP
   npm install
   ```

2. **Start Unity Editor HTTP server:**
   - Open Unity Editor
   - Click `Tools > Unity MCP > Start Server`
   - Server runs on `http://localhost:8765`

3. **Add to VS Code settings:**
   Add to your `settings.json`:
   ```json
   "mcp.servers": {
     "unity": {
       "command": "node",
       "args": ["c:\\Users\\kevin\\Desktop\\Game Project\\MovementControllerTest\\UnityMCP\\index.js"]
     }
   }
   ```

## 🚀 New Advanced Features

### Advanced Rotation (3 tools)
- `unity_set_rotation_quaternion` - Precise quaternion rotation (no gimbal lock)
- `unity_look_at` - Point objects at targets (cameras, spotlights, enemies)
- `unity_align_to_surface` - Raycast-based surface alignment

### Object Arrays (4 tools)
- `unity_duplicate_object` - Single object duplication
- `unity_create_linear_array` - Fences, roads, pillars (20+ objects in one call)
- `unity_create_circular_array` - Temples, stadiums (perfect circles)
- `unity_create_grid_array` - Cities, buildings (3D grids)

### Lighting System (1 tool)
- `unity_create_light` - Full control (Directional, Point, Spot, Area with shadows)

### Physics System (2 tools)
- `unity_add_rigidbody` - Mass, gravity, drag, constraints
- `unity_add_collider` - Box, Sphere, Capsule, Mesh colliders

### Spatial Queries (2 tools)
- `unity_get_bounds` - Bounding box calculation
- `unity_raycast` - Line-of-sight, ground detection

### Organization (2 tools)
- `unity_set_layer` - Rendering/physics layers
- `unity_set_tag` - Object identification

### Positioning (2 tools)
- `unity_set_local_transform` - Relative to parent
- `unity_snap_to_grid` - Clean alignment

### Materials (v2.0 - 7 tools)
- `unity_set_material` - PBR properties (metallic, smoothness, emission)
- `unity_apply_material` - 14 preset materials
- `unity_create_group` - Hierarchy organization
- `unity_combine_children` - 60x performance optimization

### Scene Creation (Core - 10 tools)
- `unity_create_gameobject` - Create GameObjects (empty or primitives)
- `unity_set_transform` - Set position, rotation, scale
- `unity_add_component` - Add any component
- `unity_set_property` - Configure properties
- `unity_delete_gameobject` - Remove objects
- `unity_list_scene` - List all objects
- `unity_find_gameobject` - Get object info
- `unity_new_scene` - Create new scene
- `unity_save_scene` - Save scene
- `unity_play_mode` - Start/stop play mode

**Total: 31 production-grade tools**

## 📚 Documentation

- **[ADVANCED_SCENE_CREATION.md](ADVANCED_SCENE_CREATION.md)** - Complete guide with 15+ examples
- **[ADVANCED_TOOLS_QUICK_REF.md](ADVANCED_TOOLS_QUICK_REF.md)** - Quick reference card
- **[V2_DOCUMENTATION.md](V2_DOCUMENTATION.md)** - Materials & hierarchy system
- **[WORLD_GENERATION_GUIDE.md](WORLD_GENERATION_GUIDE.md)** - Biome generation

## 🎮 Demo Scripts

```powershell
# Advanced features demo (7 demonstrations)
.\demo-advanced-scene-creation.ps1

# Realistic game scene generator
.\create-realistic-game-scene.ps1 -Theme Medieval -DetailLevel 7

# Available themes: Medieval, SciFi, Modern, Fantasy, PostApocalyptic
.\create-realistic-game-scene.ps1 -Theme SciFi -DetailLevel 10 -WithPhysics

# Materials system demo
.\demo-v2-features.ps1

# World generation
.\demo-world-generation.ps1
```

## 🎯 Real-World Examples

### Example 1: Create a Temple with Pillars
```javascript
// 1. Create base pillar
createGameObject({name: 'Pillar', primitiveType: 'Cylinder'})
setTransform({name: 'Pillar', scale: {x: 1, y: 10, z: 1}})

// 2. Circular array (12 pillars in perfect circle)
createCircularArray({
  sourceName: 'Pillar',
  count: 12,
  radius: 20,
  center: {x: 0, y: 0, z: 0}
})
// Result: Temple with 12 evenly-spaced columns in 2 seconds
```

### Example 2: Spotlight System
```javascript
// 1. Create target
createGameObject({name: 'Target', primitiveType: 'Sphere'})

// 2. Create spotlight
createLight({
  name: 'Spotlight',
  lightType: 'Spot',
  position: {x: 10, y: 20, z: 0},
  intensity: 3,
  spotAngle: 45
})

// 3. Point at target
lookAt({name: 'Spotlight', targetName: 'Target'})
// Result: Spotlight automatically tracks target
```

### Example 3: City Block
```javascript
// 1. Create building template
createGameObject({name: 'Building', primitiveType: 'Cube'})
setTransform({name: 'Building', scale: {x: 5, y: 20, z: 5}})

// 2. 3D grid array
createGridArray({
  sourceName: 'Building',
  countX: 5, countY: 1, countZ: 3,
  spacingX: 10, spacingY: 0, spacingZ: 10
})
// Result: 15 buildings in perfect grid in 3 seconds
```

### Example 4: Physics Simulation
```javascript
// 1. Create ground
createGameObject({name: 'Ground', primitiveType: 'Plane'})

// 2. Create ball
createGameObject({name: 'Ball', primitiveType: 'Sphere'})
setTransform({name: 'Ball', position: {x: 0, y: 20, z: 0}})

// 3. Add physics
addRigidbody({name: 'Ball', mass: 1, useGravity: true})
// Result: Realistic falling ball with gravity
3. Set Rigidbody mass to 10
4. Create ground plane at (0, 0, 0)
5. Enter play mode
```

## Architecture

```
VS Code (MCP Client)
    ↓
UnityMCP/index.js (MCP Server)
    ↓ HTTP
Assets/Editor/UnityMCPServer.cs (Unity HTTP Server)
    ↓ EditorApplication.delayCall
Unity Editor Main Thread
```

## Notes

- All operations execute on Unity's main thread (thread-safe)
- Uses Undo system for all modifications
- Automatically starts HTTP server on Unity load
- Port 8765 must be available
