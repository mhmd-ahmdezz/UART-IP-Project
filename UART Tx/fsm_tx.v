module fsm_tx(
    input tx_en , // Transmitting Enable Signal 
    input [7:0]data , // The Transmitted Data 
    input rst , // Synchronous Active High Reset 
    input arst_n , //Asynchronous Active Low Reset
    input BCLK , // BCLK signal from Baud Rate Generator 
    input clk , // Clock Signal
    output reg arst_n_frame , //Asynchronous Active Low Reset of Frame
    output reg arst_n_baud , // Asynchronous Active Low Reset of Baud counter 
    output reg tx , // The Transmitted bit
    output reg done , //Done Flag is asserted if the transmission has already done
    output reg busy  //Busy Flag is asserted if the transmitter is sending data now
);
//State
localparam IDLE = 3'd0 , START = 3'd1 , DATA = 3'd2 , STOP = 3'd3 , DONE = 3'd4 ;

reg [2:0] cs , ns ; // cs : current State , ns : next State

reg [3:0]tick_current , tick_next ; // Tick Counter to handle the counting of BCLK 
reg [2:0]transmitted_current , transmitted_next ; // Transmitted counter to handle 
// the number of bits that has transmitted

always @(posedge clk , negedge arst_n)
begin
    if( (~arst_n) || (rst))
    begin
        {cs , tick_current , transmitted_current} <= {IDLE , 4'd0 , 3'd0};
        {arst_n_baud , arst_n_frame,done , busy} <= 'd0 ;
    end
    else if(tx_en)
        {cs , tick_current , transmitted_current} <= {ns , tick_next , transmitted_next} ;
end

//Next State Logic 
always @(*)
begin
    //Default Values 
    {done , busy } = 'd0;
    {transmitted_next,tick_next} = {transmitted_current,tick_current} ;
    case(cs)
        IDLE : 
        begin
            if(tx_en)
            begin
                arst_n_baud = 1'b0 ;
                arst_n_frame = 1'b0 ;
                {transmitted_next,tick_next} = {3'd0,4'd0} ;
                {done , busy , tx} = {1'b0 , 1'b0 , 1'b1} ;
                ns = START ;
            end
            else 
                ns = IDLE ;
        end
        START : 
        begin
            if(tx_en)
            begin
                busy = 1'b1 ;
                arst_n_baud = 1'b1 ;
                arst_n_frame = 1'b1 ;
                tx = 1'b0 ; // Start bit 
                if(BCLK)
                begin
                    if(tick_current == 'd15)
                    begin
                        tick_next = 'd0 ;
                        ns = DATA ;
                    end
                    else
                    begin
                        tick_next = tick_current + 1 ;
                        ns = START ;
                    end 
                end
                else 
                    ns = START ;
            end
            else 
                ns = START ;
        end
        DATA :
        begin
            if(tx_en)
            begin
                // rst_n_baud = 1'b1 ;
                busy = 1'b1 ;
                tx = data[transmitted_current] ;
                if(BCLK)
                begin
                    if(tick_current == 'd15)
                    begin
                        tick_next = 'd0 ;
                        if(transmitted_current == 'd7)
                        begin
                            transmitted_next = 'd0 ;
                            ns = STOP ;
                        end
                        else 
                        begin
                            transmitted_next = transmitted_current + 1 ;
                            ns = DATA ;
                        end
                    end
                else
                begin
                    tick_next = tick_current + 1 ;
                    ns = DATA ;
                end
                end
                else 
                    ns = DATA ;
                    
            end
            else 
                ns = DATA ;
        end
        STOP :
        begin
            if(tx_en)
            begin
                tx = 1'b1 ;
                arst_n_baud = 1'b1 ;
                // busy = 1'b1 ;
                if(BCLK)
                begin
                    if(tick_current == 'd15)
                    begin
                        tick_next = 'd0 ;
                        ns = DONE ;
                    end
                    else
                    begin
                        tick_next = tick_current + 1 ;
                        ns = STOP ;
                    end
                end
                else 
                    ns = STOP ;
            end
            else 
                ns = STOP ;
        end
        DONE :
        begin
            done = 1'b1 ;
            ns = IDLE ;
        end
        default : ns = IDLE ;
    endcase
end
endmodule