using UnityEngine;
using UnityEditor;
using System;
using System.Collections.Generic;
using System.Linq;

namespace UnityMCP
{
    /// <summary>
    /// World generation system for creating complete realtime generated worlds
    /// Supports biomes, terrains, procedural placement, and natural language generation
    /// </summary>
    public class WorldGenerator
    {
        /// <summary>
        /// Create a URP-compatible material
        /// </summary>
        private static Material CreateURPMaterial()
        {
            // Try URP/Lit shader first, fallback to Standard if not available
            Shader urpShader = Shader.Find("Universal Render Pipeline/Lit");
            if (urpShader == null)
            {
                urpShader = Shader.Find("Standard");
            }
            return new Material(urpShader);
        }

        // Biome types supported
        public enum BiomeType
        {
            Forest,
            Desert,
            City,
            Medieval,
            SciFi,
            Fantasy,
            Underwater,
            Arctic,
            Jungle,
            Wasteland
        }

        // World generation settings
        public class WorldSettings
        {
            public BiomeType biome = BiomeType.Forest;
            public int worldSize = 100; // Units
            public int density = 50; // 0-100
            public bool includeTerrain = true;
            public bool includeLighting = true;
            public bool includeProps = true;
            public bool optimizeMeshes = true;
            public string seedString = "";
        }

        /// <summary>
        /// Generate a complete world based on settings
        /// </summary>
        public static Dictionary<string, object> GenerateWorld(WorldSettings settings)
        {
            try
            {
                var startTime = DateTime.Now;
                var stats = new Dictionary<string, object>();
                int objectCount = 0;

                // Set random seed if provided
                if (!string.IsNullOrEmpty(settings.seedString))
                {
                    UnityEngine.Random.InitState(settings.seedString.GetHashCode());
                }

                // Create world root
                GameObject worldRoot = new GameObject($"{settings.biome}World");
                Undo.RegisterCreatedObjectUndo(worldRoot, "Generate World");

                // Generate terrain
                if (settings.includeTerrain)
                {
                    var terrainStats = GenerateTerrain(worldRoot, settings);
                    stats["terrain"] = terrainStats;
                    objectCount += (int)terrainStats["objectCount"];
                }

                // Generate environment based on biome
                var environmentStats = GenerateEnvironment(worldRoot, settings);
                stats["environment"] = environmentStats;
                objectCount += (int)environmentStats["objectCount"];

                // Generate props/details
                if (settings.includeProps)
                {
                    var propStats = GenerateProps(worldRoot, settings);
                    stats["props"] = propStats;
                    objectCount += (int)propStats["objectCount"];
                }

                // Setup lighting
                if (settings.includeLighting)
                {
                    var lightStats = GenerateLighting(worldRoot, settings);
                    stats["lighting"] = lightStats;
                }

                // Optimize if requested
                if (settings.optimizeMeshes)
                {
                    OptimizeWorld(worldRoot);
                }

                var duration = (DateTime.Now - startTime).TotalSeconds;
                stats["success"] = true;
                stats["worldName"] = worldRoot.name;
                stats["totalObjects"] = objectCount;
                stats["generationTime"] = duration;
                stats["biome"] = settings.biome.ToString();

                return stats;
            }
            catch (Exception e)
            {
                return new Dictionary<string, object>
                {
                    { "success", false },
                    { "error", e.Message }
                };
            }
        }

        /// <summary>
        /// Generate terrain based on biome
        /// </summary>
        private static Dictionary<string, object> GenerateTerrain(GameObject parent, WorldSettings settings)
        {
            GameObject terrainGroup = new GameObject("Terrain");
            terrainGroup.transform.SetParent(parent.transform);
            Undo.RegisterCreatedObjectUndo(terrainGroup, "Generate Terrain");

            int objectCount = 0;
            int size = settings.worldSize;

            // Create ground plane
            GameObject ground = GameObject.CreatePrimitive(PrimitiveType.Plane);
            ground.name = "Ground";
            ground.transform.SetParent(terrainGroup.transform);
            ground.transform.localPosition = Vector3.zero;
            ground.transform.localScale = new Vector3(size / 10f, 1, size / 10f);
            Undo.RegisterCreatedObjectUndo(ground, "Generate Terrain");
            objectCount++;

            // Apply terrain material based on biome
            var renderer = ground.GetComponent<Renderer>();
            if (renderer != null)
            {
                Material mat = CreateURPMaterial();
                mat.name = "TerrainMaterial";

                switch (settings.biome)
                {
                    case BiomeType.Forest:
                        mat.color = new Color(0.2f, 0.5f, 0.2f);
                        break;
                    case BiomeType.Desert:
                        mat.color = new Color(0.9f, 0.8f, 0.5f);
                        break;
                    case BiomeType.City:
                        mat.color = new Color(0.4f, 0.4f, 0.4f);
                        mat.SetFloat("_Metallic", 0.2f);
                        mat.SetFloat("_Glossiness", 0.4f);
                        break;
                    case BiomeType.Arctic:
                        mat.color = Color.white;
                        mat.SetFloat("_Glossiness", 0.7f);
                        break;
                    case BiomeType.Wasteland:
                        mat.color = new Color(0.4f, 0.3f, 0.2f);
                        break;
                    default:
                        mat.color = new Color(0.3f, 0.6f, 0.3f);
                        break;
                }

                renderer.sharedMaterial = mat;
                EditorUtility.SetDirty(renderer);
            }

            // Generate hills/elevation for certain biomes
            if (settings.biome == BiomeType.Forest)
            {
                // Realistic forest terrain with gentle rolling hills
                int hillCount = Mathf.Max(4, settings.density / 20);
                for (int i = 0; i < hillCount; i++)
                {
                    GameObject hill = GameObject.CreatePrimitive(PrimitiveType.Sphere);
                    hill.name = $"Hill_{i}";
                    hill.transform.SetParent(terrainGroup.transform);
                    
                    float x = UnityEngine.Random.Range(-size / 2f, size / 2f);
                    float z = UnityEngine.Random.Range(-size / 2f, size / 2f);
                    float scale = UnityEngine.Random.Range(12f, 30f);
                    
                    // Gentler, more natural hills
                    hill.transform.localPosition = new Vector3(x, -scale / 2.5f, z);
                    hill.transform.localScale = new Vector3(scale * 1.2f, scale / 2.2f, scale);
                    
                    Undo.RegisterCreatedObjectUndo(hill, "Generate Terrain");
                    objectCount++;

                    // Apply enhanced ground material with slight color variation
                    var hillRenderer = hill.GetComponent<Renderer>();
                    if (hillRenderer != null && renderer != null)
                    {
                        Material hillMat = CreateURPMaterial();
                        // Vary the green slightly for each hill
                        hillMat.color = new Color(
                            0.18f + UnityEngine.Random.Range(-0.03f, 0.03f),
                            0.45f + UnityEngine.Random.Range(-0.05f, 0.05f),
                            0.18f + UnityEngine.Random.Range(-0.03f, 0.03f)
                        );
                        hillMat.SetFloat("_Metallic", 0.0f);
                        hillMat.SetFloat("_Glossiness", 0.2f);
                        hillRenderer.sharedMaterial = hillMat;
                        EditorUtility.SetDirty(hillRenderer);
                    }
                }
                
                // Add some rock outcroppings on hills
                int outcropCount = Mathf.Max(2, settings.density / 40);
                for (int i = 0; i < outcropCount; i++)
                {
                    GameObject outcrop = GameObject.CreatePrimitive(PrimitiveType.Cube);
                    outcrop.name = $"RockOutcrop_{i}";
                    outcrop.transform.SetParent(terrainGroup.transform);
                    
                    float x = UnityEngine.Random.Range(-size / 2f, size / 2f);
                    float z = UnityEngine.Random.Range(-size / 2f, size / 2f);
                    float height = UnityEngine.Random.Range(2f, 6f);
                    
                    outcrop.transform.localPosition = new Vector3(x, height * 0.5f, z);
                    outcrop.transform.localScale = new Vector3(
                        UnityEngine.Random.Range(3f, 8f),
                        height,
                        UnityEngine.Random.Range(3f, 8f)
                    );
                    outcrop.transform.localRotation = Quaternion.Euler(
                        UnityEngine.Random.Range(-10f, 10f),
                        UnityEngine.Random.Range(0f, 360f),
                        UnityEngine.Random.Range(-10f, 10f)
                    );
                    
                    Undo.RegisterCreatedObjectUndo(outcrop, "Generate Terrain");
                    objectCount++;
                    
                    var outcropRenderer = outcrop.GetComponent<Renderer>();
                    if (outcropRenderer != null)
                    {
                        Material rockMat = CreateURPMaterial();
                        rockMat.color = new Color(0.35f, 0.35f, 0.35f);
                        rockMat.SetFloat("_Metallic", 0.0f);
                        rockMat.SetFloat("_Glossiness", 0.15f);
                        outcropRenderer.sharedMaterial = rockMat;
                        EditorUtility.SetDirty(outcropRenderer);
                    }
                }
            }
            else if (settings.biome == BiomeType.Fantasy)
            {
                int hillCount = Mathf.Max(3, settings.density / 25);
                for (int i = 0; i < hillCount; i++)
                {
                    GameObject hill = GameObject.CreatePrimitive(PrimitiveType.Sphere);
                    hill.name = $"Hill_{i}";
                    hill.transform.SetParent(terrainGroup.transform);
                    
                    float x = UnityEngine.Random.Range(-size / 2f, size / 2f);
                    float z = UnityEngine.Random.Range(-size / 2f, size / 2f);
                    float scale = UnityEngine.Random.Range(10f, 25f);
                    
                    hill.transform.localPosition = new Vector3(x, -scale / 3f, z);
                    hill.transform.localScale = new Vector3(scale, scale / 2f, scale);
                    
                    Undo.RegisterCreatedObjectUndo(hill, "Generate Terrain");
                    objectCount++;

                    // Apply same material as ground
                    var hillRenderer = hill.GetComponent<Renderer>();
                    if (hillRenderer != null && renderer != null)
                    {
                        hillRenderer.sharedMaterial = renderer.sharedMaterial;
                        EditorUtility.SetDirty(hillRenderer);
                    }
                }
            }

            return new Dictionary<string, object>
            {
                { "objectCount", objectCount },
                { "type", "terrain" }
            };
        }

