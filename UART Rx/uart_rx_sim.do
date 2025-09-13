quit -sim
vlib work
vlog ../Edge_Detector/edge_detector.v
vlog ../Baud_Rate_Generator/baud_rate_generator.v
vlog ../SIPO/sipo.v
vlog ../FSM/fsm_rx.v
vlog uart_rx.v uart_rx_tb.v
vsim work.uart_rx_tb
add wave *
add wave -position insertpoint  \
sim:/uart_rx_tb/DUT/BCLK
add wave -position insertpoint  \
sim:/uart_rx_tb/DUT/controller/tick_current \
sim:/uart_rx_tb/DUT/controller/tick_next \
sim:/uart_rx_tb/DUT/controller/recieved_current \
sim:/uart_rx_tb/DUT/controller/recieved_next \
sim:/uart_rx_tb/DUT/controller/cs \
sim:/uart_rx_tb/DUT/controller/ns
#add wave -position insertpoint  \
#sim:/uart_rx_tb/DUT/controller/BCLK \
#sim:/uart_rx_tb/DUT/controller/out_edge \
#sim:/uart_rx_tb/DUT/controller/rx_en \
#sim:/uart_rx_tb/DUT/controller/rst \
#sim:/uart_rx_tb/DUT/controller/arst_n \
#sim:/uart_rx_tb/DUT/controller/rx \
#sim:/uart_rx_tb/DUT/controller/clk \
#sim:/uart_rx_tb/DUT/controller/rst_n_edge \
#sim:/uart_rx_tb/DUT/controller/rst_n_baud \
#sim:/uart_rx_tb/DUT/controller/en_sipo \
#sim:/uart_rx_tb/DUT/controller/rst_n_sipo \
#sim:/uart_rx_tb/DUT/controller/busy \
#sim:/uart_rx_tb/DUT/controller/done \
#sim:/uart_rx_tb/DUT/controller/err \
#sim:/uart_rx_tb/DUT/controller/tick_current \
#sim:/uart_rx_tb/DUT/controller/tick_next \
#sim:/uart_rx_tb/DUT/controller/recieved_current \
#sim:/uart_rx_tb/DUT/controller/recieved_next \
#sim:/uart_rx_tb/DUT/controller/cs \
#sim:/uart_rx_tb/DUT/controller/ns
#add wave -position insertpoint  \
#sim:/uart_rx_tb/DUT/falling_edge_detector/level \
#sim:/uart_rx_tb/DUT/falling_edge_detector/arst_n \
#sim:/uart_rx_tb/DUT/falling_edge_detector/fall \
#sim:/uart_rx_tb/DUT/falling_edge_detector/cs \
#sim:/uart_rx_tb/DUT/falling_edge_detector/ns
#add wave -position insertpoint  \
#sim:/uart_rx_tb/DUT/baud_counter/arst_n \
#sim:/uart_rx_tb/DUT/baud_counter/BCLK \
#sim:/uart_rx_tb/DUT/baud_counter/divisor \
#sim:/uart_rx_tb/DUT/baud_counter/counter
#add wave -position insertpoint  \
#sim:/uart_rx_tb/DUT/sipo_shift_reg/in \
#sim:/uart_rx_tb/DUT/sipo_shift_reg/rst_n \
#sim:/uart_rx_tb/DUT/sipo_shift_reg/en \
#sim:/uart_rx_tb/DUT/sipo_shift_reg/data
run -all