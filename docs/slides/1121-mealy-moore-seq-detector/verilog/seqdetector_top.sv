module seqdetector_top(
input clock, // 
input reset, //
input X,  // 1-bit input, 0010, 0001
output reg Z // 1-bit ouput
);

// combinational block for 
// (1) next_state (D-input), 
// (2) registers, 
// (3) output block

reg [2:0] state;
reg [2:0] next_state;

// Define states as constants 
// parameter (choose binary encoding for the states
// and if Quartus detects code as "state machine",
// the it will assign the states with an optimal encoding)
parameter [2:0]
S0 = 3'b000,
S1 = 3'b001,
S2 = 3'b010,
S3 = 3'b011,
S4 = 3'b100,
S5 = 3'b101,
S6 = 3'b110;


// (2) D-ff Register Block 
always_ff @(posedge clock or posedge reset) begin
	if (reset)
		state <= S0; // non-blocking assignment; only allowed in always
	else
		state <= next_state; // Q+ = D
end

// Next state block
// Combinational block
always_comb begin
	// case statement is like if else but the condition is on a single variable
	// // Y = X ? S0 : S1
	/// if (X) Y =  S0
	/// else Y = S1
	case (state) 
		S0: 
			next_state <= X ? S1 : S0;
		S1: 
			next_state <= X ? S0 : S2;
		S2: 
			next_state <= X ? S4 : S3;
		S3: 
			next_state <= X ? S5 : S3;
		S4:
			next_state <= X ? S0 : S6;
		S5:
			next_state <= X ? S0 : S6;
		S6:
			next_state <= X ? S0 : S2;
	endcase
end

// (3) Output block (Moore: output only depends on the state)
// Mealy: output depends on both state and the input
// this one is Moore.
always_comb begin
	case (state)
		S5: Z = 1'b1;
		S6: Z = 1'b1;
		default: Z= 1'b0;
	endcase
end
endmodule
