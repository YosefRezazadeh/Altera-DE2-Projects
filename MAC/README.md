# MAC

## What does this project do?
This project contains a MAC (multiply and accumulate) unit that multiply two signed 8 bit number and also store result of multiplication in an accumulation register and finally add result with a bias. Two buffer with 8 numbers and a bias term defined and final result will be shown on LCD using developed codes in LCD_Time project.

## Modules
- **LCD_Controller**: This module handle displaying characters on LCD.
- **Reset_Delay**: This module work as counter for creating a small dealy at begining of code. LCD_Controller and Reset_Delay module can be used in other project without any modification.
- **digit_16bit**: This module recieve a 16 bit binary number (which has maximum 5 digit in decimal form) and calculate its decimal digits and its sign.
- **mac_unit**: MAC (multiply and accumulate) unit is implemented in this module. It will updates output signal when `valid` signal set to 1.
- **MAC**: This is the top level module of project that calculates result for two predefined buffers and show final result on LCD. Values of buffer is defined in `initial` block.

## Pin assignment

| Port        | Pin         |
| ----------- | ----------- |
| CLOCK_50    | PIN_Y2      |
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