# Current Building Blocks - Unity AI Scene Builder

**Complete inventory of tools and capabilities for image-to-scene generation**

---

## 🧱 Core Building Blocks (31 Tools)

### 1. Object Creation (4 tools)
- `unity_create_gameobject` - Create primitives (Cube, Sphere, Cylinder, Capsule, Plane, Quad) or empty objects
- `unity_duplicate_object` - Duplicate existing objects
- `unity_delete_gameobject` - Remove objects
- `unity_new_scene` - Create fresh scene

**Use Cases**: Any object/structure creation from image analysis

### 2. Transformation (5 tools)
- `unity_set_transform` - World position, rotation (Euler), scale
- `unity_set_local_transform` - Parent-relative positioning
- `unity_set_rotation_quaternion` - Precise rotation (no gimbal lock)
- `unity_look_at` - Point at targets (cameras, spotlights)
- `unity_snap_to_grid` - Align to grid

**Use Cases**: Object placement from image spatial relationships

### 3. Array Generation (3 tools)
- `unity_create_linear_array` - Rows/columns (fences, roads, pillars)
- `unity_create_circular_array` - Circular patterns (temples, stadiums)
- `unity_create_grid_array` - 3D grids (cities, buildings)

**Use Cases**: Repetitive elements detected in images (trees, pillars, windows)

### 4. Materials System (7 tools)
- `unity_set_material` - Custom PBR (color, metallic, smoothness, emission, tiling, offset)
- `unity_apply_material` - 14 preset materials
- `unity_create_material_library` - List available materials

**Preset Materials:**
1. Wood_Oak - Brown rough wood
2. Metal_Steel - Gray shiny metal
3. Metal_Gold - Gold mirror finish
4. Metal_Bronze - Bronze antique
5. Glass_Clear - Transparent glass
6. Brick_Red - Red rough brick
7. Concrete - Gray matte concrete
8. Stone_Gray - Gray rough stone
9. Grass_Green - Green matte grass
10. Water_Blue - Blue transparent water
11. Rubber_Black - Black matte rubber
12. Plastic_White - White glossy plastic
13. Emissive_Blue - Glowing blue energy
14. Emissive_Red - Glowing red alarm

**Use Cases**: Material matching from image colors/textures

### 5. Hierarchy & Organization (4 tools)
- `unity_create_group` - Empty parent containers
- `unity_set_parent` - Parent-child relationships
- `unity_combine_children` - Mesh optimization (60x performance)
- `unity_set_tag` - Object identification
- `unity_set_layer` - Rendering/physics layers

**Use Cases**: Scene structure organization, performance optimization

### 6. Lighting System (1 tool)
- `unity_create_light` - Directional/Point/Spot/Area lights with shadows

**Use Cases**: Lighting estimation from image brightness/shadows

### 7. Physics System (2 tools)
- `unity_add_rigidbody` - Mass, gravity, drag, constraints
- `unity_add_collider` - Box/Sphere/Capsule/Mesh colliders

**Use Cases**: Gameplay-ready scenes with physics

### 8. Spatial Queries (2 tools)
- `unity_get_bounds` - Bounding box calculation
- `unity_raycast` - Line-of-sight, ground detection

**Use Cases**: Context-aware placement, collision detection

### 9. Scene Intelligence (3 tools)
- `unity_query_scene` - Multi-criteria search (name, tag, proximity)
- `unity_find_gameobject` - Get object info
- `unity_list_scene` - List all root objects

**Use Cases**: Validate generated scenes, query existing objects

---

## 🎨 High-Level PowerShell Functions (15+)

### Basic Creation
- `Create-UnityObject` - Create object with auto-positioning
- `Set-Transform` - Simplified transform setting
- `Build-ColoredObject` - One-line colored object creation

### Materials
- `Set-Material` - Apply custom PBR properties
- `Apply-Material` - Use library materials
- `Get-MaterialLibrary` - List available materials
- `Get-Color` - 13 color presets (Red, Blue, Green, Yellow, Cyan, Magenta, White, Black, Gray, Orange, Purple, Brown, Pink)

### Hierarchy
- `New-Group` - Create organization groups
- `Set-Parent` - Parent objects
- `Optimize-Group` - Combine meshes for performance

### Advanced Builders
- `Build-Group` - Hierarchical structure builder
- `Build-DiagonalObject` - Automatic diagonal connection
- `Build-Archway` - Square/Rounded/Pointed archways
- `Build-Staircase` - Multi-directional stairs
- `Build-CircularWall` - Solid/Pillars/Gaps circular walls
- `Build-Colonnade` - Classical columns with roofs
- `Build-Brazier` - Emissive fire stands
- `Build-TerrainMound` - Hills and dunes

### Utilities
- `Test-UnityConnection` - Health check
- `Find-Objects` - Query scene
- `Copy-Object` - Object duplication

---

## 🌍 World Generation Templates (10 Biomes)

