#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

const UNITY_BASE_URL = 'http://localhost:8765';

async function callUnity(endpoint, params = {}) {
  const response = await fetch(`${UNITY_BASE_URL}${endpoint}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(params)
  });
  
  if (!response.ok) {
    throw new Error(`Unity API error: ${response.statusText}`);
  }
  
  return await response.json();
}

async function checkUnityConnection() {
  try {
    await fetch(`${UNITY_BASE_URL}/ping`);
    return true;
  } catch {
    return false;
  }
}

const server = new Server(
  {
    name: 'unity-mcp-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Tool definitions
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'unity_create_gameobject',
        description: 'Create a new GameObject in the Unity scene. Can create empty GameObjects or primitives (Cube, Sphere, Cylinder, Capsule, Plane, Quad). Optionally set a parent.',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name of the GameObject',
            },
            primitiveType: {
              type: 'string',
              description: 'Primitive type: Cube, Sphere, Cylinder, Capsule, Plane, or Quad. Leave empty for empty GameObject.',
              enum: ['', 'Cube', 'Sphere', 'Cylinder', 'Capsule', 'Plane', 'Quad']
            },
            parent: {
              type: 'string',
              description: 'Path to parent GameObject (optional)',
            }
          },
          required: ['name'],
        },
      },
      {
        name: 'unity_set_transform',
        description: 'Set position, rotation, or scale of a GameObject. All values are optional.',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name/path of the GameObject',
            },
            position: {
              type: 'object',
              description: 'World position (x, y, z)',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' },
                z: { type: 'number' }
              }
            },
            rotation: {
              type: 'object',
              description: 'Euler rotation (x, y, z)',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' },
                z: { type: 'number' }
              }
            },
            scale: {
              type: 'object',
              description: 'Local scale (x, y, z)',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' },
                z: { type: 'number' }
              }
            }
          },
          required: ['name'],
        },
      },
      {
        name: 'unity_add_component',
        description: 'Add a component to a GameObject. Use full type names like "Rigidbody", "BoxCollider", "MeshRenderer".',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name/path of the GameObject',
            },
            componentType: {
              type: 'string',
              description: 'Component type name (e.g., "Rigidbody", "BoxCollider")',
            }
          },
          required: ['name', 'componentType'],
        },
      },
      {
        name: 'unity_set_property',
        description: 'Set a property/field value on a component. Use for configuring components after adding them.',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name/path of the GameObject',
            },
            componentType: {
              type: 'string',
              description: 'Component type name',
            },
            property: {
              type: 'string',
              description: 'Property or field name',
            },
            value: {
              description: 'Value to set (string, number, boolean)',
            }
          },
          required: ['name', 'componentType', 'property', 'value'],
        },
      },
      {
        name: 'unity_delete_gameobject',
        description: 'Delete a GameObject from the scene',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name/path of the GameObject to delete',
            }
          },
          required: ['name'],
        },
      },
      {
        name: 'unity_find_gameobject',
        description: 'Find and get information about a GameObject',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name/path of the GameObject',
            }
          },
          required: ['name'],
        },
      },
      {
        name: 'unity_list_scene',
        description: 'List all root GameObjects in the active scene',
        inputSchema: {
          type: 'object',
          properties: {},
        },
      },
      {
        name: 'unity_play_mode',
        description: 'Control Unity Editor play mode (start/stop)',
        inputSchema: {
          type: 'object',
          properties: {
            play: {
              type: 'boolean',
              description: 'True to enter play mode, false to exit',
            }
          },
          required: ['play'],
        },
      },
      {
        name: 'unity_save_scene',
        description: 'Save the current scene. Optionally specify a path for Save As.',
        inputSchema: {
          type: 'object',
          properties: {
            path: {
              type: 'string',
              description: 'Save path (optional, saves current scene if empty)',
            }
          },
        },
      },
      {
        name: 'unity_new_scene',
        description: 'Create a new empty scene with default GameObjects (Camera, Light)',
        inputSchema: {
          type: 'object',
          properties: {},
        },
      },
    ],
  };
});

// Tool execution
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  // Check Unity connection first
  const isConnected = await checkUnityConnection();
  if (!isConnected) {
    return {
      content: [
        {
          type: 'text',
          text: 'Error: Cannot connect to Unity Editor. Make sure Unity is running and the MCP server is started (Tools > Unity MCP > Start Server).',
        },
      ],
    };
  }

  try {
    let result;

    switch (name) {
      case 'unity_create_gameobject':
        result = await callUnity('/createGameObject', {
          name: args.name,
          primitiveType: args.primitiveType || '',
          parent: args.parent || ''
        });
        break;

      case 'unity_set_transform':
        result = await callUnity('/setTransform', {
          name: args.name,
          position: args.position,
          rotation: args.rotation,
          scale: args.scale
        });
        break;

      case 'unity_add_component':
        result = await callUnity('/addComponent', {
          name: args.name,
          componentType: args.componentType
        });
        break;

      case 'unity_set_property':
        result = await callUnity('/setProperty', {
          name: args.name,
          componentType: args.componentType,
          property: args.property,
          value: args.value
        });
        break;

      case 'unity_delete_gameobject':
        result = await callUnity('/deleteGameObject', {
          name: args.name
        });
        break;

      case 'unity_find_gameobject':
        result = await callUnity('/findGameObject', {
          name: args.name
        });
        break;

      case 'unity_list_scene':
        result = await callUnity('/listScene');
        break;

      case 'unity_play_mode':
        result = await callUnity('/playMode', {
          play: args.play
        });
        break;

      case 'unity_save_scene':
        result = await callUnity('/saveScene', {
          path: args.path || ''
        });
        break;

      case 'unity_new_scene':
        result = await callUnity('/newScene');
        break;

      default:
        throw new Error(`Unknown tool: ${name}`);
    }

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(result, null, 2),
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: 'text',
          text: `Error: ${error.message}`,
        },
      ],
      isError: true,
    };
  }
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('Unity MCP server running on stdio');
}

main().catch((error) => {
  console.error('Server error:', error);
  process.exit(1);
});
