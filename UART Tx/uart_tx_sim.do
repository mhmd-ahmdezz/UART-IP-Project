quit -sim
vlib work
vlog ../Frame/frame.v
vlog ../Edge_Detector/edge_detector.v
vlog ../Baud_Rate_Generator/baud_rate_generator.v
vlog ../SIPO/sipo.v
vlog ../FSM/fsm_tx.v
vlog uart_tx.v uart_tx_tb.v
vsim work.uart_tx_tb
add wave *
add wave -position insertpoint  \
sim:/uart_tx_tb/DUT/fsm_controller/cs \
sim:/uart_tx_tb/DUT/fsm_controller/ns
add wave -position insertpoint  \
sim:/uart_tx_tb/DUT/BCLK
run -all