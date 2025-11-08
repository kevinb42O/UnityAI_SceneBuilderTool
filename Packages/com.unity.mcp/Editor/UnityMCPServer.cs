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

        private static string EscapeJson(string str)
        {
            return str.Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\n", "\\n").Replace("\r", "\\r");
        }
    }
}
