import 'package:flutter/material.dart';

/// 主页屏幕 - 游戏入口
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade900,
              Colors.deepPurple.shade700,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 游戏标题
              const Spacer(flex: 2),
              
              // 像素风标题
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.amber, Colors.orange, Colors.deepOrange],
                ).createShader(bounds),
                child: const Text(
                  'FIT\nDUNGEON',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 8,
                    height: 1.2,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                '双人健身肉鸽游戏',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  letterSpacing: 4,
                ),
              ),
              
              const Spacer(flex: 2),
              
              // 像素小人装饰
              _buildPixelCharacter(),
              
              const Spacer(flex: 1),
              
              // 开始按钮
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: ElevatedButton(
                  onPressed: () => _startGame(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    '开始冒险',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 版本信息
              Text(
                'v0.1.0 原型',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  /// 简单的像素小人装饰
  Widget _buildPixelCharacter() {
    return CustomPaint(
      size: const Size(80, 100),
      painter: _PixelCharacterPainter(),
    );
  }

  /// 开始游戏
  void _startGame(BuildContext context) {
    Navigator.of(context).pushNamed('/game');
  }
}

/// 像素小人绘制器
class _PixelCharacterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    
    // 简单的像素小人 (8x10 像素网格)
    const pixelSize = 8.0;
    
    // 头部 (3x3)
    _drawPixel(canvas, paint, 2, 0, pixelSize);
    _drawPixel(canvas, paint, 3, 0, pixelSize);
    _drawPixel(canvas, paint, 4, 0, pixelSize);
    _drawPixel(canvas, paint, 2, 1, pixelSize);
    _drawPixel(canvas, paint, 4, 1, pixelSize);
    _drawPixel(canvas, paint, 2, 2, pixelSize);
    _drawPixel(canvas, paint, 3, 2, pixelSize);
    _drawPixel(canvas, paint, 4, 2, pixelSize);
    
    // 身体 (2x3)
    paint.color = Colors.amber;
    _drawPixel(canvas, paint, 3, 3, pixelSize);
    _drawPixel(canvas, paint, 3, 4, pixelSize);
    _drawPixel(canvas, paint, 3, 5, pixelSize);
    
    // 手臂
    paint.color = Colors.white;
    _drawPixel(canvas, paint, 2, 4, pixelSize);
    _drawPixel(canvas, paint, 4, 4, pixelSize);
    
    // 腿部
    _drawPixel(canvas, paint, 2, 6, pixelSize);
    _drawPixel(canvas, paint, 4, 6, pixelSize);
    _drawPixel(canvas, paint, 2, 7, pixelSize);
    _drawPixel(canvas, paint, 4, 7, pixelSize);
    _drawPixel(canvas, paint, 1, 8, pixelSize);
    _drawPixel(canvas, paint, 5, 8, pixelSize);
  }

  void _drawPixel(Canvas canvas, Paint paint, int x, int y, double size) {
    canvas.drawRect(
      Rect.fromLTWH(x * size, y * size, size, size),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
