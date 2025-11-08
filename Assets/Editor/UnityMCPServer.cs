using UnityEngine;
using UnityEditor;
using System;
using System.Net;
using System.Text;
using System.Threading;
using System.Collections.Generic;

namespace UnityMCP
{
    [InitializeOnLoad]
    public class UnityMCPServer
    {
        private static HttpListener listener;
        private static Thread listenerThread;
        private static int port = 8765;
        private static bool isRunning = false;

        static UnityMCPServer()
        {
            EditorApplication.update += Initialize;
        }

        private static void Initialize()
        {
            EditorApplication.update -= Initialize;
            if (!isRunning)
            {
                StartServer();
            }
        }

        [MenuItem("Tools/Unity MCP/Start Server")]
        public static void StartServer()
        {
            if (isRunning) return;

            try
            {
                listener = new HttpListener();
                listener.Prefixes.Add($"http://localhost:{port}/");
                listener.Start();
                isRunning = true;

                listenerThread = new Thread(HandleRequests);
                listenerThread.IsBackground = true;
                listenerThread.Start();

                Debug.Log($"[Unity MCP] Server started on port {port}");
            }
            catch (Exception e)
            {
                Debug.LogError($"[Unity MCP] Failed to start server: {e.Message}");
            }
        }

        [MenuItem("Tools/Unity MCP/Stop Server")]
        public static void StopServer()
        {
            if (!isRunning) return;

            isRunning = false;
            listener?.Stop();
            listener?.Close();
            Debug.Log("[Unity MCP] Server stopped");
        }

        private static void HandleRequests()
        {
            while (isRunning)
            {
                try
                {
                    var context = listener.GetContext();
                    ThreadPool.QueueUserWorkItem(_ => ProcessRequest(context));
                }
                catch (Exception e)
                {
                    if (isRunning)
                        Debug.LogError($"[Unity MCP] Request error: {e.Message}");
                }
            }
        }

        private static void ProcessRequest(HttpListenerContext context)
        {
            var request = context.Request;
            var response = context.Response;

            try
            {
                response.AddHeader("Access-Control-Allow-Origin", "*");
                response.AddHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
                response.AddHeader("Access-Control-Allow-Headers", "Content-Type");

                if (request.HttpMethod == "OPTIONS")
                {
                    response.StatusCode = 200;
                    response.Close();
                    return;
                }

                string body = "";
                if (request.HasEntityBody)
                {
                    using (var reader = new System.IO.StreamReader(request.InputStream, request.ContentEncoding))
                    {
                        body = reader.ReadToEnd();
                    }
                }

                string result = "";
                bool success = true;

                // Execute on main thread
                EditorApplication.delayCall += () =>
                {
                    try
                    {
                        result = HandleCommand(request.Url.AbsolutePath, body);
                    }
                    catch (Exception e)
                    {
                        result = $"{{\"error\": \"{EscapeJson(e.Message)}\"}}";
                        success = false;
                    }

                    // Send response
                    try
                    {
                        response.StatusCode = success ? 200 : 500;
                        response.ContentType = "application/json";
                        byte[] buffer = Encoding.UTF8.GetBytes(result);
                        response.ContentLength64 = buffer.Length;
                        response.OutputStream.Write(buffer, 0, buffer.Length);
                        response.Close();
                    }
                    catch { }
                };
            }
            catch (Exception e)
            {
                Debug.LogError($"[Unity MCP] Process error: {e.Message}");
                try
                {
                    response.StatusCode = 500;
                    response.Close();
                }
                catch { }
            }
        }

        private static string HandleCommand(string path, string body)
        {
            var json = ParseJson(body);

            switch (path)
            {
                case "/createGameObject":
                    return CreateGameObject(json);
                case "/setTransform":
                    return SetTransform(json);
                case "/addComponent":
                    return AddComponent(json);
                case "/setProperty":
                    return SetProperty(json);
                case "/deleteGameObject":
                    return DeleteGameObject(json);
                case "/findGameObject":
                    return FindGameObject(json);
                case "/listScene":
                    return ListScene();
                case "/playMode":
                    return PlayMode(json);
                case "/saveScene":
                    return SaveScene(json);
                case "/newScene":
                    return NewScene();
                case "/setMaterial":
                    return SetMaterial(json);
                case "/createMaterialLibrary":
                    return CreateMaterialLibrary();
                case "/applyMaterial":
                    return ApplyMaterial(json);
                case "/createGroup":
                    return CreateGroup(json);
                case "/setParent":
                    return SetParent(json);
                case "/combineChildren":
                    return CombineChildren(json);
                case "/queryScene":
                    return QueryScene(json);
                case "/generateWorld":
                    return GenerateWorld(json);
                case "/ping":
                    return "{\"status\": \"ok\"}";
                default:
                    throw new Exception($"Unknown command: {path}");
            }
        }

