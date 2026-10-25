# Barrel_shifter

module barrel_shifter #(
    parameter n = 8,
    parameter s = 3
)(
    output [n-1:0] dataout,
    input  [n-1:0] datain,
    input  [s-1:0] shift, 
    input          cntrl,
    input  [1:0]   op
);

    wire [n-1:0] stage [0:s];
    assign stage[0] = datain;

    genvar i;
    generate
        for (i = 0; i < s; i = i + 1) begin: barrelshifter
            reg [n-1:0] nxt;
            wire signed [n-1:0] cur_s = stage[i];
            
            always @(*) begin
                // Default assignment prevents latch inference
                nxt = stage[i]; 
                
                if (shift[i]) begin
                    case (op)
                        // Logical Shift (00)
                        2'b00: nxt = (cntrl) ? (stage[i] >> (1 << i)) : (stage[i] << (1 << i));
                        
                        // Arithmetic Shift (01)
                        2'b01: nxt = (cntrl) ? (cur_s >>> (1 << i)) : (stage[i] << (1 << i));
                        
                        // Rotate (10)
                        2'b10: nxt = (cntrl) ? 
                                     // Right Rotate
                                     ({stage[i][(1<<i)-1:0], stage[i][n-1:(1<<i)]}) : 
                                     // Left Rotate (Fully parameterized indexed part-selects)
                                     ({stage[i][(n - 1 - (1<<i)) -: (n - (1<<i))], stage[i][n-1 -: (1<<i)]});
                        
                        default: nxt = stage[i];
                    endcase
                end
            end
            
            assign stage[i+1] = nxt;
        end
    endgenerate

    assign dataout = stage[s];

endmodule
