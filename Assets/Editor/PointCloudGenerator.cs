using UnityEngine;
using UnityEditor;
using System;
using System.Collections.Generic;
using System.Linq;

namespace UnityMCP
{
    /// <summary>
    /// Point cloud generation system for LiDAR-style terrain scanning and organic world creation
    /// Enables realistic terrain generation from point cloud data with mesh conversion
    /// </summary>
    public class PointCloudGenerator
    {
        /// <summary>
        /// Point cloud data structure
        /// </summary>
        public class PointCloudData
        {
            public Vector3 position;
            public Vector3 normal;
            public Color color;
            public float intensity;  // For LiDAR-style intensity data
            
            public PointCloudData(Vector3 pos, Vector3 norm, Color col, float inten = 1.0f)
            {
                position = pos;
                normal = norm;
                color = col;
                intensity = inten;
            }
        }
        
        /// <summary>
        /// Point cloud generation settings
        /// </summary>
        public class PointCloudSettings
        {
            public int pointCount = 10000;
            public float areaSize = 100f;
            public float heightVariation = 20f;
            public bool usePerlinNoise = true;
            public float noiseScale = 0.1f;
            public float noiseAmplitude = 10f;
            public int noiseSeed = 0;
            public bool colorByHeight = true;
            public Gradient heightGradient;
            public bool generateNormals = true;
            
            public PointCloudSettings()
            {
                // Default gradient from blue (water) to green (grass) to brown (mountain)
                heightGradient = new Gradient();
                GradientColorKey[] colorKeys = new GradientColorKey[4];
                colorKeys[0] = new GradientColorKey(new Color(0.2f, 0.4f, 0.8f), 0.0f);  // Blue
                colorKeys[1] = new GradientColorKey(new Color(0.3f, 0.6f, 0.3f), 0.3f);  // Green
                colorKeys[2] = new GradientColorKey(new Color(0.5f, 0.4f, 0.3f), 0.7f);  // Brown
                colorKeys[3] = new GradientColorKey(new Color(0.8f, 0.8f, 0.8f), 1.0f);  // Gray
                
                GradientAlphaKey[] alphaKeys = new GradientAlphaKey[2];
                alphaKeys[0] = new GradientAlphaKey(1.0f, 0.0f);
                alphaKeys[1] = new GradientAlphaKey(1.0f, 1.0f);
                
                heightGradient.SetKeys(colorKeys, alphaKeys);
            }
        }
        
        /// <summary>
        /// Generate a point cloud representing terrain
        /// </summary>
        public static List<PointCloudData> GenerateTerrainPointCloud(PointCloudSettings settings)
        {
            List<PointCloudData> points = new List<PointCloudData>();
            
            if (settings.noiseSeed != 0)
            {
                UnityEngine.Random.InitState(settings.noiseSeed);
            }
            
            float halfSize = settings.areaSize * 0.5f;
            
            for (int i = 0; i < settings.pointCount; i++)
            {
                // Random position in XZ plane
                float x = UnityEngine.Random.Range(-halfSize, halfSize);
                float z = UnityEngine.Random.Range(-halfSize, halfSize);
                
                // Calculate height using Perlin noise
                float y = 0f;
                if (settings.usePerlinNoise)
                {
                    float noiseX = (x + halfSize) * settings.noiseScale;
                    float noiseZ = (z + halfSize) * settings.noiseScale;
                    y = Mathf.PerlinNoise(noiseX, noiseZ) * settings.noiseAmplitude;
                    
                    // Add octaves for more detail
                    y += Mathf.PerlinNoise(noiseX * 2f, noiseZ * 2f) * settings.noiseAmplitude * 0.5f;
                    y += Mathf.PerlinNoise(noiseX * 4f, noiseZ * 4f) * settings.noiseAmplitude * 0.25f;
                }
                else
                {
                    y = UnityEngine.Random.Range(0f, settings.heightVariation);
                }
                
                Vector3 position = new Vector3(x, y, z);
                
                // Calculate normal (approximate from nearby points)
                Vector3 normal = Vector3.up;
                if (settings.generateNormals && settings.usePerlinNoise)
                {
                    normal = CalculateNormalFromNoise(x, z, settings);
                }
                
                // Color by height if enabled
                Color color = Color.white;
                if (settings.colorByHeight)
                {
                    float normalizedHeight = Mathf.Clamp01(y / settings.noiseAmplitude);
                    color = settings.heightGradient.Evaluate(normalizedHeight);
                }
                
                // Intensity based on height for LiDAR-style data
                float intensity = Mathf.Clamp01(y / settings.noiseAmplitude);
                
                points.Add(new PointCloudData(position, normal, color, intensity));
            }
            
            return points;
        }
        
