module PRN (
  input clk,
  input [0:54] R0_in,
  input [0:54] R1_in,
  input [0:4] C_in,
  output reg [0:10229] P,
  output reg [0:23] first,
  output reg [0:23] last
);
  reg [0:54] R0, R1;
  reg [0:4] C;
  integer i;
  reg R0_fb, sigma_2A, sigma_2B, sigma_2C, sigma_2, R1A, R1B, R1_fb, C_fb;

  always @(posedge clk) begin
    R0 = R0_in;
    R1 = R1_in;
    C = C_in;

    // Clear PRN array at the start of each clock cycle
    P = 0;

    // Generate PRN sequence
    for (i = 0; i < 10230; i = i + 1) begin
      // Compute feedback values directly with R0 and R1
      R0_fb = R0[50] ^ R0[45] ^ R0[40] ^ R0[20] ^ R0[10] ^ R0[5] ^ R0[0];
      sigma_2A = (R0[50] ^ R0[45] ^ R0[40]) & (R0[20] ^ R0[10] ^ R0[5] ^ R0[0]);
      sigma_2B = ((R0[50] ^ R0[45]) & R0[40]) ^ ((R0[20] ^ R0[10]) & (R0[5] ^ R0[0]));
      sigma_2C = (R0[50] & R0[45]) ^ (R0[20] & R0[10]) ^ (R0[5] & R0[0]);
      sigma_2 = sigma_2A ^ sigma_2B ^ sigma_2C;
      R1A = sigma_2 ^ (R0[40] ^ R0[35] ^ R0[30] ^ R0[25] ^ R0[15] ^ R0[0]);
      R1B = R1[50] ^ R1[45] ^ R1[40] ^ R1[20] ^ R1[10] ^ R1[5] ^ R1[0];
      R1_fb = R1A ^ R1B;

      // Assign output
      P[i] = R1[0] ^ C[0];

      // Shift registers and insert feedback
      R0 = R0 << 1;R0[54] = R0_fb;
      R1 = R1 << 1;R1[54] = R1_fb;
      C_fb = C[0];
      C = C << 1;C[4] = C_fb;
    end

    // Capture first and last 24 bits
    first = P[0:23];
    last = P[10206:10229];
  end
endmodule

