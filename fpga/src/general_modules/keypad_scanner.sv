// James Kaden Cassidy  kacassidy@hmc.edu   9/14/2025

// module that handles scanning the keypad and holding the selected value until released

module keypad_scanner #(parameter row_div_count, column_div_count, debounce_delay) (
    input   logic       clk,
    input   logic       reset,
    input   logic[3:0]  keypad_row,
    output  logic[3:0]  keypad_column,
    output  logic[3:0]  pressed_value,
    output  logic       new_value
);
    logic       row_clk, column_clk;
    logic       synchronized_value;
    logic       scanning;
    logic[1:0]  target_row, target_column;
    logic[3:0]  sync_pressed1, sync_pressed2;

    //// --------- scan for pressed switch --------- ////

    clock_divider #(.div_count(row_div_count))    Clock_Divider1(.clk(clk),     .reset, .clk_divided(row_clk));
    clock_divider #(.div_count(column_div_count)) Clock_Divider2(.clk(row_clk), .reset, .clk_divided(column_clk));

    always_ff @ (posedge row_clk) begin
        if (reset)                      target_row = 4'b0;
        else if(scanning)     target_row = target_row + 1;
    end

    always_ff @ (posedge column_clk) begin
        if (reset)                       target_column = 4'b0;
        else if(scanning)   target_column = target_column + 1;
    end

    // scan by column
    always_comb begin
        case(target_column)
            2'b00: keypad_column = 4'b1110;
            2'b01: keypad_column = 4'b1101;
            2'b10: keypad_column = 4'b1011;
            2'b11: keypad_column = 4'b0111;
            default: keypad_column = 4'b1111;
        endcase
    end

    // synchronize value
    synchronizer Synchronizer (clk, ~keypad_row[target_row], synchronized_value);

    // debounce individual switch
    switch_debouncer #(debounce_delay) Switch_Debouncer(clk, synchronized_value, debounced_value);

    //// --------- stop scanning and assign new value --------- ////

    assign scanning     = ~debounced_value;
    assign new_value    = debounced_value;

    //// --------- make sure pressed value is synced --------- ////

    synchronizer #(.bits(4)) Synchronize_value(.clk, .raw_input({target_column, target_row}), .synchronized_value(pressed_value));


endmodule