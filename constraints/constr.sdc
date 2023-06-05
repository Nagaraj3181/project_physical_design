create_clock -period 30 [get_ports wclk] 
create_clock -period 15 [get_ports rclk] 
set_clock_latency -source 3 [get_clocks wclk]
set_clock_latency 2 [get_clocks rclk]
set_input_delay -max 5 -clock wclk [get_ports wdata]
set_output_delay -max 2 -clock rclk [get_ports rdata]

