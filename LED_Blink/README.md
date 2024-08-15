# LED Blink

## What does this project do?
This is a simple project to start working with Altera DE2 borad. At start first green LED is blinking, when first push-button (KEY0) is pressed, blinking will shifted to left green LED. Shifting process continues until eighth green LED and it will back to the first LCD.


## Modules

- **demux3x8**: This module implements an demultiplexer that connect its input signal to one its 8 output, through select signal.

- **ledBlinkControl**: This module recieves 50 MHz click signal as input and toggle its output every second.

- **ledBlink**: This is top level module in this project. This module contains of a demux3x8 instance and a ledBlinkControl instance. At first demultiplexer select signal is zero, and when push button is pressed select signal added by 1 (until 8) and output of ledBlinkControl direct to selected LED.

## Pin assignment

| Port        | Pin         |
| ----------- | ----------- |
| clk         | PIN_Y2      |
| next        | PIN_M23     |
| led_1       | PIN_E21     |
| led_2       | PIN_E22     |
| led_3       | PIN_E25     |
| led_4       | PIN_E24     |
| led_5       | PIN_H21     |
| led_6       | PIN_G20     |
| led_7       | PIN_G22     |
| led_8       | PIN_G21     |

