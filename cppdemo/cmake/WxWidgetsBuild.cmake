include(ExternalProject)

function(
	BuildWxWidgetsTo
	TARGET_NAME
	SRC_DIR
	BUILD_DIR
	OUT_DIR
	BUILD_TYPE
)
	# git clone 发生在 依赖该外部项目的目标的生成阶段。 add_dependencies 指定。
	ExternalProject_Add(
		wxwidgets
		GIT_REPOSITORY    git@github.com:wxWidgets/wxWidgets.git
		GIT_TAG           v3.2.2.1

		# git 是直接拉取再 SOURCE_DIR 下，DOWNLOAD_DIR 应该是配合 URL 使用的。
		# DOWNLOAD_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_download"
		SOURCE_DIR "${SRC_DIR}"

		# 这个指定不需要因为生成过程被定制了，这个是原流程使用的。
		# BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_bin"

		CONFIGURE_COMMAND "${CMAKE_COMMAND}" -S "${SRC_DIR}" -B "${BUILD_DIR}"
		BUILD_COMMAND "${CMAKE_COMMAND}" "--build" "${BUILD_DIR}" "--config" "${BUILD_TYPE}"

		# 执行安装 ${CMAKE_MAKE_PROGRAM} 是 ninja 、 make 、nmake 之流。
		INSTALL_COMMAND "${CMAKE_COMMAND}" "--install" "${BUILD_DIR}" "--config" "${BUILD_TYPE}" "--prefix" "${OUT_DIR}"
  
		# 配置 build 阶段就生成目标并安装
		STEP_TARGETS build
		EXCLUDE_FROM_ALL TRUE
	)

	get_target_property(WXWIDGETS_DLL_TARGET_BINARY_DIR ${TARGET_NAME} BINARY_DIR)

	add_dependencies("${TARGET_NAME}" wxwidgets)

	message(STATUS "WxWidgets DLL copy TO ${WXWIDGETS_DLL_TARGET_BINARY_DIR}")

	add_custom_command(
		TARGET "${TARGET_NAME}"
		POST_BUILD
		COMMAND "${CMAKE_COMMAND}" "-E" "copy_directory" "${OUT_DIR}/lib/vc_x64_dll" "${WXWIDGETS_DLL_TARGET_BINARY_DIR}"
	)

	target_compile_definitions(
		"${TARGET_NAME}"
		PUBLIC
		# 这2个是 samples 看到的，文档没有提及。
		#-DwxUSE_DPI_AWARE_MANIFEST=2
		#-DWX_PRECOMP

		# 以下为文档提及的设置项目。
		-D__WXMSW__ 
		-DWXUSINGDLL # 这个是指定动态库模式 不指定目录是 vc_x64_lib 指定了就变成 vc_x64_dll ，这个主要看预编译好的 wxwidgets 是动态库版还是静态库版。
		-DUNICODE # 文档未提及，但是 vs 的 windows 程序默认就是 UNICODE 和 _UNICODE 一起加的，开启的话就一起了。
		-D_UNICODE # mswu 是 开启了 UNICODE 的 msw

		# MSVC7 only
		#-DwxUSE_RC_MANIFEST=1
		#-DWX_CPU_X86
	)

	target_include_directories(
		"${TARGET_NAME}"
		PRIVATE
		"${OUT_DIR}/include"
		"${OUT_DIR}/include/msvc" #这个应该和编译器相关，TODO 做平台判定。
	)

	target_link_directories(
		"${TARGET_NAME}"
		PRIVATE
		"${OUT_DIR}/lib/vc_x64_dll"
	)
endfunction()