        private static string CreateGameObject(Dictionary<string, object> json)
        {
            string name = GetString(json, "name", "GameObject");
            string primitiveType = GetString(json, "primitiveType", "");
            string parentPath = GetString(json, "parent", "");

            GameObject go;
            if (!string.IsNullOrEmpty(primitiveType))
            {
                PrimitiveType type = (PrimitiveType)Enum.Parse(typeof(PrimitiveType), primitiveType, true);
                go = GameObject.CreatePrimitive(type);
                go.name = name;
            }
            else
            {
                go = new GameObject(name);
            }

            if (!string.IsNullOrEmpty(parentPath))
            {
                GameObject parent = GameObject.Find(parentPath);
                if (parent != null)
                    go.transform.SetParent(parent.transform);
            }

            Undo.RegisterCreatedObjectUndo(go, "Create GameObject");

            return $"{{\"success\": true, \"name\": \"{EscapeJson(go.name)}\", \"instanceId\": {go.GetInstanceID()}}}";
        }

        private static string SetTransform(Dictionary<string, object> json)
        {
            string name = GetString(json, "name", "");
            GameObject go = GameObject.Find(name);
            if (go == null)
                throw new Exception($"GameObject not found: {name}");

            Undo.RecordObject(go.transform, "Set Transform");

            if (json.ContainsKey("position"))
            {
                var pos = (Dictionary<string, object>)json["position"];
                go.transform.position = new Vector3(
                    GetFloat(pos, "x", 0),
                    GetFloat(pos, "y", 0),
                    GetFloat(pos, "z", 0)
                );
            }

            if (json.ContainsKey("rotation"))
            {
                var rot = (Dictionary<string, object>)json["rotation"];
                go.transform.rotation = Quaternion.Euler(
                    GetFloat(rot, "x", 0),
                    GetFloat(rot, "y", 0),
                    GetFloat(rot, "z", 0)
                );
            }

            if (json.ContainsKey("scale"))
            {
                var scale = (Dictionary<string, object>)json["scale"];
                go.transform.localScale = new Vector3(
                    GetFloat(scale, "x", 1),
                    GetFloat(scale, "y", 1),
                    GetFloat(scale, "z", 1)
                );
            }

            return "{\"success\": true}";
        }

        private static string AddComponent(Dictionary<string, object> json)
        {
            string name = GetString(json, "name", "");
            string componentType = GetString(json, "componentType", "");

            GameObject go = GameObject.Find(name);
            if (go == null)
                throw new Exception($"GameObject not found: {name}");

            Type type = Type.GetType(componentType + ", Assembly-CSharp") ??
                       Type.GetType(componentType + ", UnityEngine") ??
                       Type.GetType(componentType);

            if (type == null)
                throw new Exception($"Component type not found: {componentType}");

            Component comp = go.AddComponent(type);
            Undo.RegisterCreatedObjectUndo(comp, "Add Component");

            return $"{{\"success\": true, \"component\": \"{EscapeJson(type.Name)}\"}}";
        }

        private static string SetProperty(Dictionary<string, object> json)
        {
            string name = GetString(json, "name", "");
            string componentType = GetString(json, "componentType", "");
            string property = GetString(json, "property", "");
            object value = json.ContainsKey("value") ? json["value"] : null;

            GameObject go = GameObject.Find(name);
            if (go == null)
                throw new Exception($"GameObject not found: {name}");

            Type type = Type.GetType(componentType + ", Assembly-CSharp") ??
                       Type.GetType(componentType + ", UnityEngine") ??
                       Type.GetType(componentType);

            Component comp = go.GetComponent(type);
            if (comp == null)
                throw new Exception($"Component not found: {componentType}");

            Undo.RecordObject(comp, "Set Property");

            var prop = type.GetProperty(property);
            if (prop != null)
            {
                prop.SetValue(comp, ConvertValue(value, prop.PropertyType), null);
            }
            else
            {
                var field = type.GetField(property);
                if (field != null)
                    field.SetValue(comp, ConvertValue(value, field.FieldType));
                else
                    throw new Exception($"Property/field not found: {property}");
            }

            return "{\"success\": true}";
        }

