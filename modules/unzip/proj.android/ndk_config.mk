# @Author  Irvin Pang @ XXTeam
# @E-mail  halo.irvin@gmail.com

APP_ABI := armeabi-v7a x86
APP_STL := c++_static

WARN_FLAGS := -Wno-format-security -Wno-array-bounds -Wno-string-plus-int -Wno-varargs
C_FLAGS := -fsigned-char
CPP_FLAGS := -fsigned-char -std=c++11 -fexceptions

# 'APP_CFLAGS' apply to all C/C++ codes
APP_CFLAGS := $(WARN_FLAGS) $(C_FLAGS)
APP_CPPFLAGS := $(WARN_FLAGS) $(CPP_FLAGS)

APP_DEBUG := $(strip $(NDK_DEBUG))
ifeq ($(APP_DEBUG),1)
	APP_OPTIM := debug
else
	APP_OPTIM := release
endif

APP_PLATFORM := android-19
NDK_TOOLCHAIN_VERSION := clang