        /// <summary>
        /// Generate environment objects based on biome
        /// </summary>
        private static Dictionary<string, object> GenerateEnvironment(GameObject parent, WorldSettings settings)
        {
            GameObject envGroup = new GameObject("Environment");
            envGroup.transform.SetParent(parent.transform);
            Undo.RegisterCreatedObjectUndo(envGroup, "Generate Environment");

            int objectCount = 0;

            switch (settings.biome)
            {
                case BiomeType.Forest:
                    objectCount += GenerateForest(envGroup, settings);
                    break;
                case BiomeType.Desert:
                    objectCount += GenerateDesert(envGroup, settings);
                    break;
                case BiomeType.City:
                    objectCount += GenerateCity(envGroup, settings);
                    break;
                case BiomeType.Medieval:
                    objectCount += GenerateMedieval(envGroup, settings);
                    break;
                case BiomeType.SciFi:
                    objectCount += GenerateSciFi(envGroup, settings);
                    break;
                case BiomeType.Fantasy:
                    objectCount += GenerateFantasy(envGroup, settings);
                    break;
                case BiomeType.Arctic:
                    objectCount += GenerateArctic(envGroup, settings);
                    break;
                case BiomeType.Jungle:
                    objectCount += GenerateJungle(envGroup, settings);
                    break;
                case BiomeType.Underwater:
                    objectCount += GenerateUnderwater(envGroup, settings);
                    break;
                case BiomeType.Wasteland:
                    objectCount += GenerateWasteland(envGroup, settings);
                    break;
            }

            return new Dictionary<string, object>
            {
                { "objectCount", objectCount },
                { "type", "environment" }
            };
        }

        /// <summary>
        /// Tree species data for realistic forest generation
        /// </summary>
        private enum TreeSpecies
        {
            Oak,        // Broad, spreading canopy
            Pine,       // Tall, conical evergreen
            Birch,      // Slender, white bark
            Maple       // Medium height, rounded canopy
        }

        private class TreeData
        {
            public TreeSpecies species;
            public float trunkHeight;
            public float trunkDiameter;
            public float canopySize;
            public Color barkColor;
            public Color foliageColor;
            public float roughness;
            public bool isEvergreen;
        }

        /// <summary>
        /// Generate extremely detailed, realistic forest biome
        /// Based on real temperate deciduous/mixed forest ecosystems
        /// </summary>
        private static int GenerateForest(GameObject parent, WorldSettings settings)
        {
            int objectCount = 0;
            int size = settings.worldSize;
            int baseDensity = settings.density;

            // Create forest layers group
            GameObject canopyLayer = new GameObject("CanopyLayer");
            canopyLayer.transform.SetParent(parent.transform);
            Undo.RegisterCreatedObjectUndo(canopyLayer, "Generate Forest");

            GameObject understoryLayer = new GameObject("UnderstoryLayer");
            understoryLayer.transform.SetParent(parent.transform);
            Undo.RegisterCreatedObjectUndo(understoryLayer, "Generate Forest");

            GameObject forestFloor = new GameObject("ForestFloor");
            forestFloor.transform.SetParent(parent.transform);
            Undo.RegisterCreatedObjectUndo(forestFloor, "Generate Forest");

            // === CANOPY LAYER: Mature Trees ===
            // Realistic distribution: 60-150 trees per 100x100 units (depending on density)
            int matureTreeCount = Mathf.RoundToInt(baseDensity * 0.8f);
            
            // Create forest clusters (trees naturally group in clusters)
            int clusterCount = Mathf.Max(3, matureTreeCount / 10);
            Vector3[] clusterCenters = new Vector3[clusterCount];
            
            for (int i = 0; i < clusterCount; i++)
            {
                clusterCenters[i] = new Vector3(
                    UnityEngine.Random.Range(-size / 2f, size / 2f),
                    0,
                    UnityEngine.Random.Range(-size / 2f, size / 2f)
                );
            }

            // Generate mature trees with clustering
            for (int i = 0; i < matureTreeCount; i++)
            {
                // Choose tree species with realistic distribution
                TreeSpecies species = ChooseTreeSpecies();
                TreeData treeData = GetTreeData(species, TreeAge.Mature);
                
                // Position with clustering behavior
                Vector3 clusterCenter = clusterCenters[UnityEngine.Random.Range(0, clusterCount)];
                float clusterRadius = size / (clusterCount * 1.5f);
                float offsetX = UnityEngine.Random.Range(-clusterRadius, clusterRadius);
                float offsetZ = UnityEngine.Random.Range(-clusterRadius, clusterRadius);
                
                // Add some randomness to avoid perfect clusters
                if (UnityEngine.Random.value > 0.7f)
                {
                    offsetX = UnityEngine.Random.Range(-size / 2f, size / 2f);
                    offsetZ = UnityEngine.Random.Range(-size / 2f, size / 2f);
                }
                
                float x = clusterCenter.x + offsetX;
                float z = clusterCenter.z + offsetZ;
                
                // Ensure within bounds
                x = Mathf.Clamp(x, -size / 2f, size / 2f);
                z = Mathf.Clamp(z, -size / 2f, size / 2f);

                objectCount += CreateDetailedTree(canopyLayer, species, treeData, x, z, i);
            }

            // === UNDERSTORY LAYER: Young Trees, Bushes, Ferns ===
            int understoryCount = Mathf.RoundToInt(baseDensity * 1.5f);
            
            for (int i = 0; i < understoryCount; i++)
            {
                float x = UnityEngine.Random.Range(-size / 2f, size / 2f);
                float z = UnityEngine.Random.Range(-size / 2f, size / 2f);
                
                float rand = UnityEngine.Random.value;
                
                if (rand < 0.3f)
                {
                    // Young sapling
                    TreeSpecies species = ChooseTreeSpecies();
                    TreeData treeData = GetTreeData(species, TreeAge.Young);
                    objectCount += CreateDetailedTree(understoryLayer, species, treeData, x, z, i);
                }
                else if (rand < 0.7f)
                {
                    // Bush/shrub
                    objectCount += CreateBush(understoryLayer, x, z, i);
                }
                else
                {
                    // Fern cluster
                    objectCount += CreateFernCluster(understoryLayer, x, z, i);
                }
            }

            // === FOREST FLOOR: Fallen Logs, Mushrooms, Rocks, Leaf Litter ===
            int floorDetailCount = Mathf.RoundToInt(baseDensity * 0.8f);
            
            for (int i = 0; i < floorDetailCount; i++)
            {
                float x = UnityEngine.Random.Range(-size / 2f, size / 2f);
                float z = UnityEngine.Random.Range(-size / 2f, size / 2f);
                
                float rand = UnityEngine.Random.value;
                
                if (rand < 0.25f)
                {
                    // Fallen log
                    objectCount += CreateFallenLog(forestFloor, x, z, i);
                }
                else if (rand < 0.45f)
                {
                    // Mushroom cluster
                    objectCount += CreateMushroomCluster(forestFloor, x, z, i);
                }
                else if (rand < 0.70f)
                {
                    // Moss-covered rock
                    objectCount += CreateMossyRock(forestFloor, x, z, i);
                }
                else
                {
                    // Small ground cover (leaf litter representation)
                    objectCount += CreateGroundCover(forestFloor, x, z, i);
                }
            }

            // === SPECIAL FEATURES: Ancient Trees (1-3 per forest) ===
            int ancientTreeCount = Mathf.Max(1, matureTreeCount / 30);
            
            for (int i = 0; i < ancientTreeCount; i++)
            {
                TreeSpecies species = (TreeSpecies)UnityEngine.Random.Range(0, 2); // Oak or Pine for ancient
                TreeData treeData = GetTreeData(species, TreeAge.Ancient);
                
                float x = UnityEngine.Random.Range(-size / 3f, size / 3f);
                float z = UnityEngine.Random.Range(-size / 3f, size / 3f);
                
                objectCount += CreateDetailedTree(canopyLayer, species, treeData, x, z, 1000 + i);
            }

            return objectCount;
        }

