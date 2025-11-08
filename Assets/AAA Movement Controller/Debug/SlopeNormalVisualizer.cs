using UnityEngine;

/// <summary>
/// Visual debugger that shows ground normals and slope angles in the Scene view.
/// Attach to your player to see exactly what the ground detection is hitting.
/// </summary>
public class SlopeNormalVisualizer : MonoBehaviour
{
    [Header("Visual Debug Settings")]
    public bool enableVisualization = true;
    public bool showRaycast = true;
    public bool showNormal = true;
    public bool showSlope = true;
    public float rayLength = 5f;
    public float normalLength = 2f;
    public Color rayColor = Color.red;
    public Color normalColor = Color.blue;
    public Color slopeColor = Color.green;
    
    private RaycastHit lastHit;
    private bool hasValidHit = false;
    
    void Update()
    {
        if (!enableVisualization) return;
        
        // Perform the same raycast as the debugger
        Vector3 origin = transform.position + Vector3.up * 0.1f;
        if (Physics.Raycast(origin, Vector3.down, out lastHit, rayLength))
        {
            hasValidHit = true;
        }
        else
        {
            hasValidHit = false;
        }
    }
    
    void OnDrawGizmos()
    {
        if (!enableVisualization) return;
        
        Vector3 origin = transform.position + Vector3.up * 0.1f;
        
        // Draw the raycast
        if (showRaycast)
        {
            Gizmos.color = rayColor;
            if (hasValidHit)
            {
                Gizmos.DrawLine(origin, lastHit.point);
                Gizmos.DrawWireSphere(lastHit.point, 0.1f);
            }
            else
            {
                Gizmos.DrawLine(origin, origin + Vector3.down * rayLength);
            }
        }
        
        // Draw the normal
        if (showNormal && hasValidHit)
        {
            Gizmos.color = normalColor;
            Vector3 normalStart = lastHit.point;
            Vector3 normalEnd = normalStart + lastHit.normal * normalLength;
            Gizmos.DrawLine(normalStart, normalEnd);
            Gizmos.DrawWireCube(normalEnd, Vector3.one * 0.1f);
            
            // Draw angle arc if slope exists
            if (showSlope)
            {
                float angle = Vector3.Angle(Vector3.up, lastHit.normal);
                if (angle > 0.1f) // Only draw if there's a meaningful slope
                {
                    Gizmos.color = slopeColor;
                    
                    // Draw slope direction
                    Vector3 slopeDir = Vector3.ProjectOnPlane(Vector3.down, lastHit.normal).normalized;
                    Vector3 slopeEnd = normalStart + slopeDir * normalLength;
                    Gizmos.DrawLine(normalStart, slopeEnd);
                    
                    // Draw angle indicator
                    DrawAngleArc(normalStart, Vector3.up, lastHit.normal, normalLength * 0.5f);
                }
            }
        }
    }
    
    void DrawAngleArc(Vector3 center, Vector3 from, Vector3 to, float radius)
    {
        float angle = Vector3.Angle(from, to);
        Vector3 axis = Vector3.Cross(from, to).normalized;
        
        if (axis == Vector3.zero) return; // Parallel vectors
        
        int segments = Mathf.Max(3, (int)(angle / 5f)); // 5 degrees per segment
        float angleStep = angle / segments;
        
        Vector3 currentDir = from;
        for (int i = 0; i < segments; i++)
        {
            Vector3 nextDir = Quaternion.AngleAxis(angleStep, axis) * currentDir;
            Gizmos.DrawLine(
                center + currentDir * radius,
                center + nextDir * radius
            );
            currentDir = nextDir;
        }
    }
    
    void OnGUI()
    {
        if (!enableVisualization) return;
        
        GUILayout.BeginArea(new Rect(10, Screen.height - 150, 300, 140));
        GUILayout.Label("=== Slope Normal Debug ===", GUI.skin.box);
        
        if (hasValidHit)
        {
            float angle = Vector3.Angle(Vector3.up, lastHit.normal);
            GUILayout.Label($"Hit Object: {lastHit.collider.name}");
            GUILayout.Label($"Slope Angle: {angle:F2}°");
            GUILayout.Label($"Normal: {lastHit.normal}");
            GUILayout.Label($"Hit Point: {lastHit.point}");
            
            // Collider type info
            string colliderType = lastHit.collider.GetType().Name;
            GUILayout.Label($"Collider Type: {colliderType}");
            
            if (lastHit.collider is MeshCollider meshCol)
            {
                GUILayout.Label($"Convex: {meshCol.convex}");
                GUILayout.Label($"Mesh: {(meshCol.sharedMesh ? meshCol.sharedMesh.name : "null")}");
            }
        }
        else
        {
            GUILayout.Label("No ground hit detected");
        }
        
        GUILayout.EndArea();
    }
}