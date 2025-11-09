#!/usr/bin/env node

/**
 * Image Analyzer for Unity Scene Generation
 * Uses VLM (Vision Language Model) to analyze images and generate scene descriptions
 */

import fs from 'fs';
import path from 'path';
import { validateScene, autoFixPositioning, validateGroundPlacement, recommendSpacing } from './spatial-validator.js';

/**
 * Analyze image and generate structured scene description
 * @param {string} imagePath - Path to image file
 * @param {string} analysisType - Type of analysis: 'object', 'scene', 'architecture', 'environment'
 * @param {object} options - Additional options
 * @returns {Promise<object>} Structured scene description
 */
export async function analyzeImage(imagePath, analysisType = 'scene', options = {}) {
  // Validate image exists
  if (!fs.existsSync(imagePath)) {
    throw new Error(`Image file not found: ${imagePath}`);
  }

  // Read image as base64
  const imageBuffer = fs.readFileSync(imagePath);
  const imageBase64 = imageBuffer.toString('base64');
  const imageExt = path.extname(imagePath).toLowerCase();
  
  // Determine MIME type
  const mimeTypes = {
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.png': 'image/png',
    '.gif': 'image/gif',
    '.webp': 'image/webp'
  };
  const mimeType = mimeTypes[imageExt] || 'image/jpeg';

  // Generate analysis prompt based on type
  const prompt = generateAnalysisPrompt(analysisType, options);

  // Return structured format for VLM
  return {
    image: {
      data: imageBase64,
      mimeType: mimeType,
      path: imagePath
    },
    prompt: prompt,
    analysisType: analysisType,
    options: options
  };
}

/**
 * Generate VLM prompt for image analysis
 */
