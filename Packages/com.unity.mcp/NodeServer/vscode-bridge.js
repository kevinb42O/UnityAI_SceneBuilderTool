#!/usr/bin/env node

import express from 'express';
import { exec } from 'child_process';
import fs from 'fs';
import path from 'path';

const app = express();
const PORT = 8766;

app.use(express.json());

// Store the workspace path
const WORKSPACE_PATH = 'c:\\\\Users\\\\kevin\\\\Desktop\\\\Game Project\\\\MovementControllerTest';

app.post('/copilot-command', async (req, res) => {
  const { message, autoExecute } = req.body;
  
  console.log(`\n[Unity Chat] Received: ${message}`);
  console.log(`[Unity Chat] Auto-execute: ${autoExecute}`);
  
  try {
    // Create a marker file that VS Code can watch
    const markerPath = path.join(WORKSPACE_PATH, '.unity-copilot-request.json');
    const requestData = {
      message: message,
      autoExecute: autoExecute || false,
      timestamp: new Date().toISOString()
    };
    
    fs.writeFileSync(markerPath, JSON.stringify(requestData, null, 2));
    
    console.log(`[Unity Chat] Request saved to ${markerPath}`);
    console.log('[Unity Chat] VS Code should pick this up automatically\n');
    
    res.json({ 
      success: true, 
      message: 'Command forwarded to VS Code Copilot',
      autoExecute: autoExecute
    });
  } catch (error) {
    console.error('[Unity Chat] Error:', error);
    res.status(500).json({ 
      success: false, 
      error: error.message 
    });
  }
});

app.get('/ping', (req, res) => {
  res.json({ status: 'ok', service: 'Unity-VSCode Bridge' });
});

app.listen(PORT, () => {
  console.log(`\n🌉 Unity ↔ VS Code Bridge Server`);
  console.log(`📡 Listening on http://localhost:${PORT}`);
  console.log(`📁 Workspace: ${WORKSPACE_PATH}`);
  console.log(`\n✅ Ready to receive Unity chat messages\n`);
});
