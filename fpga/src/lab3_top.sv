// James Kaden Cassidy kacassidy@hmc.edu    9/12/2025

module lab3_top(
    input   logic[3:0]  keypad_row,
    output  logic[3:0]  keypad_column,
    output  logic[2:0]  debug_led,
    input   logic[3:0]  display_value,
    output  logic       display1_select,
    output  logic       display2_select,
    output  logic[6:0]  display
);

    assign reset = 1'b0;

    logic   clk;
    logic   reset;
    logic   debounced_value;
    logic   display_output_select;

    logic   div_clk;
    logic   scanning;

    logic[1:0]      target_row, target_column;
    
    logic[3:0]      display1_value, display2_value, display_output_value;
    logic[3:0]      pressed_value;

    HSOSC #(.CLKHF_DIV(2'b01)) hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

    //// --------- scan for pressed switch --------- ////

    clock_divider #(.div_count(1000000)) Clock_Divider1(.clk(clk), .reset, .clk_divided(column_clk));
    clock_divider #(.div_count(10000))   Clock_Divider2(.clk(column_clk), .reset, .clk_divided(row_clk));

    always_ff @ (posedge clk) begin
        if (reset)                      target_row = 4'b0;
        else if(scanning & row_clk)     target_row = target_row + 1;
    end

    always_ff @ (posedge clk) begin
        if (reset)                       target_column = 4'b0;
        else if(scanning & column_clk)   target_column = target_column + 1;
    end

    // debounce individual switch
    switch_debouncer #(1000000) Switch_Debouncer(clk, ~keypad_row[target_column], debounced_value);

    assign scanning = ~debounced_value;

    assign pressed_value = {target_row, target_column};

    //// --------- value saving logic --------- ////
 
    always_ff @ (posedge debounced_value) begin
        if (reset) begin
            display1_value <= 4'b0;
            display2_value <= 4'b0;
        end else begin
            display1_value <= pressed_value;
            display2_value <= display1_value;
        end
    end


    //// --------- segment display logic --------- ////
    assign display_output_select = div_clk;
 
    // driving logic for selectively displaying one number at a time
    assign display_output_value = display_output_select ? display1_value : display2_value;
    assign display1_select      = display_output_select;
    assign display2_select      = ~display_output_select;

    // single display controller for both displays
    seven_segment_display Display_Controller(.value(display_output_value), .segments(display));

    

    // Testing

    logic[2:0] count;

    assign keypad_column = 1'b0;

    always_ff @ (posedge debounced_value) begin
        count = count + 1;
    end

    assign debug_led = count;

endmodule