SHELL := /bin/bash
## top & syn
LOCAL	:= $(dir $(lastword $(MAKEFILE_LIST)))

VIVADO_PATH_SET = $(LOCAL)path_vivado.sh
WRPC_SW_PATH = $(LOCAL)/elf/wrc.elf

cute_a7_ipbus_dir	:= $(LOCAL)syn/cute_a7_ipbus/
cute_a7_ipbus_top	:= $(LOCAL)top/cute_a7_ipbus/
cute_a7_ipbus_bit_tgt = $(cute_a7_ipbus_dir)/cute_a7_ipbus.runs/impl_1/cute_a7_ipbus.bit
cute_a7_ipbus_mcs_tgt = $(cute_a7_ipbus_dir)/cute_a7_ipbus.runs/impl_1/cute_a7_ipbus.mcs
cute_a7_ipbus_elf_bit_tgt = $(cute_a7_ipbus_dir)/cute_a7_ipbus.runs/cute_a7_ipbus_elf.bit
cute_a7_ipbus_elf_mcs_tgt = $(cute_a7_ipbus_dir)/cute_a7_ipbus.runs/cute_a7_ipbus_elf.mcs

cute_a7_gmii_dir	:= $(LOCAL)syn/cute_a7_gmii/
cute_a7_gmii_top	:= $(LOCAL)top/cute_a7_gmii/
cute_a7_gmii_bit_tgt = $(cute_a7_gmii_dir)/cute_a7_gmii.runs/impl_1/cute_a7_gmii.bit
cute_a7_gmii_mcs_tgt = $(cute_a7_gmii_dir)/cute_a7_gmii.runs/impl_1/cute_a7_gmii.mcs
cute_a7_gmii_elf_bit_tgt = $(cute_a7_gmii_dir)/cute_a7_gmii.runs/cute_a7_gmii_elf.bit
cute_a7_gmii_elf_mcs_tgt = $(cute_a7_gmii_dir)/cute_a7_gmii.runs/cute_a7_gmii_elf.mcs

cute_a7_golden_dir	:= $(LOCAL)syn/golden/
cute_a7_golden_top	:= $(LOCAL)top/cute_a7_gmii/
cute_a7_golden_bit_tgt = $(cute_a7_golden_dir)/cute_a7_gmii.runs/impl_1/cute_a7_gmii.bit
cute_a7_golden_mcs_tgt = $(cute_a7_golden_dir)/cute_a7_gmii.runs/impl_1/cute_a7_gmii.mcs
cute_a7_golden_elf_bit_tgt = $(cute_a7_golden_dir)/cute_a7_gmii.runs/cute_a7_gmii_elf.bit
cute_a7_golden_elf_mcs_tgt = $(cute_a7_golden_dir)/cute_a7_gmii.runs/cute_a7_gmii_elf.mcs

cute_a7_35t_ipbus_bit_tgt = $(cute_a7_ipbus_dir)/cute_a7_35t_ipbus.runs/impl_1/cute_a7_ipbus.bit
cute_a7_35t_ipbus_mcs_tgt = $(cute_a7_ipbus_dir)/cute_a7_35t_ipbus.runs/impl_1/cute_a7_ipbus.mcs
cute_a7_35t_ipbus_elf_bit_tgt = $(cute_a7_ipbus_dir)/cute_a7_35t_ipbus.runs/cute_a7_35t_ipbus_elf.bit
cute_a7_35t_ipbus_elf_mcs_tgt = $(cute_a7_ipbus_dir)/cute_a7_35t_ipbus.runs/cute_a7_35t_ipbus_elf.mcs

cute_a7_35t_gmii_bit_tgt = $(cute_a7_gmii_dir)/cute_a7_35t_gmii.runs/impl_1/cute_a7_gmii.bit
cute_a7_35t_gmii_mcs_tgt = $(cute_a7_gmii_dir)/cute_a7_35t_gmii.runs/impl_1/cute_a7_gmii.mcs
cute_a7_35t_gmii_elf_bit_tgt = $(cute_a7_gmii_dir)/cute_a7_35t_gmii.runs/cute_a7_35t_gmii_elf.bit
cute_a7_35t_gmii_elf_mcs_tgt = $(cute_a7_gmii_dir)/cute_a7_35t_gmii.runs/cute_a7_35t_gmii_elf.mcs

cute_a7_35t_golden_bit_tgt = $(cute_a7_golden_dir)/cute_a7_35t_gmii.runs/impl_1/cute_a7_gmii.bit
cute_a7_35t_golden_mcs_tgt = $(cute_a7_golden_dir)/cute_a7_35t_gmii.runs/impl_1/cute_a7_gmii.mcs
cute_a7_35t_golden_elf_bit_tgt = $(cute_a7_golden_dir)/cute_a7_35t_gmii.runs/cute_a7_gmii_elf.bit
cute_a7_35t_golden_elf_mcs_tgt = $(cute_a7_golden_dir)/cute_a7_35t_gmii.runs/cute_a7_gmii_elf.mcs


