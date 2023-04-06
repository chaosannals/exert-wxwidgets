include(ExternalProject)

function(
	BuildWxWidgetsTo
	TARGET_NAME
	SRC_DIR
	BUILD_DIR
	OUT_DIR
	BUILD_TYPE
)
	# git clone ������ �������ⲿ��Ŀ��Ŀ������ɽ׶Ρ� add_dependencies ָ����
	ExternalProject_Add(
		wxwidgets
		GIT_REPOSITORY    git@github.com:wxWidgets/wxWidgets.git
		GIT_TAG           v3.2.2.1

		# git ��ֱ����ȡ�� SOURCE_DIR �£�DOWNLOAD_DIR Ӧ������� URL ʹ�õġ�
		# DOWNLOAD_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_download"
		SOURCE_DIR "${SRC_DIR}"

		# ���ָ������Ҫ��Ϊ���ɹ��̱������ˣ������ԭ����ʹ�õġ�
		# BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/wxwidgets_bin"

		CONFIGURE_COMMAND "${CMAKE_COMMAND}" -S "${SRC_DIR}" -B "${BUILD_DIR}"
		BUILD_COMMAND "${CMAKE_COMMAND}" "--build" "${BUILD_DIR}" "--config" "${BUILD_TYPE}"

		# ִ�а�װ ${CMAKE_MAKE_PROGRAM} �� ninja �� make ��nmake ֮����
		INSTALL_COMMAND "${CMAKE_COMMAND}" "--install" "${BUILD_DIR}" "--config" "${BUILD_TYPE}" "--prefix" "${OUT_DIR}"
  
		# ���� build �׶ξ�����Ŀ�겢��װ
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
		# ��2���� samples �����ģ��ĵ�û���ἰ��
		#-DwxUSE_DPI_AWARE_MANIFEST=2
		#-DWX_PRECOMP

		# ����Ϊ�ĵ��ἰ��������Ŀ��
		-D__WXMSW__ 
		-DWXUSINGDLL # �����ָ����̬��ģʽ ��ָ��Ŀ¼�� vc_x64_lib ָ���˾ͱ�� vc_x64_dll �������Ҫ��Ԥ����õ� wxwidgets �Ƕ�̬��滹�Ǿ�̬��档
		-DUNICODE # �ĵ�δ�ἰ������ vs �� windows ����Ĭ�Ͼ��� UNICODE �� _UNICODE һ��ӵģ������Ļ���һ���ˡ�
		-D_UNICODE # mswu �� ������ UNICODE �� msw

		# MSVC7 only
		#-DwxUSE_RC_MANIFEST=1
		#-DWX_CPU_X86
	)

	target_include_directories(
		"${TARGET_NAME}"
		PRIVATE
		"${OUT_DIR}/include"
		"${OUT_DIR}/include/msvc" #���Ӧ�úͱ�������أ�TODO ��ƽ̨�ж���
	)

	target_link_directories(
		"${TARGET_NAME}"
		PRIVATE
		"${OUT_DIR}/lib/vc_x64_dll"
	)
endfunction()