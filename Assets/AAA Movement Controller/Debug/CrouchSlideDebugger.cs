using UnityEngine;

/// <summary>
/// Debug utility to diagnose why slope sliding isn't working when pressing crouch.
/// Attach this to your player to see detailed information about slide conditions.
/// </summary>
public class CrouchSlideDebugger : MonoBehaviour
{
    [Header("Debug Settings")]
    public bool enableDebugOutput = true;
    public bool showDebugGUI = true;
    public KeyCode debugKey = KeyCode.F1;
    
    private CleanAAACrouch crouchController;
    private AAAMovementController movement;
    private CharacterController controller;
    
    // Debug state tracking
    private bool lastCrouchPressed = false;
    private float lastSlopeAngle = 0f;
    private Vector3 lastGroundNormal = Vector3.up;
    private string lastFailReason = "";
    
    void Start()
    {
        crouchController = GetComponent<CleanAAACrouch>();
        movement = GetComponent<AAAMovementController>();
        controller = GetComponent<CharacterController>();
        
        if (crouchController == null)
        {
            Debug.LogError("CrouchSlideDebugger: No CleanAAACrouch component found!");
            enabled = false;
        }
    }
    
    void Update()
    {
        if (!enableDebugOutput) return;
        
        // Use the same input detection as the crouch controller
        bool crouchPressed = Input.GetKeyDown(Controls.Crouch);
        
        // Check when crouch is pressed
        if (crouchPressed && !lastCrouchPressed)
        {
            AnalyzeSlideConditions();
        }
        
        // Manual debug trigger
        if (Input.GetKeyDown(debugKey))
        {
            AnalyzeSlideConditions();
        }
        
        lastCrouchPressed = crouchPressed;
    }
    
