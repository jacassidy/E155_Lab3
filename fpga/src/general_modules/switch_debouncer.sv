// James Kaden Cassidy 9/12/2025

// This module is designed to take in switch input directly from a real world pin and then synchronize and stablize the value to an ideal button/switch

module switch_debouncer #(parameter debounce_delay) (
    input   logic   clk,
    input   logic   raw_input,
    output  logic   synchronized_debounced_value
);

    logic first_synchronize, synchronized_value;

    logic debounced_input_low;

    // Synchronize Value
    always_ff @ (posedge clk) begin
        first_synchronize  <= raw_input;
        synchronized_value <= first_synchronize;
    end

    // Debounce Value

    always_ff @ (posedge clk) begin
        if      (synchronized_value)  synchronized_debounced_value <= 1'b1;
        else if (debounced_input_low) synchronized_debounced_value <= 1'b0;
    end

    clk_counter #(debounce_delay) Clk_Counter(.clk, .reset(synchronized_value), .count_achieved(debounced_input_low));

endmodule