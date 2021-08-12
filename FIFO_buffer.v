module fifo # (parameter abits =7, dbits = 64)(
    input clock,
    input reset,
    input  m_axis_tready,
    input  s_axis_tvalid,
    input  [dbits-1:0] din,
    output s_axis_tready,
    output  m_axis_tvalid,
    output reg [dbits-1:0] dout
    );

wire wr_en; //can we write to buffer 
wire db_rd; //can model read from the buffer 

reg out_s; //s_axis_tready
reg out_m; //m_axis_tvalid

reg [dbits-1:0] regarray[2**abits-1:0] ;//number of words in fifo = 2^(number of address bits)
reg [dbits-1:0] test_array[2**abits-1:0];
reg [dbits-1:0] input_s;

reg [dbits-1:0] test_reg_write;
reg [dbits-1:0] test_reg_read;
reg test_run;
reg [dbits-1:0] write_sum; 

reg dffw1, dffw2, dffr1, dffr2,input_write_once ; 
integer i;



//----------------assigning the write and read signal --------

always @ (posedge clock) dffw1 <= s_axis_tvalid & input_write_once ; 
always @ (posedge clock) dffw2 <= s_axis_tready; 

assign wr_en =  dffw1 & dffw2;

always @ (posedge clock) dffr1 <= m_axis_tvalid; 
always @ (posedge clock) dffr2 <= m_axis_tready; 

assign db_rd =  dffr1 & dffr2;
 

// set up memory 
 
reg [abits-1:0] wr_reg;//wr_next, wr_succ; //points to the register that needs to be written to
reg [abits-1:0] rd_reg,rd_next, rd_succ; //points to the register that needs to be read from

//always block for write operation
always @ (posedge clock)
 begin
  if(wr_en) 
    
    // #90 //this delay needs to be calculated.
    
    if (regarray[wr_reg]=== 64'b0000000000000000000000000000000000000000000000000000000000000000)
      
      regarray[wr_reg] <= input_s;
      
    else 
      regarray[wr_reg][31:0] <= regarray[wr_reg][31:0]+ input_s[31:0];
  else 
   input_write_once <= 0;
   
     
end
 
//always block for read operation
always @ (posedge clock)
 begin
  if(db_rd)
    dout <= regarray[rd_reg];
    test_reg_read <=regarray[rd_reg];
    regarray[rd_reg] <=0;

end


 
//rest condition  
always @ (posedge clock or posedge reset)
 begin
  if (reset)
   begin
   wr_reg <= 0;
   rd_reg <= 0;
   input_write_once <= 1; 

   for (i=0; i<8; i=i+1) regarray[i] <= 64'b0000000000000000000000000000000000000000000000000000000000000000;


   end
  
  else
   begin
    write_sum <= regarray[wr_reg]; 
   
    
    //created the next registers to avoid the error of mixing blocking and non blocking assignment to the same signal
    rd_reg <= rd_next;

    //condition for s_axis_tready, here we just hard code it to 1
    out_s <= 1;

    //condition for  m_axis_tvalid, here we just hard code it to 1 
    //if.....then....
    out_m <=1;

    if (s_axis_tvalid == 0)
      input_s <=0;

    else
      input_s <= din; 
    

   end
 end

//this block is used to make wr_rn is spike than a continous 1.
 always @(din) 
 begin

   input_write_once =1 ; 

   
 end


always @ (*) //comb block 
 begin


  if(rd_reg == 128)

    rd_reg = 0;
  
  else
   
    rd_succ = rd_reg + 1;
    rd_next = rd_reg;
  

  case({wr_en,db_rd})
    //2'b00: do nothing ..
    
    2'b01: //read only
     begin
     rd_next = rd_succ;


     end
    
    2'b10: //write only 
     begin

     wr_reg = din[40:32]; 
     input_write_once = 0; 
    
    
     end
     
    2'b11: //read and write
     begin

      wr_reg = din[40:32]; 
      rd_next = rd_succ;
      // write address is bigger than read address, then stop write. read has the priority
      if (rd_succ  <= wr_reg)
        input_s =  0;
  
      
      

     end
    
  endcase


end 
 

//condition for output singal 
assign s_axis_tready = out_s;
assign m_axis_tvalid = out_m;


endmodule