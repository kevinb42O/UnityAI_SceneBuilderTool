# Unity MCP Server

**Control Unity Editor with AI assistants** like GitHub Copilot through the Model Context Protocol (MCP).

## What This Does

- Create GameObjects directly from chat with Copilot
- Manipulate transforms, components, and scene hierarchy
- Control Play Mode, save scenes, and more
- Chat from Unity Editor window → Copilot in VS Code (no window switching!)

## Installation

### Option 1: From GitHub (Recommended)
```
1. In Unity: Window > Package Manager
2. Click '+' > Add package from git URL
3. Enter: https://github.com/YOUR_USERNAME/unity-mcp-package.git
```

### Option 2: Local Package
```
1. Copy the entire `com.unity.mcp` folder to your project's `Packages/` directory
2. Unity will auto-detect it
```

## Setup (5 minutes)

### 1. Start Unity HTTP Server
The server auto-starts when Unity opens. Verify in console:
```
[Unity MCP] Server started on port 8765
```

Manual control: `Tools > Unity MCP > Start/Stop Server`

### 2. Install Node.js Dependencies
```bash
cd Packages/com.unity.mcp/NodeServer
npm install
```

### 3. Configure VS Code MCP Settings

Run the setup script:
```bash
cd Packages/com.unity.mcp/NodeServer
.\setup.ps1  # Windows PowerShell
```

Or manually edit `%APPDATA%\Code\User\globalStorage\github.copilot-chat\mcpServers.json`:
```json
{
  "mcpServers": {
    "unity-mcp": {
      "command": "node",
      "args": ["C:\\FULL\\PATH\\TO\\Packages\\com.unity.mcp\\NodeServer\\index.js"]
    }
  }
}
```

**CRITICAL:** Use the **full absolute path** to `index.js` in your project.

### 4. Start the Bridge Server (for Unity → Copilot chat)
```bash
cd Packages/com.unity.mcp/NodeServer
npm run bridge
```

### 5. Start the Monitor Script (separate PowerShell window)
```powershell
cd Packages/com.unity.mcp/NodeServer
.\unity-copilot-bridge.ps1
```

### 6. Restart VS Code
Close and reopen VS Code to load the MCP server.

## Usage

### From VS Code Copilot Chat
```
@workspace create a car made of cubes
@workspace list all objects in the Unity scene
@workspace create a wall jump parkour course
```

### From Unity Editor (Zero Window Switching!)
1. `Tools > Unity MCP > Copilot Chat`
2. Type your command: "create 3 red spheres"
3. Click **Send to VS Code**
4. Switch to VS Code, paste (Ctrl+V) in Copilot Chat
5. Watch it execute in Unity!

## Available Commands

**Scene Manipulation:**
- Create primitives (Cube, Sphere, Cylinder, etc.)
- Set transforms (position, rotation, scale)
- Parent/child hierarchy
- Delete objects

**Editor Control:**
- Enter/exit Play Mode
- Save/load scenes
- Find GameObjects by name

**Advanced:**
- Add components
- Set component properties
- List entire scene hierarchy

## API Endpoints (Unity HTTP Server)

- `POST /createGameObject` - Create new GameObject
- `POST /setTransform` - Set position/rotation/scale
- `POST /addComponent` - Add Unity component
- `POST /setProperty` - Set component property value
- `POST /deleteGameObject` - Remove GameObject
- `GET /listScene` - Get all scene objects
- `POST /playMode` - Enter/exit Play Mode
- `GET /ping` - Health check

See `NodeServer/index.js` for full MCP tool definitions.

## Project Structure

```
com.unity.mcp/
├── package.json              # UPM package manifest
├── README.md                 # This file
├── Editor/
│   ├── UnityMCPServer.cs     # HTTP server (auto-starts)
│   ├── CopilotChatWindow.cs  # Unity chat window
│   └── Unity.MCP.Editor.asmdef
└── NodeServer/
    ├── index.js              # MCP server (stdio)
    ├── vscode-bridge.js      # Express server for Unity→VSCode
    ├── unity-copilot-bridge.ps1  # Clipboard monitor
    ├── setup.ps1             # VS Code config installer
    └── package.json          # Node dependencies
```

## Troubleshooting

**MCP server not appearing in Copilot?**
- Verify `mcpServers.json` has the correct **absolute path** to `index.js`
- Restart VS Code completely
- Check for errors: Open VS Code Dev Tools (Help > Toggle Developer Tools)

**Unity server won't start?**
- Check port 8765 isn't in use: `netstat -ano | findstr 8765`
- Look for errors in Unity console
- Try `Tools > Unity MCP > Stop Server` then `Start Server`

**Bridge not working?**
- Ensure Express server is running: `npm run bridge` (port 8766)
- Ensure monitor script is running in separate PowerShell window
- Check `NodeServer/.unity-copilot-request.json` updates when sending from Unity

## Requirements

- Unity 2020.3 or later
- Node.js 14+ 
- VS Code with GitHub Copilot extension
- Windows (PowerShell scripts; adapt for Mac/Linux)

## License

MIT - Use freely in any project, commercial or otherwise.

## Contributing

This is designed to be project-agnostic. If you find project-specific code, please submit a PR!
