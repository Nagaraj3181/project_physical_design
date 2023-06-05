set_attribute lib_search_path ./library
set_attribute library fast.lib
set_attribute hdl_search_path ./rtl
read_hdl -sv design.v
elaborate
syn_generic
write_hdl > ./unmapped/design_generic.v
read_sdc ./constraints/constr.sdc
syn_map
write_hdl > ./mapped/design_mapped.v
write_sdc > ./mapped/design_mapped.sdc
report power > ./reports/design_power.txt
report area > ./reports/design_area.txt
report timing > ./reports/design_timing.txt
write_do_lec -no_exit -golden_design ./rtl/design.v -revised_design ./mapped/design_mapped.v > rtltog.lec.do
gui_show
