cmake_minimum_required(VERSION 3.16)

include(cmake/arm-none-eabi-toolchain.cmake)

project(cubemx C ASM)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/STM32F103XX_FLASH.ld)

##############
# sources
##############
set(C_SOURCES
    ../app.c
    Core/Src/main.c
    Core/Src/stm32f1xx_hal_msp.c
    Core/Src/stm32f1xx_it.c
    Core/Src/syscalls.c
    Core/Src/sysmem.c
    Core/Src/system_stm32f1xx.c
    Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal.c
    Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_cortex.c
    Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_dma.c
    Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_exti.c
    Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_flash.c
    Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_flash_ex.c
    Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_gpio.c
    Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_gpio_ex.c
    Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_pwr.c
    Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc.c
    Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc_ex.c
)

set(ASM_SOURCES
    startup_stm32f103xb.s
)

add_executable(cubemx ${C_SOURCES} ${ASM_SOURCES})
set_target_properties(cubemx PROPERTIES
    LINKER_LANGUAGE C
    SUFFIX ".elf"
)

###############
# compile
###############
target_compile_definitions(cubemx PRIVATE
    USE_HAL_DRIVER
    STM32F103xB
)

target_include_directories(cubemx PRIVATE
    Core/Inc
    Drivers/STM32F1xx_HAL_Driver/Inc
    Drivers/STM32F1xx_HAL_Driver/Inc/Legacy
    Drivers/CMSIS/Device/ST/STM32F1xx/Include
    Drivers/CMSIS/Include
    ..
)

target_compile_options(cubemx PRIVATE
    -Wall
    -ffunction-sections
    -fdata-sections
    -funsigned-char
)

##############
# link
##############
target_link_options(cubemx PRIVATE
    --specs=nosys.specs
    --specs=nano.specs
    -T${LINKER_SCRIPT}
    -Wl,-Map=${CMAKE_BINARY_DIR}/cubemx.map,--cref
    -Wl,--gc-sections
)

##############
# post build: hex / bin / size
##############
add_custom_command(TARGET cubemx POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex   $<TARGET_FILE:cubemx> ${CMAKE_BINARY_DIR}/cubemx.hex
    COMMAND ${CMAKE_OBJCOPY} -O binary -S $<TARGET_FILE:cubemx> ${CMAKE_BINARY_DIR}/cubemx.bin
    COMMAND ${CMAKE_SIZE} $<TARGET_FILE:cubemx>
    COMMENT "Generate cubemx.hex / cubemx.bin"
)