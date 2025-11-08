using UnityEngine;
using System.Collections.Generic;

#if UNITY_EDITOR
using UnityEditor;
#endif

/// <summary>
/// AAA Quality Procedural Wall Jump Parcours Generator
/// Creates dynamic, challenging wall jump courses for testing and gameplay
/// Perfect for Unity Asset Store - Professional quality with extensive customization
/// </summary>
[ExecuteAlways]
public class WallJumpParcours : MonoBehaviour
{
    [Header("=== 🎯 COURSE CONFIGURATION ===")]
    [Tooltip("Seed for procedural generation (same seed = same course)")]
    public int seed = 42;
    
    [Tooltip("Course difficulty preset")]
    public DifficultyLevel difficulty = DifficultyLevel.Medium;
    
    [Tooltip("Number of wall segments in the course")]
    [Range(5, 50)]
    public int segmentCount = 15;
    
    [Tooltip("Course layout pattern")]
    public CoursePattern pattern = CoursePattern.ZigZag;
    
    [Header("=== 📐 SPACING & DIMENSIONS ===")]
    [Tooltip("Distance between wall segments (horizontal)")]
    [Range(300f, 1200f)]
    public float segmentSpacing = 600f;
    
    [Tooltip("Height variation between segments")]
    [Range(0f, 500f)]
    public float heightVariation = 200f;
    
    [Tooltip("Wall width (perpendicular to jump direction)")]
    [Range(200f, 1000f)]
    public float wallWidth = 500f;
    
    [Tooltip("Wall height (vertical dimension)")]
    [Range(400f, 1500f)]
    public float wallHeight = 800f;
    
    [Tooltip("Wall thickness")]
    [Range(20f, 100f)]
    public float wallThickness = 50f;
    
    [Header("=== 🎨 VISUAL STYLING ===")]
    [Tooltip("Wall material (auto-creates if null)")]
    public Material wallMaterial;
    
    [Tooltip("Use color gradient based on difficulty")]
    public bool useGradientColors = true;
    
    [Tooltip("Start color for gradient")]
    public Color startColor = new Color(0.2f, 0.8f, 0.3f);
    
    [Tooltip("End color for gradient")]
    public Color endColor = new Color(0.8f, 0.2f, 0.2f);
    
    [Header("=== 🎮 GAMEPLAY FEATURES ===")]
    [Tooltip("Add checkpoint platforms")]
    public bool addCheckpoints = true;
    
    [Tooltip("Checkpoint frequency (every N segments)")]
    [Range(3, 10)]
    public int checkpointFrequency = 5;
    
    [Tooltip("Add visual guides (arrows)")]
    public bool addVisualGuides = true;
    
    [Tooltip("Add starting platform")]
    public bool addStartPlatform = true;
    
    [Tooltip("Add ending platform")]
    public bool addEndPlatform = true;
    
    [Tooltip("Add numbered markers to walls for easier navigation")]
    public bool addWallNumbers = true;
    
    [Tooltip("Add distance markers showing jump gaps")]
    public bool addDistanceIndicators = false;
    
    [Header("=== ⚙️ ADVANCED SETTINGS ===")]
    [Tooltip("Randomize wall angles slightly")]
    public bool randomizeAngles = false;
    
    [Tooltip("Max angle randomization (degrees)")]
    [Range(0f, 15f)]
    public float maxAngleRandomization = 5f;
    
    [Tooltip("Add decorative elements")]
    public bool addDecorations = false;
    
    [Tooltip("Physics layer for walls")]
    public LayerMask wallLayer = 1; // Default layer
    
    [Header("=== 🔧 GENERATION CONTROLS ===")]
    [Tooltip("Auto-generate on value change (Editor only)")]
    public bool autoRegenerate = true;
    
    [Tooltip("Parent object for all course elements")]
    public Transform courseParent;
    
    // Internal state
    private List<GameObject> generatedObjects = new List<GameObject>();
    private System.Random rng;
    
#if UNITY_EDITOR
    private bool regenerationQueued = false;
#endif
    