    void AnalyzeSlideConditions()
    {
        Debug.Log("=== CROUCH SLIDE ANALYSIS ===");
        
        // Check component availability
        if (crouchController == null)
        {
            Debug.LogError("❌ CleanAAACrouch component missing!");
            return;
        }
        
        if (movement == null)
        {
            Debug.LogError("❌ AAAMovementController component missing!");
            return;
        }
        
        // Check configuration
        var config = crouchController.Config;
        bool autoSlideEnabled = true; // Default value since enableAutoSlide is private
        bool slideEnabled = true; // Default value since enableSlide is private
        
        Debug.Log($"🔧 Configuration:");
        Debug.Log($"   - Config asset: {(config != null ? config.name : "NULL (using inspector values)")}");
        
        // Check current state
        bool isGrounded = movement.IsGrounded;
        bool isWalking = movement.CurrentMode == AAAMovementController.MovementMode.Walking;
        bool isDiving = crouchController.IsDiving;
        bool isDiveProne = crouchController.IsDiveProne;
        bool isSliding = crouchController.IsSliding;
        bool isCrouching = crouchController.IsCrouching;
        
        Debug.Log($"🎮 Current State:");
        Debug.Log($"   - Grounded: {isGrounded}");
        Debug.Log($"   - Walking Mode: {isWalking}");
        Debug.Log($"   - Is Diving: {isDiving}");
        Debug.Log($"   - Is Dive Prone: {isDiveProne}");
        Debug.Log($"   - Is Sliding: {isSliding}");
        Debug.Log($"   - Is Crouching: {isCrouching}");
        
        // Check ground slope - using multiple detection methods
        RaycastHit hit;
        bool hasGroundSimple = Physics.Raycast(transform.position + Vector3.up * 0.1f, Vector3.down, out hit, 2f);
        
        // Try different raycast positions and directions
        RaycastHit hitCenter, hitForward, hitBack;
        bool hasGroundCenter = Physics.Raycast(transform.position, Vector3.down, out hitCenter, 3f);
        bool hasGroundForward = Physics.Raycast(transform.position + transform.forward * 0.5f, Vector3.down, out hitForward, 3f);
        bool hasGroundBack = Physics.Raycast(transform.position - transform.forward * 0.5f, Vector3.down, out hitBack, 3f);
        
        Debug.Log($"🔍 Multiple Ground Tests:");
        if (hasGroundSimple)
        {
            float angle1 = Vector3.Angle(Vector3.up, hit.normal);
            Debug.Log($"   - Simple (up 0.1): {angle1:F1}° | Normal: {hit.normal} | Object: {hit.collider.name}");
        }
        if (hasGroundCenter)
        {
            float angle2 = Vector3.Angle(Vector3.up, hitCenter.normal);
            Debug.Log($"   - Center: {angle2:F1}° | Normal: {hitCenter.normal} | Object: {hitCenter.collider.name}");
        }
        if (hasGroundForward)
        {
            float angle3 = Vector3.Angle(Vector3.up, hitForward.normal);
            Debug.Log($"   - Forward: {angle3:F1}° | Normal: {hitForward.normal} | Object: {hitForward.collider.name}");
        }
        if (hasGroundBack)
        {
            float angle4 = Vector3.Angle(Vector3.up, hitBack.normal);
            Debug.Log($"   - Back: {angle4:F1}° | Normal: {hitBack.normal} | Object: {hitBack.collider.name}");
        }
        
        // Also test the crouch controller's ground detection
        bool hasGroundCrouch = false;
        RaycastHit crouchHit = default;
        bool hasGround = false; // Declare the final result variable here
        
        // Try to access the private ProbeGround method through reflection or test similar logic
        if (crouchController != null && controller != null)
        {
            // Replicate the ProbeGround logic for debugging
            float bottomOffset = controller.height * 0.5f - Mathf.Max(controller.radius, 0.01f);
            Vector3 localBottom = controller.center + Vector3.down * bottomOffset;
            Vector3 bottomSphereCenter = transform.TransformPoint(localBottom);
            float radius = Mathf.Max(0.01f, controller.radius - 0.02f);
            Vector3 origin = bottomSphereCenter + Vector3.up * 0.2f;
            float dynamicGroundCheck = Mathf.Max(640f, controller.height * 0.5f); // slideGroundCheckDistance default
            
            // Test with All layers first
            hasGroundCrouch = Physics.SphereCast(
                origin,
                radius,
                Vector3.down,
                out crouchHit,
                dynamicGroundCheck,
                -1, // All layers for debugging
                QueryTriggerInteraction.Ignore
            );
            
            Debug.Log($"🔍 Ground Detection Debug:");
            Debug.Log($"   - Simple Raycast: {hasGroundSimple}");
            Debug.Log($"   - Crouch SphereCast: {hasGroundCrouch}");
            Debug.Log($"   - Origin: {origin}");
            Debug.Log($"   - Radius: {radius}");
            Debug.Log($"   - Distance: {dynamicGroundCheck}");
            Debug.Log($"   - Controller Height: {controller.height}");
            Debug.Log($"   - Controller Radius: {controller.radius}");
            Debug.Log($"   - Player Layer: {gameObject.layer}");
            
            if (hasGroundCrouch)
            {
                Debug.Log($"   - Hit Object: {crouchHit.collider.name}");
                Debug.Log($"   - Hit Layer: {crouchHit.collider.gameObject.layer}");
                Debug.Log($"   - Hit Distance: {crouchHit.distance}");
                Debug.Log($"   - Is Trigger: {crouchHit.collider.isTrigger}");
            }
            
            if (hasGroundSimple)
            {
                Debug.Log($"   - Simple Hit Object: {hit.collider.name}");
                Debug.Log($"   - Simple Hit Layer: {hit.collider.gameObject.layer}");
            }
        }
        
        // Use the better detection result
        if (hasGroundCrouch)
        {
            hasGround = hasGroundCrouch;
            hit = crouchHit;
        }
        else
        {
            hasGround = hasGroundSimple;
        }
        
        if (hasGround)
        {
            float slopeAngle = Vector3.Angle(Vector3.up, hit.normal);
            lastSlopeAngle = slopeAngle;
            lastGroundNormal = hit.normal;
            
            // Get the required slope angle from config or default
            float requiredAngle = config != null ? config.landingSlopeAngleForAutoSlide : 12f;
            
            Debug.Log($"🏔️ Ground Information:");
            Debug.Log($"   - Has Ground: {hasGround}");
            Debug.Log($"   - Slope Angle: {slopeAngle:F1}°");
            Debug.Log($"   - Ground Normal: {hit.normal}");
            Debug.Log($"   - Vector3.up: {Vector3.up}");
            Debug.Log($"   - Normal magnitude: {hit.normal.magnitude}");
            Debug.Log($"   - Is normal normalized: {Mathf.Approximately(hit.normal.magnitude, 1f)}");
            Debug.Log($"   - Hit point: {hit.point}");
            Debug.Log($"   - Hit distance: {hit.distance}");
            Debug.Log($"   - Hit object: {hit.collider.name}");
            Debug.Log($"   - Hit transform rotation: {hit.collider.transform.rotation.eulerAngles}");
            Debug.Log($"   - Required Angle: {requiredAngle:F1}°");
            Debug.Log($"   - Manual Slide Zone (5°-∞): {slopeAngle >= requiredAngle}");
            Debug.Log($"   - Auto Slide Zone (50°-90°): {slopeAngle >= 50f && slopeAngle < 90f}");
        }
        else
        {
            Debug.LogWarning("⚠️ No ground detected under player!");
        }
        
        // Check velocity
        Vector3 velocity = movement.Velocity;
        float speed = velocity.magnitude;
        float horizontalSpeed = new Vector3(velocity.x, 0, velocity.z).magnitude;
        
        Debug.Log($"🚀 Velocity Information:");
        Debug.Log($"   - Total Speed: {speed:F2}");
        Debug.Log($"   - Horizontal Speed: {horizontalSpeed:F2}");
        Debug.Log($"   - Velocity: {velocity}");
        
        // Analyze why slide might not start
        AnalyzeFailureReasons(isGrounded, isWalking, isDiving, isDiveProne, isSliding, hasGround, lastSlopeAngle);
    }
    
