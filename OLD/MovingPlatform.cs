using UnityEngine;

/// <summary>
/// AAA Moving Platform - Professional testing tool for AAAMovementController.
/// Showcases platform parenting, rotation, and complex movement patterns.
/// Perfect for demonstrating your controller's stability at any speed/rotation.
/// </summary>
public class MovingPlatform : MonoBehaviour
{
    [Header("=== 🎮 QUICK PRESETS ===")]
    [Tooltip("Load preset configuration (overrides manual settings below)")]
    [SerializeField] private PlatformPreset preset = PlatformPreset.Custom;
    
    [Header("=== ROTATION SETTINGS ===")]
    [Tooltip("Rotation speed in degrees per second around each axis")]
    [SerializeField] private Vector3 rotationSpeed = new Vector3(0f, 30f, 0f);
    
    [Tooltip("Local space rotation (relative to platform's initial orientation)")]
    [SerializeField] private bool useLocalRotation = true;
    
    [Header("=== MOVEMENT SETTINGS (OPTIONAL) ===")]
    [Tooltip("Enable linear movement in addition to rotation")]
    [SerializeField] private bool enableLinearMovement = false;
    
    [Tooltip("Movement speed in units per second")]
    [SerializeField] private float moveSpeed = 500f;
    
    [Tooltip("Movement pattern (PingPong or Loop)")]
    [SerializeField] private MovementPattern movementPattern = MovementPattern.PingPong;
    
    [Tooltip("Waypoints for linear movement (leave empty to disable)")]
    [SerializeField] private Transform[] waypoints;
    
    [Header("=== OSCILLATION (OPTIONAL) ===")]
    [Tooltip("Enable smooth oscillating movement (sine wave motion)")]
    [SerializeField] private bool enableOscillation = false;
    
    [Tooltip("Oscillation amplitude (movement distance from center)")]
    [SerializeField] private Vector3 oscillationAmplitude = new Vector3(0f, 100f, 0f);
    
    [Tooltip("Oscillation frequency (cycles per second)")]
    [SerializeField] private float oscillationFrequency = 0.5f;
    
    [Header("=== PLATFORM BEHAVIOR ===")]
    [Tooltip("Transport method: Parent (rotates with platform) or Manual (no rotation)")]
    [SerializeField] private TransportMode transportMode = TransportMode.Manual;
    
    [Tooltip("Layer mask for detecting players")]
    [SerializeField] private LayerMask playerLayer = -1;
    
    [Tooltip("Detection area - how much wider than platform to detect (0 = exact platform size)")]
    [SerializeField] private float detectionPadding = 50f;
    
    [Tooltip("Detection height above platform surface")]
    [SerializeField] private float detectionHeight = 400f;
    
    public enum TransportMode
    {
        Manual,    // Move player manually (no parenting, no rotation)
        Parent     // Parent player (rotates with platform)
    }
    
    [Header("=== STRESS TEST OPTIONS ===")]
    [Tooltip("Enable extreme speed testing (showcases controller stability)")]
    [SerializeField] private bool extremeSpeedMode = false;
    
    [Tooltip("Speed multiplier when in extreme mode")]
    [SerializeField] private float extremeSpeedMultiplier = 5f;
    
    [Header("=== DEBUG ===")]
    [Tooltip("Show debug information in console")]
    [SerializeField] private bool showDebug = false;
    
    [Tooltip("Draw gizmos in editor")]
    [SerializeField] private bool showGizmos = true;
    
    // Preset configurations for quick testing
    public enum PlatformPreset
    {
        Custom,              // Manual configuration
        RotatingY,           // Slow Y-axis rotation (turntable)
        RotatingFast,        // Fast multi-axis rotation (challenge mode)
        Elevator,            // Vertical oscillation (lift)
        Pendulum,            // Horizontal swing (side-to-side)
        Carousel,            // Rotation + circular movement
        Orbital,             // Complex 3D rotation pattern
        SpeedTest            // Extreme speed stress test
    }
    
