`timescale 1ns / 1ns 
module uart_rx_tb();

//declare the local , reg , and wire identifiers
parameter UART_INPUT_CLK = 100_000_000 , baud_rate = 9600 ;
reg rx_en ; // Enabling The Rx interface to receive data
reg clk = 1'b0 ; // Clock Signal
reg rst ; // Synchronous Active High signal
reg arst_n ; // Asynchronous Active Low Signal
reg rx ; // Receiving Input 
wire busy ; // Busy flag indicating that the module is receiving data now
wire done ; // Done flag indicating that the module is completely received data
wire err ; // Error Flag indicating that the stop bit is not received properly 
wire [7:0]data; // Received Data

//Instantiate the module under test
uart_rx #(.UART_INPUT_CLK(UART_INPUT_CLK),.baud_rate(baud_rate)) DUT(rx_en ,clk ,rst ,arst_n ,rx ,busy ,done ,err ,data);

//Generate the Clock 
localparam T = 10 ;
always #(T/2) clk = ~ clk ;

//Task to Handle the inputs 
//The BCLK ticks for 6510 ns if the CLK = 10MHZ and the Baud Rate = 9600
//due to the divisor so the bit should be stable for 16 ticks of BCLK 
//so it should be stable for (6510*16) ns 

//Sequence to be received
localparam in = 8'b11010110 ;

// 6510 ns = (divisor * clock period) = (651 * 10) ns
localparam bit_period = (651 * T) * 16 ;
task driving_seq;
    input [7:0] seq ;
    integer i ;
    begin
        //Starting Bit
        rx = 1'b0 ;
        #(bit_period) ;
        //The Sequence
        for(i=0;i<8;i=i+1)
        begin
            rx = seq[7-i] ;
            // $display("@%0t , BCLK : " , $time , DUT.BCLK) ;
            #(bit_period) ;
        end
        //Stop Bit
        rx = 1'b1 ;
        #(bit_period) ;
        // rx_en = 1'b0 ;
        // #2 $stop ;
    end
endtask
//Create the Stimulus using initial 
initial
begin
    //1st Frame 
    //Async. Reseting 
    arst_n = 1'b0 ;
    rst = 1'b0 ;
    rx_en = 1'b1 ;
    rx = 1'b1 ; // IDLE State
    #2 arst_n = 1'b1 ;
    @(posedge clk) ;
    driving_seq(in);
    driving_seq(8'b11010100);
    // rx_en = 1'b0 ;
    //2nd Frame 
    // rst = 1'b1 ;
    // arst_n = 1'b1 ;
    // repeat(3) @(negedge clk) rst = 1'b0 ;
    // rx_en = 1'b1 ;
    // arst_n = 1'b0 ;
    // repeat(3) @(negedge clk) arst_n = 1'b1 ;
    // //Start Bit = 1'b1 ;
    // rx = 1'b1 ;
    // repeat(3) @(negedge clk) ;
    // driving_seq(8'b01010100);
    // rx_en = 1'b0 ;
    #2 $stop ;
end
endmodule