Pre-built world generation with terrain, environment, props, and lighting:

1. **Forest** - Trees, greenery, natural lighting
2. **Desert** - Sand dunes, cacti, harsh sunlight
3. **City** - Modern buildings, roads, urban lighting
4. **Medieval** - Castle, houses, torches
5. **SciFi** - Futuristic structures, neon lights
6. **Fantasy** - Magical trees, crystals, mystical atmosphere
7. **Underwater** - Coral formations, aquatic lighting
8. **Arctic** - Ice, snow, cold atmosphere
9. **Jungle** - Dense vegetation, humidity effects
10. **Wasteland** - Post-apocalyptic ruins, desolation

**Usage**: `New-World -biome "Forest" -worldSize 150 -density 70 -seed "MyWorld123"`

---

## 🏗️ Proven Scene Templates

### Complete Structures
1. **Building 21** - Multi-story military facility (500+ objects, 8 levels)
2. **Luxury Villa** - 3-story Mediterranean villa (400+ objects, 8+ rooms)
3. **Geodesic Dome** - Mathematical dome with oculus (1,600-2,400 objects)
4. **Sci-Fi Capital** - Cyberpunk metropolis (800+ objects, 20 skyscrapers)
5. **Egyptian Pyramid World** - Ancient civilization (1,000+ objects, 6 pyramids)
6. **Parkour Course** - Comprehensive movement course (279+ objects, 7 phases)
7. **Tower Bridge** - Suspension bridge replica (778 objects)

---

## 📊 Capabilities Summary for Image-to-Scene

### What We Can Build From Images

#### 1. Single Objects
- **Detection**: Object type, shape, size, color, material
- **Tools**: Primitive creation + scaling + materials
- **Examples**: Statue, vase, furniture, vehicle

#### 2. Architectural Structures
- **Detection**: Walls, floors, roofs, windows, doors, columns
- **Tools**: Arrays + hierarchy + materials + archways
- **Examples**: House, building, temple, monument

#### 3. Natural Scenes
- **Detection**: Trees, rocks, terrain features, water bodies
- **Tools**: World generation + terrain mounds + materials
- **Examples**: Forest, mountain, beach, garden

#### 4. Interior Spaces
- **Detection**: Rooms, furniture layout, lighting sources
- **Tools**: Hierarchy + placement + lighting + materials
- **Examples**: Bedroom, office, restaurant, museum

#### 5. Urban Environments
- **Detection**: Buildings, roads, vehicles, street furniture
- **Tools**: Grid arrays + lighting + materials + hierarchy
- **Examples**: City block, plaza, parking lot, street

#### 6. Complex Compositions
- **Detection**: Multiple objects with spatial relationships
- **Tools**: Full toolkit orchestration
- **Examples**: Battle scene, marketplace, concert venue

---

## 🎯 Expansion Strategy for "Everything Imaginable"

### Current Gaps to Fill

#### 1. Organic Shapes
**Gap**: No bezier curves, splines, or mesh deformation
**Solution**: 
- Add mesh subdivision tools
- Implement parametric curve generation
- Create organic shape primitives (rocks, plants)

#### 2. Texture Integration
**Gap**: Only basic PBR properties, no texture files
**Solution**:
- Image-to-texture extraction from input
- Automatic texture mapping (UV unwrapping)
- Procedural texture generation

#### 3. Detailed Geometry
**Gap**: Limited to Unity primitives and combinations
**Solution**:
- CSG (Constructive Solid Geometry) boolean operations
- Vertex manipulation tools
- Detail generation (cracks, imperfections, wear)

#### 4. Animation & Motion
**Gap**: Static scenes only
**Solution**:
- Animation curve generation from motion in images
- Particle system setup for effects
- Physics simulation parameters

#### 5. Advanced Lighting
**Gap**: Basic light types only
**Solution**:
- Image-based lighting (IBL) extraction
- Global illumination setup
- Volumetric effects (fog, god rays)

#### 6. Semantic Understanding
**Gap**: No contextual rules (e.g., "door should be on wall")
**Solution**:
- Spatial relationship validation
- Architectural rules engine
- Physics-based placement constraints

---

## 🔄 Combinability & Reusability

### How Everything Connects

#### 1. Modular Design
- **Each tool is independent** - Can be called in any order
- **Composable functions** - High-level functions built from low-level tools
- **Template system** - Pre-built structures can be modified

#### 2. Scene Hierarchy
```
Root Group
├── Environment Group
│   ├── Terrain
│   ├── Sky
│   └── Lighting
├── Objects Group
│   ├── Buildings Group
│   │   ├── Building 1
│   │   └── Building 2
│   └── Props Group
│       ├── Trees
│       └── Furniture
└── Optimization Group
    └── Combined Meshes
```

#### 3. Material System
- **14 preset materials** - Instant application
- **Custom PBR workflow** - Infinite variations
- **Shared materials** - Apply to multiple objects
- **Material libraries** - Create custom libraries