    // Movement pattern types
    public enum MovementPattern
    {
        PingPong,  // Move back and forth between waypoints
        Loop       // Move in a continuous loop through waypoints
    }
    
    // Private state
    private int currentWaypointIndex = 0;
    private bool movingForward = true;
    private Vector3 velocity = Vector3.zero;
    private Transform playerTransform = null;
    private CharacterController playerController = null;
    private Vector3 initialPosition;
    private float oscillationTime = 0f;
    private PlatformPreset lastPreset = PlatformPreset.Custom;
    private bool playerOnPlatform = false;
    
    // Manual transport tracking
    private Vector3 lastPlatformPosition;
    private Vector3 platformMoveDelta;
    
    void Start()
    {
        // Store initial position for oscillation
        initialPosition = transform.position;
        lastPlatformPosition = transform.position;
        
        // Apply preset if selected
        if (preset != PlatformPreset.Custom)
        {
            ApplyPreset(preset);
        }
        
        // Validate waypoints
        if (enableLinearMovement && (waypoints == null || waypoints.Length < 2))
        {
            Debug.LogWarning($"[MovingPlatform] {gameObject.name}: Linear movement enabled but not enough waypoints assigned. Disabling linear movement.");
            enableLinearMovement = false;
        }
        
        if (showDebug)
        {
            Debug.Log($"[MovingPlatform] {gameObject.name} initialized. Preset: {preset}, Rotation: {rotationSpeed}, Linear: {enableLinearMovement}, Oscillation: {enableOscillation}");
        }
    }
    
    void Update()
    {
        // Check if preset changed in editor (allows runtime testing)
        if (preset != lastPreset && preset != PlatformPreset.Custom)
        {
            ApplyPreset(preset);
            lastPreset = preset;
        }
    }
    
    void FixedUpdate()
    {
        // Store position before movement
        lastPlatformPosition = transform.position;
        
        // Apply speed multiplier for stress testing
        float speedMultiplier = extremeSpeedMode ? extremeSpeedMultiplier : 1f;
        
        // Apply rotation (around local center, not pivot)
        if (rotationSpeed.sqrMagnitude > 0.01f)
        {
            Vector3 rotationDelta = rotationSpeed * speedMultiplier * Time.fixedDeltaTime;
            
            // Rotate around the platform's own center (local space)
            transform.Rotate(rotationDelta, Space.Self);
        }
        
        // Apply oscillation (smooth sine wave motion)
        if (enableOscillation)
        {
            oscillationTime += Time.fixedDeltaTime * oscillationFrequency * speedMultiplier;
            Vector3 oscillationOffset = new Vector3(
                oscillationAmplitude.x * Mathf.Sin(oscillationTime * Mathf.PI * 2f),
                oscillationAmplitude.y * Mathf.Sin(oscillationTime * Mathf.PI * 2f),
                oscillationAmplitude.z * Mathf.Sin(oscillationTime * Mathf.PI * 2f)
            );
            transform.position = initialPosition + oscillationOffset;
        }
        
        // Apply linear movement (if enabled and not using oscillation)
        if (enableLinearMovement && !enableOscillation && waypoints != null && waypoints.Length >= 2)
        {
            MoveAlongWaypoints(speedMultiplier);
        }
        
        // Calculate platform movement delta
        platformMoveDelta = transform.position - lastPlatformPosition;
        
        // Calculate actual velocity (for physics interactions)
        velocity = platformMoveDelta / Time.fixedDeltaTime;
        
        // Detect player and transport them
        DetectAndTransportPlayer();
    }
    
    /// <summary>
    /// Move platform along waypoints based on selected pattern
    /// </summary>
    private void MoveAlongWaypoints(float speedMultiplier = 1f)
    {
        Transform targetWaypoint = waypoints[currentWaypointIndex];
        
        if (targetWaypoint == null)
        {
            Debug.LogWarning($"[MovingPlatform] Waypoint {currentWaypointIndex} is null!");
            return;
        }
        
        // Move towards current waypoint
        Vector3 direction = (targetWaypoint.position - transform.position).normalized;
        float distance = Vector3.Distance(transform.position, targetWaypoint.position);
        float step = moveSpeed * speedMultiplier * Time.fixedDeltaTime;
        
        if (distance <= step)
        {
            // Reached waypoint - move to next
            transform.position = targetWaypoint.position;
            SelectNextWaypoint();
        }
        else
        {
            // Move towards waypoint
            transform.position += direction * step;
        }
    }
    
