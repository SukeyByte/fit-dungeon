# FitDungeon - 双人健身肉鸽游戏

通过摄像头识别健身动作进行战斗的本地双人协作肉鸽游戏。

## v0.1 原型功能

- ✅ Flutter 项目基础架构
- ✅ 摄像头权限请求
- ✅ 摄像头实时预览
- ✅ Google ML Kit 姿态检测
- ✅ 深蹲动作识别
- ✅ 像素小人角色
- ✅ 深蹲触发攻击动画

## 技术栈

| 组件 | 方案 |
|-----|------|
| 框架 | Flutter |
| 姿态识别 | Google ML Kit Pose Detection |
| 状态管理 | Riverpod |
| 平台 | Android |

## 开发环境

1. 安装 Flutter SDK (>=3.0.0)
2. 安装 Android Studio
3. 连接 Android 设备或启动模拟器

## 运行项目

```bash
# 获取依赖
flutter pub get

# 运行到设备
flutter run

# 打包 APK
flutter build apk --release
```

## 项目结构

```
lib/
├── main.dart              # 应用入口
├── models/
│   └── pose_data.dart     # 姿态数据模型
├── screens/
│   ├── home_screen.dart   # 主页
│   └── game_screen.dart   # 游戏页面
├── services/
│   ├── camera_service.dart      # 摄像头服务
│   └── pose_detector_service.dart # 姿态检测服务
└── game/
    ├── pixel_character.dart  # 像素小人绘制
    └── squat_detector.dart   # 深蹲检测器
```

## 深蹲识别原理

1. ML Kit 检测人体 33 个关键点
2. 计算膝盖弯曲角度（髋-膝-踝三点夹角）
3. 角度 < 120° 判定为下蹲
4. 角度 > 160° 判定为站立
5. 使用历史状态平滑，减少抖动

## 下一步计划 (v0.2)

- [ ] 双人同时识别
- [ ] 画面左右区域分割
- [ ] 更多动作类型（开合跳、高抬腿等）
- [ ] 战斗系统原型

## License

MIT
