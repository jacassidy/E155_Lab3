// James Kaden Cassidy kacassidy@hmc.edu 9/14/2025

// module to display two values on a seven segment display based on a value clock feeding mechanism

module dual_seven_segment_display(
    input   logic       clk,
    input   logic       reset,
    input   logic       update_value,
    input   logic[3:0]  value,
    output  logic[6:0]  display
);

    logic[3:0]      display1_value, display2_value, display_output_value;

    //// --------- value saving logic --------- ////
 
    always_ff @ (posedge update_value) begin
        if (reset) begin
            display1_value <= 4'b0;
            display2_value <= 4'b0;
        end else begin
            display1_value <= value;
            display2_value <= display1_value;
        end
    end


    //// --------- segment display logic --------- ////
    assign display_output_select = clk;
 
    // driving logic for selectively displaying one number at a time
    assign display_output_value = display_output_select ? display1_value : display2_value;
    assign display1_select      = display_output_select;
    assign display2_select      = ~display_output_select;

    // single display controller for both displays
    seven_segment_display Display_Controller(.value(display_output_value), .segments(display));

endmodule