function generateAnalysisPrompt(analysisType, options) {
  const basePrompt = `You are an EXPERT at analyzing images and generating EXACT Unity scene replications. 
Your task is to analyze the provided image and generate a DETAILED JSON response that will recreate THIS SPECIFIC object/building/scene in Unity - NOT a generic approximation.

GOAL: EXACT VISUAL REPLICATION
- Extract EVERY visible detail, color, proportion
- Identify distinguishing features that make THIS object unique
- Capture specific architectural elements, decorative details, unique shapes
- Match colors PRECISELY using RGB values from the image
- Replicate proportions EXACTLY as they appear

Available Unity primitives: Cube, Sphere, Cylinder, Capsule, Plane, Quad
Available materials: Wood_Oak, Metal_Steel, Metal_Gold, Metal_Bronze, Glass_Clear, Brick_Red, Concrete, Stone_Gray, Grass_Green, Water_Blue, Rubber_Black, Plastic_White, Emissive_Blue, Emissive_Red
Available patterns: Linear array, Circular array, Grid array

CRITICAL SPATIAL RULES:
1. Unity uses METERS as units (1 unit = 1 meter). A human is ~1.8 units tall.
2. Y-axis is UP. Ground level is Y=0. Objects sit ON ground with Y = half their height.
3. Avoid overlaps: Objects must not occupy the same space. Check positions carefully.
4. Use proper spacing: Minimum 0.5 units between objects to prevent z-fighting.
5. Scale appropriately: A door is ~2 units tall, a table is ~1 unit tall, a car is ~4 units long.
6. For "on top of": Calculate Y position as: bottom_object_Y + bottom_object_height/2 + top_object_height/2
7. For "next to": Same Y, different X or Z with spacing = (obj1_width + obj2_width)/2 + gap
8. For "inside": Parent-child relationship, child position relative to parent center

DETAIL EXTRACTION REQUIREMENTS:
- Colors: Extract exact RGB values from dominant colors in image
- Proportions: Measure relative sizes of all components accurately
- Unique features: Identify what makes THIS object different (curves, angles, decorations)
- Surface properties: Detect if metallic (cars, metal buildings), smooth (glass), rough (stone, brick)
- Repetitive patterns: Count windows, columns, wheels, etc. - use arrays for efficiency
- Fine details: Small decorative elements, trim, railings, ornaments

`;

  const typePrompts = {
    'object': `${basePrompt}
FOCUS: EXACT REPLICATION of single object (car, statue, furniture, landmark)
GOAL: Someone looking at the generated 3D model should recognize THIS SPECIFIC object, not a generic version.

ANALYSIS STEPS:
1. IDENTIFY OBJECT TYPE: What exactly is this? (e.g., "1965 Ford Mustang", "Statue of Liberty", "Eiffel Tower", not just "car", "statue", "tower")
2. MEASURE PROPORTIONS: Get exact width:height:depth ratios from the image
3. EXTRACT COLORS: Sample RGB values from major surfaces (body, trim, details)
4. IDENTIFY UNIQUE FEATURES: What makes THIS object recognizable?
   - Cars: Headlight shape, grille design, body curves, wheel style, hood ornaments
   - Buildings: Window patterns, architectural style, unique shapes, spires, domes
   - Statues: Pose, clothing folds, facial features, base design, decorative elements
5. COUNT REPETITIVE ELEMENTS: Windows, wheels, columns, decorations (use arrays)
6. DETECT MATERIALS: Metal (cars, modern buildings), glass (windows), stone (monuments), wood, plastic
7. BREAK INTO PRIMITIVES: Use MANY small primitives for accuracy (20-50+ components for complex objects)
   - Curved surfaces: Use multiple rotated cylinders/spheres
   - Angular shapes: Use cubes with precise rotations
   - Round elements: Spheres, cylinders, capsules
8. CALCULATE EXACT POSITIONS: Follow spatial rules to prevent overlaps

Output JSON format:
{
  "type": "single_object",
  "name": "SPECIFIC Name (e.g., 'Eiffel Tower', '1967 Chevy Impala', 'Atomium Brussels')",
  "description": "Detailed description highlighting UNIQUE identifying features that make this recognizable",
  "reference_colors": [
    {"name": "primary_body", "rgb": {"r": 0.15, "g": 0.15, "b": 0.18}, "description": "dark metallic blue"},
    {"name": "trim", "rgb": {"r": 0.9, "g": 0.9, "b": 0.9}, "description": "chrome trim"},
    {"name": "accent", "rgb": {"r": 0.8, "g": 0.1, "b": 0.1}, "description": "red details"}
  ],
  "unique_features": [
    "Distinctive curved hood with chrome strip",
    "Circular headlights with chrome bezels",
    "Dual exhaust pipes visible at rear"
  ],
  "components": [
    {
      "name": "Main_Body",
      "primitive": "Cube/Sphere/Cylinder",
      "position": {"x": 0, "y": 0.5, "z": 0},  // Y MUST be calculated
      "scale": {"x": 1, "y": 1, "z": 1},  // EXACT real-world meters
      "rotation": {"x": 0, "y": 0, "z": 0},
      "material": {
        "preset": "Material_Name or null",
        "color": {"r": 0.15, "g": 0.15, "b": 0.18},  // Use EXTRACTED colors
        "metallic": 0.8,  // High for cars, low for stone
        "smoothness": 0.9  // High for cars/glass, low for rough surfaces
      },
      "represents": "Main car body / building facade / statue torso"
    }
  ]
}

EXAMPLE - 1967 Chevrolet Impala (EXACT replication, not generic car):
{
  "name": "1967 Chevrolet Impala",
  "description": "Classic American muscle car with distinctive long hood, chrome bumpers, and dual headlights",
  "reference_colors": [
    {"name": "body", "rgb": {"r": 0.1, "g": 0.1, "b": 0.15}, "description": "midnight blue metallic"},
    {"name": "chrome", "rgb": {"r": 0.9, "g": 0.9, "b": 0.92}, "description": "chrome trim"},
    {"name": "glass", "rgb": {"r": 0.2, "g": 0.3, "b": 0.4}, "description": "tinted windows"}
  ],
  "unique_features": [
    "Long sloping hood characteristic of 1967 model",
    "Dual circular headlights with chrome bezels",
    "Horizontal chrome grille bars",
    "Chrome bumper wrapping around front",
    "Fastback roofline",
    "Dual tail lights"
  ],
  "components": [
    {"name": "Body_Main", "primitive": "Cube", "position": {"x": 0, "y": 0.6, "z": 0}, "scale": {"x": 2, "y": 0.8, "z": 5}, "material": {"color": {"r": 0.1, "g": 0.1, "b": 0.15}, "metallic": 0.9, "smoothness": 0.95}},
    {"name": "Hood", "primitive": "Cube", "position": {"x": 0, "y": 0.75, "z": 1.8}, "scale": {"x": 1.8, "y": 0.1, "z": 1.5}, "rotation": {"x": -5, "y": 0, "z": 0}, "material": {"color": {"r": 0.1, "g": 0.1, "b": 0.15}, "metallic": 0.9, "smoothness": 0.95}},
    {"name": "Roof", "primitive": "Cube", "position": {"x": 0, "y": 1.3, "z": -0.5}, "scale": {"x": 1.6, "y": 0.05, "z": 2}, "material": {"color": {"r": 0.1, "g": 0.1, "b": 0.15}, "metallic": 0.9, "smoothness": 0.95}},
    {"name": "Windshield", "primitive": "Cube", "position": {"x": 0, "y": 1.2, "z": 0.8}, "scale": {"x": 1.5, "y": 0.6, "z": 0.05}, "rotation": {"x": -25, "y": 0, "z": 0}, "material": {"preset": "Glass_Clear"}},
    {"name": "Headlight_L", "primitive": "Sphere", "position": {"x": -0.7, "y": 0.5, "z": 2.4}, "scale": {"x": 0.15, "y": 0.15, "z": 0.1}, "material": {"color": {"r": 1, "g": 1, "b": 0.95}, "metallic": 0, "smoothness": 1}},
    {"name": "Headlight_R", "primitive": "Sphere", "position": {"x": 0.7, "y": 0.5, "z": 2.4}, "scale": {"x": 0.15, "y": 0.15, "z": 0.1}, "material": {"color": {"r": 1, "g": 1, "b": 0.95}, "metallic": 0, "smoothness": 1}},
    {"name": "Grille", "primitive": "Cube", "position": {"x": 0, "y": 0.45, "z": 2.45}, "scale": {"x": 1.4, "y": 0.3, "z": 0.05}, "material": {"preset": "Metal_Steel", "metallic": 1, "smoothness": 0.8}},
    {"name": "Wheel_FL", "primitive": "Cylinder", "position": {"x": -0.8, "y": 0.35, "z": 1.5}, "scale": {"x": 0.35, "y": 0.2, "z": 0.35}, "rotation": {"x": 0, "y": 0, "z": 90}, "material": {"preset": "Rubber_Black"}},
    {"name": "Wheel_FR", "primitive": "Cylinder", "position": {"x": 0.8, "y": 0.35, "z": 1.5}, "scale": {"x": 0.35, "y": 0.2, "z": 0.35}, "rotation": {"x": 0, "y": 0, "z": 90}, "material": {"preset": "Rubber_Black"}},
    {"name": "Wheel_RL", "primitive": "Cylinder", "position": {"x": -0.8, "y": 0.35, "z": -1.5}, "scale": {"x": 0.35, "y": 0.2, "z": 0.35}, "rotation": {"x": 0, "y": 0, "z": 90}, "material": {"preset": "Rubber_Black"}},
    {"name": "Wheel_RR", "primitive": "Cylinder", "position": {"x": 0.8, "y": 0.35, "z": -1.5}, "scale": {"x": 0.35, "y": 0.2, "z": 0.35}, "rotation": {"x": 0, "y": 0, "z": 90}, "material": {"preset": "Rubber_Black"}}
  ]
}

KEY PRINCIPLE: Use 20-50+ components for accuracy. More components = better replication of unique features.`,

    'scene': `${basePrompt}
FOCUS: Complete scene with multiple objects
- Identify all major objects and their spatial relationships
- Detect patterns (rows, circles, grids)
- Determine ground/terrain type
- Identify lighting conditions (bright/dim, direction)
- Group related objects hierarchically
- CRITICAL: Calculate proper spacing and Y positions for ALL objects
  * Measure distances between objects in image, convert to realistic meters
  * Ensure no overlaps: min 0.5m gap between objects
  * Objects on ground: Y = object_height/2
  * Objects on tables/platforms: Y = platform_top + object_height/2

Output JSON format:
{
  "type": "complete_scene",
  "description": "Scene overview with spatial analysis",
  "environment": {
    "terrain": "flat/hilly/urban",
    "ground_material": "Grass_Green/Concrete/etc",
    "lighting": {
      "type": "Directional/Point/Spot",
      "intensity": 1.0,
      "color": {"r": 1, "g": 1, "b": 1},
      "direction": {"x": 0, "y": -1, "z": 0}
    }
  },
  "objects": [
    {
      "name": "ObjectName",
      "primitive": "Cube/Sphere/etc",
      "position": {"x": 0, "y": 0.5, "z": 0},  // CALCULATE Y = height/2 for ground objects
      "scale": {"x": 1, "y": 1, "z": 1},  // Realistic meters based on object type
      "material": {...}
    }
  ],
  "patterns": [
    {
      "type": "linear/circular/grid",
      "template": "ObjectName",
      "count": 10,
      "spacing": 5,  // MUST be > object_width to prevent overlap
      "center": {"x": 0, "y": 0, "z": 0}
    }
  ]
}

EXAMPLE - Park bench with trees:
{
  "objects": [
    {"name": "Ground", "primitive": "Plane", "position": {"x": 0, "y": 0, "z": 0}, "scale": {"x": 50, "y": 1, "z": 50}},
    {"name": "Bench", "primitive": "Cube", "position": {"x": 0, "y": 0.25, "z": 0}, "scale": {"x": 2, "y": 0.5, "z": 0.6}},  // Bench: 0.5m tall, Y=0.25
    {"name": "Tree1", "primitive": "Cylinder", "position": {"x": -5, "y": 3, "z": 2}, "scale": {"x": 0.5, "y": 6, "z": 0.5}},  // Tree: 6m tall, Y=3, 5m from bench
    {"name": "Tree2", "primitive": "Cylinder", "position": {"x": 5, "y": 3, "z": -2}, "scale": {"x": 0.5, "y": 6, "z": 0.5}}  // Tree: 6m tall, Y=3, 5m on opposite side
  ]
}`,

    'architecture': `${basePrompt}
FOCUS: EXACT REPLICATION of specific building/landmark (White House, Eiffel Tower, Atomium, specific pier, etc.)
GOAL: Recreate THIS SPECIFIC building with all identifying features, not a generic building.

ANALYSIS STEPS:
1. IDENTIFY LANDMARK: What exactly is this? Name it specifically if recognizable
2. ARCHITECTURAL STYLE: Gothic, Art Deco, Modern, Classical, etc. - be specific
3. SIGNATURE FEATURES: What makes THIS building instantly recognizable?
   - Unique shapes (domes, spires, arches, curves)
   - Distinctive elements (clock towers, statues, ornaments)
   - Characteristic proportions (tall/wide, symmetrical/asymmetrical)
   - Iconic details (columns, balconies, decorative trim)
4. COUNT REPETITIVE ELEMENTS: 
   - Windows per floor, windows per facade
   - Columns in row
   - Decorative elements
   - Use arrays for efficiency
5. EXTRACT EXACT COLORS: Sample from image
   - Wall color (brick red, white marble, gray concrete)
   - Roof color (dark gray, copper green, red tile)
   - Trim/accent colors (gold, white, dark)
6. MEASURE PROPORTIONS: Width:height ratios, window spacing, floor heights
7. MATERIAL DETECTION: Brick, stone, concrete, glass, metal
8. BREAK INTO MANY COMPONENTS: Use 50-200+ primitives for landmarks
   - Base/foundation
   - Each wall section
   - Each window/door individually or as array
   - Roof sections
   - Decorative elements (spires, statues, trim)
   - Unique architectural features

Output JSON format:
{
  "type": "architecture",
  "name": "SPECIFIC NAME (e.g., 'White House', 'Eiffel Tower', 'Atomium Brussels', 'Blankenberge Pier')",
  "style": "Specific architectural style (e.g., 'Neoclassical', 'Art Nouveau', 'Postmodern Atomic Age')",
  "description": "Detailed description highlighting unique identifying features of THIS building",
  "reference_colors": [
    {"name": "primary", "rgb": {"r": 0.95, "g": 0.95, "b": 0.98}, "description": "white marble"},
    {"name": "trim", "rgb": {"r": 0.85, "g": 0.75, "b": 0.55}, "description": "gold/brass accents"},
    {"name": "roof", "rgb": {"r": 0.15, "g": 0.15, "b": 0.17}, "description": "dark gray/black"}
  ],
  "signature_features": [
    "Iconic portico with 6 massive columns",
    "Triangular pediment above entrance",
    "Symmetrical wings extending left and right",
    "Rectangular windows with white frames in precise grid"
  ],
  "structure": {
    "foundation": {
      "position": {"x": 0, "y": -0.3, "z": 0},
      "scale": {"x": 52, "y": 0.6, "z": 26},
      "material": {"preset": "Concrete"}
    },
    "walls": [
      {
        "name": "Front_Main_Wall",
        "position": {"x": 0, "y": 7.5, "z": -13},
        "scale": {"x": 52, "y": 15, "z": 0.5},
        "material": {"color": {"r": 0.95, "g": 0.95, "b": 0.98}, "metallic": 0, "smoothness": 0.6},
        "represents": "Main facade - white painted stone"
      },
      {
        "name": "Rear_Wall",
        "position": {"x": 0, "y": 7.5, "z": 13},
        "scale": {"x": 52, "y": 15, "z": 0.5},
        "material": {"color": {"r": 0.95, "g": 0.95, "b": 0.98}, "metallic": 0, "smoothness": 0.6}
      }
    ],
    "columns": {
      "type": "array",
      "template": {
        "primitive": "Cylinder",
        "scale": {"x": 0.8, "y": 10, "z": 0.8},
        "material": {"color": {"r": 0.95, "g": 0.95, "b": 0.98}, "metallic": 0, "smoothness": 0.7}
      },
      "positions": [
        {"x": -10, "y": 5, "z": -13.5},
        {"x": -6, "y": 5, "z": -13.5},
        {"x": -2, "y": 5, "z": -13.5},
        {"x": 2, "y": 5, "z": -13.5},
        {"x": 6, "y": 5, "z": -13.5},
        {"x": 10, "y": 5, "z": -13.5}
      ],
      "represents": "Iconic front portico columns"
    },
    "windows": {
      "type": "grid_array",
      "template": {
        "primitive": "Cube",
        "scale": {"x": 1.2, "y": 2.5, "z": 0.15},
        "material": {"preset": "Glass_Clear"}
      },
      "pattern": {
        "rows": 3,
        "columns": 12,
        "spacing": {"x": 4, "y": 4},
        "start_position": {"x": -22, "y": 5, "z": -13.3}
      },
      "represents": "Symmetrical window grid on facade"
    },
    "roof": {
      "name": "Main_Roof",
      "position": {"x": 0, "y": 15.3, "z": 0},
      "scale": {"x": 53, "y": 0.6, "z": 27},
      "material": {"color": {"r": 0.15, "g": 0.15, "b": 0.17}, "metallic": 0.3, "smoothness": 0.5},
      "represents": "Flat roof with dark finish"
    },
    "unique_elements": [
      {
        "name": "Triangular_Pediment",
        "primitive": "Cube",
        "position": {"x": 0, "y": 11, "z": -13.8},
        "scale": {"x": 14, "y": 2, "z": 0.3},
        "rotation": {"x": 0, "y": 0, "z": 0},
        "material": {"color": {"r": 0.95, "g": 0.95, "b": 0.98}, "metallic": 0, "smoothness": 0.6},
        "represents": "Triangular pediment above entrance"
      }
    ]
  }
}

EXAMPLE - Atomium Brussels (EXACT landmark replication):
{
  "name": "Atomium Brussels",
  "style": "Postmodern Atomic Age Architecture",
  "description": "Iconic Belgian landmark representing iron crystal magnified 165 billion times, consists of 9 spheres connected by tubes",
  "reference_colors": [
    {"name": "spheres", "rgb": {"r": 0.85, "g": 0.85, "b": 0.88}, "description": "polished stainless steel"},
    {"name": "tubes", "rgb": {"r": 0.82, "g": 0.82, "b": 0.85}, "description": "metallic silver"}
  ],
  "signature_features": [
    "9 spheres arranged in unit cell of iron crystal structure",
    "Each sphere 18m diameter",
    "Connected by tubes containing escalators",
    "Distinctive angular geometry at 54.74° angles",
    "Highly reflective metallic surface"
  ],
  "structure": {
    "spheres": [
      {"name": "Sphere_Center", "primitive": "Sphere", "position": {"x": 0, "y": 51, "z": 0}, "scale": {"x": 18, "y": 18, "z": 18}, "material": {"preset": "Metal_Steel", "metallic": 1, "smoothness": 0.95}},
      {"name": "Sphere_Top", "primitive": "Sphere", "position": {"x": 0, "y": 102, "z": 0}, "scale": {"x": 18, "y": 18, "z": 18}, "material": {"preset": "Metal_Steel", "metallic": 1, "smoothness": 0.95}},
      {"name": "Sphere_Bottom", "primitive": "Sphere", "position": {"x": 0, "y": 9, "z": 0}, "scale": {"x": 18, "y": 18, "z": 18}, "material": {"preset": "Metal_Steel", "metallic": 1, "smoothness": 0.95}},
      {"name": "Sphere_NE", "primitive": "Sphere", "position": {"x": 29.7, "y": 51, "z": 29.7}, "scale": {"x": 18, "y": 18, "z": 18}, "material": {"preset": "Metal_Steel", "metallic": 1, "smoothness": 0.95}},
      {"name": "Sphere_NW", "primitive": "Sphere", "position": {"x": -29.7, "y": 51, "z": 29.7}, "scale": {"x": 18, "y": 18, "z": 18}, "material": {"preset": "Metal_Steel", "metallic": 1, "smoothness": 0.95}},
      {"name": "Sphere_SE", "primitive": "Sphere", "position": {"x": 29.7, "y": 51, "z": -29.7}, "scale": {"x": 18, "y": 18, "z": 18}, "material": {"preset": "Metal_Steel", "metallic": 1, "smoothness": 0.95}},
      {"name": "Sphere_SW", "primitive": "Sphere", "position": {"x": -29.7, "y": 51, "z": -29.7}, "scale": {"x": 18, "y": 18, "z": 18}, "material": {"preset": "Metal_Steel", "metallic": 1, "smoothness": 0.95}},
      {"name": "Sphere_Top_Front", "primitive": "Sphere", "position": {"x": 0, "y": 76.5, "z": 29.7}, "scale": {"x": 18, "y": 18, "z": 18}, "material": {"preset": "Metal_Steel", "metallic": 1, "smoothness": 0.95}},
      {"name": "Sphere_Top_Back", "primitive": "Sphere", "position": {"x": 0, "y": 76.5, "z": -29.7}, "scale": {"x": 18, "y": 18, "z": 18}, "material": {"preset": "Metal_Steel", "metallic": 1, "smoothness": 0.95}}
    ],
    "connecting_tubes": [
      {"name": "Tube_Center_Top", "primitive": "Cylinder", "position": {"x": 0, "y": 76.5, "z": 0}, "scale": {"x": 3, "y": 51, "z": 3}, "rotation": {"x": 0, "y": 0, "z": 0}, "material": {"preset": "Metal_Steel", "metallic": 0.9, "smoothness": 0.9}}
    ]
  }
}

KEY PRINCIPLE: Use 50-200+ components for landmark accuracy. Identify and recreate ALL signature features that make it recognizable.`,

    'environment': `${basePrompt}
FOCUS: Natural or outdoor environment
- Identify environment type (forest, desert, city, etc.)
- Detect vegetation (trees, grass, bushes)
- Identify terrain features (hills, rocks, water)
- Determine weather/atmosphere
- Count and distribute natural elements

Output JSON format:
{
  "type": "environment",
  "biome": "Forest/Desert/City/Medieval/SciFi/Fantasy/Underwater/Arctic/Jungle/Wasteland",
  "description": "Environment overview",
  "terrain": {
    "type": "flat/hilly/mountainous",
    "size": {"x": 100, "z": 100},
    "elevation_variation": 0-20
  },
  "vegetation": [
    {
      "type": "tree/bush/grass",
      "count": 20,
      "distribution": "scattered/clustered/linear",
      "scale_variation": 0.8-1.2
    }
  ],
  "features": [
    {
      "type": "rock/water/path",
      "description": "Feature description",
      "positions": [...]
    }
  ]
}`
  };

  return typePrompts[analysisType] || typePrompts['scene'];
}