        private static string DeleteGameObject(Dictionary<string, object> json)
        {
            string name = GetString(json, "name", "");
            GameObject go = GameObject.Find(name);
            if (go == null)
                throw new Exception($"GameObject not found: {name}");

            Undo.DestroyObjectImmediate(go);
            return "{\"success\": true}";
        }

        private static string FindGameObject(Dictionary<string, object> json)
        {
            string name = GetString(json, "name", "");
            GameObject go = GameObject.Find(name);

            if (go == null)
                return "{\"found\": false}";

            return $"{{\"found\": true, \"name\": \"{EscapeJson(go.name)}\", " +
                   $"\"position\": {{\"x\": {go.transform.position.x}, \"y\": {go.transform.position.y}, \"z\": {go.transform.position.z}}}, " +
                   $"\"active\": {go.activeSelf.ToString().ToLower()}}}";
        }

        private static string ListScene()
        {
            var scene = UnityEngine.SceneManagement.SceneManager.GetActiveScene();
            var objects = scene.GetRootGameObjects();
            var list = new System.Text.StringBuilder();
            list.Append("{\"objects\": [");

            for (int i = 0; i < objects.Length; i++)
            {
                if (i > 0) list.Append(",");
                list.Append($"{{\"name\": \"{EscapeJson(objects[i].name)}\", \"active\": {objects[i].activeSelf.ToString().ToLower()}}}");
            }

            list.Append($"], \"scene\": \"{EscapeJson(scene.name)}\"}}");
            return list.ToString();
        }

        private static string PlayMode(Dictionary<string, object> json)
        {
            bool play = GetBool(json, "play", true);
            EditorApplication.isPlaying = play;
            return $"{{\"success\": true, \"isPlaying\": {EditorApplication.isPlaying.ToString().ToLower()}}}";
        }

        private static string SaveScene(Dictionary<string, object> json)
        {
            string path = GetString(json, "path", "");
            if (string.IsNullOrEmpty(path))
            {
                UnityEditor.SceneManagement.EditorSceneManager.SaveOpenScenes();
            }
            else
            {
                var scene = UnityEngine.SceneManagement.SceneManager.GetActiveScene();
                UnityEditor.SceneManagement.EditorSceneManager.SaveScene(scene, path);
            }
            return "{\"success\": true}";
        }

        private static string NewScene()
        {
            UnityEditor.SceneManagement.EditorSceneManager.NewScene(
                UnityEditor.SceneManagement.NewSceneSetup.DefaultGameObjects,
                UnityEditor.SceneManagement.NewSceneMode.Single
            );
            return "{\"success\": true}";
        }

        // ============================================================
        // MATERIALS SYSTEM - Production Grade Material Management
        // ============================================================

        private static string SetMaterial(Dictionary<string, object> json)
        {
            string name = GetString(json, "name", "");
            GameObject go = GameObject.Find(name);
            if (go == null)
                throw new Exception($"GameObject not found: {name}");

            var renderer = go.GetComponent<Renderer>();
            if (renderer == null)
                throw new Exception($"No Renderer component on: {name}");

            Undo.RecordObject(renderer, "Set Material");

            // Create or modify material
            Material mat = renderer.sharedMaterial;
            if (mat == null || mat.name == "Default-Material")
            {
                mat = new Material(Shader.Find("Standard"));
                mat.name = $"{name}_Material";
                renderer.sharedMaterial = mat;
            }

            // Apply color
            if (json.ContainsKey("color"))
            {
                var colorDict = (Dictionary<string, object>)json["color"];
                float r = GetFloat(colorDict, "r", 1.0f);
                float g = GetFloat(colorDict, "g", 1.0f);
                float b = GetFloat(colorDict, "b", 1.0f);
                float a = GetFloat(colorDict, "a", 1.0f);
                mat.color = new Color(r, g, b, a);
            }

            // Apply metallic (0-1)
            if (json.ContainsKey("metallic"))
            {
                float metallic = GetFloat(json, "metallic", 0.0f);
                mat.SetFloat("_Metallic", Mathf.Clamp01(metallic));
            }

            // Apply smoothness (0-1)
            if (json.ContainsKey("smoothness"))
            {
                float smoothness = GetFloat(json, "smoothness", 0.5f);
                mat.SetFloat("_Glossiness", Mathf.Clamp01(smoothness));
            }

            // Apply emission
            if (json.ContainsKey("emission"))
            {
                var emissionDict = (Dictionary<string, object>)json["emission"];
                float r = GetFloat(emissionDict, "r", 0.0f);
                float g = GetFloat(emissionDict, "g", 0.0f);
                float b = GetFloat(emissionDict, "b", 0.0f);
                float intensity = GetFloat(emissionDict, "intensity", 1.0f);
                
                mat.EnableKeyword("_EMISSION");
                mat.SetColor("_EmissionColor", new Color(r, g, b, 1.0f) * intensity);
            }

            // Apply texture tiling and offset
            if (json.ContainsKey("tiling"))
            {
                var tilingDict = (Dictionary<string, object>)json["tiling"];
                float x = GetFloat(tilingDict, "x", 1.0f);
                float y = GetFloat(tilingDict, "y", 1.0f);
                mat.mainTextureScale = new Vector2(x, y);
            }

            if (json.ContainsKey("offset"))
            {
                var offsetDict = (Dictionary<string, object>)json["offset"];
                float x = GetFloat(offsetDict, "x", 0.0f);
                float y = GetFloat(offsetDict, "y", 0.0f);
                mat.mainTextureOffset = new Vector2(x, y);
            }

            EditorUtility.SetDirty(renderer);

            return $"{{\"success\": true, \"materialName\": \"{EscapeJson(mat.name)}\"}}";
        }

