import 'package:camera/camera.dart';

/// 摄像头服务
/// 负责管理摄像头生命周期和图像流
class CameraService {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  
  /// 获取可用的摄像头列表
  Future<List<CameraDescription>> getAvailableCameras() async {
    _cameras ??= await availableCameras();
    return _cameras!;
  }
  
  /// 初始化摄像头
  /// [resolution] 分辨率
  /// [onImageAvailable] 图像回调
  Future<CameraController> initializeCamera({
    ResolutionPreset resolution = ResolutionPreset.high,
    Function(CameraImage)? onImageAvailable,
  }) async {
    final cameras = await getAvailableCameras();
    
    if (cameras.isEmpty) {
      throw Exception('没有可用的摄像头');
    }
    
    // 优先使用后置摄像头
    final camera = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    
    _controller = CameraController(
      camera,
      resolution,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21,
    );
    
    await _controller!.initialize();
    
    if (onImageAvailable != null) {
      await _controller!.startImageStream(onImageAvailable);
    }
    
    return _controller!;
  }
  
  /// 获取当前摄像头控制器
  CameraController? get controller => _controller;
  
  /// 是否已初始化
  bool get isInitialized => _controller?.value.isInitialized ?? false;
  
  /// 释放资源
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }
}