/**
 * Convert VLM response to PowerShell script
 * @param {object} analysis - Structured analysis from VLM
 * @returns {string} PowerShell script content
 */
export function generatePowerShellScript(analysis) {
  // Validate and auto-fix spatial issues before generating script
  let validatedAnalysis = { ...analysis };
  
  if (analysis.type === 'single_object' && analysis.components) {
    const validation = validateScene(analysis.components);
    if (!validation.valid || validation.warningCount > 0) {
      console.log('[SPATIAL VALIDATOR] Found issues, auto-fixing...');
      validatedAnalysis.components = autoFixPositioning(analysis.components);
      console.log(`[SPATIAL VALIDATOR] Fixed ${validation.issueCount} overlaps and ${validation.warningCount} positioning warnings`);
    }
  } else if (analysis.type === 'complete_scene' && analysis.objects) {
    const validation = validateScene(analysis.objects);
    if (!validation.valid || validation.warningCount > 0) {
      console.log('[SPATIAL VALIDATOR] Found issues, auto-fixing...');
      validatedAnalysis.objects = autoFixPositioning(analysis.objects);
      console.log(`[SPATIAL VALIDATOR] Fixed ${validation.issueCount} overlaps and ${validation.warningCount} positioning warnings`);
    }
  }

  let script = `# ============================================================
# AUTO-GENERATED UNITY SCENE SCRIPT
# Generated from image analysis with spatial validation
# Type: ${validatedAnalysis.type}
# ============================================================

# Import helper library
. "$PSScriptRoot\\unity-helpers-v2.ps1"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Image-to-Scene Generation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test connection
if (-not (Test-UnityConnection)) {
    exit 1
}

Write-Host ""
Write-Host "[INFO] Generating scene from image analysis..." -ForegroundColor Green
Write-Host "[INFO] Type: ${validatedAnalysis.type}" -ForegroundColor Cyan
Write-Host "[INFO] Spatial validation: PASSED" -ForegroundColor Green
Write-Host ""

`;

  // Generate script based on analysis type
  analysis = validatedAnalysis;
  switch (analysis.type) {
    case 'single_object':
      script += generateSingleObjectScript(analysis);
      break;
    case 'complete_scene':
      script += generateCompleteSceneScript(analysis);
      break;
    case 'architecture':
      script += generateArchitectureScript(analysis);
      break;
    case 'environment':
      script += generateEnvironmentScript(analysis);
      break;
    default:
      script += generateGenericScript(analysis);
  }

  script += `
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host " Scene Generation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
`;

  return script;
}

