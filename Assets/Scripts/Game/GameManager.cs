using UnityEngine;
using UnityEngine.UI;
using FitDungeon.Camera;
using FitDungeon.Pose;

namespace FitDungeon.Game
{
    /// <summary>
    /// 游戏管理器 - 协调摄像头、姿态识别和游戏逻辑
    /// </summary>
    public class GameManager : MonoBehaviour
    {
        [Header("组件引用")]
        [SerializeField] private WebcamController webcamController;
        [SerializeField] private SquatDetector squatDetector;
        [SerializeField] private PixelCharacterController player;
        
        [Header("UI")]
        [SerializeField] private Text squatCountText;
        [SerializeField] private Text statusText;
        [SerializeField] private RawImage cameraDisplay;
        
        // 姿态数据
        private PoseData currentPose;
        
        // 游戏状态
        public enum GameState { WaitingForCamera, Playing, Paused }
        private GameState gameState = GameState.WaitingForCamera;
        
        private void Start()
        {
            InitializeGame();
        }
        
        private void InitializeGame()
        {
            // 创建姿态数据对象
            currentPose = new PoseData();
            
            // 订阅深蹲事件
            if (squatDetector != null)
            {
                squatDetector.OnSquatStart += HandleSquatStart;
                squatDetector.OnSquatEnd += HandleSquatEnd;
                squatDetector.OnSquatCountChanged += HandleSquatCountChanged;
            }
            
            UpdateStatus("正在初始化摄像头...");
            
            // 启动摄像头
            if (webcamController != null)
            {
                webcamController.StartCamera();
            }
        }
        
        private void Update()
        {
            if (gameState == GameState.Playing)
            {
                // 获取当前帧并进行姿态检测
                UpdatePoseDetection();
            }
            
            // 检查摄像头状态
            if (webcamController != null && webcamController.IsCameraRunning && gameState == GameState.WaitingForCamera)
            {
                gameState = GameState.Playing;
                UpdateStatus("游戏进行中 - 开始深蹲！");
            }
        }
        
        private void UpdatePoseDetection()
        {
            // TODO: 集成 MediaPipe 进行真正的姿态检测
            // 目前使用模拟数据测试
            
            // 如果有真实的姿态检测数据
            if (currentPose != null && currentPose.IsValid)
            {
                squatDetector?.Detect(currentPose);
            }
        }
        
        // === 事件处理 ===
        
        private void HandleSquatStart()
        {
            // 深蹲开始 - 角色准备攻击
            player?.Attack();
        }
        
        private void HandleSquatEnd()
        {
            // 深蹲结束
            UpdateStatus($"深蹲完成！继续加油！");
        }
        
        private void HandleSquatCountChanged(int count)
        {
            // 更新计数显示
            if (squatCountText != null)
            {
                squatCountText.text = $"深蹲次数: {count}";
            }
        }
        
        // === UI 更新 ===
        
        private void UpdateStatus(string message)
        {
            if (statusText != null)
            {
                statusText.text = message;
            }
            Debug.Log($"[状态] {message}");
        }
        
        // === 公共方法 ===
        
        /// <summary>
        /// 模拟深蹲（用于测试）
        /// </summary>
        public void SimulateSquat()
        {
            // 创建模拟的姿态数据
            currentPose = new PoseData();
            
            // 模拟深蹲姿态（膝盖弯曲）
            float squatKneeAngle = 90f; // 深蹲时膝盖角度约90度
            
            // 设置关键点位置（简化计算）
            Vector2 hipPos = new Vector2(0.5f, 0.5f);
            Vector2 kneePos = new Vector2(0.5f, 0.7f); // 深蹲时膝盖更低
            Vector2 anklePos = new Vector2(0.5f, 0.9f);
            
            currentPose.UpdateKeypoint(PoseData.LEFT_HIP, hipPos, 1f);
            currentPose.UpdateKeypoint(PoseData.LEFT_KNEE, kneePos, 1f);
            currentPose.UpdateKeypoint(PoseData.LEFT_ANKLE, anklePos, 1f);
            currentPose.UpdateKeypoint(PoseData.RIGHT_HIP, hipPos + Vector2.right * 0.1f, 1f);
            currentPose.UpdateKeypoint(PoseData.RIGHT_KNEE, kneePos + Vector2.right * 0.1f, 1f);
            currentPose.UpdateKeypoint(PoseData.RIGHT_ANKLE, anklePos + Vector2.right * 0.1f, 1f);
            
            currentPose.SetValid(true);
            
            // 检测深蹲
            squatDetector?.Detect(currentPose);
        }
        
        /// <summary>
        /// 模拟站立（用于测试）
        /// </summary>
        public void SimulateStand()
        {
            // 创建模拟的姿态数据
            currentPose = new PoseData();
            
            // 模拟站立姿态（膝盖伸直）
            Vector2 hipPos = new Vector2(0.5f, 0.3f);
            Vector2 kneePos = new Vector2(0.5f, 0.5f);
            Vector2 anklePos = new Vector2(0.5f, 0.9f);
            
            currentPose.UpdateKeypoint(PoseData.LEFT_HIP, hipPos, 1f);
            currentPose.UpdateKeypoint(PoseData.LEFT_KNEE, kneePos, 1f);
            currentPose.UpdateKeypoint(PoseData.LEFT_ANKLE, anklePos, 1f);
            currentPose.UpdateKeypoint(PoseData.RIGHT_HIP, hipPos + Vector2.right * 0.1f, 1f);
            currentPose.UpdateKeypoint(PoseData.RIGHT_KNEE, kneePos + Vector2.right * 0.1f, 1f);
            currentPose.UpdateKeypoint(PoseData.RIGHT_ANKLE, anklePos + Vector2.right * 0.1f, 1f);
            
            currentPose.SetValid(true);
            
            // 检测站立
            squatDetector?.Detect(currentPose);
        }
        
        private void OnDestroy()
        {
            // 取消订阅事件
            if (squatDetector != null)
            {
                squatDetector.OnSquatStart -= HandleSquatStart;
                squatDetector.OnSquatEnd -= HandleSquatEnd;
                squatDetector.OnSquatCountChanged -= HandleSquatCountChanged;
            }
        }
    }
}