.PHONY: ipbus_compile_project \
	ipbus_update_elf \
	ipbus_update_flash \
	ipbus_update_flash_elf \
	ipbus_program program_elf \
	ipbus_program_flash \
	ipbus_program_flash_elf \
	gmii_compile_project \
	gmii_update_elf \
	gmii_update_flash \
	gmii_update_flash_elf \
	gmii_program program_elf \
	gmii_program_flash \
	gmii_program_flash_elf \
	golden_compile_project \
	golden_update_elf \
	golden_update_flash \
	golden_update_flash_elf \
	golden_program program_elf \
	golden_program_flash \
	golden_program_flash_elf \
	ipbus_compile_project_35t \
	ipbus_update_elf_35t \
	ipbus_update_flash_35t \
	ipbus_update_flash_elf_35t \
	ipbus_program_35t program_elf \
	ipbus_program_flash_35t \
	ipbus_program_flash_elf_35t \
	gmii_compile_project_35t \
	gmii_update_elf_35t \
	gmii_update_flash_35t \
	gmii_update_flash_elf_35t \
	gmii_program_35t program_elf \
	gmii_program_flash_35t \
	gmii_program_flash_elf_35t \
	golden_compile_project_35t \
	golden_update_elf_35t \
	golden_update_flash_35t \
	golden_update_flash_elf_35t \
	golden_program_35t program_elf \
	golden_program_flash_35t \
	golden_program_flash_elf_35t


ipbus_compile_project :
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh compile_project "$(cute_a7_ipbus_dir)/cute_a7_ipbus.xpr"

ipbus_update_elf:$(WRPC_SW_PATH) $(cute_a7_ipbus_bit_tgt) 
	source $(VIVADO_PATH_SET) && updatemem -meminfo $(cute_a7_ipbus_top)/cute_a7_ipbus.mmi -data $(WRPC_SW_PATH) \
	-bit $(cute_a7_ipbus_bit_tgt) -proc dummy -out $(cute_a7_ipbus_elf_bit_tgt) -force
	rm updatemem.log
	rm updatemem.jou

