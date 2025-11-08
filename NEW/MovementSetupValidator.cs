using UnityEngine;

/// <summary>
/// Validation utility that checks for common setup issues with the AAA Movement Controller.
/// Helps users quickly identify and fix configuration problems.
/// </summary>
[System.Serializable]
public class MovementSetupValidator : MonoBehaviour
{
    [Header("Validation Settings")]
    [Tooltip("Automatically fix issues when possible")]
    public bool autoFixIssues = true;
    [Tooltip("Show detailed validation messages")]
    public bool verboseLogging = true;
    [Tooltip("Run validation continuously in play mode")]
    public bool continuousValidation = false;
    
    // Validation results
    [System.Serializable]
    public class ValidationResult
    {
        public bool hasErrors;
        public bool hasWarnings;
        public string[] errors;
        public string[] warnings;
        public string[] fixes;
    }
    
    void Start()
    {
        // Always validate on start
        ValidateSetup();
    }
    
    void Update()
    {
        // Optional continuous validation
        if (continuousValidation && Time.frameCount % 300 == 0) // Every 5 seconds at 60fps
        {
            ValidateSetup();
        }
    }
    
    /// <summary>
    /// Performs comprehensive validation of the movement controller setup.
    /// </summary>
    /// <returns>Validation results with any issues found</returns>
    public ValidationResult ValidateSetup()
    {
        var result = new ValidationResult();
        var errors = new System.Collections.Generic.List<string>();
        var warnings = new System.Collections.Generic.List<string>();
        var fixes = new System.Collections.Generic.List<string>();
        
        // Find movement controller
        var movement = GetComponent<AAAMovementController>();
        if (movement == null)
        {
            movement = FindObjectOfType<AAAMovementController>();
        }
        
        if (movement == null)
        {
            errors.Add("No AAAMovementController found in scene");
            result.hasErrors = true;
        }
        else
        {
            ValidateMovementController(movement, errors, warnings, fixes);
        }
        
        // Validate overall scene setup
        ValidateSceneSetup(errors, warnings, fixes);
        
        // Compile results
        result.errors = errors.ToArray();
        result.warnings = warnings.ToArray();
        result.fixes = fixes.ToArray();
        result.hasErrors = errors.Count > 0;
        result.hasWarnings = warnings.Count > 0;
        
        // Log results
        if (verboseLogging)
        {
            LogValidationResults(result);
        }
        
        return result;
    }
    
    private void ValidateMovementController(AAAMovementController movement, 
        System.Collections.Generic.List<string> errors, 
        System.Collections.Generic.List<string> warnings, 
        System.Collections.Generic.List<string> fixes)
    {
        // Check CharacterController
        var controller = movement.GetComponent<CharacterController>();
        if (controller == null)
        {
            errors.Add("AAAMovementController requires CharacterController component");
            if (autoFixIssues)
            {
                movement.gameObject.AddComponent<CharacterController>();
                fixes.Add("Added missing CharacterController component");
            }
        }
        else
        {
            ValidateCharacterController(controller, warnings, fixes);
        }
        
        // Check configuration (using actual API)
        // Note: Config property may not exist, check individual properties instead
        try 
        {
            float moveSpeed = movement.MoveSpeed;
            // Note: JumpForce is not public, so we can't validate it directly
            // If we get here, the movement controller is properly initialized
        }
        catch
        {
            warnings.Add("Movement controller may not be properly initialized");
        }
        
        // Check camera reference (simplified for actual API)
        // Note: cameraTransform property may not exist in actual implementation
        warnings.Add("Verify camera setup is compatible with movement controller");
        
        // Check for conflicting movement scripts
        ValidateConflictingComponents(movement.gameObject, warnings, fixes);
    }
    
    private void ValidateCharacterController(CharacterController controller, 
        System.Collections.Generic.List<string> warnings, 
        System.Collections.Generic.List<string> fixes)
    {
        // Check dimensions
        if (controller.height < 100f || controller.height > 500f)
        {
            warnings.Add($"CharacterController height ({controller.height}) may be incorrect for this movement system (recommended: 200-400)");
        }
        
        if (controller.radius < 20f || controller.radius > 100f)
        {
            warnings.Add($"CharacterController radius ({controller.radius}) may be incorrect (recommended: 30-70)");
        }
        
        // Check skin width
        float recommendedSkinWidth = controller.height * 0.04f; // 4% of height
        if (Mathf.Abs(controller.skinWidth - recommendedSkinWidth) > 5f)
        {
            warnings.Add($"CharacterController skinWidth ({controller.skinWidth}) should be ~4% of height ({recommendedSkinWidth:F1})");
            if (autoFixIssues)
            {
                controller.skinWidth = recommendedSkinWidth;
                fixes.Add($"Adjusted skinWidth to {recommendedSkinWidth:F1}");
            }
        }
        
        // Check slope limit
        if (controller.slopeLimit < 30f || controller.slopeLimit > 60f)
        {
            warnings.Add($"CharacterController slopeLimit ({controller.slopeLimit}°) may cause issues (recommended: 45-55°)");
        }
        
        // Check step offset
        float recommendedStepOffset = controller.height * 0.125f; // 12.5% of height
        if (Mathf.Abs(controller.stepOffset - recommendedStepOffset) > 10f)
        {
            warnings.Add($"CharacterController stepOffset ({controller.stepOffset}) should be ~12.5% of height ({recommendedStepOffset:F1})");
            if (autoFixIssues)
            {
                controller.stepOffset = recommendedStepOffset;
                fixes.Add($"Adjusted stepOffset to {recommendedStepOffset:F1}");
            }
        }
    }
    