        /// <summary>
        /// Calculate normal vector from Perlin noise gradient
        /// </summary>
        private static Vector3 CalculateNormalFromNoise(float x, float z, PointCloudSettings settings)
        {
            float halfSize = settings.areaSize * 0.5f;
            float delta = 0.1f;
            
            float noiseX = (x + halfSize) * settings.noiseScale;
            float noiseZ = (z + halfSize) * settings.noiseScale;
            
            float heightL = Mathf.PerlinNoise(noiseX - delta, noiseZ) * settings.noiseAmplitude;
            float heightR = Mathf.PerlinNoise(noiseX + delta, noiseZ) * settings.noiseAmplitude;
            float heightD = Mathf.PerlinNoise(noiseX, noiseZ - delta) * settings.noiseAmplitude;
            float heightU = Mathf.PerlinNoise(noiseX, noiseZ + delta) * settings.noiseAmplitude;
            
            Vector3 normal = new Vector3(heightL - heightR, 2f * delta, heightD - heightU);
            return normal.normalized;
        }
        
        /// <summary>
        /// Generate point cloud from existing mesh (useful for mesh analysis)
        /// </summary>
        public static List<PointCloudData> GenerateFromMesh(Mesh mesh, int sampleCount = 1000)
        {
            List<PointCloudData> points = new List<PointCloudData>();
            
            if (mesh == null || mesh.triangles.Length == 0)
            {
                return points;
            }
            
            Vector3[] vertices = mesh.vertices;
            Vector3[] normals = mesh.normals;
            Color[] colors = mesh.colors;
            int[] triangles = mesh.triangles;
            
            bool hasNormals = normals != null && normals.Length > 0;
            bool hasColors = colors != null && colors.Length > 0;
            
            // Sample points from mesh surface
            for (int i = 0; i < sampleCount; i++)
            {
                // Pick random triangle
                int triIndex = UnityEngine.Random.Range(0, triangles.Length / 3) * 3;
                
                Vector3 v0 = vertices[triangles[triIndex]];
                Vector3 v1 = vertices[triangles[triIndex + 1]];
                Vector3 v2 = vertices[triangles[triIndex + 2]];
                
                // Random barycentric coordinates
                float r1 = UnityEngine.Random.value;
                float r2 = UnityEngine.Random.value;
                if (r1 + r2 > 1f)
                {
                    r1 = 1f - r1;
                    r2 = 1f - r2;
                }
                float r3 = 1f - r1 - r2;
                
                // Interpolate position
                Vector3 position = v0 * r1 + v1 * r2 + v2 * r3;
                
                // Interpolate normal
                Vector3 normal = Vector3.up;
                if (hasNormals)
                {
                    Vector3 n0 = normals[triangles[triIndex]];
                    Vector3 n1 = normals[triangles[triIndex + 1]];
                    Vector3 n2 = normals[triangles[triIndex + 2]];
                    normal = (n0 * r1 + n1 * r2 + n2 * r3).normalized;
                }
                
                // Interpolate color
                Color color = Color.white;
                if (hasColors)
                {
                    Color c0 = colors[triangles[triIndex]];
                    Color c1 = colors[triangles[triIndex + 1]];
                    Color c2 = colors[triangles[triIndex + 2]];
                    color = c0 * r1 + c1 * r2 + c2 * r3;
                }
                
                points.Add(new PointCloudData(position, normal, color, 1.0f));
            }
            
            return points;
        }
        
