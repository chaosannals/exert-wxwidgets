cmake_minimum_required(VERSION 3.24)

message(STATUS "wxwidgets")
include(ExternalProject)

set(WXWIDGETS_SRC_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_src")
set(WXWIDGETS_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_build")
set(WXWIDGETS_OUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_out")

# git clone 发生在 依赖该外部项目的目标的生成阶段。 add_dependencies 指定。
ExternalProject_Add(wxwidgets
  GIT_REPOSITORY    git@github.com:wxWidgets/wxWidgets.git
  GIT_TAG           v3.2.2.1

  # git 是直接拉取再 SOURCE_DIR 下，DOWNLOAD_DIR 应该是配合 URL 使用的。
  # DOWNLOAD_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_download"
  SOURCE_DIR "${WXWIDGETS_SRC_DIR}"

  # 这个指定不需要因为生成过程被定制了，这个是原流程使用的。
  # BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_bin"

  CONFIGURE_COMMAND "${CMAKE_COMMAND}" -S "${WXWIDGETS_SRC_DIR}" -B "${WXWIDGETS_BUILD_DIR}"
  BUILD_COMMAND "${CMAKE_COMMAND}" "--build" "${WXWIDGETS_BUILD_DIR}" --config Release

  # 执行安装 ${CMAKE_MAKE_PROGRAM} 是 ninja 、 make 、nmake 之流。
  INSTALL_COMMAND "${CMAKE_COMMAND}" "--install" "${WXWIDGETS_BUILD_DIR}" "--prefix" "${WXWIDGETS_OUT_DIR}"
  
  # 配置 build 阶段就生成目标并安装
  STEP_TARGETS build
  EXCLUDE_FROM_ALL TRUE
)

project(wxwcppdemo)

add_executable(wxwcppdemo)

add_dependencies(wxwcppdemo wxwidgets)

target_compile_definitions(
	wxwcppdemo
	PUBLIC
	# 这2个是 samples 看到的，文档没有提及。
	#-DwxUSE_DPI_AWARE_MANIFEST=2
	#-DWX_PRECOMP

	# 以下为文档提及的设置项目。
	-DNDEBUG # 关闭调试，这个不影响编译。
	-D__WXMSW__ 
	-DWXUSINGDLL # 这个是指定动态库模式 不指定目录是 vc_x64_lib 指定了就变成 vc_x64_dll ，这个主要看预编译好的 wxwidgets 是动态库版还是静态库版。
	-DUNICODE # 文档未提及，但是 vs 的 windows 程序默认就是 UNICODE 和 _UNICODE 一起加的，开启的话就一起了。
    -D_UNICODE # mswu 是 开启了 UNICODE 的 msw

	# MSVC7 only
	#-DwxUSE_RC_MANIFEST=1
	#-DWX_CPU_X86
)

target_include_directories(
	wxwcppdemo
	PRIVATE
	"${WXWIDGETS_OUT_DIR}/include"
	"${WXWIDGETS_OUT_DIR}/include/msvc"
)

target_link_directories(
	wxwcppdemo
	PRIVATE
	"${WXWIDGETS_OUT_DIR}/lib/vc_x64_dll"
)

target_sources(
	wxwcppdemo
	PRIVATE
	"src/main.cpp"
)
