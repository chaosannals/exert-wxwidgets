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

target_include_directories(
	wxwcppdemo
	PRIVATE
	"${WXWIDGETS_OUT_DIR}/include"
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