        /// <summary>
        /// Tree age categories affecting size and appearance
        /// </summary>
        private enum TreeAge
        {
            Young,      // Saplings, small trees
            Mature,     // Full-grown trees
            Ancient     // Old-growth giants
        }

        /// <summary>
        /// Choose tree species with realistic distribution
        /// Oak: 35%, Pine: 25%, Birch: 20%, Maple: 20%
        /// </summary>
        private static TreeSpecies ChooseTreeSpecies()
        {
            float rand = UnityEngine.Random.value;
            if (rand < 0.35f) return TreeSpecies.Oak;
            if (rand < 0.60f) return TreeSpecies.Pine;
            if (rand < 0.80f) return TreeSpecies.Birch;
            return TreeSpecies.Maple;
        }

        /// <summary>
        /// Get realistic tree data based on species and age
        /// </summary>
        private static TreeData GetTreeData(TreeSpecies species, TreeAge age)
        {
            TreeData data = new TreeData { species = species };
            
            // Age multiplier
            float ageMultiplier = age == TreeAge.Young ? 0.4f : (age == TreeAge.Ancient ? 1.8f : 1.0f);
            
            switch (species)
            {
                case TreeSpecies.Oak:
                    data.trunkHeight = 8.0f * ageMultiplier;
                    data.trunkDiameter = 1.2f * ageMultiplier;
                    data.canopySize = 8.0f * ageMultiplier;
                    data.barkColor = new Color(0.35f, 0.25f, 0.15f); // Dark brown
                    data.foliageColor = new Color(0.15f, 0.45f, 0.12f); // Deep green
                    data.roughness = 0.95f;
                    data.isEvergreen = false;
                    break;
                    
                case TreeSpecies.Pine:
                    data.trunkHeight = 12.0f * ageMultiplier;
                    data.trunkDiameter = 0.8f * ageMultiplier;
                    data.canopySize = 5.0f * ageMultiplier;
                    data.barkColor = new Color(0.3f, 0.2f, 0.12f); // Reddish brown
                    data.foliageColor = new Color(0.08f, 0.35f, 0.08f); // Dark pine green
                    data.roughness = 0.9f;
                    data.isEvergreen = true;
                    break;
                    
                case TreeSpecies.Birch:
                    data.trunkHeight = 10.0f * ageMultiplier;
                    data.trunkDiameter = 0.6f * ageMultiplier;
                    data.canopySize = 6.0f * ageMultiplier;
                    data.barkColor = new Color(0.95f, 0.95f, 0.92f); // White with slight yellow
                    data.foliageColor = new Color(0.25f, 0.55f, 0.20f); // Bright green
                    data.roughness = 0.6f;
                    data.isEvergreen = false;
                    break;
                    
                case TreeSpecies.Maple:
                    data.trunkHeight = 9.0f * ageMultiplier;
                    data.trunkDiameter = 1.0f * ageMultiplier;
                    data.canopySize = 7.5f * ageMultiplier;
                    data.barkColor = new Color(0.4f, 0.3f, 0.2f); // Gray-brown
                    data.foliageColor = new Color(0.20f, 0.50f, 0.15f); // Medium green
                    data.roughness = 0.85f;
                    data.isEvergreen = false;
                    break;
            }
            
            return data;
        }

        /// <summary>
        /// Create a detailed, realistic tree with species-specific characteristics
        /// </summary>
        private static int CreateDetailedTree(GameObject parent, TreeSpecies species, TreeData data, float x, float z, int index)
        {
            int objectCount = 0;
            
            // Create tree group
            GameObject treeGroup = new GameObject($"{species}Tree_{index}");
            treeGroup.transform.SetParent(parent.transform);
            Undo.RegisterCreatedObjectUndo(treeGroup, "Generate Forest");
            
            // === TRUNK ===
            GameObject trunk = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
            trunk.name = "Trunk";
            trunk.transform.SetParent(treeGroup.transform);
            trunk.transform.localPosition = new Vector3(x, data.trunkHeight / 2f, z);
            trunk.transform.localScale = new Vector3(data.trunkDiameter, data.trunkHeight / 2f, data.trunkDiameter);
            
            // Add slight taper (trees narrow at top)
            trunk.transform.localScale = new Vector3(
                data.trunkDiameter * 1.1f,
                data.trunkHeight / 2f,
                data.trunkDiameter * 1.1f
            );
            
            Undo.RegisterCreatedObjectUndo(trunk, "Generate Forest");
            objectCount++;
            
            // Apply realistic bark material
            var trunkRenderer = trunk.GetComponent<Renderer>();
            if (trunkRenderer != null)
            {
                Material barkMat = CreateURPMaterial();
                barkMat.color = data.barkColor;
                barkMat.SetFloat("_Metallic", 0.0f);
                barkMat.SetFloat("_Glossiness", 1.0f - data.roughness); // Convert roughness to smoothness
                trunkRenderer.sharedMaterial = barkMat;
                EditorUtility.SetDirty(trunkRenderer);
            }
            
            // === CANOPY ===
            // Different canopy shapes for different species
            GameObject canopy;
            if (species == TreeSpecies.Pine)
            {
                // Conical canopy for evergreens (3 stacked spheres)
                for (int i = 0; i < 3; i++)
                {
                    canopy = GameObject.CreatePrimitive(PrimitiveType.Sphere);
                    canopy.name = $"Canopy_{i}";
                    canopy.transform.SetParent(treeGroup.transform);
                    
                    float heightOffset = data.trunkHeight + (i * data.canopySize * 0.3f);
                    float sizeScale = data.canopySize * (1.0f - i * 0.25f); // Smaller at top
                    
                    canopy.transform.localPosition = new Vector3(x, heightOffset, z);
                    canopy.transform.localScale = new Vector3(sizeScale, sizeScale * 0.8f, sizeScale);
                    
                    Undo.RegisterCreatedObjectUndo(canopy, "Generate Forest");
                    objectCount++;
                    
                    var canopyRenderer = canopy.GetComponent<Renderer>();
                    if (canopyRenderer != null)
                    {
                        Material foliageMat = CreateURPMaterial();
                        foliageMat.color = data.foliageColor;
                        foliageMat.SetFloat("_Metallic", 0.0f);
                        foliageMat.SetFloat("_Glossiness", 0.3f);
                        canopyRenderer.sharedMaterial = foliageMat;
                        EditorUtility.SetDirty(canopyRenderer);
                    }
                }
            }
            else if (species == TreeSpecies.Oak)
            {
                // Broad, spreading canopy (flattened sphere)
                canopy = GameObject.CreatePrimitive(PrimitiveType.Sphere);
                canopy.name = "Canopy";
                canopy.transform.SetParent(treeGroup.transform);
                canopy.transform.localPosition = new Vector3(x, data.trunkHeight + data.canopySize * 0.3f, z);
                canopy.transform.localScale = new Vector3(data.canopySize, data.canopySize * 0.6f, data.canopySize);
                
                Undo.RegisterCreatedObjectUndo(canopy, "Generate Forest");
                objectCount++;
                
                var canopyRenderer = canopy.GetComponent<Renderer>();
                if (canopyRenderer != null)
                {
                    Material foliageMat = CreateURPMaterial();
                    foliageMat.color = data.foliageColor;
                    foliageMat.SetFloat("_Metallic", 0.0f);
                    foliageMat.SetFloat("_Glossiness", 0.25f);
                    canopyRenderer.sharedMaterial = foliageMat;
                    EditorUtility.SetDirty(canopyRenderer);
                }
            }
            else
            {
                // Rounded canopy (Birch, Maple)
                canopy = GameObject.CreatePrimitive(PrimitiveType.Sphere);
                canopy.name = "Canopy";
                canopy.transform.SetParent(treeGroup.transform);
                canopy.transform.localPosition = new Vector3(x, data.trunkHeight + data.canopySize * 0.4f, z);
                canopy.transform.localScale = new Vector3(data.canopySize, data.canopySize * 0.85f, data.canopySize);
                
                Undo.RegisterCreatedObjectUndo(canopy, "Generate Forest");
                objectCount++;
                
                var canopyRenderer = canopy.GetComponent<Renderer>();
                if (canopyRenderer != null)
                {
                    Material foliageMat = CreateURPMaterial();
                    foliageMat.color = data.foliageColor;
                    foliageMat.SetFloat("_Metallic", 0.0f);
                    foliageMat.SetFloat("_Glossiness", 0.3f);
                    canopyRenderer.sharedMaterial = foliageMat;
                    EditorUtility.SetDirty(canopyRenderer);
                }
            }
            
            // === BRANCHES (for larger trees) ===
            if (data.trunkHeight > 7f)
            {
                int branchCount = UnityEngine.Random.Range(3, 6);
                for (int i = 0; i < branchCount; i++)
                {
                    GameObject branch = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
                    branch.name = $"Branch_{i}";
                    branch.transform.SetParent(treeGroup.transform);
                    
                    float angle = (360f / branchCount) * i + UnityEngine.Random.Range(-15f, 15f);
                    float branchHeight = data.trunkHeight * UnityEngine.Random.Range(0.6f, 0.8f);
                    float branchLength = data.trunkDiameter * 2.5f;
                    
                    Vector3 branchDir = new Vector3(
                        Mathf.Cos(angle * Mathf.Deg2Rad),
                        0,
                        Mathf.Sin(angle * Mathf.Deg2Rad)
                    );
                    
                    branch.transform.localPosition = new Vector3(
                        x + branchDir.x * branchLength * 0.5f,
                        branchHeight,
                        z + branchDir.z * branchLength * 0.5f
                    );
                    
                    branch.transform.localRotation = Quaternion.Euler(0, angle, 75);
                    branch.transform.localScale = new Vector3(
                        data.trunkDiameter * 0.3f,
                        branchLength / 2f,
                        data.trunkDiameter * 0.3f
                    );
                    
                    Undo.RegisterCreatedObjectUndo(branch, "Generate Forest");
                    objectCount++;
                    
                    var branchRenderer = branch.GetComponent<Renderer>();
                    if (branchRenderer != null)
                    {
                        Material branchMat = CreateURPMaterial();
                        branchMat.color = data.barkColor * 0.9f;
                        branchMat.SetFloat("_Metallic", 0.0f);
                        branchMat.SetFloat("_Glossiness", 1.0f - data.roughness);
                        branchRenderer.sharedMaterial = branchMat;
                        EditorUtility.SetDirty(branchRenderer);
                    }
                }
            }
            
            return objectCount;
        }

