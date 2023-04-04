cmake_minimum_required(VERSION 3.24)

message(STATUS "wxwidgets")
include(ExternalProject)
include("cmake/WxWidgetsBuild.cmake")

project(wxwcppdemo)

add_executable(wxwcppdemo WIN32)

set(WXWIDGETS_SRC_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_src")
set(WXWIDGETS_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_build")
set(WXWIDGETS_OUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_out")

if(CMAKE_BUILD_TYPE AND (CMAKE_BUILD_TYPE STREQUAL "Debug"))
	message(STATUS "wxWidgets Debug")
	BuildWxwidgetsTo(
		wxwcppdemo
		"${WXWIDGETS_SRC_DIR}"
		"${WXWIDGETS_BUILD_DIR}"
		"${WXWIDGETS_OUT_DIR}"
		"Debug"
	)
else()
	message(STATUS "wxWidgets Release")
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

add_dependencies(wxwcppdemo wxwidgets)

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
