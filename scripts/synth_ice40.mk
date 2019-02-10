YOSYS=yosys
NEXTPNR=nextpnr-ice40
CHIPNAME?=chip
DEVICE?=hx8k
TIME_DEVICE?=hx$(DEVICE)
PACKAGE?=bg121

DEFINES+=FPGA TRISTATE_ICE40

# If you've set up the udev rule you can leave this as "iceprog"
ICEPROG=sudo iceprog

SYNTH_CMD=read_verilog $(addprefix -D,$(DEFINES)) $(SRCS); 
ifneq (,$(TOP))
	SYNTH_CMD+=hierarchy -top $(TOP); 
endif
SYNTH_CMD+=synth_ice40 -json $(CHIPNAME).json

# Kill implicit rules
.SUFFIXES:
.IMPLICIT:

.PHONY: all clean synth pnr bits prog

all: bit
synth: $(CHIPNAME).json
pnr: $(CHIPNAME).asc
bit: $(CHIPNAME).bin

srcs.mk: Makefile $(DOTF)
	$(SCRIPTS)/listfiles --relative -f make -o srcs.mk $(DOTF)

-include srcs.mk

$(CHIPNAME).json: $(SRCS)
	@echo ">>> Synth"
	@echo
	$(YOSYS) -p "$(SYNTH_CMD)" > synth.log
	tail -n 35 synth.log


$(CHIPNAME).asc: $(CHIPNAME).json $(CHIPNAME).pcf
	@echo
	@echo ">>> Place and Route"
	@echo
	$(NEXTPNR) -r --$(DEVICE) --package $(PACKAGE) --pcf $(CHIPNAME).pcf --json $(CHIPNAME).json --asc $(CHIPNAME).asc --quiet --log pnr.log
	@grep "Info: Max frequency" pnr.log | tail -n 1

$(CHIPNAME).bin: $(CHIPNAME).asc
	@echo
	@echo ">>> Generate Bitstream"
	@echo
	icepack $(CHIPNAME).asc $(CHIPNAME).bin

prog: $(CHIPNAME).bin
	@echo
	@echo ">>> Programming Device"
	@echo
	$(ICEPROG) $(CHIPNAME).bin

clean::
	rm -f $(CHIPNAME).json $(CHIPNAME).asc $(CHIPNAME).bin 
	rm -f synth.log pnr.log
	rm -f srcs.mk