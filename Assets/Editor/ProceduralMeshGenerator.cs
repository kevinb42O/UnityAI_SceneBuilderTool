using UnityEngine;
using UnityEditor;
using System;
using System.Collections.Generic;
using System.Linq;

namespace UnityMCP
{
    /// <summary>
    /// Advanced procedural mesh generation system for complex geometry
    /// Supports noise-based terrain, L-Systems, building facades, and organic shapes
    /// </summary>
    public class ProceduralMeshGenerator
    {
        /// <summary>
        /// Noise type for procedural generation
        /// </summary>
        public enum NoiseType
        {
            Perlin,
            Simplex,
            Voronoi,
            Ridged,
            Billow
        }
        
        /// <summary>
        /// Settings for procedural terrain generation
        /// </summary>
        public class TerrainSettings
        {
            public int width = 100;
            public int height = 100;
            public float scale = 20f;
            public float amplitude = 10f;
            public int octaves = 4;
            public float persistence = 0.5f;
            public float lacunarity = 2f;
            public NoiseType noiseType = NoiseType.Perlin;
            public int seed = 0;
            public bool colorByHeight = true;
            public Gradient colorGradient;
            
            public TerrainSettings()
            {
                colorGradient = CreateDefaultGradient();
            }
            
            private Gradient CreateDefaultGradient()
            {
                Gradient gradient = new Gradient();
                GradientColorKey[] colorKeys = new GradientColorKey[5];
                colorKeys[0] = new GradientColorKey(new Color(0.1f, 0.3f, 0.6f), 0.0f);  // Deep water
                colorKeys[1] = new GradientColorKey(new Color(0.8f, 0.7f, 0.4f), 0.4f);  // Beach
                colorKeys[2] = new GradientColorKey(new Color(0.2f, 0.6f, 0.2f), 0.5f);  // Grass
                colorKeys[3] = new GradientColorKey(new Color(0.5f, 0.4f, 0.3f), 0.8f);  // Mountain
                colorKeys[4] = new GradientColorKey(new Color(0.9f, 0.9f, 0.9f), 1.0f);  // Snow
                
                GradientAlphaKey[] alphaKeys = new GradientAlphaKey[2];
                alphaKeys[0] = new GradientAlphaKey(1.0f, 0.0f);
                alphaKeys[1] = new GradientAlphaKey(1.0f, 1.0f);
                
                gradient.SetKeys(colorKeys, alphaKeys);
                return gradient;
            }
        }
        
        /// <summary>
        /// Generate procedural terrain mesh using noise algorithms
        /// </summary>
        public static Mesh GenerateTerrainMesh(TerrainSettings settings)
        {
            Mesh mesh = new Mesh();
            mesh.name = "ProceduralTerrain";
            
            if (settings.seed != 0)
            {
                UnityEngine.Random.InitState(settings.seed);
            }
            
            int vertexCount = (settings.width + 1) * (settings.height + 1);
            Vector3[] vertices = new Vector3[vertexCount];
            Vector2[] uvs = new Vector2[vertexCount];
            Color[] colors = new Color[vertexCount];
            
            float maxHeight = 0f;
            float minHeight = float.MaxValue;
            
            // Generate vertices with noise
            for (int z = 0; z <= settings.height; z++)
            {
                for (int x = 0; x <= settings.width; x++)
                {
                    int index = z * (settings.width + 1) + x;
                    
                    float height = GenerateNoiseHeight(x, z, settings);
                    maxHeight = Mathf.Max(maxHeight, height);
                    minHeight = Mathf.Min(minHeight, height);
                    
                    vertices[index] = new Vector3(x, height, z);
                    uvs[index] = new Vector2((float)x / settings.width, (float)z / settings.height);
                }
            }
            
            // Apply colors based on height
            if (settings.colorByHeight)
            {
                for (int i = 0; i < vertices.Length; i++)
                {
                    float normalizedHeight = Mathf.InverseLerp(minHeight, maxHeight, vertices[i].y);
                    colors[i] = settings.colorGradient.Evaluate(normalizedHeight);
                }
            }
            else
            {
                for (int i = 0; i < colors.Length; i++)
                {
                    colors[i] = Color.white;
                }
            }
            
            // Generate triangles
            int[] triangles = new int[settings.width * settings.height * 6];
            int triIndex = 0;
            
            for (int z = 0; z < settings.height; z++)
            {
                for (int x = 0; x < settings.width; x++)
                {
                    int bottomLeft = z * (settings.width + 1) + x;
                    int bottomRight = bottomLeft + 1;
                    int topLeft = bottomLeft + (settings.width + 1);
                    int topRight = topLeft + 1;
                    
                    triangles[triIndex++] = bottomLeft;
                    triangles[triIndex++] = topLeft;
                    triangles[triIndex++] = bottomRight;
                    
                    triangles[triIndex++] = bottomRight;
                    triangles[triIndex++] = topLeft;
                    triangles[triIndex++] = topRight;
                }
            }
            
            mesh.vertices = vertices;
            mesh.triangles = triangles;
            mesh.uv = uvs;
            mesh.colors = colors;
            mesh.RecalculateNormals();
            mesh.RecalculateBounds();
            
            return mesh;
        }
        
