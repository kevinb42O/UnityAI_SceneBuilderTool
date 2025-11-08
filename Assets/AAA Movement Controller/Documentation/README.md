# 🚀 AAA Movement Controller

**Professional-grade 3D movement system for Unity - Built for performance, customization, and ease of use.**

[![Unity Version](https://img.shields.io/badge/Unity-2022.3%2B-blue.svg)](https://unity3d.com/get-unity/download)
[![License](https://img.shields.io/badge/License-Unity%20Asset%20Store-green.svg)](https://assetstore.unity.com)

## ⚡ **Quick Start (5 Minutes)**

1. **Import** the package into your Unity project
2. **Drop** the `AAAMovementController` prefab into your scene
3. **Assign** your main camera to the "Camera Transform" field
4. **Play** and start moving with WASD + Space!

> 🎯 **Pro Tip:** Check out the included demo scene for a complete setup example with all features enabled.

---

## 🎮 **Key Features**

### **🏃 Core Movement**
- **Responsive Ground Movement** - Smooth WASD controls with customizable speeds
- **Advanced Air Control** - Precise mid-air adjustments without feeling floaty
- **Sprint System** - Built-in energy management with optional integration points
- **Slope Physics** - Realistic sliding on steep surfaces with auto-detection

### **🦘 Advanced Jumping**
- **Coyote Time** - Grace period for jumps after leaving ground
- **Jump Cut** - Variable height jumps based on button hold duration
- **Double Jump** - Optional multi-jump system with customizable count
- **Wall Jumping** - Momentum-based wall jump chains with camera direction control

### **🤸 Movement Techniques**
- **Crouch & Slide** - Smooth crouching with momentum-based sliding
- **Tactical Dive** - High-speed dive system with recovery mechanics
- **Auto-Slide** - Intelligent slope detection for seamless traversal
- **Stair Climbing** - Automatic step-up assistance for smooth navigation

### **📹 Camera Integration**
- **FOV Effects** - Dynamic field-of-view changes for speed sensation
- **Camera Shake** - Impact feedback for landings and wall hits
- **Smooth Following** - Jitter-free camera tracking at any framerate

### **⚙️ Configuration System**
- **ScriptableObject Configs** - Data-driven setup with multiple presets
- **Runtime Customization** - Modify settings during gameplay
- **Inspector-Friendly** - Clear tooltips and organized sections
- **Validation** - Automatic value clamping and error prevention

---

## 📋 **Requirements**

- **Unity 2022.3 LTS** or newer
- **Universal Render Pipeline (URP)** (recommended, but works with Built-in)
- **CharacterController** component (automatically added)

### **Optional Integrations**
- **New Input System** (fallback to legacy Input Manager included)
- **Audio System** (3D positional sound support)
- **Animation System** (state management hooks included)

---

## 🛠️ **Setup Guide**

### **Method 1: Prefab Setup (Recommended)**
1. Drag `AAA Player Controller` prefab from `Prefabs/` folder into your scene
2. Position at your desired spawn point
3. Assign your main camera to the `Camera Transform` field in `AAAMovementController`
4. Configure movement settings in the `Movement Config` asset

### **Method 2: Manual Setup**
1. Create an empty GameObject for your player
2. Add `CharacterController` component
3. Add `AAAMovementController` script
4. Add `CleanAAACrouch` script (optional, for advanced crouch/slide)
5. Add `AAACameraController` to your camera (optional, for FOV effects)
6. Create or assign a `MovementConfig` asset

### **Method 3: Existing Character Integration**
1. Add `AAAMovementController` to your existing character
2. Disable any conflicting movement scripts
3. Configure the `Movement Config` to match your game's feel
4. Test and adjust settings in Play mode

---

## ⚙️ **Configuration**

### **Movement Config Asset**
The heart of the system. Create via: `Assets > Create > Game > Movement Configuration`

#### **Essential Settings:**
```csharp
// Core Physics
gravity = -7000f;              // Strong, responsive gravity
jumpForce = 1700f;            // Jump height (~65% of character height)
moveSpeed = 1300f;            // Base movement speed
sprintMultiplier = 1.55f;     // Sprint speed boost

// Air Control
airControlStrength = 0.25f;   // How much control you have while airborne
coyoteTime = 0.225f;         // Grace period for jumping after leaving ground

// Wall Jumping
wallJumpUpForce = 1300f;     // Vertical wall jump power
wallJumpOutForce = 1800f;    // Horizontal push from wall
wallJumpMomentumPreservation = 0.35f; // Keep 35% of previous velocity
```

#### **Presets Included:**
- **🎮 Arcade** - High speed, floaty physics, forgiving controls
- **🎯 Realistic** - Grounded feel, limited air control, weight-based
- **🏁 Fast-Paced** - Titanfall-inspired, momentum chains, skill-based
- **🎲 Platformer** - Precise controls, predictable physics, puzzle-friendly

### **Input Configuration**
Supports both legacy Input Manager and new Input System:

```csharp
// Legacy Input Manager (default)
Movement: WASD
Jump: Space
Sprint: Left Shift
Crouch: Left Ctrl or C
Dive: V (while sprinting)

// New Input System
Configure via InputActions asset - examples included
```

---

## 🎯 **Advanced Features**

### **Wall Jump System**
The crown jewel of the movement system - momentum-based wall jumping:

```csharp
// Momentum scaling - the secret sauce!
wallJumpFallSpeedBonus = 1f;  // 100% fall speed → horizontal speed
wallJumpCameraDirectionBoost = 900f; // Where you look = where you go
wallJumpInputInfluence = 1f;  // Full WASD control during wall jumps
```

**How it works:**
1. Fall speed gets converted to horizontal momentum
2. Camera direction influences jump trajectory
3. Input adds precision control
4. Previous velocity partially preserved for chaining

### **Slide System**
Intelligent sliding with multiple trigger conditions:

```csharp
// Auto-slide triggers:
- Crouch while sprinting on any slope >12°
- Automatically on steep slopes >50° (even without crouch)
- Manual crouch input for style points
- Smooth wall sliding using collide-and-slide algorithm
```

### **Performance Optimization**
Built for smooth 60fps gameplay:

```csharp
// Optimizations included:
- Cached component references
- Efficient ground detection
- Minimal garbage collection
- LOD-based update frequencies
- Object pooling for effects
```

---

## 🔧 **API Reference**

### **Core Movement Control**
```csharp
// Get movement controller reference
AAAMovementController movement = GetComponent<AAAMovementController>();

// Check movement state
bool isGrounded = movement.IsGrounded;
bool isWallSliding = movement.IsWallSliding;
Vector3 velocity = movement.GetVelocity();

// Apply external forces
movement.AddExternalForce(Vector3.up * 1000f, 0.5f); // Force + duration
movement.SetExternalVelocity(velocity, 1f);          // Override velocity

// Movement mode control
movement.SetMovementMode(MovementMode.Flying);       // Flying or Walking
```

### **Crouch & Slide Control**
```csharp
// Get crouch controller reference
CleanAAACrouch crouch = GetComponent<CleanAAACrouch>();

// Check crouch state
bool isCrouching = crouch.IsCrouching;
bool isSliding = crouch.IsSliding;
bool isDiving = crouch.IsDiving;

// Force slide (for gameplay mechanics)
crouch.ForceSlide(Vector3.forward, 2000f); // Direction + speed
```

### **Camera Control**
```csharp
// Get camera controller reference
AAACameraController camera = GetComponent<AAACameraController>();

// Apply camera effects
camera.AddTrauma(0.5f);                    // Screen shake intensity
camera.SetFOVBoost(1.2f, 0.5f);          // FOV multiplier + duration
```

### **Configuration Runtime Changes**
```csharp
// Modify config at runtime
MovementConfig config = movement.config;
config.jumpForce = 2000f;                  // Higher jumps
config.wallJumpMomentumPreservation = 0.5f; // More momentum preservation
```

---

## 🎨 **Customization Examples**

### **Make it Feel Like Titanfall**
```csharp
// High-speed momentum gameplay
config.wallJumpFallSpeedBonus = 1f;       // Max momentum transfer
config.wallJumpMomentumPreservation = 0.5f; // Keep lots of speed
config.airControlStrength = 0.15f;        // Limited air control
config.maxAirSpeed = 20000f;              // No speed limits!
```

### **Make it Feel Like Mario**
```csharp
// Precise platforming
config.coyoteTime = 0.3f;                 // Forgiving jump timing
config.airControlStrength = 0.8f;         // Full air control
config.jumpCutMultiplier = 0.3f;          // Variable jump height
config.wallJumpOutForce = 1200f;          // Gentle wall pushes
```

### **Make it Realistic**
```csharp
// Grounded, weighty feel
config.gravity = -9800f;                  // Real-world gravity
config.airControlStrength = 0.1f;         // Minimal air control
config.maxAirJumps = 0;                   // No double jumping
config.wallJumpUpForce = 800f;            // Realistic wall climb
```

---

## 🐛 **Troubleshooting**

### **Common Issues**

#### **Player falls through ground**
- Check `groundMask` includes your ground layer
- Increase `groundCheckDistance` in config
- Ensure CharacterController `skinWidth` isn't too large

#### **Wall jumping doesn't work**
- Verify walls are on layers included in `groundMask`
- Check `wallDetectionDistance` (should be ~1.25× character radius)
- Ensure wall surfaces have colliders

#### **Movement feels floaty**
- Increase `gravity` value (more negative = stronger)
- Reduce `airControlStrength` 
- Lower `jumpForce` for shorter jumps

#### **Player gets stuck on slopes**
- Check `maxSlopeAngle` setting (45-50° recommended)
- Verify `minimumSlopeAngle` is low (1-2°)
- Ensure slope surfaces are smooth (no gaps between colliders)

#### **Camera jitter**
- Enable `Fixed Timestep` in Project Settings > Time
- Use `AAACameraController` for smooth following
- Check for multiple cameras updating player position

### **Performance Issues**
- Disable debug visualizations in builds
- Use object pooling for particle effects
- Reduce `wallDetectionDistance` if not using wall jumping
- Consider LOD for complex character controllers

---

## 📞 **Support**

### **Documentation**
- 📖 **Complete API docs** included in `Documentation/` folder  
- 🎥 **Video tutorials** available on our YouTube channel
- 💡 **Example scripts** in `Examples/` folder

### **Community**
- 💬 **Discord server**: [Join our community](https://discord.gg/yourserver)
- 📧 **Email support**: support@yourstudio.com
- 🐛 **Bug reports**: Use GitHub issues or email

### **Updates**
- ✅ **Free updates** for all Asset Store customers
- 🔔 **Newsletter** for major feature announcements
- 📝 **Changelog** included with each version

---

## 📄 **License**

This asset is licensed under the Unity Asset Store End User License Agreement.
- ✅ Use in unlimited commercial projects
- ✅ Modify source code for your needs  
- ❌ Resell or redistribute as asset
- ❌ Share source code publicly

---

## 🚀 **What's Next?**

### **Planned Features**
- 🎯 **Grappling Hook** integration
- 🏃 **Parkour system** with automatic vaulting
- 🎮 **Gamepad** haptic feedback
- 🌊 **Swimming** mechanics
- 🚁 **Vehicle** transition system

### **Join the Community**
We're building the next generation of Unity movement systems. Get involved:
- Share your creations on social media with #AAAMovement
- Contribute ideas and feedback
- Beta test upcoming features

---

**Happy developing! 🎮**

*Built with ❤️ for the Unity community*