<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
   
</head>
<body>
    <h1>MIPS 32 Processor Projects</h1>
    
  <h2>MIPS 32 Pipeline Processor</h2>
    <p>This project designs a pipelined MIPS 32 processor to handle various hazards:</p>
    <ul>
        <li><strong>Structural Hazards:</strong> Resolved by writing on the falling edge of the clock in the Register File.</li>
        <li><strong>Data Hazards:</strong> Handled by introducing NoOps for hazards with distance 1 and 2.</li>
        <li><strong>Control Hazards:</strong> Managed by inserting NoOps for branch and jump instructions.</li>
    </ul>
    <p>Components include Fetch, Decode, Execute, Memory, MPG, SSD, UC, and Test Environment. The processor is designed and tested using VHDL and Vivado.</p>

  <h2>MIPS 32 Single-Cycle Processor</h2>
    <p>This project develops a single-cycle MIPS 32 processor, also using VHDL and Vivado. It addresses the problem of replacing array elements with triples if they are greater than X, or halves otherwise.</p>
    <ul>
        <li><strong>Instruction Types:</strong> Includes R-type, I-type, and J-type instructions.</li>
        <li><strong>Functionality:</strong> The processor supports essential operations like ADD, SUB, LW, SW, and more.</li>
        <li><strong>Verification:</strong> The design compiles and generates a bitstream but has not been fully verified on the FPGA board due to project timing.</li>
    </ul>
    <p>For detailed documentation, please refer to the attached files.</p>
</body>
</html>
