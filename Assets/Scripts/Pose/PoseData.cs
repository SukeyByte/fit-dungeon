using UnityEngine;

namespace FitDungeon.Pose
{
    /// <summary>
    /// 姿态数据 - 存储人体关键点信息
    /// </summary>
    public class PoseData
    {
        // MediaPipe 33个关键点
        public Vector2[] Keypoints { get; private set; }
        public float[] Confidences { get; private set; }
        public bool IsValid { get; private set; }
        
        // 关键点索引（MediaPipe标准）
        public const int NOSE = 0;
        public const int LEFT_SHOULDER = 11;
        public const int RIGHT_SHOULDER = 12;
        public const int LEFT_ELBOW = 13;
        public const int RIGHT_ELBOW = 14;
        public const int LEFT_WRIST = 15;
        public const int RIGHT_WRIST = 16;
        public const int LEFT_HIP = 23;
        public const int RIGHT_HIP = 24;
        public const int LEFT_KNEE = 25;
        public const int RIGHT_KNEE = 26;
        public const int LEFT_ANKLE = 27;
        public const int RIGHT_ANKLE = 28;
        
        public PoseData()
        {
            Keypoints = new Vector2[33];
            Confidences = new float[33];
            IsValid = false;
        }
        
        /// <summary>
        /// 更新关键点数据
        /// </summary>
        public void UpdateKeypoint(int index, Vector2 position, float confidence)
        {
            if (index >= 0 && index < 33)
            {
                Keypoints[index] = position;
                Confidences[index] = confidence;
            }
        }
        
        /// <summary>
        /// 获取关键点（带置信度检查）
        /// </summary>
        public bool TryGetKeypoint(int index, out Vector2 position, float minConfidence = 0.5f)
        {
            position = Vector2.zero;
            if (index >= 0 && index < 33 && Confidences[index] >= minConfidence)
            {
                position = Keypoints[index];
                return true;
            }
            return false;
        }
        
        /// <summary>
        /// 计算两点之间的角度
        /// </summary>
        public float CalculateAngle(int point1, int point2, int point3)
        {
            Vector2 p1, p2, p3;
            
            if (!TryGetKeypoint(point1, out p1) ||
                !TryGetKeypoint(point2, out p2) ||
                !TryGetKeypoint(point3, out p3))
            {
                return -1f; // 无效
            }
            
            Vector2 v1 = p1 - p2;
            Vector2 v2 = p3 - p2;
            
            float angle = Vector2.Angle(v1, v2);
            return angle;
        }
        
        /// <summary>
        /// 标记数据为有效/无效
        /// </summary>
        public void SetValid(bool valid)
        {
            IsValid = valid;
        }
    }
}
