# Example VLM Outputs

**Sample JSON responses for testing the image-to-scene system**

Use these examples to test the pipeline without VLM access.

---

## Example 1: Simple Statue

**Image Type**: Single object (statue on pedestal)

**VLM Prompt**: Object analysis, DetailLevel 5

**Expected JSON Output**:
```json
{
  "type": "single_object",
  "name": "ClassicalStatue",
  "description": "Classical marble statue on cylindrical pedestal",
  "components": [
    {
      "primitive": "Cylinder",
      "position": {"x": 0, "y": 0.5, "z": 0},
      "scale": {"x": 1.5, "y": 1, "z": 1.5},
      "rotation": {"x": 0, "y": 0, "z": 0},
      "material": {
        "preset": "Stone_Gray",
        "color": null,
        "metallic": 0,
        "smoothness": 0.7
      }
    },
    {
      "primitive": "Cube",
      "position": {"x": 0, "y": 2, "z": 0},
      "scale": {"x": 1, "y": 2, "z": 0.5},
      "rotation": {"x": 0, "y": 0, "z": 0},
      "material": {
        "preset": "Stone_Gray",
        "color": null,
        "metallic": 0,
        "smoothness": 0.7
      }
    },
    {
      "primitive": "Sphere",
      "position": {"x": 0, "y": 3.2, "z": 0},
      "scale": {"x": 0.6, "y": 0.6, "z": 0.6},
      "rotation": {"x": 0, "y": 0, "z": 0},
      "material": {
        "preset": "Stone_Gray",
        "color": null,
        "metallic": 0,
        "smoothness": 0.7
      }
    }
  ]
}
```

**Usage**:
```powershell
# Save to file
$json | Out-File -FilePath "statue-analysis.json" -Encoding UTF8

# Generate scene
.\generate-scene-from-json.ps1 -JsonPath "statue-analysis.json" -Execute
```

---

## Example 2: Park Bench Scene

**Image Type**: Outdoor scene with bench and trees

**VLM Prompt**: Scene analysis, DetailLevel 6

**Expected JSON Output**:
```json
{
  "type": "complete_scene",
  "description": "Park scene with bench and trees",
  "environment": {
    "terrain": "flat",
    "ground_material": "Grass_Green",
    "lighting": {
      "type": "Directional",
      "intensity": 1.2,
      "color": {"r": 1, "g": 0.95, "b": 0.85},
      "direction": {"x": -0.3, "y": -1, "z": -0.3}
    }
  },
  "objects": [
    {
      "name": "Bench",
      "primitive": "Cube",
      "position": {"x": 0, "y": 0.5, "z": 0},
      "scale": {"x": 3, "y": 0.2, "z": 1},
      "material": {"preset": "Wood_Oak"}
    },
    {
      "name": "BenchLeg1",
      "primitive": "Cube",
      "position": {"x": -1, "y": 0.25, "z": 0},
      "scale": {"x": 0.2, "y": 0.5, "z": 0.8},
      "material": {"preset": "Metal_Steel"}
    },
    {
      "name": "BenchLeg2",
      "primitive": "Cube",
      "position": {"x": 1, "y": 0.25, "z": 0},
      "scale": {"x": 0.2, "y": 0.5, "z": 0.8},
      "material": {"preset": "Metal_Steel"}
    },
    {
      "name": "Tree1",
      "primitive": "Cylinder",
      "position": {"x": -5, "y": 3, "z": -2},
      "scale": {"x": 0.5, "y": 6, "z": 0.5},
      "material": {"preset": "Wood_Oak"}
    },
    {
      "name": "TreeTop1",
      "primitive": "Sphere",
      "position": {"x": -5, "y": 7, "z": -2},
      "scale": {"x": 3, "y": 3, "z": 3},
      "material": {
        "preset": null,
        "color": {"r": 0.2, "g": 0.6, "b": 0.2},
        "metallic": 0,
        "smoothness": 0.3
      }
    },
    {
      "name": "Tree2",
      "primitive": "Cylinder",
      "position": {"x": 5, "y": 2.5, "z": 2},
      "scale": {"x": 0.4, "y": 5, "z": 0.4},
      "material": {"preset": "Wood_Oak"}
    },
    {
      "name": "TreeTop2",
      "primitive": "Sphere",
      "position": {"x": 5, "y": 6, "z": 2},
      "scale": {"x": 2.5, "y": 2.5, "z": 2.5},
      "material": {
        "preset": null,
        "color": {"r": 0.2, "g": 0.6, "b": 0.2},
        "metallic": 0,
        "smoothness": 0.3
      }
    }
  ]
}
```

