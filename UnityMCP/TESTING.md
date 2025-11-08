# Unity MCP Server - Test Suite

## Test Status: Ready for Testing

### Prerequisites
- [x] Node.js dependencies installed
- [x] MCP server configured in VS Code
- [ ] Unity Editor open
- [ ] Unity MCP HTTP server started

## Test 1: Connection & Basic Operations

### 1.1 Connection Test
**Command:** "List the Unity scene"
**Expected:** JSON response with scene objects
**Status:** ⏳ Pending

### 1.2 Create Empty GameObject
**Command:** "Create an empty GameObject called TestObject"
**Expected:** GameObject appears in hierarchy
**Verify:** Check Unity hierarchy for "TestObject"
**Status:** ⏳ Pending

### 1.3 Create Primitive
**Command:** "Create a cube called TestCube"
**Expected:** Cube appears in scene
**Verify:** Visual confirmation in scene view
**Status:** ⏳ Pending

## Test 2: Transform Operations

### 2.1 Set Position
**Command:** "Move TestCube to position (5, 2, 0)"
**Expected:** Cube moves to specified position
**Verify:** Inspector shows position (5, 2, 0)
**Status:** ⏳ Pending

### 2.2 Set Rotation
**Command:** "Rotate TestCube 45 degrees on Y axis"
**Expected:** Cube rotates
**Verify:** Inspector shows rotation (0, 45, 0)
**Status:** ⏳ Pending

### 2.3 Set Scale
**Command:** "Scale TestCube to (2, 1, 3)"
**Expected:** Cube changes size
**Verify:** Inspector shows scale (2, 1, 3)
**Status:** ⏳ Pending

## Test 3: Component Management

### 3.1 Add Rigidbody
**Command:** "Add a Rigidbody to TestCube"
**Expected:** Rigidbody component appears
**Verify:** Inspector shows Rigidbody component
**Status:** ⏳ Pending

### 3.2 Set Component Property
**Command:** "Set the Rigidbody mass to 10"
**Expected:** Mass property updates
**Verify:** Inspector shows mass = 10
**Status:** ⏳ Pending

### 3.3 Add Collider
**Command:** "Add a BoxCollider to TestCube"
**Expected:** BoxCollider component appears
**Verify:** Inspector shows BoxCollider
**Status:** ⏳ Pending

## Test 4: Scene Creation Workflow

### 4.1 Create Physics Test Scene
**Command:** "Create a new scene with a cube at (0, 5, 0) with Rigidbody, and a ground plane at (0, 0, 0)"
**Expected:** 
- New scene created
- Cube at height 5 with Rigidbody
- Plane at ground level
**Verify:** Visual confirmation + play mode drops cube
**Status:** ⏳ Pending

### 4.2 Build Platform Layout
**Command:** "Create three platforms: one at (0, 1, 0) scaled (5, 0.5, 5), one at (6, 2, 0) scaled (3, 0.5, 3), one at (-4, 3, 0) scaled (4, 0.5, 4)"
**Expected:** Three platforms at different positions and heights
**Verify:** Visual confirmation of layout
**Status:** ⏳ Pending

## Test 5: Scene Management

### 5.1 List Scene Objects
**Command:** "List all objects in the scene"
**Expected:** JSON array with all root GameObjects
**Verify:** Response matches hierarchy
**Status:** ⏳ Pending

### 5.2 Find GameObject
**Command:** "Find TestCube and tell me its position"
**Expected:** Position data returned
**Verify:** Matches Inspector values
**Status:** ⏳ Pending

### 5.3 Delete GameObject
**Command:** "Delete TestCube"
**Expected:** GameObject removed from scene
**Verify:** Object no longer in hierarchy
**Status:** ⏳ Pending

### 5.4 New Scene
**Command:** "Create a new empty scene"
**Expected:** Fresh scene with default objects (Camera, Light)
**Verify:** Hierarchy shows only defaults
**Status:** ⏳ Pending

## Test 6: Play Mode Control

### 6.1 Enter Play Mode
**Command:** "Enter play mode"
**Expected:** Unity enters play mode
**Verify:** Play button highlighted
**Status:** ⏳ Pending

### 6.2 Exit Play Mode
**Command:** "Exit play mode"
**Expected:** Unity exits play mode
**Verify:** Play button normal state
**Status:** ⏳ Pending

## Test 7: Complex Scenarios

### 7.1 Full Movement Test Scene
**Command:** 
```
Create a movement test scene:
1. New scene
2. Ground plane at (0, 0, 0) scaled (20, 1, 20)
3. Player capsule at (0, 2, 0) scaled (1, 2, 1)
4. Three obstacle cubes at (5, 1, 0), (10, 2, 0), (15, 3, 0)
5. Add Rigidbody to player
6. Save scene as MovementTestScene.unity
```
**Expected:** Complete test scene setup
**Verify:** All objects created correctly
**Status:** ⏳ Pending

### 7.2 Rapid Iteration
**Command:** "Delete all cubes, create a sphere at (0, 5, 0) with Rigidbody mass 5"
**Expected:** Cubes removed, sphere created with physics
**Verify:** Scene updated correctly
**Status:** ⏳ Pending

## Test 8: Error Handling

### 8.1 Invalid GameObject Name
**Command:** "Move NonExistentObject to (0, 0, 0)"
**Expected:** Error message: "GameObject not found"
**Status:** ⏳ Pending

### 8.2 Invalid Component Type
**Command:** "Add FakeComponent to TestCube"
**Expected:** Error message: "Component type not found"
**Status:** ⏳ Pending

### 8.3 Server Not Running
**Setup:** Stop Unity MCP server
**Command:** "List the scene"
**Expected:** Error: "Cannot connect to Unity Editor"
**Status:** ⏳ Pending

## Test 9: Undo System

### 9.1 Undo GameObject Creation
**Setup:** Create a cube via MCP
**Action:** Ctrl+Z in Unity
**Expected:** Cube removed
**Status:** ⏳ Pending

### 9.2 Undo Transform Change
**Setup:** Move cube via MCP
**Action:** Ctrl+Z in Unity
**Expected:** Position reverted
**Status:** ⏳ Pending

### 9.3 Undo Component Addition
**Setup:** Add Rigidbody via MCP
**Action:** Ctrl+Z in Unity
**Expected:** Rigidbody removed
**Status:** ⏳ Pending

## Test 10: Performance & Stability

### 10.1 Rapid Commands
**Action:** Execute 20 commands in quick succession
**Expected:** All execute correctly, no crashes
**Status:** ⏳ Pending

### 10.2 Large Scene
**Action:** Create 50+ GameObjects
**Expected:** All created, Unity responsive
**Status:** ⏳ Pending

### 10.3 Extended Session
**Action:** Run server for 30+ minutes, various operations
**Expected:** No memory leaks, stable performance
**Status:** ⏳ Pending

## Results Summary

**Total Tests:** 25
**Passed:** 0
**Failed:** 0
**Pending:** 25

## Notes

- Test after restarting VS Code
- Verify Unity console for any errors
- Check Network tab in Unity Profiler for HTTP calls
- Monitor memory usage during extended testing

## Next Actions

1. Open Unity Editor
2. Start MCP server: Tools > Unity MCP > Start Server
3. Restart VS Code
4. Run Test 1.1 (Connection Test)
5. Document results for each test