    void AnalyzeFailureReasons(bool isGrounded, bool isWalking, bool isDiving, bool isDiveProne, bool isSliding, bool hasGround, float slopeAngle)
    {
        string failReason = "";
        
        if (!isGrounded)
            failReason += "❌ Not grounded\\n";
            
        if (!isWalking)
            failReason += "❌ Not in walking mode\\n";
            
        if (isDiving)
            failReason += "❌ Currently diving\\n";
            
        if (isDiveProne)
            failReason += "❌ Currently dive prone\\n";
            
        if (isSliding)
            failReason += "❌ Already sliding\\n";
            
        if (!hasGround)
            failReason += "❌ No ground detected\\n";
        else
        {
            float requiredAngle = 5f; // Updated value
            if (slopeAngle < requiredAngle)
                failReason += $"❌ Slope too shallow ({slopeAngle:F1}° < {requiredAngle:F1}°)\\n";
            // FIXED: No upper limit for manual crouch sliding!
        }
        
        if (string.IsNullOrEmpty(failReason))
        {
            Debug.Log("✅ All conditions met for sliding! If not sliding, check inspector settings:");
            Debug.Log("   - Enable Auto Slide = true");
            Debug.Log("   - Enable Slide = true");
            Debug.Log("   - Landing Slope Angle For Auto Slide = 12 or lower");
        }
        else
        {
            Debug.LogWarning("❌ Slide conditions not met:");
            Debug.LogWarning(failReason);
        }
        
        lastFailReason = failReason;
    }
    
    void OnGUI()
    {
        if (!showDebugGUI) return;
        
        GUILayout.BeginArea(new Rect(10, 10, 400, 300));
        GUILayout.Label("=== Crouch Slide Debug ===", GUI.skin.box);
        
        GUILayout.Label($"Slope Angle: {lastSlopeAngle:F1}°");
        GUILayout.Label($"Ground Normal: {lastGroundNormal}");
        
        if (crouchController != null)
        {
            GUILayout.Label($"Is Sliding: {crouchController.IsSliding}");
            GUILayout.Label($"Is Crouching: {crouchController.IsCrouching}");
        }
        
        if (movement != null)
        {
            GUILayout.Label($"Speed: {movement.CurrentSpeed:F1}");
            GUILayout.Label($"Grounded: {movement.IsGrounded}");
            GUILayout.Label($"Mode: {movement.CurrentMode}");
        }
        
        if (!string.IsNullOrEmpty(lastFailReason))
        {
            GUILayout.Label("Failure Reasons:", GUI.skin.box);
            GUILayout.Label(lastFailReason);
        }
        
        if (GUILayout.Button($"Debug Analysis ({debugKey})"))
        {
            AnalyzeSlideConditions();
        }
        
        GUILayout.EndArea();
    }
}