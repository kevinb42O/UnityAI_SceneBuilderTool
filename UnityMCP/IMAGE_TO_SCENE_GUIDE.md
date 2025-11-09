# Image-to-Scene Generation Guide

**Transform any image into a Unity 3D scene in minutes**

---

## 🎯 Overview

The Image-to-Scene system uses **Vision Language Models (VLM)** to analyze images and automatically generate Unity scenes. Upload a photo, drawing, or concept art, and get an executable PowerShell script that recreates it in 3D.

### What Can Be Generated

- ✅ **Single Objects** - Statues, furniture, vehicles, props
- ✅ **Complete Scenes** - Rooms, outdoor areas, landscapes
- ✅ **Architecture** - Buildings, houses, monuments, temples
- ✅ **Environments** - Forests, deserts, cities, natural landscapes

---

## 🚀 Quick Start

### Prerequisites

1. Unity 2021.3+ with MCP Server running
2. PowerShell (Windows) or compatible shell
3. Access to VLM (Claude 3.5 Sonnet or GPT-4V)
4. Image file (.jpg, .png, .gif, .webp)

### Basic Workflow

```powershell
# Navigate to UnityMCP directory
cd UnityMCP

# Start the process
.\image-to-scene.ps1 -ImagePath "path\to\your\image.jpg"

# Follow the prompts to:
# 1. Copy the generated VLM prompt
# 2. Submit to Claude/GPT-4V with your image
# 3. Save the JSON response
# 4. Generate and execute the scene script
```

---

## 📋 Complete Workflow

### Step 1: Prepare Your Image

**Best Results With:**
- Clear, well-lit images
- Simple compositions for first attempts
- Architectural references (buildings, structures)
- Objects with clear shapes
- Scene layouts with visible spatial relationships

**Image Requirements:**
- Format: JPG, PNG, GIF, WEBP
- Size: Any (will be optimized)
- Resolution: Higher is better for detail detection

### Step 2: Start Analysis

```powershell
.\image-to-scene.ps1 `
    -ImagePath "C:\Users\You\Pictures\statue.jpg" `
    -AnalysisType "object" `
    -DetailLevel 7
```

**Analysis Types:**
- `object` - Single object or statue (best for isolated subjects)
- `scene` - Complete scene with multiple objects (default)
- `architecture` - Buildings and structures (detects walls, windows, doors)
- `environment` - Natural landscapes (forests, deserts, etc.)

**Detail Levels (1-10):**
- 1-3: Minimal - Basic shapes only
- 4-6: Medium - Good balance (recommended for first attempts)
- 7-9: High - More objects and details
- 10: Maximum - Every visible element

### Step 3: VLM Analysis

The script will output a specialized prompt. Copy it and follow these steps:

#### Option A: Claude 3.5 Sonnet (Recommended)

1. Go to [claude.ai](https://claude.ai)
2. Start a new conversation
3. Click the attachment icon and upload your image
4. Paste the generated prompt
5. Wait for Claude to analyze and return JSON
6. Copy the JSON response

#### Option B: ChatGPT with GPT-4V

1. Go to [chat.openai.com](https://chat.openai.com)
2. Ensure you're using GPT-4 with vision
3. Upload your image
4. Paste the generated prompt
5. Copy the JSON response

### Step 4: Generate Scene Script

Save the VLM JSON response to a file (e.g., `analysis.json`), then:

```powershell
.\generate-scene-from-json.ps1 -JsonPath "analysis.json" -Execute
```

The script will:
1. Parse the VLM analysis
2. Generate optimized PowerShell code
3. Execute the scene creation in Unity
4. Organize objects hierarchically
5. Apply materials and optimization

### Step 5: Review and Iterate

Check the Unity scene. If needed:
- Adjust materials manually
- Fine-tune object positions
- Combine meshes for performance
- Add lighting and effects

---

## 🎨 Examples

### Example 1: Simple Statue

**Input Image:** Photo of a marble statue

```powershell
.\image-to-scene.ps1 `
    -ImagePath "statue.jpg" `
    -AnalysisType "object" `
    -DetailLevel 5
```

