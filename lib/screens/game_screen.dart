import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/pose_detector_service.dart';
import '../services/camera_service.dart';
import '../game/pixel_character.dart';
import '../game/squat_detector.dart';
import '../models/pose_data.dart';

/// 游戏主屏幕
class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isPermissionGranted = false;
  String? _errorMessage;
  
  // 姿态检测
  PoseDetectorService? _poseDetectorService;
  PoseData? _currentPose;
  
  // 深蹲检测
  final SquatDetector _squatDetector = SquatDetector();
  int _squatCount = 0;
  bool _isSquatting = false;
  
  // 游戏状态
  String _characterState = 'idle';
  double _attackAnimation = 0;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  /// 初始化游戏
  Future<void> _initializeGame() async {
    // 1. 请求权限
    final permissionStatus = await Permission.camera.request();
    
    if (permissionStatus.isGranted) {
      setState(() {
        _isPermissionGranted = true;
      });
      
      // 2. 初始化姿态检测服务
      _poseDetectorService = PoseDetectorService();
      
      // 3. 初始化摄像头
      await _initializeCamera();
    } else {
      setState(() {
        _errorMessage = '需要摄像头权限才能运行游戏';
      });
    }
  }

  /// 初始化摄像头
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = '没有找到可用的摄像头';
        });
        return;
      }

      // 使用后置摄像头（通常更适合健身场景）
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21, // Android 默认格式
      );

      await _cameraController!.initialize();
      
      setState(() {
        _isCameraInitialized = true;
      });

      // 开始图像流进行姿态检测
      _cameraController!.startImageStream(_processCameraImage);
      
    } catch (e) {
      setState(() {
        _errorMessage = '摄像头初始化失败: $e';
      });
    }
  }

  /// 处理摄像头图像
  void _processCameraImage(CameraImage image) async {
    if (_poseDetectorService == null) return;
    
    try {
      // 检测姿态
      final pose = await _poseDetectorService!.detectPoseFromCameraImage(image);
      
      if (pose != null && mounted) {
        // 检测深蹲
        final squatState = _squatDetector.detectSquat(pose);
        
        setState(() {
          _currentPose = pose;
          
          // 深蹲状态更新
          if (squatState == SquatState.down && !_isSquatting) {
            _isSquatting = true;
            _characterState = 'charging';
          } else if (squatState == SquatState.up && _isSquatting) {
            _isSquatting = false;
            _squatCount++;
            _characterState = 'attack';
            _attackAnimation = 1.0;
          } else if (squatState == SquatState.neutral) {
            if (!_isSquatting && _attackAnimation <= 0) {
              _characterState = 'idle';
            }
          }
          
          // 攻击动画衰减
          if (_attackAnimation > 0) {
            _attackAnimation -= 0.05;
            if (_attackAnimation <= 0) {
              _attackAnimation = 0;
            }
          }
        });
      }
    } catch (e) {
      // 静默处理检测错误
      debugPrint('姿态检测错误: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _poseDetectorService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 摄像头预览
          _buildCameraPreview(),
          
          // 游戏界面叠加
          _buildGameOverlay(),
          
          // 错误提示
          if (_errorMessage != null)
            _buildErrorMessage(),
          
          // 加载提示
          if (!_isCameraInitialized && _errorMessage == null)
            _buildLoadingIndicator(),
        ],
      ),
    );
  }

  /// 构建摄像头预览
  Widget _buildCameraPreview() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Container(color: Colors.black);
    }

    return Transform.scale(
      scaleX: -1, // 镜像显示
      child: CameraPreview(_cameraController!),
    );
  }

  /// 构建游戏叠加层
  Widget _buildGameOverlay() {
    return SafeArea(
      child: Column(
        children: [
          // 顶部状态栏
          _buildTopBar(),
          
          const Spacer(),
          
          // 像素小人区域
          _buildCharacterArea(),
          
          const Spacer(),
          
          // 底部信息栏
          _buildBottomBar(),
        ],
      ),
    );
  }

  /// 顶部状态栏
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          // 返回按钮
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          
          const Spacer(),
          
          // 深蹲计数
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.fitness_center, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  '深蹲: $_squatCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 角色显示区域
  Widget _buildCharacterArea() {
    return Center(
      child: SizedBox(
        width: 200,
        height: 250,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 像素小人
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              transform: Matrix4.identity()
                ..translate(_characterState == 'attack' ? 20.0 * _attackAnimation : 0.0),
              child: CustomPaint(
                size: const Size(120, 160),
                painter: PixelCharacterPainter(
                  state: _characterState,
                  attackProgress: _attackAnimation,
                ),
              ),
            ),
            
            // 攻击特效
            if (_attackAnimation > 0)
              Positioned(
                right: 0,
                child: Opacity(
                  opacity: _attackAnimation,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.orange.withOpacity(_attackAnimation),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 底部信息栏
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          // 当前状态
          Text(
            _getStatusText(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 姿态检测状态
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _currentPose != null ? Icons.check_circle : Icons.circle_outlined,
                color: _currentPose != null ? Colors.green : Colors.grey,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                _currentPose != null ? '姿态检测中...' : '等待检测人体...',
                style: TextStyle(
                  color: _currentPose != null ? Colors.green : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 获取状态文本
  String _getStatusText() {
    switch (_characterState) {
      case 'idle':
        return '准备就绪 - 开始做深蹲吧！';
      case 'charging':
        return '蓄力中...保持姿势！';
      case 'attack':
        return '💥 攻击！';
      default:
        return '准备就绪';
    }
  }

  /// 错误提示
  Widget _buildErrorMessage() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? '发生错误',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('返回'),
            ),
          ],
        ),
      ),
    );
  }

  /// 加载提示
  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Colors.amber),
          SizedBox(height: 16),
          Text(
            '正在初始化摄像头...',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