        /// <summary>
        /// Convert point cloud to mesh using simple vertex-based approach
        /// For small point clouds, creates a vertex mesh with point rendering
        /// </summary>
        public static Mesh ConvertToVertexMesh(List<PointCloudData> points)
        {
            Mesh mesh = new Mesh();
            mesh.name = "PointCloudMesh";
            
            if (points.Count == 0)
            {
                return mesh;
            }
            
            // Create vertices
            Vector3[] vertices = new Vector3[points.Count];
            Color[] colors = new Color[points.Count];
            Vector3[] normals = new Vector3[points.Count];
            int[] indices = new int[points.Count];
            
            for (int i = 0; i < points.Count; i++)
            {
                vertices[i] = points[i].position;
                colors[i] = points[i].color;
                normals[i] = points[i].normal;
                indices[i] = i;
            }
            
            mesh.vertices = vertices;
            mesh.colors = colors;
            mesh.normals = normals;
            mesh.SetIndices(indices, MeshTopology.Points, 0);
            mesh.RecalculateBounds();
            
            return mesh;
        }
        
        /// <summary>
        /// Convert point cloud to surface mesh using grid-based triangulation
        /// Better for creating actual terrain surfaces
        /// </summary>
        public static Mesh ConvertToSurfaceMesh(List<PointCloudData> points, int gridResolution = 50)
        {
            Mesh mesh = new Mesh();
            mesh.name = "PointCloudSurfaceMesh";
            
            if (points.Count == 0)
            {
                return mesh;
            }
            
            // Find bounds
            Vector3 min = points[0].position;
            Vector3 max = points[0].position;
            foreach (var point in points)
            {
                min = Vector3.Min(min, point.position);
                max = Vector3.Max(max, point.position);
            }
            
            // Create grid
            float stepX = (max.x - min.x) / gridResolution;
            float stepZ = (max.z - min.z) / gridResolution;
            
            Vector3[] vertices = new Vector3[(gridResolution + 1) * (gridResolution + 1)];
            Color[] colors = new Color[vertices.Length];
            
            // Fill grid with interpolated heights
            for (int z = 0; z <= gridResolution; z++)
            {
                for (int x = 0; x <= gridResolution; x++)
                {
                    int index = z * (gridResolution + 1) + x;
                    
                    float worldX = min.x + x * stepX;
                    float worldZ = min.z + z * stepZ;
                    
                    // Find nearest points and interpolate height
                    float height = InterpolateHeight(points, worldX, worldZ, stepX * 2f);
                    Color color = InterpolateColor(points, worldX, worldZ, stepX * 2f);
                    
                    vertices[index] = new Vector3(worldX, height, worldZ);
                    colors[index] = color;
                }
            }
            
            // Create triangles
            int[] triangles = new int[gridResolution * gridResolution * 6];
            int triIndex = 0;
            
            for (int z = 0; z < gridResolution; z++)
            {
                for (int x = 0; x < gridResolution; x++)
                {
                    int bottomLeft = z * (gridResolution + 1) + x;
                    int bottomRight = bottomLeft + 1;
                    int topLeft = bottomLeft + (gridResolution + 1);
                    int topRight = topLeft + 1;
                    
                    // First triangle
                    triangles[triIndex++] = bottomLeft;
                    triangles[triIndex++] = topLeft;
                    triangles[triIndex++] = bottomRight;
                    
                    // Second triangle
                    triangles[triIndex++] = bottomRight;
                    triangles[triIndex++] = topLeft;
                    triangles[triIndex++] = topRight;
                }
            }
            
            mesh.vertices = vertices;
            mesh.triangles = triangles;
            mesh.colors = colors;
            mesh.RecalculateNormals();
            mesh.RecalculateBounds();
            
            return mesh;
        }
        
