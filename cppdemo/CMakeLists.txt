cmake_minimum_required(VERSION 3.24)

message(STATUS "wxwidgets")
include(ExternalProject)
include("cmake/AsmJitBuild.cmake")
include("cmake/Blend2DBuild.cmake")
include("cmake/WxWidgetsBuild.cmake")

project(wxwcppdemo)

add_executable(wxwcppdemo WIN32)

# set(ASMJIT_SRC_DIR "${CMAKE_CURRENT_BINARY_DIR}/asmjit_src")
# blend2d 导入 asmjit 的方式不规范，以下使用它特有方式导入。
# set(ASMJIT_DIR "${ASMJIT_SRC_DIR}")

set(BLEND2D_SRC_DIR "${CMAKE_CURRENT_BINARY_DIR}/blend2d") # 这名字也是写死的
set(BLEND2D_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/blend2d_build")
set(BLEND2D_OUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/blend2d_out")

set(WXWIDGETS_SRC_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_src")
set(WXWIDGETS_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_build")
set(WXWIDGETS_OUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_out")


if(CMAKE_BUILD_TYPE AND (CMAKE_BUILD_TYPE STREQUAL "Debug"))
	message(STATUS "wxWidgets Debug")
	#CloneAsmJitTo(
	#	"${ASMJIT_SRC_DIR}"
	#)
	BuildBlend2DTo(
		wxwcppdemo
		"${BLEND2D_SRC_DIR}"
		"${BLEND2D_BUILD_DIR}"
		"${BLEND2D_OUT_DIR}"
		"Debug"
	)
	BuildWxwidgetsTo(
		wxwcppdemo
		"${WXWIDGETS_SRC_DIR}"
		"${WXWIDGETS_BUILD_DIR}"
		"${WXWIDGETS_OUT_DIR}"
		"Debug"
	)
else()
	message(STATUS "wxWidgets Release")
	#CloneAsmJitTo(
	#	"${ASMJIT_SRC_DIR}"
	#)
	BuildBlend2DTo(
		wxwcppdemo
		"${BLEND2D_SRC_DIR}"
		"${BLEND2D_BUILD_DIR}"
		"${BLEND2D_OUT_DIR}"
		"Release"
	)
	BuildWxwidgetsTo(
		wxwcppdemo
		"${WXWIDGETS_SRC_DIR}"
		"${WXWIDGETS_BUILD_DIR}"
		"${WXWIDGETS_OUT_DIR}"
		"Release"
	)
endif()

add_custom_command(
	TARGET wxwcppdemo
	POST_BUILD
	COMMAND "${CMAKE_COMMAND}" "-E" "copy_directory" "${wxwcppdemo_SOURCE_DIR}/data" "${wxwcppdemo_BINARY_DIR}/data"
)

if(CMAKE_BUILD_TYPE AND (CMAKE_BUILD_TYPE STREQUAL "Debug"))
	message(STATUS "demo Debug")
else()
	message(STATUS "demo Release")
	target_compile_definitions(
		wxwcppdemo
		PUBLIC
		-DNDEBUG # 关闭调试，这个不影响编译。
	)
endif()

target_sources(
	wxwcppdemo
	PRIVATE
	"src/main.cpp"
)
