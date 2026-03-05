import 'package:flutter/material.dart';

/// 像素小人绘制器
/// 根据状态绘制不同动作的像素角色
class PixelCharacterPainter extends CustomPainter {
  final String state;
  final double attackProgress;
  
  PixelCharacterPainter({
    this.state = 'idle',
    this.attackProgress = 0,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // 像素大小
    const pixelSize = 8.0;
    
    // 根据状态选择颜色
    final skinColor = const Color(0xFFFFDBAC);
    final shirtColor = state == 'attack' 
        ? Colors.orange.shade600 
        : Colors.amber.shade600;
    final pantsColor = const Color(0xFF4169E1);
    final hairColor = const Color(0xFF8B4513);
    
    final paint = Paint();
    
    // 计算中心偏移
    final offsetX = (size.width - 8 * pixelSize) / 2;
    final offsetY = (size.height - 20 * pixelSize) / 2;
    
    canvas.save();
    canvas.translate(offsetX, offsetY);
    
    // 根据状态绘制不同姿势
    switch (state) {
      case 'idle':
        _drawIdlePose(canvas, paint, pixelSize, skinColor, shirtColor, pantsColor, hairColor);
        break;
      case 'charging':
        _drawChargingPose(canvas, paint, pixelSize, skinColor, shirtColor, pantsColor, hairColor);
        break;
      case 'attack':
        _drawAttackPose(canvas, paint, pixelSize, skinColor, shirtColor, pantsColor, hairColor, attackProgress);
        break;
      default:
        _drawIdlePose(canvas, paint, pixelSize, skinColor, shirtColor, pantsColor, hairColor);
    }
    
    canvas.restore();
  }
  
  /// 绘制待机姿势
  void _drawIdlePose(
    Canvas canvas, 
    Paint paint, 
    double ps,
    Color skinColor,
    Color shirtColor,
    Color pantsColor,
    Color hairColor,
  ) {
    // 头发
    paint.color = hairColor;
    _drawRect(canvas, paint, 2, 0, 4, 1, ps);
    
    // 头部
    paint.color = skinColor;
    _drawRect(canvas, paint, 2, 1, 4, 3, ps);
    
    // 眼睛
    paint.color = Colors.black;
    _drawPixel(canvas, paint, 2, 2, ps);
    _drawPixel(canvas, paint, 5, 2, ps);
    
    // 身体
    paint.color = shirtColor;
    _drawRect(canvas, paint, 2, 4, 4, 7, ps);
    
    // 手臂（下垂）
    paint.color = skinColor;
    _drawPixel(canvas, paint, 1, 5, ps);
    _drawPixel(canvas, paint, 1, 6, ps);
    _drawPixel(canvas, paint, 6, 5, ps);
    _drawPixel(canvas, paint, 6, 6, ps);
    
    // 腿部
    paint.color = pantsColor;
    _drawRect(canvas, paint, 2, 8, 3, 11, ps);
    _drawRect(canvas, paint, 4, 8, 5, 11, ps);
    
    // 脚
    paint.color = Colors.brown.shade800;
    _drawPixel(canvas, paint, 2, 11, ps);
    _drawPixel(canvas, paint, 4, 11, ps);
  }
  
  /// 绘制蓄力姿势（下蹲）
  void _drawChargingPose(
    Canvas canvas, 
    Paint paint, 
    double ps,
    Color skinColor,
    Color shirtColor,
    Color pantsColor,
    Color hairColor,
  ) {
    // 头发
    paint.color = hairColor;
    _drawRect(canvas, paint, 2, 2, 4, 3, ps);
    
    // 头部（向下移动）
    paint.color = skinColor;
    _drawRect(canvas, paint, 2, 3, 4, 5, ps);
    
    // 眼睛（用力表情）
    paint.color = Colors.black;
    _drawPixel(canvas, paint, 2, 4, ps);
    _drawPixel(canvas, paint, 5, 4, ps);
    
    // 身体（压缩）
    paint.color = shirtColor;
    _drawRect(canvas, paint, 2, 6, 4, 8, ps);
    
    // 手臂（握拳）
    paint.color = skinColor;
    _drawPixel(canvas, paint, 1, 6, ps);
    _drawPixel(canvas, paint, 6, 6, ps);
    
    // 腿部（弯曲）
    paint.color = pantsColor;
    _drawRect(canvas, paint, 1, 9, 3, 10, ps);
    _drawRect(canvas, paint, 4, 9, 6, 10, ps);
    
    // 脚
    paint.color = Colors.brown.shade800;
    _drawPixel(canvas, paint, 0, 10, ps);
    _drawPixel(canvas, paint, 6, 10, ps);
  }
  
  /// 绘制攻击姿势
  void _drawAttackPose(
    Canvas canvas, 
    Paint paint, 
    double ps,
    Color skinColor,
    Color shirtColor,
    Color pantsColor,
    Color hairColor,
    double progress,
  ) {
    // 头发
    paint.color = hairColor;
    _drawRect(canvas, paint, 2, 0, 4, 1, ps);
    
    // 头部
    paint.color = skinColor;
    _drawRect(canvas, paint, 2, 1, 4, 3, ps);
    
    // 眼睛（愤怒表情）
    paint.color = Colors.black;
    _drawPixel(canvas, paint, 2, 2, ps);
    _drawPixel(canvas, paint, 5, 2, ps);
    
    // 身体
    paint.color = shirtColor;
    _drawRect(canvas, paint, 2, 4, 4, 7, ps);
    
    // 手臂（向前伸出 - 攻击动作）
    paint.color = skinColor;
    // 右手向前
    _drawPixel(canvas, paint, 6, 4, ps);
    _drawPixel(canvas, paint, 7, 4, ps);
    // 根据攻击进度添加延伸效果
    if (progress > 0.5) {
      _drawPixel(canvas, paint, 8, 4, ps);
    }
    // 左手
    _drawPixel(canvas, paint, 1, 5, ps);
    
    // 武器效果（简单的剑）
    paint.color = Colors.grey.shade300;
    if (progress > 0.3) {
      _drawPixel(canvas, paint, 9, 3, ps);
      _drawPixel(canvas, paint, 9, 4, ps);
      _drawPixel(canvas, paint, 9, 5, ps);
    }
    
    // 腿部
    paint.color = pantsColor;
    _drawRect(canvas, paint, 2, 8, 3, 11, ps);
    _drawRect(canvas, paint, 4, 8, 5, 11, ps);
    
    // 脚
    paint.color = Colors.brown.shade800;
    _drawPixel(canvas, paint, 2, 11, ps);
    _drawPixel(canvas, paint, 4, 11, ps);
    
    // 攻击特效
    if (progress > 0.2) {
      paint.color = Colors.orange.withOpacity(progress);
      _drawPixel(canvas, paint, 10, 4, ps);
      paint.color = Colors.yellow.withOpacity(progress);
      _drawPixel(canvas, paint, 11, 3, ps);
      _drawPixel(canvas, paint, 11, 5, ps);
    }
  }
  
  /// 绘制单个像素
  void _drawPixel(Canvas canvas, Paint paint, int x, int y, double size) {
    canvas.drawRect(
      Rect.fromLTWH(x * size, y * size, size, size),
      paint,
    );
  }
  
  /// 绘制矩形区域
  void _drawRect(Canvas canvas, Paint paint, int x1, int y1, int x2, int y2, double size) {
    for (int x = x1; x <= x2; x++) {
      for (int y = y1; y <= y2; y++) {
        _drawPixel(canvas, paint, x, y, size);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant PixelCharacterPainter oldDelegate) {
    return oldDelegate.state != state || oldDelegate.attackProgress != attackProgress;
  }
}
