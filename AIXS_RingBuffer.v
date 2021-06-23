module axis_buffer #(parameter depth = 128, width = 64)(
    input clk,
    input rst,
    input [width-1:0] s_axis_tdata,
    input m_axis_tready,
    input s_axis_tvalid,
    output s_axis_treeady,
    output m_axis_tvaild,
    output [width-1:0]m_axis_tdata,


);

fifo axis_buffer_im 
#( 
    .abits(depth),
    .dbits(width),

)
(
    .clock(clk), 
    .reset(rst),
    .wr(s_axis_tvalid),
    .rd(m_axis_tvaild),
    .din(s_axis_tdata),
    .empty(s_axis_tvalid),
    .full(m_axis_tvaild),
    .dout(m_axis_tdata)

)



endmodule