// James Kaden Cassidy kacassidy@hmc.edu 9/15/2025

// testbench to confirm all permutations of dual seven segment display are correct

module dual_seven_seg_testbench();

    logic clk, reset;
	logic result;
	logic [31:0] vector_num, errors;
	logic [10:0] testvectors[10000:0];

	logic	display1_select, display2_select;

	// dut signals
    logic[3:0]  s;
    logic[2:0]  led;
    logic[6:0]  seg, expected_seg, prev_expected_seg, dumby_seg;
	
	// generate clock
	always begin
		clk=1; #5; clk=0; #5;
	end

	dual_seven_segment_display dut(.clk, .reset, .update_value(clk), .value(s), .display(seg), .display1_select, .display2_select);
		
	// at start of test, load vectors and pulse reset
	initial begin
		testvectors[0]  = 11'b0000_0000001;
		testvectors[1]  = 11'b0001_1001111;
		testvectors[2]  = 11'b0010_0010010;
		testvectors[3]  = 11'b0011_0000110;
		testvectors[4]  = 11'b0100_1001100;
		testvectors[5]  = 11'b0101_0100100;
		testvectors[6]  = 11'b0110_0100000;
		testvectors[7]  = 11'b0111_0001111;
		testvectors[8]  = 11'b1000_0000000;
		testvectors[9]  = 11'b1001_0001100;
		testvectors[10] = 11'b1010_0001000;
		testvectors[11] = 11'b1011_1100000;
		testvectors[12] = 11'b1100_0110001;
		testvectors[13] = 11'b1101_1000010;
		testvectors[14] = 11'b1110_0110000;
		testvectors[15] = 11'b1111_0111000;
		testvectors[15] = 11'b1111_0111000;
		
		//Reset Values
		vector_num = 0; errors = 0; reset = 1; 
		
		#12; //Wait to reset
		
		reset = 0; //Begin
	end

	always @ (posedge clk) begin
		prev_expected_seg 	<= expected_seg;
		expected_seg 		<= dumby_seg;
		{s, dumby_seg} 		<= testvectors[vector_num];
	end
		
	// check results on falling edge of clk
	always @(negedge clk)
		if (~reset) begin // skip during reset

			//No more instructions
			if (expected_seg === 7'bxxxxxxx) begin
				$display("Total test cases %d", vector_num);
				$display("Total errors %d", errors);
				$stop;
			end

			//Check if correct result was computed
			if (expected_seg === seg) begin
				result = 1'b1;
			end else begin
				$display("Error on vector %d, %b (%b expected)", vector_num, seg, expected_seg);
				result = 1'b0;
				errors = errors + 1;
			end
			
			//next test
			vector_num = vector_num + 1;
		
		end	

	always @(posedge clk)
		if (~reset) begin // skip during reset

			//No more instructions
			if (expected_seg === 7'bxxxxxxx) begin
				$display("Total test cases %d", vector_num);
				$display("Total errors %d", errors);
				$stop;
			end

			//Check if correct result was computed
			if (prev_expected_seg === seg) begin
				result = 1'b1;
			end else begin
				$display("Error on vector %d, %b (%b prev_expected)", vector_num, seg, prev_expected_seg);
				result = 1'b0;
				errors = errors + 1;
			end
			
			//next test
			vector_num = vector_num + 1;
		
		end	

endmodule