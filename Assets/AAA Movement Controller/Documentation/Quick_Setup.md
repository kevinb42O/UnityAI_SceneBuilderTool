# 🚀 Quick Setup Guide - AAA Movement Controller

**Get up and running in under 5 minutes!**

---

## ⚡ **Instant Setup (Prefab Method)**

### Step 1: Import the Package
1. Import the AAA Movement Controller package from the Asset Store
2. Unity will automatically import all files to `Assets/AAA Movement Controller/`

### Step 2: Add the Player Controller
1. Navigate to `AAA Movement Controller/Prefabs/`
2. Drag `AAA Player Controller` prefab into your scene
3. Position it at your desired spawn point
4. **Done!** Your player is ready to move

### Step 3: Connect Your Camera
1. Select the `AAA Player Controller` in the scene
2. In the `AAAMovementController` component, find "Camera Transform"
3. Drag your Main Camera from the hierarchy into this field
4. **Optional:** Add `AAACameraController` script to your camera for FOV effects

### Step 4: Test It Out!
Press Play and use:
- **WASD** - Move around
- **Space** - Jump (hold for variable height)
- **Shift** - Sprint
- **Ctrl** - Crouch
- **Ctrl while sprinting** - Slide

**You're done! 🎉**

---

## 🛠️ **Manual Setup (Existing Character)**

### Step 1: Prepare Your Character
1. Make sure your character has a **CharacterController** component
2. Set the CharacterController height to match your character (default: 320 units)
3. Disable any existing movement scripts to prevent conflicts

### Step 2: Add Movement Components
1. Add `AAAMovementController` script to your character
2. **Optional:** Add `CleanAAACrouch` for advanced crouch/slide mechanics
3. **Optional:** Add `HeadCollisionSystem` for head bonk protection

### Step 3: Create Configuration
1. Right-click in Project window
2. Choose `Create > Game > Movement Configuration`
3. Name it "MyMovementConfig"
4. Assign it to the "Config" field in `AAAMovementController`

### Step 4: Setup References
1. Assign your Main Camera to "Camera Transform" field
2. **Optional:** Create Input Configuration via `Create > AAA Movement > Input Configuration`

---

## 🎮 **Input Setup**

### Legacy Input Manager (Default)
No setup required! The system uses Unity's built-in input:
- Horizontal/Vertical axes for movement
- Space for jump
- Left Shift for sprint
- Left Ctrl for crouch

### New Input System (Advanced)
1. Install Input System package: `Window > Package Manager > Unity Registry > Input System`
2. Create Input Actions asset: `Create > Input Actions`
3. Set up action maps for Player input
4. Reference the included example in `Examples/InputActions/`

---

## ⚙️ **Configuration Presets**

Choose a preset that matches your game style:

### 🎮 **Arcade Style**
```
Use: MovementConfig_Arcade
- High air control
- Multiple jumps
- Forgiving wall jumping
- Fast-paced gameplay
```

### 🎯 **Realistic Style**
```
Use: MovementConfig_Realistic  
- Limited air control
- Single jump only
- Weighty feel
- Grounded movement
```

### 🎲 **Platformer Style**
```
Use: MovementConfig_Platformer
- Precise controls
- Moderate air control
- Wall jump chains
- Puzzle-friendly
```

To apply a preset:
1. Select your player's `AAAMovementController`
2. In the "Config" field, choose one of the preset configs
3. Tweak individual values as needed

---

## 🎪 **Quick Customization**

### Make Jumps Higher
```
Increase: jumpForce (try 2000)
```

### Make Movement Faster
```
Increase: moveSpeed (try 1600)
Increase: sprintMultiplier (try 1.8)
```

### Make Wall Jumping Easier
```
Increase: wallDetectionDistance (try 450)
Increase: wallJumpMomentumPreservation (try 0.5)
```

### Reduce Gravity (More Floaty)
```
Decrease: gravity (try -5000 instead of -7000)
```

### Add Double Jump
```
Increase: maxAirJumps (set to 1 for double jump)
```

---

## 🔧 **Common Issues & Fixes**

### **Player Falls Through Ground**
✅ **Fix:** Check that your ground objects have the correct layer assigned and that `groundMask` in the config includes that layer.

### **Wall Jumping Doesn't Work**
✅ **Fix:** Ensure walls have colliders and are included in the `groundMask`. Try increasing `wallDetectionDistance`.

### **Movement Feels Slow**
✅ **Fix:** Your character might be a different scale. Adjust `moveSpeed`, `jumpForce`, and `gravity` proportionally.

### **Player Gets Stuck on Slopes**
✅ **Fix:** Check `maxSlopeAngle` in config (try 45-50 degrees). Ensure slope colliders are smooth without gaps.

### **Camera Feels Jerky**
✅ **Fix:** Add the included `AAACameraController` to your camera. Enable "Fixed Timestep" in Project Settings > Time.

---

## 🎥 **Demo Scene**

Check out the included demo scene:
1. Open `AAA Movement Controller/Examples/DemoScene`
2. Press Play to see all features in action
3. Use the on-screen instructions to test different abilities
4. Study the setup for reference in your own project

---

## 📞 **Need Help?**

- 📖 **Full Documentation:** Check `Documentation/README.md`
- 🔧 **API Reference:** See `Documentation/API_Reference.md`
- 💡 **Examples:** Browse `Examples/` folder for implementation samples
- 💬 **Support:** Email support@yourstudio.com

---

**You're all set! Start building amazing movement experiences! 🚀**