TARGET=main
DEBUG = 1
OPT = -Og
RM=rm -rf
ASM_SOURCES = startup_stm32f103xb.s
LDSCRIPT = STM32F103C8Tx_FLASH.ld

MD = mkdir -p
PREFIX = arm-none-eabi-
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

INCLUDE_DIR_NAME = include
INCLUDE_DIRS = $(subst ./,, $(shell find  -name "*.h"))
C_INCLUDE_LINK = $(sort $(addprefix -I,$(dir $(INCLUDE_DIRS))))
#找到头文件目录
C_SRC = $(subst ./,, $(shell find -name "*.c"))
BUILD_DIR = build
OBJECTS = $(addprefix $(BUILD_DIR)/,$(C_SRC:.c=.o))
CPU = -mcpu=cortex-m3
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)
AS_DEFS = 
C_DEFS =  \
-DUSE_HAL_DRIVER \
-DUSE_STDPERIPH_DRIVER \
-DSTM32F10X_MD \
-DSTM32F103xB 
#-DUSE_STDPERIPH_DRIVER 
AS_INCLUDES = 
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections
CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDE_LINK) $(OPT) -Wall -fdata-sections -ffunction-sections
ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"

# libraries
LIBS = -lc -lm -lnosys 
LIBDIR = 
LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

$(OBJECTS):$(BUILD_DIR)/%.o:%.c 
	$(MD) $(@D)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/$(ASM_SOURCES:.s=.o): $(ASM_SOURCES) Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@
$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) $(BUILD_DIR)/$(ASM_SOURCES:.s=.o) Makefile
	$(CC) $(OBJECTS) $(BUILD_DIR)/$(ASM_SOURCES:.s=.o) $(LDFLAGS) -o $@
	$(SZ) $@
$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@	
$(BUILD_DIR):
	mkdir $@		
bin:
	$(OBJCOPY) $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).bin
hex:
	$(OBJCOPY) $(BUILD_DIR)/$(TARGET).elf -Oihex $(BUILD_DIR)/$(TARGET).hex
clean:
	$(RM) $(BUILD_DIR)
upload:
	openocd -f ./stm32f103c8_blue_pill.cfg -c "program $(BUILD_DIR)/$(TARGET).elf verify reset exit"
gdb:
	openocd -f ./stm32f103c8_blue_pill.cfg 
-include $(wildcard $(OBJECTS:.o=.d))
