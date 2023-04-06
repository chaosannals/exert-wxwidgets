# blend2d 使用 asmjit 是通过隔壁源码半固定路径指定的
# 废弃，使用 Blend2D 固有方式导入，详见 Blend2DBuild.cmake
function(
	CloneAsmJitTo
	SRC_DIR
)
	# 下载依赖库 asmjit 必须在 blend2d 源码隔壁
	FetchContent_Declare(
		asmjit
		GIT_REPOSITORY git@github.com:asmjit/asmjit.git
		GIT_TAG master
		SOURCE_DIR "${SRC_DIR}"
	)
	FetchContent_MakeAvailable(asmjit)
endfunction()