---

## Example 3: Simple House

**Image Type**: Small house with door and windows

**VLM Prompt**: Architecture analysis, DetailLevel 7

**Expected JSON Output**:
```json
{
  "type": "architecture",
  "style": "Modern",
  "description": "Simple single-story house with door and windows",
  "structure": {
    "foundation": {
      "position": {"x": 0, "y": -0.2, "z": 0},
      "scale": {"x": 12, "y": 0.4, "z": 8},
      "material": "Concrete"
    },
    "walls": [
      {
        "position": {"x": 0, "y": 2.5, "z": -4},
        "scale": {"x": 12, "y": 5, "z": 0.3},
        "material": "Brick_Red"
      },
      {
        "position": {"x": 0, "y": 2.5, "z": 4},
        "scale": {"x": 12, "y": 5, "z": 0.3},
        "material": "Brick_Red"
      },
      {
        "position": {"x": -6, "y": 2.5, "z": 0},
        "scale": {"x": 0.3, "y": 5, "z": 8},
        "material": "Brick_Red"
      },
      {
        "position": {"x": 6, "y": 2.5, "z": 0},
        "scale": {"x": 0.3, "y": 5, "z": 8},
        "material": "Brick_Red"
      }
    ],
    "windows": [
      {
        "position": {"x": -3, "y": 2.5, "z": -4.2},
        "scale": {"x": 1.5, "y": 2, "z": 0.1}
      },
      {
        "position": {"x": 3, "y": 2.5, "z": -4.2},
        "scale": {"x": 1.5, "y": 2, "z": 0.1}
      },
      {
        "position": {"x": -3, "y": 2.5, "z": 4.2},
        "scale": {"x": 1.5, "y": 2, "z": 0.1}
      },
      {
        "position": {"x": 3, "y": 2.5, "z": 4.2},
        "scale": {"x": 1.5, "y": 2, "z": 0.1}
      }
    ],
    "roof": {
      "type": "flat",
      "position": {"x": 0, "y": 5.2, "z": 0},
      "scale": {"x": 12.5, "y": 0.3, "z": 8.5},
      "material": "Stone_Gray"
    }
  }
}
```

---

## Example 4: Forest Environment

**Image Type**: Forest scene with multiple trees

**VLM Prompt**: Environment analysis, DetailLevel 6

**Expected JSON Output**:
```json
{
  "type": "environment",
  "biome": "Forest",
  "description": "Dense forest with deciduous trees",
  "terrain": {
    "type": "hilly",
    "size": {"x": 100, "z": 100},
    "elevation_variation": 5
  },
  "vegetation": [
    {
      "type": "tree",
      "count": 25,
      "distribution": "scattered",
      "scale_variation": 0.8
    }
  ],
  "features": [
    {
      "type": "path",
      "description": "Dirt path through forest",
      "positions": [
        {"x": -30, "y": 0, "z": -30},
        {"x": 0, "y": 0, "z": 0},
        {"x": 30, "y": 0, "z": 30}
      ]
    }
  ]
}
```

---

## Example 5: Table with Objects

**Image Type**: Table with vase and books

**VLM Prompt**: Scene analysis, DetailLevel 6

