set ip_directory "ip_repo"
set project_name "placeholderproject"
set ip_name "bondmachineip"
set part_number "xc7z010clg400-1"

create_project -f ${project_name} ${ip_directory}/${project_name} -part ${part_number}
set_property ip_repo_paths ${ip_directory} [current_project]
create_peripheral bondmachine.fisica.unipg.it user $ip_name 1.0 -dir ${ip_directory}
add_peripheral_interface S00_AXIS -interface_mode slave -axi_type stream [ipx::find_open_core bondmachine.fisica.unipg.it:user:bondmachineip:1.0]
add_peripheral_interface M00_AXIS -interface_mode master -axi_type stream [ipx::find_open_core bondmachine.fisica.unipg.it:user:bondmachineip:1.0]
generate_peripheral -force [ipx::find_open_core bondmachine.fisica.unipg.it:user:$ip_name:1.0]
write_peripheral [ipx::find_open_core bondmachine.fisica.unipg.it:user:${ip_name}:1.0]
update_ip_catalog
ipx::edit_ip_in_project -upgrade true -name bondmachineip_v1_0_project -directory ${ip_directory}/${project_name}.tmp/bondmachineip_v1_0_project ${ip_directory}/${ip_name}_1.0/component.xml
update_compile_order -fileset sources_1
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
update_compile_order -fileset sources_1
ipx::merge_project_changes files [ipx::current_core]
ipx::merge_project_changes hdl_parameters [ipx::current_core]
set_property core_revision 4 [ipx::current_core]
ipx::update_source_project_archive -component [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
ipx::move_temp_component_back -component [ipx::current_core]
close_project -delete
update_ip_catalog -rebuild -repo_path ${ip_directory}
close_project -delete
exit

