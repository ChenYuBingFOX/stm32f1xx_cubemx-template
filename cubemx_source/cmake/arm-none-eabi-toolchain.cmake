# ARM Cortex-M3 (STM32F103xB) bare-metal toolchain
# Usage: pass via -DCMAKE_TOOLCHAIN_FILE or include from CMakeLists.txt

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# bare-metal: skip executable link during compiler check (no syscalls)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# optional: point to a folder containing the toolchain binaries
#   cmake -DTCHAIN_PATH=C:/tools/gcc-arm-none-eabi/bin
set(TCHAIN_PATH "" CACHE PATH "Directory of the ARM toolchain binaries (optional)")

if(TCHAIN_PATH)
    set(CMAKE_C_COMPILER    ${TCHAIN_PATH}/arm-none-eabi-gcc)
    set(CMAKE_ASM_COMPILER  ${TCHAIN_PATH}/arm-none-eabi-gcc)
    set(CMAKE_OBJCOPY       ${TCHAIN_PATH}/arm-none-eabi-objcopy)
    set(CMAKE_OBJDUMP       ${TCHAIN_PATH}/arm-none-eabi-objdump)
    set(CMAKE_SIZE          ${TCHAIN_PATH}/arm-none-eabi-size)
else()
    set(CMAKE_C_COMPILER    arm-none-eabi-gcc)
    set(CMAKE_ASM_COMPILER  arm-none-eabi-gcc)
    set(CMAKE_OBJCOPY       arm-none-eabi-objcopy)
    set(CMAKE_OBJDUMP       arm-none-eabi-objdump)
    set(CMAKE_SIZE          arm-none-eabi-size)
endif()

set(CPU_FLAGS "-mcpu=cortex-m3 -mthumb")

set(CMAKE_C_FLAGS_INIT       "${CPU_FLAGS}")
set(CMAKE_ASM_FLAGS_INIT     "${CPU_FLAGS} -x assembler-with-cpp")
set(CMAKE_EXE_LINKER_FLAGS_INIT "${CPU_FLAGS}")

set(CMAKE_C_FLAGS_DEBUG_INIT     "-Og -g")
set(CMAKE_C_FLAGS_RELEASE_INIT   "-O2")