# ####################################################################

#  Created by Genus(TM) Synthesis Solution 20.11-s111_1 on Mon May 08 18:49:30 IST 2023

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design async_fifo1

create_clock -name "wclk" -period 30.0 -waveform {0.0 15.0} [get_ports wclk]
create_clock -name "rclk" -period 15.0 -waveform {0.0 7.5} [get_ports rclk]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks wclk] -add_delay -max 5.0 [get_ports {wdata[7]}]
set_input_delay -clock [get_clocks wclk] -add_delay -max 5.0 [get_ports {wdata[6]}]
set_input_delay -clock [get_clocks wclk] -add_delay -max 5.0 [get_ports {wdata[5]}]
set_input_delay -clock [get_clocks wclk] -add_delay -max 5.0 [get_ports {wdata[4]}]
set_input_delay -clock [get_clocks wclk] -add_delay -max 5.0 [get_ports {wdata[3]}]
set_input_delay -clock [get_clocks wclk] -add_delay -max 5.0 [get_ports {wdata[2]}]
set_input_delay -clock [get_clocks wclk] -add_delay -max 5.0 [get_ports {wdata[1]}]
set_input_delay -clock [get_clocks wclk] -add_delay -max 5.0 [get_ports {wdata[0]}]
set_output_delay -clock [get_clocks rclk] -add_delay -max 2.0 [get_ports {rdata[7]}]
set_output_delay -clock [get_clocks rclk] -add_delay -max 2.0 [get_ports {rdata[6]}]
set_output_delay -clock [get_clocks rclk] -add_delay -max 2.0 [get_ports {rdata[5]}]
set_output_delay -clock [get_clocks rclk] -add_delay -max 2.0 [get_ports {rdata[4]}]
set_output_delay -clock [get_clocks rclk] -add_delay -max 2.0 [get_ports {rdata[3]}]
set_output_delay -clock [get_clocks rclk] -add_delay -max 2.0 [get_ports {rdata[2]}]
set_output_delay -clock [get_clocks rclk] -add_delay -max 2.0 [get_ports {rdata[1]}]
set_output_delay -clock [get_clocks rclk] -add_delay -max 2.0 [get_ports {rdata[0]}]
set_wire_load_mode "enclosed"
set_clock_latency -source 3.0 [get_clocks wclk]
set_clock_latency  2.0 [get_clocks rclk]
