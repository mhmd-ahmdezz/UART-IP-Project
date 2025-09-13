//Parallel load  register
module frame(
    input clk , arst_n ,
    input [7:0]in ,
    output reg [7:0]Q
);

always @(posedge clk , negedge arst_n)
begin
    if(~arst_n)
        Q <= 'd0 ;
    else
        Q <= in ;
end
endmodule