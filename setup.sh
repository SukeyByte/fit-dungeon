#!/bin/bash
# FitDungeon 项目初始化脚本
# 在本地开发机器上运行此脚本

set -e

echo "🎮 FitDungeon 项目初始化"
echo "========================="

# 检查 Flutter 是否安装
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter 未安装"
    echo "请先安装 Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter 已安装: $(flutter --version | head -1)"

# 获取依赖
echo ""
echo "📦 获取依赖..."
flutter pub get

# 检查 Android SDK
echo ""
echo "🔍 检查 Android SDK..."
if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
    echo "⚠️  ANDROID_HOME 未设置"
    echo "请确保 Android SDK 已安装并设置环境变量"
fi

# 检查连接的设备
echo ""
echo "📱 检查设备..."
flutter devices

# 运行项目
echo ""
echo "🚀 准备运行项目..."
echo "运行以下命令启动应用:"
echo "  flutter run"
echo ""
echo "或打包 APK:"
echo "  flutter build apk --release"
