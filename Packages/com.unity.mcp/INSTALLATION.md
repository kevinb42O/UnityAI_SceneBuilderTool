# QUICK START: Using Unity MCP in Any Project

## For New Projects (From Package)

1. **Copy Package Folder:**
   ```bash
   # Copy the ENTIRE com.unity.mcp folder to your new project
   xcopy /E /I "C:\Path\To\OldProject\Packages\com.unity.mcp" "C:\Path\To\NewProject\Packages\com.unity.mcp"
   ```

2. **Install Node Dependencies:**
   ```bash
   cd C:\Path\To\NewProject\Packages\com.unity.mcp\NodeServer
   npm install
   ```

3. **Update VS Code MCP Settings:**
   ```bash
   # Run setup script with NEW project path
   .\setup.ps1
   ```
   
   Or manually edit `%APPDATA%\Code\User\globalStorage\github.copilot-chat\mcpServers.json`:
   ```json
   {
     "mcpServers": {
       "unity-mcp": {
         "command": "node",
         "args": ["C:\\NEW\\PROJECT\\PATH\\Packages\\com.unity.mcp\\NodeServer\\index.js"]
       }
     }
   }
   ```

4. **Start Services:**
   ```bash
   # Terminal 1: Bridge server
   npm run bridge
   
   # Terminal 2 (PowerShell): Monitor
   .\unity-copilot-bridge.ps1
   ```

5. **Restart VS Code** to load the MCP server.

## For Distribution (GitHub Package)

### Option A: GitHub Release
1. Create repo: `unity-mcp-package`
2. Push `Packages/com.unity.mcp/*` to repo root
3. Create release tag: `v1.0.0`
4. Users install via: `https://github.com/YOUR_USERNAME/unity-mcp-package.git`

### Option B: Unity Asset Store
1. Export `Packages/com.unity.mcp` as `.unitypackage`
2. Submit to Asset Store with README as documentation

## Testing in Current Project

The package is already in `Packages/com.unity.mcp/`. To test:

```bash
# Your project already has it installed!
# Just verify the MCP settings path is correct:
cd Packages\com.unity.mcp\NodeServer
.\setup.ps1
```

Restart VS Code and try:
```
@workspace create a spinning cube at position 5,0,5
```

## Key Files to Customize Per Project

**NONE!** The system is 100% project-agnostic. The only thing that changes is the **absolute path** in VS Code's MCP settings, which `setup.ps1` handles automatically.

## Architecture

```
Unity Editor (any project)
    ↓ HTTP (port 8765)
UnityMCPServer.cs (auto-starts)
    ↓
Node.js MCP Server (index.js)
    ↓ stdio
VS Code GitHub Copilot
    ↓ Commands
Unity Scene (any project)
```

**No project-specific code.** No hardcoded paths. No asset dependencies.