        /// <summary>
        /// Create a bush/shrub for understory
        /// </summary>
        private static int CreateBush(GameObject parent, float x, float z, int index)
        {
            GameObject bush = GameObject.CreatePrimitive(PrimitiveType.Sphere);
            bush.name = $"Bush_{index}";
            bush.transform.SetParent(parent.transform);
            
            float size = UnityEngine.Random.Range(1.2f, 2.5f);
            bush.transform.localPosition = new Vector3(x, size * 0.4f, z);
            bush.transform.localScale = new Vector3(size, size * 0.7f, size);
            
            Undo.RegisterCreatedObjectUndo(bush, "Generate Forest");
            
            var renderer = bush.GetComponent<Renderer>();
            if (renderer != null)
            {
                Material mat = CreateURPMaterial();
                mat.color = new Color(
                    UnityEngine.Random.Range(0.15f, 0.25f),
                    UnityEngine.Random.Range(0.40f, 0.55f),
                    UnityEngine.Random.Range(0.10f, 0.20f)
                );
                mat.SetFloat("_Metallic", 0.0f);
                mat.SetFloat("_Glossiness", 0.2f);
                renderer.sharedMaterial = mat;
                EditorUtility.SetDirty(renderer);
            }
            
            return 1;
        }

        /// <summary>
        /// Create a cluster of ferns (low undergrowth)
        /// </summary>
        private static int CreateFernCluster(GameObject parent, float x, float z, int index)
        {
            int count = 0;
            int fernCount = UnityEngine.Random.Range(2, 5);
            
            for (int i = 0; i < fernCount; i++)
            {
                GameObject fern = GameObject.CreatePrimitive(PrimitiveType.Cube);
                fern.name = $"Fern_{index}_{i}";
                fern.transform.SetParent(parent.transform);
                
                float offsetX = UnityEngine.Random.Range(-0.8f, 0.8f);
                float offsetZ = UnityEngine.Random.Range(-0.8f, 0.8f);
                float height = UnityEngine.Random.Range(0.6f, 1.2f);
                
                fern.transform.localPosition = new Vector3(x + offsetX, height * 0.5f, z + offsetZ);
                fern.transform.localScale = new Vector3(0.3f, height, 0.8f);
                fern.transform.localRotation = Quaternion.Euler(0, UnityEngine.Random.Range(0f, 360f), 0);
                
                Undo.RegisterCreatedObjectUndo(fern, "Generate Forest");
                count++;
                
                var renderer = fern.GetComponent<Renderer>();
                if (renderer != null)
                {
                    Material mat = CreateURPMaterial();
                    mat.color = new Color(0.18f, 0.50f, 0.15f);
                    mat.SetFloat("_Metallic", 0.0f);
                    mat.SetFloat("_Glossiness", 0.35f);
                    renderer.sharedMaterial = mat;
                    EditorUtility.SetDirty(renderer);
                }
            }
            
            return count;
        }

        /// <summary>
        /// Create a fallen log (decomposing wood)
        /// </summary>
        private static int CreateFallenLog(GameObject parent, float x, float z, int index)
        {
            GameObject log = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
            log.name = $"FallenLog_{index}";
            log.transform.SetParent(parent.transform);
            
            float length = UnityEngine.Random.Range(4f, 8f);
            float diameter = UnityEngine.Random.Range(0.6f, 1.2f);
            float angle = UnityEngine.Random.Range(0f, 360f);
            
            log.transform.localPosition = new Vector3(x, diameter * 0.4f, z);
            log.transform.localRotation = Quaternion.Euler(90, angle, 0);
            log.transform.localScale = new Vector3(diameter, length / 2f, diameter);
            
            Undo.RegisterCreatedObjectUndo(log, "Generate Forest");
            
            var renderer = log.GetComponent<Renderer>();
            if (renderer != null)
            {
                Material mat = CreateURPMaterial();
                // Weathered, decaying wood color
                mat.color = new Color(0.25f, 0.18f, 0.12f);
                mat.SetFloat("_Metallic", 0.0f);
                mat.SetFloat("_Glossiness", 0.15f);
                renderer.sharedMaterial = mat;
                EditorUtility.SetDirty(renderer);
            }
            
            return 1;
        }

        /// <summary>
        /// Create a cluster of mushrooms
        /// </summary>
        private static int CreateMushroomCluster(GameObject parent, float x, float z, int index)
        {
            int count = 0;
            int mushroomCount = UnityEngine.Random.Range(3, 7);
            
            for (int i = 0; i < mushroomCount; i++)
            {
                GameObject mushroomGroup = new GameObject($"Mushroom_{index}_{i}");
                mushroomGroup.transform.SetParent(parent.transform);
                Undo.RegisterCreatedObjectUndo(mushroomGroup, "Generate Forest");
                
                float offsetX = UnityEngine.Random.Range(-0.5f, 0.5f);
                float offsetZ = UnityEngine.Random.Range(-0.5f, 0.5f);
                float size = UnityEngine.Random.Range(0.15f, 0.35f);
                
                // Mushroom stem
                GameObject stem = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
                stem.name = "Stem";
                stem.transform.SetParent(mushroomGroup.transform);
                stem.transform.localPosition = new Vector3(x + offsetX, size * 0.5f, z + offsetZ);
                stem.transform.localScale = new Vector3(size * 0.3f, size * 0.5f, size * 0.3f);
                Undo.RegisterCreatedObjectUndo(stem, "Generate Forest");
                count++;
                
                var stemRenderer = stem.GetComponent<Renderer>();
                if (stemRenderer != null)
                {
                    Material stemMat = CreateURPMaterial();
                    stemMat.color = new Color(0.85f, 0.82f, 0.75f);
                    stemMat.SetFloat("_Metallic", 0.0f);
                    stemMat.SetFloat("_Glossiness", 0.4f);
                    stemRenderer.sharedMaterial = stemMat;
                    EditorUtility.SetDirty(stemRenderer);
                }
                
                // Mushroom cap
                GameObject cap = GameObject.CreatePrimitive(PrimitiveType.Sphere);
                cap.name = "Cap";
                cap.transform.SetParent(mushroomGroup.transform);
                cap.transform.localPosition = new Vector3(x + offsetX, size * 1.2f, z + offsetZ);
                cap.transform.localScale = new Vector3(size * 1.5f, size * 0.6f, size * 1.5f);
                Undo.RegisterCreatedObjectUndo(cap, "Generate Forest");
                count++;
                
                var capRenderer = cap.GetComponent<Renderer>();
                if (capRenderer != null)
                {
                    Material capMat = CreateURPMaterial();
                    // Random mushroom colors (brown, red, yellow variations)
                    float colorChoice = UnityEngine.Random.value;
                    if (colorChoice < 0.6f)
                        capMat.color = new Color(0.5f, 0.3f, 0.2f); // Brown
                    else if (colorChoice < 0.85f)
                        capMat.color = new Color(0.7f, 0.2f, 0.15f); // Red
                    else
                        capMat.color = new Color(0.8f, 0.7f, 0.3f); // Yellow
                        
                    capMat.SetFloat("_Metallic", 0.0f);
                    capMat.SetFloat("_Glossiness", 0.5f);
                    capRenderer.sharedMaterial = capMat;
                    EditorUtility.SetDirty(capRenderer);
                }
            }
            
            return count;
        }

