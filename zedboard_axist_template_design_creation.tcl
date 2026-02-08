set ip_directory "ip_repo"
set project_name "bmaccelerator"
set ip_name "bondmachineip"
set project_dir "bmaccelerator"
set part_number "xc7z020clg484-1"

create_project ${project_name} ${project_dir} -part ${part_number}
set_property board_part em.avnet.com:zed:part0:1.4 [current_project]
set_property ip_repo_paths ${ip_directory} [current_project]
update_ip_catalog
create_bd_design "bm_design"
open_bd_design ${project_dir}/${project_name}.srcs/sources_1/bd/bm_design/bm_design.bd
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
create_bd_cell -type ip -vlnv bondmachine.fisica.unipg.it:user:${ip_name}:1_0 ${ip_name}_0
save_bd_design
endgroup

ipx::edit_ip_in_project -upgrade true -name ${ip_name}_v1_0_project -directory ${project_dir}/${project_name}.tmp/${ip_name}_v1_0_project ${ip_directory}/${ip_name}_1_0/component.xml
update_compile_order -fileset sources_1
add_files -norecurse -scan_for_includes ${ip_directory}/${ip_name}_1_0/hdl/bondmachine.sv
update_compile_order -fileset sources_1
add_files -norecurse -scan_for_includes ${ip_directory}/${ip_name}_1_0/hdl/bondmachine.vhd
update_compile_order -fileset sources_1
ipx::open_ipxact_file ${ip_directory}/${ip_name}_1_0/component.xml
ipx::merge_project_changes hdl_parameters [ipx::current_core]
set_property core_revision 4 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
update_ip_catalog -rebuild
close_project
close_project

open_project ${project_dir}/${project_name}.xpr
open_bd_design ${project_dir}/${project_name}.srcs/sources_1/bd/bm_design/bm_design.bd
upgrade_ip -vlnv bondmachine.fisica.unipg.it:user:${ip_name}:1_0 [get_ips  bm_design_${ip_name}_0_0] -log ip_upgrade.log
export_ip_user_files -of_objects [get_ips bm_design_${ip_name}_0_0] -no_script -sync -force -quiet

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0
endgroup

set_property -dict [list CONFIG.c_s_axis_s2mm_tdata_width.VALUE_SRC USER] [get_bd_cells axi_dma_0]
set_property -dict [list CONFIG.c_include_sg {0} CONFIG.c_sg_length_width {26} CONFIG.c_sg_include_stscntrl_strm {0} CONFIG.c_s2mm_burst_size {256}] [get_bd_cells axi_dma_0]

connect_bd_intf_net [get_bd_intf_pins ${ip_name}_0/M00_AXIS] [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM]
connect_bd_intf_net [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins ${ip_name}_0/S00_AXIS]

startgroup
set_property -dict [list CONFIG.PCW_USE_S_AXI_HP0 {1} CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1}] [get_bd_cells processing_system7_0]
endgroup

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0
endgroup

set_property -dict [list CONFIG.NUM_SI {2} CONFIG.NUM_MI {1}] [get_bd_cells axi_interconnect_0]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins axi_dma_0/M_AXI_MM2S]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/S01_AXI] [get_bd_intf_pins axi_dma_0/M_AXI_S2MM]
connect_bd_intf_net [get_bd_intf_pins processing_system7_0/S_AXI_HP0] -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M00_AXI]

startgroup
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/processing_system7_0/FCLK_CLK0 (100 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins axi_dma_0/m_axi_mm2s_aclk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/processing_system7_0/FCLK_CLK0 (100 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins axi_dma_0/m_axi_s2mm_aclk]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/axi_dma_0/S_AXI_LITE} ddr_seg {Auto} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/processing_system7_0/FCLK_CLK0 (100 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins axi_interconnect_0/ACLK]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/processing_system7_0/FCLK_CLK0 (100 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins axi_interconnect_0/M00_ACLK]
endgroup

assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force

save_bd_design

validate_bd_design
make_wrapper -files [get_files ${project_dir}/${project_name}.srcs/sources_1/bd/bm_design/bm_design.bd] -top
update_compile_order -fileset sources_1
add_files -norecurse -scan_for_includes ${project_dir}/${project_name}.srcs/sources_1/bd/bm_design/hdl/bm_design_wrapper.v
update_compile_order -fileset sources_1
add_files -fileset constrs_1 -norecurse zedboard.xdc
update_compile_order -fileset sources_1

close_project
exit
