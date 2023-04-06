# blend2d ʹ�� asmjit ��ͨ������Դ���̶�·��ָ����
# ������ʹ�� Blend2D ���з�ʽ���룬��� Blend2DBuild.cmake
function(
	CloneAsmJitTo
	SRC_DIR
)
	# ���������� asmjit ������ blend2d Դ�����
	FetchContent_Declare(
		asmjit
		GIT_REPOSITORY git@github.com:asmjit/asmjit.git
		GIT_TAG master
		SOURCE_DIR "${SRC_DIR}"
	)
	FetchContent_MakeAvailable(asmjit)
endfunction()