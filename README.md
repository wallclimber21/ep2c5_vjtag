
EP2C5 VJTAG
===========

Experiment to test virtual jtag on EP2C5 development board.

This is nothing more than a port of the [virtual jtag tutorial for the DE0-Nano board](http://idlelogiclabs.com/2012/04/15/talking-to-the-de0-nano-using-the-virtual-jtag-interface/) design for the dirt cheap EP2C5 board that can usually be found on eBay for around $13.

When the design is loaded, one LED is connected to a fixed rate blinker, used as sanity test that all is well. The two 
other LEDs are connected to bit 0 and bit 6 of a DR shift register instead. There are both on after the bitstream has 
been loaded.

During execution of the vjtag_led_counter program, one LED will be blinking very quickly, while the other will simply switch
from 1 to 0.


Usage
-----

Start virtual JTAG server:

```
quartus_stp -t vjtag_client_control.tcl
```

Send command to virtual JTAG server:

```
python vjtag_led_counter.py
```