    public enum DifficultyLevel
    {
        Tutorial,    // Wide spacing, low height variation
        Easy,        // Comfortable spacing, some variation
        Medium,      // Standard spacing, moderate variation
        Hard,        // Tight spacing, high variation
        Expert,      // Extreme spacing, maximum variation
        Insane       // Barely possible, requires perfect execution
    }
    
    public enum CoursePattern
    {
        ZigZag,          // Classic alternating walls
        Spiral,          // Circular ascending path
        Wave,            // Sinusoidal pattern
        Staircase,       // Ascending steps
        Random,          // Completely random placement
        DoubleHelix,     // Two intertwined spirals
        Canyon,          // Parallel walls (corridor style)
        Obstacle         // Mixed patterns with challenges
    }
    
    void Start()
    {
        if (Application.isPlaying)
        {
            GenerateCourse();
        }
    }
    
#if UNITY_EDITOR
    void OnValidate()
    {
        if (!Application.isPlaying && autoRegenerate && !regenerationQueued)
        {
            regenerationQueued = true;
            // Delay generation to avoid editor issues and prevent multiple queued calls
            EditorApplication.delayCall += () =>
            {
                if (this != null)
                {
                    GenerateCourse();
                    regenerationQueued = false;
                }
            };
        }
    }
#endif
    
    /// <summary>
    /// Main generation method - Creates the entire parcours
    /// </summary>
    [ContextMenu("Generate Course")]
    public void GenerateCourse()
    {
        // Initialize RNG
        rng = new System.Random(seed);
        
        // Clear previous course
        ClearCourse();
        
        // Setup parent
        if (courseParent == null)
        {
            GameObject parentObj = new GameObject("WallJumpCourse");
            parentObj.transform.SetParent(transform);
            parentObj.transform.localPosition = Vector3.zero;
            courseParent = parentObj.transform;
        }
        
        // Apply difficulty settings
        ApplyDifficultySettings();
        
        // Generate start platform
        if (addStartPlatform)
        {
            GenerateStartPlatform();
        }
        
        // Generate wall segments based on pattern
        GenerateWallSegments();
        
        // Add checkpoints
        if (addCheckpoints)
        {
            GenerateCheckpoints();
        }
        
        // Add visual guides
        if (addVisualGuides)
        {
            GenerateVisualGuides();
        }
        
        // Generate end platform
        if (addEndPlatform)
        {
            GenerateEndPlatform();
        }
        
        Debug.Log($"[WallJumpParcours] Generated {segmentCount} segments with {pattern} pattern (Difficulty: {difficulty})");
    }
    
    /// <summary>
    /// Clears all generated course elements
    /// </summary>
    [ContextMenu("Clear Course")]
    public void ClearCourse()
    {
        if (courseParent != null)
        {
            // Destroy all children
            while (courseParent.childCount > 0)
            {
                DestroyImmediate(courseParent.GetChild(0).gameObject);
            }
        }
        
        generatedObjects.Clear();
    }
    
    /// <summary>
    /// Apply preset difficulty values
    /// </summary>
    private void ApplyDifficultySettings()
    {
        switch (difficulty)
        {
            case DifficultyLevel.Tutorial:
                segmentSpacing = 800f;
                heightVariation = 50f;
                break;
                
            case DifficultyLevel.Easy:
                segmentSpacing = 700f;
                heightVariation = 100f;
                break;
                
            case DifficultyLevel.Medium:
                segmentSpacing = 600f;
                heightVariation = 200f;
                break;
                
            case DifficultyLevel.Hard:
                segmentSpacing = 500f;
                heightVariation = 300f;
                break;
                
            case DifficultyLevel.Expert:
                segmentSpacing = 400f;
                heightVariation = 400f;
                break;
                
            case DifficultyLevel.Insane:
                segmentSpacing = 350f;
                heightVariation = 500f;
                break;
        }
    }
    
    /// <summary>
    /// Generate wall segments based on selected pattern
    /// </summary>
    private void GenerateWallSegments()
    {
        for (int i = 0; i < segmentCount; i++)
        {
            Vector3 position = CalculateSegmentPosition(i);
            Quaternion rotation = CalculateSegmentRotation(i);
            
            CreateWallSegment(position, rotation, i);
        }
    }
    
