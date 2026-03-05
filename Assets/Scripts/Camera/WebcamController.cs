using UnityEngine;
using UnityEngine.UI;

namespace FitDungeon.Camera
{
    /// <summary>
    /// 摄像头控制器 - 负责开启和管理设备摄像头
    /// </summary>
    public class WebcamController : MonoBehaviour
    {
        [Header("摄像头设置")]
        [SerializeField] private RawImage cameraDisplay;
        [SerializeField] private int requestedWidth = 1280;
        [SerializeField] private int requestedHeight = 720;
        [SerializeField] private int requestedFPS = 30;
        
        private WebCamTexture webcamTexture;
        private bool isCameraRunning = false;
        
        /// <summary>
        /// 摄像头是否正在运行
        /// </summary>
        public bool IsCameraRunning => isCameraRunning;
        
        /// <summary>
        /// 获取当前摄像头纹理
        /// </summary>
        public WebCamTexture WebcamTexture => webcamTexture;
        
        /// <summary>
        /// 获取摄像头画面（用于姿态识别）
        /// </summary>
        public Texture2D CameraFrame { get; private set; }
        
        private void Start()
        {
            StartCamera();
        }
        
        /// <summary>
        /// 启动摄像头
        /// </summary>
        public void StartCamera()
        {
            if (isCameraRunning) return;
            
            // 检查摄像头权限
            if (!Application.HasUserAuthorization(UserAuthorization.WebCam))
            {
                Debug.Log("请求摄像头权限...");
                StartCoroutine(RequestCameraPermission());
                return;
            }
            
            // 获取可用摄像头
            if (WebCamTexture.devices.Length == 0)
            {
                Debug.LogError("没有找到可用的摄像头！");
                return;
            }
            
            // 使用后置摄像头（如果有的话）
            string deviceName = WebCamTexture.devices[0].name;
            foreach (var device in WebCamTexture.devices)
            {
                if (!device.isFrontFacing)
                {
                    deviceName = device.name;
                    break;
                }
            }
            
            // 创建摄像头纹理
            webcamTexture = new WebCamTexture(deviceName, requestedWidth, requestedHeight, requestedFPS);
            
            // 显示到 RawImage
            if (cameraDisplay != null)
            {
                cameraDisplay.texture = webcamTexture;
            }
            
            // 开始捕获
            webcamTexture.Play();
            isCameraRunning = true;
            
            Debug.Log($"摄像头已启动: {deviceName} ({webcamTexture.width}x{webcamTexture.height})");
        }
        
        /// <summary>
        /// 停止摄像头
        /// </summary>
        public void StopCamera()
        {
            if (!isCameraRunning) return;
            
            webcamTexture?.Stop();
            isCameraRunning = false;
            Debug.Log("摄像头已停止");
        }
        
        /// <summary>
        /// 获取当前帧（用于姿态识别）
        /// </summary>
        public Texture2D GetCurrentFrame()
        {
            if (!isCameraRunning || webcamTexture == null) return null;
            
            // 创建或调整 Texture2D 大小
            if (CameraFrame == null || CameraFrame.width != webcamTexture.width || CameraFrame.height != webcamTexture.height)
            {
                CameraFrame = new Texture2D(webcamTexture.width, webcamTexture.height, TextureFormat.RGB24, false);
            }
            
            // 复制当前帧
            CameraFrame.SetPixels(webcamTexture.GetPixels());
            CameraFrame.Apply();
            
            return CameraFrame;
        }
        
        private System.Collections.IEnumerator RequestCameraPermission()
        {
            yield return Application.RequestUserAuthorization(UserAuthorization.WebCam);
            
            if (Application.HasUserAuthorization(UserAuthorization.WebCam))
            {
                Debug.Log("摄像头权限已获取");
                StartCamera();
            }
            else
            {
                Debug.LogError("摄像头权限被拒绝！");
            }
        }
        
        private void OnDestroy()
        {
            StopCamera();
        }
    }
}
