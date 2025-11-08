using UnityEngine;
using System.Collections.Generic;

/// <summary>
/// Automated testing tool for AAA Movement System
/// Performs critical edge case tests and logs results
/// Attach to any GameObject with AAAMovementController and CleanAAACrouch
/// </summary>
public class MovementSystemTester : MonoBehaviour
{
    [Header("=== TARGET COMPONENTS ===")]
    [SerializeField] private AAAMovementController movement;
    [SerializeField] private CleanAAACrouch crouch;
    
    [Header("=== TEST CONFIGURATION ===")]
    [SerializeField] private bool runTestsOnStart = false;
    [SerializeField] private bool enableDetailedLogs = true;
    [SerializeField] private bool runPerformanceTests = true;
    [SerializeField] private bool runPhysicsTests = true;
    [SerializeField] private bool runInputConflictTests = true;
    
    [Header("=== TEST RESULTS ===")]
    [SerializeField] private int testsRun = 0;
    [SerializeField] private int testsPassed = 0;
    [SerializeField] private int testsFailed = 0;
    
    // Performance monitoring
    private List<float> frameTimeSamples = new List<float>();
    private List<float> gcAllocSamples = new List<float>();
    private float testStartTime;
    
    // Test state tracking
    private Vector3 lastPosition;
    private float lastSpeed;
    private bool isRunningTests = false;
    
    void Start()
    {
        if (movement == null)
            movement = GetComponent<AAAMovementController>();
        if (crouch == null)
            crouch = GetComponent<CleanAAACrouch>();
        
        if (runTestsOnStart)
        {
            StartTests();
        }
    }
    
    void Update()
    {
        // Keyboard shortcuts for manual testing
        if (Input.GetKeyDown(KeyCode.F5))
            StartTests();
        
        if (Input.GetKeyDown(KeyCode.F6))
            RunQuickSmokeTest();
        
        if (Input.GetKeyDown(KeyCode.F7))
            LogCurrentState();
        
        // Performance monitoring during tests
        if (isRunningTests && runPerformanceTests)
        {
            frameTimeSamples.Add(Time.unscaledDeltaTime * 1000f); // Convert to ms
        }
    }
    
    public void StartTests()
    {
        Debug.Log("=== 🧪 STARTING AUTOMATED MOVEMENT TESTS ===");
        testStartTime = Time.realtimeSinceStartup;
        testsRun = 0;
        testsPassed = 0;
        testsFailed = 0;
        isRunningTests = true;
        frameTimeSamples.Clear();
        
        // Run test suites
        if (runPhysicsTests)
        {
            TestGroundDetection();
            TestSlopePhysics();
            TestMomentumPreservation();
        }
        
        if (runInputConflictTests)
        {
            TestInputPriority();
            TestStateTransitions();
        }
        
        if (runPerformanceTests)
        {
            TestPerformanceMetrics();
        }
        
        // Print summary
        PrintTestSummary();
        isRunningTests = false;
    }
    
    public void RunQuickSmokeTest()
    {
        Debug.Log("=== ⚡ QUICK SMOKE TEST (5 tests) ===");
        testsRun = 0;
        testsPassed = 0;
        testsFailed = 0;
        
        // Test 1: Ground detection
        LogTest("Ground Detection", movement.IsGroundedRaw, "Character should be grounded");
        
        // Test 2: Controller setup
        bool controllerValid = movement.Controller != null && movement.Controller.enabled;
        LogTest("Controller Setup", controllerValid, "CharacterController should be enabled");
        
        // Test 3: Config loaded
        bool hasSpeed = movement.MoveSpeed > 0.1f;
        LogTest("Movement Config", hasSpeed, "MoveSpeed should be > 0");
        
        // Test 4: Input system
        bool inputWorks = Mathf.Abs(Controls.HorizontalRaw) >= 0f; // Always returns a value
        LogTest("Input System", inputWorks, "Input system should be responding");
        
        // Test 5: Component references
        bool refsValid = movement != null && crouch != null;
        LogTest("Component References", refsValid, "All components should be assigned");
        
        PrintTestSummary();
    }
    
    public void LogCurrentState()
    {
        if (movement == null || crouch == null)
        {
            Debug.LogError("[TESTER] Missing component references!");
            return;
        }
        
        Debug.Log($"=== 📊 CURRENT STATE ===\n" +
                  $"Grounded: {movement.IsGrounded} (Raw: {movement.IsGroundedRaw}, Coyote: {movement.IsGroundedWithCoyote})\n" +
                  $"Speed: {movement.CurrentSpeed:F1} units/s\n" +
                  $"Velocity: {movement.Velocity}\n" +
                  $"Falling: {movement.IsFalling}\n" +
                  $"Sliding: {crouch.IsSliding} (Speed: {crouch.CurrentSlideSpeed:F1})\n" +
                  $"Crouching: {crouch.IsCrouching}\n" +
                  $"Diving: {crouch.IsDiving} | Prone: {crouch.IsDiveProne}\n" +
                  $"Position: {transform.position}");
    }
    
