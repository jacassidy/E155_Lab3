// James Kaden Cassidy kacassidy@hmc.edu 9/7/2025

// testbench to confirm correct clock counter function

`define COUNT 10

module clk_counter_testbench();

    logic clk, reset;
	logic result;
	logic [31:0] vector_num, errors;

	// dut signals
    logic count_achieved;
	
	// generate clock
	always begin
		clk=0; #5; clk=1; #5;
	end

	clk_counter #(.count_target(`COUNT)) dut(.clk, .reset, .count_achieved);
		
	initial begin
	
		//Reset Values
		vector_num = 1; errors = 0; reset = 1; 
		
		#7; //Wait to reset
		
		reset = 0; //Begin
	end
		
	// check results on falling edge of clk
	always @(negedge clk)
		if (~reset) begin // skip during reset

            if (vector_num <= `COUNT) begin
                result = ~count_achieved;
            end else begin
                result = count_achieved;
            end

            if (~result) begin
                errors = errors + 1;
                $display("Error on vector %d, %b (%b expected)", vector_num, count_achieved, ~count_achieved);
            end

			// end testing
			if (vector_num == `COUNT+2) begin
				$display("Total test cases %d", vector_num);
				$display("Total errors %d", errors);
				$stop;
			end
			
			//next test
			vector_num = vector_num + 1;
		
		end	

endmodule