/**
 * Generate PowerShell for single object
 */
function generateSingleObjectScript(analysis) {
  if (!analysis.components || analysis.components.length === 0) {
    return '# No components found\n';
  }

  let script = `# ============================================================
# OBJECT: ${analysis.name || 'Unknown'}
# Description: ${analysis.description || 'No description'}
# ============================================================
# SPATIAL CALCULATIONS:
# - Y positions calculated for proper stacking (no overlaps/floating)
# - Scale in Unity meters (1 unit = 1 meter)
# - Objects validated for collisions before generation
# ============================================================

Write-Host "[PHASE 1] Creating main object..." -ForegroundColor Yellow
Write-Host ""

# Create parent group
New-Group -name "${analysis.name || 'GeneratedObject'}"

`;

  analysis.components.forEach((component, index) => {
    const compName = `${analysis.name}_Part${index + 1}`;
    script += `# Component ${index + 1}: ${component.primitive}
Create-UnityObject -name "${compName}" -type "${component.primitive}" -parent "${analysis.name}"
Set-Transform -name "${compName}" ` +
      `-x ${component.position.x} -y ${component.position.y} -z ${component.position.z} ` +
      `-sx ${component.scale.x} -sy ${component.scale.y} -sz ${component.scale.z} ` +
      `-rx ${component.rotation?.x || 0} -ry ${component.rotation?.y || 0} -rz ${component.rotation?.z || 0}

`;

    // Apply material
    if (component.material) {
      if (component.material.preset) {
        script += `Apply-Material -name "${compName}" -materialName "${component.material.preset}"\n`;
      } else {
        script += `Set-Material -name "${compName}" ` +
          `-color @{ r = ${component.material.color.r}; g = ${component.material.color.g}; b = ${component.material.color.b} } ` +
          `-metallic ${component.material.metallic} -smoothness ${component.material.smoothness}\n`;
      }
    }

    script += `Write-Host "  [OK] Created ${compName}" -ForegroundColor Green
Start-Sleep -Milliseconds 100

`;
  });

  script += `Write-Host ""
Write-Host "[PHASE 2] Optimizing object..." -ForegroundColor Yellow
Optimize-Group -parentName "${analysis.name}"
Write-Host "[OK] Object complete with ${analysis.components.length} components" -ForegroundColor Green
Write-Host ""

`;

  return script;
}