**Expected VLM Output:**
```json
{
  "type": "single_object",
  "name": "MarbleStatue",
  "description": "Classical marble statue on pedestal",
  "components": [
    {
      "primitive": "Cylinder",
      "position": {"x": 0, "y": 0.5, "z": 0},
      "scale": {"x": 1.5, "y": 1, "z": 1.5},
      "material": {
        "preset": "Stone_Gray",
        "metallic": 0,
        "smoothness": 0.7
      }
    },
    {
      "primitive": "Cube",
      "position": {"x": 0, "y": 2, "z": 0},
      "scale": {"x": 1, "y": 2, "z": 0.5},
      "material": {
        "preset": "Stone_Gray",
        "metallic": 0,
        "smoothness": 0.7
      }
    }
  ]
}
```

**Result:** 2-component statue with pedestal in ~5 seconds

### Example 2: Room Interior

**Input Image:** Photo of a bedroom

```powershell
.\image-to-scene.ps1 `
    -ImagePath "bedroom.jpg" `
    -AnalysisType "scene" `
    -DetailLevel 6
```

**Expected VLM Output:**
```json
{
  "type": "complete_scene",
  "description": "Modern bedroom interior",
  "environment": {
    "terrain": "flat",
    "ground_material": "Wood_Oak",
    "lighting": {
      "type": "Point",
      "intensity": 1.5,
      "color": {"r": 1, "g": 0.95, "b": 0.9}
    }
  },
  "objects": [
    {
      "name": "Bed",
      "primitive": "Cube",
      "position": {"x": 0, "y": 0.5, "z": -3},
      "scale": {"x": 4, "y": 1, "z": 5},
      "material": {"preset": "Wood_Oak"}
    },
    {
      "name": "Nightstand",
      "primitive": "Cube",
      "position": {"x": 3, "y": 0.5, "z": -3},
      "scale": {"x": 1, "y": 1, "z": 1},
      "material": {"preset": "Wood_Oak"}
    }
  ]
}
```

**Result:** Room with furniture and lighting in ~15 seconds

### Example 3: Building Exterior

**Input Image:** Photo of a house

```powershell
.\image-to-scene.ps1 `
    -ImagePath "house.jpg" `
    -AnalysisType "architecture" `
    -DetailLevel 7
```

**Expected VLM Output:**
```json
{
  "type": "architecture",
  "style": "Modern",
  "description": "Two-story suburban house",
  "structure": {
    "walls": [
      {
        "position": {"x": 0, "y": 2.5, "z": 0},
        "scale": {"x": 10, "y": 5, "z": 0.3},
        "material": "Brick_Red"
      },
      {
        "position": {"x": 0, "y": 2.5, "z": 8},
        "scale": {"x": 10, "y": 5, "z": 0.3},
        "material": "Brick_Red"
      }
    ],
    "windows": [
      {
        "position": {"x": 2, "y": 2, "z": 0.2},
        "scale": {"x": 1.5, "y": 2, "z": 0.1}
      }
    ],
    "roof": {
      "type": "gabled",
      "material": "Stone_Gray"
    }
  }
}
```

**Result:** Building structure with walls and windows in ~20 seconds

### Example 4: Forest Scene

**Input Image:** Photo of a forest

```powershell
.\image-to-scene.ps1 `
    -ImagePath "forest.jpg" `
    -AnalysisType "environment" `
    -DetailLevel 6