        private static string CreateMaterialLibrary()
        {
            // Predefined material library for common use cases
            var materials = new Dictionary<string, Dictionary<string, object>>
            {
                ["Wood_Oak"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 0.65f, ["g"] = 0.45f, ["b"] = 0.25f },
                    ["metallic"] = 0.0f,
                    ["smoothness"] = 0.3f
                },
                ["Metal_Steel"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 0.75f, ["g"] = 0.75f, ["b"] = 0.75f },
                    ["metallic"] = 0.9f,
                    ["smoothness"] = 0.8f
                },
                ["Metal_Gold"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 1.0f, ["g"] = 0.84f, ["b"] = 0.0f },
                    ["metallic"] = 1.0f,
                    ["smoothness"] = 0.9f
                },
                ["Metal_Bronze"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 0.8f, ["g"] = 0.5f, ["b"] = 0.2f },
                    ["metallic"] = 0.8f,
                    ["smoothness"] = 0.6f
                },
                ["Glass_Clear"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 0.9f, ["g"] = 0.9f, ["b"] = 1.0f, ["a"] = 0.3f },
                    ["metallic"] = 0.0f,
                    ["smoothness"] = 1.0f
                },
                ["Brick_Red"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 0.7f, ["g"] = 0.2f, ["b"] = 0.15f },
                    ["metallic"] = 0.0f,
                    ["smoothness"] = 0.1f
                },
                ["Concrete"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 0.6f, ["g"] = 0.6f, ["b"] = 0.6f },
                    ["metallic"] = 0.0f,
                    ["smoothness"] = 0.2f
                },
                ["Stone_Gray"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 0.5f, ["g"] = 0.5f, ["b"] = 0.5f },
                    ["metallic"] = 0.0f,
                    ["smoothness"] = 0.15f
                },
                ["Grass_Green"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 0.2f, ["g"] = 0.6f, ["b"] = 0.1f },
                    ["metallic"] = 0.0f,
                    ["smoothness"] = 0.0f
                },
                ["Water_Blue"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 0.1f, ["g"] = 0.4f, ["b"] = 0.8f, ["a"] = 0.7f },
                    ["metallic"] = 0.0f,
                    ["smoothness"] = 0.95f
                },
                ["Rubber_Black"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 0.1f, ["g"] = 0.1f, ["b"] = 0.1f },
                    ["metallic"] = 0.0f,
                    ["smoothness"] = 0.4f
                },
                ["Plastic_White"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 0.95f, ["g"] = 0.95f, ["b"] = 0.95f },
                    ["metallic"] = 0.0f,
                    ["smoothness"] = 0.7f
                },
                ["Emissive_Blue"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 0.2f, ["g"] = 0.4f, ["b"] = 1.0f },
                    ["metallic"] = 0.0f,
                    ["smoothness"] = 0.5f,
                    ["emission"] = new Dictionary<string, object> { ["r"] = 0.2f, ["g"] = 0.4f, ["b"] = 1.0f, ["intensity"] = 2.0f }
                },
                ["Emissive_Red"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 1.0f, ["g"] = 0.1f, ["b"] = 0.1f },
                    ["metallic"] = 0.0f,
                    ["smoothness"] = 0.5f,
                    ["emission"] = new Dictionary<string, object> { ["r"] = 1.0f, ["g"] = 0.1f, ["b"] = 0.1f, ["intensity"] = 2.0f }
                }
            };

            var sb = new System.Text.StringBuilder();
            sb.Append("{\"materials\": [");
            
            int count = 0;
            foreach (var kvp in materials)
            {
                if (count > 0) sb.Append(",");
                sb.Append($"{{\"name\": \"{kvp.Key}\"}}");
                count++;
            }
            
            sb.Append("]}");
            return sb.ToString();
        }

        private static string ApplyMaterial(Dictionary<string, object> json)
        {
            string name = GetString(json, "name", "");
            string materialName = GetString(json, "materialName", "");

            GameObject go = GameObject.Find(name);
            if (go == null)
                throw new Exception($"GameObject not found: {name}");

            var renderer = go.GetComponent<Renderer>();
            if (renderer == null)
                throw new Exception($"No Renderer component on: {name}");

            // Predefined materials lookup
            var materialConfigs = new Dictionary<string, Dictionary<string, object>>
            {
                ["Wood_Oak"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 0.65f, ["g"] = 0.45f, ["b"] = 0.25f },
                    ["metallic"] = 0.0f,
                    ["smoothness"] = 0.3f
                },
                ["Metal_Steel"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 0.75f, ["g"] = 0.75f, ["b"] = 0.75f },
                    ["metallic"] = 0.9f,
                    ["smoothness"] = 0.8f
                },
                ["Metal_Gold"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 1.0f, ["g"] = 0.84f, ["b"] = 0.0f },
                    ["metallic"] = 1.0f,
                    ["smoothness"] = 0.9f
                },
                ["Brick_Red"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 0.7f, ["g"] = 0.2f, ["b"] = 0.15f },
                    ["metallic"] = 0.0f,
                    ["smoothness"] = 0.1f
                },
                ["Concrete"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 0.6f, ["g"] = 0.6f, ["b"] = 0.6f },
                    ["metallic"] = 0.0f,
                    ["smoothness"] = 0.2f
                },
                ["Grass_Green"] = new Dictionary<string, object>
                {
                    ["color"] = new Dictionary<string, object> { ["r"] = 0.2f, ["g"] = 0.6f, ["b"] = 0.1f },
                    ["metallic"] = 0.0f,
                    ["smoothness"] = 0.0f
                }
            };

            if (!materialConfigs.ContainsKey(materialName))
                throw new Exception($"Material not found in library: {materialName}");

            // Apply material using setMaterial
            var materialData = materialConfigs[materialName];
            materialData["name"] = name;
            
            return SetMaterial(materialData);
        }

        // ============================================================
        // HIERARCHY SYSTEM - Smart Object Organization & Optimization
        // ============================================================

        private static string CreateGroup(Dictionary<string, object> json)
        {
            string name = GetString(json, "name", "Group");
            string parentPath = GetString(json, "parent", "");

            GameObject group = new GameObject(name);
            
            if (!string.IsNullOrEmpty(parentPath))
            {
                GameObject parent = GameObject.Find(parentPath);
                if (parent != null)
                    group.transform.SetParent(parent.transform);
            }

            Undo.RegisterCreatedObjectUndo(group, "Create Group");

            return $"{{\"success\": true, \"name\": \"{EscapeJson(group.name)}\", \"instanceId\": {group.GetInstanceID()}, \"path\": \"{EscapeJson(GetGameObjectPath(group))}\"}}";
        }

        private static string SetParent(Dictionary<string, object> json)
        {
            string childName = GetString(json, "childName", "");
            string parentName = GetString(json, "parentName", "");
            bool worldPositionStays = GetBool(json, "worldPositionStays", true);

            GameObject child = GameObject.Find(childName);
            if (child == null)
                throw new Exception($"Child GameObject not found: {childName}");

            GameObject parent = GameObject.Find(parentName);
            if (parent == null)
                throw new Exception($"Parent GameObject not found: {parentName}");

            Undo.SetTransformParent(child.transform, parent.transform, worldPositionStays, "Set Parent");

            return $"{{\"success\": true, \"child\": \"{EscapeJson(child.name)}\", \"parent\": \"{EscapeJson(parent.name)}\"}}";
        }

        private static string CombineChildren(Dictionary<string, object> json)
        {
            string parentName = GetString(json, "parentName", "");
            bool destroyOriginals = GetBool(json, "destroyOriginals", true);
            bool generateCollider = GetBool(json, "generateCollider", true);

            GameObject parent = GameObject.Find(parentName);
            if (parent == null)
                throw new Exception($"Parent GameObject not found: {parentName}");

            // Collect all mesh filters from children
            MeshFilter[] meshFilters = parent.GetComponentsInChildren<MeshFilter>();
            if (meshFilters.Length == 0)
                throw new Exception($"No mesh filters found in children of: {parentName}");

            // Group by material for optimal batching
            Dictionary<Material, List<CombineInstance>> materialGroups = new Dictionary<Material, List<CombineInstance>>();

            foreach (MeshFilter meshFilter in meshFilters)
            {
                if (meshFilter.gameObject == parent) continue; // Skip parent itself

                MeshRenderer renderer = meshFilter.GetComponent<MeshRenderer>();
                if (renderer == null) continue;

                Material material = renderer.sharedMaterial;
                if (material == null) material = new Material(Shader.Find("Standard"));

                if (!materialGroups.ContainsKey(material))
                    materialGroups[material] = new List<CombineInstance>();

                CombineInstance combine = new CombineInstance();
                combine.mesh = meshFilter.sharedMesh;
                combine.transform = meshFilter.transform.localToWorldMatrix;
                materialGroups[material].Add(combine);
            }

            // Create combined mesh for each material
            int combinedCount = 0;
            foreach (var kvp in materialGroups)
            {
                GameObject combined = new GameObject($"{parent.name}_Combined_{combinedCount}");
                combined.transform.SetParent(parent.transform);
                combined.transform.localPosition = Vector3.zero;
                combined.transform.localRotation = Quaternion.identity;
                combined.transform.localScale = Vector3.one;

                MeshFilter combinedFilter = combined.AddComponent<MeshFilter>();
                MeshRenderer combinedRenderer = combined.AddComponent<MeshRenderer>();

                Mesh combinedMesh = new Mesh();
                combinedMesh.name = $"{parent.name}_CombinedMesh_{combinedCount}";
                combinedMesh.CombineMeshes(kvp.Value.ToArray(), true, true);
                
                // Optimize the mesh
                combinedMesh.RecalculateNormals();
                combinedMesh.RecalculateBounds();
                combinedMesh.Optimize();

                combinedFilter.sharedMesh = combinedMesh;
                combinedRenderer.sharedMaterial = kvp.Key;

                // Generate mesh collider if requested
                if (generateCollider)
                {
                    MeshCollider collider = combined.AddComponent<MeshCollider>();
                    collider.sharedMesh = combinedMesh;
                    collider.convex = false; // More accurate for static geometry
                }

                Undo.RegisterCreatedObjectUndo(combined, "Combine Meshes");
                combinedCount++;
            }

            // Destroy original child objects if requested
            if (destroyOriginals)
            {
                foreach (MeshFilter meshFilter in meshFilters)
                {
                    if (meshFilter.gameObject != parent && !meshFilter.gameObject.name.Contains("_Combined_"))
                    {
                        Undo.DestroyObjectImmediate(meshFilter.gameObject);
                    }
                }
            }

            return $"{{\"success\": true, \"combinedMeshes\": {combinedCount}, \"originalCount\": {meshFilters.Length}}}";
        }

        // ============================================================
        // SCENE QUERY SYSTEM - Context-Aware Scene Intelligence
        // ============================================================

        private static string QueryScene(Dictionary<string, object> json)
        {
            string query = GetString(json, "query", "");
            float radius = GetFloat(json, "radius", 0.0f);
            
            Vector3 position = Vector3.zero;
            if (json.ContainsKey("position"))
            {
                var posDict = (Dictionary<string, object>)json["position"];
                position = new Vector3(
                    GetFloat(posDict, "x", 0),
                    GetFloat(posDict, "y", 0),
                    GetFloat(posDict, "z", 0)
                );
            }

            var results = new System.Text.StringBuilder();
            results.Append("{\"results\": [");

            int count = 0;
            GameObject[] allObjects = GameObject.FindObjectsOfType<GameObject>();

            foreach (GameObject go in allObjects)
            {
                bool include = false;

                // Filter by query string (name contains)
                if (!string.IsNullOrEmpty(query))
                {
                    if (go.name.ToLower().Contains(query.ToLower()))
                        include = true;
                    
                    // Also check tags
                    if (go.tag.ToLower().Contains(query.ToLower()))
                        include = true;
                }
                else
                {
                    include = true; // Include all if no query
                }

                // Filter by radius if specified
                if (include && radius > 0.0f)
                {
                    float distance = Vector3.Distance(go.transform.position, position);
                    include = distance <= radius;
                }

                if (include)
                {
                    if (count > 0) results.Append(",");

                    var bounds = go.GetComponent<Renderer>()?.bounds;
                    string boundsStr = "null";
                    if (bounds.HasValue)
                    {
                        var b = bounds.Value;
                        boundsStr = $"{{\"center\": {{\"x\": {b.center.x}, \"y\": {b.center.y}, \"z\": {b.center.z}}}, " +
                                   $"\"size\": {{\"x\": {b.size.x}, \"y\": {b.size.y}, \"z\": {b.size.z}}}}}";
                    }

                    results.Append($"{{");
                    results.Append($"\"name\": \"{EscapeJson(go.name)}\", ");
                    results.Append($"\"path\": \"{EscapeJson(GetGameObjectPath(go))}\", ");
                    results.Append($"\"tag\": \"{EscapeJson(go.tag)}\", ");
                    results.Append($"\"layer\": {go.layer}, ");
                    results.Append($"\"active\": {go.activeSelf.ToString().ToLower()}, ");
                    results.Append($"\"position\": {{\"x\": {go.transform.position.x}, \"y\": {go.transform.position.y}, \"z\": {go.transform.position.z}}}, ");
                    results.Append($"\"bounds\": {boundsStr}");
                    results.Append($"}}");

                    count++;

                    // Limit results to prevent overwhelming response
                    if (count >= 500) break;
                }
            }

            results.Append($"], \"count\": {count}}}");
            return results.ToString();
        }

        // Helper to get full hierarchy path of GameObject
        private static string GetGameObjectPath(GameObject go)
        {
            string path = go.name;
            Transform current = go.transform.parent;
            
            while (current != null)
            {
                path = current.name + "/" + path;
                current = current.parent;
            }
            
            return path;
        }

        // Helper methods
        private static Dictionary<string, object> ParseJson(string json)
        {
            if (string.IsNullOrEmpty(json) || json == "{}")
                return new Dictionary<string, object>();

            json = json.Trim();
            if (!json.StartsWith("{") || !json.EndsWith("}"))
                return new Dictionary<string, object>();

            var dict = new Dictionary<string, object>();
            json = json.Substring(1, json.Length - 2).Trim();
            if (string.IsNullOrEmpty(json)) return dict;

            int pos = 0;
            while (pos < json.Length)
            {
                // Skip whitespace and commas
                while (pos < json.Length && (json[pos] == ' ' || json[pos] == ',' || json[pos] == '\n' || json[pos] == '\r'))
                    pos++;
                
                if (pos >= json.Length) break;

                // Parse key
                if (json[pos] != '"') break;
                pos++; // Skip opening quote
                int keyStart = pos;
                while (pos < json.Length && json[pos] != '"') pos++;
                string key = json.Substring(keyStart, pos - keyStart);
                pos++; // Skip closing quote

                // Skip colon and whitespace
                while (pos < json.Length && (json[pos] == ':' || json[pos] == ' ')) pos++;

                // Parse value
                if (pos >= json.Length) break;

                if (json[pos] == '{')
                {
                    // Nested object
                    int braceCount = 1;
                    int valueStart = pos;
                    pos++;
                    while (pos < json.Length && braceCount > 0)
                    {
                        if (json[pos] == '{') braceCount++;
                        else if (json[pos] == '}') braceCount--;
                        pos++;
                    }
                    string nestedJson = json.Substring(valueStart, pos - valueStart);
                    dict[key] = ParseJson(nestedJson);
                }
                else if (json[pos] == '"')
                {
                    // String value
                    pos++; // Skip opening quote
                    int valueStart = pos;
                    while (pos < json.Length && json[pos] != '"') pos++;
                    dict[key] = json.Substring(valueStart, pos - valueStart);
                    pos++; // Skip closing quote
                }
                else if (json[pos] == 't' && pos + 4 <= json.Length && json.Substring(pos, 4) == "true")
                {
                    dict[key] = true;
                    pos += 4;
                }
                else if (json[pos] == 'f' && pos + 5 <= json.Length && json.Substring(pos, 5) == "false")
                {
                    dict[key] = false;
                    pos += 5;
                }
                else
                {
                    // Number
                    int valueStart = pos;
                    while (pos < json.Length && (char.IsDigit(json[pos]) || json[pos] == '.' || json[pos] == '-' || json[pos] == 'e' || json[pos] == 'E'))
                        pos++;
                    string numStr = json.Substring(valueStart, pos - valueStart);
                    if (numStr.Contains(".") || numStr.Contains("e") || numStr.Contains("E"))
                        dict[key] = float.Parse(numStr, System.Globalization.CultureInfo.InvariantCulture);
                    else
                        dict[key] = int.Parse(numStr);
                }
            }
            return dict;
        }

        private static string GetString(Dictionary<string, object> dict, string key, string defaultValue)
        {
            return dict.ContainsKey(key) ? dict[key].ToString() : defaultValue;
        }

        private static float GetFloat(Dictionary<string, object> dict, string key, float defaultValue)
        {
            if (!dict.ContainsKey(key)) return defaultValue;
            var val = dict[key];
            if (val is float) return (float)val;
            if (val is double) return (float)(double)val;
            if (val is int) return (float)(int)val;
            return float.Parse(val.ToString());
        }

        private static bool GetBool(Dictionary<string, object> dict, string key, bool defaultValue)
        {
            return dict.ContainsKey(key) ? (bool)dict[key] : defaultValue;
        }

        private static object ConvertValue(object value, Type targetType)
        {
            if (value == null) return null;
            if (targetType.IsAssignableFrom(value.GetType())) return value;

            if (targetType == typeof(float))
                return Convert.ToSingle(value);
            if (targetType == typeof(int))
                return Convert.ToInt32(value);
            if (targetType == typeof(bool))
                return Convert.ToBoolean(value);
            if (targetType == typeof(string))
                return value.ToString();

            return value;
        }

        /// <summary>
        /// Generate a complete world based on biome and settings
        /// </summary>
        private static string GenerateWorld(Dictionary<string, object> json)
        {
            try
            {
                // Parse settings
                var settings = new WorldGenerator.WorldSettings();
                
                if (json.ContainsKey("biome"))
                {
                    string biomeStr = GetString(json, "biome", "Forest");
                    if (Enum.TryParse(biomeStr, true, out WorldGenerator.BiomeType biome))
                    {
                        settings.biome = biome;
                    }
                }
                
                if (json.ContainsKey("worldSize"))
                    settings.worldSize = GetInt(json, "worldSize", 100);
                
                if (json.ContainsKey("density"))
                    settings.density = GetInt(json, "density", 50);
                
                if (json.ContainsKey("includeTerrain"))
                    settings.includeTerrain = GetBool(json, "includeTerrain", true);
                
                if (json.ContainsKey("includeLighting"))
                    settings.includeLighting = GetBool(json, "includeLighting", true);
                
                if (json.ContainsKey("includeProps"))
                    settings.includeProps = GetBool(json, "includeProps", true);
                
                if (json.ContainsKey("optimizeMeshes"))
                    settings.optimizeMeshes = GetBool(json, "optimizeMeshes", true);
                
                if (json.ContainsKey("seed"))
                    settings.seedString = GetString(json, "seed", "");

                // Generate world
                var result = WorldGenerator.GenerateWorld(settings);
                
                // Convert to JSON
                var jsonParts = new List<string>();
                foreach (var kvp in result)
                {
                    string value;
                    if (kvp.Value is string)
                        value = $"\"{EscapeJson(kvp.Value.ToString())}\"";
                    else if (kvp.Value is bool)
                        value = kvp.Value.ToString().ToLower();
                    else if (kvp.Value is Dictionary<string, object>)
                    {
                        var subDict = (Dictionary<string, object>)kvp.Value;
                        var subParts = new List<string>();
                        foreach (var subKvp in subDict)
                        {
                            string subValue = subKvp.Value is string ? 
                                $"\"{EscapeJson(subKvp.Value.ToString())}\"" : 
                                subKvp.Value.ToString();
                            subParts.Add($"\"{subKvp.Key}\": {subValue}");
                        }
                        value = "{" + string.Join(", ", subParts) + "}";
                    }
                    else
                        value = kvp.Value.ToString();
                    
                    jsonParts.Add($"\"{kvp.Key}\": {value}");
                }
                
                return "{" + string.Join(", ", jsonParts) + "}";
            }
            catch (Exception e)
            {
                return $"{{\"success\": false, \"error\": \"{EscapeJson(e.Message)}\"}}";
            }
        }

        private static string EscapeJson(string str)
        {
            return str.Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\n", "\\n").Replace("\r", "\\r");
        }
    }
}
