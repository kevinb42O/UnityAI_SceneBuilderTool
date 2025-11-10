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
      {
        name: 'unity_set_rotation_quaternion',
        description: 'Set rotation using quaternion (x, y, z, w) for precise orientation without gimbal lock. Best for complex rotations.',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name/path of the GameObject',
            },
            quaternion: {
              type: 'object',
              description: 'Quaternion rotation (x, y, z, w)',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' },
                z: { type: 'number' },
                w: { type: 'number' }
              },
              required: ['x', 'y', 'z', 'w']
            }
          },
          required: ['name', 'quaternion'],
        },
      },
      {
        name: 'unity_look_at',
        description: 'Make a GameObject look at a target position or another GameObject. Useful for cameras, spotlights, or directional objects.',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name/path of the GameObject to rotate',
            },
            targetName: {
              type: 'string',
              description: 'Name of target GameObject to look at (mutually exclusive with targetPosition)',
            },
            targetPosition: {
              type: 'object',
              description: 'World position to look at (mutually exclusive with targetName)',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' },
                z: { type: 'number' }
              }
            },
            upVector: {
              type: 'object',
              description: 'Up direction (default: 0,1,0)',
              properties: {
                x: { type: 'number', default: 0 },
                y: { type: 'number', default: 1 },
                z: { type: 'number', default: 0 }
              }
            }
          },
          required: ['name'],
        },
      },
      {
        name: 'unity_align_to_surface',
        description: 'Align GameObject to surface normal using raycast. Perfect for placing objects on terrain or walls.',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name/path of the GameObject',
            },
            rayOrigin: {
              type: 'object',
              description: 'Origin point for raycast',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' },
                z: { type: 'number' }
              },
              required: ['x', 'y', 'z']
            },
            rayDirection: {
              type: 'object',
              description: 'Direction of raycast (default: down 0,-1,0)',
              properties: {
                x: { type: 'number', default: 0 },
                y: { type: 'number', default: -1 },
                z: { type: 'number', default: 0 }
              }
            },
            maxDistance: {
              type: 'number',
              description: 'Maximum raycast distance (default: 100)',
              default: 100
            },
            offset: {
              type: 'number',
              description: 'Height offset from surface (default: 0)',
              default: 0
            }
          },
          required: ['name', 'rayOrigin'],
        },
      },
      {
        name: 'unity_set_local_transform',
        description: 'Set LOCAL position, rotation, and scale relative to parent. Essential for hierarchical structures.',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name/path of the GameObject',
            },
            localPosition: {
              type: 'object',
              description: 'Local position relative to parent',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' },
                z: { type: 'number' }
              }
            },
            localRotation: {
              type: 'object',
              description: 'Local Euler rotation relative to parent',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' },
                z: { type: 'number' }
              }
            },
            localScale: {
              type: 'object',
              description: 'Local scale (not affected by parent scale)',
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
        name: 'unity_duplicate_object',
        description: 'Duplicate a GameObject with optional offset. Returns the name of the duplicated object.',
        inputSchema: {
          type: 'object',
          properties: {
            sourceName: {
              type: 'string',
              description: 'Name/path of the GameObject to duplicate',
            },
            newName: {
              type: 'string',
              description: 'Name for the duplicate',
            },
            offset: {
              type: 'object',
              description: 'Position offset from original',
              properties: {
                x: { type: 'number', default: 0 },
                y: { type: 'number', default: 0 },
                z: { type: 'number', default: 0 }
              }
            },
            parent: {
              type: 'string',
              description: 'Optional parent for the duplicate',
            }
          },
          required: ['sourceName', 'newName'],
        },
      },
      {
        name: 'unity_create_linear_array',
        description: 'Create a linear array of duplicated objects along a direction. Perfect for fences, pillars, or roads.',
        inputSchema: {
          type: 'object',
          properties: {
            sourceName: {
              type: 'string',
              description: 'Name/path of the GameObject to duplicate',
            },
            count: {
              type: 'number',
              description: 'Number of copies to create',
              minimum: 1
            },
            spacing: {
              type: 'object',
              description: 'Spacing vector between copies',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' },
                z: { type: 'number' }
              },
              required: ['x', 'y', 'z']
            },
            namePrefix: {
              type: 'string',
              description: 'Prefix for naming duplicates (will add _0, _1, etc.)',
            },
            parent: {
              type: 'string',
              description: 'Optional parent group for all copies',
            }
          },
          required: ['sourceName', 'count', 'spacing'],
        },
      },
      {
        name: 'unity_create_circular_array',
        description: 'Create a circular array of duplicated objects around a center point. Perfect for columns, pillars, or radial structures.',
        inputSchema: {
          type: 'object',
          properties: {
            sourceName: {
              type: 'string',
              description: 'Name/path of the GameObject to duplicate',
            },
            count: {
              type: 'number',
              description: 'Number of copies around the circle',
              minimum: 3
            },
            radius: {
              type: 'number',
              description: 'Radius of the circle',
            },
            center: {
              type: 'object',
              description: 'Center point of the circle',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' },
                z: { type: 'number' }
              },
              required: ['x', 'y', 'z']
            },
            rotateToCenter: {
              type: 'boolean',
              description: 'Whether copies should face the center (default: true)',
              default: true
            },
            namePrefix: {
              type: 'string',
              description: 'Prefix for naming duplicates (will add _0, _1, etc.)',
            },
            parent: {
              type: 'string',
              description: 'Optional parent group for all copies',
            }
          },
          required: ['sourceName', 'count', 'radius', 'center'],
        },
      },
      {
        name: 'unity_create_grid_array',
        description: 'Create a 3D grid array of duplicated objects. Perfect for buildings, cities, or tiled floors.',
        inputSchema: {
          type: 'object',
          properties: {
            sourceName: {
              type: 'string',
              description: 'Name/path of the GameObject to duplicate',
            },
            countX: {
              type: 'number',
              description: 'Number of copies along X axis',
              minimum: 1
            },
            countY: {
              type: 'number',
              description: 'Number of copies along Y axis',
              minimum: 1
            },
            countZ: {
              type: 'number',
              description: 'Number of copies along Z axis',
              minimum: 1
            },
            spacingX: {
              type: 'number',
              description: 'Spacing between copies on X axis',
            },
            spacingY: {
              type: 'number',
              description: 'Spacing between copies on Y axis',
            },
            spacingZ: {
              type: 'number',
              description: 'Spacing between copies on Z axis',
            },
            namePrefix: {
              type: 'string',
              description: 'Prefix for naming duplicates (will add _x_y_z)',
            },
            parent: {
              type: 'string',
              description: 'Optional parent group for all copies',
            }
          },
          required: ['sourceName', 'countX', 'countY', 'countZ', 'spacingX', 'spacingY', 'spacingZ'],
        },
      },
      {
        name: 'unity_snap_to_grid',
        description: 'Snap GameObject position to a grid. Useful for level design and alignment.',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name/path of the GameObject',
            },
            gridSize: {
              type: 'number',
              description: 'Grid size in units (e.g., 1.0 for 1-unit grid)',
            }
          },
          required: ['name', 'gridSize'],
        },
      },
      {
        name: 'unity_create_light',
        description: 'Create a light source (Directional, Point, Spot, or Area) with full control over properties.',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name of the light',
            },
            lightType: {
              type: 'string',
              description: 'Type of light',
              enum: ['Directional', 'Point', 'Spot', 'Area']
            },
            position: {
              type: 'object',
              description: 'Light position',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' },
                z: { type: 'number' }
              }
            },
            rotation: {
              type: 'object',
              description: 'Light rotation (for directional/spot)',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' },
                z: { type: 'number' }
              }
            },
            color: {
              type: 'object',
              description: 'Light color (RGB 0-1)',
              properties: {
                r: { type: 'number' },
                g: { type: 'number' },
                b: { type: 'number' }
              }
            },
            intensity: {
              type: 'number',
              description: 'Light intensity (default: 1.0)',
              default: 1.0
            },
            range: {
              type: 'number',
              description: 'Light range for Point/Spot lights (default: 10)',
              default: 10
            },
            spotAngle: {
              type: 'number',
              description: 'Spot angle for Spot lights (default: 30)',
              default: 30
            },
            shadows: {
              type: 'string',
              description: 'Shadow type',
              enum: ['None', 'Hard', 'Soft'],
              default: 'Soft'
            }
          },
          required: ['name', 'lightType'],
        },
      },
      {
        name: 'unity_set_layer',
        description: 'Set the layer of a GameObject for rendering, physics, or raycasting control.',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name/path of the GameObject',
            },
            layer: {
              type: 'string',
              description: 'Layer name or number (Default, TransparentFX, IgnoreRaycast, Water, UI, etc.)',
            },
            recursive: {
              type: 'boolean',
              description: 'Apply to all children (default: false)',
              default: false
            }
          },
          required: ['name', 'layer'],
        },
      },
      {
        name: 'unity_set_tag',
        description: 'Set the tag of a GameObject for identification and searching.',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name/path of the GameObject',
            },
            tag: {
              type: 'string',
              description: 'Tag name (Player, MainCamera, Respawn, Finish, EditorOnly, etc.)',
            }
          },
          required: ['name', 'tag'],
        },
      },
      {
        name: 'unity_add_rigidbody',
        description: 'Add Rigidbody component with physics properties. Essential for realistic physics simulation.',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name/path of the GameObject',
            },
            mass: {
              type: 'number',
              description: 'Mass in kilograms (default: 1)',
              default: 1
            },
            drag: {
              type: 'number',
              description: 'Air drag (default: 0)',
              default: 0
            },
            angularDrag: {
              type: 'number',
              description: 'Angular drag (default: 0.05)',
              default: 0.05
            },
            useGravity: {
              type: 'boolean',
              description: 'Use gravity (default: true)',
              default: true
            },
            isKinematic: {
              type: 'boolean',
              description: 'Is kinematic (controlled by script, not physics) (default: false)',
              default: false
            },
            constraints: {
              type: 'object',
              description: 'Freeze position/rotation axes',
              properties: {
                freezePositionX: { type: 'boolean', default: false },
                freezePositionY: { type: 'boolean', default: false },
                freezePositionZ: { type: 'boolean', default: false },
                freezeRotationX: { type: 'boolean', default: false },
                freezeRotationY: { type: 'boolean', default: false },
                freezeRotationZ: { type: 'boolean', default: false }
              }
            }
          },
          required: ['name'],
        },
      },
      {
        name: 'unity_add_collider',
        description: 'Add a collider component (Box, Sphere, Capsule, Mesh) with trigger option.',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name/path of the GameObject',
            },
            colliderType: {
              type: 'string',
              description: 'Type of collider',
              enum: ['Box', 'Sphere', 'Capsule', 'Mesh']
            },
            isTrigger: {
              type: 'boolean',
              description: 'Is this a trigger (non-physical) (default: false)',
              default: false
            },
            center: {
              type: 'object',
              description: 'Collider center offset',
              properties: {
                x: { type: 'number', default: 0 },
                y: { type: 'number', default: 0 },
                z: { type: 'number', default: 0 }
              }
            },
            size: {
              type: 'object',
              description: 'Size for Box collider',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' },
                z: { type: 'number' }
              }
            },
            radius: {
              type: 'number',
              description: 'Radius for Sphere/Capsule collider',
            },
            height: {
              type: 'number',
              description: 'Height for Capsule collider',
            },
            convex: {
              type: 'boolean',
              description: 'Is mesh collider convex (required for rigidbody) (default: false)',
              default: false
            }
          },
          required: ['name', 'colliderType'],
        },
      },
      {
        name: 'unity_get_bounds',
        description: 'Get the bounding box of a GameObject (including all renderers). Useful for placement and collision detection.',
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
        name: 'unity_raycast',
        description: 'Perform a physics raycast to detect objects. Returns hit information including point, normal, and object name.',
        inputSchema: {
          type: 'object',
          properties: {
            origin: {
              type: 'object',
              description: 'Ray origin point',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' },
                z: { type: 'number' }
              },
              required: ['x', 'y', 'z']
            },
            direction: {
              type: 'object',
              description: 'Ray direction (will be normalized)',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' },
                z: { type: 'number' }
              },
              required: ['x', 'y', 'z']
            },
            maxDistance: {
              type: 'number',
              description: 'Maximum distance (default: 1000)',
              default: 1000
            },
            layerMask: {
              type: 'string',
              description: 'Layer mask for filtering (optional)',
            }
          },
          required: ['origin', 'direction'],
        },
      },
      {
        name: 'unity_generate_point_cloud',
        description: 'Generate realistic terrain using point cloud data with Perlin noise. Creates LiDAR-style terrain representation with height-based coloring. Perfect for organic, natural-looking landscapes.',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name of the point cloud terrain object',
              default: 'PointCloudTerrain'
            },
            pointCount: {
              type: 'number',
              description: 'Number of points to generate (10000-50000 recommended)',
              default: 10000
            },
            areaSize: {
              type: 'number',
              description: 'Size of terrain area in units',
              default: 100
            },
            noiseAmplitude: {
              type: 'number',
              description: 'Height variation amount (5-50 units)',
              default: 10
            },
            noiseScale: {
              type: 'number',
              description: 'Scale of noise features (0.01-0.2, smaller = larger features)',
              default: 0.1
            },
            seed: {
              type: 'number',
              description: 'Random seed for reproducible terrain (0 = random)',
              default: 0
            },
            asSurface: {
              type: 'boolean',
              description: 'Convert to surface mesh (true) or keep as points (false)',
              default: true
            },
            gridResolution: {
              type: 'number',
              description: 'Grid resolution for surface mesh (20-100)',
              default: 50
            }
          },
          required: ['name']
        }
      },
      {
        name: 'unity_generate_procedural_terrain',
        description: 'Generate advanced procedural terrain using multiple noise algorithms (Perlin, Simplex, Voronoi, Ridged, Billow). Supports multi-octave noise for detailed, realistic terrain with automatic height-based coloring.',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name of the procedural terrain object',
              default: 'ProceduralTerrain'
            },
            width: {
              type: 'number',
              description: 'Width of terrain in units',
              default: 100
            },
            height: {
              type: 'number',
              description: 'Depth of terrain in units',
              default: 100
            },
            amplitude: {
              type: 'number',
              description: 'Maximum height variation',
              default: 10
            },
            noiseType: {
              type: 'string',
              description: 'Noise algorithm type',
              enum: ['Perlin', 'Simplex', 'Voronoi', 'Ridged', 'Billow'],
              default: 'Perlin'
            },
            octaves: {
              type: 'number',
              description: 'Number of noise layers for detail (1-8)',
              default: 4
            },
            persistence: {
              type: 'number',
              description: 'Amplitude decrease per octave (0.3-0.7)',
              default: 0.5
            },
            lacunarity: {
              type: 'number',
              description: 'Frequency increase per octave (1.5-3.0)',
              default: 2.0
            },
            seed: {
              type: 'number',
              description: 'Random seed for reproducible terrain',
              default: 0
            }
          },
          required: ['name']
        }
      },
      {
        name: 'unity_generate_building_facade',
        description: 'Generate procedural building facade with windows, doors, and optional balconies. Creates realistic architectural exteriors with customizable floors, window patterns, and materials.',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name of the building object',
              default: 'Building'
            },
            floors: {
              type: 'number',
              description: 'Number of floors (1-30)',
              default: 5
            },
            floorHeight: {
              type: 'number',
              description: 'Height of each floor in units',
              default: 3.0
            },
            windowsPerFloor: {
              type: 'number',
              description: 'Number of windows per floor (1-10)',
              default: 4
            },
            addDoor: {
              type: 'boolean',
              description: 'Add entrance door on ground floor',
              default: true
            },
            addBalconies: {
              type: 'boolean',
              description: 'Add balconies to each floor (except ground)',
              default: false
            },
            position: {
              type: 'object',
              description: 'World position (x, y, z)',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' },
                z: { type: 'number' }
              }
            }
          },
          required: ['name']
        }
      },
      {
        name: 'unity_generate_lsystem_tree',
        description: 'Generate procedural tree using L-System (Lindenmayer system) grammar. Creates organic, realistic branching patterns. Use preset="tree" for default oak-like tree or customize rules for unique species.',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name of the tree object',
              default: 'Tree'
            },
            preset: {
              type: 'string',
              description: 'Use preset configuration (tree = default oak-like)',
              default: 'tree'
            },
            iterations: {
              type: 'number',
              description: 'Number of L-System iterations (2-6, higher = more complex)',
              default: 4
            },
            angle: {
              type: 'number',
              description: 'Branch angle in degrees (15-45)',
              default: 25
            },
            segmentLength: {
              type: 'number',
              description: 'Length of each branch segment',
              default: 1.0
            },
            position: {
              type: 'object',
              description: 'World position (x, y, z)',
              properties: {
                x: { type: 'number' },
                y: { type: 'number' },
                z: { type: 'number' }
              }
            }
          },
          required: ['name']
        }
      }
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

      case 'unity_set_rotation_quaternion':
        result = await callUnity('/setRotationQuaternion', {
          name: args.name,
          quaternion: args.quaternion
        });
        break;

      case 'unity_look_at':
        result = await callUnity('/lookAt', {
          name: args.name,
          targetName: args.targetName,
          targetPosition: args.targetPosition,
          upVector: args.upVector || { x: 0, y: 1, z: 0 }
        });
        break;

      case 'unity_align_to_surface':
        result = await callUnity('/alignToSurface', {
          name: args.name,
          rayOrigin: args.rayOrigin,
          rayDirection: args.rayDirection || { x: 0, y: -1, z: 0 },
          maxDistance: args.maxDistance || 100,
          offset: args.offset || 0
        });
        break;

      case 'unity_set_local_transform':
        result = await callUnity('/setLocalTransform', {
          name: args.name,
          localPosition: args.localPosition,
          localRotation: args.localRotation,
          localScale: args.localScale
        });
        break;

      case 'unity_duplicate_object':
        result = await callUnity('/duplicateObject', {
          sourceName: args.sourceName,
          newName: args.newName,
          offset: args.offset,
          parent: args.parent
        });
        break;

      case 'unity_create_linear_array':
        result = await callUnity('/createLinearArray', {
          sourceName: args.sourceName,
          count: args.count,
          spacing: args.spacing,
          namePrefix: args.namePrefix,
          parent: args.parent
        });
        break;

      case 'unity_create_circular_array':
        result = await callUnity('/createCircularArray', {
          sourceName: args.sourceName,
          count: args.count,
          radius: args.radius,
          center: args.center,
          rotateToCenter: args.rotateToCenter !== false,
          namePrefix: args.namePrefix,
          parent: args.parent
        });
        break;

      case 'unity_create_grid_array':
        result = await callUnity('/createGridArray', {
          sourceName: args.sourceName,
          countX: args.countX,
          countY: args.countY,
          countZ: args.countZ,
          spacingX: args.spacingX,
          spacingY: args.spacingY,
          spacingZ: args.spacingZ,
          namePrefix: args.namePrefix,
          parent: args.parent
        });
        break;

      case 'unity_snap_to_grid':
        result = await callUnity('/snapToGrid', {
          name: args.name,
          gridSize: args.gridSize
        });
        break;

      case 'unity_create_light':
        result = await callUnity('/createLight', {
          name: args.name,
          lightType: args.lightType,
          position: args.position,
          rotation: args.rotation,
          color: args.color,
          intensity: args.intensity,
          range: args.range,
          spotAngle: args.spotAngle,
          shadows: args.shadows || 'Soft'
        });
        break;

      case 'unity_set_layer':
        result = await callUnity('/setLayer', {
          name: args.name,
          layer: args.layer,
          recursive: args.recursive || false
        });
        break;

      case 'unity_set_tag':
        result = await callUnity('/setTag', {
          name: args.name,
          tag: args.tag
        });
        break;

      case 'unity_add_rigidbody':
        result = await callUnity('/addRigidbody', {
          name: args.name,
          mass: args.mass || 1,
          drag: args.drag || 0,
          angularDrag: args.angularDrag || 0.05,
          useGravity: args.useGravity !== false,
          isKinematic: args.isKinematic || false,
          constraints: args.constraints
        });
        break;

      case 'unity_add_collider':
        result = await callUnity('/addCollider', {
          name: args.name,
          colliderType: args.colliderType,
          isTrigger: args.isTrigger || false,
          center: args.center,
          size: args.size,
          radius: args.radius,
          height: args.height,
          convex: args.convex || false
        });
        break;

      case 'unity_get_bounds':
        result = await callUnity('/getBounds', {
          name: args.name
        });
        break;

      case 'unity_raycast':
        result = await callUnity('/raycast', {
          origin: args.origin,
          direction: args.direction,
          maxDistance: args.maxDistance || 1000,
          layerMask: args.layerMask
        });
        break;

      case 'unity_generate_point_cloud':
        result = await callUnity('/generatePointCloud', {
          name: args.name || 'PointCloudTerrain',
          pointCount: args.pointCount || 10000,
          areaSize: args.areaSize || 100,
          noiseAmplitude: args.noiseAmplitude || 10,
          noiseScale: args.noiseScale || 0.1,
          seed: args.seed || 0,
          asSurface: args.asSurface !== undefined ? args.asSurface : true,
          gridResolution: args.gridResolution || 50
        });
        break;

      case 'unity_generate_procedural_terrain':
        result = await callUnity('/generateProceduralTerrain', {
          name: args.name || 'ProceduralTerrain',
          width: args.width || 100,
          height: args.height || 100,
          amplitude: args.amplitude || 10,
          noiseType: args.noiseType || 'Perlin',
          octaves: args.octaves || 4,
          persistence: args.persistence || 0.5,
          lacunarity: args.lacunarity || 2.0,
          seed: args.seed || 0
        });
        break;

      case 'unity_generate_building_facade':
        result = await callUnity('/generateBuildingFacade', {
          name: args.name || 'Building',
          floors: args.floors || 5,
          floorHeight: args.floorHeight || 3.0,
          windowsPerFloor: args.windowsPerFloor || 4,
          addDoor: args.addDoor !== undefined ? args.addDoor : true,
          addBalconies: args.addBalconies || false,
          position: args.position
        });
        break;

      case 'unity_generate_lsystem_tree':
        result = await callUnity('/generateLSystemTree', {
          name: args.name || 'Tree',
          preset: args.preset || 'tree',
          iterations: args.iterations || 4,
          angle: args.angle || 25,
          segmentLength: args.segmentLength || 1.0,
          position: args.position
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
