using UnityEngine;
using UnityEditor;
using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace UnityMCP
{
    public class CopilotChatWindow : EditorWindow
    {
        private string userMessage = "";
        private Vector2 scrollPosition;
        private System.Collections.Generic.List<ChatMessage> chatHistory = new System.Collections.Generic.List<ChatMessage>();
        private bool isProcessing = false;
        private string vscodeWebhookUrl = "http://localhost:8766/copilot-command";
        
        private GUIStyle messageBoxStyle;
        private GUIStyle userMessageStyle;
        private GUIStyle assistantMessageStyle;
        private bool stylesInitialized = false;

        [MenuItem("Tools/Unity MCP/Copilot Chat")]
        public static void ShowWindow()
        {
            var window = GetWindow<CopilotChatWindow>("Copilot Chat");
            window.minSize = new Vector2(400, 500);
        }

        private void InitializeStyles()
        {
            if (stylesInitialized) return;

            messageBoxStyle = new GUIStyle(EditorStyles.textArea);
            messageBoxStyle.wordWrap = true;
            messageBoxStyle.padding = new RectOffset(10, 10, 10, 10);

            userMessageStyle = new GUIStyle(EditorStyles.helpBox);
            userMessageStyle.wordWrap = true;
            userMessageStyle.padding = new RectOffset(10, 10, 10, 10);
            userMessageStyle.normal.textColor = new Color(0.8f, 0.9f, 1f);

            assistantMessageStyle = new GUIStyle(EditorStyles.helpBox);
            assistantMessageStyle.wordWrap = true;
            assistantMessageStyle.padding = new RectOffset(10, 10, 10, 10);
            assistantMessageStyle.normal.textColor = new Color(0.9f, 1f, 0.9f);

            stylesInitialized = true;
        }

        private void OnGUI()
        {
            InitializeStyles();

            GUILayout.Label("💬 Chat with GitHub Copilot", EditorStyles.boldLabel);
            GUILayout.Label("Commands auto-execute in VS Code", EditorStyles.miniLabel);
            
            EditorGUILayout.Space(5);

            // Chat history
            scrollPosition = EditorGUILayout.BeginScrollView(scrollPosition, GUILayout.ExpandHeight(true));
            
            foreach (var msg in chatHistory)
            {
                var style = msg.isUser ? userMessageStyle : assistantMessageStyle;
                var prefix = msg.isUser ? "You: " : "Copilot: ";
                
                EditorGUILayout.BeginVertical(style);
                EditorGUILayout.LabelField(prefix + msg.message, EditorStyles.wordWrappedLabel);
                if (!string.IsNullOrEmpty(msg.timestamp))
                {
                    GUILayout.Label(msg.timestamp, EditorStyles.miniLabel);
                }
                EditorGUILayout.EndVertical();
                GUILayout.Space(5);
            }
            
            EditorGUILayout.EndScrollView();

            // Input area
            EditorGUILayout.Space(10);
            
            GUILayout.Label("Your Message:", EditorStyles.boldLabel);
            userMessage = EditorGUILayout.TextArea(userMessage, messageBoxStyle, GUILayout.Height(80));

            EditorGUILayout.BeginHorizontal();
            
            GUI.enabled = !isProcessing && !string.IsNullOrWhiteSpace(userMessage);
            if (GUILayout.Button("Send to Copilot", GUILayout.Height(30)))
            {
                SendMessage();
            }
            GUI.enabled = true;

            if (GUILayout.Button("Clear Chat", GUILayout.Height(30), GUILayout.Width(100)))
            {
                chatHistory.Clear();
                userMessage = "";
            }

            EditorGUILayout.EndHorizontal();

            if (isProcessing)
            {
                EditorGUILayout.Space(5);
                EditorGUILayout.HelpBox("⏳ Processing... Copilot is working on your request.", MessageType.Info);
            }

            EditorGUILayout.Space(10);
            EditorGUILayout.HelpBox(
                "💡 Tip: Ask Copilot to create GameObjects, modify scenes, or run commands.\n" +
                "All actions execute automatically - no approval needed!", 
                MessageType.None);
        }

        private async void SendMessage()
        {
            if (string.IsNullOrWhiteSpace(userMessage)) return;

            string msg = userMessage.Trim();
            userMessage = "";
            
            chatHistory.Add(new ChatMessage
            {
                message = msg,
                isUser = true,
                timestamp = DateTime.Now.ToString("HH:mm:ss")
            });

            isProcessing = true;
            Repaint();

            try
            {
                await SendToVSCode(msg);
                
                chatHistory.Add(new ChatMessage
                {
                    message = "✓ Command sent to Copilot. Check VS Code for response and actions.",
                    isUser = false,
                    timestamp = DateTime.Now.ToString("HH:mm:ss")
                });
            }
            catch (Exception ex)
            {
                chatHistory.Add(new ChatMessage
                {
                    message = $"❌ Error: {ex.Message}\nMake sure the VS Code webhook server is running.",
                    isUser = false,
                    timestamp = DateTime.Now.ToString("HH:mm:ss")
                });
            }
            finally
            {
                isProcessing = false;
                Repaint();
                
                // Scroll to bottom
                scrollPosition.y = float.MaxValue;
            }
        }

        private async Task SendToVSCode(string message)
        {
            using (var client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(5);
                
                var json = $"{{\"message\": {EscapeJson(message)}, \"autoExecute\": true}}";
                var content = new StringContent(json, Encoding.UTF8, "application/json");
                
                var response = await client.PostAsync(vscodeWebhookUrl, content);
                response.EnsureSuccessStatusCode();
            }
        }

        private string EscapeJson(string str)
        {
            return "\"" + str
                .Replace("\\", "\\\\")
                .Replace("\"", "\\\"")
                .Replace("\n", "\\n")
                .Replace("\r", "\\r")
                .Replace("\t", "\\t") + "\"";
        }

        [System.Serializable]
        private class ChatMessage
        {
            public string message;
            public bool isUser;
            public string timestamp;
        }
    }
}
