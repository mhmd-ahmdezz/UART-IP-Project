`timescale 1ns / 1ns 
module uart_tx_tb();

//declare the local , reg , and wire identifier
parameter UART_INPUT_CLK = 100_000_000 , baud_rate = 9600 ;
reg [7:0]data_in ; //Register contains the data to be sended
reg clk = 1'b0 ; // Clock Signal
reg rst ; // Synchronous Active High Reset 
reg arst_n ; //Asynchronous Active Low Reset
reg tx_en ; // Transmitting Enable Signal 
wire tx ; // The Transmitted bit
wire done ; //Done Flag is asserted if the transmission has already done
wire busy ;  //Busy Flag is asserted if the transmitter is sending data now

//Instantiate the module under test
uart_tx #(.UART_INPUT_CLK(UART_INPUT_CLK),.baud_rate(baud_rate)) 
DUT(data_in ,clk ,rst ,arst_n ,tx_en ,tx ,done , busy);

//Generate the clock 
localparam T = 10 ;
always #(T/2) clk = ~clk ;

//The BCLK ticks for 6510 ns if the CLK = 100MHZ and the Baud Rate = 9600
//due to the divisor so the bit should be stable for 16 ticks of BCLK 
//so it should be stable for (6510*16) ns 

// 6510 ns = (divisor * clock period) = (651 * 10) ns
localparam bit_period = (651 * T) * 16 ;

//Task to handle the transmission operation 
task driving_seq ;
    begin
        repeat(10)
        begin
            $display("@%0t , done : %0b , busy : %0b ,Transmitted : %0d",$time , done ,busy , DUT.fsm_controller.transmitted_current);
            #(bit_period);
        end
    end
endtask


//Create the stimulus using initial block
initial 
begin
    //1st Frame with Asynchronous Reset
    arst_n = 1'b0 ;
    rst = 1'b0 ;
    tx_en = 1'b0 ;
    data_in = 8'b11100110 ;
    #2 arst_n = 1'b1 ;
    tx_en = 1'b1 ;
    //First Frame : 
    driving_seq();
    // repeat(6) @(negedge clk);
    @(negedge done) ;
    //2nd Frame and Synchronous Reset Feature 
    // #30 ;
    // tx_en = 1'b0 ;
    // rst = 1'b1 ;
    // #10_000 rst = 1'b0 ;
    // data_in = 8'b01001011 ;
    // #2 tx_en = 1'b1 ;
    // driving_seq();
    // @(negedge done);
    // //3rd Frame 
    // tx_en = 1'b0 ;


    #2 $stop ;
end
endmodule