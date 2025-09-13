module fsm_rx(
    input BCLK , // Output of Baud Rate Generator  
    input out_edge , // Asserted to (1) when a falling edge is happened
    input rx_en , // Recieving Enable
    input rst ,  // Synchronous Reset
    input arst_n , // Asynchronous Reset
    input rx ,
    input clk , // Clock signal 
    //output rst_n_baud , // Reseting of Baud Rate Generator
    output reg arst_n_edge , //Reseting Edge detector 
    output reg arst_n_baud , // Reseting Baud Rate Generator
    output reg en_sipo , // Enable recieving of Data (Enable shifting of SIPO)
    output reg rst_n_sipo , // Reseting of Serial in parallel out register
    output reg busy , // Busy Flag 
    output reg done , // Done Flag 
    output reg err  // Error Flag
);

//Internal Signals 
reg [3:0] tick_current , tick_next ; // Handle the number of BCLK 
reg [2:0] recieved_current , recieved_next ; //Hanlde the number of Recieved bits

//States
reg [2:0] cs , ns ; // cs : Current State , ns : Next State
localparam IDLE = 3'd0 , START = 3'd1 , DATA = 3'd2 , STOP = 3'd3,
           ERROR = 3'd4 , DONE = 3'd5 ;

always @(posedge clk , negedge arst_n)
begin
    if((~arst_n) || (rst))
    begin
        {cs , tick_current , recieved_current} <= {IDLE , 4'd0 , 3'd0} ;
        {arst_n_baud , rst_n_sipo , arst_n_edge } <= 3'd0 ;
    end
    else if(rx_en)
        {cs , tick_current , recieved_current} <= {ns , tick_next , recieved_next} ;
    // else
    //     {cs , tick_current , recieved_current} <= {cs , tick_current , recieved_current} ;
end

//Next State Logic 
always @(*)
begin
    //Default Values 
    
    {busy , done , err} = {1'b0 , 1'b0 , 1'b0} ;
    {en_sipo , rst_n_sipo } = {1'b0 , 1'b0} ;
    // {tick_next , recieved_next } = 'd0 ;
    arst_n_edge = 1'b1 ;
    // rst_n_baud = 1'b0 ;

    case(cs)
        IDLE : 
        begin
            // if(rx_en)
            // begin
                if(out_edge) // Falling Edge Happened
                begin
                    arst_n_baud = 1'b1 ; // let the baud rate generator begin to count
                    tick_next = 'd0 ;
                    recieved_next = 'd0 ;
                    ns = START ;
                end
                else 
                    ns = IDLE ;
            // end
            // else 
            //     ns = cs ;
        end
        START : 
        begin
            // if(rx_en)
            // begin
                busy = 1'b1 ;
                en_sipo = 1'b0 ;
                
                if(BCLK)
                begin
                    // if(rx == 1'b0) // Checking the start bit is zero 
                    // begin
                        if(tick_current == 'd7) // Sampling 
                        begin
                            tick_next = 'd0 ;
                            ns = DATA ;
                        end
                        else
                        begin    
                            tick_next = tick_current + 1 ;  
                            ns = START ;
                        end
                    // end
                    // else 
                    // begin
                        // err = 1'b1 ;
                        // ns = IDLE ;
                    // end 
                end
                else 
                    ns = START ;
            // end
            // else 
            //     ns = cs ;
        end
        DATA :
        begin
            // if(rx_en)
            // begin
                busy = 1'b1 ;
                rst_n_sipo = 1'b1 ;
                if(BCLK)
                begin
                    
                    if(tick_current == 'd15)
                    begin
                        tick_next = 'd0 ;
                        en_sipo = 1'b1 ;
                        
                        if(recieved_current == 'd7)
                        begin
                            recieved_next = 'd0 ;
                            ns = STOP ;
                        end
                        else
                        begin 
                            recieved_next = recieved_current + 1 ;
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
            // end
            // else 
            //     ns = cs ;
        end
        STOP :
        begin
            // if(rx_en)
            // begin
                rst_n_sipo = 1'b1 ;
                if(BCLK)
                begin
                    if(tick_current == 'd15)
                    begin
                        tick_next = 'd0 ;
                        ns = (rx == 1'b1 ) ? DONE : ERROR ;
                    end
                    else
                    begin
                        tick_next = tick_current + 1 ; 
                        ns = STOP ;
                    end 
                end
            // end
            // else 
            //     ns = cs ;
        end
        ERROR :
        begin
            err = 1'b1 ;
            ns = IDLE ;
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