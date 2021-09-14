TARGET=test
CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy
RM=rm -rf
CORE=3
BUILDDIR=build
CPUFLAGS=-mthumb -mcpu=cortex-m$(CORE)
LDFLAGS = -T STM32F103C8Tx_FLASH.ld -Wl,-cref,-u,Reset_Handler -Wl,-Map=$(BUILDDIR)/$(TARGET).map -Wl,--gc-sections -Wl,--defsym=malloc_getpagesize_P=0x80 -Wl,--start-group -lc -lm -Wl,--end-group
CFLAGS=-g -o
$(TARGET):$(BUILDDIR)/startup_stm32f103xb.o $(BUILDDIR)/main.o | $(BUILDDIR)
	$(CC) $^ $(CPUFLAGS) $(LDFLAGS) $(CFLAGS) $(BUILDDIR)/$(TARGET).elf
$(BUILDDIR)/startup_stm32f103xb.o:startup_stm32f103xb.s | $(BUILDDIR)
	$(CC) -c $^ $(CPUFLAGS) $(CFLAGS) $@
$(BUILDDIR)/main.o:main.c | $(BUILDDIR)
	$(CC) -c $^ $(CPUFLAGS) $(CFLAGS) $@

$(BUILDDIR):
	mkdir $@		
bin:
	$(OBJCOPY) $(BUILDDIR)/$(TARGET).elf $(BUILDDIR)/$(TARGET).bin
hex:
	$(OBJCOPY) $(BUILDDIR)/$(TARGET).elf -Oihex $(BUILDDIR)/$(TARGET).hex
clean:
	$(RM) $(BUILDDIR)
upload:
	openocd -f ./stm32f103c8_blue_pill.cfg -c "program $(BUILDDIR)/$(TARGET).elf verify reset exit"

