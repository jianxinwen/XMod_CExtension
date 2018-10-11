#!/bin/bash
# @Author  Irvin Pang @ XXTeam
# @E-mail  halo.irvin@gmail.com

# 配置各种目录路径
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

NDK_MODULE_PATH="${XMOD_ROOT}/prebuilt"
APP_BUILD_SCRIPT="$DIR/unzip_config.mk"
NDK_APPLICATION_MK="$DIR/ndk_config.mk"
