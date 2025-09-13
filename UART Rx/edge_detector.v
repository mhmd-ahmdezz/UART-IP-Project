//Mealy Falling Edge Detector

module edge_detector(
    input clk , level , arst_n ,
    output fall 
);

//Storage Elements
localparam IDLE = 2'd0 , zero = 2'd1 , one = 2'd2 ;
reg [1:0] cs , ns ;

always @(posedge clk , negedge arst_n)
begin
    if(!arst_n)
        cs <= IDLE ;
    else 
        cs <= ns ;
end

//Next state logic 
always @(*)
begin
    case(cs)
        IDLE : ns = (level) ? one : zero ;
        zero : ns = (level) ? one : zero ;
        one  : ns = (level) ? one : zero ;
    endcase
end

//Output Logic 
assign fall = (cs == one ) && (~level) ;
endmodule