using UnityEngine;

/// <summary>
/// Example integration showing how to connect the AAA Movement Controller
/// with a custom animation system. Copy and modify this script for your project.
/// </summary>
[RequireComponent(typeof(AAAMovementController))]
public class MovementAnimationExample : MonoBehaviour
{
    [Header("Animation References")]
    public Animator characterAnimator;
    
    [Header("Animation Parameters")]
    [Tooltip("Name of the speed parameter in your Animator")]
    public string speedParameterName = "Speed";
    [Tooltip("Name of the grounded parameter in your Animator")]
    public string groundedParameterName = "IsGrounded";
    [Tooltip("Name of the wall sliding parameter in your Animator")]
    public string wallSlidingParameterName = "IsWallSliding";
    [Tooltip("Name of the crouch parameter in your Animator")]
    public string crouchParameterName = "IsCrouching";
    
    [Header("Animation Triggers")]
    public string jumpTriggerName = "Jump";
    public string landTriggerName = "Land";
    public string wallJumpTriggerName = "WallJump";
    
    // Component references
    private AAAMovementController movement;
    private CleanAAACrouch crouchController;
    
    // Animation parameter hashes (for performance)
    private int speedHash;
    private int groundedHash;
    private int wallSlidingHash;
    private int crouchHash;
    private int jumpTriggerHash;
    private int landTriggerHash;
    private int wallJumpTriggerHash;
    
    // State tracking
    private bool wasGrounded = true;
    private float lastSpeed = 0f;
    
    void Awake()
    {
        // Get component references
        movement = GetComponent<AAAMovementController>();
        crouchController = GetComponent<CleanAAACrouch>();
        
        // Auto-find animator if not assigned
        if (characterAnimator == null)
            characterAnimator = GetComponentInChildren<Animator>();
        
        // Cache parameter hashes for performance
        if (characterAnimator != null)
        {
            speedHash = Animator.StringToHash(speedParameterName);
            groundedHash = Animator.StringToHash(groundedParameterName);
            wallSlidingHash = Animator.StringToHash(wallSlidingParameterName);
            crouchHash = Animator.StringToHash(crouchParameterName);
            jumpTriggerHash = Animator.StringToHash(jumpTriggerName);
            landTriggerHash = Animator.StringToHash(landTriggerName);
            wallJumpTriggerHash = Animator.StringToHash(wallJumpTriggerName);
        }
    }
    
    void OnEnable()
    {
        // Note: These events don't exist in the current AAAMovementController
        // This is an example of how you would implement them if needed
        // You can add these events to your AAAMovementController or remove these subscriptions
    }
    
    void OnDisable()
    {
        // Corresponding unsubscriptions would go here
    }
    
    void Update()
    {
        if (characterAnimator == null || movement == null) return;
        
        UpdateAnimationParameters();
        CheckStateTransitions();
    }
    
    private void UpdateAnimationParameters()
    {
        // Update continuous parameters using actual API
        float currentSpeed = movement.CurrentSpeed; // Use actual property name
        float normalizedSpeed = currentSpeed / movement.MoveSpeed; // Use actual property name
        characterAnimator.SetFloat(speedHash, normalizedSpeed);
        
        characterAnimator.SetBool(groundedHash, movement.IsGrounded);
        characterAnimator.SetBool(wallSlidingHash, movement.IsInWallJumpChain); // Use actual property
        
        // Update crouch state if crouch controller exists
        if (crouchController != null)
        {
            characterAnimator.SetBool(crouchHash, crouchController.IsCrouching);
        }
        
        lastSpeed = currentSpeed;
    }
    
    private void CheckStateTransitions()
    {
        // Detect landing (grounded this frame but not last frame)
        if (movement.IsGrounded && !wasGrounded)
        {
            // Landing detected - will be handled by event system
        }
        
        wasGrounded = movement.IsGrounded;
    }
    
    // Event handlers
    private void OnPlayerJumped(Vector3 position, bool isDoubleJump)
    {
        if (characterAnimator != null)
        {
            characterAnimator.SetTrigger(jumpTriggerHash);
        }
        
        Debug.Log($"Animation: Player jumped at {position} (Double jump: {isDoubleJump})");
    }
    
    private void OnPlayerLanded(Vector3 position, float fallSpeed)
    {
        if (characterAnimator != null)
        {
            characterAnimator.SetTrigger(landTriggerHash);
        }
        
        Debug.Log($"Animation: Player landed at {position} with speed {fallSpeed:F1}");
    }
    
    private void OnPlayerWallJumped(Vector3 position, Vector3 wallNormal)
    {
        if (characterAnimator != null)
        {
            characterAnimator.SetTrigger(wallJumpTriggerHash);
        }
        
        Debug.Log($"Animation: Player wall jumped at {position}");
    }
}