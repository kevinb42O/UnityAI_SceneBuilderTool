using UnityEngine;

/// <summary>
/// Input configuration for the AAA Movement Controller.
/// Create via: Assets > Create > AAA Movement > Input Configuration
/// </summary>
[CreateAssetMenu(fileName = "InputConfig", menuName = "AAA Movement/Input Configuration", order = 0)]
public class InputConfig : ScriptableObject
{
    [Header("Movement Keys")]
    [Tooltip("Key for jumping (default: Space)")]
    public KeyCode jumpKey = KeyCode.Space;
    
    [Tooltip("Key for sprinting/boosting (default: Left Shift)")]
    public KeyCode sprintKey = KeyCode.LeftShift;
    
    [Tooltip("Key for crouching (default: C)")]
    public KeyCode crouchKey = KeyCode.C;
    
    [Tooltip("Key for tactical dive (default: V)")]
    public KeyCode diveKey = KeyCode.V;

    [Header("Input Axes")]
    [Tooltip("Name of horizontal input axis (default: 'Horizontal')")]
    public string horizontalAxisName = "Horizontal";
    
    [Tooltip("Name of vertical input axis (default: 'Vertical')")]
    public string verticalAxisName = "Vertical";

    [Header("Alternative Input Methods")]
    [Tooltip("Enable mouse button alternatives")]
    public bool allowMouseInputs = false;
    
    [Tooltip("Mouse button for jump (if enabled, -1 = disabled)")]
    public int mouseJumpButton = -1;
    
    [Tooltip("Mouse button for sprint (if enabled, -1 = disabled)")]
    public int mouseSprintButton = -1;

    /// <summary>
    /// Check if jump was pressed this frame
    /// </summary>
    public bool GetJumpDown()
    {
        bool keyboardJump = Input.GetKeyDown(jumpKey);
        bool mouseJump = allowMouseInputs && mouseJumpButton >= 0 && Input.GetMouseButtonDown(mouseJumpButton);
        return keyboardJump || mouseJump;
    }

    /// <summary>
    /// Check if jump is currently held
    /// </summary>
    public bool GetJumpHeld()
    {
        bool keyboardJump = Input.GetKey(jumpKey);
        bool mouseJump = allowMouseInputs && mouseJumpButton >= 0 && Input.GetMouseButton(mouseJumpButton);
        return keyboardJump || mouseJump;
    }

    /// <summary>
    /// Check if jump was released this frame
    /// </summary>
    public bool GetJumpUp()
    {
        bool keyboardJump = Input.GetKeyUp(jumpKey);
        bool mouseJump = allowMouseInputs && mouseJumpButton >= 0 && Input.GetMouseButtonUp(mouseJumpButton);
        return keyboardJump || mouseJump;
    }

    /// <summary>
    /// Check if sprint is currently held
    /// </summary>
    public bool GetSprintHeld()
    {
        bool keyboardSprint = Input.GetKey(sprintKey);
        bool mouseSprint = allowMouseInputs && mouseSprintButton >= 0 && Input.GetMouseButton(mouseSprintButton);
        return keyboardSprint || mouseSprint;
    }

    /// <summary>
    /// Check if crouch was pressed this frame
    /// </summary>
    public bool GetCrouchDown()
    {
        return Input.GetKeyDown(crouchKey);
    }

    /// <summary>
    /// Check if crouch is currently held
    /// </summary>
    public bool GetCrouchHeld()
    {
        return Input.GetKey(crouchKey);
    }

    /// <summary>
    /// Check if dive was pressed this frame
    /// </summary>
    public bool GetDiveDown()
    {
        return Input.GetKeyDown(diveKey);
    }

    /// <summary>
    /// Get horizontal input (-1 to 1)
    /// </summary>
    public float GetHorizontalRaw()
    {
        // Try Input Manager first
        float axisInput = Input.GetAxisRaw(horizontalAxisName);
        
        // Fallback: Direct key reading if axis returns 0
        if (Mathf.Abs(axisInput) < 0.01f)
        {
            if (Input.GetKey(KeyCode.D)) return 1f;
            if (Input.GetKey(KeyCode.A)) return -1f;
        }
        
        return axisInput;
    }

    /// <summary>
    /// Get vertical input (-1 to 1)
    /// </summary>
    public float GetVerticalRaw()
    {
        // Try Input Manager first
        float axisInput = Input.GetAxisRaw(verticalAxisName);
        
        // Fallback: Direct key reading if axis returns 0
        if (Mathf.Abs(axisInput) < 0.01f)
        {
            if (Input.GetKey(KeyCode.W)) return 1f;
            if (Input.GetKey(KeyCode.S)) return -1f;
        }
        
        return axisInput;
    }

    /// <summary>
    /// Create a default configuration
    /// </summary>
    public static InputConfig CreateDefault()
    {
        var config = CreateInstance<InputConfig>();
        config.jumpKey = KeyCode.Space;
        config.sprintKey = KeyCode.LeftShift;
        config.crouchKey = KeyCode.C;
        config.diveKey = KeyCode.V;
        config.horizontalAxisName = "Horizontal";
        config.verticalAxisName = "Vertical";
        config.allowMouseInputs = false;
        config.mouseJumpButton = -1;
        config.mouseSprintButton = -1;
        return config;
    }
}