    /// <summary>
    /// Calculate position for segment based on pattern
    /// </summary>
    private Vector3 CalculateSegmentPosition(int index)
    {
        float progress = (float)index / segmentCount;
        Vector3 position = Vector3.zero;
        
        switch (pattern)
        {
            case CoursePattern.ZigZag:
                position = new Vector3(
                    (index % 2 == 0 ? 1 : -1) * segmentSpacing * 0.5f,
                    index * heightVariation * 0.5f + GetRandomHeight(),
                    index * segmentSpacing
                );
                break;
                
            case CoursePattern.Spiral:
                float angle = index * (360f / segmentCount) * 3f * Mathf.Deg2Rad;
                float radius = segmentSpacing * 0.8f;
                position = new Vector3(
                    Mathf.Cos(angle) * radius,
                    index * heightVariation * 0.3f,
                    Mathf.Sin(angle) * radius
                );
                break;
                
            case CoursePattern.Wave:
                position = new Vector3(
                    Mathf.Sin(index * 0.5f) * segmentSpacing * 0.7f,
                    index * heightVariation * 0.4f + GetRandomHeight(),
                    index * segmentSpacing * 0.6f
                );
                break;
                
            case CoursePattern.Staircase:
                int stairSide = (index / 3) % 2;
                position = new Vector3(
                    (stairSide == 0 ? 1 : -1) * segmentSpacing * 0.6f,
                    index * heightVariation * 0.6f,
                    index * segmentSpacing * 0.5f
                );
                break;
                
            case CoursePattern.Random:
                position = new Vector3(
                    GetRandomFloat(-segmentSpacing, segmentSpacing),
                    index * heightVariation * 0.5f + GetRandomHeight(),
                    index * segmentSpacing * 0.7f
                );
                break;
                
            case CoursePattern.DoubleHelix:
                float helixAngle = index * (360f / segmentCount) * 2f * Mathf.Deg2Rad;
                float helixRadius = segmentSpacing * 0.5f;
                int helixStrand = index % 2;
                position = new Vector3(
                    Mathf.Cos(helixAngle + helixStrand * Mathf.PI) * helixRadius,
                    index * heightVariation * 0.4f,
                    Mathf.Sin(helixAngle + helixStrand * Mathf.PI) * helixRadius + index * segmentSpacing * 0.3f
                );
                break;
                
            case CoursePattern.Canyon:
                position = new Vector3(
                    (index % 2 == 0 ? 1 : -1) * segmentSpacing * 0.8f,
                    GetRandomHeight() * 0.5f,
                    index * segmentSpacing * 0.5f
                );
                break;
                
            case CoursePattern.Obstacle:
                // Mix of patterns
                if (index % 5 == 0)
                {
                    position = new Vector3(0, index * heightVariation * 0.5f, index * segmentSpacing * 0.6f);
                }
                else
                {
                    position = new Vector3(
                        (index % 2 == 0 ? 1 : -1) * segmentSpacing * 0.6f,
                        index * heightVariation * 0.4f + GetRandomHeight(),
                        index * segmentSpacing * 0.5f
                    );
                }
                break;
        }
        
        return position + transform.position;
    }
    
    /// <summary>
    /// Calculate rotation for segment
    /// </summary>
    private Quaternion CalculateSegmentRotation(int index)
    {
        Quaternion baseRotation = Quaternion.identity;
        
        // Face walls toward center/player path
        if (pattern == CoursePattern.Spiral || pattern == CoursePattern.DoubleHelix)
        {
            Vector3 toCenter = -CalculateSegmentPosition(index);
            toCenter.y = 0;
            if (toCenter != Vector3.zero)
            {
                baseRotation = Quaternion.LookRotation(toCenter);
            }
        }
        else if (pattern == CoursePattern.Canyon)
        {
            // Walls face each other
            baseRotation = Quaternion.Euler(0, index % 2 == 0 ? 90 : -90, 0);
        }
        else
        {
            // Default: walls face forward
            baseRotation = Quaternion.Euler(0, index % 2 == 0 ? 90 : -90, 0);
        }
        
        // Add randomization
        if (randomizeAngles)
        {
            float randomYaw = GetRandomFloat(-maxAngleRandomization, maxAngleRandomization);
            baseRotation *= Quaternion.Euler(0, randomYaw, 0);
        }
        
        return baseRotation;
    }
    