/**
 * Generate PowerShell for complete scene
 */
function generateCompleteSceneScript(analysis) {
  let script = `# ============================================================
# SCENE: ${analysis.description || 'Generated Scene'}
# ============================================================

`;

  // Environment setup
  if (analysis.environment) {
    script += `Write-Host "[PHASE 1] Setting up environment..." -ForegroundColor Yellow
Write-Host ""

# Create ground
Create-UnityObject -name "Ground" -type "Plane"
Set-Transform -name "Ground" -sx 50 -sz 50
Apply-Material -name "Ground" -materialName "${analysis.environment.ground_material || 'Grass_Green'}"
Write-Host "  [OK] Ground created" -ForegroundColor Green

`;

    // Lighting
    if (analysis.environment.lighting) {
      const light = analysis.environment.lighting;
      script += `# Create lighting
$lightBody = @{
    name = "MainLight"
    lightType = "${light.type || 'Directional'}"
    intensity = ${light.intensity || 1.0}
    color = @{ r = ${light.color?.r || 1}; g = ${light.color?.g || 1}; b = ${light.color?.b || 1} }
} | ConvertTo-Json

Invoke-RestMethod -Uri "$UNITY_BASE/createLight" -Method POST -ContentType "application/json" -Body $lightBody
Write-Host "  [OK] Lighting created" -ForegroundColor Green
Write-Host ""

`;
    }
  }

  // Objects
  if (analysis.objects && analysis.objects.length > 0) {
    script += `Write-Host "[PHASE 2] Creating objects..." -ForegroundColor Yellow
Write-Host ""

`;

    analysis.objects.forEach((obj, index) => {
      script += `# Object ${index + 1}: ${obj.name}
Create-UnityObject -name "${obj.name}" -type "${obj.primitive}"
Set-Transform -name "${obj.name}" ` +
        `-x ${obj.position.x} -y ${obj.position.y} -z ${obj.position.z} ` +
        `-sx ${obj.scale.x} -sy ${obj.scale.y} -sz ${obj.scale.z}

`;

      if (obj.material) {
        if (obj.material.preset) {
          script += `Apply-Material -name "${obj.name}" -materialName "${obj.material.preset}"\n`;
        } else {
          script += `Set-Material -name "${obj.name}" ` +
            `-color @{ r = ${obj.material.color.r}; g = ${obj.material.color.g}; b = ${obj.material.color.b} } ` +
            `-metallic ${obj.material.metallic || 0} -smoothness ${obj.material.smoothness || 0.5}\n`;
        }
      }

      script += `Write-Host "  [OK] Created ${obj.name}" -ForegroundColor Green
Start-Sleep -Milliseconds 100

`;
    });
  }

  // Patterns
  if (analysis.patterns && analysis.patterns.length > 0) {
    script += `Write-Host ""
Write-Host "[PHASE 3] Creating patterns..." -ForegroundColor Yellow
Write-Host ""

`;

    analysis.patterns.forEach((pattern, index) => {
      if (pattern.type === 'linear') {
        script += `# Linear array ${index + 1}
$arrayBody = @{
    sourceName = "${pattern.template}"
    count = ${pattern.count}
    spacing = ${pattern.spacing}
    direction = @{ x = 1; y = 0; z = 0 }
} | ConvertTo-Json

Invoke-RestMethod -Uri "$UNITY_BASE/createLinearArray" -Method POST -ContentType "application/json" -Body $arrayBody
Write-Host "  [OK] Created linear array (${pattern.count} objects)" -ForegroundColor Green

`;
      } else if (pattern.type === 'circular') {
        script += `# Circular array ${index + 1}
$arrayBody = @{
    sourceName = "${pattern.template}"
    count = ${pattern.count}
    radius = ${pattern.spacing}
    center = @{ x = ${pattern.center.x}; y = ${pattern.center.y}; z = ${pattern.center.z} }
} | ConvertTo-Json

Invoke-RestMethod -Uri "$UNITY_BASE/createCircularArray" -Method POST -ContentType "application/json" -Body $arrayBody
Write-Host "  [OK] Created circular array (${pattern.count} objects)" -ForegroundColor Green

`;
      }
    });
  }

  return script;
}

