LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := xmod_extension_stub

LOCAL_SRC_FILES := $(TARGET_ARCH_ABI)/lib$(LOCAL_MODULE).a
LOCAL_EXPORT_C_INCLUDES := ${LOCAL_PATH}/../../include

include $(PREBUILT_STATIC_LIBRARY)