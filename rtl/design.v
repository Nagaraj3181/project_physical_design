//-----------------------------------------------------------------------------------------------------
// FIFO memory
//-----------------------------------------------------------------------------------------------------

module fifomem
#(
  parameter DATASIZE = 8, // Memory data word width
  parameter ADDRSIZE = 6  // Number of mem address bits
)
(
  input   winc, wfull, wclk,
  input   [ADDRSIZE-1:0] waddr, raddr,
  input   [DATASIZE-1:0] wdata,
  output  [DATASIZE-1:0] rdata
);

 
  localparam DEPTH = 1<<ADDRSIZE;

  logic [DATASIZE-1:0] memo [0:DEPTH-1];

  assign rdata = memo[raddr];

  always_ff @(posedge wclk)
    if (winc && !wfull)
      memo[waddr] <= wdata;

endmodule

//-----------------------------------------------------------------------------------------------------
// read pointer
//-----------------------------------------------------------------------------------------------------

module rptr_empty
#(
  parameter ADDRSIZE = 6
)
(
  input   rinc, rclk, rrst_n,
  input   [ADDRSIZE :0] rq2_wptr,
  output reg  rempty,
  output  [ADDRSIZE-1:0] raddr,
  output reg [ADDRSIZE :0] rptr
);

  reg [ADDRSIZE:0] rbin;
  wire [ADDRSIZE:0] rgraynext, rbinnext;


  // GRAYSTYLE2 pointer

  always_ff  @(posedge rclk or negedge rrst_n)
    if (!rrst_n)
      {rbin, rptr} <= 1'b0;
    else
      {rbin, rptr} <= {rbinnext, rgraynext};

  
  assign raddr = rbin[ADDRSIZE-1:0];
  assign rbinnext = rbin + (rinc & ~rempty);
  assign rgraynext = (rbinnext>>1) ^ rbinnext;

  // FIFO empty when the next rptr == synchronized wptr or on reset

  assign rempty_val = (rgraynext == rq2_wptr);

  always_ff   @(posedge rclk or negedge rrst_n)
    if (!rrst_n)
      rempty <= 1'b1;
    else
      rempty <= rempty_val;

endmodule

//-----------------------------------------------------------------------------------------------------
// WPTR FULL
//-----------------------------------------------------------------------------------------------------

module wptr_full
#(
  parameter ADDRSIZE = 6
)
(
  input   winc, wclk, wrst_n,
  input   [ADDRSIZE :0] wq2_rptr,
  output reg  wfull,
  output  [ADDRSIZE-1:0] waddr,
  output reg [ADDRSIZE :0] wptr
);

   reg [ADDRSIZE:0] wbin;
  wire [ADDRSIZE:0] wgraynext, wbinnext;

  // GRAYSTYLE2 pointer
  always_ff  @(posedge wclk or negedge wrst_n)
    if (!wrst_n)
      {wbin, wptr} <= 1'b0;
    else
      {wbin, wptr} <= {wbinnext, wgraynext};

  // Memory write-address pointer 

  assign waddr = wbin[ADDRSIZE-1:0];
  assign wbinnext = wbin + (winc & ~wfull);
  assign wgraynext = (wbinnext>>1) ^ wbinnext;

  assign wfull_val = (wgraynext=={~wq2_rptr[ADDRSIZE:ADDRSIZE-1], wq2_rptr[ADDRSIZE-2:0]});

  always_ff  @(posedge wclk or negedge wrst_n)
    if (!wrst_n)
      wfull <= 1'b0;
    else
      wfull <= wfull_val;

endmodule

//-----------------------------------------------------------------------------------------------------
// write pointer to read clock synchronizer
//-----------------------------------------------------------------------------------------------------

module sync_w2r
#(
  parameter ADDRSIZE = 6
)
(
  input   rclk, rrst_n,
  input   [ADDRSIZE:0] wptr,
  output reg [ADDRSIZE:0] rq2_wptr
);

  reg [ADDRSIZE:0] rq1_wptr;

  always_ff  @(posedge rclk or negedge rrst_n)
    if (!rrst_n)
      {rq2_wptr,rq1_wptr} <= 0;
    else
      {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};

endmodule
 
//-----------------------------------------------------------------------------------------------------
// Read pointer to write clock synchronizer
//-----------------------------------------------------------------------------------------------------

module sync_r2w
#(
  parameter ADDRSIZE = 6
)
(
  input   wclk, wrst_n,
  input   [ADDRSIZE:0] rptr,
  output reg  [ADDRSIZE:0] wq2_rptr//readpointer with write side
);

  reg [ADDRSIZE:0] wq1_rptr;

  always_ff  @(posedge wclk or negedge wrst_n)
    if (!wrst_n) {wq2_rptr,wq1_rptr} <= 0;
    else {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};

endmodule

//----------------------------------------------------------------------------------------------------
// TOP MODULE
//-----------------------------------------------------------------------------------------------------
module async_fifo1
#(
  parameter DATASIZE = 8,
  parameter ADDRSIZE = 6
 )
(
  input   winc, wclk, wrst_n,//winc write enable signal
  input   rinc, rclk, rrst_n,//rinc read enable signal
  input   [DATASIZE-1:0] wdata,

  output  [DATASIZE-1:0] rdata,
  output  wfull,
  output  rempty
);

  wire [ADDRSIZE-1:0] waddr, raddr;
  wire [ADDRSIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

  sync_r2w R2W(.*);
  sync_w2r W2R(.*);
  fifomem #(DATASIZE, ADDRSIZE) MEM(.*);
  rptr_empty #(ADDRSIZE) RPTR(.*);
  wptr_full #(ADDRSIZE) WPTR(.*);
  
endmodule
//-----------------------------------------------------------------------------------------------------
