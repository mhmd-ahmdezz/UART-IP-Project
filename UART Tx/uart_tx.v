module uart_tx
#(parameter UART_INPUT_CLK = 100_000_000 , baud_rate = 9600)
(
    input [7:0]data_in , //Register contains the data to be sended
    input clk , // Clock Signal
    input rst , // Synchronous Active High Reset 
    input arst_n , //Asynchronous Active Low Reset
    input tx_en , // Transmitting Enable Signal 
    output  tx , // The Transmitted bit
    output  done , //Done Flag is asserted if the transmission has already done
    output  busy  //Busy Flag is asserted if the transmitter is sending data now
);

//Internal Signals 
wire arst_n_baud , BCLK , arst_n_frame ;
wire [7:0]data_out ;


//Frame
frame data_register(clk , arst_n_frame ,data_in ,data_out);

//Baud Rate Generator 
baud_rate_generator #(.UART_INPUT_CLK(UART_INPUT_CLK), .baud_rate(baud_rate))
baud_counter( clk , arst_n_baud , BCLK );

//FSM Controller 
fsm_tx fsm_controller(tx_en ,data_out ,rst ,arst_n ,BCLK ,clk ,
    arst_n_frame ,arst_n_baud ,tx , done , busy);


endmodule