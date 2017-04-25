#!/usr/bin/python
# This is the code demonstrating the enumeration of 
# the SLD_NODEs (Virtual JTAG instances)
# connected to the SLD hub in Altera FPGA
# This PUBLIC DOMAIN code, written by Wojciech M. Zabolotny
# wzab<at>ise.pw.edu.pl 27.05.2009 is written basing
# on information provided by Altera in the "Virtual JTAG
# (sld_virtual_jtag) Megafunction User Guide",
# Available (at least atthe time of writing)
# at http://www.altera.com/literature/ug/ug_virtualjtag.pdf
# This code works with the code jtag1.vhd (included in this
# archive) uploaded to the NIOS2 EVB EP2C35 board.

import pexpect
import re
import time
#import fpgadbg_conv
import os
class urjtag:
  def __init__(self):
    self.p=pexpect.spawn("/opt/urjtag/bin/jtag")
    self.p.expect("jtag>")
    self.af=re.compile("(.*\r\n)*")
  def cmd(self,line):
    print "cmd:",line
    self.p.sendline(line)
    self.p.expect_exact("jtag>")
    if self.p.before.find("Error:")>=0:
        #res=-1
        raise("error")
    elif self.p.before.find("Unknown")>=0 or \
         self.p.before.find("unknown")>=0:
        #res=-2   
        raise ("unknown command or syntax error")
    return self.p.before
  def send_dr(self,dr_as_str):
        w=u.cmd("dr "+dr_as_str+":: shift dr :: dr")
        print w
        g=self.af.search(w)
        return g.group(1).strip()[0:4]
        return int(g.group(1).strip(), base=2)
        #int(, base=2)

        
u=urjtag()
u.cmd("cable UsbBlaster")
s=u.cmd("reset")
s=u.cmd("detect")
#Here we parse the output of the "detect" command,
#Building the list of the parts
parts=[]
finder=re.compile(r'.*Part\((?P<num>.*?)\):\s*(?P<name>\S*)', re.M)
start=0
while True:
   rs=finder.search(s,start)
   if not rs:
      break
   # We have found a new part, add it to the list of parts
   parts.append((rs.group('num'),rs.group('name')))
   start=rs.span()[1]
# OK, so we set all the parts except the EP2C5 in the BYPASS
# mode
for p in parts:
   if p[1]=="EP2C5":
      u.cmd("part "+p[0])
      u.cmd("register DRS 4")
      u.cmd("register DRL 64")
      u.cmd("instruction USER1 0000001110 DRS")
      u.cmd("instruction USER1L 0000001110 DRL")
      u.cmd("instruction USER0 0000001100 DRS")
      u.cmd("instruction USER0L 0000001100 DRL")
      u.cmd("instruction USER1L")
      u.cmd("shift ir")
   else:
      u.cmd("part "+p[0])
      u.cmd("instruction BYPASS")
      u.cmd("shift ir")

# The function bint allows us to convert part of the binary string to int
def bint(astring,beg,end):
   sbeg=len(astring)-beg-1
   send=len(astring)-end
   return int(astring[sbeg:send],base=2)

# Now read the HUB IP Configuration Register
# (Table A-3 in Virtual JTAG (sld_virtual_jtag) 
# Megafunction User Guide)
u.cmd("dr "+64*"0")
u.cmd("shift dr")
u.cmd("instruction USER0 :: shift ir")
st=""
for i in range(0,8):
  st=u.send_dr("0000")+st
hub_ipv=bint(st,31,27)
n_nodes=bint(st,26,19)
mfg_id=bint(st,18,8)
vir_len=bint(st,7,0)
print 10*"*" + " SLD HUB INFO "+10*"*"
print "HUB IP VER: "+hex(hub_ipv)
print "N_NODES: "+str(n_nodes)
print "MFG_ID: "+hex(mfg_id)
print "M: "+str(vir_len)

# Now scan the nodes (Table A-4 in Virtual JTAG
# (sld_virtual_jtag) Megafunction User Guide)
for n in range(1,n_nodes+1):
   st=""
   for i in range(0,8):
     st=u.send_dr("0000")+st
   node_ver=bint(st,31,27)
   node_id=bint(st,26,19)
   mfg_id=bint(st,18,8)
   node_inst_id=bint(st,7,0)
   print 10*"*" + " NODE NR "+str(n) + " "+10*"*"
   print "NODE VER: "+hex(node_ver)
   print "NODE_ID: "+str(node_id)
   print "MFG_ID: "+hex(mfg_id)
   print "NODE_INST: "+str(node_inst_id)

#So now we can define instructions to access the user nodes
#Calculate addr_lan as CEIL(log2(n_nodes+1))
def ceil_log2(n):
  pow2=1
  res=0
  while pow2<n:
    pow2 <<= 1
    res+=1
  return res

addr_len=ceil_log2(n_nodes+1)   
sum_mn=addr_len+vir_len
print "addr_len:", addr_len
print "vir_len:", vir_len

u.cmd("register UDR "+str(sum_mn))

#In my sample design, user node is the node nr 1"
u.cmd("instruction USER1U 0000001110 UDR")
u.cmd("instruction USER1U :: shift ir")
if addr_len == 1 and vir_len == 4:
  u.send_dr("10001") # 1-bit node number "1", 2-bits contents of VIR "000"
else:
  raise "This is another design??? addr_len="+str(addr_len)+\
  " vir_len="+str(vir_len)+", change the DR contents in the above line!"



#In fact, the above should be synthesized basing on the addr_len and vir_len
#values, but I really had no time to implement the proper int->bin_string
# conversion function !!!
#
#Define the register to access the user function (6 bits in my sample design)
u.cmd("register UDR7 7")
u.cmd("instruction USER0U 0000001100 UDR7")
u.cmd("instruction USER0U :: shift ir")
#Now we just blink the LEDS every second...
print "Start blinking!"
while True:
    u.send_dr("0000001")
#    time.sleep(1)
    u.send_dr("0000010")
#    time.sleep(1)
    u.send_dr("0000100")
#    time.sleep(1)


