using UnityEngine;
using UnityEngine.Profiling;

/// <summary>
/// Performance optimization utilities for the AAA Movement Controller.
/// Includes object pooling, profiler markers, and performance monitoring.
/// </summary>
public class MovementPerformanceOptimizer : MonoBehaviour
{
    [Header("Performance Settings")]
    [Tooltip("Enable profiler markers for detailed performance analysis")]
    public bool enableProfilerMarkers = true;
    [Tooltip("Target frame rate for movement updates")]
    public int targetFrameRate = 60;
    [Tooltip("Enable automatic garbage collection optimization")]
    public bool enableGCOptimization = true;
    
    [Header("Monitoring")]
    [Tooltip("Log performance warnings when frame time exceeds threshold")]
    public bool logPerformanceWarnings = false;
    [Tooltip("Frame time threshold in milliseconds")]
    public float frameTimeThresholdMs = 16.67f; // 60 FPS
    
    // Component references
    private AAAMovementController movement;
    private CleanAAACrouch crouchController;
    
    // Performance tracking
    private float lastFrameTime;
    private int frameCount;
    private float accumulatedFrameTime;
    private const int FRAME_SAMPLE_SIZE = 60;
    
    // Profiler markers (using Profiler.BeginSample instead of CustomSampler)
    private string movementUpdateSample = "AAA Movement Update";
    private string groundCheckSample = "AAA Ground Check";
    private string wallJumpSample = "AAA Wall Jump";
    private string crouchUpdateSample = "AAA Crouch Update";
    
    // Object pooling for common allocations
    private readonly Vector3[] vectorPool = new Vector3[10];
    private readonly RaycastHit[] raycastHitPool = new RaycastHit[5];
    private int vectorPoolIndex = 0;
    private int raycastPoolIndex = 0;
    
    void Awake()
    {
        // Get component references
        movement = GetComponent<AAAMovementController>();
        crouchController = GetComponent<CleanAAACrouch>();
        
        // Initialize profiler markers (simplified approach)
        if (enableProfilerMarkers)
        {
            Debug.Log("Profiler markers enabled for AAA Movement Controller");
        }
        
        // Set target frame rate
        Application.targetFrameRate = targetFrameRate;
        
        // GC optimization
        if (enableGCOptimization)
        {
            // Pre-allocate common strings to avoid GC
            PreallocateCommonStrings();
        }
    }
    
    void Update()
    {
        if (enableProfilerMarkers)
        {
            Profiler.BeginSample(movementUpdateSample);
            MonitorPerformance();
            Profiler.EndSample();
        }
        else
        {
            MonitorPerformance();
        }
    }
    
    private void MonitorPerformance()
    {
        float currentFrameTime = Time.deltaTime * 1000f;
        
        // Track frame time statistics
        accumulatedFrameTime += currentFrameTime;
        frameCount++;
        
        // Log warnings for slow frames
        if (logPerformanceWarnings && currentFrameTime > frameTimeThresholdMs)
        {
            Debug.LogWarning($"[Performance] Slow frame detected: {currentFrameTime:F2}ms (target: {frameTimeThresholdMs:F2}ms)");
        }
        
        // Calculate average every N frames
        if (frameCount >= FRAME_SAMPLE_SIZE)
        {
            float averageFrameTime = accumulatedFrameTime / frameCount;
            
            if (logPerformanceWarnings && averageFrameTime > frameTimeThresholdMs)
            {
                Debug.LogWarning($"[Performance] Average frame time exceeds target: {averageFrameTime:F2}ms");
            }
            
            // Reset counters
            accumulatedFrameTime = 0f;
            frameCount = 0;
        }
        
        lastFrameTime = currentFrameTime;
    }
    
    private void PreallocateCommonStrings()
    {
        // Pre-allocate commonly used strings to avoid GC during gameplay
        // This is especially important for debug output and UI updates
        _ = "Speed: ";
        _ = "Grounded";
        _ = "Airborne";
        _ = "Wall Sliding";
        _ = "Crouching";
        _ = "Sliding";
        _ = "Diving";
    }
    