        /// <summary>
        /// Create a moss-covered rock
        /// </summary>
        private static int CreateMossyRock(GameObject parent, float x, float z, int index)
        {
            GameObject rock = GameObject.CreatePrimitive(PrimitiveType.Sphere);
            rock.name = $"MossyRock_{index}";
            rock.transform.SetParent(parent.transform);
            
            float size = UnityEngine.Random.Range(0.8f, 2.0f);
            rock.transform.localPosition = new Vector3(x, size * 0.35f, z);
            rock.transform.localScale = new Vector3(size, size * 0.6f, size * 0.9f);
            rock.transform.localRotation = Quaternion.Euler(
                UnityEngine.Random.Range(-15f, 15f),
                UnityEngine.Random.Range(0f, 360f),
                UnityEngine.Random.Range(-15f, 15f)
            );
            
            Undo.RegisterCreatedObjectUndo(rock, "Generate Forest");
            
            var renderer = rock.GetComponent<Renderer>();
            if (renderer != null)
            {
                Material mat = CreateURPMaterial();
                // Gray rock with greenish moss tint
                mat.color = new Color(0.25f, 0.30f, 0.22f);
                mat.SetFloat("_Metallic", 0.0f);
                mat.SetFloat("_Glossiness", 0.25f);
                renderer.sharedMaterial = mat;
                EditorUtility.SetDirty(renderer);
            }
            
            return 1;
        }

        /// <summary>
        /// Create ground cover (represents leaf litter, small plants)
        /// </summary>
        private static int CreateGroundCover(GameObject parent, float x, float z, int index)
        {
            GameObject cover = GameObject.CreatePrimitive(PrimitiveType.Cube);
            cover.name = $"GroundCover_{index}";
            cover.transform.SetParent(parent.transform);
            
            float size = UnityEngine.Random.Range(1.0f, 2.0f);
            cover.transform.localPosition = new Vector3(x, 0.05f, z);
            cover.transform.localScale = new Vector3(size, 0.1f, size);
            cover.transform.localRotation = Quaternion.Euler(0, UnityEngine.Random.Range(0f, 360f), 0);
            
            Undo.RegisterCreatedObjectUndo(cover, "Generate Forest");
            
            var renderer = cover.GetComponent<Renderer>();
            if (renderer != null)
            {
                Material mat = CreateURPMaterial();
                // Brown leaf litter color
                mat.color = new Color(0.35f, 0.25f, 0.15f);
                mat.SetFloat("_Metallic", 0.0f);
                mat.SetFloat("_Glossiness", 0.1f);
                renderer.sharedMaterial = mat;
                EditorUtility.SetDirty(renderer);
            }
            
            return 1;
        }

        /// <summary>
        /// Generate desert biome
        /// </summary>
        private static int GenerateDesert(GameObject parent, WorldSettings settings)
        {
            int objectCount = 0;
            int size = settings.worldSize;
            int duneCount = settings.density / 5;

            // Create sand dunes
            for (int i = 0; i < duneCount; i++)
            {
                GameObject dune = GameObject.CreatePrimitive(PrimitiveType.Sphere);
                dune.name = $"Dune_{i}";
                dune.transform.SetParent(parent.transform);
                
                float x = UnityEngine.Random.Range(-size / 2f, size / 2f);
                float z = UnityEngine.Random.Range(-size / 2f, size / 2f);
                float scale = UnityEngine.Random.Range(5f, 15f);
                
                dune.transform.localPosition = new Vector3(x, -scale / 4f, z);
                dune.transform.localScale = new Vector3(scale, scale / 3f, scale);
                Undo.RegisterCreatedObjectUndo(dune, "Generate Desert");
                objectCount++;

                // Apply sand material
                var renderer = dune.GetComponent<Renderer>();
                if (renderer != null)
                {
                    Material mat = CreateURPMaterial();
                    mat.color = new Color(0.95f, 0.85f, 0.6f);
                    mat.SetFloat("_Glossiness", 0.2f);
                    renderer.sharedMaterial = mat;
                    EditorUtility.SetDirty(renderer);
                }
            }

            // Create cacti
            int cactiCount = settings.density / 10;
            for (int i = 0; i < cactiCount; i++)
            {
                float x = UnityEngine.Random.Range(-size / 2f, size / 2f);
                float z = UnityEngine.Random.Range(-size / 2f, size / 2f);

                GameObject cactus = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
                cactus.name = $"Cactus_{i}";
                cactus.transform.SetParent(parent.transform);
                cactus.transform.localPosition = new Vector3(x, 1.5f, z);
                cactus.transform.localScale = new Vector3(0.4f, 1.5f, 0.4f);
                Undo.RegisterCreatedObjectUndo(cactus, "Generate Desert");
                objectCount++;

                // Apply cactus material
                var renderer = cactus.GetComponent<Renderer>();
                if (renderer != null)
                {
                    Material mat = CreateURPMaterial();
                    mat.color = new Color(0.2f, 0.5f, 0.2f);
                    renderer.sharedMaterial = mat;
                    EditorUtility.SetDirty(renderer);
                }
            }

            return objectCount;
        }

        /// <summary>
        /// Generate city biome
        /// </summary>
        private static int GenerateCity(GameObject parent, WorldSettings settings)
        {
            int objectCount = 0;
            int size = settings.worldSize;
            int buildingCount = settings.density / 2;

            // Create buildings in a grid pattern
            int gridSize = (int)Mathf.Sqrt(buildingCount);
            float spacing = size / (float)(gridSize + 1);

            for (int x = 0; x < gridSize; x++)
            {
                for (int z = 0; z < gridSize; z++)
                {
                    float posX = (x - gridSize / 2f) * spacing;
                    float posZ = (z - gridSize / 2f) * spacing;
                    float height = UnityEngine.Random.Range(10f, 40f);

                    GameObject building = GameObject.CreatePrimitive(PrimitiveType.Cube);
                    building.name = $"Building_{x}_{z}";
                    building.transform.SetParent(parent.transform);
                    building.transform.localPosition = new Vector3(posX, height / 2f, posZ);
                    building.transform.localScale = new Vector3(
                        UnityEngine.Random.Range(5f, 10f),
                        height,
                        UnityEngine.Random.Range(5f, 10f)
                    );
                    Undo.RegisterCreatedObjectUndo(building, "Generate City");
                    objectCount++;

                    // Apply building material
                    var renderer = building.GetComponent<Renderer>();
                    if (renderer != null)
                    {
                        Material mat = CreateURPMaterial();
                        mat.color = new Color(
                            UnityEngine.Random.Range(0.5f, 0.8f),
                            UnityEngine.Random.Range(0.5f, 0.8f),
                            UnityEngine.Random.Range(0.5f, 0.8f)
                        );
                        mat.SetFloat("_Metallic", 0.3f);
                        mat.SetFloat("_Glossiness", 0.6f);
                        renderer.sharedMaterial = mat;
                        EditorUtility.SetDirty(renderer);
                    }
                }
            }

            return objectCount;
        }

