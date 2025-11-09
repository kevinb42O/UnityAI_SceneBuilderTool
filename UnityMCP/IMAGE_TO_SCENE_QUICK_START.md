# Image-to-Scene Quick Start

**5-minute guide to your first AI-generated Unity scene**

---

## ⚡ Quick Steps

### 1. Prepare
```powershell
cd UnityMCP
# Make sure Unity is running with MCP server started
```

### 2. Start Analysis
```powershell
.\image-to-scene.ps1 -ImagePath "your-image.jpg"
```

### 3. Send to VLM
- Copy the displayed prompt
- Go to [claude.ai](https://claude.ai) or [chat.openai.com](https://chat.openai.com)
- Upload your image
- Paste the prompt
- Copy the JSON response

### 4. Generate Scene
```powershell
# Save VLM response as analysis.json
.\generate-scene-from-json.ps1 -JsonPath "analysis.json" -Execute
```

### 5. Done! 🎉
Your scene is now in Unity.

---

## 🎯 Analysis Types

| Type | Use For | Example |
|------|---------|---------|
| `object` | Single item | Statue, furniture, prop |
| `scene` | Multiple objects | Room, courtyard, plaza |
| `architecture` | Buildings | House, temple, monument |
| `environment` | Landscapes | Forest, desert, city |

**Specify type:**
```powershell
.\image-to-scene.ps1 -ImagePath "image.jpg" -AnalysisType "architecture"
```

---

## 🎚️ Detail Levels

| Level | Objects | Use When |
|-------|---------|----------|
| 1-3 | 2-10 | Testing, simple shapes |
| 4-6 | 10-30 | **Recommended start** |
| 7-9 | 30-100 | Complex scenes |
| 10 | 100+ | Maximum detail |

**Specify level:**
```powershell
.\image-to-scene.ps1 -ImagePath "image.jpg" -DetailLevel 7
```

---

## 🧪 Test Without VLM

Test the pipeline with example data:

```powershell
.\image-to-scene.ps1 `
    -ImagePath "any-image.jpg" `
    -AnalysisType "object" `
    -UseExampleData
```

Generates a simple test object instantly.

---

## 📝 Example Workflow

### Example 1: Simple Statue

```powershell
# 1. Start analysis
.\image-to-scene.ps1 -ImagePath "statue.jpg" -AnalysisType "object"

# 2. Use VLM (copy prompt, get JSON)

# 3. Generate scene
.\generate-scene-from-json.ps1 -JsonPath "statue-analysis.json" -Execute
```

**Result:** Statue created in Unity (~10 seconds)

### Example 2: Building

```powershell
# 1. Start analysis with more detail
.\image-to-scene.ps1 `
    -ImagePath "house.jpg" `
    -AnalysisType "architecture" `
    -DetailLevel 7

# 2. Use VLM (copy prompt, get JSON)

# 3. Generate scene
.\generate-scene-from-json.ps1 -JsonPath "house-analysis.json" -Execute
```

**Result:** Building with walls and windows (~30 seconds)

---

## 🎨 Best Image Types

### ✅ Great Results
- Clear reference photos
- Simple geometric objects
- Architectural drawings
- Well-lit scenes
- Distinct objects

### ⚠️ Challenging
- Blurry images
- Cluttered scenes
- Complex organic shapes
- Dark/underexposed
- Heavy perspective

---

## 🔧 Common Issues

### "Image file not found"
```powershell
# Use full path
.\image-to-scene.ps1 -ImagePath "C:\Users\You\Pictures\image.jpg"
```

### "Unity not connected"
```powershell
# Check Unity MCP server
# In Unity: Tools > Unity MCP > Start Server
Test-UnityConnection
```

### "Invalid JSON from VLM"
- Ask VLM: "Please fix the JSON formatting"
- Use online JSON validator
- Try different VLM (Claude vs GPT-4V)

---

## 📊 What to Expect

### Single Object (DetailLevel 5)
- **Objects:** 2-10 primitives
- **Time:** 5-15 seconds
- **Accuracy:** 80-90%

### Complete Scene (DetailLevel 6)
- **Objects:** 10-30 items
- **Time:** 20-45 seconds
- **Accuracy:** 70-85%

### Architecture (DetailLevel 7)
- **Objects:** 20-100 elements
- **Time:** 30-90 seconds
- **Accuracy:** 75-90%

### Environment (DetailLevel 6)
- **Objects:** 50-200+ items
- **Time:** 2-5 minutes
- **Accuracy:** 60-80%

---

## 💡 Pro Tips

1. **Start simple** - Use DetailLevel 5 for first attempt
2. **Iterate** - Generate, review, adjust, regenerate
3. **Combine approaches** - Use VLM for structure, manual for details
4. **Use presets** - Leverage the 14 built-in materials
5. **Optimize** - Scripts auto-optimize for 60x performance gain

---

## 🔗 Learn More

- **[IMAGE_TO_SCENE_GUIDE.md](IMAGE_TO_SCENE_GUIDE.md)** - Complete guide
- **[CURRENT_BUILDING_BLOCKS.md](CURRENT_BUILDING_BLOCKS.md)** - Available tools
- **[V2_DOCUMENTATION.md](V2_DOCUMENTATION.md)** - API reference

---

## 🎯 Your First Scene in 5 Minutes

```powershell
# 1. Quick test with example data (no VLM needed)
.\image-to-scene.ps1 `
    -ImagePath "any-image.jpg" `
    -AnalysisType "object" `
    -UseExampleData

# 2. Check Unity - you should see a simple statue!

# 3. Now try with real VLM for your actual image
.\image-to-scene.ps1 -ImagePath "your-real-image.jpg"
```

---

**From pixels to polygons in minutes.** 📸→🎮
