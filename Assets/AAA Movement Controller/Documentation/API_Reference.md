# 🔧 AAA Movement Controller - API Reference

## Table of Contents
- [Core Classes](#core-classes)
- [Movement Control](#movement-control)
- [Configuration](#configuration)
- [Events & Callbacks](#events--callbacks)
- [Integration Examples](#integration-examples)
- [Advanced Usage](#advanced-usage)

---

## Core Classes

### AAAMovementController
The main movement controller component.

```csharp
public class AAAMovementController : MonoBehaviour
```

#### Key Properties
```csharp
// Movement State
public bool IsGrounded { get; }                    // Current grounded state
public bool IsWallSliding { get; }                 // Wall sliding state
public Vector3 velocity { get; set; }              // Current velocity
public MovementMode currentMode { get; }           // Walking or Flying mode

// Configuration
public MovementConfig config;                      // Movement configuration asset
public CharacterController controller;             // CharacterController reference
public Transform cameraTransform;                  // Main camera transform
```

#### Core Methods
```csharp
// Movement Control
public void SetMovementMode(MovementMode mode)
public void AddExternalForce(Vector3 force, float duration)
public void SetExternalVelocity(Vector3 velocity, float duration)
public void ClearExternalForce()

// State Queries
public Vector3 GetVelocity()
public float GetSpeed()
public bool IsMoving()
public bool IsInAir()

// Configuration
public void ApplyConfig(MovementConfig newConfig)
public void ResetToDefaults()
```

### CleanAAACrouch
Advanced crouch, slide, and dive system.

```csharp
public class CleanAAACrouch : MonoBehaviour
```

#### Key Properties
```csharp
// State
public bool IsCrouching { get; }                   // Basic crouch state
public bool IsSliding { get; }                     // Sliding state
public bool IsDiving { get; }                      // Diving state
public bool IsInSlideableCrouch { get; }          // Can start sliding

// Configuration
public CrouchConfig config;                        // Crouch configuration asset
```

#### Core Methods
```csharp
// Manual Control
public void ForceSlide(Vector3 direction, float speed)
public void ForceDive(Vector3 direction, float speed)
public void ForceStand()

// State Queries
public float GetSlideSpeed()
public Vector3 GetSlideDirection()
public bool CanSlide()
public bool CanDive()
```

### AAACameraController
Camera system with FOV effects and shake.

```csharp
public class AAACameraController : MonoBehaviour
```

#### Core Methods
```csharp
// Camera Effects
public void AddTrauma(float intensity)            // Screen shake
public void SetFOVBoost(float multiplier, float duration)
public void ResetFOV()

// Speed-based Effects
public void UpdateSpeedFOV(float currentSpeed, float maxSpeed)
```

---

## Movement Control

### Basic Movement
```csharp
// Get movement controller
AAAMovementController movement = GetComponent<AAAMovementController>();

// Check if player is moving
if (movement.IsMoving())
{
    float speed = movement.GetSpeed();
    Debug.Log($"Player moving at {speed} units/second");
}

// Override player velocity (useful for launch pads, explosions)
movement.SetExternalVelocity(Vector3.up * 2000f, 1f); // 1 second duration
```

### Advanced Movement
```csharp
// Apply continuous force (wind, conveyor belt)
movement.AddExternalForce(Vector3.right * 500f, 5f); // 5 second duration

// Switch to flying mode
movement.SetMovementMode(MovementMode.Flying);

// Clear all external forces
movement.ClearExternalForce();
```

### Crouch and Slide Control
```csharp
CleanAAACrouch crouch = GetComponent<CleanAAACrouch>();

// Force a slide in specific direction (gameplay mechanic)
crouch.ForceSlide(transform.forward, 2000f);

// Check slide state for animation triggers
if (crouch.IsSliding)
{
    // Play slide animation
    // Spawn slide particles
}

// Tactical dive (useful for combat mechanics)
if (crouch.CanDive())
{
    crouch.ForceDive(playerLookDirection, 1500f);
}
```

---

## Configuration

### Runtime Configuration Changes
```csharp
// Modify movement feel at runtime
MovementConfig config = movement.config;

// Make jumping more responsive
config.gravity = -8000f;          // Stronger gravity
config.jumpForce = 2000f;         // Higher jumps
config.coyoteTime = 0.3f;         // More forgiving timing

// Make wall jumping more momentum-based
config.wallJumpMomentumPreservation = 0.6f;  // Keep more speed
config.wallJumpFallSpeedBonus = 1f;          // Max momentum transfer

// Apply changes (automatic - config is referenced)
```

### Creating Custom Presets
```csharp
// Create new configuration asset
public static MovementConfig CreateCustomConfig()
{
    var config = ScriptableObject.CreateInstance<MovementConfig>();
    
    // Titanfall-inspired settings
    config.gravity = -7000f;
    config.wallJumpMomentumPreservation = 0.7f;
    config.wallJumpFallSpeedBonus = 1f;
    config.maxAirSpeed = 25000f;
    
    return config;
}
```

### Layer Mask Configuration
```csharp
// Set what layers count as ground
config.groundMask = LayerMask.GetMask("Ground", "Platform", "MovingPlatform");

// Exclude certain layers
config.groundMask = ~LayerMask.GetMask("Player", "Ignore Raycast");
```

---

## Events & Callbacks

### Built-in Events
The system integrates with several optional event systems:

```csharp
// Landing detection (if using impact system)
private void OnEnable()
{
    ImpactEventBroadcaster.OnImpact += OnPlayerImpact;
}

private void OnPlayerImpact(ImpactData impact)
{
    if (impact.severityNormalized > 0.5f)
    {
        // Heavy landing - play sound, camera shake
        cameraController.AddTrauma(impact.traumaIntensity);
    }
}

// Wall jump events (if using XP system)
private void OnWallJump(Vector3 position)
{
    WallJumpXPSimple.Instance?.OnWallJumpPerformed(position);
}
```

### Custom Event Integration
```csharp
public class MovementEventManager : MonoBehaviour
{
    public static event System.Action<float> OnSpeedChanged;
    public static event System.Action OnJump;
    public static event System.Action OnLand;
    public static event System.Action<Vector3> OnWallJump;
    
    private AAAMovementController movement;
    private float lastSpeed;
    
    void Update()
    {
        float currentSpeed = movement.GetSpeed();
        if (Mathf.Abs(currentSpeed - lastSpeed) > 50f)
        {
            OnSpeedChanged?.Invoke(currentSpeed);
            lastSpeed = currentSpeed;
        }
    }
}
```

---

## Integration Examples

### Health System Integration
```csharp
public class HealthBasedMovement : MonoBehaviour
{
    public PlayerHealth health;
    public AAAMovementController movement;
    
    void Update()
    {
        // Reduce movement speed when injured
        float healthPercent = health.CurrentHealth / health.MaxHealth;
        movement.config.moveSpeed = Mathf.Lerp(600f, 1300f, healthPercent);
        
        // Disable wall jumping when critically injured
        movement.config.enableWallJump = healthPercent > 0.3f;
    }
}
```

### Audio System Integration
```csharp
public class MovementAudio : MonoBehaviour
{
    public AudioSource audioSource;
    public AudioClip[] footstepSounds;
    public AudioClip jumpSound;
    public AudioClip landSound;
    public AudioClip slideSound;
    
    private AAAMovementController movement;
    private CleanAAACrouch crouch;
    
    void Update()
    {
        // Footstep timing based on movement speed
        if (movement.IsGrounded && movement.IsMoving())
        {
            float stepInterval = Mathf.Lerp(0.5f, 0.2f, movement.GetSpeed() / 2000f);
            // Play footstep at calculated interval
        }
        
        // Slide audio loop
        if (crouch.IsSliding && !audioSource.isPlaying)
        {
            audioSource.clip = slideSound;
            audioSource.loop = true;
            audioSource.Play();
        }
        else if (!crouch.IsSliding && audioSource.clip == slideSound)
        {
            audioSource.Stop();
        }
    }
}
```

### Animation System Integration
```csharp
public class MovementAnimator : MonoBehaviour
{
    public Animator animator;
    private AAAMovementController movement;
    private CleanAAACrouch crouch;
    
    // Animation parameter hashes for performance
    private static readonly int SpeedHash = Animator.StringToHash("Speed");
    private static readonly int IsGroundedHash = Animator.StringToHash("IsGrounded");
    private static readonly int IsCrouchingHash = Animator.StringToHash("IsCrouching");
    private static readonly int IsWallSlidingHash = Animator.StringToHash("IsWallSliding");
    
    void Update()
    {
        // Update animation parameters
        animator.SetFloat(SpeedHash, movement.GetSpeed() / movement.config.moveSpeed);
        animator.SetBool(IsGroundedHash, movement.IsGrounded);
        animator.SetBool(IsCrouchingHash, crouch.IsCrouching);
        animator.SetBool(IsWallSlidingHash, movement.IsWallSliding);
    }
    
    // Trigger one-shot animations
    public void OnJump() => animator.SetTrigger("Jump");
    public void OnLand() => animator.SetTrigger("Land");
    public void OnWallJump() => animator.SetTrigger("WallJump");
}
```

---

## Advanced Usage

### Custom Movement Modes
```csharp
public class WaterMovement : MonoBehaviour
{
    public AAAMovementController movement;
    private MovementConfig originalConfig;
    private MovementConfig waterConfig;
    
    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            // Store original config
            originalConfig = movement.config;
            
            // Apply water movement
            waterConfig = CreateWaterConfig();
            movement.ApplyConfig(waterConfig);
        }
    }
    
    MovementConfig CreateWaterConfig()
    {
        var config = ScriptableObject.Instantiate(originalConfig);
        config.gravity = -2000f;           // Buoyancy
        config.airControlStrength = 0.9f;  // Full 3D control
        config.maxAirSpeed = 800f;         // Slower in water
        config.jumpForce = 1000f;          // Swimming up
        return config;
    }
}
```

### Performance Monitoring
```csharp
public class MovementProfiler : MonoBehaviour
{
    private AAAMovementController movement;
    
    void Update()
    {
        using (Profiler.BeginSample("Movement Performance Check"))
        {
            // Monitor movement system performance
            float updateTime = Time.deltaTime;
            if (updateTime > 0.016f) // >16ms = <60fps
            {
                Debug.LogWarning($"Movement frame time: {updateTime * 1000f:F1}ms");
            }
        }
    }
}
```

### AI Movement Integration
```csharp
public class AIMovementController : MonoBehaviour
{
    public AAAMovementController movement;
    public NavMeshAgent agent;
    
    void Update()
    {
        // Use AAA movement for AI characters
        if (agent.hasPath)
        {
            Vector3 direction = (agent.steeringTarget - transform.position).normalized;
            
            // Simulate input for movement system
            movement.SetInput(direction.x, direction.z);
            
            // AI wall jumping
            if (movement.IsWallSliding && agent.remainingDistance > 2f)
            {
                movement.TriggerJump(); // Custom method for AI
            }
        }
    }
}
```

### Networking Integration (Multiplayer)
```csharp
public class NetworkedMovement : MonoBehaviour
{
    [SyncVar] private Vector3 networkVelocity;
    [SyncVar] private bool networkIsGrounded;
    
    private AAAMovementController movement;
    
    void Update()
    {
        if (isLocalPlayer)
        {
            // Send state to server
            CmdUpdateMovementState(movement.velocity, movement.IsGrounded);
        }
        else
        {
            // Apply networked state
            movement.velocity = networkVelocity;
            // Smooth interpolation for remote players
        }
    }
    
    [Command]
    void CmdUpdateMovementState(Vector3 velocity, bool grounded)
    {
        networkVelocity = velocity;
        networkIsGrounded = grounded;
    }
}
```

---

## Debugging and Diagnostics

### Debug Visualization
```csharp
void OnDrawGizmos()
{
    if (movement != null && movement.config.showWallJumpDebug)
    {
        // Visualize wall detection rays
        Gizmos.color = movement.IsWallSliding ? Color.red : Color.yellow;
        Gizmos.DrawRay(transform.position, transform.right * movement.config.wallDetectionDistance);
        Gizmos.DrawRay(transform.position, -transform.right * movement.config.wallDetectionDistance);
        
        // Visualize ground check
        Gizmos.color = movement.IsGrounded ? Color.green : Color.red;
        Gizmos.DrawRay(transform.position, Vector3.down * movement.config.groundCheckDistance);
    }
}
```

### Performance Metrics
```csharp
public class MovementMetrics : MonoBehaviour
{
    public Text speedDisplay;
    public Text stateDisplay;
    
    private AAAMovementController movement;
    
    void Update()
    {
        if (speedDisplay != null)
        {
            speedDisplay.text = $"Speed: {movement.GetSpeed():F0} u/s";
        }
        
        if (stateDisplay != null)
        {
            string state = movement.IsGrounded ? "Grounded" : "Airborne";
            if (movement.IsWallSliding) state += " + Wall Sliding";
            stateDisplay.text = state;
        }
    }
}
```

---

This API reference provides comprehensive coverage of the AAA Movement Controller system. For more examples and detailed implementation guides, check the included example scenes and scripts in the `Examples/` folder.