    /// <summary>
    /// Select next waypoint based on movement pattern
    /// </summary>
    private void SelectNextWaypoint()
    {
        if (movementPattern == MovementPattern.Loop)
        {
            // Loop pattern: 0 -> 1 -> 2 -> 0 -> 1 -> 2...
            currentWaypointIndex = (currentWaypointIndex + 1) % waypoints.Length;
        }
        else // PingPong
        {
            // PingPong pattern: 0 -> 1 -> 2 -> 1 -> 0 -> 1 -> 2...
            if (movingForward)
            {
                currentWaypointIndex++;
                if (currentWaypointIndex >= waypoints.Length)
                {
                    currentWaypointIndex = waypoints.Length - 2;
                    movingForward = false;
                }
            }
            else
            {
                currentWaypointIndex--;
                if (currentWaypointIndex < 0)
                {
                    currentWaypointIndex = 1;
                    movingForward = true;
                }
            }
        }
        
        if (showDebug)
        {
            Debug.Log($"[MovingPlatform] Moving to waypoint {currentWaypointIndex}");
        }
    }
    
    /// <summary>
    /// Detect player on platform and transport them (manual or parent mode)
    /// </summary>
    private void DetectAndTransportPlayer()
    {
        bool wasOnPlatform = playerOnPlatform;
        playerOnPlatform = false;
        
        // Get platform bounds from collider
        Collider platformCollider = GetComponent<Collider>();
        if (platformCollider == null)
        {
            if (showDebug)
                Debug.LogWarning($"[MovingPlatform] No collider found on {gameObject.name}!");
            return;
        }
        
        // Calculate detection box based on platform's actual size
        Bounds bounds = platformCollider.bounds;
        Vector3 detectionSize = new Vector3(
            bounds.size.x + detectionPadding,
            detectionHeight,
            bounds.size.z + detectionPadding
        );
        // Center the detection box just above the platform surface
        Vector3 detectionCenter = new Vector3(
            bounds.center.x,
            bounds.max.y + (detectionHeight * 0.5f),
            bounds.center.z
        );
        
        // Search for player on platform (use world-aligned box, not rotated)
        Collider[] colliders = Physics.OverlapBox(
            detectionCenter,
            detectionSize * 0.5f,
            Quaternion.identity  // World-aligned, not rotated with platform
        );
        
        foreach (Collider col in colliders)
        {
            CharacterController controller = col.GetComponent<CharacterController>();
            AAAMovementController movementController = col.GetComponent<AAAMovementController>();
            
            if (controller != null && movementController != null)
            {
                // Check if player is grounded AND touching this platform
                if (movementController.IsGrounded)
                {
                    // Raycast from player down to find what they're standing on
                    RaycastHit hit;
                    Vector3 rayOrigin = col.transform.position;
                    float rayDistance = controller.height + 50f;
                    
                    if (Physics.Raycast(rayOrigin, Vector3.down, out hit, rayDistance))
                    {
                        // Check if the hit object is this platform or a child of it
                        Transform hitTransform = hit.collider.transform;
                        bool isOnThisPlatform = hitTransform == transform || hitTransform.IsChildOf(transform);
                        
                        if (isOnThisPlatform)
                        {
                            // Player is on platform
                            playerOnPlatform = true;
                            playerTransform = col.transform;
                            playerController = controller;
                            
                            // Transport based on mode
                            if (transportMode == TransportMode.Manual)
                            {
                                // Manual: Move player by platform delta (no rotation, no parenting)
                                if (platformMoveDelta.sqrMagnitude > 0.0001f)
                                {
                                    controller.Move(platformMoveDelta);
                                }
                                
                                // Ensure player is NOT parented
                                if (playerTransform.parent == transform)
                                {
                                    playerTransform.SetParent(null);
                                }
                            }
                            else // TransportMode.Parent
                            {
                                // Parent mode: Parent player (includes rotation)
                                if (playerTransform.parent != transform)
                                {
                                    playerTransform.SetParent(transform);
                                    
                                    if (showDebug)
                                    {
                                        Debug.Log($"[MovingPlatform] Player parented to platform {gameObject.name}");
                                    }
                                }
                            }
                            
                            if (showDebug && !wasOnPlatform)
                            {
                                Debug.Log($"[MovingPlatform] Player on platform (Mode: {transportMode})");
                            }
                            
                            return;
                        }
                    }
                }
            }
        }
        
        // Player left platform
        if (wasOnPlatform && !playerOnPlatform)
        {
            if (showDebug)
            {
                Debug.Log($"[MovingPlatform] Player left platform {gameObject.name}");
            }
            
            // Unparent player if in parent mode
            if (transportMode == TransportMode.Parent && playerTransform != null && playerTransform.parent == transform)
            {
                playerTransform.SetParent(null);
            }
            
            playerTransform = null;
            playerController = null;
        }
    }
    
