#!/bin/bash
# @Author  Irvin Pang @ XXTeam
# @Repo    https://github.com/xxzhushou

# 配置各种目录路径
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
XMOD_ROOT="$DIR/.."

xcode_version=`xcodebuild -version | grep "Xcode "`
echo using $xcode_version ...

# 推荐先安装xcpretty, 优化xcodebuild的输出
has_xcpretty=`which xcpretty`
if [[ $has_xcpretty == '' ]]; then
	echo "[WARN] recommanded to run 'gem install xcpretty' first"
else
	echo using xcpretty `xcpretty -v` ...
fi
echo

BUILD_FLAG_DEBUG=Release

# 检查输入参数
while getopts "fdrm:" opt; do
	case $opt in
		d)	BUILD_FLAG_DEBUG=Debug ;;
		r)	BUILD_FLAG_DEBUG=Release ;;
		m)  BUILD_MODULE="$OPTARG" ;;
		?) echo "usage: [-dr] -m <module>"; exit 1 ;;
	esac
done

if [ $BUILD_FLAG_DEBUG == 1 ]; then
	echo "[WARN] building $BUILD_MODULE under DEBUG mode"
fi

BUILD_PROJ_PATH=$XMOD_ROOT/modules/$BUILD_MODULE/proj.ios/$BUILD_MODULE.xcodeproj
if [ ! -d $BUILD_PROJ_PATH ]; then
	echo "[ERROR] project $BUILD_MODULE.xcodeproj not found!"
	exit 1
fi

# 使用xcodebuild编译proj工程
TMP_OUTPUT="$XMOD_ROOT"/modules/$BUILD_MODULE/proj.ios/xcodeBuild
DEST_OUTPUT="$XMOD_ROOT"/output/ios/$BUILD_MODULE
if [[ $has_xcpretty != '' ]]; then
	xcodebuild CONFIGURATION_BUILD_DIR="$TMP_OUTPUT" -project "$BUILD_PROJ_PATH" -arch armv7 -arch arm64 -configuration $BUILD_FLAG_DEBUG | xcpretty
else
	xcodebuild CONFIGURATION_BUILD_DIR="$TMP_OUTPUT" -project "$BUILD_PROJ_PATH" -arch armv7 -arch arm64 -configuration $BUILD_FLAG_DEBUG
fi

# 检查编译结果
if [ $? -eq 0 ]; then
	echo
	mkdir -p $DEST_OUTPUT >/dev/null 2>&1
	cp $TMP_OUTPUT/*.dylib $DEST_OUTPUT/
	echo "[SUCCEED] check $DEST_OUTPUT for libraries"
else
	echo
	echo "[ERROR] failed to compile $BUILD_MODULE"
fi
