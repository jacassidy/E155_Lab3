// James Kaden Cassidy kacassidy@hmc.edu 8/31/2025

// Seven segment display takes an input value to be displayed in hex (4 bits) and outputs the necessary segments to be lit (logic 0) and turned off (logic 1)

module seven_segment_display(
        input   logic[3:0]  value,
        output  logic[6:0]  segments
    );

    always_comb begin : display_decoder
        case(value)
            4'h0    : segments = 7'b0000001; // 0
            4'h1    : segments = 7'b1001111; // 1
            4'h2    : segments = 7'b0010010; // 2
            4'h3    : segments = 7'b0000110; // 3
            4'h4    : segments = 7'b1001100; // 4
            4'h5    : segments = 7'b0100100; // 5
            4'h6    : segments = 7'b0100000; // 6
            4'h7    : segments = 7'b0001111; // 7
            4'h8    : segments = 7'b0000000; // 8
            4'h9    : segments = 7'b0001100; // 9
            4'ha    : segments = 7'b0001000; // a
            4'hb    : segments = 7'b1100000; // b
            4'hc    : segments = 7'b0110001; // c
            4'hd    : segments = 7'b1000010; // d
            4'he    : segments = 7'b0110000; // e
            4'hf    : segments = 7'b0111000; // f
            default : segments = 7'b1111110; // -
        endcase
    end

endmodule