# 5 Stage Pipelined processor implementation based on RV32I
Implementation of the 5-stage pipelined processor based on the RV32I ISA

## Features
- Has support for all jump, branch, arithmetic and load/store instructions
- Data hazard detection and forwarding
- Control hazard detection and flushing
- Also contains (1,2) correlating branch predictor and a branch history table with 8 entries

## References

1. https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf
