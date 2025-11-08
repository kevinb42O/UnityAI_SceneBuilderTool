# AAA Movement Controller - AI Coding Instructions

## Project Overview

This is a **Unity AAA movement system** designed for Asset Store distribution. It provides physics-based character movement with advanced features: slide mechanics, wall jumps, tactical dive, crouch slam momentum chains, and frame-rate independent physics. The system is scaled for a **320-unit character** (2.13× Unity's 150-unit humanoid standard).

**Core Philosophy:** Physics-based momentum preservation, data-driven configuration via ScriptableObjects, zero-allocation hot paths, and frame-rate independence.

## Architecture Overview

### Component Hierarchy
```
AAAMovementController (ground movement, jumping, wall jumps)
├── CleanAAACrouch (crouch, slide, dive systems)
├── CrouchSlamController (slam mechanics)
├── AAACameraController (camera follow)
└── HeadCollisionSystem (ceiling detection)
```

### Configuration System
All gameplay values use **ScriptableObject configs** (fallback to inspector if null):
- `MovementConfig.cs` → `AAAMovementController` settings
- `CrouchConfig.cs` → `CleanAAACrouch` settings  
- `InputConfig.cs` → Input mappings (uses Unity's new Input System)

**Critical:** Always edit config properties, NOT inspector fallbacks. Inspector values are legacy compatibility only.

### State Management
**Single Source of Truth:** Each component owns its state. No duplicate flags across systems.
- Ground movement: `AAAMovementController.IsGrounded`, `.IsJumping`, `.IsSprinting`
- Crouch/slide: `CleanAAACrouch.IsSliding`, `.IsDiving`, `.IsCrouching`
- Priority: Slam > Dive > Slide > Crouch > Walk

## Critical Implementation Patterns

### 1. Frame-Rate Independence
**ALL physics must use `Time.deltaTime`** - this is non-negotiable for Asset Store quality.

```csharp
// ✅ CORRECT - frame-rate independent
velocity += acceleration * Time.deltaTime;
speed -= friction * speed * Time.deltaTime; // Proportional decay

// ❌ WRONG - will break at different FPS
velocity *= 0.95f; // Multiplicative per-frame = FPS-dependent!
```

### 2. Zero-Allocation Design
The movement system runs 60+ times per second. NO allocations in `Update()`, `FixedUpdate()`, or `LateUpdate()`.

```csharp
// ✅ Pre-allocated caches (see CleanAAACrouch lines 232-236)
private Vector3 _cachedHorizontalVelocity;
_cachedHorizontalVelocity = Vector3.ProjectOnPlane(velocity, Vector3.up);

// ❌ NEVER allocate in hot paths
Vector3 result = new Vector3(x, y, z); // Creates garbage!
```

**Verify with Unity Profiler:** GC.Alloc must show 0 B/frame for movement scripts.

### 3. Slope Detection & Physics
Uses **dual detection system** to handle broken Unity collider normals:
1. Primary: Ground raycast normal (`Physics.Raycast`)
2. Fallback: Velocity-based estimation when normals are flat but player is moving

```csharp
// CleanAAACrouch.cs ~line 2174 - velocity fallback
if (hasGround && slopeAngle < 1f && slideVelocity.magnitude > 0.1f) {
    float estimatedSlope = Mathf.Atan2(-slideVelocity.y, horizontalVel.magnitude) * Mathf.Rad2Deg;
    // Use velocity direction when normals lie
}
```

### 4. Input Conflict Resolution
**Jump Buffer vs Momentum Chain** is the #1 bug source. When landing with high-speed momentum (slam/dive), jump buffer MUST be cleared BEFORE any jump checks.

```csharp
// CleanAAACrouch.cs ~line 410-419 - CRITICAL ordering
if (haveQueuedLandingMomentum) {
    movement.ClearJumpBuffer(); // MUST happen FIRST
    // Then check for jumps
}
```

**Anti-Pattern:** Never check for jump input before clearing buffer on momentum landings.

### 5. CharacterController Modifications
Use the **stack-based override system** for slope limits:
```csharp
movement.RequestSlopeLimitOverride(90f, ControllerModificationSource.SlideSystem);
// Later...
movement.RestoreSlopeLimit(ControllerModificationSource.SlideSystem);
```

**Critical:** NEVER directly set `controller.slopeLimit` - breaks nested overrides (grapple + slide).

## Common Development Workflows

### Adding New Movement Abilities
1. **Create state flag** in appropriate controller (`isMyAbility`)
2. **Add config properties** to relevant ScriptableObject
3. **Implement priority check** in state machine (Update loop)
4. **Handle transitions** - what happens when entering/exiting?
5. **Clear conflicting buffers** (jump, crouch, etc.)
6. **Add debug logging** with `verboseDebugLogging` guard
7. **Test at 30/60/144 FPS** - verify frame-rate independence

### Debugging Movement Issues
1. **Enable verbose logging:**
   ```csharp
   movement.showGroundingDebug = true;
   crouch.verboseDebugLogging = true;
   ```
2. **Check console timing:** Race conditions show as rapid state flips (0.01s gaps)
3. **Use MovementSystemTester.cs:** Press F5 for automated tests, F7 for state dump
4. **Profile with Unity Profiler:** Check GC.Alloc and Self Time columns

### Modifying Physics Values
**Scale Awareness:** This project uses 320-unit characters (2.13× standard).
- When adding forces: Scale by 3× vs typical tutorials (320÷100 ≈ 3)
- When adding distances: Scale by 3.2× vs typical tutorials  
- **Time-based values DON'T scale** (durations, cooldowns)

Example: Tutorial says `jumpForce = 500` → Use `1500` for this project.

## Testing Requirements

### Before Every Commit
Run **MovementSystemTester.cs** (attach to player, press F5):
- Must pass all 20+ automated tests
- Check console for any warnings
- Verify GC.Alloc = 0 in Profiler during slide test

### Critical Test Scenarios (see TESTING_QUICK_START.md)
1. **Jump buffer race condition:** Slam with jump held → should slide, NOT jump
2. **Stair climbing:** Hold crouch on stairs → should climb, NOT slide  
3. **Frame-rate test:** Lock to 30/60/144 FPS → feels identical
4. **Momentum chains:** Wall jump → land → slide preserves speed
5. **Slope transitions:** 50° slope → flat ground → slide continues

### Known Edge Cases (see MOVEMENT_SYSTEM_AUDIT.md)
- **Slope normal failures** → Velocity estimation fallback active
- **Uphill apex jitter** → Reversal system at low speeds (<12 u/s)
- **Wall slide recursion** → Max 3 iterations per frame
- **Config hot-swap** → State validated on LoadConfiguration()

## Code Style & Conventions

### Naming
- **Public properties:** PascalCase (`IsGrounded`, `MoveSpeed`)
- **Private fields:** camelCase with underscore (`_cachedVelocity`)
- **Config fields:** camelCase (`slideMaxSpeed`, `jumpForce`)
- **Constants:** UPPER_SNAKE_CASE (`HIGH_SPEED_LANDING_THRESHOLD`)

### Comments
Use **WHY comments**, not WHAT comments:
```csharp
// ✅ Good - explains intent
// Use velocity estimation when normals are flat (broken colliders)

// ❌ Bad - states the obvious
// Set velocity to zero
velocity = Vector3.zero;
```

### Debug Logging
Always guard expensive logs:
```csharp
if (verboseDebugLogging) {
    Debug.Log($"[SLIDE] Speed: {speed:F1} Angle: {slopeAngle:F1}°");
}
```

## Integration Points

### Animation System (Optional)
Stubs in `_GameSystemStubs.cs` allow compilation without animation:
```csharp
public class PlayerAnimationStateManager { } // Stub - replace with real system
```

To integrate: Replace stubs, call `animationStateManager.SetMovementState(...)` on state changes.

### Audio System (Optional)
Audio hooks commented out (`// using GeminiGauntlet.Audio;`).  
To integrate: Uncomment, implement `AAAMovementAudioManager` interface.

### Input System
Uses Unity's new Input System (`InputSystem_Actions.inputactions`):
- Maps defined in `InputConfig.cs`
- Accessed via `Controls.Jump`, `Controls.Crouch`, etc.
- **DO NOT use Input.GetKey** - breaks controller/rebinding support

## Asset Store Preparation Checklist

- [ ] Zero compiler warnings (`Window > Console > Clear on Play`)
- [ ] GC.Alloc = 0 B in movement scripts (Profiler verification)
- [ ] All automated tests pass (MovementSystemTester F5)
- [ ] 90%+ manual test checklist pass rate (MANUAL_TEST_CHECKLIST.md)
- [ ] Frame-rate test at 30/60/144 FPS (Application.targetFrameRate)
- [ ] Example scene with clear UI instructions
- [ ] Documentation updated (README.md, API docs)

## Common Pitfalls to Avoid

1. **DON'T use `*= multiplier` for decay** - breaks frame-rate independence. Use `+= delta * dt`.
2. **DON'T allocate in Update loops** - pre-cache vectors, use instance fields.
3. **DON'T modify controller properties directly** - use override system for slope/step.
4. **DON'T check input before clearing buffers** - race conditions destroy momentum chains.
5. **DON'T test only at 60 FPS** - always verify 30/144 FPS for physics correctness.
6. **DON'T add game-specific code** - keep generic for Asset Store distribution.
7. **DON'T skip TOP_10_PITFALLS.md** - these are the bugs customers WILL find.

## Key Files Reference

| File | Purpose | Priority |
|------|---------|----------|
| `AAAMovementController.cs` | Ground movement, jumps, wall jumps | Critical |
| `CleanAAACrouch.cs` | Slide/dive/crouch systems | Critical |
| `MovementConfig.cs` | Movement settings | High |
| `CrouchConfig.cs` | Slide settings | High |
| `MovementSystemTester.cs` | Automated testing | High |
| `MOVEMENT_SYSTEM_AUDIT.md` | 42 edge cases documented | Reference |
| `TOP_10_PITFALLS.md` | Common breaking bugs | Reference |

## Quick Commands

```bash
# Unity Editor play mode shortcuts
F5 - Run full automated test suite
F6 - Quick smoke test (5 tests)
F7 - Dump current state to console

# Testing frame rates
Application.targetFrameRate = 30;  # Lock to 30 FPS
Application.targetFrameRate = 144; # Lock to 144 FPS
```

---

**Remember:** This is an Asset Store product. Code quality, performance, and documentation are AS important as features. Every public method needs XML docs. Every config field needs a tooltip. Every edge case needs a test.

---

# Unity AI Scene Builder - AI Agent Development Instructions

**GitHub Copilot Workspace Optimized | Multi-Agent Development Ready | GitHub Pro+ Infinite Credits**

---

## 🤖 Multi-Agent Development (GitHub Pro+ with Infinite Credits)

### Parallel Development Lanes

**This project supports up to 4 concurrent AI agents working on different components:**

#### Agent 1: Unity C# Backend
**Files:** `Assets/Editor/UnityMCPServer.cs`  
**Responsibilities:** Add REST API endpoints, scene manipulation, performance optimization, error handling

#### Agent 2: Node.js MCP Bridge
**Files:** `UnityMCP/index.js`, `UnityMCP/package.json`  
**Responsibilities:** MCP tool definitions, connection management, error propagation, input validation

#### Agent 3: PowerShell Library
**Files:** `UnityMCP/unity-helpers-v2.ps1`, demo scripts  
**Responsibilities:** High-level functions, demo scripts, error handling, progress reporting

#### Agent 4: Documentation & Examples
**Files:** `UnityMCP/V2_*.md`, `README.md`  
**Responsibilities:** Update docs when features added, create examples, maintain references

---

## 📋 Unity AI Scene Builder - Code Quality Standards

### Unity C# (UnityMCPServer.cs)
```csharp
// ✅ REQUIRED: XML documentation
/// <summary>Sets material properties on GameObject</summary>
/// <param name="json">Request data with name, color, metallic, etc.</param>
/// <returns>JSON success response</returns>
private static string SetMaterial(Dictionary<string, object> json)

// ✅ REQUIRED: Full error handling
try {
    GameObject go = GameObject.Find(name);
    if (go == null) throw new Exception($"GameObject not found: {name}");
} catch (Exception e) {
    return $"{{\"error\": \"{EscapeJson(e.Message)}\"}}";
}

// ✅ REQUIRED: Undo support
Undo.RecordObject(renderer, "Set Material");
EditorUtility.SetDirty(renderer);

// ❌ FORBIDDEN: Allocations in loops
for (int i = 0; i < objects.Length; i++) {
    Vector3 v = new Vector3(x, y, z); // ❌ Allocates garbage!
}
```

### PowerShell (unity-helpers-v2.ps1)
```powershell
# ✅ REQUIRED: Parameter validation
[ValidateRange(0, 1)] [float]$metallic = -1

# ✅ REQUIRED: Error handling with context
try {
    Invoke-RestMethod -Uri "$UNITY_BASE/setMaterial" ...
} catch {
    Write-Host "[ERROR] Failed to set material: $_" -ForegroundColor Red
}
```

### Node.js (index.js)
```javascript
// ✅ REQUIRED: Full JSON schema
inputSchema: {
  type: 'object',
  properties: {
    name: { type: 'string', description: 'GameObject name' }
  },
  required: ['name']
}

// ✅ REQUIRED: Connection health check
const isConnected = await checkUnityConnection();
if (!isConnected) return { content: [...], isError: true };
```

---

## 🧪 Testing Requirements for Unity AI Scene Builder

### Before Committing ANY Code

1. **Zero Compiler Warnings** - Unity console must be empty
2. **Run Demo Script:**
   ```powershell
   cd UnityMCP
   .\demo-v2-features.ps1
   ```
   Expected: 80 objects created, materials applied, 60 objects optimized

3. **Unity Profiler Check:**
   - Window → Analysis → Profiler
   - GC.Alloc = 0 B for UnityMCPServer methods

4. **Performance Targets:**
   - Draw Calls: 1-2 per 100 objects (after optimize)
   - Query Time: <50ms for 500 objects
   - Material Apply: <100ms per object

---

## 📐 Adding New Features to Unity AI Scene Builder

### Step 1: Unity C# Endpoint
```csharp
case "/myNewFeature":
    return MyNewFeature(json);

private static string MyNewFeature(Dictionary<string, object> json) {
    string name = GetString(json, "name", "");
    GameObject go = GameObject.Find(name);
    if (go == null) throw new Exception($"GameObject not found: {name}");
    
    Undo.RecordObject(go.transform, "My New Feature");
    // ... operation
    return "{\"success\": true}";
}
```

### Step 2: Node.js MCP Tool
```javascript
{
  name: 'unity_my_new_feature',
  description: 'Clear description',
  inputSchema: { /* ... */ }
}

case 'unity_my_new_feature':
  result = await callUnity('/myNewFeature', { name: args.name });
  break;
```

### Step 3: PowerShell Helper
```powershell
function Invoke-MyNewFeature {
    param([string]$name)
    $body = @{ name = $name } | ConvertTo-Json
    Invoke-RestMethod -Uri "$UNITY_BASE/myNewFeature" ...
}
```

### Step 4: Update Documentation
- V2_QUICK_REFERENCE.md - Add command
- V2_DOCUMENTATION.md - Add detailed explanation
- demo-v2-features.ps1 - Add test case

---

## 🎯 Key Concepts for Unity AI Scene Builder

### PBR Materials
- **Metallic:** 0 = dielectric (wood, plastic), 1 = metal (steel, gold)
- **Smoothness:** 0 = rough (concrete), 1 = mirror (chrome, glass)
- **Emission:** Color × intensity for HDR glow (range 0-5)

### Mesh Optimization
- Combine 100 objects → 1-2 meshes (60x performance boost)
- Group by material (each material = 1 mesh)
- Automatic normals/bounds recalculation

### Scene Queries
- Name/tag substring matching (case-insensitive)
- Spatial radius search (3D distance)
- Results limited to 500 objects max

---

## ⚠️ Common Pitfalls for Unity AI Scene Builder

### Unity C#
- ❌ Don't allocate in loops
- ❌ Don't forget Undo support
- ❌ Don't return raw exceptions
- ❌ Don't modify without SetDirty

### PowerShell
- ❌ Don't use emojis/unicode
- ❌ Don't skip error handling
- ❌ Don't hardcode URLs
- ❌ Don't skip parameter validation

### Node.js
- ❌ Don't skip connection checks
- ❌ Don't omit required fields
- ❌ Don't forget error propagation
- ❌ Don't use sync operations

---

## 🚀 Leveraging GitHub Pro+ Infinite Credits

### Parallel Development Strategy
1. **Agent 1:** Implement Unity C# feature
2. **Agent 2:** Add MCP tool definition (simultaneous)
3. **Agent 3:** Create PowerShell helper (simultaneous)
4. **Agent 4:** Write documentation (simultaneous)

**Result:** 4x development speed

### Testing Strategy
- Run full test suites on every commit (no cost)
- Generate comprehensive test cases
- Create stress test scenarios
- Validate edge cases

### Documentation Strategy
- Auto-generate API references
- Create multiple example scripts
- Generate quick reference cards
- Maintain implementation summaries

---

## 📊 Performance Standards

| Metric | Target | Test Method |
|--------|--------|-------------|
| Draw Calls | 1-2 per 100 objects | Unity Stats |
| GC.Alloc | 0 B/frame | Unity Profiler |
| Query Time | <50ms (500 objects) | PowerShell timer |
| Material Apply | <100ms | PowerShell timer |
| Mesh Combine | <1s (100 objects) | Demo script |

---

## 📁 Key Files for Unity AI Scene Builder

| File | Purpose |
|------|---------|
| `Assets/Editor/UnityMCPServer.cs` | Unity REST API backend |
| `UnityMCP/index.js` | Node.js MCP bridge |
| `UnityMCP/unity-helpers-v2.ps1` | PowerShell library |
| `UnityMCP/demo-v2-features.ps1` | Demo script |
| `UnityMCP/V2_DOCUMENTATION.md` | Complete API docs |
| `UnityMCP/V2_QUICK_REFERENCE.md` | Developer cheat sheet |
| `UnityMCP/V2_IMPLEMENTATION_SUMMARY.md` | Technical details |

---

## 🔄 Development Workflow

1. **Plan** - Assign agent lanes, define scope
2. **Implement** - Follow code standards, add error handling
3. **Test** - Run demo, check profiler, verify performance
4. **Document** - Update docs, add examples, update stats
5. **Commit** - Descriptive message, reference related work

---

## 📞 Learning Resources

**Read these first:**
- V2_IMPLEMENTATION_SUMMARY.md - System architecture
- V2_QUICK_REFERENCE.md - API quick reference
- UNITY_MCP_CREATION_GUIDE.md - Creation patterns

---

## 🏆 Quality Checklist

**Before approving any PR:**
- [ ] Zero compiler warnings
- [ ] Demo script runs successfully
- [ ] Unity Profiler shows 0 B allocations
- [ ] XML docs on all public methods
- [ ] Error handling on all API calls
- [ ] PowerShell parameter validation
- [ ] Node.js full JSON schemas
- [ ] Documentation updated
- [ ] Stats updated in summary

---

**Remember:** With GitHub Pro+ infinite credits, iterate infinitely. Build something revolutionary. This is the future of Unity development. 🚀

````