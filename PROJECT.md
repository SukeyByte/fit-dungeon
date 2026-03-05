# FitDungeon - 双人健身肉鸽游戏

## 项目概述

**类型**: 本地双人协作肉鸽游戏  
**平台**: Android App  
**时长**: 每局约 40 分钟  
**风格**: 像素风  
**核心玩法**: 通过摄像头识别健身动作进行战斗

---

## 技术方案

| 组件 | 方案 |
|-----|------|
| 游戏引擎 | **Unity 2022 LTS** |
| 渲染管线 | 2D URP (Universal Render Pipeline) |
| 摄像头 | WebCamTexture |
| 姿态识别 | MediaPipe Unity Plugin / Nuitrack |
| 版本控制 | Git + GitHub |

---

## 为什么选择 Unity

1. **专业游戏引擎** — 粒子效果、动画、物理引擎内置
2. **像素游戏友好** — Pixel Perfect Camera、2D Tilemap
3. **摄像头简单** — `WebCamTexture` 一行代码搞定
4. **资源丰富** — Unity Asset Store 大量免费素材
5. **打包方便** — 直接导出 APK

---

## 核心功能

### 动作识别
| 动作 | 游戏效果 | 难度 |
|-----|---------|------|
| 深蹲 | 蓄力重击 | ⭐ |
| 开合跳 | AOE 攻击 | ⭐⭐ |
| 高抬腿 | 快速连击 | ⭐⭐ |
| 弓步 | 防御姿态 | ⭐ |
| 侧蹲 | 闪避 | ⭐⭐ |
| 空中拳击 | 远程攻击 | ⭐ |

### 游戏流程
```
[地牢入口] → [房间1: 小怪] → [休息30s] → [房间2: 精英] → [休息30s] → [房间3: 宝箱] → ... → [BOSS]
```

### 双人机制
- 两人同屏，分左右区域识别
- 协作打怪，一人攻击一人防御
- 每 2 分钟可切换角色

### 休息机制
- 每房间战斗后强制休息 30-60 秒
- 显示心率建议
- 喝水提醒

---

## 验收标准

### v0.1 - 原型验证 (Unity)
- [ ] Unity 项目搭建完成
- [ ] 摄像头能正常开启并显示
- [ ] 能识别人体姿态（MediaPipe）
- [ ] 深蹲动作识别准确率 > 70%
- [ ] 像素小人能显示
- [ ] 做深蹲时小人能做出攻击动作

### v0.2 - 双人识别
- [ ] 能同时识别两个人
- [ ] 左右区域分割正确
- [ ] 动作识别准确率 > 80%

### v0.3 - 战斗系统
- [ ] 基础战斗逻辑
- [ ] 怪物 AI
- [ ] 血量系统
- [ ] 至少 3 种动作攻击

### v0.4 - 肉鸽元素
- [ ] 随机房间生成
- [ ] 随机怪物组合
- [ ] 装备掉落系统
- [ ] 技能系统

### v0.5 - 完整游戏
- [ ] 完整一局游戏流程（40分钟）
- [ ] Boss 战
- [ ] 存档系统
- [ ] 音效和音乐

### v1.0 - 发布版
- [ ] 所有功能完整
- [ ] 性能优化
- [ ] 无重大 Bug
- [ ] 美术资源完善

---

## 里程碑时间表

| 版本 | 目标时间 | 状态 |
|-----|---------|------|
| v0.1 | 3 天内 | 🔄 进行中 (Unity) |
| v0.2 | 1 周内 | ⏳ 待开始 |
| v0.3 | 2 周内 | ⏳ 待开始 |
| v0.4 | 3 周内 | ⏳ 待开始 |
| v0.5 | 1 个月内 | ⏳ 待开始 |
| v1.0 | 2 个月内 | ⏳ 待开始 |

---

## Unity 项目结构

```
Assets/
├── Scenes/
│   ├── MainMenu.unity
│   └── Game.unity
├── Scripts/
│   ├── Camera/
│   │   └── WebcamController.cs
│   ├── Pose/
│   │   ├── PoseDetector.cs
│   │   └── SquatDetector.cs
│   ├── Game/
│   │   ├── PlayerController.cs
│   │   ├── EnemyController.cs
│   │   └── CombatSystem.cs
│   └── UI/
│       └── GameUI.cs
├── Sprites/
│   ├── Characters/
│   ├── Enemies/
│   └── Effects/
├── Prefabs/
│   ├── Player.prefab
│   └── Enemy.prefab
└── Plugins/
    └── MediaPipe/
```

---

## 开发流程

1. **每 30 分钟检查进度**
2. **每个可验收版本完成后**:
   - 测试功能
   - 打包 APK
   - 上传到 GitHub Releases
   - 更新验收文档

3. **定期 commit**:
   - 每完成一个小功能
   - 每次重要修改
   - 每次测试通过

---

## 相关链接

- GitHub 仓库: https://github.com/SukeyByte/fit-dungeon
- 设计文档: ./ACCEPTANCE.md
- 进度日志: ./PROGRESS.md
