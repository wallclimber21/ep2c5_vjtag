
#bsdl path <path>

cable UsbBlaster
detect
part 0


# Define DRS register, with a length of 4
register DRS 4

# Define DRL register, with a length of 64
register DRL 64

instruction USER1  0000001110 DRS
instruction USER1L 0000001110 DRL

instruction USER0  0000001100 DRS
instruction USER0L 0000001100 DRL

# Select USER1 instruction 
instruction USER1L
shift ir

# The USER1 register contains address and vir value. It's length is variable, but
# it's always to be 64 or less.
# When you shift 64 zeros, you're guaranteed to select address 0 and VIR 0.
# Address 0 is always allocated to the SLD hub, and VIR 0 of the SLD hub links to the 32-bit wide HUB IP configuration register.
# The HUB IP configuration register contains the next clues for further discovery.

dr  0000000000000000000000000000000000000000000000000000000000000000
shift dr

# Select the USER0 register.
# Due to the previous USER1 sequence, the USER0 DR will now be connected to the HUB IP configuration register
instruction USER0 :: shift ir

# Shift 32 bits, 8 nibbles out. 
# The data that comes out is as follows: 
# * HUB IP version (6 bits)
# * Nr Nodes (8 bits)			: The number of nodes connected to the SLD hub.
# * Altera MFG ID (10 bits)		: 0x06E
# * m (8 bits)					: m is size of the largest VIR register of SLD client nodes. 
dr 0000 :: shift dr :: dr
dr 0000 :: shift dr :: dr
dr 0000 :: shift dr :: dr
dr 0000 :: shift dr :: dr
dr 0000 :: shift dr :: dr
dr 0000 :: shift dr :: dr
dr 0000 :: shift dr :: dr
dr 0000 :: shift dr :: dr

# Shift another 32 bits out.
# The data contains:
# * node version (5 bits)		: version of ID of this node type.
# * node id (8 bits)			: node type. (0x08 = virtual jtag, 0x00 = signaltap, 0x04 = serial flash loader, 0x84 = JTAG to avalon)
# * node MFG ID (11 bits)		: manufacturer ID of this node type. 0x06e = Altera.
# * node instance ID (8 bits)	: node instance ID, in case there are multiple nodes of the same type.
dr 0000 :: shift dr :: dr
dr 0000 :: shift dr :: dr
dr 0000 :: shift dr :: dr
dr 0000 :: shift dr :: dr
dr 0000 :: shift dr :: dr
dr 0000 :: shift dr :: dr
dr 0000 :: shift dr :: dr
dr 0000 :: shift dr :: dr

register UDR 5					: 5 bits. 1 address, 4 VIR
instruction USER1U 0000001110 UDR

instruction USER1U :: shift ir

# node 1: select VIR 1
dr 10001 :: shift dr :: dr




