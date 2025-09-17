// James Kaden Cassidy kacassidy@hmc.edu 9/7/2025

// testbench to confirm correct clock divider function

`define DIV_COUNT 10

module div_testbench();

    logic clk, reset;
	logic result;
	logic [31:0] vector_num, errors;

	// dut signals
    logic clk_divided;
	
	// generate clock
	always begin
		clk=0; #5; clk=1; #5;
	end

	clock_divider #(.div_count(`DIV_COUNT)) dut(.clk, .reset, .clk_divided);
		
	initial begin
	
		//Reset Values
		vector_num = 1; errors = 0; reset = 1; 
		
		#7; //Wait to reset
		
		reset = 0; //Begin
	end
		
	// check results on falling edge of clk
	always @(negedge clk)
		if (~reset) begin // skip during reset

            if (vector_num % (2 * `DIV_COUNT) < `DIV_COUNT) begin
                result = clk_divided;
            end else begin
                result = ~clk_divided;
            end

            if (~result) begin
                errors = errors + 1;
                $display("Error on vector %d, %b (%b expected)", vector_num, clk_divided, ~clk_divided);
            end

			// end testing
			if (vector_num == 3 * (`DIV_COUNT) + 1) begin
				$display("Total test cases %d", vector_num);
				$display("Total errors %d", errors);
				$stop;
			end
			
			//next test
			vector_num = vector_num + 1;
		
		end	

endmodule