        /// <summary>
        /// Generate height value using specified noise algorithm
        /// </summary>
        private static float GenerateNoiseHeight(int x, int z, TerrainSettings settings)
        {
            float amplitude = 1f;
            float frequency = 1f;
            float noiseHeight = 0f;
            
            for (int octave = 0; octave < settings.octaves; octave++)
            {
                float sampleX = x / settings.scale * frequency;
                float sampleZ = z / settings.scale * frequency;
                
                float noiseValue = 0f;
                
                switch (settings.noiseType)
                {
                    case NoiseType.Perlin:
                        noiseValue = Mathf.PerlinNoise(sampleX, sampleZ) * 2f - 1f;
                        break;
                    case NoiseType.Simplex:
                        // Approximate simplex with Perlin (Unity doesn't have native simplex)
                        noiseValue = (Mathf.PerlinNoise(sampleX, sampleZ) + 
                                     Mathf.PerlinNoise(sampleX + 1000f, sampleZ + 1000f)) * 0.5f * 2f - 1f;
                        break;
                    case NoiseType.Voronoi:
                        noiseValue = GenerateVoronoiNoise(sampleX, sampleZ) * 2f - 1f;
                        break;
                    case NoiseType.Ridged:
                        noiseValue = 1f - Mathf.Abs(Mathf.PerlinNoise(sampleX, sampleZ) * 2f - 1f);
                        break;
                    case NoiseType.Billow:
                        noiseValue = Mathf.Abs(Mathf.PerlinNoise(sampleX, sampleZ) * 2f - 1f);
                        break;
                }
                
                noiseHeight += noiseValue * amplitude;
                
                amplitude *= settings.persistence;
                frequency *= settings.lacunarity;
            }
            
            return noiseHeight * settings.amplitude;
        }
        
        /// <summary>
        /// Generate Voronoi noise (cellular/worley noise)
        /// </summary>
        private static float GenerateVoronoiNoise(float x, float z)
        {
            int cellX = Mathf.FloorToInt(x);
            int cellZ = Mathf.FloorToInt(z);
            
            float minDist = float.MaxValue;
            
            // Check surrounding cells
            for (int offsetZ = -1; offsetZ <= 1; offsetZ++)
            {
                for (int offsetX = -1; offsetX <= 1; offsetX++)
                {
                    int neighborX = cellX + offsetX;
                    int neighborZ = cellZ + offsetZ;
                    
                    // Generate random point in cell
                    float pointX = neighborX + GetCellRandom(neighborX, neighborZ, 0);
                    float pointZ = neighborZ + GetCellRandom(neighborX, neighborZ, 1);
                    
                    float dist = Vector2.Distance(new Vector2(x, z), new Vector2(pointX, pointZ));
                    minDist = Mathf.Min(minDist, dist);
                }
            }
            
            return Mathf.Clamp01(minDist);
        }
        
        /// <summary>
        /// Get pseudo-random value for cell (deterministic)
        /// </summary>
        private static float GetCellRandom(int x, int z, int seed)
        {
            int n = x * 374761393 + z * 668265263 + seed * 1013904223;
            n = (n ^ (n >> 13)) * 1274126177;
            return ((n ^ (n >> 16)) & 0x7fffffff) / 2147483647.0f;
        }
        
        /// <summary>
        /// Settings for building facade generation
        /// </summary>
        public class BuildingFacadeSettings
        {
            public int floors = 5;
            public float floorHeight = 3f;
            public int windowsPerFloor = 4;
            public float windowWidth = 1.5f;
            public float windowHeight = 2f;
            public float wallThickness = 0.3f;
            public bool addDoor = true;
            public bool addBalconies = false;
            public Color wallColor = new Color(0.8f, 0.8f, 0.8f);
            public Color windowColor = new Color(0.2f, 0.3f, 0.4f);
        }
        
