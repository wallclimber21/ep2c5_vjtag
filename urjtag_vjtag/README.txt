# Copied from: https://groups.google.com/forum/#!topic/alt.sources/WKzYsx6lvQ0

This archive contains the code demonstrating the enumeration of 
the SLD_NODEs (Virtual JTAG instances) connected to the SLD hub
in Altera FPGA.
This PUBLIC DOMAIN code, written by Wojciech M. Zabolotny
wzab<at>ise.pw.edu.pl 27.05.2009 is written basing
on information provided by Altera in the "Virtual JTAG
(sld_virtual_jtag) Megafunction User Guide",
Available (at least atthe time of writing)
at http://www.altera.com/literature/ug/ug_virtualjtag.pdf

This archive consists of the file jtag1.vhd prepared for 
the NIOS2 EVB EP2C35 board - the Virtual JTAG instance
controls the LEDs.

The altera_jtag.py is the Python code, which uses the urJTAG
to access the SDL hub and SDL nodes via the JTAG interface
(now: ByteBlaster connected to /dev/parport1)