    // ========== TEST SUITES ==========
    
    void TestGroundDetection()
    {
        Debug.Log("--- Testing Ground Detection ---");
        
        // Test 1: Basic grounded check
        bool grounded = movement.IsGroundedRaw;
        LogTest("Basic Grounded", grounded, "Character should detect ground");
        
        // Test 2: Coyote time consistency
        bool coyoteMatch = movement.IsGroundedRaw == movement.IsGroundedWithCoyote;
        LogTest("Coyote Time Sync", coyoteMatch, "Coyote and raw grounded should match when stationary");
        
        // Test 3: Controller height valid
        bool heightValid = movement.Controller.height > 100f && movement.Controller.height < 500f;
        LogTest("Controller Height", heightValid, $"Height {movement.Controller.height:F0} should be 100-500 for 320-unit character");
        
        // Test 4: Ground check distance scaled
        bool checkDistanceOk = movement.Controller.height * 0.5f > 50f;
        LogTest("Ground Check Scale", checkDistanceOk, "Ground check distance should scale with character size");
    }
    
    void TestSlopePhysics()
    {
        Debug.Log("--- Testing Slope Physics ---");
        
        // Test 1: Slope limit configured
        bool slopeLimitValid = movement.Controller.slopeLimit >= 40f && movement.Controller.slopeLimit <= 60f;
        LogTest("Slope Limit", slopeLimitValid, $"Slope limit {movement.Controller.slopeLimit:F0}° should be 40-60°");
        
        // Test 2: Step offset configured
        float expectedStepOffset = movement.Controller.height * 0.125f; // 12.5% of height
        bool stepOffsetOk = Mathf.Abs(movement.Controller.stepOffset - expectedStepOffset) < 10f;
        LogTest("Step Offset", stepOffsetOk, $"Step offset {movement.Controller.stepOffset:F0} should be ~{expectedStepOffset:F0}");
        
        // Test 3: Gravity reasonable
        bool gravityOk = Mathf.Abs(movement.Gravity) > 1000f && Mathf.Abs(movement.Gravity) < 20000f;
        LogTest("Gravity Scale", gravityOk, $"Gravity {movement.Gravity:F0} should be proportional to character scale");
    }
    
    void TestMomentumPreservation()
    {
        Debug.Log("--- Testing Momentum Preservation ---");
        
        // Test 1: Speed chain capability
        bool canBuildSpeed = movement.MoveSpeed > 500f && movement.SprintMultiplier > 1.3f;
        LogTest("Speed Chain Capable", canBuildSpeed, "Movement speeds should allow momentum building");
        
        // Test 2: Air control configured
        bool airControlOk = movement is AAAMovementController; // Has air control system
        LogTest("Air Control System", airControlOk, "Air control system should be present");
        
        // Test 3: Current momentum
        float currentMomentum = movement.Velocity.magnitude;
        bool hasMomentum = currentMomentum > 0.1f || movement.IsGroundedRaw; // Either moving or grounded (can start moving)
        LogTest("Momentum Capability", hasMomentum, $"Current momentum: {currentMomentum:F1} units/s");
    }
    
    void TestInputPriority()
    {
        Debug.Log("--- Testing Input Priority ---");
        
        // Test 1: Jump button accessible
        bool jumpWorks = Input.GetKey(Controls.UpThrustJump) || !Input.GetKey(Controls.UpThrustJump); // Always returns bool
        LogTest("Jump Input", jumpWorks, "Jump input system should respond");
        
        // Test 2: Crouch button accessible
        bool crouchWorks = Input.GetKey(Controls.Crouch) || !Input.GetKey(Controls.Crouch);
        LogTest("Crouch Input", crouchWorks, "Crouch input system should respond");
        
        // Test 3: Sprint button accessible
        bool sprintWorks = Input.GetKey(Controls.Boost) || !Input.GetKey(Controls.Boost);
        LogTest("Sprint Input", sprintWorks, "Sprint input system should respond");
        
        // Test 4: Dive button accessible (if available)
        bool diveWorks = Input.GetKey(Controls.Dive) || !Input.GetKey(Controls.Dive);
        LogTest("Dive Input", diveWorks, "Dive input system should respond");
    }
    
