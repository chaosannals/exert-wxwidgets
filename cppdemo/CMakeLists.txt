cmake_minimum_required(VERSION 3.24)

message(STATUS "wxwidgets")
include(ExternalProject)

set(WXWIDGETS_SRC_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_src")
set(WXWIDGETS_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_build")
set(WXWIDGETS_OUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_out")

# git clone ������ �������ⲿ��Ŀ��Ŀ������ɽ׶Ρ� add_dependencies ָ����
ExternalProject_Add(wxwidgets
  GIT_REPOSITORY    git@github.com:wxWidgets/wxWidgets.git
  GIT_TAG           v3.2.2.1

  # git ��ֱ����ȡ�� SOURCE_DIR �£�DOWNLOAD_DIR Ӧ������� URL ʹ�õġ�
  # DOWNLOAD_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_download"
  SOURCE_DIR "${WXWIDGETS_SRC_DIR}"

  # ���ָ������Ҫ��Ϊ���ɹ��̱������ˣ������ԭ����ʹ�õġ�
  # BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_bin"

  CONFIGURE_COMMAND "${CMAKE_COMMAND}" -S "${WXWIDGETS_SRC_DIR}" -B "${WXWIDGETS_BUILD_DIR}"
  BUILD_COMMAND "${CMAKE_COMMAND}" "--build" "${WXWIDGETS_BUILD_DIR}" --config Release

  # ִ�а�װ ${CMAKE_MAKE_PROGRAM} �� ninja �� make ��nmake ֮����
  INSTALL_COMMAND "${CMAKE_COMMAND}" "--install" "${WXWIDGETS_BUILD_DIR}" "--prefix" "${WXWIDGETS_OUT_DIR}"
  
  # ���� build �׶ξ�����Ŀ�겢��װ
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