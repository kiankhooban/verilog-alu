module ALU_Simple (A, B, op, overflow, result);
    input [3:0] A, B;
    input [2:0] op;
    output reg [3:0] result;
    output reg overflow;

    always @(op, A, B)
    begin
        overflow = 1'b0;
        case (op)
            3'b000: result = A & B;
            3'b001: result = A | B;
            3'b010: result = A ^ B;
            3'b011: result = ~A;
            3'b100: {overflow, result} = A + B;
            3'b101: {overflow, result} = A - B;
            3'b110: result = (A > B);
            3'b111: result = (A == B);

        endcase
    end

endmodule