// James Kaden Cassidy kacassidy@hmc.edu 9/12/2025

// testbench to debug led works correctly

timeunit 1ns;
timeprecision 1ps;

module lab3_top_testbench();

    logic clk, reset;
	logic result;
    logic clk_divided;
	logic [31:0] vector_num, errors;
	logic [2:0] testvectors[10000:0];

	// dut signals
    logic[2:0]  led, led_expected;

    logic[3:0]  keypad_row, keypad_column;
    logic       display1_select, display2_select;
    logic[6:0]  display;
	
	// generate clock
	always begin
		clk=1; #5; clk=0; #5;
	end
    
    clock_divider #(1) Clk_Divider(.clk, .reset, .clk_divided);

	lab3_top dut(.reset, .keypad_row, .keypad_column, .debug_led(led), .display1_select, .display2_select, .display, .new_value_debug(clk_divided));
		
	// at start of test, load vectors and pulse reset
	initial begin
		testvectors[0]  = 3'b000;
        testvectors[1]  = 3'b001;
        testvectors[2]  = 3'b010;
        testvectors[3]  = 3'b011;
        testvectors[4]  = 3'b100;
        testvectors[5]  = 3'b101;
        testvectors[6]  = 3'b110;
        testvectors[7]  = 3'b111;

        testvectors[8]  = 3'b000;
        testvectors[9]  = 3'b001;
        testvectors[10] = 3'b010;
        testvectors[11] = 3'b011;
        testvectors[12] = 3'b100;
        testvectors[13] = 3'b101;
        testvectors[14] = 3'b110;
        testvectors[15] = 3'b111;
		
		//Reset Values
		vector_num = 0; errors = 0; reset = 1; 
		
		#12; //Wait to reset
		
		reset = 0; //Begin
	end

	always @ (posedge clk) begin
		led_expected = testvectors[vector_num];
	end

	// check results on falling edge of clk
	always @(negedge clk)
		if (~reset) begin // skip during reset

			//No more instructions
			if (led_expected === 3'bxxx) begin
				$display("Total test cases %d", vector_num);
				$display("Total errors %d", errors);
				$stop;
			end

			//Check if correct result was computed
			if (led_expected === led) begin
				result = 1'b1;
			end else begin
				$display("Error on vector %d, %b (%b expected)", vector_num, led, led_expected);
				result = 1'b0;
				errors = errors + 1;
			end
			
			//next test
			vector_num = vector_num + 1;
		
		end	

endmodule