**Expected JSON Output**:
```json
{
  "type": "complete_scene",
  "description": "Wooden table with decorative items",
  "environment": {
    "terrain": "flat",
    "ground_material": "Wood_Oak",
    "lighting": {
      "type": "Point",
      "intensity": 1.5,
      "color": {"r": 1, "g": 0.9, "b": 0.8},
      "position": {"x": 0, "y": 5, "z": 0}
    }
  },
  "objects": [
    {
      "name": "Table",
      "primitive": "Cube",
      "position": {"x": 0, "y": 1, "z": 0},
      "scale": {"x": 4, "y": 0.1, "z": 2},
      "material": {"preset": "Wood_Oak"}
    },
    {
      "name": "TableLeg1",
      "primitive": "Cylinder",
      "position": {"x": 1.5, "y": 0.5, "z": 0.75},
      "scale": {"x": 0.1, "y": 1, "z": 0.1},
      "material": {"preset": "Wood_Oak"}
    },
    {
      "name": "TableLeg2",
      "primitive": "Cylinder",
      "position": {"x": -1.5, "y": 0.5, "z": 0.75},
      "scale": {"x": 0.1, "y": 1, "z": 0.1},
      "material": {"preset": "Wood_Oak"}
    },
    {
      "name": "TableLeg3",
      "primitive": "Cylinder",
      "position": {"x": 1.5, "y": 0.5, "z": -0.75},
      "scale": {"x": 0.1, "y": 1, "z": 0.1},
      "material": {"preset": "Wood_Oak"}
    },
    {
      "name": "TableLeg4",
      "primitive": "Cylinder",
      "position": {"x": -1.5, "y": 0.5, "z": -0.75},
      "scale": {"x": 0.1, "y": 1, "z": 0.1},
      "material": {"preset": "Wood_Oak"}
    },
    {
      "name": "Vase",
      "primitive": "Cylinder",
      "position": {"x": 0, "y": 1.5, "z": 0},
      "scale": {"x": 0.3, "y": 0.8, "z": 0.3},
      "material": {
        "preset": null,
        "color": {"r": 0.3, "g": 0.5, "b": 0.7},
        "metallic": 0.2,
        "smoothness": 0.8
      }
    },
    {
      "name": "Book1",
      "primitive": "Cube",
      "position": {"x": -1, "y": 1.2, "z": 0},
      "scale": {"x": 0.6, "y": 0.1, "z": 0.8},
      "material": {
        "preset": null,
        "color": {"r": 0.6, "g": 0.2, "b": 0.2},
        "metallic": 0,
        "smoothness": 0.3
      }
    },
    {
      "name": "Book2",
      "primitive": "Cube",
      "position": {"x": -1, "y": 1.3, "z": 0},
      "scale": {"x": 0.5, "y": 0.1, "z": 0.7},
      "material": {
        "preset": null,
        "color": {"r": 0.2, "g": 0.3, "b": 0.6},
        "metallic": 0,
        "smoothness": 0.3
      }
    }
  ]
}
```

---

## Testing Workflow

### Test Example 1 (Statue)
```powershell
# Copy JSON to file
@'
{JSON from Example 1}
'@ | Out-File -FilePath "statue-test.json" -Encoding UTF8

# Generate scene
.\generate-scene-from-json.ps1 -JsonPath "statue-test.json" -Execute
```

### Test Example 2 (Park Scene)
```powershell
@'
{JSON from Example 2}
'@ | Out-File -FilePath "park-test.json" -Encoding UTF8

.\generate-scene-from-json.ps1 -JsonPath "park-test.json" -Execute
```

### Test Example 3 (House)
```powershell
@'
{JSON from Example 3}
'@ | Out-File -FilePath "house-test.json" -Encoding UTF8

.\generate-scene-from-json.ps1 -JsonPath "house-test.json" -Execute
```

---

## Creating Custom Examples

Use this template for your own test cases:

```json
{
  "type": "single_object|complete_scene|architecture|environment",
  "name": "YourObjectName",
  "description": "Brief description",
  "components": [
    {
      "primitive": "Cube|Sphere|Cylinder|Capsule|Plane|Quad",
      "position": {"x": 0, "y": 0, "z": 0},
      "scale": {"x": 1, "y": 1, "z": 1},
      "rotation": {"x": 0, "y": 0, "z": 0},
      "material": {
        "preset": "Material_Name or null",
        "color": {"r": 0.5, "g": 0.5, "b": 0.5},
        "metallic": 0.0,
        "smoothness": 0.5
      }
    }
  ]
}
```

---

## Tips for Real VLM Usage

When getting actual VLM outputs:

1. **Validate JSON**: Use online JSON validator before using
2. **Check Coordinates**: Ensure Y-axis is up (Unity convention)
3. **Scale Appropriately**: Unity units are meters (2 units ≈ human height)
4. **Use Presets**: Prefer preset materials over custom colors when possible
5. **Hierarchical Naming**: Use descriptive names (e.g., "Building_Wall_North")

---

## Troubleshooting VLM Outputs

### Issue: Invalid JSON
```powershell
# Test JSON validity
Get-Content "analysis.json" | ConvertFrom-Json
```

### Issue: Missing Fields
Add defaults:
- `rotation`: `{"x": 0, "y": 0, "z": 0}`
- `material.preset`: Can be `null` if using custom colors
- `material.metallic`: Default `0`
- `material.smoothness`: Default `0.5`

### Issue: Wrong Coordinate System
VLM might use different conventions:
- **Unity**: Y-up, right-handed
- **Some VLMs**: Z-up or left-handed

Adjust in the JSON before generating script.

---

**These examples demonstrate the full range of scene types the system can generate.**
