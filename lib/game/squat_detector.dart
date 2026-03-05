import '../models/pose_data.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// 深蹲状态
enum SquatState {
  neutral,  // 中立状态
  down,     // 下蹲中
  up,       // 起立中
}

/// 深蹲检测器
/// 通过分析膝盖和髋部角度来检测深蹲动作
class SquatDetector {
  // 深蹲阈值（角度）
  static const double _squatDownThreshold = 120;  // 膝盖角度小于此值为下蹲
  static const double _squatUpThreshold = 160;    // 膝盖角度大于此值为站立
  
  // 历史状态（用于平滑检测）
  final List<SquatState> _stateHistory = [];
  static const int _historySize = 5;
  
  /// 检测深蹲动作
  SquatState detectSquat(PoseData pose) {
    // 获取左右膝盖角度
    final leftKneeAngle = pose.getAngle(
      PoseLandmarkType.leftHip,
      PoseLandmarkType.leftKnee,
      PoseLandmarkType.leftAnkle,
    );
    
    final rightKneeAngle = pose.getAngle(
      PoseLandmarkType.rightHip,
      PoseLandmarkType.rightKnee,
      PoseLandmarkType.rightAnkle,
    );
    
    // 需要至少一个膝盖角度有效
    if (leftKneeAngle == null && rightKneeAngle == null) {
      return SquatState.neutral;
    }
    
    // 使用平均值（如果两边都有效）
    double avgKneeAngle;
    if (leftKneeAngle != null && rightKneeAngle != null) {
      avgKneeAngle = (leftKneeAngle + rightKneeAngle) / 2;
    } else {
      avgKneeAngle = leftKneeAngle ?? rightKneeAngle!;
    }
    
    // 判断状态
    SquatState newState;
    if (avgKneeAngle < _squatDownThreshold) {
      newState = SquatState.down;
    } else if (avgKneeAngle > _squatUpThreshold) {
      newState = SquatState.up;
    } else {
      newState = SquatState.neutral;
    }
    
    // 添加到历史记录
    _stateHistory.add(newState);
    if (_stateHistory.length > _historySize) {
      _stateHistory.removeAt(0);
    }
    
    // 平滑处理：返回历史中出现最多的状态
    return _getMostFrequentState();
  }
  
  /// 获取历史中出现最多的状态
  SquatState _getMostFrequentState() {
    if (_stateHistory.isEmpty) return SquatState.neutral;
    
    final counts = <SquatState, int>{
      SquatState.neutral: 0,
      SquatState.down: 0,
      SquatState.up: 0,
    };
    
    for (final state in _stateHistory) {
      counts[state] = (counts[state] ?? 0) + 1;
    }
    
    // 找出出现次数最多的状态
    SquatState mostFrequent = SquatState.neutral;
    int maxCount = 0;
    
    for (final entry in counts.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        mostFrequent = entry.key;
      }
    }
    
    return mostFrequent;
  }
  
  /// 重置检测器状态
  void reset() {
    _stateHistory.clear();
  }
}
