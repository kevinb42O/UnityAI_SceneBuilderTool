using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// Example UI integration showing movement stats and configuration controls.
/// Useful for debugging, demos, and runtime configuration adjustment.
/// </summary>
public class MovementUIExample : MonoBehaviour
{
    [Header("UI References")]
    public Text speedText;
    public Text stateText;
    public Text configText;
    public Slider gravitySlider;
    public Slider jumpForceSlider;
    public Button resetButton;
    public Toggle wallJumpToggle;
    
    [Header("Settings")]
    public bool showDetailedStats = true;
    public float updateInterval = 0.1f; // Update UI every 0.1 seconds
    
    // Component references
    private AAAMovementController movement;
    private CleanAAACrouch crouchController;
    
    // State tracking
    private float lastUpdateTime;
    private MovementConfig originalConfig;
    
    void Start()
    {
        // Find movement controller
        movement = FindObjectOfType<AAAMovementController>();
        crouchController = FindObjectOfType<CleanAAACrouch>();
        
        if (movement == null)
        {
            Debug.LogWarning("MovementUIExample: No AAAMovementController found in scene!");
            enabled = false;
            return;
        }
        
        // Store original configuration (using actual API)
        // Note: Movement controller may not have Config property - use individual properties instead
        originalConfig = ScriptableObject.CreateInstance<MovementConfig>();
        originalConfig.moveSpeed = movement.MoveSpeed;
        // Note: JumpForce is not public, so we can't store it
        // Store other needed values as needed
        
        SetupUI();
    }
    
    void Update()
    {
        // Update UI at specified interval to avoid performance issues
        if (Time.time - lastUpdateTime >= updateInterval)
        {
            UpdateMovementDisplay();
            lastUpdateTime = Time.time;
        }
    }
    
    private void SetupUI()
    {
        // Setup sliders (using actual API)
        if (gravitySlider != null)
        {
            gravitySlider.minValue = -15000f;
            gravitySlider.maxValue = -1000f;
            gravitySlider.value = -9810f; // Default gravity value
            gravitySlider.onValueChanged.AddListener(OnGravityChanged);
        }
        
        if (jumpForceSlider != null)
        {
            jumpForceSlider.minValue = 500f;
            jumpForceSlider.maxValue = 3000f;
            jumpForceSlider.value = 1500f; // Default value since JumpForce is not public
            jumpForceSlider.onValueChanged.AddListener(OnJumpForceChanged);
        }
        
        // Setup toggle (wall jump may not be configurable - remove or adjust)
        if (wallJumpToggle != null)
        {
            wallJumpToggle.isOn = true; // Default enabled
            wallJumpToggle.onValueChanged.AddListener(OnWallJumpToggled);
        }
        
        // Setup reset button
        if (resetButton != null)
        {
            resetButton.onClick.AddListener(ResetToDefaults);
        }
    }
    
    private void UpdateMovementDisplay()
    {
        if (movement == null) return;
        
        // Update speed display (using actual API)
        if (speedText != null)
        {
            float speed = movement.CurrentSpeed;
            
            if (showDetailedStats)
            {
                speedText.text = $"Speed: {speed:F0} u/s\nVertical: {movement.Velocity.y:F0} u/s";
            }
            else
            {
                speedText.text = $"Speed: {speed:F0} u/s";
            }
        }
        
        // Update state display
        if (stateText != null)
        {
            string state = GetMovementState();
            stateText.text = state;
        }
        
        // Update config display (using actual API)
        if (configText != null)
        {
            configText.text = $"Move Speed: {movement.MoveSpeed:F0}";
        }
    }
    
    private string GetMovementState()
    {
        if (movement == null) return "No Controller";
        
        string state = movement.IsGrounded ? "Grounded" : "Airborne";
        
        // Note: IsWallSliding not available in actual API
        // if (movement.IsWallSliding)
        //     state += " + Wall Sliding";
        
        if (crouchController != null)
        {
            if (crouchController.IsSliding)
                state += " + Sliding";
            else if (crouchController.IsCrouching)
                state += " + Crouching";
            
            if (crouchController.IsDiving)
                state += " + Diving";
        }
        
        state += $"\nVelocity: {movement.Velocity.magnitude:F0} u/s";
        
        if (showDetailedStats)
        {
            state += $"\nVel: ({movement.Velocity.x:F0}, {movement.Velocity.y:F0}, {movement.Velocity.z:F0})";
        }
        
        return state;
    }
    
    // UI Event Handlers (simplified for actual API)
    private void OnGravityChanged(float value)
    {
        // Note: Gravity may not be directly configurable in AAAMovementController
        Debug.Log($"Gravity changed to: {value}");
    }
    
    private void OnJumpForceChanged(float value)
    {
        // This would need to be implemented if jump force is settable
        Debug.Log($"Jump force changed to: {value}");
    }
    
    private void OnWallJumpToggled(bool enabled)
    {
        // Wall jump toggle - may not be configurable
        Debug.Log($"Wall jump toggled: {enabled}");
    }
    
    private void ResetToDefaults()
    {
        if (movement != null && originalConfig != null)
        {
            // Reset to original values (limited by actual API)
            Debug.Log("Resetting to default configuration");
            
            // Update UI controls to original values
            if (gravitySlider != null) gravitySlider.value = -9810f;
            if (jumpForceSlider != null) jumpForceSlider.value = 1500f; // Default since JumpForce not public
            if (wallJumpToggle != null) wallJumpToggle.isOn = true;
        }
    }
    
    /// <summary>
    /// Call this to switch to a different movement configuration preset.
    /// Note: Limited by actual AAAMovementController API
    /// </summary>
    /// <param name="newConfig">Configuration to switch to</param>
    public void SwitchConfiguration(MovementConfig newConfig)
    {
        if (movement != null && newConfig != null)
        {
            Debug.Log($"Switching to configuration: {newConfig.name}");
            
            // Update UI to reflect new config values
            if (gravitySlider != null) gravitySlider.value = newConfig.gravity;
            if (jumpForceSlider != null) jumpForceSlider.value = newConfig.jumpForce;
            if (wallJumpToggle != null) wallJumpToggle.isOn = newConfig.enableWallJump;
        }
    }
    
    /// <summary>
    /// Creates a performance monitoring display for frame rate and timing.
    /// </summary>
    public void ShowPerformanceStats()
    {
        if (speedText != null)
        {
            float frameTime = Time.deltaTime * 1000f;
            float fps = 1f / Time.deltaTime;
            
            string perfStats = $"\nFPS: {fps:F0}\nFrame Time: {frameTime:F1}ms";
            speedText.text += perfStats;
        }
    }
}