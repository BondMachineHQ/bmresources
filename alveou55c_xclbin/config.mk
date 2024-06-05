VIVADO := $(XILINX_VIVADO)/bin/vivado
$(TEMP_DIR)/bondmachine.xo: src/krnl_bondmachine/package_kernel.tcl src/krnl_bondmachine/gen_xo.tcl src/krnl_bondmachine/hdl/*.sv src/krnl_bondmachine/hdl/*.v 
	mkdir -p $(TEMP_DIR)
	$(VIVADO) -mode batch -source src/krnl_bondmachine/gen_xo.tcl -tclargs $(TEMP_DIR)/bondmachine.xo $(TARGET) $(PLATFORM) $(XSA)
