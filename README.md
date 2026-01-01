# Happy Birthday Serial Pattern Detector 🎂

This project implements a serial transmitter–receiver system that detects a
9-bit birthday pattern (Month + Date) from a random 10-bit serial stream and
displays the number of hits per second on a 7-segment display.

## Clock
- System Clock: 10 kHz

## Transmitter
- 10-bit counter generates data (0–1023)
- PISO transmitter sends LSB-first
- Bit rate = 10 kHz, Frame rate = 1 kHz

## Receiver
- 9-bit shift register detects birthday pattern
- Overlapping matches supported

## Display
- Hit count is updated every 1 second
- Value is converted to BCD and shown on 7-segment LED

## Top Ports

| Signal            | Dir | Description            |
|-------            |-----|-------------           |
| i_clk             | In  | 10 kHz clock           |
| i_rst             | In  | Active-high reset      |
| i_tx_ena_n        | In  | Active-low TX enable   |
| o_hit_count       | Out | 7-segment display data |
| o_hit_count_valid | Out | Display update pulse   |
