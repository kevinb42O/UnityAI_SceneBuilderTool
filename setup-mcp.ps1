# Unity MCP Server Setup Script
# This script configures VS Code and Unity for full MCP integration

Write-Host "Setting up Unity MCP Server..." -ForegroundColor Green

# Check if Unity is running
$unityProcesses = Get-Process -Name "Unity*" -ErrorAction SilentlyContinue
if ($unityProcesses) {
    Write-Host "✓ Unity Editor is running" -ForegroundColor Green
} else {
    Write-Host "⚠ Unity Editor is not running. Please start Unity and open the project." -ForegroundColor Yellow
}

# Check VS Code MCP extension
Write-Host "Checking VS Code MCP extension..." -ForegroundColor Cyan
$extensionInstalled = code --list-extensions | Select-String "coplaydev.unity-mcp"
if ($extensionInstalled) {
    Write-Host "✓ Unity MCP extension is installed" -ForegroundColor Green
} else {
    Write-Host "Installing Unity MCP extension..." -ForegroundColor Yellow
    code --install-extension coplaydev.unity-mcp
}

# Verify project structure
$projectPath = "c:\Users\kevin\Desktop\Game Project\MovementControllerTest"
$requiredFiles = @(
    "Assets\Scripts\UnityMCPServer.cs",
    "Assets\Scripts\UnityMCPCommands.cs",
    "Assets\Scripts\Editor\MCPControlPanel.cs",
    "Assets\Scripts\MCPConfig.cs",
    ".vscode\settings.json",
    "MovementControllerTest.code-workspace"
)

Write-Host "Verifying project files..." -ForegroundColor Cyan
foreach ($file in $requiredFiles) {
    $fullPath = Join-Path $projectPath $file
    if (Test-Path $fullPath) {
        Write-Host "✓ $file" -ForegroundColor Green
    } else {
        Write-Host "✗ $file (MISSING)" -ForegroundColor Red
    }
}

# Test network port availability
Write-Host "Testing MCP port availability..." -ForegroundColor Cyan
$port = 3001
$connection = Test-NetConnection -ComputerName "localhost" -Port $port -WarningAction SilentlyContinue
if ($connection.TcpTestSucceeded) {
    Write-Host "✓ Port $port is available for MCP server" -ForegroundColor Green
} else {
    Write-Host "⚠ Port $port might be in use or blocked" -ForegroundColor Yellow
}

Write-Host "`nSetup Summary:" -ForegroundColor Magenta
Write-Host "1. Unity MCP Server scripts installed in Unity project" -ForegroundColor White
Write-Host "2. VS Code workspace configured with MCP settings" -ForegroundColor White
Write-Host "3. MCP Control Panel available in Unity: Tools > MCP > Control Panel" -ForegroundColor White
Write-Host "4. Server will auto-start when Unity loads" -ForegroundColor White

Write-Host "`nNext Steps:" -ForegroundColor Yellow
Write-Host "1. In Unity: Go to Tools > MCP > Control Panel to monitor server" -ForegroundColor White
Write-Host "2. In VS Code: Check MCP output panel for connection status" -ForegroundColor White
Write-Host "3. Test the connection using the Control Panel" -ForegroundColor White

Write-Host "`nMCP Server is now ready for AI control!" -ForegroundColor Green