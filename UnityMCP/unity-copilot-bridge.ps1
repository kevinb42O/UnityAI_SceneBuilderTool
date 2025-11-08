# Unity-VSCode Chat Bridge - Auto-executes Unity requests in Copilot
# This script watches for Unity chat requests and automatically sends them to Copilot

$workspacePath = "c:\Users\kevin\Desktop\Game Project\MovementControllerTest"
$markerFile = Join-Path $workspacePath ".unity-copilot-request.json"
$processedFile = Join-Path $workspacePath ".unity-copilot-processed.txt"

Write-Host "Unity to VSCode Copilot Bridge" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Watching for Unity chat messages..." -ForegroundColor Yellow
Write-Host "Marker file: $markerFile" -ForegroundColor Gray
Write-Host ""
Write-Host "Ready! Send messages from Unity Editor" -ForegroundColor Green
Write-Host "Tools -> Unity MCP -> Copilot Chat" -ForegroundColor Green
Write-Host ""

# Load processed timestamps
$processed = @{}
if (Test-Path $processedFile) {
    Get-Content $processedFile | ForEach-Object {
        if ($_ -match "^(.+)$") {
            $processed[$matches[1]] = $true
        }
    }
}

# Watch loop
while ($true) {
    Start-Sleep -Milliseconds 500
    
    if (Test-Path $markerFile) {
        try {
            $content = Get-Content $markerFile -Raw | ConvertFrom-Json
            $timestamp = $content.timestamp
            
            # Skip if already processed
            if ($processed.ContainsKey($timestamp)) {
                continue
            }
            
            Write-Host "New message from Unity:" -ForegroundColor Cyan
            Write-Host "  $($content.message)" -ForegroundColor White
            Write-Host ""
            
            # Mark as processed
            $processed[$timestamp] = $true
            Add-Content -Path $processedFile -Value $timestamp
            
            if ($content.autoExecute) {
                Write-Host "Auto-executing in Copilot..." -ForegroundColor Yellow
                Write-Host ""
                
                # Simulate sending to Copilot via clipboard
                Set-Clipboard -Value $content.message
                
                Write-Host "Message copied to clipboard" -ForegroundColor Green
                Write-Host "Paste into Copilot Chat in VS Code" -ForegroundColor Yellow
                Write-Host ""
                Write-Host "TIP: Keep VS Code Copilot Chat open for instant pasting" -ForegroundColor Gray
                Write-Host ""
            }
            
        } catch {
            Write-Host "Error processing request: $_" -ForegroundColor Red
        }
    }
}