        /// <summary>
        /// Generate procedural building facade with windows and details
        /// </summary>
        public static GameObject GenerateBuildingFacade(string name, BuildingFacadeSettings settings)
        {
            GameObject building = new GameObject(name);
            
            float buildingWidth = settings.windowsPerFloor * settings.windowWidth * 1.5f;
            float buildingHeight = settings.floors * settings.floorHeight;
            
            // Create main wall
            GameObject wall = GameObject.CreatePrimitive(PrimitiveType.Cube);
            wall.name = "Wall";
            wall.transform.parent = building.transform;
            wall.transform.localScale = new Vector3(buildingWidth, buildingHeight, settings.wallThickness);
            wall.transform.localPosition = new Vector3(0, buildingHeight * 0.5f, 0);
            
            Material wallMaterial = new Material(Shader.Find("Standard"));
            wallMaterial.color = settings.wallColor;
            wall.GetComponent<MeshRenderer>().sharedMaterial = wallMaterial;
            
            // Create windows
            float windowSpacing = buildingWidth / (settings.windowsPerFloor + 1);
            
            for (int floor = 0; floor < settings.floors; floor++)
            {
                float floorY = (floor + 0.5f) * settings.floorHeight;
                
                for (int i = 0; i < settings.windowsPerFloor; i++)
                {
                    float windowX = -buildingWidth * 0.5f + windowSpacing * (i + 1);
                    
                    GameObject window = GameObject.CreatePrimitive(PrimitiveType.Cube);
                    window.name = $"Window_F{floor}_W{i}";
                    window.transform.parent = building.transform;
                    window.transform.localScale = new Vector3(settings.windowWidth, settings.windowHeight, settings.wallThickness * 0.5f);
                    window.transform.localPosition = new Vector3(windowX, floorY, settings.wallThickness * 0.3f);
                    
                    Material windowMaterial = new Material(Shader.Find("Standard"));
                    windowMaterial.color = settings.windowColor;
                    windowMaterial.SetFloat("_Metallic", 0.8f);
                    windowMaterial.SetFloat("_Glossiness", 0.9f);
                    window.GetComponent<MeshRenderer>().sharedMaterial = windowMaterial;
                }
                
                // Add balconies if enabled
                if (settings.addBalconies && floor > 0)
                {
                    GameObject balcony = GameObject.CreatePrimitive(PrimitiveType.Cube);
                    balcony.name = $"Balcony_F{floor}";
                    balcony.transform.parent = building.transform;
                    balcony.transform.localScale = new Vector3(buildingWidth * 0.8f, 0.2f, 1.5f);
                    balcony.transform.localPosition = new Vector3(0, floorY - settings.floorHeight * 0.5f, 0.8f);
                    balcony.GetComponent<MeshRenderer>().sharedMaterial = wallMaterial;
                }
            }
            
            // Add door on ground floor
            if (settings.addDoor)
            {
                GameObject door = GameObject.CreatePrimitive(PrimitiveType.Cube);
                door.name = "Door";
                door.transform.parent = building.transform;
                door.transform.localScale = new Vector3(settings.windowWidth * 0.8f, settings.floorHeight * 0.7f, settings.wallThickness * 0.5f);
                door.transform.localPosition = new Vector3(0, settings.floorHeight * 0.35f, settings.wallThickness * 0.3f);
                
                Material doorMaterial = new Material(Shader.Find("Standard"));
                doorMaterial.color = new Color(0.4f, 0.3f, 0.2f);
                door.GetComponent<MeshRenderer>().sharedMaterial = doorMaterial;
            }
            
            Undo.RegisterCreatedObjectUndo(building, "Generate Building Facade");
            EditorUtility.SetDirty(building);
            
            return building;
        }
        
        /// <summary>
        /// L-System rule for procedural generation
        /// </summary>
        public class LSystemRule
        {
            public char symbol;
            public string replacement;
            
            public LSystemRule(char sym, string repl)
            {
                symbol = sym;
                replacement = repl;
            }
        }
        
