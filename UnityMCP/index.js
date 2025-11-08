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
      {
        name: 'unity_set_material',
        description: 'Set material properties on a GameObject (color, metallic, smoothness, emission). Creates Standard material if none exists.',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name/path of the GameObject',
            },
            color: {
              type: 'object',
              description: 'RGBA color (0-1 range)',
              properties: {
                r: { type: 'number' },
                g: { type: 'number' },
                b: { type: 'number' },
                a: { type: 'number' }
              }
            },
            metallic: {
              type: 'number',
              description: 'Metallic value 0-1 (0=non-metallic, 1=fully metallic)',
            },
            smoothness: {
              type: 'number',
              description: 'Smoothness value 0-1 (0=rough, 1=smooth/glossy)',
            },
            emission: {
              type: 'object',
              description: 'Emission color and intensity',
              properties: {
                r: { type: 'number' },
                g: { type: 'number' },
                b: { type: 'number' },
                intensity: { type: 'number' }
              }
            },
            tiling: {
              type: 'object',
              description: 'Texture tiling',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' }
              }
            },
            offset: {
              type: 'object',
              description: 'Texture offset',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' }
              }
            }
          },
          required: ['name'],
        },
      },
      {
        name: 'unity_apply_material',
        description: 'Apply a predefined material from the built-in library (Wood_Oak, Metal_Steel, Metal_Gold, Brick_Red, Concrete, Grass_Green, etc.)',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name/path of the GameObject',
            },
            materialName: {
              type: 'string',
              description: 'Material name from library',
              enum: ['Wood_Oak', 'Metal_Steel', 'Metal_Gold', 'Metal_Bronze', 'Glass_Clear', 'Brick_Red', 'Concrete', 'Stone_Gray', 'Grass_Green', 'Water_Blue', 'Rubber_Black', 'Plastic_White', 'Emissive_Blue', 'Emissive_Red']
            }
          },
          required: ['name', 'materialName'],
        },
      },
      {
        name: 'unity_create_material_library',
        description: 'Get list of all available predefined materials in the library',
        inputSchema: {
          type: 'object',
          properties: {},
        },
      },
      {
        name: 'unity_create_group',
        description: 'Create an empty GameObject to act as a parent group/container for organizing objects',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name of the group',
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
        name: 'unity_set_parent',
        description: 'Set the parent of a GameObject to organize hierarchy',
        inputSchema: {
          type: 'object',
          properties: {
            childName: {
              type: 'string',
              description: 'Name/path of the child GameObject',
            },
            parentName: {
              type: 'string',
              description: 'Name/path of the parent GameObject',
            },
            worldPositionStays: {
              type: 'boolean',
              description: 'Keep world position when parenting (default: true)',
            }
          },
          required: ['childName', 'parentName'],
        },
      },
      {
        name: 'unity_combine_children',
        description: 'Combine all child meshes into optimized mesh(es) grouped by material. Critical for performance with many objects.',
        inputSchema: {
          type: 'object',
          properties: {
            parentName: {
              type: 'string',
              description: 'Name/path of the parent GameObject containing children to combine',
            },
            destroyOriginals: {
              type: 'boolean',
              description: 'Delete original child objects after combining (default: true)',
            },
            generateCollider: {
              type: 'boolean',
              description: 'Generate mesh collider on combined mesh (default: true)',
            }
          },
          required: ['parentName'],
        },
      },
      {
        name: 'unity_query_scene',
        description: 'Search and query the scene for GameObjects matching criteria. Returns object names, positions, bounds, tags.',
        inputSchema: {
          type: 'object',
          properties: {
            query: {
              type: 'string',
              description: 'Search string to match against object names/tags (optional, returns all if empty)',
            },
            radius: {
              type: 'number',
              description: 'Only include objects within this radius of position (optional)',
            },
            position: {
              type: 'object',
              description: 'Center position for radius search',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' },
                z: { type: 'number' }
              }
            }
          },
        },
      },
      {
        name: 'unity_generate_world',
        description: 'Generate a complete realtime generated world with specified biome, terrain, and environmental features. Creates an entire playable world in seconds.',
        inputSchema: {
          type: 'object',
          properties: {
            biome: {
              type: 'string',
              description: 'World biome type: Forest, Desert, City, Medieval, SciFi, Fantasy, Underwater, Arctic, Jungle, or Wasteland',
              enum: ['Forest', 'Desert', 'City', 'Medieval', 'SciFi', 'Fantasy', 'Underwater', 'Arctic', 'Jungle', 'Wasteland']
            },
            worldSize: {
              type: 'number',
              description: 'Size of the world in Unity units (default: 100)',
              default: 100
            },
            density: {
              type: 'number',
              description: 'Object density from 0-100, higher = more objects (default: 50)',
              default: 50,
              minimum: 0,
              maximum: 100
            },
            includeTerrain: {
              type: 'boolean',
              description: 'Generate terrain/ground (default: true)',
              default: true
            },
            includeLighting: {
              type: 'boolean',
              description: 'Setup biome-appropriate lighting (default: true)',
              default: true
            },
            includeProps: {
              type: 'boolean',
              description: 'Add environmental props/details (default: true)',
              default: true
            },
            optimizeMeshes: {
              type: 'boolean',
              description: 'Automatically optimize meshes for performance (default: true)',
              default: true
            },
            seed: {
              type: 'string',
              description: 'Random seed for reproducible worlds (optional)',
            }
          },
          required: ['biome'],
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

      case 'unity_set_material':
        result = await callUnity('/setMaterial', {
          name: args.name,
          color: args.color,
          metallic: args.metallic,
          smoothness: args.smoothness,
          emission: args.emission,
          tiling: args.tiling,
          offset: args.offset
        });
        break;

      case 'unity_apply_material':
        result = await callUnity('/applyMaterial', {
          name: args.name,
          materialName: args.materialName
        });
        break;

      case 'unity_create_material_library':
        result = await callUnity('/createMaterialLibrary');
        break;

      case 'unity_create_group':
        result = await callUnity('/createGroup', {
          name: args.name,
          parent: args.parent
        });
        break;

      case 'unity_set_parent':
        result = await callUnity('/setParent', {
          childName: args.childName,
          parentName: args.parentName,
          worldPositionStays: args.worldPositionStays
        });
        break;

      case 'unity_combine_children':
        result = await callUnity('/combineChildren', {
          parentName: args.parentName,
          destroyOriginals: args.destroyOriginals,
          generateCollider: args.generateCollider
        });
        break;

      case 'unity_query_scene':
        result = await callUnity('/queryScene', {
          query: args.query,
          radius: args.radius,
          position: args.position
        });
        break;

      case 'unity_generate_world':
        result = await callUnity('/generateWorld', {
          biome: args.biome,
          worldSize: args.worldSize,
          density: args.density,
          includeTerrain: args.includeTerrain,
          includeLighting: args.includeLighting,
          includeProps: args.includeProps,
          optimizeMeshes: args.optimizeMeshes,
          seed: args.seed
        });
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
