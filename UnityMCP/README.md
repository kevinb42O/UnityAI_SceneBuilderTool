# Unity MCP Server

Control Unity Editor directly through MCP protocol. Create GameObjects, modify transforms, add components, and manage scenes programmatically.

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

## Available Tools

### Scene Creation
- `unity_create_gameobject` - Create GameObjects (empty or primitives)
- `unity_set_transform` - Set position, rotation, scale
- `unity_add_component` - Add components (Rigidbody, Collider, etc.)
- `unity_set_property` - Configure component properties
- `unity_delete_gameobject` - Remove GameObjects

### Scene Management
- `unity_list_scene` - List all root objects
- `unity_find_gameobject` - Get GameObject info
- `unity_new_scene` - Create new scene
- `unity_save_scene` - Save current/new scene
- `unity_play_mode` - Start/stop play mode

## Example Usage

Create a physics test scene:
```
1. Create cube at (0, 5, 0)
2. Add Rigidbody component
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