        /// <summary>
        /// Generate medieval biome
        /// </summary>
        private static int GenerateMedieval(GameObject parent, WorldSettings settings)
        {
            int objectCount = 0;
            int size = settings.worldSize;

            // Create castle in center
            GameObject castle = new GameObject("Castle");
            castle.transform.SetParent(parent.transform);
            Undo.RegisterCreatedObjectUndo(castle, "Generate Medieval");

            // Castle walls
            for (int i = 0; i < 4; i++)
            {
                GameObject wall = GameObject.CreatePrimitive(PrimitiveType.Cube);
                wall.name = $"CastleWall_{i}";
                wall.transform.SetParent(castle.transform);
                
                float angle = i * 90f;
                float distance = 15f;
                float x = Mathf.Cos(angle * Mathf.Deg2Rad) * distance;
                float z = Mathf.Sin(angle * Mathf.Deg2Rad) * distance;
                
                wall.transform.localPosition = new Vector3(x, 5f, z);
                wall.transform.localRotation = Quaternion.Euler(0, angle, 0);
                wall.transform.localScale = new Vector3(20f, 10f, 2f);
                Undo.RegisterCreatedObjectUndo(wall, "Generate Medieval");
                objectCount++;

                // Apply stone material
                var renderer = wall.GetComponent<Renderer>();
                if (renderer != null)
                {
                    Material mat = CreateURPMaterial();
                    mat.color = new Color(0.5f, 0.5f, 0.5f);
                    mat.SetFloat("_Glossiness", 0.1f);
                    renderer.sharedMaterial = mat;
                    EditorUtility.SetDirty(renderer);
                }
            }

            // Castle towers
            for (int i = 0; i < 4; i++)
            {
                GameObject tower = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
                tower.name = $"CastleTower_{i}";
                tower.transform.SetParent(castle.transform);
                
                float angle = i * 90f;
                float distance = 15f;
                float x = Mathf.Cos(angle * Mathf.Deg2Rad) * distance;
                float z = Mathf.Sin(angle * Mathf.Deg2Rad) * distance;
                
                tower.transform.localPosition = new Vector3(x, 10f, z);
                tower.transform.localScale = new Vector3(3f, 10f, 3f);
                Undo.RegisterCreatedObjectUndo(tower, "Generate Medieval");
                objectCount++;

                // Apply stone material
                var renderer = tower.GetComponent<Renderer>();
                if (renderer != null)
                {
                    Material mat = CreateURPMaterial();
                    mat.color = new Color(0.4f, 0.4f, 0.4f);
                    mat.SetFloat("_Glossiness", 0.1f);
                    renderer.sharedMaterial = mat;
                    EditorUtility.SetDirty(renderer);
                }
            }

            // Houses around castle
            int houseCount = settings.density / 3;
            for (int i = 0; i < houseCount; i++)
            {
                float angle = UnityEngine.Random.Range(0f, 360f);
                float distance = UnityEngine.Random.Range(25f, size / 2f - 10f);
                float x = Mathf.Cos(angle * Mathf.Deg2Rad) * distance;
                float z = Mathf.Sin(angle * Mathf.Deg2Rad) * distance;

                GameObject house = GameObject.CreatePrimitive(PrimitiveType.Cube);
                house.name = $"House_{i}";
                house.transform.SetParent(parent.transform);
                house.transform.localPosition = new Vector3(x, 2.5f, z);
                house.transform.localScale = new Vector3(4f, 5f, 4f);
                Undo.RegisterCreatedObjectUndo(house, "Generate Medieval");
                objectCount++;

                // Apply wood material
                var renderer = house.GetComponent<Renderer>();
                if (renderer != null)
                {
                    Material mat = CreateURPMaterial();
                    mat.color = new Color(0.4f, 0.25f, 0.1f);
                    renderer.sharedMaterial = mat;
                    EditorUtility.SetDirty(renderer);
                }

                // Add roof
                GameObject roof = GameObject.CreatePrimitive(PrimitiveType.Cube);
                roof.name = $"House_{i}_Roof";
                roof.transform.SetParent(parent.transform);
                roof.transform.localPosition = new Vector3(x, 5.5f, z);
                roof.transform.localScale = new Vector3(5f, 1f, 5f);
                Undo.RegisterCreatedObjectUndo(roof, "Generate Medieval");
                objectCount++;

                // Apply red roof material
                var roofRenderer = roof.GetComponent<Renderer>();
                if (roofRenderer != null)
                {
                    Material mat = CreateURPMaterial();
                    mat.color = new Color(0.6f, 0.2f, 0.1f);
                    roofRenderer.sharedMaterial = mat;
                    EditorUtility.SetDirty(roofRenderer);
                }
            }

            return objectCount;
        }

        /// <summary>
        /// Generate sci-fi biome
        /// </summary>
        private static int GenerateSciFi(GameObject parent, WorldSettings settings)
        {
            int objectCount = 0;
            int size = settings.worldSize;
            int structureCount = settings.density / 2;

            for (int i = 0; i < structureCount; i++)
            {
                float x = UnityEngine.Random.Range(-size / 2f, size / 2f);
                float z = UnityEngine.Random.Range(-size / 2f, size / 2f);

                // Sci-fi structure
                GameObject structure = GameObject.CreatePrimitive(PrimitiveType.Cube);
                structure.name = $"SciFiStructure_{i}";
                structure.transform.SetParent(parent.transform);
                structure.transform.localPosition = new Vector3(x, 5f, z);
                structure.transform.localScale = new Vector3(6f, 10f, 6f);
                structure.transform.localRotation = Quaternion.Euler(0, UnityEngine.Random.Range(0f, 360f), 0);
                Undo.RegisterCreatedObjectUndo(structure, "Generate SciFi");
                objectCount++;

                // Apply metallic material
                var renderer = structure.GetComponent<Renderer>();
                if (renderer != null)
                {
                    Material mat = CreateURPMaterial();
                    mat.color = new Color(0.7f, 0.7f, 0.8f);
                    mat.SetFloat("_Metallic", 0.8f);
                    mat.SetFloat("_Glossiness", 0.9f);
                    renderer.sharedMaterial = mat;
                    EditorUtility.SetDirty(renderer);
                }

                // Add glowing element
                if (UnityEngine.Random.value > 0.5f)
                {
                    GameObject glow = GameObject.CreatePrimitive(PrimitiveType.Sphere);
                    glow.name = $"SciFiGlow_{i}";
                    glow.transform.SetParent(parent.transform);
                    glow.transform.localPosition = new Vector3(x, 10.5f, z);
                    glow.transform.localScale = new Vector3(1.5f, 1.5f, 1.5f);
                    Undo.RegisterCreatedObjectUndo(glow, "Generate SciFi");
                    objectCount++;

                    // Apply emissive material
                    var glowRenderer = glow.GetComponent<Renderer>();
                    if (glowRenderer != null)
                    {
                        Material glowMat = CreateURPMaterial();
                        glowMat.color = new Color(0f, 0.5f, 1f);
                        glowMat.SetColor("_EmissionColor", new Color(0f, 1f, 2f));
                        glowMat.EnableKeyword("_EMISSION");
                        glowRenderer.sharedMaterial = glowMat;
                        EditorUtility.SetDirty(glowRenderer);
                    }
                }
            }

            return objectCount;
        }

        /// <summary>
        /// Generate fantasy biome
        /// </summary>
        private static int GenerateFantasy(GameObject parent, WorldSettings settings)
        {
            int objectCount = 0;
            int size = settings.worldSize;

            // Generate magical crystals
            int crystalCount = settings.density / 4;
            for (int i = 0; i < crystalCount; i++)
            {
                float x = UnityEngine.Random.Range(-size / 2f, size / 2f);
                float z = UnityEngine.Random.Range(-size / 2f, size / 2f);

                GameObject crystal = GameObject.CreatePrimitive(PrimitiveType.Cube);
                crystal.name = $"MagicCrystal_{i}";
                crystal.transform.SetParent(parent.transform);
                crystal.transform.localPosition = new Vector3(x, 3f, z);
                crystal.transform.localScale = new Vector3(1f, 6f, 1f);
                crystal.transform.localRotation = Quaternion.Euler(
                    UnityEngine.Random.Range(-10f, 10f),
                    UnityEngine.Random.Range(0f, 360f),
                    UnityEngine.Random.Range(-10f, 10f)
                );
                Undo.RegisterCreatedObjectUndo(crystal, "Generate Fantasy");
                objectCount++;

                // Apply glowing crystal material
                var renderer = crystal.GetComponent<Renderer>();
                if (renderer != null)
                {
                    Material mat = CreateURPMaterial();
                    Color[] colors = {
                        new Color(1f, 0f, 1f), // Magenta
                        new Color(0f, 1f, 1f), // Cyan
                        new Color(1f, 1f, 0f)  // Yellow
                    };
                    Color color = colors[UnityEngine.Random.Range(0, colors.Length)];
                    mat.color = color;
                    mat.SetColor("_EmissionColor", color * 2f);
                    mat.SetFloat("_Glossiness", 0.9f);
                    mat.EnableKeyword("_EMISSION");
                    renderer.sharedMaterial = mat;
                    EditorUtility.SetDirty(renderer);
                }
            }

            // Generate magical trees (similar to forest but with special colors)
            int treeCount = settings.density / 3;
            for (int i = 0; i < treeCount; i++)
            {
                float x = UnityEngine.Random.Range(-size / 2f, size / 2f);
                float z = UnityEngine.Random.Range(-size / 2f, size / 2f);

                // Tree trunk
                GameObject trunk = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
                trunk.name = $"MagicTree_{i}_Trunk";
                trunk.transform.SetParent(parent.transform);
                trunk.transform.localPosition = new Vector3(x, 3f, z);
                trunk.transform.localScale = new Vector3(0.6f, 3f, 0.6f);
                Undo.RegisterCreatedObjectUndo(trunk, "Generate Fantasy");
                objectCount++;

                // Apply purple trunk material
                var trunkRenderer = trunk.GetComponent<Renderer>();
                if (trunkRenderer != null)
                {
                    Material trunkMat = CreateURPMaterial();
                    trunkMat.color = new Color(0.4f, 0.1f, 0.5f);
                    trunkRenderer.sharedMaterial = trunkMat;
                    EditorUtility.SetDirty(trunkRenderer);
                }

                // Tree foliage
                GameObject foliage = GameObject.CreatePrimitive(PrimitiveType.Sphere);
                foliage.name = $"MagicTree_{i}_Foliage";
                foliage.transform.SetParent(parent.transform);
                foliage.transform.localPosition = new Vector3(x, 7.5f, z);
                foliage.transform.localScale = new Vector3(4.5f, 4.5f, 4.5f);
                Undo.RegisterCreatedObjectUndo(foliage, "Generate Fantasy");
                objectCount++;

                // Apply glowing foliage material
                var foliageRenderer = foliage.GetComponent<Renderer>();
                if (foliageRenderer != null)
                {
                    Material foliageMat = CreateURPMaterial();
                    foliageMat.color = new Color(0.5f, 0.1f, 0.8f);
                    foliageMat.SetColor("_EmissionColor", new Color(0.3f, 0.05f, 0.4f));
                    foliageMat.EnableKeyword("_EMISSION");
                    foliageRenderer.sharedMaterial = foliageMat;
                    EditorUtility.SetDirty(foliageRenderer);
                }
            }

            return objectCount;
        }

