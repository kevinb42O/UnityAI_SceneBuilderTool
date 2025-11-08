# Unity MCP Server - Quick Start

## What This Does

This MCP server gives Copilot **direct control** over Unity Editor. I can now:
- Create GameObjects and primitives
- Set transforms (position, rotation, scale)
- Add and configure components
- Control play mode
- Manage scenes

## Setup (3 Steps)

### 1. Install Dependencies (DONE ✓)
```bash
cd UnityMCP
npm install
```

### 2. Start Unity HTTP Server
**In Unity Editor:**
- Menu: `Tools > Unity MCP > Start Server`
- You'll see: `[Unity MCP] Server started on port 8765`

### 3. Restart VS Code
The MCP server is configured in your settings. Just restart VS Code to activate it.

## Usage Examples

### Create a Test Scene
"Create a physics test scene with a cube at height 5 and a ground plane"

### Build a Simple Level
"Create a platform at (0, 2, 0) that's a stretched cube 10x1x10"

### Add Physics
"Add a Rigidbody to the cube and set its mass to 5"

### Test Play Mode
"Enter play mode and tell me what happens"

## Available Commands

### GameObject Creation
- `unity_create_gameobject` - Create empty or primitive objects
  - Primitives: Cube, Sphere, Cylinder, Capsule, Plane, Quad

### Transform Control
- `unity_set_transform` - Set position/rotation/scale
  - Position: world space (x, y, z)
  - Rotation: euler angles (x, y, z)
  - Scale: local scale (x, y, z)

### Component Management
- `unity_add_component` - Add components (Rigidbody, BoxCollider, etc.)
- `unity_set_property` - Configure component properties

### Scene Operations
- `unity_list_scene` - See what's in the scene
- `unity_find_gameobject` - Get object info
- `unity_delete_gameobject` - Remove objects
- `unity_new_scene` - Create fresh scene
- `unity_save_scene` - Save current work

### Play Mode
- `unity_play_mode` - Start/stop play mode

## Architecture

```
┌──────────────────┐
│   Copilot Chat   │  "Create a cube at (0, 5, 0)"
└────────┬─────────┘
         │ MCP Protocol
┌────────▼─────────┐
│  UnityMCP/       │  Node.js MCP Server
│  index.js        │  (Translates to HTTP calls)
└────────┬─────────┘
         │ HTTP (localhost:8765)
┌────────▼─────────┐
│  Assets/Editor/  │  C# HTTP Server
│  UnityMCPServer  │  (Runs on main thread)
└────────┬─────────┘
         │ EditorApplication.delayCall
┌────────▼─────────┐
│  Unity Editor    │  Scene modifications
└──────────────────┘
```

## Technical Details

### Thread Safety
- All operations execute on Unity's main thread via `EditorApplication.delayCall`
- No threading issues or crashes

### Undo Support
- All modifications use `Undo.RegisterCreatedObjectUndo`
- Full Ctrl+Z support for all operations

### Error Handling
- Connection checks before operations
- Graceful error messages
- JSON error responses

### Performance
- Lightweight HTTP server (no overhead)
- Direct GameObject manipulation (no reflection overhead for transforms)
- Simple JSON parsing (no heavy dependencies)

## Troubleshooting

### "Cannot connect to Unity Editor"
- Open Unity Editor
- Click `Tools > Unity MCP > Start Server`
- Check console for `[Unity MCP] Server started on port 8765`

### Port 8765 Already in Use
- Stop the server: `Tools > Unity MCP > Stop Server`
- Close any other apps using port 8765
- Restart the server

### MCP Server Not Found
- Restart VS Code after configuration
- Check settings.json has the `mcp.servers` entry
- Verify path in settings points to `UnityMCP/index.js`

## Example Workflows

### Create a Movement Test Scene
```
1. Create new scene
2. Create a cube at (0, 2, 0)
3. Add Rigidbody and CharacterController
4. Create ground plane at (0, 0, 0) scaled to (10, 1, 10)
5. Save scene as MovementTest.unity
```

### Build a Simple Parkour Course
```
1. Create platforms at various heights
2. Set positions and scales for each
3. Create a player capsule
4. Add physics components
5. Enter play mode to test
```

### Rapid Prototyping
```
1. List current scene objects
2. Delete unwanted objects
3. Create new layout
4. Test in play mode
5. Save if good, reset if not
```

## Next Steps

1. Open Unity Editor
2. Start the MCP server (Tools menu)
3. Come back here and ask me to create something in Unity!

Example: "Create a test scene with a cube, sphere, and ground plane"
