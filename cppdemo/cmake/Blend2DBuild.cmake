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
	# ��ȡ asmjit �������ڸ���
	get_filename_component(BLEND2D_SRC_UPDIR "${SRC_DIR}" DIRECTORY)
	set(BLEND2D_ASMJIT_SRC_DIR "${BLEND2D_SRC_UPDIR}/asmjit")

	message(STATUS "blend asmjit dir: ${BLEND2D_ASMJIT_SRC_DIR}")


	# ֻ��ȡԴ��
	ExternalProject_Add(
		asmjit
		GIT_REPOSITORY    git@github.com:asmjit/asmjit.git
		GIT_TAG           master
		SOURCE_DIR "${BLEND2D_ASMJIT_SRC_DIR}"

		# ������
		CONFIGURE_COMMAND ""
		# ������
		BUILD_COMMAND ""
		# ����װ
		INSTALL_COMMAND ""

		# ���� build �׶ξ�����Ŀ�겢��װ
		STEP_TARGETS build
		EXCLUDE_FROM_ALL TRUE
	)

	# ����
	ExternalProject_Add(
		blend2d
		GIT_REPOSITORY    git@github.com:blend2d/blend2d.git
		GIT_TAG           master

		# git ��ֱ����ȡ�� SOURCE_DIR �£�DOWNLOAD_DIR Ӧ������� URL ʹ�õġ�
		# DOWNLOAD_DIR "${CMAKE_CURRENT_BINARY_DIR}/**_download"
		SOURCE_DIR "${SRC_DIR}"

		# ���ָ������Ҫ��Ϊ���ɹ��̱������ˣ������ԭ����ʹ�õġ�
		# BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/**_bin"

		CONFIGURE_COMMAND "${CMAKE_COMMAND}" -S "${SRC_DIR}" -B "${BUILD_DIR}"
		BUILD_COMMAND "${CMAKE_COMMAND}" "--build" "${BUILD_DIR}" "--config" "${BUILD_TYPE}"

		# ִ�а�װ ${CMAKE_MAKE_PROGRAM} �� ninja �� make ��nmake ֮����
		INSTALL_COMMAND "${CMAKE_COMMAND}" "--install" "${BUILD_DIR}" "--config" "${BUILD_TYPE}" "--prefix" "${OUT_DIR}"
  
		# ���� build �׶ξ�����Ŀ�겢��װ
		STEP_TARGETS build
		EXCLUDE_FROM_ALL TRUE
	)

	add_dependencies(blend2d asmjit)
	add_dependencies("${TARGET_NAME}" blend2d)
endfunction()