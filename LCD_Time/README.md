# LCD Time

## What does this project do?
This project shows time in format HH:MM:SS on 16x2 LCD module. Time starts from values that determined in `begin` block in code, defualt time in this project is 12:30:40.


## Modules

- **LCD_Controller**: This module handle displaying characters on LCD.
- **Reset_Delay**: This module work as counter for creating a small dealy at begining of code. LCD_Controller and Reset_Delay module can be used in other project without any modification.
- **lcdlab2**: This is the top level module in this project. It has an instance of LCD_Controller and Reset_Delay and updates values of register that store values of each LCD position. There are some hints about coding for LCD module:

    - The data which passes to LCD_Controller has format of $[type][data]$. Type field is one of command or data, type should be 1 for data and 0 for command. We use data mode when we want to change value of a LCD cell, In this mode data is 8-bit ASCII code, for example if we want to send *A* to LCD_Controller, we should send $100101001$, which first 1 is for data and 00101001 is ASCII code of *A*.

    - Updating LCD cells is performing in a FSM like process. At first LUT_INDEX (updating position) is at beginig of LCD, and value the register for this position is read and will send to LCD_Controller and then we go to sencond state and we should wait until *done* signal activated by LCD_Controller. When it was activated, we go to third state and wait for samll time as delay and finally we will go to last state and LUT_INDEX added by one and will back to the first state. LUT_SIZE is total cells that will be updated, this can be changed.



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