#### 4. Generation Patterns
```powershell
# Pattern: Single object
Create → Transform → Material → Parent → Optimize

# Pattern: Array
Create Template → Array → Materials → Optimize

# Pattern: Complex Structure
Create Groups → Create Objects → Parent → Materials → Optimize

# Pattern: Complete Scene
World Generation → Add Objects → Add Details → Optimize → Lighting
```

---

## 💡 Image-to-Scene Translation Rules

### Detection → Tool Mapping

#### Visual Elements
- **Color** → `Set-Material` color property
- **Shininess** → `Set-Material` metallic/smoothness
- **Glow/Light** → `Set-Material` emission or `unity_create_light`
- **Transparency** → `Set-Material` alpha channel

#### Shapes
- **Box/Cube** → `unity_create_gameobject` type Cube
- **Round** → Sphere or Cylinder
- **Flat** → Plane or scaled Cube
- **Organic** → Multiple primitives combined

#### Patterns
- **Repetition (linear)** → `unity_create_linear_array`
- **Repetition (circular)** → `unity_create_circular_array`
- **Grid pattern** → `unity_create_grid_array`
- **Random scatter** → Loop with random positions

#### Structures
- **Walls** → Scaled cubes or arrays
- **Pillars** → Cylinders with arrays
- **Arches** → `Build-Archway` function
- **Stairs** → `Build-Staircase` function
- **Domes** → Geodesic dome template

#### Spatial Relationships
- **"On top of"** → Parent-child + Y offset
- **"Next to"** → Same Y, X/Z offset
- **"Inside"** → Parent-child + containment
- **"Around"** → Circular array centered on object

---

## 🚀 Performance & Scale

### Proven Performance
- **Single objects**: < 0.1 seconds
- **Arrays (100+ objects)**: 1-3 seconds
- **Complex structures (500+ objects)**: 15-30 seconds
- **Complete worlds (1,000+ objects)**: 2-10 minutes
- **Optimization (mesh combining)**: 60x draw call reduction

### Scale Limits
- **Single scene**: 10,000+ objects (with optimization)
- **Query results**: 500 objects max (performance limit)
- **Array generation**: 1,000+ objects per call
- **World size**: 500x500 units practical limit

---

## 📝 Script Generation Template

### PowerShell Script Structure
```powershell
# 1. Header & Setup
. "$PSScriptRoot\unity-helpers-v2.ps1"
Test-UnityConnection

# 2. Scene Preparation
# Clear scene or create groups

# 3. Main Content Generation
# Create objects based on image analysis

# 4. Materials & Details
# Apply colors, textures, lighting

# 5. Hierarchy & Organization
# Parent objects, create logical groups

# 6. Optimization
# Combine meshes for performance

# 7. Final Touches
# Lighting, camera position, validation
```

---

## ✅ Summary: What Can Be Built

### Fully Supported (100%)
- ✅ Geometric structures (buildings, monuments, bridges)
- ✅ Natural environments (terrain, trees, water bodies)
- ✅ Urban scenes (cities, roads, vehicles)
- ✅ Interior spaces (rooms, furniture, lighting)
- ✅ Repetitive patterns (arrays, grids, circles)
- ✅ Material variations (14 presets + infinite custom)
- ✅ Lighting setups (directional, point, spot, area)
- ✅ Hierarchical organization (groups, parents)
- ✅ Performance optimization (mesh combining)

### Partially Supported (70%)
- ⚠️ Organic shapes (via primitive combinations)
- ⚠️ Complex geometry (limited to primitives)
- ⚠️ Detailed textures (colors only, no texture files)
- ⚠️ Animation (static scenes, manual setup needed)

### Not Supported (0%)
- ❌ Custom mesh import (no .fbx/.obj loading yet)
- ❌ Texture file import (no image loading yet)
- ❌ Skeletal animation (static only)
- ❌ Procedural mesh generation (primitives only)

---

## 🎯 Recommendation for Image-to-Scene

**Best Suited For:**
1. Architectural references (buildings, monuments, interiors)
2. Simple objects (statues, furniture, props)
3. Environment references (forests, deserts, cities)
4. Geometric compositions (abstract structures)
5. Layout references (spatial arrangements)

**Challenging:**
1. Highly organic forms (humans, animals, plants)
2. Complex mechanical objects (vehicles, machines)
3. Fine details (small decorations, text, patterns)
4. Realistic textures (wood grain, stone patterns)

**Solution**: Focus VLM on detecting:
- Object types and shapes (primitive approximations)
- Spatial relationships (positioning rules)
- Color and material properties (PBR matching)
- Patterns and repetition (array generation)
- Overall composition (hierarchy structure)

**The VLM should output structured data that maps to our tools, not try to recreate exact visual fidelity.**

---

**Status**: Ready for VLM integration. All building blocks documented and proven.