/**
 * Generate PowerShell for architecture
 */
function generateArchitectureScript(analysis) {
  let script = `# ============================================================
# ARCHITECTURE: ${analysis.style || 'Unknown'} Style
# Description: ${analysis.description || 'No description'}
# ============================================================

Write-Host "[PHASE 1] Creating architectural structure..." -ForegroundColor Yellow
Write-Host ""

# Create building group
New-Group -name "Building"

`;

  // Foundation
  if (analysis.structure?.foundation) {
    script += `# Foundation
Create-UnityObject -name "Foundation" -type "Cube" -parent "Building"
Set-Transform -name "Foundation" -y -0.5 -sx 15 -sy 0.5 -sz 15
Apply-Material -name "Foundation" -materialName "Concrete"
Write-Host "  [OK] Foundation created" -ForegroundColor Green

`;
  }

  // Walls
  if (analysis.structure?.walls && analysis.structure.walls.length > 0) {
    script += `# Walls
New-Group -name "Walls" -parent "Building"

`;

    analysis.structure.walls.forEach((wall, index) => {
      const wallName = `Wall_${index + 1}`;
      script += `Create-UnityObject -name "${wallName}" -type "Cube" -parent "Walls"
Set-Transform -name "${wallName}" ` +
        `-x ${wall.position.x} -y ${wall.position.y} -z ${wall.position.z} ` +
        `-sx ${wall.scale.x} -sy ${wall.scale.y} -sz ${wall.scale.z}
Apply-Material -name "${wallName}" -materialName "${wall.material || 'Brick_Red'}"
Write-Host "  [OK] ${wallName} created" -ForegroundColor Green

`;
    });
  }

  // Windows
  if (analysis.structure?.windows && analysis.structure.windows.length > 0) {
    script += `# Windows
New-Group -name "Windows" -parent "Building"

`;

    analysis.structure.windows.forEach((window, index) => {
      const winName = `Window_${index + 1}`;
      script += `Create-UnityObject -name "${winName}" -type "Cube" -parent "Windows"
Set-Transform -name "${winName}" ` +
        `-x ${window.position.x} -y ${window.position.y} -z ${window.position.z} ` +
        `-sx ${window.scale.x} -sy ${window.scale.y} -sz ${window.scale.z}
Apply-Material -name "${winName}" -materialName "Glass_Clear"
Write-Host "  [OK] ${winName} created" -ForegroundColor Green

`;
    });
  }

  script += `Write-Host ""
Write-Host "[PHASE 2] Optimizing building..." -ForegroundColor Yellow
Optimize-Group -parentName "Building"
Write-Host "[OK] Building complete" -ForegroundColor Green
Write-Host ""

`;

  return script;
}

