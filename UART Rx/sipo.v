//Serial-in parallel-out register
module sipo(
    input in ,clk , rst_n , en  ,
    output reg [7:0]data 
);

always @(posedge clk)
begin
    if(!rst_n)
        data <= 8'd0 ;
    else if(en)
        data <= {data[6:0] , in} ; 
end

endmodule