    /// <summary>
    /// OLD METHOD - kept for compatibility
    /// </summary>
    private void DetectAndParentPlayerOld()
    {
        // Check if player is already parented
        if (playerTransform != null && playerTransform.parent == transform)
        {
            // Verify player is still grounded on platform
            if (!IsPlayerOnPlatform(playerTransform, playerController))
            {
                UnparentPlayer();
            }
            return;
        }
        
        // Get platform bounds from collider
        Collider platformCollider = GetComponent<Collider>();
        if (platformCollider == null)
        {
            if (showDebug)
                Debug.LogWarning($"[MovingPlatform] No collider found on {gameObject.name}!");
            return;
        }
        
        // Calculate detection box based on platform's actual size
        Bounds bounds = platformCollider.bounds;
        Vector3 detectionSize = new Vector3(
            bounds.size.x + detectionPadding,
            detectionHeight,
            bounds.size.z + detectionPadding
        );
        // Center the detection box just above the platform surface
        Vector3 detectionCenter = new Vector3(
            bounds.center.x,
            bounds.max.y + (detectionHeight * 0.5f),
            bounds.center.z
        );
        
        // Search for player on platform (use world-aligned box, not rotated)
        Collider[] colliders = Physics.OverlapBox(
            detectionCenter,
            detectionSize * 0.5f,
            Quaternion.identity  // World-aligned, not rotated with platform
        );
        
        foreach (Collider col in colliders)
        {
            CharacterController controller = col.GetComponent<CharacterController>();
            AAAMovementController movementController = col.GetComponent<AAAMovementController>();
            
            if (controller != null && movementController != null)
            {
                // Check if player is grounded AND touching this platform
                if (movementController.IsGrounded)
                {
                    // Raycast from player down to find what they're standing on
                    RaycastHit hit;
                    Vector3 rayOrigin = col.transform.position;
                    float rayDistance = controller.height + 50f; // Extra distance for safety
                    
                    if (Physics.Raycast(rayOrigin, Vector3.down, out hit, rayDistance))
                    {
                        // Check if the hit object is this platform or a child of it
                        Transform hitTransform = hit.collider.transform;
                        bool isOnThisPlatform = hitTransform == transform || hitTransform.IsChildOf(transform);
                        
                        if (isOnThisPlatform)
                        {
                            // Player is on this platform - parent them
                            playerTransform = col.transform;
                            playerController = controller;
                            playerTransform.SetParent(transform);
                            
                            if (showDebug)
                            {
                                Debug.Log($"[MovingPlatform] Player parented to platform {gameObject.name} at height {hit.distance}");
                            }
                            
                            return;
                        }
                    }
                }
            }
        }
    }
    
