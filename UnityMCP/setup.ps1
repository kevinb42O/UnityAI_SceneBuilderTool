# Unity MCP Server Setup Script
# Adds Unity MCP server to VS Code settings

$settingsPath = "$env:APPDATA\Code\User\settings.json"
$unityMcpPath = (Get-Location).Path + "\index.js"

Write-Host "Unity MCP Server Configuration" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Check if settings file exists
if (-not (Test-Path $settingsPath)) {
    Write-Host "Creating new settings.json..." -ForegroundColor Yellow
    New-Item -Path $settingsPath -ItemType File -Force | Out-Null
    Set-Content -Path $settingsPath -Value "{}"
}

# Read current settings
$settings = Get-Content $settingsPath -Raw | ConvertFrom-Json

# Add or update MCP servers configuration
if (-not $settings.PSObject.Properties['mcp.servers']) {
    $settings | Add-Member -MemberType NoteProperty -Name 'mcp.servers' -Value @{}
}

$settings.'mcp.servers' | Add-Member -MemberType NoteProperty -Name 'unity' -Value @{
    command = "node"
    args = @($unityMcpPath)
} -Force

# Save settings
$settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath

Write-Host "Successfully configured Unity MCP server in VS Code settings" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Open Unity Editor" -ForegroundColor White
Write-Host "2. Click: Tools then Unity MCP then Start Server" -ForegroundColor White
Write-Host "3. Restart VS Code to load the MCP server" -ForegroundColor White
Write-Host ""
Write-Host "Test by asking me to list the Unity scene" -ForegroundColor Yellow