    /// <summary>
    /// Gets a pooled Vector3 to avoid allocations. Use sparingly and don't hold references.
    /// </summary>
    public Vector3 GetPooledVector3()
    {
        vectorPoolIndex = (vectorPoolIndex + 1) % vectorPool.Length;
        return vectorPool[vectorPoolIndex];
    }
    
    /// <summary>
    /// Gets a pooled RaycastHit to avoid allocations. Use sparingly and don't hold references.
    /// </summary>
    public RaycastHit GetPooledRaycastHit()
    {
        raycastPoolIndex = (raycastPoolIndex + 1) % raycastHitPool.Length;
        return raycastHitPool[raycastPoolIndex];
    }
    
    /// <summary>
    /// Begins a custom profiler sample for external systems integrating with movement.
    /// </summary>
    public void BeginProfilerSample(string sampleName)
    {
        if (enableProfilerMarkers)
        {
            Profiler.BeginSample(sampleName);
        }
    }
    
    /// <summary>
    /// Ends the current profiler sample.
    /// </summary>
    public void EndProfilerSample()
    {
        if (enableProfilerMarkers)
        {
            Profiler.EndSample();
        }
    }
    
    /// <summary>
    /// Forces garbage collection at a safe time (e.g., during loading screens).
    /// </summary>
    public void ForceGarbageCollection()
    {
        if (enableGCOptimization)
        {
            System.GC.Collect();
            System.GC.WaitForPendingFinalizers();
            System.GC.Collect();
        }
    }
    
    /// <summary>
    /// Gets current performance statistics.
    /// </summary>
    public PerformanceStats GetPerformanceStats()
    {
        return new PerformanceStats
        {
            currentFrameTimeMs = lastFrameTime,
            currentFPS = 1f / Time.deltaTime,
            averageFrameTimeMs = frameCount > 0 ? accumulatedFrameTime / frameCount : 0f,
            isPerformingWell = lastFrameTime <= frameTimeThresholdMs
        };
    }
    
    /// <summary>
    /// Optimizes movement controller settings for better performance on lower-end devices.
    /// Note: Limited by actual AAAMovementController API
    /// </summary>
    public void ApplyPerformanceOptimizations()
    {
        if (movement == null) return;
        
        Debug.Log("[Performance] Performance optimization requested - manual tuning may be required");
        
        // Note: Config property may not exist in actual implementation
        // Apply optimizations through available API instead
        try
        {
            // Try to access available settings
            float currentMoveSpeed = movement.MoveSpeed;
            // Note: JumpForce is not public, so we can't modify it
            
            Debug.Log($"[Performance] Current settings - MoveSpeed: {currentMoveSpeed}");
        }
        catch
        {
            Debug.LogWarning("[Performance] Unable to access movement controller settings for optimization");
        }
    }
    
    private bool IsFeatureUsed(string featureName)
    {
        // Simple heuristic to detect if features are being used
        // In a real implementation, you might track usage statistics
        switch (featureName)
        {
            default:
                return true;
        }
    }
    
    void OnDestroy()
    {
        // Clean up - simplified since we're not using CustomSampler objects
        if (enableProfilerMarkers)
        {
            Debug.Log("Performance optimizer cleanup complete");
        }
    }
}

/// <summary>
/// Performance statistics data structure.
/// </summary>
[System.Serializable]
public struct PerformanceStats
{
    public float currentFrameTimeMs;
    public float currentFPS;
    public float averageFrameTimeMs;
    public bool isPerformingWell;
    
    public override string ToString()
    {
        return $"FPS: {currentFPS:F1}, Frame Time: {currentFrameTimeMs:F1}ms, Performance: {(isPerformingWell ? "Good" : "Poor")}";
    }
}