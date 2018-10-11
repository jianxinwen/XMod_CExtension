# @Author  Irvin Pang @ XXTeam
# @E-mail  halo.irvin@gmail.com

MODULE_LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

# 模块名
LOCAL_MODULE := xmod_module_unzip

# 头文件搜索路径列表
LOCAL_C_INCLUDES := $(MODULE_LOCAL_PATH)/../classes

# 编译源码列表
LOCAL_SRC_FILES := $(MODULE_LOCAL_PATH)/../classes/ioapi.c \
                   $(MODULE_LOCAL_PATH)/../classes/unzip.c \
                   $(MODULE_LOCAL_PATH)/../classes/lua_unzip.cpp

# 必要宏定义
LOCAL_CFLAGS := -DUSE_FILE32API

# 静态库依赖
LOCAL_STATIC_LIBRARIES := xmod_extension_stub
# NDK库依赖
LOCAL_LDLIBS := -llog -lz

include $(BUILD_SHARED_LIBRARY)

# 引用xmod_extension_stub
$(call import-module, android)
