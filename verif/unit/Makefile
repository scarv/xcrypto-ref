
OUT_DIR     ?= $(XC_WORK)/unit

INPUTS      ?= $(shell find -name "*.S")
OUTPUTS     ?= $(addprefix $(OUT_DIR)/, $(INPUTS:%.S=%.hex))

AS           = $(RISCV)/bin/riscv32-unknown-elf-as
OBJDUMP      = $(RISCV)/bin/riscv32-unknown-elf-objdump

all: $(OUTPUTS)

$(OUT_DIR)/%.o : %.S
	@mkdir -p $(OUT_DIR)
	$(AS) -march=rv32ix -o $@ $<

$(OUT_DIR)/%.hex : $(OUT_DIR)/%.o
	$(OBJDUMP) -D -j.text $< | grep -P ":\t" > $@
	sed -i 's/     .*$///' $@
	sed -i 's/^.*:\t//' $@

clean:
	rm -rf $(OUTPUTS)
