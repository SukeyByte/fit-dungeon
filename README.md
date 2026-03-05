# FitDungeon - 双人健身肉鸽游戏

通过摄像头识别健身动作进行战斗的本地双人协作肉鸽游戏。

🎮 **Unity 2022 LTS** | 📱 Android | 🦞 像素风

## 项目状态

🚧 开发中 - v0.1 原型验证阶段

## 核心功能

- 📷 摄像头实时捕捉
- 🏋️ 姿态识别（深蹲、开合跳等）
- ⚔️ 双人协作战斗
- 🎲 肉鸽元素（随机房间、装备、技能）
- 🕹️ 像素风格

## 技术栈

| 组件 | 方案 |
|-----|------|
| 游戏引擎 | Unity 2022 LTS |
| 渲染管线 | 2D URP |
| 摄像头 | WebCamTexture |
| 姿态识别 | MediaPipe Unity Plugin |
| 平台 | Android |

## 项目结构

```
Assets/
├── Scenes/           # 游戏场景
├── Scripts/
│   ├── Camera/       # 摄像头控制
│   ├── Pose/         # 姿态识别
│   ├── Game/         # 游戏逻辑
│   └── UI/           # 界面
├── Sprites/          # 像素素材
├── Prefabs/          # 预制体
└── Plugins/          # MediaPipe 插件
```

## 已完成的脚本

| 脚本 | 功能 |
|-----|------|
| `WebcamController.cs` | 摄像头开启/关闭/帧获取 |
| `PoseData.cs` | 姿态数据结构（33个关键点） |
| `SquatDetector.cs` | 深蹲检测（膝盖角度分析） |
| `PixelCharacterController.cs` | 像素角色控制（攻击动画） |
| `GameManager.cs` | 游戏协调器 |

## 开发环境

1. 安装 Unity 2022 LTS
2. 安装 Android Build Support
3. 连接 Android 设备

## 运行项目

1. 用 Unity 打开项目
2. 打开 `Assets/Scenes/Game.unity`
3. File > Build Settings > Android
4. Build & Run

## 深蹲识别原理

1. MediaPipe 检测人体 33 个关键点
2. 计算膝盖弯曲角度（髋-膝-踝三点夹角）
3. 角度 < 100° 判定为下蹲
4. 角度 > 150° 判定为站立
5. 使用历史状态平滑，减少抖动

## 下一步计划

- [ ] 创建 Unity 场景
- [ ] 集成 MediaPipe
- [ ] 制作像素角色素材
- [ ] 真机测试

## 文档

- [项目概述](PROJECT.md)
- [验收标准](ACCEPTANCE.md)
- [开发进度](PROGRESS.md)

## License

MIT

---

Made with 🦞 by SukeyByte