    /// <summary>
    /// Create a single wall segment
    /// </summary>
    private void CreateWallSegment(Vector3 position, Quaternion rotation, int index)
    {
        // Create wall GameObject
        GameObject wall = GameObject.CreatePrimitive(PrimitiveType.Cube);
        wall.name = $"Wall_{index:D2}";
        wall.transform.SetParent(courseParent);
        wall.transform.position = position;
        wall.transform.rotation = rotation;
        wall.transform.localScale = new Vector3(wallThickness, wallHeight, wallWidth);
        
        // Apply material and color
        Renderer renderer = wall.GetComponent<Renderer>();
        if (wallMaterial != null)
        {
            renderer.material = wallMaterial;
        }
        else
        {
            // Create default material
            Material mat = new Material(Shader.Find("Standard"));
            renderer.material = mat;
        }
        
        // Apply gradient color
        if (useGradientColors)
        {
            float t = (float)index / segmentCount;
            Color wallColor = Color.Lerp(startColor, endColor, t);
            renderer.material.color = wallColor;
        }
        
        // Set layer - Check if wallLayer mask represents a single layer (power of 2)
        // This bit trick: (n & (n-1)) == 0 is true only for powers of 2 (single layer masks)
        if (wallLayer.value > 0 && (wallLayer.value & (wallLayer.value - 1)) == 0)
        {
            // wallLayer is a single layer, extract the layer index using log2
            wall.layer = (int)Mathf.Log(wallLayer.value, 2);
        }
        // Otherwise keep default layer (0)
        
        // Add wall number label if enabled
        if (addWallNumbers)
        {
            CreateWallNumberLabel(wall, index + 1, position);
        }
        
        generatedObjects.Add(wall);
    }
    
    /// <summary>
    /// Create a 3D text label showing wall number
    /// </summary>
    private void CreateWallNumberLabel(GameObject wall, int number, Vector3 wallPosition)
    {
        // Create a small cube as visual marker for the number
        GameObject marker = GameObject.CreatePrimitive(PrimitiveType.Cube);
        marker.name = $"WallMarker_{number}";
        marker.transform.SetParent(wall.transform);
        marker.transform.localPosition = new Vector3(0, wallHeight * 0.4f / wallHeight, wallWidth * 0.4f / wallWidth); // Top front corner
        marker.transform.localScale = new Vector3(0.3f, 0.3f, 0.3f);
        
        // Bright color for visibility
        Renderer renderer = marker.GetComponent<Renderer>();
        Material mat = new Material(Shader.Find("Standard"));
        mat.color = Color.yellow;
        mat.SetFloat("_Metallic", 0.5f);
        mat.SetFloat("_Glossiness", 0.8f);
        renderer.material = mat;
        
        // Disable collision for marker
        Collider collider = marker.GetComponent<Collider>();
        if (collider != null)
        {
            DestroyImmediate(collider);
        }
        
        // Note: For production, you'd use TextMeshPro for better text rendering
        // This uses a simple visual marker instead for universal compatibility
    }
    
    /// <summary>
    /// Generate starting platform
    /// </summary>
    private void GenerateStartPlatform()
    {
        GameObject platform = GameObject.CreatePrimitive(PrimitiveType.Cube);
        platform.name = "StartPlatform";
        platform.transform.SetParent(courseParent);
        platform.transform.position = transform.position + Vector3.down * wallHeight * 0.5f;
        platform.transform.localScale = new Vector3(800f, 50f, 800f);
        
        // Apply material
        Renderer renderer = platform.GetComponent<Renderer>();
        Material mat = new Material(Shader.Find("Standard"));
        mat.color = new Color(0.3f, 0.3f, 0.8f);
        renderer.material = mat;
        
        generatedObjects.Add(platform);
    }
    
