
EP2C5 VJTAG
===========

Experiment to test virtual jtag on EP2C5 development board

Usage
-----

Start virtual JTAG server:

    `quartus_stp -t vjtag_client_control.tcl`

Send command to virtual JTAG server:

    `python vjtag_led_counter.py`

