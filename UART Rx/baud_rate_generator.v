`timescale 1ns / 1ns 
module baud_rate_generator
#(parameter UART_INPUT_CLK = 10000000 , baud_rate = 9600)
(
    input clk , arst_n , // Clock signal , and asynchronous active low reset signal
    output reg BCLK 
);

//16-bit Divisor 
wire [15:0]divisor ;
assign divisor = (UART_INPUT_CLK) / (baud_rate*16) ;

//Modulo-16 Counter 
reg [15:0] counter ;

always @(posedge clk ,negedge arst_n)
begin
    if(!arst_n)
        {counter , BCLK} <= {4'd0 , 1'b0} ;
    else if(counter == divisor-1)
        {counter , BCLK} <= {4'd0 , 1'b1} ;
    else 
        {counter , BCLK} <= {counter+1 , 1'b0} ;
end

endmodule