        /// <summary>
        /// Generate arctic biome
        /// </summary>
        private static int GenerateArctic(GameObject parent, WorldSettings settings)
        {
            int objectCount = 0;
            int size = settings.worldSize;

            // Create ice formations
            int iceCount = settings.density / 3;
            for (int i = 0; i < iceCount; i++)
            {
                GameObject ice = GameObject.CreatePrimitive(PrimitiveType.Cube);
                ice.name = $"IceFormation_{i}";
                ice.transform.SetParent(parent.transform);
                
                float x = UnityEngine.Random.Range(-size / 2f, size / 2f);
                float z = UnityEngine.Random.Range(-size / 2f, size / 2f);
                float height = UnityEngine.Random.Range(2f, 8f);
                
                ice.transform.localPosition = new Vector3(x, height / 2f, z);
                ice.transform.localScale = new Vector3(
                    UnityEngine.Random.Range(2f, 5f),
                    height,
                    UnityEngine.Random.Range(2f, 5f)
                );
                ice.transform.localRotation = Quaternion.Euler(
                    UnityEngine.Random.Range(-15f, 15f),
                    UnityEngine.Random.Range(0f, 360f),
                    UnityEngine.Random.Range(-15f, 15f)
                );
                Undo.RegisterCreatedObjectUndo(ice, "Generate Arctic");
                objectCount++;

                // Apply ice material
                var renderer = ice.GetComponent<Renderer>();
                if (renderer != null)
                {
                    Material mat = CreateURPMaterial();
                    mat.color = new Color(0.8f, 0.9f, 1f);
                    mat.SetFloat("_Metallic", 0.1f);
                    mat.SetFloat("_Glossiness", 0.8f);
                    renderer.sharedMaterial = mat;
                    EditorUtility.SetDirty(renderer);
                }
            }

            return objectCount;
        }

        /// <summary>
        /// Generate jungle biome
        /// </summary>
        private static int GenerateJungle(GameObject parent, WorldSettings settings)
        {
            int objectCount = 0;
            int size = settings.worldSize;
            int vegetationCount = settings.density * 2; // Dense vegetation

            for (int i = 0; i < vegetationCount; i++)
            {
                float x = UnityEngine.Random.Range(-size / 2f, size / 2f);
                float z = UnityEngine.Random.Range(-size / 2f, size / 2f);

                // Varied plant types
                bool isTall = UnityEngine.Random.value > 0.3f;

                if (isTall)
                {
                    // Tall tree
                    GameObject trunk = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
                    trunk.name = $"JungleTree_{i}";
                    trunk.transform.SetParent(parent.transform);
                    trunk.transform.localPosition = new Vector3(x, 4f, z);
                    trunk.transform.localScale = new Vector3(0.4f, 4f, 0.4f);
                    Undo.RegisterCreatedObjectUndo(trunk, "Generate Jungle");
                    objectCount++;

                    var trunkRenderer = trunk.GetComponent<Renderer>();
                    if (trunkRenderer != null)
                    {
                        Material mat = CreateURPMaterial();
                        mat.color = new Color(0.3f, 0.2f, 0.1f);
                        trunkRenderer.sharedMaterial = mat;
                        EditorUtility.SetDirty(trunkRenderer);
                    }
                }
                else
                {
                    // Ground vegetation
                    GameObject plant = GameObject.CreatePrimitive(PrimitiveType.Sphere);
                    plant.name = $"JunglePlant_{i}";
                    plant.transform.SetParent(parent.transform);
                    plant.transform.localPosition = new Vector3(x, 0.5f, z);
                    plant.transform.localScale = new Vector3(1.5f, 1f, 1.5f);
                    Undo.RegisterCreatedObjectUndo(plant, "Generate Jungle");
                    objectCount++;

                    var renderer = plant.GetComponent<Renderer>();
                    if (renderer != null)
                    {
                        Material mat = CreateURPMaterial();
                        mat.color = new Color(
                            UnityEngine.Random.Range(0.1f, 0.3f),
                            UnityEngine.Random.Range(0.4f, 0.6f),
                            UnityEngine.Random.Range(0.1f, 0.2f)
                        );
                        renderer.sharedMaterial = mat;
                        EditorUtility.SetDirty(renderer);
                    }
                }
            }

            return objectCount;
        }

        /// <summary>
        /// Generate underwater biome
        /// </summary>
        private static int GenerateUnderwater(GameObject parent, WorldSettings settings)
        {
            int objectCount = 0;
            int size = settings.worldSize;

            // Create coral formations
            int coralCount = settings.density;
            for (int i = 0; i < coralCount; i++)
            {
                float x = UnityEngine.Random.Range(-size / 2f, size / 2f);
                float z = UnityEngine.Random.Range(-size / 2f, size / 2f);

                GameObject coral = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
                coral.name = $"Coral_{i}";
                coral.transform.SetParent(parent.transform);
                coral.transform.localPosition = new Vector3(x, 1.5f, z);
                coral.transform.localScale = new Vector3(0.8f, 1.5f, 0.8f);
                coral.transform.localRotation = Quaternion.Euler(
                    UnityEngine.Random.Range(-20f, 20f),
                    UnityEngine.Random.Range(0f, 360f),
                    UnityEngine.Random.Range(-20f, 20f)
                );
                Undo.RegisterCreatedObjectUndo(coral, "Generate Underwater");
                objectCount++;

                // Apply colorful coral material
                var renderer = coral.GetComponent<Renderer>();
                if (renderer != null)
                {
                    Material mat = CreateURPMaterial();
                    Color[] colors = {
                        new Color(1f, 0.3f, 0.3f), // Red
                        new Color(1f, 0.6f, 0f),   // Orange
                        new Color(1f, 1f, 0.3f),   // Yellow
                        new Color(1f, 0.3f, 1f)    // Pink
                    };
                    mat.color = colors[UnityEngine.Random.Range(0, colors.Length)];
                    mat.SetFloat("_Glossiness", 0.5f);
                    renderer.sharedMaterial = mat;
                    EditorUtility.SetDirty(renderer);
                }
            }

            return objectCount;
        }

        /// <summary>
        /// Generate wasteland biome
        /// </summary>
        private static int GenerateWasteland(GameObject parent, WorldSettings settings)
        {
            int objectCount = 0;
            int size = settings.worldSize;

            // Create debris and ruins
            int debrisCount = settings.density / 2;
            for (int i = 0; i < debrisCount; i++)
            {
                float x = UnityEngine.Random.Range(-size / 2f, size / 2f);
                float z = UnityEngine.Random.Range(-size / 2f, size / 2f);

                GameObject debris = GameObject.CreatePrimitive(PrimitiveType.Cube);
                debris.name = $"Debris_{i}";
                debris.transform.SetParent(parent.transform);
                debris.transform.localPosition = new Vector3(x, 1f, z);
                debris.transform.localScale = new Vector3(
                    UnityEngine.Random.Range(2f, 6f),
                    UnityEngine.Random.Range(2f, 5f),
                    UnityEngine.Random.Range(2f, 6f)
                );
                debris.transform.localRotation = Quaternion.Euler(
                    UnityEngine.Random.Range(-30f, 30f),
                    UnityEngine.Random.Range(0f, 360f),
                    UnityEngine.Random.Range(-30f, 30f)
                );
                Undo.RegisterCreatedObjectUndo(debris, "Generate Wasteland");
                objectCount++;

                // Apply rusty/damaged material
                var renderer = debris.GetComponent<Renderer>();
                if (renderer != null)
                {
                    Material mat = CreateURPMaterial();
                    mat.color = new Color(0.4f, 0.3f, 0.2f);
                    mat.SetFloat("_Metallic", 0.5f);
                    mat.SetFloat("_Glossiness", 0.2f);
                    renderer.sharedMaterial = mat;
                    EditorUtility.SetDirty(renderer);
                }
            }

            return objectCount;
        }

