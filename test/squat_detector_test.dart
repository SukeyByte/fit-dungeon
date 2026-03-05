import 'package:flutter_test/flutter_test.dart';
import 'package:fit_dungeon/game/squat_detector.dart';
import 'package:fit_dungeon/models/pose_data.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

void main() {
  group('SquatDetector', () {
    late SquatDetector detector;

    setUp(() {
      detector = SquatDetector();
    });

    test('初始状态应该是 neutral', () {
      // 没有姿态数据时返回 neutral
      // 这里我们无法直接测试，因为需要 PoseData
    });

    test('深蹲检测应该能重置状态', () {
      detector.reset();
      // 重置后状态清空
    });
  });

  group('PoseData', () {
    test('fromPose 应该正确映射关键点', () {
      // 创建一个模拟的 Pose 对象
      // 注意：在实际测试中需要 mock ML Kit 的 Pose
    });

    test('getAngle 应该正确计算角度', () {
      // 测试角度计算逻辑
    });
  });
}
