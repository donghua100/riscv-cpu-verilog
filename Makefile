TOPNAME = top
VERILATOR = verilator
VERILATOR_CFLAGS += -MMD --build --cc \
					-O3 --x-assign fast --x-initial fast --noassert \
					--trace --relative-includes
CSRC_DIR = ./csrc
VSRC_DIR = ./vsrc
BUILD_DIR = ./build
OBJ_DIR = $(BUILD_DIR)/obj_dir
INC_PATH = $(BUILD_DIR)/obj_dir
BIN = $(BUILD_DIR)/$(TOPNAME)

$(shell mkdir -p $(BUILD_DIR))
VSRCS = $(shell find $(abspath $(VSRC_DIR)) -name "*.v")
CSRCS = $(shell find $(abspath $(CSRC_DIR)) -name "*.cc" -or -name "*.c" -or -name "*.cpp")
INCFLAGS = $(addprefix -I, $(INC_PATH))
CFLAGS += $(INCFLAGS)
DUMPFILE = $(BUILD_DIR)/dump.vcd
#LDFLAGS +=
$(BIN): $(VSRCS) $(CSRCS)
	@rm -rf $(OBJ_DIR)
	$(VERILATOR) $(VERILATOR_CFLAGS) \
		--top-module $(TOPNAME) $^ \
		$(addprefix -CFLAGS ,$(CFLAGS)) \
		-Mdir $(OBJ_DIR) --exe -o $(abspath $(BIN))

run:$(BIN)
	@$^ +trace

clean:
	-rm -rf $(BUILD_DIR)

.PHONY: test verilog help compile bsp reformat checkformat clean

sim:$(DUMPFILE)
	@gtkwave $^


