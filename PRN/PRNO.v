module PRNO(
  input clk,
  input [0:9] R0_in,
  input [0:9] R1_in,
  output reg [0:1799] P,
  output reg [0:23] first,
  output reg [0:23] last
);

  integer i;
  reg r_pl,r3_pl;
  reg sigma_2A, sigma_2B, sigma_2,temp;
  reg R1A, R1B, R1_fb;
  reg [0:9] R0, R1;

  always @(*) begin
    R0 = R0_in;
    R1 = R1_in;
    
   for (i = 0; i < 1800; i = i + 1) 
   begin
	r_pl =  (R0[5]^R0[2])^(R0[1]^R0[0]);
        sigma_2A = (R0[5]^R0[2])&(R0[1]^R0[0]);
        sigma_2B = (R0[5]&R0[2])^(R0[1]&R0[0]);
        sigma_2 = sigma_2A^sigma_2B ;
        temp = R0[6]^R0[3]^R0[2]^R0[0];
        R1A = sigma_2^temp;
        R1B = R1[5]^R1[2]^R1[1]^R1[0];
        r3_pl = R1A^R1B;
        P[i]= R1[0];
	R0=R0<<1;R0[9]=r_pl;
	R1=R1<<1;R1[9]=r3_pl;
    end

    first = P[0:23];
    last = P[1776:1799];
    //$display("First 24: %o, Last 24: %o", first, last);
  end
endmodule
