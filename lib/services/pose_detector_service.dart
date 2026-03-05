import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../models/pose_data.dart';

/// 姿态检测服务
/// 使用 Google ML Kit 进行人体姿态检测
class PoseDetectorService {
  late final PoseDetector _poseDetector;
  
  PoseDetectorService() {
    // 配置姿态检测器
    // 使用基础模式（更快）
    final options = PoseDetectorOptions(
      model: PoseDetectionModel.base,
      mode: PoseDetectionMode.stream,
    );
    
    _poseDetector = PoseDetector(options: options);
  }
  
  /// 从摄像头图像检测姿态
  Future<PoseData?> detectPoseFromCameraImage(CameraImage image) async {
    try {
      // 将 CameraImage 转换为 InputImage
      final inputImage = _convertToInputImage(image);
      
      if (inputImage == null) return null;
      
      // 检测姿态
      final poses = await _poseDetector.processImage(inputImage);
      
      if (poses.isEmpty) return null;
      
      // 返回第一个检测到的人体姿态
      return PoseData.fromPose(poses.first);
      
    } catch (e) {
      debugPrint('姿态检测错误: $e');
      return null;
    }
  }
  
  /// 将 CameraImage 转换为 InputImage
  InputImage? _convertToInputImage(CameraImage image) {
    // 获取图像旋转角度
    // 注意：实际设备上需要从 DeviceOrientation 获取
    final cameraRotation = InputImageRotation.rotation0deg;
    
    // 根据图像格式创建 InputImage
    final plane = image.planes.first;
    
    // NV21 格式（Android 默认）
    return InputImage.fromBytes(
      bytes: _concatenatePlanes(image.planes),
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: cameraRotation,
        format: InputImageFormat.nv21,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }
  
  /// 合并图像平面数据
  Uint8List _concatenatePlanes(List<Plane> planes) {
    final buffer = <int>[];
    
    for (final plane in planes) {
      buffer.addAll(plane.bytes);
    }
    
    return Uint8List.fromList(buffer);
  }
  
  /// 释放资源
  void dispose() {
    _poseDetector.close();
  }
}
