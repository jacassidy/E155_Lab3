// James Kaden Cassidy kacassidy@hmc.edu 9/15/2025

// testbench to confirm correct synchronizer function

module synchronizer_testbench();

    logic clk, reset;
	logic result;
	logic [31:0] vector_num, errors;
    logic [1:0] testvectors[10000:0];
    int current_vector;

    logic expected_synchronized, synchronized_value, raw_input;

	// dut signals
    logic clk_divided;
	
	// generate clock
	always begin
		clk=0; #5; clk=1; #5;
	end

	synchronizer Synchronizer(clk, raw_input, synchronized_value);
		
	// at start of test, load vectors and pulse reset
	initial begin

        testvectors[0] = 2'b00;
        testvectors[1] = 2'b00;
        testvectors[2] = 2'b00;
        testvectors[3] = 2'b00;
        testvectors[4] = 2'b00;
        testvectors[5] = 2'b10;
        testvectors[6] = 2'b10;
        testvectors[7] = 2'b11;
        testvectors[8] = 2'b01;
        testvectors[9] = 2'b01;
        testvectors[10] = 2'b00;
	
		//Reset Values
		vector_num = 1; errors = 0; reset = 1; 
		
		#7; //Wait to reset
		
		reset = 0; //Begin
	end

    always @ (posedge clk) begin
        raw_input           = testvectors[vector_num][1];
        expected_synchronized  = testvectors[vector_num][0];
    end
		
	// check results on falling edge of clk
	always @(negedge clk)
		if (~reset) begin // skip during reset

            result = ~(expected_synchronized ^ synchronized_value);

            if (~result) begin
                errors = errors + 1;
                $display("Error on vector %d, %b (%b expected)", vector_num, synchronized_value, ~expected_synchronized);
            end

			// end testing
			if (raw_input === 1'bx) begin
				$display("Total test cases %d", vector_num);
				$display("Total errors %d", errors);
				$stop;
			end
			
			//next test
			vector_num = vector_num + 1;
		
		end
endmodule