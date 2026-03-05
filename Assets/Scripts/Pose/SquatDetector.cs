using UnityEngine;
using System.Collections.Generic;

namespace FitDungeon.Pose
{
    /// <summary>
    /// 深蹲检测器 - 基于膝盖角度分析
    /// </summary>
    public class SquatDetector : MonoBehaviour
    {
        [Header("检测设置")]
        [SerializeField] private float squatAngleThreshold = 100f; // 深蹲时膝盖角度阈值
        [SerializeField] private float standAngleThreshold = 150f; // 站立时膝盖角度阈值
        [SerializeField] private float minConfidence = 0.5f; // 最小置信度
        [SerializeField] private int historySize = 5; // 历史记录大小（用于平滑）
        
        // 状态历史
        private Queue<bool> squatHistory = new Queue<bool>();
        private bool isSquatting = false;
        private int squatCount = 0;
        
        // 事件
        public event System.Action OnSquatStart;
        public event System.Action OnSquatEnd;
        public event System.Action<int> OnSquatCountChanged;
        
        /// <summary>
        /// 当前是否在深蹲
        /// </summary>
        public bool IsSquatting => isSquatting;
        
        /// <summary>
        /// 深蹲计数
        /// </summary>
        public int SquatCount => squatCount;
        
        /// <summary>
        /// 检测深蹲（每帧调用）
        /// </summary>
        public void Detect(PoseData poseData)
        {
            if (poseData == null || !poseData.IsValid)
            {
                UpdateHistory(false);
                return;
            }
            
            // 计算左右膝盖角度
            float leftKneeAngle = poseData.CalculateAngle(
                PoseData.LEFT_HIP,
                PoseData.LEFT_KNEE,
                PoseData.LEFT_ANKLE
            );
            
            float rightKneeAngle = poseData.CalculateAngle(
                PoseData.RIGHT_HIP,
                PoseData.RIGHT_KNEE,
                PoseData.RIGHT_ANKLE
            );
            
            // 如果两个膝盖角度都有效，取平均值
            float avgKneeAngle = -1f;
            if (leftKneeAngle > 0 && rightKneeAngle > 0)
            {
                avgKneeAngle = (leftKneeAngle + rightKneeAngle) / 2f;
            }
            else if (leftKneeAngle > 0)
            {
                avgKneeAngle = leftKneeAngle;
            }
            else if (rightKneeAngle > 0)
            {
                avgKneeAngle = rightKneeAngle;
            }
            
            // 判断是否在深蹲
            bool currentSquat = false;
            if (avgKneeAngle > 0)
            {
                currentSquat = avgKneeAngle < squatAngleThreshold;
            }
            
            // 添加到历史记录
            UpdateHistory(currentSquat);
            
            // 平滑处理（多数投票）
            bool smoothedSquat = GetSmoothedState();
            
            // 状态变化检测
            if (smoothedSquat && !isSquatting)
            {
                // 开始深蹲
                isSquatting = true;
                OnSquatStart?.Invoke();
                Debug.Log("深蹲开始");
            }
            else if (!smoothedSquat && isSquatting)
            {
                // 结束深蹲
                isSquatting = false;
                squatCount++;
                OnSquatEnd?.Invoke();
                OnSquatCountChanged?.Invoke(squatCount);
                Debug.Log($"深蹲结束，计数: {squatCount}");
            }
        }
        
        private void UpdateHistory(bool isSquat)
        {
            squatHistory.Enqueue(isSquat);
            if (squatHistory.Count > historySize)
            {
                squatHistory.Dequeue();
            }
        }
        
        private bool GetSmoothedState()
        {
            if (squatHistory.Count == 0) return false;
            
            int squatCount = 0;
            foreach (var state in squatHistory)
            {
                if (state) squatCount++;
            }
            
            // 多数投票
            return squatCount > squatHistory.Count / 2;
        }
        
        /// <summary>
        /// 重置计数
        /// </summary>
        public void ResetCount()
        {
            squatCount = 0;
            squatHistory.Clear();
            isSquatting = false;
            OnSquatCountChanged?.Invoke(squatCount);
        }
    }
}