    /// <summary>
    /// Generate ending platform
    /// </summary>
    private void GenerateEndPlatform()
    {
        Vector3 lastPos = CalculateSegmentPosition(segmentCount - 1);
        Vector3 endPos = lastPos + Vector3.forward * segmentSpacing * 1.5f + Vector3.up * heightVariation;
        
        GameObject platform = GameObject.CreatePrimitive(PrimitiveType.Cube);
        platform.name = "EndPlatform";
        platform.transform.SetParent(courseParent);
        platform.transform.position = endPos;
        platform.transform.localScale = new Vector3(1000f, 50f, 1000f);
        
        // Apply material
        Renderer renderer = platform.GetComponent<Renderer>();
        Material mat = new Material(Shader.Find("Standard"));
        mat.color = new Color(0.8f, 0.8f, 0.2f);
        renderer.material = mat;
        
        generatedObjects.Add(platform);
    }
    
    /// <summary>
    /// Generate checkpoint platforms throughout course
    /// </summary>
    private void GenerateCheckpoints()
    {
        for (int i = checkpointFrequency; i < segmentCount; i += checkpointFrequency)
        {
            Vector3 checkpointPos = CalculateSegmentPosition(i);
            checkpointPos += Vector3.down * wallHeight * 0.3f;
            
            GameObject checkpoint = GameObject.CreatePrimitive(PrimitiveType.Cube);
            checkpoint.name = $"Checkpoint_{i / checkpointFrequency}";
            checkpoint.transform.SetParent(courseParent);
            checkpoint.transform.position = checkpointPos;
            checkpoint.transform.localScale = new Vector3(400f, 30f, 400f);
            
            // Apply material
            Renderer renderer = checkpoint.GetComponent<Renderer>();
            Material mat = new Material(Shader.Find("Standard"));
            mat.color = new Color(0.2f, 0.8f, 0.8f);
            renderer.material = mat;
            
            generatedObjects.Add(checkpoint);
        }
    }
    
    /// <summary>
    /// Generate visual guide arrows
    /// </summary>
    private void GenerateVisualGuides()
    {
        for (int i = 0; i < segmentCount - 1; i++)
        {
            Vector3 currentPos = CalculateSegmentPosition(i);
            Vector3 nextPos = CalculateSegmentPosition(i + 1);
            Vector3 midPoint = (currentPos + nextPos) * 0.5f;
            Vector3 direction = (nextPos - currentPos).normalized;
            
            // Create arrow (using elongated cube for simplicity)
            GameObject arrow = GameObject.CreatePrimitive(PrimitiveType.Cube);
            arrow.name = $"Guide_{i:D2}";
            arrow.transform.SetParent(courseParent);
            arrow.transform.position = midPoint;
            arrow.transform.rotation = Quaternion.LookRotation(direction);
            arrow.transform.localScale = new Vector3(20f, 20f, 100f);
            
            // Apply material
            Renderer renderer = arrow.GetComponent<Renderer>();
            Material mat = new Material(Shader.Find("Standard"));
            mat.color = new Color(1f, 1f, 0f, 0.5f);
            renderer.material = mat;
            
            // Disable collider
            Collider collider = arrow.GetComponent<Collider>();
            if (collider != null)
            {
                DestroyImmediate(collider);
            }
            
            generatedObjects.Add(arrow);
        }
    }
    
    // Utility methods
    private float GetRandomHeight()
    {
        return GetRandomFloat(-heightVariation * 0.3f, heightVariation * 0.3f);
    }
    
    private float GetRandomFloat(float min, float max)
    {
        return min + (float)rng.NextDouble() * (max - min);
    }
    
    /// <summary>
    /// Exports course settings as a preset
    /// </summary>
    [ContextMenu("Export Preset")]
    public void ExportPreset()
    {
        Debug.Log($"[WallJumpParcours] Preset: Seed={seed}, Difficulty={difficulty}, Pattern={pattern}, Segments={segmentCount}");
    }
    
    /// <summary>
    /// Visualize course path in editor
    /// </summary>
    private void OnDrawGizmos()
    {
        if (!Application.isPlaying && segmentCount > 0)
        {
            Gizmos.color = Color.cyan;
            
            for (int i = 0; i < segmentCount; i++)
            {
                Vector3 pos = CalculateSegmentPosition(i);
                Gizmos.DrawWireCube(pos, Vector3.one * 100f);
                
                if (i < segmentCount - 1)
                {
                    Vector3 nextPos = CalculateSegmentPosition(i + 1);
                    Gizmos.DrawLine(pos, nextPos);
                }
            }
        }
    }
}