        /// <summary>
        /// Generate props/details for the world
        /// </summary>
        private static Dictionary<string, object> GenerateProps(GameObject parent, WorldSettings settings)
        {
            GameObject propsGroup = new GameObject("Props");
            propsGroup.transform.SetParent(parent.transform);
            Undo.RegisterCreatedObjectUndo(propsGroup, "Generate Props");

            int objectCount = 0;
            int size = settings.worldSize;
            int propCount = settings.density / 5;

            // Add random rocks/props
            for (int i = 0; i < propCount; i++)
            {
                GameObject prop = GameObject.CreatePrimitive(PrimitiveType.Sphere);
                prop.name = $"Rock_{i}";
                prop.transform.SetParent(propsGroup.transform);
                
                float x = UnityEngine.Random.Range(-size / 2f, size / 2f);
                float z = UnityEngine.Random.Range(-size / 2f, size / 2f);
                float scale = UnityEngine.Random.Range(0.5f, 2f);
                
                prop.transform.localPosition = new Vector3(x, scale / 2f, z);
                prop.transform.localScale = new Vector3(scale, scale * 0.7f, scale);
                Undo.RegisterCreatedObjectUndo(prop, "Generate Props");
                objectCount++;

                // Apply rock material
                var renderer = prop.GetComponent<Renderer>();
                if (renderer != null)
                {
                    Material mat = CreateURPMaterial();
                    mat.color = new Color(0.3f, 0.3f, 0.3f);
                    mat.SetFloat("_Glossiness", 0.1f);
                    renderer.sharedMaterial = mat;
                    EditorUtility.SetDirty(renderer);
                }
            }

            return new Dictionary<string, object>
            {
                { "objectCount", objectCount },
                { "type", "props" }
            };
        }

        /// <summary>
        /// Setup lighting for the world
        /// </summary>
        private static Dictionary<string, object> GenerateLighting(GameObject parent, WorldSettings settings)
        {
            // Find or create directional light
            Light[] lights = GameObject.FindObjectsByType<Light>(FindObjectsSortMode.None);
            Light dirLight = null;
            foreach (Light light in lights)
            {
                if (light.type == LightType.Directional)
                {
                    dirLight = light;
                    break;
                }
            }

            if (dirLight == null)
            {
                GameObject lightObj = new GameObject("Directional Light");
                lightObj.transform.SetParent(parent.transform);
                dirLight = lightObj.AddComponent<Light>();
                dirLight.type = LightType.Directional;
                Undo.RegisterCreatedObjectUndo(lightObj, "Generate Lighting");
            }

            // Configure lighting based on biome
            switch (settings.biome)
            {
                case BiomeType.Desert:
                    dirLight.color = new Color(1f, 0.95f, 0.8f);
                    dirLight.intensity = 1.5f;
                    dirLight.transform.rotation = Quaternion.Euler(50, 30, 0);
                    RenderSettings.ambientLight = new Color(0.7f, 0.6f, 0.5f);
                    break;

                case BiomeType.Forest:
                    // Dappled sunlight filtering through canopy
                    dirLight.color = new Color(1f, 0.95f, 0.85f); // Warm sunlight
                    dirLight.intensity = 0.9f; // Slightly dimmed by canopy
                    dirLight.transform.rotation = Quaternion.Euler(55, 45, 0); // Late morning angle
                    
                    // Rich, natural forest ambient light (greenish from foliage)
                    RenderSettings.ambientLight = new Color(0.25f, 0.35f, 0.25f);
                    
                    // Subtle fog for atmospheric depth
                    RenderSettings.fog = true;
                    RenderSettings.fogColor = new Color(0.7f, 0.75f, 0.7f);
                    RenderSettings.fogMode = FogMode.Exponential;
                    RenderSettings.fogDensity = 0.008f; // Very subtle
                    break;

                case BiomeType.Arctic:
                    dirLight.color = new Color(0.9f, 0.95f, 1f);
                    dirLight.intensity = 1.2f;
                    dirLight.transform.rotation = Quaternion.Euler(30, 0, 0);
                    RenderSettings.ambientLight = new Color(0.6f, 0.65f, 0.7f);
                    break;

                case BiomeType.SciFi:
                    dirLight.color = new Color(0.8f, 0.9f, 1f);
                    dirLight.intensity = 0.8f;
                    dirLight.transform.rotation = Quaternion.Euler(45, 45, 0);
                    RenderSettings.ambientLight = new Color(0.2f, 0.2f, 0.3f);
                    break;

                case BiomeType.Fantasy:
                    dirLight.color = new Color(1f, 0.9f, 1f);
                    dirLight.intensity = 1f;
                    dirLight.transform.rotation = Quaternion.Euler(40, 60, 0);
                    RenderSettings.ambientLight = new Color(0.4f, 0.3f, 0.5f);
                    break;

                case BiomeType.Underwater:
                    dirLight.color = new Color(0.5f, 0.7f, 1f);
                    dirLight.intensity = 0.6f;
                    dirLight.transform.rotation = Quaternion.Euler(70, 0, 0);
                    RenderSettings.ambientLight = new Color(0.1f, 0.2f, 0.3f);
                    RenderSettings.fogColor = new Color(0.1f, 0.3f, 0.5f);
                    RenderSettings.fog = true;
                    RenderSettings.fogDensity = 0.05f;
                    break;

                default:
                    dirLight.color = Color.white;
                    dirLight.intensity = 1f;
                    dirLight.transform.rotation = Quaternion.Euler(50, 330, 0);
                    RenderSettings.ambientLight = new Color(0.4f, 0.4f, 0.4f);
                    break;
            }

            EditorUtility.SetDirty(dirLight);

            return new Dictionary<string, object>
            {
                { "configured", true },
                { "type", "lighting" }
            };
        }

        /// <summary>
        /// Optimize the generated world by combining meshes
        /// </summary>
        private static void OptimizeWorld(GameObject worldRoot)
        {
            // Find all groups with multiple children
            Transform[] allTransforms = worldRoot.GetComponentsInChildren<Transform>();
            
            foreach (Transform t in allTransforms)
            {
                // Skip if it has no children or too few children
                if (t.childCount < 5) continue;

                // Try to combine meshes in this group
                try
                {
                    CombineMeshes(t.gameObject);
                }
                catch
                {
                    // Skip groups that can't be combined
                }
            }
        }

        /// <summary>
        /// Combine meshes in a GameObject group
        /// </summary>
        private static void CombineMeshes(GameObject parent)
        {
            // Group children by material
            Dictionary<Material, List<MeshFilter>> materialGroups = new Dictionary<Material, List<MeshFilter>>();
            
            MeshFilter[] meshFilters = parent.GetComponentsInChildren<MeshFilter>();
            
            foreach (MeshFilter mf in meshFilters)
            {
                if (mf.transform == parent.transform) continue; // Skip parent
                
                MeshRenderer mr = mf.GetComponent<MeshRenderer>();
                if (mr == null || mr.sharedMaterial == null) continue;
                
                Material mat = mr.sharedMaterial;
                if (!materialGroups.ContainsKey(mat))
                {
                    materialGroups[mat] = new List<MeshFilter>();
                }
                materialGroups[mat].Add(mf);
            }

            // Combine each material group
            int groupIndex = 0;
            foreach (var kvp in materialGroups)
            {
                if (kvp.Value.Count < 5) continue; // Only combine groups with 5+ objects

                Material material = kvp.Key;
                List<MeshFilter> groupMeshFilters = kvp.Value;

                // Create combine instances
                CombineInstance[] combine = new CombineInstance[groupMeshFilters.Count];
                for (int i = 0; i < groupMeshFilters.Count; i++)
                {
                    combine[i].mesh = groupMeshFilters[i].sharedMesh;
                    combine[i].transform = groupMeshFilters[i].transform.localToWorldMatrix;
                }

                // Create combined mesh
                GameObject combined = new GameObject($"Combined_{groupIndex}");
                combined.transform.SetParent(parent.transform);
                combined.transform.position = parent.transform.position;
                Undo.RegisterCreatedObjectUndo(combined, "Optimize World");

                MeshFilter newMF = combined.AddComponent<MeshFilter>();
                MeshRenderer newMR = combined.AddComponent<MeshRenderer>();

                Mesh combinedMesh = new Mesh();
                combinedMesh.CombineMeshes(combine, true, true);
                combinedMesh.RecalculateNormals();
                combinedMesh.RecalculateBounds();
                combinedMesh.Optimize();

                newMF.sharedMesh = combinedMesh;
                newMR.sharedMaterial = material;

                // Disable original objects instead of destroying (allows undo)
                foreach (MeshFilter mf in groupMeshFilters)
                {
                    mf.gameObject.SetActive(false);
                }

                groupIndex++;
            }
        }
    }
}
