#!/bin/bash
# @Author  Irvin Pang @ XXTeam
# @Repo    https://github.com/xxzhushou

# 配置各种目录路径
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
XMOD_ROOT="$DIR/.."

# 检查是否存在 ANDROID_NDK_ROOT 环境变量
[ $ANDROID_NDK_ROOT ] || echo "define 'ANDROID_NDK_ROOT' for your own Android NDK location."
[ $ANDROID_NDK_ROOT ] || exit 1

NDK_BUILD_PATH="$ANDROID_NDK_ROOT"/ndk-build
# Windows下使用ndk-build.cmd
if [ -f ${NDK_BUILD_PATH}.cmd ]; then
	NDK_BUILD_PATH=${NDK_BUILD_PATH}.cmd
fi

BUILD_FLAG_DEBUG=0
BUILD_FLAG_REBUILD=""

# 检查输入参数
while getopts "fdrm:" opt; do
	case $opt in
		f)	BUILD_FLAG_REBUILD="-B" ;;
		d)	BUILD_FLAG_DEBUG=1 ;;
		r)	BUILD_FLAG_DEBUG=0 ;;
		m)  BUILD_MODULE="$OPTARG" ;;
		?) echo "usage: [-fdr] -m <module>"; exit 1 ;;
	esac
done

source $XMOD_ROOT/modules/$BUILD_MODULE/proj.android/build_config.sh
if [ ! $? -eq 0 ]; then
	echo "[ERROR] module '"$BUILD_MODULE"' not found!"
	exit 1
fi

if [ $BUILD_FLAG_DEBUG == 1 ]; then
	echo "[WARN] building $BUILD_MODULE under DEBUG mode"
fi

# 使用NDK编译native代码
TMP_OUTPUT="$XMOD_ROOT"/modules/$BUILD_MODULE/proj.android/ndkBuild
DEST_OUTPUT="$XMOD_ROOT"/output/android/$BUILD_MODULE
"$NDK_BUILD_PATH" \
	-j8 \
	$BUILD_FLAG_REBUILD \
	NDK_DEBUG=$BUILD_FLAG_DEBUG \
	NDK_MODULE_PATH=$NDK_MODULE_PATH \
	NDK_PROJECT_PATH=$TMP_OUTPUT APP_BUILD_SCRIPT=$APP_BUILD_SCRIPT NDK_APPLICATION_MK=$NDK_APPLICATION_MK

# 检查编译结果
if [ $? -eq 0 ]; then
	mkdir -p $DEST_OUTPUT >/dev/null 2>&1
	cp $TMP_OUTPUT/libs/armeabi-v7a/*.so $DEST_OUTPUT/lib${BUILD_MODULE}_armeabi-v7a.so
	cp $TMP_OUTPUT/libs/x86/*.so $DEST_OUTPUT/lib${BUILD_MODULE}_x86.so
	echo "[SUCCEED] check $DEST_OUTPUT for libraries"
else
	echo "[ERROR] failed to compile $BUILD_MODULE"
fi
