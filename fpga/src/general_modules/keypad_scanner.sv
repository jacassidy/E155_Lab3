// James Kaden Cassidy  kacassidy@hmc.edu   9/14/2025

module keypad_scanner #(parameter column_div_count = 100000, row_div_count = 1000) (
    input   logic       clk,
    input   logic       reset,
    input   logic[3:0]  keypad_row,
    output  logic[3:0]  keypad_column,
    output  logic
);

    logic[3:0] sync_pressed1, sync_pressed2, pressed_value;

    //// --------- scan for pressed switch --------- ////

    clock_divider #(.div_count(column_div_count)) Clock_Divider1(.clk(clk), .reset, .clk_divided(column_clk));
    clock_divider #(.div_count(row_div_count))   Clock_Divider2(.clk(column_clk), .reset, .clk_divided(row_clk));

    always_ff @ (posedge row_clk) begin
        if (reset)                      target_row = 4'b0;
        else if(scanning)     target_row = target_row + 1;
    end

    always_ff @ (posedge column_clk) begin
        if (reset)                       target_column = 4'b0;
        else if(scanning)   target_column = target_column + 1;
    end

    // scan by row
    always_comb begin
        case(target_row)
            2'b00: keypad_column = 4'b1110;
            2'b01: keypad_column = 4'b1101;
            2'b10: keypad_column = 4'b1011;
            2'b11: keypad_column = 4'b0111;
            default: keypad_column = 4'b1111;
        endcase
    end

    // debounce individual switch
    switch_debouncer #(4000000) Switch_Debouncer(clk, ~keypad_row[target_column], debounced_value);

    //// --------- make sure pressed value is correct --------- ////

    assign scanning = ~debounced_value;

    //// --------- make sure pressed value is correct --------- ////
    always_ff @ (posedge clk) begin
        if (scanning) begin
            sync_pressed1 <= {target_row, target_column};
            sync_pressed2 <= sync_pressed1;
        end
    end

    assign pressed_value = sync_pressed2;


endmodule