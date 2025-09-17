// James Kaden Cassidy kacassidy@hmc.edu 8/31/2025

// testbench to confirm all buttons on the keypad work as expected in the keypad scanner module

module keypad_testbench();

    logic clk, reset;
	logic result;
	logic [31:0] vector_num, errors;
	logic [10:0] testvectors[10000:0];

    tri [3:0] row_bus;   // goes into DUT .keypad_row
    tri [3:0] col_bus;   // driven by DUT .keypad_column (TB never drives this)
    logic [15:0] button; // button[4*col + row] = 1 closes that switch

    // Idle pull-ups on rows (active-low keypad)
    pullup pu_r0(row_bus[0]);
    pullup pu_r1(row_bus[1]);
    pullup pu_r2(row_bus[2]);
    pullup pu_r3(row_bus[3]);

    logic new_value, expected_new_value;
    logic[3:0]  pressed_value, expected_pressed_value;
	
	// generate clock
	always begin
		clk=1; #5; clk=0; #5;
	end

    keypad_scanner #(.row_div_count(1), .column_div_count(4), .debounce_delay(1)) dut(
        .clk,
        .reset,
        .keypad_row    (row_bus),   // DUT samples rows
        .keypad_column (col_bus),   // DUT drives columns (active-low scan)
        .decoded_pressed_value(pressed_value),
        .new_value
    );

    // Column 0
    tranif1 (col_bus[0], row_bus[0], button[0]);   // (row 0, col 0)
    tranif1 (col_bus[0], row_bus[1], button[4]);   // (row 1, col 0)
    tranif1 (col_bus[0], row_bus[2], button[8]);   // (row 2, col 0)
    tranif1 (col_bus[0], row_bus[3], button[12]);  // (row 3, col 0)
    // Column 1
    tranif1 (col_bus[1], row_bus[0], button[1]);   // (row 0, col 1)
    tranif1 (col_bus[1], row_bus[1], button[5]);   // (row 1, col 1)
    tranif1 (col_bus[1], row_bus[2], button[9]);   // (row 2, col 1)
    tranif1 (col_bus[1], row_bus[3], button[13]);  // (row 3, col 1)
    // Column 2
    tranif1 (col_bus[2], row_bus[0], button[2]);   // (row 0, col 2)
    tranif1 (col_bus[2], row_bus[1], button[6]);   // (row 1, col 2)
    tranif1 (col_bus[2], row_bus[2], button[10]);  // (row 2, col 2)
    tranif1 (col_bus[2], row_bus[3], button[14]);  // (row 3, col 2)
    // Column 3
    tranif1 (col_bus[3], row_bus[0], button[3]);   // (row 0, col 3)
    tranif1 (col_bus[3], row_bus[1], button[7]);   // (row 1, col 3)
    tranif1 (col_bus[3], row_bus[2], button[11]);  // (row 2, col 3)
    tranif1 (col_bus[3], row_bus[3], button[15]);  // (row 3, col 3)
		
	// at start of test, load vectors and pulse reset
	initial begin
		testvectors[0]  = 11'b0000_0000001;
		
		//Reset Values
		vector_num = 0; errors = 0; reset = 1; 
		
		#512; //Wait to reset
		
		reset = 0; //Begin
	end

    int target_button;

    always @ (posedge clk) begin
        target_button = vector_num / 100;
        button = 16'h0000;
        button[target_button] = ((vector_num%100 >= 48) & (vector_num%100 < 62));
    end

	// always @ (posedge clk) begin
	// 	{s, expected_seg} = testvectors[vector_num];
	// end
		
	// check results on falling edge of clk
	always @(negedge clk)
		if (~reset) begin // skip during reset

            $display("testvectors[%d] = 5'b%b_%b; // button = %d", vector_num, new_value, pressed_value, target_button);

			//No more instructions
			// if (expected_seg === 7'bxxxxxxx) begin
			// 	$display("Total test cases %d", vector_num);
			// 	$display("Total errors %d", errors);
			// 	$stop;
			// end

			//Check if correct result was computed
			// if (expected_seg === seg) begin
			// 	result = 1'b1;
			// end else begin
			// 	$display("Error on vector %d, %b (%b expected)", vector_num, seg, expected_seg);
			// 	result = 1'b0;
			// 	errors = errors + 1;
			// end
			
			//next test
			vector_num = vector_num + 1;
		
		end	

endmodule