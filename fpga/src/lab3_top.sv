// James Kaden Cassidy kacassidy@hmc.edu    9/12/2025

module lab3_top(
    input   logic       rst_inv,
    input   logic[3:0]  keypad_row,
    output  logic[3:0]  keypad_column,
    output  logic[1:0]  debug_led,
    output  logic       display1_select,
    output  logic       display2_select,
    output  logic[6:0]  display,
    input   logic       new_value_debug,
	output  logic       pressed
);
    logic           clk, reset;
    logic           display_clk;

    logic           new_value;
    logic[3:0]      pressed_value;

    assign          reset = ~rst_inv;

    HSOSC #(.CLKHF_DIV(2'b01)) hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

    //// --------- scan for pressed switch and debounce --------- ////

    keypad_scanner #(.row_div_count(1000), .column_div_count(8), .debounce_delay(100000)) 
        Keypad_Scanner(.clk, .reset, .keypad_row, .keypad_column, .decoded_pressed_value(pressed_value), .new_value);

    //// --------- value saving and displaying logic --------- ////

    clock_divider #(.div_count(100000)) Clock_Divider(.clk(clk), .reset, .clk_divided(display_clk));

    dual_seven_segment_display Dual_Seven_Seg_Display(.clk(display_clk), .reset, .update_value(new_value), .value(pressed_value), .display, .display1_select, .display2_select);

    // Testing and debugging

    logic[1:0] count;

    always_ff @ (posedge new_value) begin
        if (reset)  count = 0;
        else        count = count + 1;
    end

    assign debug_led = count;
	
	assign pressed = new_value;

endmodule