        /// <summary>
        /// Settings for L-System generation
        /// </summary>
        public class LSystemSettings
        {
            public string axiom = "F";
            public List<LSystemRule> rules = new List<LSystemRule>();
            public int iterations = 4;
            public float segmentLength = 1f;
            public float angle = 25f;
            public float radiusReduction = 0.8f;
            public float initialRadius = 0.3f;
            public Color trunkColor = new Color(0.4f, 0.3f, 0.2f);
            public Color leafColor = new Color(0.2f, 0.6f, 0.2f);
        }
        
        /// <summary>
        /// Generate L-System string
        /// </summary>
        private static string GenerateLSystemString(LSystemSettings settings)
        {
            string current = settings.axiom;
            
            for (int iteration = 0; iteration < settings.iterations; iteration++)
            {
                string next = "";
                
                foreach (char c in current)
                {
                    bool replaced = false;
                    foreach (var rule in settings.rules)
                    {
                        if (c == rule.symbol)
                        {
                            next += rule.replacement;
                            replaced = true;
                            break;
                        }
                    }
                    
                    if (!replaced)
                    {
                        next += c;
                    }
                }
                
                current = next;
            }
            
            return current;
        }
        
        /// <summary>
        /// Generate procedural tree/plant using L-System
        /// F = move forward, + = turn left, - = turn right, [ = push state, ] = pop state
        /// </summary>
        public static GameObject GenerateLSystemTree(string name, LSystemSettings settings)
        {
            GameObject tree = new GameObject(name);
            
            string lSystemString = GenerateLSystemString(settings);
            
            // Turtle graphics state
            Stack<TurtleState> stateStack = new Stack<TurtleState>();
            TurtleState currentState = new TurtleState
            {
                position = Vector3.zero,
                direction = Vector3.up,
                radius = settings.initialRadius
            };
            
            int segmentIndex = 0;
            
            foreach (char c in lSystemString)
            {
                switch (c)
                {
                    case 'F': // Move forward and draw
                        Vector3 newPosition = currentState.position + currentState.direction * settings.segmentLength;
                        CreateBranch(tree.transform, currentState.position, newPosition, currentState.radius, 
                                   settings.trunkColor, segmentIndex++);
                        currentState.position = newPosition;
                        currentState.radius *= settings.radiusReduction;
                        break;
                        
                    case '+': // Turn left
                        currentState.direction = Quaternion.Euler(0, 0, settings.angle) * currentState.direction;
                        break;
                        
                    case '-': // Turn right
                        currentState.direction = Quaternion.Euler(0, 0, -settings.angle) * currentState.direction;
                        break;
                        
                    case '[': // Push state
                        stateStack.Push(new TurtleState
                        {
                            position = currentState.position,
                            direction = currentState.direction,
                            radius = currentState.radius
                        });
                        break;
                        
                    case ']': // Pop state
                        if (stateStack.Count > 0)
                        {
                            currentState = stateStack.Pop();
                        }
                        break;
                        
                    case 'L': // Add leaf
                        CreateLeaf(tree.transform, currentState.position, settings.leafColor, segmentIndex++);
                        break;
                }
            }
            
            Undo.RegisterCreatedObjectUndo(tree, "Generate L-System Tree");
            EditorUtility.SetDirty(tree);
            
            return tree;
        }
        
        /// <summary>
        /// Turtle graphics state for L-System
        /// </summary>
        private class TurtleState
        {
            public Vector3 position;
            public Vector3 direction;
            public float radius;
        }
        
        /// <summary>
        /// Create branch segment for L-System
        /// </summary>
        private static void CreateBranch(Transform parent, Vector3 start, Vector3 end, float radius, Color color, int index)
        {
            GameObject branch = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
            branch.name = $"Branch_{index}";
            branch.transform.parent = parent;
            
            Vector3 center = (start + end) * 0.5f;
            float length = Vector3.Distance(start, end);
            
            branch.transform.position = center;
            branch.transform.up = (end - start).normalized;
            branch.transform.localScale = new Vector3(radius * 2f, length * 0.5f, radius * 2f);
            
            Material material = new Material(Shader.Find("Standard"));
            material.color = color;
            branch.GetComponent<MeshRenderer>().sharedMaterial = material;
        }
        
