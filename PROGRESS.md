# FitDungeon 开发进度

## 2026-03-05 23:37 UTC

### 项目启动
- ✅ 创建项目文档
- ✅ 定义验收标准
- ✅ 确定技术方案：Flutter + ML Kit + Flame

### v0.1 原型开发 (进行中)

#### 已完成
- ✅ 创建 Flutter 项目结构
- ✅ 配置 pubspec.yaml 依赖
  - google_mlkit_pose_detection
  - camera
  - permission_handler
  - flutter_riverpod
- ✅ 实现主页面 (HomeScreen)
  - 游戏标题
  - 开始按钮
  - 像素小人装饰
- ✅ 实现游戏页面 (GameScreen)
  - 摄像头权限请求
  - 摄像头预览
  - 姿态检测集成
  - 深蹲计数
  - 角色状态显示
- ✅ 姿态检测服务 (PoseDetectorService)
  - ML Kit Pose Detection 集成
  - CameraImage 转换
- ✅ 深蹲检测器 (SquatDetector)
  - 膝盖角度分析
  - 状态平滑处理
  - 阈值可配置
- ✅ 姿态数据模型 (PoseData)
  - 关键点封装
  - 角度计算
  - 便捷访问器
- ✅ 像素小人绘制 (PixelCharacterPainter)
  - 待机姿势
  - 蓄力姿势（下蹲）
  - 攻击姿势（含特效）
- ✅ Android 配置
  - 摄像头权限
  - ML Kit 依赖

#### 待完成
- [ ] 在真机上测试
- [ ] 调整深蹲检测阈值
- [ ] 优化性能
- [ ] 打包 APK

---

## 进度记录格式

```
### YYYY-MM-DD HH:MM
- 完成的工作
- 遇到的问题
- 下一步计划
```

---

## 版本历史

| 版本 | 日期 | 主要功能 | 状态 |
|-----|------|---------|------|
| v0.1 | 2026-03-05 | 原型验证 | 🔄 进行中 |
| v0.2 | - | 双人识别 | ⏳ |
| v0.3 | - | 战斗系统 | ⏳ |
| v0.4 | - | 肉鸽元素 | ⏳ |
| v0.5 | - | 完整游戏 | ⏳ |
| v1.0 | - | 正式发布 | ⏳ |
