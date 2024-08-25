# Matrix Multiply

## What does this project do?
This project multiply a n x n matrix to n x 1 matrix (n is 4, 8, ...), which matrix values are 8 bit numbers and show elements of result on LCD one by one. This project uses 4 MAC unit to perform multiplications so this project process each 4 lines of matrix parallel.

## Modules
- **LCD_Controller**: This module handle displaying characters on LCD.
- **Reset_Delay**: This module work as counter for creating a small dealy at begining of code. LCD_Controller and Reset_Delay module can be used in other project without any modification.
- **digit_16bit**: This module recieve a 16 bit binary number (which has maximum 5 digit in decimal form) and calculate its decimal digits and its sign.
- **mac_unit**: MAC (multiply and accumulate) unit is implemented in this module. It will updates output signal when `valid` signal set to 1.
- **matrix_multiplier**: This module has 4 MAC units and multuplies a row from first matrix to second matrix and generate an element from result matrix.
- **address_generator_unit**: This module generate address of inputs of each four MAC units. It also generate output addresses and set `clear` and `valid` signals of MAC units.
- **Matrix_Multiply.v**: This is the top-level module of project, which initialize two matrixes and write outputs in a buffer and show them on LCD.


## Pin assignment

| Port        | Pin         |
| ----------- | ----------- |
| clk         | PIN_Y2      |
| LCD_ON      | PIN_L5     |
| LCD_BLON    | PIN_L6     |
| LCD_RW      | PIN_M1     |
| LCD_EN      | PIN_L4     |
| LCD_RS      | PIN_M2     |
| LCD_DATA[0] | PIN_L3     |
| LCD_DATA[1] | PIN_L1     |
| LCD_DATA[2] | PIN_L2     |
| LCD_DATA[3] | PIN_K7     |
| LCD_DATA[4] | PIN_K1     |
| LCD_DATA[5] | PIN_K2     |
| LCD_DATA[6] | PIN_M3     |
| LCD_DATA[7] | PIN_M5     |