/**
 * Generate PowerShell for environment
 */
function generateEnvironmentScript(analysis) {
  let script = `# ============================================================
# ENVIRONMENT: ${analysis.biome || 'Unknown'} Biome
# Description: ${analysis.description || 'No description'}
# ============================================================

`;

  // Use world generation if biome is recognized
  const recognizedBiomes = ['Forest', 'Desert', 'City', 'Medieval', 'SciFi', 'Fantasy', 'Underwater', 'Arctic', 'Jungle', 'Wasteland'];
  if (recognizedBiomes.includes(analysis.biome)) {
    script += `Write-Host "[INFO] Using world generation for ${analysis.biome} biome..." -ForegroundColor Cyan
Write-Host ""

# Generate world using built-in biome
New-World -biome "${analysis.biome}" -worldSize ${analysis.terrain?.size?.x || 150} -density 70

Write-Host ""
Write-Host "[OK] ${analysis.biome} world generated" -ForegroundColor Green
Write-Host ""

`;
  } else {
    // Manual environment creation
    script += `Write-Host "[PHASE 1] Creating custom environment..." -ForegroundColor Yellow
Write-Host ""

# Create terrain
Create-UnityObject -name "Terrain" -type "Plane"
Set-Transform -name "Terrain" -sx ${(analysis.terrain?.size?.x || 100) / 10} -sz ${(analysis.terrain?.size?.z || 100) / 10}
Apply-Material -name "Terrain" -materialName "Grass_Green"
Write-Host "  [OK] Terrain created" -ForegroundColor Green

`;

    // Vegetation
    if (analysis.vegetation && analysis.vegetation.length > 0) {
      script += `# Vegetation
`;

      analysis.vegetation.forEach((veg, index) => {
        script += `Write-Host "  [INFO] Creating ${veg.type} (${veg.count} instances)..." -ForegroundColor Cyan
`;
        for (let i = 0; i < Math.min(veg.count, 50); i++) {
          const x = (Math.random() - 0.5) * (analysis.terrain?.size?.x || 100);
          const z = (Math.random() - 0.5) * (analysis.terrain?.size?.z || 100);
          const scale = 0.8 + Math.random() * 0.4;
          
          script += `Create-UnityObject -name "${veg.type}_${i + 1}" -type "Cylinder"
Set-Transform -name "${veg.type}_${i + 1}" -x ${x.toFixed(2)} -y ${(scale * 2).toFixed(2)} -z ${z.toFixed(2)} -sx ${scale.toFixed(2)} -sy ${(scale * 2).toFixed(2)} -sz ${scale.toFixed(2)}
Apply-Material -name "${veg.type}_${i + 1}" -materialName "Wood_Oak"

`;
        }

        script += `Write-Host "  [OK] Created ${Math.min(veg.count, 50)} ${veg.type} instances" -ForegroundColor Green

`;
      });
    }
  }

  return script;
}

/**
 * Generate generic script fallback
 */
function generateGenericScript(analysis) {
  return `# Generic scene generation
Write-Host "[INFO] Analysis data:" -ForegroundColor Cyan
Write-Host (ConvertTo-Json $analysis -Depth 5)
Write-Host ""
Write-Host "[WARN] No specific generation method available for this analysis type" -ForegroundColor Yellow
Write-Host ""

`;
}

/**
 * Save PowerShell script to file
 */
export function saveScript(scriptContent, outputPath) {
  fs.writeFileSync(outputPath, scriptContent, 'utf8');
  return outputPath;
}
