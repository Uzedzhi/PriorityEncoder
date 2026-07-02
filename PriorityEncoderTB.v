`include "PriorityEncoder.v"

`define WIDTH 32
`define NUM_OF_TESTS 9

module TB();
    wire [$clog2(`WIDTH) - 1:0]   position;
    reg  [`WIDTH - 1: 0]         vector;
    reg  [`WIDTH - 1: 0]         test_vectors [0:`NUM_OF_TESTS - 1];

    encoder #(
        .WIDTH(`WIDTH)
    ) TB_encoder (
        .vector(vector),
        .position(position)
    );

    initial begin
        $display("in TB: position, vector, mask, is_onehot, parity");
        $monitor("%d, %b, %b, %d, %d", position, vector,
                TB_encoder.IsolatedTopBit, TB_encoder.is_onehot,
                TB_encoder.parity);
        
        $readmemh("TB.txt", test_vectors);

        for (integer i = 0; i < `NUM_OF_TESTS; i = i+1) begin
            vector = test_vectors[i];
            #10;
        end
        

        $finish;
    end
endmodule