# FitDungeon 快速开始指南

## 环境要求

- Flutter SDK >= 3.0.0
- Android SDK (API 21+)
- Android 设备（推荐）或模拟器
- 摄像头

## 步骤 1: 克隆项目

```bash
cd your-workspace
git clone <repo-url>
cd fit-dungeon
```

## 步骤 2: 安装依赖

```bash
flutter pub get
```

## 步骤 3: 连接设备

确保 Android 设备已开启 USB 调试，或启动 Android 模拟器。

```bash
# 查看已连接设备
flutter devices
```

## 步骤 4: 运行应用

```bash
flutter run
```

## 常见问题

### 摄像头权限

首次运行时需要授予摄像头权限。如果权限被拒绝，可以在系统设置中手动开启。

### ML Kit 模型下载

首次使用姿态检测时，ML Kit 会自动下载模型文件（约 10MB）。请确保网络连接正常。

### 性能问题

如果帧率较低，可以尝试：
1. 降低摄像头分辨率
2. 使用 release 模式运行：`flutter run --release`

## 打包 APK

```bash
flutter build apk --release
```

APK 文件位于：`build/app/outputs/flutter-apk/app-release.apk`

## 开发调试

### 查看日志

```bash
flutter logs
```

### 热重载

在运行时按 `r` 热重载，按 `R` 热重启。

### 调试模式

```bash
flutter run --debug
```