    /// <summary>
    /// Check if player is still on the platform
    /// </summary>
    private bool IsPlayerOnPlatform(Transform player, CharacterController controller)
    {
        if (player == null || controller == null)
            return false;
        
        // Get movement controller to check grounded state
        AAAMovementController movementController = player.GetComponent<AAAMovementController>();
        if (movementController == null || !movementController.IsGrounded)
            return false;
        
        // Get platform bounds
        Collider platformCollider = GetComponent<Collider>();
        if (platformCollider == null)
            return false;
        
        Bounds bounds = platformCollider.bounds;
        
        // Check if player is within platform bounds (with padding)
        Vector3 playerPos = player.position;
        if (playerPos.x < bounds.min.x - detectionPadding || playerPos.x > bounds.max.x + detectionPadding)
            return false;
        if (playerPos.z < bounds.min.z - detectionPadding || playerPos.z > bounds.max.z + detectionPadding)
            return false;
        
        // Raycast down to verify what player is standing on
        RaycastHit hit;
        Vector3 rayOrigin = player.position;
        float rayDistance = controller.height + detectionHeight;
        
        if (Physics.Raycast(rayOrigin, Vector3.down, out hit, rayDistance))
        {
            Transform hitTransform = hit.collider.transform;
            return hitTransform == transform || hitTransform.IsChildOf(transform);
        }
        
        return false;
    }
    
    /// <summary>
    /// Unparent player from platform
    /// </summary>
    private void UnparentPlayer()
    {
        if (playerTransform != null)
        {
            if (showDebug)
            {
                Debug.Log($"[MovingPlatform] Player unparented from platform {gameObject.name}");
            }
            
            playerTransform.SetParent(null);
            playerTransform = null;
            playerController = null;
        }
    }
    
    /// <summary>
    /// Get current platform velocity (for external systems)
    /// </summary>
    public Vector3 GetVelocity()
    {
        return velocity;
    }
    
    /// <summary>
    /// Check if player is currently on this platform
    /// </summary>
    public bool IsPlayerInPlatform(CharacterController controller)
    {
        return playerController == controller && playerTransform != null && playerTransform.parent == transform;
    }
    
    /// <summary>
    /// Apply preset configuration for quick testing
    /// </summary>
    private void ApplyPreset(PlatformPreset presetType)
    {
        switch (presetType)
        {
            case PlatformPreset.RotatingY:
                // Gentle turntable - showcases basic stability
                rotationSpeed = new Vector3(0f, 20f, 0f);
                enableLinearMovement = false;
                enableOscillation = false;
                extremeSpeedMode = false;
                useLocalRotation = true;
                break;
                
            case PlatformPreset.RotatingFast:
                // Fast multi-axis - tests controller's handling of complex rotation
                rotationSpeed = new Vector3(15f, 45f, 10f);
                enableLinearMovement = false;
                enableOscillation = false;
                extremeSpeedMode = false;
                useLocalRotation = true;
                break;
                
            case PlatformPreset.Elevator:
                // Vertical oscillation - classic elevator test
                rotationSpeed = Vector3.zero;
                enableLinearMovement = false;
                enableOscillation = true;
                oscillationAmplitude = new Vector3(0f, 500f, 0f);
                oscillationFrequency = 0.3f;
                extremeSpeedMode = false;
                break;
                
            case PlatformPreset.Pendulum:
                // Horizontal swing - tests lateral stability
                rotationSpeed = Vector3.zero;
                enableLinearMovement = false;
                enableOscillation = true;
                oscillationAmplitude = new Vector3(800f, 0f, 0f);
                oscillationFrequency = 0.4f;
                extremeSpeedMode = false;
                break;
                
            case PlatformPreset.Carousel:
                // Rotation + circular motion - complex combined movement
                rotationSpeed = new Vector3(0f, 30f, 0f);
                enableLinearMovement = false;
                enableOscillation = true;
                oscillationAmplitude = new Vector3(600f, 0f, 600f);
                oscillationFrequency = 0.2f;
                extremeSpeedMode = false;
                useLocalRotation = true;
                break;
                
            case PlatformPreset.Orbital:
                // Complex 3D rotation - ultimate stability test
                rotationSpeed = new Vector3(20f, 35f, 15f);
                enableLinearMovement = false;
                enableOscillation = true;
                oscillationAmplitude = new Vector3(300f, 200f, 300f);
                oscillationFrequency = 0.25f;
                extremeSpeedMode = false;
                useLocalRotation = false;
                break;
                
            case PlatformPreset.SpeedTest:
                // Extreme speed - showcases controller's robustness
                rotationSpeed = new Vector3(30f, 90f, 20f);
                enableLinearMovement = false;
                enableOscillation = true;
                oscillationAmplitude = new Vector3(1000f, 500f, 1000f);
                oscillationFrequency = 0.5f;
                extremeSpeedMode = true;
                extremeSpeedMultiplier = 3f;
                useLocalRotation = true;
                break;
        }
        
        // Reset oscillation timer for smooth transitions
        oscillationTime = 0f;
        initialPosition = transform.position;
        
        if (showDebug)
        {
            Debug.Log($"[MovingPlatform] Applied preset: {presetType}");
        }
    }
    