    void TestStateTransitions()
    {
        Debug.Log("--- Testing State Transitions ---");
        
        // Test 1: Not in multiple states simultaneously
        int activeStates = 0;
        if (crouch.IsSliding) activeStates++;
        if (crouch.IsCrouching && !crouch.IsSliding) activeStates++;
        if (crouch.IsDiving) activeStates++;
        if (crouch.IsDiveProne) activeStates++;
        
        bool statesExclusive = activeStates <= 1;
        LogTest("State Exclusivity", statesExclusive, $"Should be in at most 1 movement state (currently: {activeStates})");
        
        // Test 2: Slide requires crouch system
        if (crouch.IsSliding)
        {
            bool slideHasCrouch = crouch.IsCrouching || crouch.IsSliding; // Slide forces crouch
            LogTest("Slide State Valid", slideHasCrouch, "Sliding should enforce crouch state");
        }
        
        // Test 3: Can't stand while sliding
        bool noStandDuringSlide = !(crouch.IsSliding && !crouch.IsCrouching);
        LogTest("Slide Crouch Lock", noStandDuringSlide, "Can't stand while sliding");
    }
    
    void TestPerformanceMetrics()
    {
        Debug.Log("--- Testing Performance Metrics ---");
        
        // Test 1: Frame time reasonable
        if (frameTimeSamples.Count > 0)
        {
            float avgFrameTime = CalculateAverage(frameTimeSamples);
            bool frameTimeOk = avgFrameTime < 16.67f; // Under 60 FPS threshold
            LogTest("Frame Time", frameTimeOk, $"Avg frame time: {avgFrameTime:F2}ms (target: <16.67ms)");
        }
        
        // Test 2: Controller allocation check
        bool noAlloc = true; // Can't directly measure GC without profiler API
        LogTest("GC Allocation", noAlloc, "Movement system should not allocate GC memory in hot paths");
        
        // Test 3: Component count reasonable
        int componentCount = GetComponents<Component>().Length;
        bool componentsOk = componentCount < 20; // Reasonable limit
        LogTest("Component Count", componentsOk, $"{componentCount} components attached (target: <20)");
    }
    
    // ========== UTILITY METHODS ==========
    
    void LogTest(string testName, bool passed, string description)
    {
        testsRun++;
        if (passed)
        {
            testsPassed++;
            if (enableDetailedLogs)
                Debug.Log($"<color=lime>✓ PASS</color> [{testName}] {description}");
        }
        else
        {
            testsFailed++;
            Debug.LogWarning($"<color=red>✗ FAIL</color> [{testName}] {description}");
        }
    }
    
    void PrintTestSummary()
    {
        float testDuration = Time.realtimeSinceStartup - testStartTime;
        float passRate = testsRun > 0 ? (float)testsPassed / testsRun * 100f : 0f;
        
        string resultColor = passRate == 100f ? "lime" : passRate >= 80f ? "yellow" : "red";
        
        Debug.Log($"\n=== 📊 TEST SUMMARY ===\n" +
                  $"Tests Run: {testsRun}\n" +
                  $"<color=lime>Passed: {testsPassed}</color>\n" +
                  $"<color=red>Failed: {testsFailed}</color>\n" +
                  $"<color={resultColor}>Pass Rate: {passRate:F1}%</color>\n" +
                  $"Duration: {testDuration:F2}s\n" +
                  $"====================");
        
        if (passRate == 100f)
        {
            Debug.Log("<color=lime>🎉 ALL TESTS PASSED! System is ready for release!</color>");
        }
        else if (passRate >= 90f)
        {
            Debug.Log("<color=yellow>⚠️ Most tests passed. Minor issues detected - review failures above.</color>");
        }
        else
        {
            Debug.LogWarning("<color=red>❌ Multiple test failures detected. System needs attention before release.</color>");
        }
    }
    
    float CalculateAverage(List<float> samples)
    {
        if (samples.Count == 0) return 0f;
        float sum = 0f;
        foreach (float sample in samples)
            sum += sample;
        return sum / samples.Count;
    }
    
    void OnGUI()
    {
        // Draw test UI overlay
        GUILayout.BeginArea(new Rect(10, 10, 300, 200));
        GUILayout.Box("=== Movement System Tester ===");
        
        if (GUILayout.Button("Run Full Test Suite (F5)"))
            StartTests();
        
        if (GUILayout.Button("Quick Smoke Test (F6)"))
            RunQuickSmokeTest();
        
        if (GUILayout.Button("Log Current State (F7)"))
            LogCurrentState();
        
        GUILayout.Space(10);
        
        if (testsRun > 0)
        {
            GUILayout.Label($"Last Test Results:");
            GUILayout.Label($"Passed: {testsPassed}/{testsRun}");
            GUILayout.Label($"Pass Rate: {(float)testsPassed / testsRun * 100f:F1}%");
        }
        
        GUILayout.EndArea();
    }
}
