import 'dart:ui';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// 姿态数据模型
/// 封装 ML Kit 的姿态检测结果
class PoseData {
  /// 所有关键点
  final Map<PoseLandmarkType, PoseLandmarkData> landmarks;
  
  /// 图像尺寸（用于归一化）
  final Size imageSize;
  
  PoseData({
    required this.landmarks,
    required this.imageSize,
  });
  
  /// 从 ML Kit Pose 创建
  factory PoseData.fromPose(Pose pose, [Size imageSize = const Size(1, 1)]) {
    final landmarks = <PoseLandmarkType, PoseLandmarkData>{};
    
    // 映射所有关键点
    for (final type in PoseLandmarkType.values) {
      final landmark = pose.landmarks[type];
      if (landmark != null) {
        landmarks[type] = PoseLandmarkData(
          x: landmark.x,
          y: landmark.y,
          z: landmark.z,
          likelihood: landmark.likelihood,
        );
      }
    }
    
    return PoseData(landmarks: landmarks, imageSize: imageSize);
  }
  
  /// 获取指定关键点
  PoseLandmarkData? getLandmark(PoseLandmarkType type) => landmarks[type];
  
  /// 获取归一化的关键点坐标 (0-1)
  Offset? getNormalizedPosition(PoseLandmarkType type) {
    final landmark = landmarks[type];
    if (landmark == null || imageSize == Size.zero) return null;
    
    return Offset(
      landmark.x / imageSize.width,
      landmark.y / imageSize.height,
    );
  }
  
  /// 检查关键点是否有效
  bool hasLandmark(PoseLandmarkType type) {
    final landmark = landmarks[type];
    return landmark != null && landmark.likelihood > 0.5;
  }
  
  // 常用关键点便捷访问器
  
  PoseLandmarkData? get nose => getLandmark(PoseLandmarkType.nose);
  PoseLandmarkData? get leftShoulder => getLandmark(PoseLandmarkType.leftShoulder);
  PoseLandmarkData? get rightShoulder => getLandmark(PoseLandmarkType.rightShoulder);
  PoseLandmarkData? get leftElbow => getLandmark(PoseLandmarkType.leftElbow);
  PoseLandmarkData? get rightElbow => getLandmark(PoseLandmarkType.rightElbow);
  PoseLandmarkData? get leftWrist => getLandmark(PoseLandmarkType.leftWrist);
  PoseLandmarkData? get rightWrist => getLandmark(PoseLandmarkType.rightWrist);
  PoseLandmarkData? get leftHip => getLandmark(PoseLandmarkType.leftHip);
  PoseLandmarkData? get rightHip => getLandmark(PoseLandmarkType.rightHip);
  PoseLandmarkData? get leftKnee => getLandmark(PoseLandmarkType.leftKnee);
  PoseLandmarkData? get rightKnee => getLandmark(PoseLandmarkType.rightKnee);
  PoseLandmarkData? get leftAnkle => getLandmark(PoseLandmarkType.leftAnkle);
  PoseLandmarkData? get rightAnkle => getLandmark(PoseLandmarkType.rightAnkle);
  
  /// 计算两个关键点之间的角度
  double? getAngle(
    PoseLandmarkType first,
    PoseLandmarkType mid,
    PoseLandmarkType last,
  ) {
    final firstPoint = landmarks[first];
    final midPoint = landmarks[mid];
    final lastPoint = landmarks[last];
    
    if (firstPoint == null || midPoint == null || lastPoint == null) {
      return null;
    }
    
    // 计算向量
    final vector1 = Offset(
      firstPoint.x - midPoint.x,
      firstPoint.y - midPoint.y,
    );
    final vector2 = Offset(
      lastPoint.x - midPoint.x,
      lastPoint.y - midPoint.y,
    );
    
    // 计算角度
    final dot = vector1.dx * vector2.dx + vector1.dy * vector2.dy;
    final mag1 = vector1.distance;
    final mag2 = vector2.distance;
    
    if (mag1 == 0 || mag2 == 0) return null;
    
    final cos = (dot / (mag1 * mag2)).clamp(-1.0, 1.0);
    return (180 / 3.14159) * acos(cos);
  }
}

/// 关键点数据
class PoseLandmarkData {
  final double x;
  final double y;
  final double z;
  final double likelihood;
  
  PoseLandmarkData({
    required this.x,
    required this.y,
    required this.z,
    required this.likelihood,
  });
  
  Offset get position => Offset(x, y);
}