```

**Expected VLM Output:**
```json
{
  "type": "environment",
  "biome": "Forest",
  "description": "Dense forest with scattered trees",
  "terrain": {
    "type": "hilly",
    "size": {"x": 100, "z": 100}
  },
  "vegetation": [
    {
      "type": "tree",
      "count": 30,
      "distribution": "scattered",
      "scale_variation": 0.8-1.2
    }
  ]
}
```

**Result:** Forest biome with 30+ trees in ~10 seconds (uses world generation)

---

## 🔧 Advanced Usage

### Testing Without VLM

For testing the pipeline without VLM access:

```powershell
.\image-to-scene.ps1 `
    -ImagePath "test.jpg" `
    -AnalysisType "object" `
    -UseExampleData
```

This uses built-in example data to demonstrate the workflow.

### Custom Output Path

Specify where to save the generated script:

```powershell
.\image-to-scene.ps1 `
    -ImagePath "image.jpg" `
    -OutputPath "my-custom-scene.ps1"
```

### Batch Processing

Process multiple images:

```powershell
Get-ChildItem "C:\Images\*.jpg" | ForEach-Object {
    .\image-to-scene.ps1 `
        -ImagePath $_.FullName `
        -AnalysisType "object" `
        -DetailLevel 5
}
```

---

## 📊 Expected Results

### Performance Metrics

| Scene Type | Objects Created | Generation Time | Optimization Gain |
|------------|----------------|-----------------|-------------------|
| Single Object | 2-10 | 5-15 seconds | 2-10x |
| Simple Scene | 10-30 | 15-45 seconds | 10-30x |
| Architecture | 20-100 | 30-90 seconds | 20-100x |
| Environment | 50-200+ | 2-10 minutes | 50-200x+ |

### Accuracy Expectations

**High Accuracy (80-95%):**
- Geometric shapes and primitives
- Spatial layouts and positioning
- Basic material properties (color, roughness)
- Object counts and patterns

**Medium Accuracy (60-80%):**
- Complex organic shapes
- Fine details and textures
- Specific architectural styles
- Material variations

**Lower Accuracy (40-60%):**
- Very complex objects
- Specific textures and patterns
- Text and symbols
- Exact proportions

---

## 💡 Tips for Best Results

### Image Selection

✅ **Good Images:**
- Clear, well-lit reference photos
- Simple compositions with distinct objects
- Architectural drawings with clean lines
- Concept art with clear shapes

❌ **Challenging Images:**
- Blurry or dark photos
- Cluttered scenes with many overlapping objects
- Complex organic shapes
- Photos with heavy perspective distortion

### Analysis Type Selection

Choose based on image content:
- **Buildings/Structures** → `architecture`
- **Single Object** → `object`
- **Outdoor Nature** → `environment`
- **Everything Else** → `scene`

### Detail Level Guidelines

Start lower and increase if needed:
- First attempt: 5
- Too simple: Increase to 7-8
- Too complex: Decrease to 3-4
- Maximum detail: 9-10 (may be overwhelming)

### VLM Prompting

For better results, you can add context to the VLM:
```
[Paste generated prompt]

