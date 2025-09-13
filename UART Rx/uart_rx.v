module uart_rx
#(parameter UART_INPUT_CLK = 100_000_000 , baud_rate = 9600)
(
    input rx_en , // Enabling The Rx interface to receive data
    input clk , // Clock Signal
    input rst , // Synchronous Active High signal
    input arst_n , // Asynchronous Active Low Signal
    input rx , // Receiving Input 
    output busy , // Busy flag indicating that the module is receiving data now
    output done , // Done flag indicating that the module is completely received data
    output err , // Error Flag indicating that the stop bit is not received properly 
    output [7:0]data // Received Data
);

//Internal Signals 
wire arst_n_baud , BCLK ; // internal signals for edge detector interface
wire out_edge , arst_n_edge ; // internal signals for Baud Generator interface
wire en_sipo , rst_n_sipo ;// internal signals for SIPO(serial-in parallel-out) interface

//FSM Controller
fsm_rx controller(BCLK , out_edge , rx_en ,rst ,arst_n ,rx ,clk ,
    arst_n_edge ,arst_n_baud , en_sipo ,rst_n_sipo ,busy ,
    done ,err
);

//Falling Edge Detector
edge_detector falling_edge_detector(clk , rx , arst_n_edge ,out_edge) ;

//Baud Rate Generator 
baud_rate_generator #(.UART_INPUT_CLK(UART_INPUT_CLK), .baud_rate(baud_rate))
    baud_counter(clk , arst_n_baud , BCLK); // CLK = 100MHZ , Rate = 9600 

//SIPO Shift Register
sipo sipo_shift_reg(rx ,clk , rst_n_sipo , en_sipo  ,data);


endmodule