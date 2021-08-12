`include "FIFO_buffer.v"


module FIFO_buffer_tb;

    parameter DEPTH = 7;
    parameter WIDTH = 64;
    reg clk;
    reg rst;
    reg  [WIDTH-1:0] s_axis_tdata;
    reg m_axis_tready;
    reg s_axis_tvalid;
    wire s_axis_tready;
    wire m_axis_tvalid;
    wire [WIDTH-1:0]m_axis_tdata;

    localparam period = 100;  


    fifo #( 
        .abits(DEPTH),
        .dbits(WIDTH)

    )
    DUT
    (
        .clock(clk), 
        .reset(rst),
        .s_axis_tready(s_axis_tready),
        .m_axis_tvalid(m_axis_tvalid),
        .din(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .m_axis_tready(m_axis_tready),
        .dout(m_axis_tdata)

    );

        // simple write and read  
        initial begin
            $dumpfile("waveform_write.vcd");
            $dumpvars(0,FIFO_buffer_tb);
            
            clk = 1'b1;
            rst =1'b0;
            // m_axis_tready =1'b1;
            // s_axis_tvalid =1'b1;


        end

        always  #5 clk = ~clk;

        
        initial begin
            //write 
            
            rst = 1;

            #period; 
            rst = 0;
    
            #period;

            m_axis_tready =1'b0;
            s_axis_tvalid =1'b1;
            s_axis_tdata = 64'b0000000000000000000000000000000100000000000000000000000000000001;
            #period;
            m_axis_tready =1'b0;
            s_axis_tvalid =1'b1;
            s_axis_tdata = 64'b0000000000000000000000000000000100000000000000000000000000000010;
            #period;
            m_axis_tready =1'b0;
            s_axis_tvalid =1'b1;
            s_axis_tdata = 64'b0000000000000000000000000000000100000000000000000000000000000100;
            #period;
            m_axis_tready =1'b0;
            s_axis_tvalid =1'b1;
            s_axis_tdata = 64'b0000000000000000000000000000001000000000000000000000000000000001;
            #period;
            m_axis_tready =1'b0;
            s_axis_tvalid =1'b1;
            s_axis_tdata = 64'b0000000000000000000000000000001000000000000000000000000000000010;
            #period;
            m_axis_tready =1'b0;
            s_axis_tvalid =1'b1;
            s_axis_tdata = 64'b0000000000000000000000000000001000000000000000000000000000000100;
            #period;
            

            
            m_axis_tready =1'b1;
            s_axis_tvalid =1'b0;
            s_axis_tdata = 64'b0000000000000000000000000000001000000000000000000000000000001111;
            #period;
            
            // s_axis_tdata = 64'b0000000000000000000000000000000100000000000000000000000000000010;
            // m_axis_tready =1'b1;
            // s_axis_tvalid =1'b1;
            

            #period;
        end



endmodule