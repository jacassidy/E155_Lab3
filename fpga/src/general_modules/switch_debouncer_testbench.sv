// James Kaden Cassidy kacassidy@hmc.edu 9/15/2025

// testbench to confirm correct clock switch debounce function

`define DEBOUNCE_DELAY 10

module debouncer_testbench();

    logic clk, reset;
	logic result;
	logic [31:0] vector_num, errors;
    logic [1:0] testvectors[10000:0];
    int current_vector;

    logic expected_debounced, debounced_value, raw_input;

	// dut signals
    logic clk_divided;
	
	// generate clock
	always begin
		clk=0; #5; clk=1; #5;
	end

	switch_debouncer #(.debounce_delay(`DEBOUNCE_DELAY)) Switch_Debouncer(clk, raw_input, debounced_value);
		
	// at start of test, load vectors and pulse reset
	initial begin

        testvectors[0] = 2'b00;
        testvectors[1] = 2'b00;
        testvectors[2] = 2'b00;
        testvectors[3] = 2'b00;
        testvectors[4] = 2'b00;
        testvectors[5] = 2'b10;

        current_vector = 6;

        for (int i = 0; i < `DEBOUNCE_DELAY; i++) begin
            for (int j = 0; j < i; j++) begin
                testvectors[current_vector] = {1'b0, 1'(j < `DEBOUNCE_DELAY)};
                current_vector = current_vector + 1;
            end
            testvectors[current_vector] = {1'b1, 1'(i < `DEBOUNCE_DELAY)};
            current_vector = current_vector + 1;
        end
	
		//Reset Values
		vector_num = 1; errors = 0; reset = 1; 
		
		#7; //Wait to reset
		
		reset = 0; //Begin
	end

    always @ (posedge clk) begin
        raw_input           = testvectors[vector_num][1];
        expected_debounced  = testvectors[vector_num][0];
    end
		
	// check results on falling edge of clk
	always @(negedge clk)
		if (~reset) begin // skip during reset

            result = ~(expected_debounced ^ debounced_value);

            if (~result) begin
                errors = errors + 1;
                $display("Error on vector %d, %b (%b expected)", vector_num, debounced_value, ~expected_debounced);
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