ipbus_flash: $(cute_a7_ipbus_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh generate_mcs $< $(cute_a7_ipbus_mcs_tgt)

ipbus_flash_elf: $(cute_a7_ipbus_elf_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh generate_mcs $< $(cute_a7_ipbus_elf_mcs_tgt)

ipbus_program: $(cute_a7_ipbus_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_fpga $<

ipbus_program_elf: $(cute_a7_ipbus_elf_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_fpga $<

ipbus_program_flash: $(cute_a7_ipbus_mcs_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_flash $<

ipbus_program_flash_elf: $(cute_a7_ipbus_elf_mcs_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_flash $<

gmii_compile_project :
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh compile_project "$(cute_a7_gmii_dir)/cute_a7_gmii.xpr"

gmii_update_elf:$(WRPC_SW_PATH) $(cute_a7_gmii_bit_tgt) 
	source $(VIVADO_PATH_SET) && updatemem -meminfo $(cute_a7_gmii_top)/cute_a7_gmii.mmi -data $(WRPC_SW_PATH) \
	-bit $(cute_a7_gmii_bit_tgt) -proc dummy -out $(cute_a7_gmii_elf_bit_tgt) -force
	rm updatemem.log
	rm updatemem.jou

gmii_flash: $(cute_a7_gmii_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh generate_mcs $< $(cute_a7_gmii_mcs_tgt)

gmii_flash_elf: $(cute_a7_gmii_elf_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh generate_mcs $< $(cute_a7_gmii_elf_mcs_tgt)

gmii_program: $(cute_a7_gmii_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_fpga $<

gmii_program_elf: $(cute_a7_gmii_elf_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_fpga $<

gmii_program_flash: $(cute_a7_gmii_mcs_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_flash $<

gmii_program_flash_elf: $(cute_a7_gmii_elf_mcs_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_flash $<

golden_compile_project :
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh compile_project "$(cute_a7_golden_dir)/cute_a7_gmii.xpr"

golden_update_elf:$(WRPC_SW_PATH) $(cute_a7_golden_bit_tgt) 
	source $(VIVADO_PATH_SET) && updatemem -meminfo $(cute_a7_gmii_top)/cute_a7_gmii.mmi -data $(WRPC_SW_PATH) \
	-bit $(cute_a7_golden_bit_tgt) -proc dummy -out $(cute_a7_golden_elf_bit_tgt) -force
	rm updatemem.log
	rm updatemem.jou

golden_flash: $(cute_a7_golden_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh generate_mcs $< $(cute_a7_golden_mcs_tgt)

golden_flash_elf: $(cute_a7_golden_elf_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh generate_mcs $< $(cute_a7_golden_elf_mcs_tgt)

golden_program: $(cute_a7_golden_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_fpga $<

golden_program_elf: $(cute_a7_golden_elf_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_fpga $<

golden_program_flash: $(cute_a7_golden_mcs_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_flash $<

golden_program_flash_elf: $(cute_a7_golden_elf_mcs_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_flash $<


#### 35t

ipbus_compile_project_35t :
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh compile_project "$(cute_a7_ipbus_dir)/cute_a7_35t_ipbus.xpr"

ipbus_update_elf_35t:$(WRPC_SW_PATH) $(cute_a7_35t_ipbus_bit_tgt) 
	source $(VIVADO_PATH_SET) && updatemem -meminfo $(cute_a7_ipbus_top)/cute_a7_35t_ipbus.mmi -data $(WRPC_SW_PATH) \
	-bit $(cute_a7_35t_ipbus_bit_tgt) -proc dummy -out $(cute_a7_35t_ipbus_elf_bit_tgt) -force
	rm updatemem.log
	rm updatemem.jou

ipbus_flash_35t: $(cute_a7_35t_ipbus_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh generate_mcs $< $(cute_a7_35t_ipbus_mcs_tgt)

ipbus_flash_elf_35t: $(cute_a7_35t_ipbus_elf_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh generate_mcs $< $(cute_a7_35t_ipbus_elf_mcs_tgt)

ipbus_program_35t: $(cute_a7_35t_ipbus_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_fpga $<

ipbus_program_elf_35t: $(cute_a7_35t_ipbus_elf_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_fpga $<

ipbus_program_flash_35t: $(cute_a7_35t_ipbus_mcs_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_flash $<

ipbus_program_flash_elf_35t: $(cute_a7_35t_ipbus_elf_mcs_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_flash $<

gmii_compile_project_35t :
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh compile_project "$(cute_a7_gmii_dir)/cute_a7_35t_gmii.xpr"

gmii_update_elf_35t:$(WRPC_SW_PATH) $(cute_a7_35t_gmii_bit_tgt) 
	source $(VIVADO_PATH_SET) && updatemem -meminfo $(cute_a7_gmii_top)/cute_a7_35t_gmii.mmi -data $(WRPC_SW_PATH) \
	-bit $(cute_a7_35t_gmii_bit_tgt) -proc dummy -out $(cute_a7_35t_gmii_elf_bit_tgt) -force
	rm updatemem.log
	rm updatemem.jou

gmii_flash_35t: $(cute_a7_35t_gmii_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh generate_mcs $< $(cute_a7_35t_gmii_mcs_tgt)

gmii_flash_elf_35t: $(cute_a7_35t_gmii_elf_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh generate_mcs $< $(cute_a7_35t_gmii_elf_mcs_tgt)

gmii_program_35t: $(cute_a7_35t_gmii_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_fpga $<

gmii_program_elf_35t: $(cute_a7_35t_gmii_elf_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_fpga $<

gmii_program_flash_35t: $(cute_a7_35t_gmii_mcs_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_flash $<

gmii_program_flash_elf_35t: $(cute_a7_35t_gmii_elf_mcs_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_flash $<

golden_compile_project_35t :
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh compile_project "$(cute_a7_golden_dir)/cute_a7_35t_gmii.xpr"

golden_update_elf_35t:$(WRPC_SW_PATH) $(cute_a7_35t_golden_bit_tgt) 
	source $(VIVADO_PATH_SET) && updatemem -meminfo $(cute_a7_gmii_top)/cute_a7_gmii.mmi -data $(WRPC_SW_PATH) \
	-bit $(cute_a7_35t_golden_bit_tgt) -proc dummy -out $(cute_a7_35t_golden_elf_bit_tgt) -force
	rm updatemem.log
	rm updatemem.jou

golden_flash_35t: $(cute_a7_35t_golden_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh generate_mcs $< $(cute_a7_35t_golden_mcs_tgt)

golden_flash_elf_35t: $(cute_a7_35t_golden_elf_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh generate_mcs $< $(cute_a7_35t_golden_elf_mcs_tgt)

golden_program_35t: $(cute_a7_35t_golden_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_fpga $<

golden_program_elf_35t: $(cute_a7_35t_golden_elf_bit_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_fpga $<

golden_program_flash_35t: $(cute_a7_35t_golden_mcs_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_flash $<

golden_program_flash_elf_35t: $(cute_a7_35t_golden_elf_mcs_tgt)
	source $(VIVADO_PATH_SET) && ./tools/tcl/run_cute_a7_tcl.sh program_flash $<
