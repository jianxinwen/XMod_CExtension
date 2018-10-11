## C/C++扩展

### 前言

在阅读后续内容之前，需要确认开发者具备以下的基本技能：

* 一定的C/C++开发基础；
* 交叉编译（Cross-compilation）的基本原理和工具使用：
    + Android NDK的基本配置和用法；
    + iOS Xcode基本使用。

如果你有移动平台原生开发相关的经验，或者在其他平台有过Lua C扩展的开发经验，那么以下内容同样也适合你。

没有以上相关经验或技能，但有兴趣并决心学习的开发者也不要气馁，学习最好的时机是昨天，其次是今天。

### 准备工作

相关安装及部署细节和步骤本文~~懒得~~不宜详述，请各位善用搜索引擎解决问题。

#### Android

* 下载并解压[Android NDK](https://developer.android.com/ndk/downloads/)，最低要求r13b版本；
* 配置环境变量`ANDROID_NDK_ROOT`为NDK解压路径。

#### iOS

* 由于苹果自身的限制，iOS编译只能在macOS系统下进行；
* 需要Xcode 9及以上版本，并安装Command Line Tools for Xcode。

### API详解

XMod C/C++扩展工程可以在这里下载最新的配置文件和代码（附带例子）：[@xxzhushou/CExtension](https://github.com/xxzhushou/CExtension)

#### Lua虚拟机API

Lua虚拟机API定义在头文件[`LuaAPIStub53.h`](https://github.com/xxzhushou/CExtension/blob/master/include/LuaAPIStub53.h)中，叉叉引擎从2.0版本开始，使用Lua v5.3运行环境，扩展支持***除以下列表外***的所有公开Lua C API接口：

* **lua_dump**
* **lua_load**
* **lua_close**
* **lua_sethook**
* **luaL_newstate**
* **luaL_dofile**
* **luaL_dostring**
* **luaL_loadfile**
* **luaL_loadstring**
* **luaL_loadbuffer**

详细Lua 5.3 C API功能介绍请参阅官方文档：[Lua5.3 Reference Manual](https://www.lua.org/manual/5.3/)中的`C API`和`auxiliary library`部分。

#### Lua扩展API

Lua扩展API部分定义在头文件[`XModLuaAPIStub.h`](https://github.com/xxzhushou/CExtension/blob/master/include/XModLuaAPIStub.h)中，主要是针对XMod引擎内部的Lua扩展操作，目前有以下API：

* **void lua\_push\_xmod\_point(lua\_State* L, const xmod\_point& val)**

    将`xmod_point`的实例val压到当前Lua堆栈栈顶（对应Lua中`Point` usertype类型）。

* **void lua\_push\_xmod\_size(lua\_State* L, const xmod\_size& val)**

    将`xmod_size`的实例val压到当前Lua堆栈栈顶（对应Lua中`Size` usertype类型）。

* **void lua\_push\_xmod\_rect(lua\_State* L, const xmod\_rect& val)**

    将`xmod_rect`的实例val压到当前Lua堆栈栈顶（对应Lua中`Rect` usertype类型）。

* **void lua\_push\_xmod\_color3b(lua\_State* L, const xmod\_color3b& val)**

    将`xmod_color3b`的实例val压到当前Lua堆栈栈顶（对应Lua中`Color3b` usertype类型）。

* **void lua\_push\_xmod\_color3f(lua\_State* L, const xmod\_color3f& val)**

    将`xmod_color3f`的实例val压到当前Lua堆栈栈顶（对应Lua中`Color3f` usertype类型）。

* **void lua\_push\_xmod\_image(lua\_State* L, const xmod\_image& val)**

    将`xmod_image`的实例val压到当前Lua堆栈栈顶（对应Lua中`Image` usertype类型）。

* **xmod\_point lua\_to\_xmod\_point(lua\_State* L, int index)**

    将Lua栈对应index处位置的Lua对象（`Point` usertype类型）转换成`xmod_point`类型并返回。

* **xmod\_size lua\_to\_xmod\_size(lua\_State* L, int index)**

    将Lua栈对应index处位置的Lua对象（`Size` usertype类型）转换成`xmod_size`类型并返回。

* **xmod\_rect lua\_to\_xmod\_rect(lua\_State* L, int index)**

    将Lua栈对应index处位置的Lua对象（`Rect` usertype类型）转换成`xmod_rect`类型并返回。

* **xmod\_color3b lua\_to\_xmod\_color3b(lua\_State* L, int index)**

    将Lua栈对应index处位置的Lua对象（`Color3b` usertype类型）转换成`xmod_color3b`类型并返回。

* **xmod\_color3f lua\_to\_xmod\_color3f(lua\_State* L, int index)**

    将Lua栈对应index处位置的Lua对象（`Color3f` usertype类型）转换成`xmod_color3f`类型并返回。

* **xmod\_image* lua\_to\_xmod\_image(lua\_State* L, int index)**

    将Lua栈对应index处位置的Lua对象（`Image` usertype类型）转换成`xmod_image*`类型并返回。

* **void dispatch\_in\_lua\_thread(const std::function<void(lua\_State*)>& callback)**

    将C函数callback放到Lua主线程中执行，此函数可以在多线程环境下调用。

> 注意：由于Lua是基于栈进行数据交换的，除特殊说明，以上所有API均只能在Lua线程（默认触发线程）中调用，不能在其他线程调用，否则会引起不可控的报错甚至闪退。

#### XMod引擎API

* **void xmod\_get\_platform(char\*\* platform)**

    获取当前运行平台名，并写入到platform指针对应地址中，结果可能是"Android"或者"iOS"之一。

* **void xmod\_get\_version\_code(int* code)**

    获取XMod引擎版本号，并写入到code指针对应地址中。

* **void xmod\_get\_version\_name(char\*\* name)**

    获取XMod引擎版本名，并写入到name指针对应地址中。

* **void xmod\_get\_product\_code(XModProductCode* code)**

    获取当前运行产品代号，并写入到code指针对应地址中。

* **void xmod\_get\_process\_mode(XModProcessMode* mode)**

    获取当前运行模式，并写入到mode指针对应地址中，结果可能是：

    + kProcessStandalone：独立运行模式，脚本跟游戏分别在不同进程中运行（如开发助手的极客模式、叉叉小精灵等）；
    + kProcessEmbedded：内嵌运行模式，脚本跟游戏同属一个进程运行（如开发助手的通用模式、叉叉酷玩和IPA精灵等）。

* **void xmod\_get\_product\_name(char\*\* name)**

    获取当前产品名称，并写入到name指针对应地址中，结果可能是：

    + DEV：开发助手
    + XXZS：叉叉助手
    + IPA：IPA精灵（iOS）
    + KUWAN：叉叉酷玩（Android）
    + SPIRIT：叉叉小精灵（Android）

* **void xmod\_get\_public\_path(char\*\* path)**

    获取XMod引擎的公共目录路径，并写入到path指针对应地址中。

* **void xmod\_get\_private\_path(char\*\* path)**

    获取当前运行脚本的私有目录路径，并写入到path指针对应地址中。

* **void xmod\_get\_resolved\_path(const char* path, char\*\* outpath)**

    将伪目录path转换成完整路径，并写入到outpath指针对应地址中。

    > 例如传入参数path = "[public]test.png"，得到的outpath为公共目录路径下的test.png完整路径。

* **bool xmod\_script\_get\_id(int* id)**

    获取当前脚本运行ID，并写入到id指针对应的地址中；获取成功放回true，否则返回false。

    > 开发助手下运行获取得脚本ID固定为-1.

* **bool xmod\_script\_get\_user\_info(char\*\* uid, int* membership, int* expiredTime)**

    获取当前用户的ID、会员标识和剩余时间，分别写入到uid、membership和expiredTime指针对应地址中；获取成功返回true，否则返回false。

    会员标识取值是：
    
    + 0: 未购买，非试用
    + 1: 付费用户
    + 2: 试用用户
    + 3: 免费用户

    > uid并非果盘账号，但能唯一对应果盘账号；  
    > 用户通过激活码激活（包括日卡）套餐后，也认定为付费用户；  
    > 开发助手下获取到的uid和expiredTime固定为"null"和3.

* **void xmod\_screen\_get\_size(xmod\_size* size)**

    获取屏幕分辨率，并写入到size指针对应的对象中。

    > 注意返回结果和脚本的`screen.init`调用有关。

* **void xmod\_screen\_mock\_transform\_rect(XModMockMode mode, const xmod\_rect& in, xmod\_rect* out)**

    指定转换模式mode，对in矩形进行转换，转换结果写入到out指针对应的对象中。

    转换函数通过Lua函数`screen.setMockTransform(transform)`指定，mode和in参数将会回传到Lua函数transform中，out即为transform函数的返回结果。

    > 注意：该函数涉及Lua调用，只能在Lua线程（即默认触发线程）中调用，多线程环境下调用会导致不可控的报错甚至闪退。

* **void xmod\_screen\_mock\_transform\_point(XModMockMode mode, const xmod\_point& in, xmod\_point* out)**

    与`xmod_screen_mock_transform_rect`函数功能类似，不同的是只针对xmod_point类型进行转换。

    > 注意：该函数涉及Lua调用，只能在Lua线程（即默认触发线程）中调用，多线程环境下调用会导致不可控的报错甚至闪退。

* **bool xmod\_xsp\_get\_res(const char* subpath, unsigned char\*\* buff, size\_t* size)**

    获取XSP文件中res/目录下的subpath文件，将文件数据和大小分别写入到buff指针和size指针对应地址；获取成功返回true，否则返回false（例如文件不存在）。

* **bool xmod\_xsp\_extract\_res(const char* subpath, const char* destpath)**

    将XSP文件中res/目录下的subpath文件解压到destpath路径，解压成功返回true，否则返回false（例如文件不存在）。

* **xmod\_image* xmod\_image\_from\_screen()**

    截取当前屏幕，并返回xmod_image\*类型对象。

    > 注意创建返回的xmod_image\*对象需要通过`xmod_image_release`进行释放。

* **xmod\_image* xmod\_image\_from\_screen\_clip(const xmod\_rect& rect)**

    指定rect范围截取屏幕数据，并返回xmod_image\*类型对象。

    > 注意创建返回的xmod_image\*对象需要通过`xmod_image_release`进行释放。

* **xmod\_image* xmod\_image\_from\_file(const char* path)**

    指定path路径，加载并返回xmod_image\*类型对象。

    > 注意创建返回的xmod_image\*对象需要通过`xmod_image_release`进行释放。

* **xmod\_image* xmod\_image\_from\_stream(const unsigned char* buff, ssize\_t len)**

    指定数据源buff和大小len，构造并返回xmod_image\*类型对象。

    > 注意创建返回的xmod_image\*对象需要通过`xmod_image_release`进行释放。

* **xmod\_image* xmod\_image\_from\_format(XModPixelFormat format, const xmod\_size& size, const unsigned char* buff, ssize\_t len)**

    指定像素格式format、图像尺寸size、数据源buff和大小len，构造并返回xmod_image\*类型对象。

    > 注意创建返回的xmod_image\*对象需要通过`xmod_image_release`进行释放。

* **void xmod\_image\_release(xmod\_image* image)**

    释放image对象。

* **bool xmod\_image\_get\_size(const xmod\_image* image, xmod\_size* size)**

    获取image对象的图像尺寸，并写入到size指针对应的对象中；获取成功返回true，否则返回false。

* **void xmod\_image\_set\_rotation(xmod\_image* image, XModRotation rotation)**

    对image对象进行旋转操作。

* **void xmod\_image\_clip\_with\_rect(xmod\_image* image, const xmod\_rect& rect)**

    对image对象进行截取操作，截取范围为rect。

* **bool xmod\_image\_get\_pixel(const xmod\_image* image, const xmod\_point& point, uint32\_t* pixel)**

    获取image图像位于point处的RGB888格式像素数据，并写入到pixel指针对应的地址中；获取成功返回true，否则返回false（例如point范围越界）。

* **bool xmod\_image\_get\_rgb(const xmod\_image* image, const xmod\_point& point, xmod\_color3b* c3b)**

    获取image图像位于point处的RGB888格式像素数据，并写入到c3b指针对应的对象中；获取成功返回true，否则返回false（例如point范围越界）。

* **bool xmod\_image\_save\_to\_file(const xmod\_image* image, const char* path, int quality)**

    将image图像保存到path指定的路径中，质量quality可选1-100范围；保存成功返回true，否则返回false（例如path路径没有操作权限）。


### 代码规范（重点）

#### 头文件引入
有Lua扩展模块经验的开发者可能会留意到，XMod引擎并没有提供Lua原生的lua.h、lauxlib.h等头文件供开发者引入。

在XMod引擎扩展中，提供了ExtensionSupport.h这个头文件作为整个XMod引擎扩展库的总头文件，实际上所有lua.h、lauxlib.h等头文件已经被合并到了LuaAPIStub53.h这个头文件中，你只能在需要用到Lua模块的地方单独include这个头文件来使用Lua的C API，而不能再用类似`#include <lua.h>`这样的写法。参见示例module/lunzip模块中的[lua_unzip.cpp](https://github.com/xxzhushou/CExtension/blob/master/modules/lunzip/lua_unzip.cpp)中的头文件依赖。

需要注意的是，由于ExtensionSupport.h中默认集成的头文件中依赖了C++的namespace等关键词，所以任何包含了ExtensionSupport.h的源代码，都需要以cpp/cc/cxx等后缀格式结尾，不能使用c后缀格式，其他源代码文件不受影响。

#### 模块入口函数
每个模块必须提供入口函数，也就是当Lua代码中调用`require '<module_name>'`时，实际触发的C++入口函数。而这个C++模块入口函数，同样也有统一的规范：

* 入口函数必须是可见和导出（export）的；
* 入口函数名必须符合`luaopen_<module_name>`的格式；
* 入口函数名编译后的符号必须以C命名风格，而不是C++命名风格（C++支持重载）。

看似规则复杂，实际上要同时保证上面这三点要求，只需要在入口函数上面加上`extern "C" __attribute__((visibility("default")))`修饰即可，例如[lua_unzip.cpp](https://github.com/xxzhushou/CExtension/blob/master/modules/lunzip/lua_unzip.cpp)中`luaopen_unzip`函数的定义是：

```cpp
extern "C" __attribute__((visibility("default")))
int luaopen_unzip(lua_State *L)
{
	...
}
```

> `extern "C"`告诉编译器使用C编译器来编译该函数；  
> `__attribute__((visibility("default")))`则告诉编译器这个函数符号是可见导出的。

### 编译和打包

以[@xxzhushou/CExtension](https://github.com/xxzhushou/CExtension)项目中的modules/lunzip工程为例。

#### Android动态库编译

* Mac系统

    + 下载和配置好Android NDK工具；
    + 打开Terminal，用`cd`命令切换到build目录；
    + 运行命令行`sh build_android.sh lunzip`，脚本会执行ndk-build编译modules/lunzip工程（默认release模式，可选`-d`参数指定debug模式）；
    + 编译过程如提示出错，请按错误提示进行修改，编译成功后，文件可以在`output/android/lunzip`目录下找到对应Android架构的`so`后缀的动态库文件。

* Windows系统

    待补充（与Mac系统类似，但需要通过cygwin编译）。

#### iOS动态库编译

待补充。

可以参照modules目录下的工程，创建自定义的扩展模块，也可以在[LuaRock官网展示列表](https://luarocks.org/m/root)中寻找最新和优秀的Lua开源项目，自行编译成动态库后使用。

### 加载和使用

编译成功后，必须保留动态库的文件命名格式 `lib<module_name>.so`（Android） 或 `lib<module_name>.dylib`（iOS），其中`<module_name>`是模块名称，而且该名称不能和以下XMod官方内置的模块名称冲突：

* lfs —— 文件管理模块
* cjson —— JSON库模块
* ssl —— OpenSSL/HTTPS支持
* socket —— Socket通讯模块
* mime —— MIME协议模块
* crypto —— 常见通用加解密模块
* chttp —— HTTP通讯模块
* dmocr —— 大漠识别模块
* tessocr_3.02.02 —— Tesseract v3.02.02识别模块
* tessocr_3.05.02 —— Tesseract v3.05.02识别模块

使用时将编译好的库文件放到脚本工程下的`lib`目录，即集成开发环境中的`库文件`目录下。但注意Android和iOS的动态库规范有差异，因此部署也有差异。

#### 部署Android动态库文件

XMod引擎目前支持且仅支持以下两种Android架构：

* ARM-32（armeabi-v7a）
* X86

目前普遍的真机设备是使用ARM架构，其中支持arm64的设备一般也是兼容arm的，而x86架构主要用于安卓模拟器（也有极少数的x86的真机设备）。

由于这两种架构本身互不兼容（事实上部分模拟器也可能集成了Intel的houdini模块以兼容arm在x86的运行），上述编译出来的动态库需要按照架构区分存放，具体搜索优先级是：

* `lib<module_name>_<arch>.so`
* `lib<module_name>.so`

以`cmodule`这个动态库为例，假设脚本运行在arm架构的Android设备上，那么当代码中使用`require 'cmodule'`加载cmoudle动态库，XMod加载器会按照以下优先级搜索cmodule模块：

* xsp://lib/libcmodule_armeabi-v7a.so
* xsp://lib/libcmodule.so

如果不存在这两个文件，require失败脚本报错；如果文件存在，则会尝试进行加载。

注意由于不同架构互不兼容，虽然x86架构的模拟器一般有专门的转换模块兼容arm格式的动态库，但反过来是行不通的。所以可能会出现只编译了x86架构的动态库，但没有严格按照架构进行后缀区分，那么脚本运行在arm架构设备上会被错误加载了只兼容x86的动态库，严重可能会引起引擎的崩溃。

除非你明确清楚和知道当前脚本的运行平台和环境，否则强烈建议严格按照本文的架构后缀进行区分，避免不必要的问题发生。

#### 部署iOS动态库文件

待补充。
