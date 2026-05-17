module test_ALU_Simple;
    // inputs declared as reg -- we drive them manually
    reg [3:0] A, B;
    reg [2:0] op;
    
    // outputs declared as wire -- driven by ALU
    wire [3:0] result;
    wire overflow;

    // instantiate the ALU
    ALU_Simple M1(A, B, op, result, overflow);

    initial $monitor("op=%b | A=%d B=%d | result=%d overflow=%b",
                      op,    A,   B,     result,   overflow);

    initial begin

        A = 4'b0011;   // A = 3
        B = 4'b0101;   // B = 5

        op = 3'b000;   // AND
        #50;

        op = 3'b001;   // OR
        #50;

        op = 3'b010;   // XOR
        #50;

        op = 3'b011;   // NOT
        #50;

        op = 3'b100;   // ADD -- normal, no overflow
        #50;

        // OVERFLOW CASE: ADD
        // 1111 (15) + 0001 (1) = 10000 (16)
        // 16 does not fit in 4 bits!
        // result wraps to 0000 (0), overflow = 1
        A = 4'b1111;   // A = 15
        B = 4'b0001;   // B = 1
        op = 3'b100;   // ADD
        #50;

        op = 3'b101;   // SUB -- normal, no overflow
        #50;

        // OVERFLOW CASE: SUB
        // 0001 (1) - 1111 (15) = -14
        // negative number! 4-bit unsigned cannot represent this
        // result wraps around, overflow = 1
        A = 4'b0001;   // A = 1
        B = 4'b1111;   // B = 15
        op = 3'b101;   // SUB
        #50;

        A = 4'b1111;   // A = 15
        B = 4'b0001;   // B = 1
        op = 3'b110;   // GT -- true, 15 > 1
        #50;

        A = 4'b0001;   // A = 1
        B = 4'b1111;   // B = 15
        op = 3'b110;   // GT -- false, 1 < 15
        #50;

        A = 4'b0101;   // A = 5
        B = 4'b0101;   // B = 5
        op = 3'b110;   // GT -- false, 5 == 5
        #50;

        op = 3'b111;   // EQ -- true, 5 == 5
        #50;

        A = 4'b0011;   // A = 3
        B = 4'b0101;   // B = 5
        op = 3'b111;   // EQ -- false, 3 != 5
        #50;

    end

    initial #750 $finish; // 13 tests * 50 = 650 + 100 safety

endmodule