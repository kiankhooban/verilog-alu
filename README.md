# 4-bit ALU in Verilog HDL

A 4-bit Arithmetic Logic Unit (ALU) implemented in Verilog HDL as part of my 
digital circuit design studies. The ALU supports 8 operations including 
arithmetic, logical, and comparison operations with overflow detection.

---

## What is an ALU?

An ALU (Arithmetic Logic Unit) is the fundamental component inside every 
processor that performs arithmetic and logical operations. This implementation 
models the core functionality of a real ALU at the hardware level using 
Verilog HDL.

---

## Supported Operations

| op (3-bit) | Operation | Description                          |
|------------|-----------|--------------------------------------|
| 000        | AND       | Bitwise AND of A and B               |
| 001        | OR        | Bitwise OR of A and B                |
| 010        | XOR       | Bitwise XOR of A and B               |
| 011        | NOT       | Bitwise NOT of A                     |
| 100        | ADD       | Addition of A and B with overflow    |
| 101        | SUB       | Subtraction of A from B with overflow|
| 110        | GT        | 1 if A > B, else 0                   |
| 111        | EQ        | 1 if A == B, else 0                  |

---

## Overflow Detection

The ALU includes overflow detection for addition and subtraction operations.
A 4-bit number can only represent values from 0 to 15. When the result 
exceeds this range, the overflow flag is set to 1.

**Addition overflow example:**
1111  (15)

0001  ( 1)


10000  (16) -- needs 5 bits!
result   = 0000  (wrapped around)
overflow = 1     (overflow detected!)

**Subtraction overflow example:**
0001  ( 1)

1111  (15)


-14   (negative -- cannot represent in 4-bit unsigned!)
result   = wrapped around value
overflow = 1     (overflow detected!)

---

## Project Structure
```
ALU_Project/
├── README.md
├── src/
│   └── ALU_Simple.v        -- ALU circuit
└── testbench/
    └── test_ALU_Simple.v   -- test bench
```

---

## How It Works

The ALU is built using behavioural modeling in Verilog. The `op` input 
selects which operation to perform. All operations are computed 
combinationally -- meaning the result updates immediately whenever 
inputs change, with no clock required.

```verilog
// operation selection using case statement
case (op)
    3'b000: result = A & B;              // AND
    3'b001: result = A | B;              // OR
    3'b010: result = A ^ B;              // XOR
    3'b011: result = ~A;                 // NOT
    3'b100: {overflow, result} = A + B;  // ADD with overflow
    3'b101: {overflow, result} = A - B;  // SUB with overflow
    3'b110: result = {3'b000, (A > B)};  // GT
    3'b111: result = {3'b000, (A == B)}; // EQ
endcase
```

---

## Simulation Results

Test results using A=3 (0011) and B=5 (0101):
op=000 | A=3  B=5  | result=1  overflow=0 | AND  -- 0011 & 0101 = 0001
op=001 | A=3  B=5  | result=7  overflow=0 | OR   -- 0011 | 0101 = 0111
op=010 | A=3  B=5  | result=6  overflow=0 | XOR  -- 0011 ^ 0101 = 0110
op=011 | A=3  B=5  | result=12 overflow=0 | NOT  -- ~0011 = 1100
op=100 | A=3  B=5  | result=8  overflow=0 | ADD  -- 3 + 5 = 8
op=100 | A=15 B=1  | result=0  overflow=1 | ADD  -- OVERFLOW! 15+1=16
op=101 | A=15 B=1  | result=14 overflow=0 | SUB  -- 15 - 1 = 14
op=101 | A=1  B=15 | result=?  overflow=1 | SUB  -- OVERFLOW! 1-15=-14
op=110 | A=15 B=1  | result=1  overflow=0 | GT   -- 15 > 1  = true
op=110 | A=1  B=15 | result=0  overflow=0 | GT   -- 1  > 15 = false
op=110 | A=5  B=5  | result=0  overflow=0 | GT   -- 5  > 5  = false
op=111 | A=5  B=5  | result=1  overflow=0 | EQ   -- 5  == 5 = true
op=111 | A=3  B=5  | result=0  overflow=0 | EQ   -- 3  == 5 = false

---

## How To Run

**Using Icarus Verilog:**
```bash
# compile
iverilog -o alu_sim src/ALU_Simple.v testbench/test_ALU_Simple.v

# simulate
vvp alu_sim
```

**Using EDAPlayground:**
1. Go to https://www.edaplayground.com
2. Create a new project
3. Paste ALU_Simple.v and test_ALU_Simple.v
4. Select Icarus Verilog as simulator
5. Run simulation

---

## Concepts Demonstrated
```

✅ Behavioural modeling using always blocks
✅ Case statements for operation selection
✅ Overflow detection using concatenation operator {}
✅ Bitwise operations (AND, OR, XOR, NOT)
✅ Arithmetic operations (ADD, SUB)
✅ Comparison operations (GT, EQ)
✅ Comprehensive test bench with edge cases
✅ Multi-bit vector operations [3:0]

```
---