        /// <summary>
        /// Create leaf for L-System
        /// </summary>
        private static void CreateLeaf(Transform parent, Vector3 position, Color color, int index)
        {
            GameObject leaf = GameObject.CreatePrimitive(PrimitiveType.Sphere);
            leaf.name = $"Leaf_{index}";
            leaf.transform.parent = parent;
            leaf.transform.position = position;
            leaf.transform.localScale = Vector3.one * 0.5f;
            
            Material material = new Material(Shader.Find("Standard"));
            material.color = color;
            leaf.GetComponent<MeshRenderer>().sharedMaterial = material;
        }
        
        /// <summary>
        /// Create default tree L-System settings
        /// </summary>
        public static LSystemSettings CreateDefaultTreeSettings()
        {
            LSystemSettings settings = new LSystemSettings
            {
                axiom = "F",
                iterations = 4,
                segmentLength = 2f,
                angle = 25f,
                radiusReduction = 0.7f,
                initialRadius = 0.5f
            };
            
            // Classic tree rules
            settings.rules.Add(new LSystemRule('F', "F[+FL][-FL]F"));
            
            return settings;
        }
        
        /// <summary>
        /// Create procedural sphere with subdivisions
        /// </summary>
        public static Mesh GenerateSubdividedSphere(int subdivisions = 2, float radius = 1f)
        {
            Mesh mesh = new Mesh();
            mesh.name = "ProceduralSphere";
            
            // Start with icosahedron
            float t = (1f + Mathf.Sqrt(5f)) / 2f;
            
            List<Vector3> vertices = new List<Vector3>
            {
                new Vector3(-1, t, 0).normalized * radius,
                new Vector3(1, t, 0).normalized * radius,
                new Vector3(-1, -t, 0).normalized * radius,
                new Vector3(1, -t, 0).normalized * radius,
                new Vector3(0, -1, t).normalized * radius,
                new Vector3(0, 1, t).normalized * radius,
                new Vector3(0, -1, -t).normalized * radius,
                new Vector3(0, 1, -t).normalized * radius,
                new Vector3(t, 0, -1).normalized * radius,
                new Vector3(t, 0, 1).normalized * radius,
                new Vector3(-t, 0, -1).normalized * radius,
                new Vector3(-t, 0, 1).normalized * radius
            };
            
            List<int> triangles = new List<int>
            {
                0, 11, 5, 0, 5, 1, 0, 1, 7, 0, 7, 10, 0, 10, 11,
                1, 5, 9, 5, 11, 4, 11, 10, 2, 10, 7, 6, 7, 1, 8,
                3, 9, 4, 3, 4, 2, 3, 2, 6, 3, 6, 8, 3, 8, 9,
                4, 9, 5, 2, 4, 11, 6, 2, 10, 8, 6, 7, 9, 8, 1
            };
            
            // Subdivide
            for (int i = 0; i < subdivisions; i++)
            {
                List<int> newTriangles = new List<int>();
                Dictionary<long, int> midPointCache = new Dictionary<long, int>();
                
                for (int tri = 0; tri < triangles.Count; tri += 3)
                {
                    int v0 = triangles[tri];
                    int v1 = triangles[tri + 1];
                    int v2 = triangles[tri + 2];
                    
                    int m0 = GetMidPoint(v0, v1, vertices, midPointCache, radius);
                    int m1 = GetMidPoint(v1, v2, vertices, midPointCache, radius);
                    int m2 = GetMidPoint(v2, v0, vertices, midPointCache, radius);
                    
                    newTriangles.AddRange(new[] { v0, m0, m2 });
                    newTriangles.AddRange(new[] { v1, m1, m0 });
                    newTriangles.AddRange(new[] { v2, m2, m1 });
                    newTriangles.AddRange(new[] { m0, m1, m2 });
                }
                
                triangles = newTriangles;
            }
            
            mesh.vertices = vertices.ToArray();
            mesh.triangles = triangles.ToArray();
            mesh.RecalculateNormals();
            mesh.RecalculateBounds();
            
            return mesh;
        }
        
        /// <summary>
        /// Get or create midpoint between two vertices
        /// </summary>
        private static int GetMidPoint(int v0, int v1, List<Vector3> vertices, Dictionary<long, int> cache, float radius)
        {
            long key = ((long)Mathf.Min(v0, v1) << 32) + Mathf.Max(v0, v1);
            
            if (cache.ContainsKey(key))
            {
                return cache[key];
            }
            
            Vector3 midPoint = ((vertices[v0] + vertices[v1]) * 0.5f).normalized * radius;
            int index = vertices.Count;
            vertices.Add(midPoint);
            cache[key] = index;
            
            return index;
        }
    }
}
