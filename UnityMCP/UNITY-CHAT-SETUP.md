# Unity to Copilot Bridge - Setup & Usage

## What This Does
Allows you to chat with GitHub Copilot directly from Unity Editor. Messages automatically appear in your clipboard ready to paste into Copilot Chat.

## Setup (One-time)

### 1. Start the Bridge Server
```powershell
cd UnityMCP
npm run bridge
```
This starts the webhook server on port 8766.

### 2. Start the Monitor (Optional - for auto-clipboard)
In a separate terminal:
```powershell
cd UnityMCP
.\unity-copilot-bridge.ps1
```

### 3. Open Unity Chat Window
In Unity Editor:
- `Tools > Unity MCP > Copilot Chat`

## Usage

### From Unity:
1. Open Copilot Chat window (`Tools > Unity MCP > Copilot Chat`)
2. Type your message (e.g., "create 5 cubes in a circle")
3. Click "Send to Copilot"
4. Message is copied to clipboard automatically

### In VS Code:
1. Open Copilot Chat (Ctrl+Alt+I or Cmd+Shift+I)
2. Paste (Ctrl+V)
3. I'll execute the command using Unity MCP tools!

## Example Workflow

**Unity:**
```
"Create a staircase with 10 steps going up"
```
*Click Send*

**Auto-copied to clipboard, paste in VS Code Copilot Chat:**
*I receive and execute immediately*

**Result:**
- Staircase appears in Unity scene
- No need to switch windows
- All Unity MCP commands work

## Quick Commands to Try

From Unity Chat window:
- "List the scene"
- "Create a sphere at (5, 2, 0)"
- "Add a Rigidbody to the Player"
- "Enter play mode"
- "Create a parkour course"
- "Move all cubes 5 units up"

## Architecture

```
Unity Editor
    ↓ (HTTP POST)
Bridge Server (port 8766)
    ↓ (writes file)
Monitor Script
    ↓ (clipboard)
Your Clipboard
    ↓ (paste)
VS Code Copilot Chat
    ↓ (MCP tools)
Unity MCP Server
    ↓ (HTTP to Unity)
Unity Editor (changes happen)
```

## Advanced: Full Auto-Execute (Future)

To enable true auto-execution without clipboard:
1. Install VS Code extension API access
2. Use `vscode.window.showInputBox` automation
3. Direct Copilot Chat API integration

Current limitation: VS Code doesn't expose Copilot Chat API directly, so we use clipboard as bridge.

## Tips

- Keep VS Code Copilot Chat open in a side panel
- Use Unity chat window as your command center
- Monitor script auto-copies to clipboard
- Just paste in Copilot and it executes instantly

## Stopping

- Bridge Server: Ctrl+C in terminal
- Monitor Script: Ctrl+C in PowerShell
- Unity Window: Close the editor window