    private void ValidateMovementConfig(MovementConfig config, 
        System.Collections.Generic.List<string> warnings, 
        System.Collections.Generic.List<string> fixes)
    {
        // Simplified validation since we may not have direct access to config properties
        // Check basic physics values if available
        if (config.gravity > -1000f)
        {
            warnings.Add($"Gravity ({config.gravity}) may be too weak for responsive movement (recommended: -5000 to -10000)");
        }
        
        if (config.jumpForce < 500f || config.jumpForce > 5000f)
        {
            warnings.Add($"Jump force ({config.jumpForce}) may be inappropriate (recommended: 1000-2500)");
        }
        
        // Note: Other config validations depend on actual MovementConfig implementation
        warnings.Add("Manual config validation recommended - check movement settings");
    }
    
    private void ValidateConflictingComponents(GameObject player, 
        System.Collections.Generic.List<string> warnings, 
        System.Collections.Generic.List<string> fixes)
    {
        // Check for Rigidbody conflicts
        var rb = player.GetComponent<Rigidbody>();
        if (rb != null && !rb.isKinematic)
        {
            warnings.Add("Non-kinematic Rigidbody may conflict with CharacterController movement");
            if (autoFixIssues)
            {
                rb.isKinematic = true;
                fixes.Add("Set Rigidbody to kinematic to avoid conflicts");
            }
        }
        
        // Check for other movement scripts
        var movementScripts = player.GetComponents<MonoBehaviour>();
        foreach (var script in movementScripts)
        {
            var typeName = script.GetType().Name;
            if (typeName.Contains("Movement") && !typeName.Contains("AAA") && !typeName.Contains("Clean"))
            {
                warnings.Add($"Potential conflicting movement script found: {typeName}");
            }
        }
    }
    
    private void ValidateSceneSetup(System.Collections.Generic.List<string> errors, 
        System.Collections.Generic.List<string> warnings, 
        System.Collections.Generic.List<string> fixes)
    {
        // Check for ground objects
        var groundObjects = FindObjectsOfType<Collider>();
        bool hasGround = false;
        foreach (var collider in groundObjects)
        {
            if (collider.transform.position.y < 0 && collider.bounds.size.y > 10f)
            {
                hasGround = true;
                break;
            }
        }
        
        if (!hasGround)
        {
            warnings.Add("No ground colliders detected - player may fall indefinitely");
        }
        
        // Check camera setup
        var cameras = FindObjectsOfType<Camera>();
        if (cameras.Length == 0)
        {
            errors.Add("No cameras found in scene");
        }
        else if (cameras.Length > 1)
        {
            warnings.Add($"Multiple cameras found ({cameras.Length}) - ensure main camera is properly tagged");
        }
        
        // Check physics settings
        if (Physics.gravity.y > -5f)
        {
            warnings.Add($"Physics gravity ({Physics.gravity.y}) is very weak - may affect movement feel");
        }
    }
    
    private void LogValidationResults(ValidationResult result)
    {
        if (result.hasErrors)
        {
            Debug.LogError($"[Movement Validation] Found {result.errors.Length} errors:");
            foreach (var error in result.errors)
            {
                Debug.LogError($"  ❌ {error}");
            }
        }
        
        if (result.hasWarnings)
        {
            Debug.LogWarning($"[Movement Validation] Found {result.warnings.Length} warnings:");
            foreach (var warning in result.warnings)
            {
                Debug.LogWarning($"  ⚠️ {warning}");
            }
        }
        
        if (result.fixes.Length > 0)
        {
            Debug.Log($"[Movement Validation] Applied {result.fixes.Length} automatic fixes:");
            foreach (var fix in result.fixes)
            {
                Debug.Log($"  ✅ {fix}");
            }
        }
        
        if (!result.hasErrors && !result.hasWarnings)
        {
            Debug.Log("[Movement Validation] ✅ All checks passed - setup looks good!");
        }
    }
    
    /// <summary>
    /// Creates a validation report that can be displayed in UI or saved to file.
    /// </summary>
    public string GenerateValidationReport()
    {
        var result = ValidateSetup();
        var report = new System.Text.StringBuilder();
        
        report.AppendLine("=== AAA Movement Controller Validation Report ===");
        report.AppendLine($"Generated: {System.DateTime.Now}");
        report.AppendLine();
        
        if (result.hasErrors)
        {
            report.AppendLine("ERRORS:");
            foreach (var error in result.errors)
            {
                report.AppendLine($"  ❌ {error}");
            }
            report.AppendLine();
        }
        
        if (result.hasWarnings)
        {
            report.AppendLine("WARNINGS:");
            foreach (var warning in result.warnings)
            {
                report.AppendLine($"  ⚠️ {warning}");
            }
            report.AppendLine();
        }
        
        if (result.fixes.Length > 0)
        {
            report.AppendLine("AUTOMATIC FIXES APPLIED:");
            foreach (var fix in result.fixes)
            {
                report.AppendLine($"  ✅ {fix}");
            }
            report.AppendLine();
        }
        
        if (!result.hasErrors && !result.hasWarnings)
        {
            report.AppendLine("✅ All validation checks passed!");
            report.AppendLine("Your movement controller setup looks good.");
        }
        
        return report.ToString();
    }
}