Additional context:
- This is a [describe object/scene]
- Focus on [specific aspects]
- The scale should be approximately [size reference]
```

---

## 🐛 Troubleshooting

### Issue: VLM Returns Invalid JSON

**Solution:**
1. Ask the VLM to "fix the JSON formatting"
2. Use an online JSON validator
3. Manually correct bracket/comma errors
4. Try a different VLM (Claude vs GPT-4V)

### Issue: Objects Too Small/Large

**Solution:**
1. Edit the generated script before execution
2. Multiply all scale values by a constant
3. Adjust in Unity after generation
4. Re-prompt VLM with size reference: "The main object should be approximately 2 meters tall"

### Issue: Materials Not Matching Image

**Solution:**
1. The VLM can only use preset materials
2. Edit the generated script to add custom materials
3. Or apply materials manually in Unity after generation
4. Use `Set-Material` with custom color/metallic/smoothness values

### Issue: Scene Too Complex

**Solution:**
1. Reduce `DetailLevel` to 3-4
2. Simplify the input image
3. Break scene into multiple images (foreground, background)
4. Focus on specific areas with cropped images

### Issue: Unity Server Not Responding

**Solution:**
1. Check Unity is running
2. Verify MCP server is started: `Tools > Unity MCP > Start Server`
3. Test connection: `Test-UnityConnection`
4. Restart Unity if needed

---

## 🎓 Understanding VLM Limitations

### What VLMs Can See

- **Shapes and geometry** - Excellent
- **Colors and materials** - Very good
- **Spatial relationships** - Good
- **Object counts** - Good for <20 objects
- **Patterns and repetition** - Excellent

### What VLMs Struggle With

- **Exact dimensions** - Use reference objects
- **Fine details** - Simplify or specify
- **Text and symbols** - Ignore or describe separately
- **Exact colors** - Use preset materials
- **Complex textures** - Use solid colors

### Working With These Limitations

1. **Simplify expectations** - Aim for approximate recreation, not pixel-perfect
2. **Focus on structure** - Get the layout right, refine details later
3. **Use iteration** - Generate, review, adjust, regenerate
4. **Manual refinement** - Let VLM do 80%, you do the final 20%

---

## 📁 File Organization

Generated files structure:
```
UnityMCP/
├── image-to-scene.ps1              # Main CLI tool
├── generate-scene-from-json.ps1    # JSON-to-script converter
├── image-analyzer.js               # VLM integration (Node.js)
├── image-analysis-prompt.txt       # Last generated prompt
├── generated-scene-[timestamp].ps1 # Generated scene scripts
└── analysis.json                   # VLM response (user-provided)
```

---

## 🔄 Integration with Existing Tools

### Combining with World Generation

```powershell
# Generate environment from image
.\image-to-scene.ps1 -ImagePath "landscape.jpg" -AnalysisType "environment"

# Then add custom buildings/objects
.\Building21.ps1

# Or add vegetation
.\add-epic-forest.ps1
```

### Using Material Library

Generated scripts use the 14-preset material library:
- Wood_Oak
- Metal_Steel, Metal_Gold, Metal_Bronze
- Glass_Clear
- Brick_Red
- Concrete, Stone_Gray
- Grass_Green, Water_Blue
- Rubber_Black, Plastic_White
- Emissive_Blue, Emissive_Red

### Performance Optimization

All generated scripts include optimization:
```powershell
Optimize-Group -parentName "GeneratedObjects"
```

This combines meshes for 60x+ performance improvement.

---

## 🚀 Next Steps

After generating your first scene:

1. **Experiment with detail levels** - Find what works for your images
2. **Try different analysis types** - See which captures your intent best
3. **Combine multiple images** - Foreground + background + details
4. **Refine in Unity** - Manual adjustments for perfection
5. **Save as templates** - Reuse successful patterns

---

## 📞 Support

**Issues:**
- VLM access: Use Claude 3.5 Sonnet (free tier available)
- JSON errors: Use online validators, ask VLM to fix
- Unity connection: Restart Unity, check MCP server status

**Resources:**
- [V2_DOCUMENTATION.md](V2_DOCUMENTATION.md) - Complete API reference
- [CURRENT_BUILDING_BLOCKS.md](CURRENT_BUILDING_BLOCKS.md) - Tool capabilities
- [UNITY_MCP_CREATION_GUIDE.md](UNITY_MCP_CREATION_GUIDE.md) - Technical details

---

## ✨ The Vision

**Goal:** Upload any image → Get a Unity scene in minutes

**Current Status:** ✅ Working with VLM integration (manual step)

**Future Enhancements:**
- Automatic VLM API integration (no manual copy/paste)
- Real-time preview during generation
- Multi-image scene composition
- Style transfer and material matching
- Automatic texture extraction from images
- 3D model import for complex objects

---

**Transform your visual ideas into interactive 3D worlds.** 🎨→🎮