    // Draw gizmos in editor
    void OnDrawGizmos()
    {
        if (!showGizmos)
            return;
        
        // Get platform bounds from collider
        Collider platformCollider = GetComponent<Collider>();
        if (platformCollider != null)
        {
            Bounds bounds = platformCollider.bounds;
            
            // Calculate detection box based on platform's actual size
            Vector3 detectionSize = new Vector3(
                bounds.size.x + detectionPadding,
                detectionHeight,
                bounds.size.z + detectionPadding
            );
            Vector3 detectionCenter = bounds.center + Vector3.up * (detectionHeight * 0.5f - bounds.extents.y);
            
            // Draw detection box
            Gizmos.color = playerOnPlatform ? Color.green : Color.yellow;
            Gizmos.DrawWireCube(detectionCenter, detectionSize);
            
            // Draw platform bounds
            Gizmos.color = Color.red;
            Gizmos.DrawWireCube(bounds.center, bounds.size);
        }
        else
        {
            // Fallback if no collider
            Gizmos.color = Color.red;
            Gizmos.DrawWireCube(transform.position, Vector3.one * 100f);
        }
        
        // Draw platform rotation axis
        Gizmos.color = Color.cyan;
        if (rotationSpeed.x != 0)
            Gizmos.DrawLine(transform.position, transform.position + transform.right * 2f);
        if (rotationSpeed.y != 0)
            Gizmos.DrawLine(transform.position, transform.position + transform.up * 2f);
        if (rotationSpeed.z != 0)
            Gizmos.DrawLine(transform.position, transform.position + transform.forward * 2f);
        
        // Draw waypoints
        if (enableLinearMovement && waypoints != null && waypoints.Length >= 2)
        {
            Gizmos.color = Color.cyan;
            
            for (int i = 0; i < waypoints.Length; i++)
            {
                if (waypoints[i] == null)
                    continue;
                
                // Draw waypoint sphere
                Gizmos.DrawWireSphere(waypoints[i].position, 50f);
                
                // Draw line to next waypoint
                int nextIndex = (i + 1) % waypoints.Length;
                if (waypoints[nextIndex] != null)
                {
                    Gizmos.DrawLine(waypoints[i].position, waypoints[nextIndex].position);
                }
            }
        }
        
        // Draw oscillation path
        if (enableOscillation)
        {
            Gizmos.color = Color.magenta;
            Vector3 startPos = initialPosition - oscillationAmplitude;
            Vector3 endPos = initialPosition + oscillationAmplitude;
            Gizmos.DrawLine(startPos, endPos);
            Gizmos.DrawWireSphere(startPos, 30f);
            Gizmos.DrawWireSphere(endPos, 30f);
        }
    }
    
    // Runtime debug visualization
    void OnDrawGizmosSelected()
    {
        if (!showDebug)
            return;
            
        // Draw raycast from player to platform if parented
        if (playerTransform != null && playerController != null)
        {
            Gizmos.color = Color.green;
            Gizmos.DrawLine(playerTransform.position, transform.position);
            Gizmos.DrawWireSphere(playerTransform.position, playerController.radius);
        }
    }
}
