include(FetchContent)
include(ExternalProject)

function(
	BuildBlend2DTo
	TARGET_NAME
	SRC_DIR
	BUILD_DIR
	OUT_DIR
	BUILD_TYPE
)
	# 拉取 asmjit 代码置于隔壁
	get_filename_component(BLEND2D_SRC_UPDIR "${SRC_DIR}" DIRECTORY)
	set(BLEND2D_ASMJIT_SRC_DIR "${BLEND2D_SRC_UPDIR}/asmjit")

	message(STATUS "blend asmjit dir: ${BLEND2D_ASMJIT_SRC_DIR}")


	# 只拉取源码
	ExternalProject_Add(
		asmjit
		GIT_REPOSITORY    git@github.com:asmjit/asmjit.git
		GIT_TAG           master
		SOURCE_DIR "${BLEND2D_ASMJIT_SRC_DIR}"

		# 不配置
		CONFIGURE_COMMAND ""
		# 不构建
		BUILD_COMMAND ""
		# 不安装
		INSTALL_COMMAND ""

		# 配置 build 阶段就生成目标并安装
		STEP_TARGETS build
		EXCLUDE_FROM_ALL TRUE
	)

	# 生成
	ExternalProject_Add(
		blend2d
		GIT_REPOSITORY    git@github.com:blend2d/blend2d.git
		GIT_TAG           master

		# git 是直接拉取再 SOURCE_DIR 下，DOWNLOAD_DIR 应该是配合 URL 使用的。
		# DOWNLOAD_DIR "${CMAKE_CURRENT_BINARY_DIR}/**_download"
		SOURCE_DIR "${SRC_DIR}"

		# 这个指定不需要因为生成过程被定制了，这个是原流程使用的。
		# BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/**_bin"

		CONFIGURE_COMMAND "${CMAKE_COMMAND}" -S "${SRC_DIR}" -B "${BUILD_DIR}"
		BUILD_COMMAND "${CMAKE_COMMAND}" "--build" "${BUILD_DIR}" "--config" "${BUILD_TYPE}"

		# 执行安装 ${CMAKE_MAKE_PROGRAM} 是 ninja 、 make 、nmake 之流。
		INSTALL_COMMAND "${CMAKE_COMMAND}" "--install" "${BUILD_DIR}" "--config" "${BUILD_TYPE}" "--prefix" "${OUT_DIR}"
  
		# 配置 build 阶段就生成目标并安装
		STEP_TARGETS build
		EXCLUDE_FROM_ALL TRUE
	)

	add_dependencies(blend2d asmjit)
	add_dependencies("${TARGET_NAME}" blend2d)
endfunction()