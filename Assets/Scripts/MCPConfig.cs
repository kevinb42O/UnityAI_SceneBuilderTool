using UnityEngine;

namespace MCPBridge
{
    [CreateAssetMenu(fileName = "MCPConfig", menuName = "MCP/Configuration")]
    public class MCPConfig : ScriptableObject
    {
        [Header("Server Settings")]
        public int port = 3001;
        public string host = "localhost";
        public bool autoStartOnPlay = true;
        public bool debugLogging = true;
        
        [Header("Security")]
        public bool allowRemoteConnections = false;
        public string[] allowedIPs = { "127.0.0.1", "localhost" };
        
        [Header("Performance")]
        public int maxConcurrentConnections = 5;
        public int bufferSize = 4096;
        public float connectionTimeout = 30f;
        
        [Header("Features")]
        public bool enablePlayModeCommands = true;
        public bool enableSceneManipulation = true;
        public bool enableAssetManagement = true;
        public bool enableCompilation = true;
        
        private static MCPConfig _instance;
        public static MCPConfig Instance
        {
            get
            {
                if (_instance == null)
                {
                    _instance = Resources.Load<MCPConfig>("MCPConfig");
                    if (_instance == null)
                    {
                        Debug.LogWarning("[MCP] No MCPConfig found in Resources. Using default settings.");
                        _instance = CreateInstance<MCPConfig>();
                    }
                }
                return _instance;
            }
        }
    }
}