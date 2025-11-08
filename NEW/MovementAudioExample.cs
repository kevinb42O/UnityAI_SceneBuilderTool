using UnityEngine;

/// <summary>
/// Example showing how to integrate the AAA Movement Controller with an audio system.
/// Demonstrates 3D positional audio for movement sounds.
/// </summary>
[RequireComponent(typeof(AAAMovementController))]
public class MovementAudioExample : MonoBehaviour
{
    [Header("Audio Settings")]
    [Tooltip("Audio source for movement sounds (auto-created if null)")]
    public AudioSource movementAudioSource;
    
    [Header("Sound Effects")]
    public AudioClip[] footstepSounds;
    public AudioClip jumpSound;
    public AudioClip doubleJumpSound;
    public AudioClip landSound;
    public AudioClip wallJumpSound;
    public AudioClip slideLoopSound;
    
    [Header("Volume Settings")]
    [Range(0f, 1f)] public float footstepVolume = 0.7f;
    [Range(0f, 1f)] public float jumpVolume = 0.8f;
    [Range(0f, 1f)] public float landVolume = 0.9f;
    [Range(0f, 1f)] public float wallJumpVolume = 0.8f;
    [Range(0f, 1f)] public float slideVolume = 0.6f;
    
    [Header("Footstep Settings")]
    [Tooltip("Time between footsteps at base speed")]
    public float baseFootstepInterval = 0.5f;
    [Tooltip("Minimum time between footsteps")]
    public float minFootstepInterval = 0.2f;
    
    // Component references
    private AAAMovementController movement;
    private CleanAAACrouch crouchController;
    private AudioSource slideAudioSource;
    
    // State tracking
    private float lastFootstepTime;
    private bool wasGrounded = true;
    private bool wasSliding = false;
    
    void Awake()
    {
        // Get component references
        movement = GetComponent<AAAMovementController>();
        crouchController = GetComponent<CleanAAACrouch>();
        
        // Create audio source if not assigned
        if (movementAudioSource == null)
        {
            movementAudioSource = gameObject.AddComponent<AudioSource>();
            movementAudioSource.spatialBlend = 1f; // 3D sound
            movementAudioSource.rolloffMode = AudioRolloffMode.Logarithmic;
            movementAudioSource.maxDistance = 50f;
        }
        
        // Create separate audio source for slide loop
        slideAudioSource = gameObject.AddComponent<AudioSource>();
        slideAudioSource.spatialBlend = 1f;
        slideAudioSource.loop = true;
        slideAudioSource.volume = slideVolume;
        slideAudioSource.clip = slideLoopSound;
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
        
        // Stop any looping sounds
        if (slideAudioSource != null && slideAudioSource.isPlaying)
        {
            slideAudioSource.Stop();
        }
    }
    
    void Update()
    {
        if (movement == null) return;
        
        UpdateFootsteps();
        UpdateSlideAudio();
    }
    
    private void UpdateFootsteps()
    {
        // Only play footsteps when grounded and moving (using actual API)
        if (!movement.IsGrounded || movement.CurrentSpeed < 0.1f) return;
        
        // Skip footsteps while sliding
        if (crouchController != null && crouchController.IsSliding) return;
        
        // Calculate footstep interval based on movement speed
        float speedRatio = movement.CurrentSpeed / movement.MoveSpeed;
        float footstepInterval = Mathf.Lerp(baseFootstepInterval, minFootstepInterval, speedRatio);
        
        // Play footstep if enough time has passed
        if (Time.time - lastFootstepTime >= footstepInterval)
        {
            PlayFootstep();
            lastFootstepTime = Time.time;
        }
    }
    
    private void UpdateSlideAudio()
    {
        if (crouchController == null) return;
        
        bool isSliding = crouchController.IsSliding;
        
        // Start slide audio
        if (isSliding && !wasSliding)
        {
            if (slideLoopSound != null && !slideAudioSource.isPlaying)
            {
                slideAudioSource.Play();
            }
        }
        // Stop slide audio
        else if (!isSliding && wasSliding)
        {
            if (slideAudioSource.isPlaying)
            {
                slideAudioSource.Stop();
            }
        }
        
        wasSliding = isSliding;
    }
    
    private void PlayFootstep()
    {
        if (footstepSounds == null || footstepSounds.Length == 0) return;
        
        // Pick random footstep sound
        AudioClip footstep = footstepSounds[Random.Range(0, footstepSounds.Length)];
        PlaySound(footstep, footstepVolume);
    }
    
    private void PlaySound(AudioClip clip, float volume)
    {
        if (clip == null || movementAudioSource == null) return;
        
        movementAudioSource.volume = volume;
        movementAudioSource.PlayOneShot(clip);
    }
    
    // Event handlers
    private void OnPlayerJumped(Vector3 position, bool isDoubleJump)
    {
        AudioClip soundToPlay = isDoubleJump ? doubleJumpSound : jumpSound;
        if (soundToPlay != null)
        {
            PlaySound(soundToPlay, jumpVolume);
        }
    }
    
    private void OnPlayerLanded(Vector3 position, float fallSpeed)
    {
        if (landSound != null)
        {
            // Adjust volume based on fall speed
            float fallSpeedRatio = Mathf.Clamp01(fallSpeed / 2000f);
            float adjustedVolume = Mathf.Lerp(landVolume * 0.5f, landVolume, fallSpeedRatio);
            PlaySound(landSound, adjustedVolume);
        }
    }
    
    private void OnPlayerWallJumped(Vector3 position, Vector3 wallNormal)
    {
        if (wallJumpSound != null)
        {
            PlaySound(wallJumpSound, wallJumpVolume);
        }
    }
    
    /// <summary>
    /// Call this method to play a custom movement sound from external scripts.
    /// </summary>
    /// <param name="clip">Audio clip to play</param>
    /// <param name="volume">Volume (0-1)</param>
    public void PlayCustomMovementSound(AudioClip clip, float volume = 1f)
    {
        PlaySound(clip, volume);
    }
}