        /// <summary>
        /// Interpolate height at position from nearby points
        /// </summary>
        private static float InterpolateHeight(List<PointCloudData> points, float x, float z, float radius)
        {
            float totalWeight = 0f;
            float weightedHeight = 0f;
            
            foreach (var point in points)
            {
                float dx = point.position.x - x;
                float dz = point.position.z - z;
                float distSq = dx * dx + dz * dz;
                
                if (distSq < radius * radius)
                {
                    float dist = Mathf.Sqrt(distSq);
                    float weight = 1f - (dist / radius);
                    weight = weight * weight; // Squared falloff
                    
                    weightedHeight += point.position.y * weight;
                    totalWeight += weight;
                }
            }
            
            return totalWeight > 0 ? weightedHeight / totalWeight : 0f;
        }
        
        /// <summary>
        /// Interpolate color at position from nearby points
        /// </summary>
        private static Color InterpolateColor(List<PointCloudData> points, float x, float z, float radius)
        {
            float totalWeight = 0f;
            Color weightedColor = Color.black;
            
            foreach (var point in points)
            {
                float dx = point.position.x - x;
                float dz = point.position.z - z;
                float distSq = dx * dx + dz * dz;
                
                if (distSq < radius * radius)
                {
                    float dist = Mathf.Sqrt(distSq);
                    float weight = 1f - (dist / radius);
                    weight = weight * weight;
                    
                    weightedColor += point.color * weight;
                    totalWeight += weight;
                }
            }
            
            return totalWeight > 0 ? weightedColor / totalWeight : Color.gray;
        }
        
        /// <summary>
        /// Create a GameObject with point cloud mesh
        /// </summary>
        public static GameObject CreatePointCloudObject(string name, List<PointCloudData> points, bool asSurface = true, int gridResolution = 50)
        {
            GameObject go = new GameObject(name);
            
            MeshFilter meshFilter = go.AddComponent<MeshFilter>();
            MeshRenderer meshRenderer = go.AddComponent<MeshRenderer>();
            
            // Create mesh
            Mesh mesh = asSurface ? 
                ConvertToSurfaceMesh(points, gridResolution) : 
                ConvertToVertexMesh(points);
            
            meshFilter.sharedMesh = mesh;
            
            // Create material
            Material material = new Material(Shader.Find("Standard"));
            material.color = Color.white;
            material.SetFloat("_Metallic", 0f);
            material.SetFloat("_Glossiness", 0.3f);
            
            meshRenderer.sharedMaterial = material;
            
            Undo.RegisterCreatedObjectUndo(go, "Create Point Cloud Object");
            EditorUtility.SetDirty(go);
            
            return go;
        }
        
        /// <summary>
        /// Apply point cloud detail to existing terrain
        /// </summary>
        public static void ApplyToTerrain(Terrain terrain, List<PointCloudData> points)
        {
            if (terrain == null || points.Count == 0)
            {
                return;
            }
            
            TerrainData terrainData = terrain.terrainData;
            int heightmapResolution = terrainData.heightmapResolution;
            float[,] heights = terrainData.GetHeights(0, 0, heightmapResolution, heightmapResolution);
            
            Vector3 terrainPos = terrain.transform.position;
            Vector3 terrainSize = terrainData.size;
            
            // Apply point cloud heights to terrain
            foreach (var point in points)
            {
                // Convert world position to terrain local position
                float localX = (point.position.x - terrainPos.x) / terrainSize.x;
                float localZ = (point.position.z - terrainPos.z) / terrainSize.z;
                
                if (localX >= 0 && localX <= 1 && localZ >= 0 && localZ <= 1)
                {
                    int heightmapX = Mathf.FloorToInt(localX * (heightmapResolution - 1));
                    int heightmapZ = Mathf.FloorToInt(localZ * (heightmapResolution - 1));
                    
                    float normalizedHeight = point.position.y / terrainSize.y;
                    heights[heightmapZ, heightmapX] = Mathf.Clamp01(normalizedHeight);
                }
            }
            
            terrainData.SetHeights(0, 0, heights);
            
            Undo.RegisterCompleteObjectUndo(terrainData, "Apply Point Cloud to Terrain");
            EditorUtility.SetDirty(terrainData);
        }
    }
}
