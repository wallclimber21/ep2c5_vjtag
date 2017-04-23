#!/bin/sh
# This is a shell archive (produced by GNU sharutils 4.6.3).
# To extract the files from this archive, save it to some FILE, remove
# everything before the `#!/bin/sh' line above, then type `sh FILE'.
#
lock_dir=_sh11201
# Made on 2009-05-27 20:35 CEST by <xl@wzab>.
# Source directory was `/tmp/alt_jtag'.
#
# Existing files will *not* be overwritten, unless `-c' is specified.
#
# This shar contains:
# length mode       name
# ------ ---------- ------------------------------------------
#   4678 -rw-r--r-- altera_jtag.py
#   3254 -rw-r--r-- jtag1.vhd
#    498 -rw-r--r-- pins.txt
#
MD5SUM=${MD5SUM-md5sum}
f=`${MD5SUM} --version | egrep '^md5sum .*(core|text)utils'`
test -n "${f}" && md5check=true || md5check=false
${md5check} || \
  echo 'Note: not verifying md5sums.  Consider installing GNU coreutils.'
save_IFS="${IFS}"
IFS="${IFS}:"
gettext_dir=FAILED
locale_dir=FAILED
first_param="$1"
for dir in $PATH
do
  if test "$gettext_dir" = FAILED && test -f $dir/gettext \
     && ($dir/gettext --version >/dev/null 2>&1)
  then
    case `$dir/gettext --version 2>&1 | sed 1q` in
      *GNU*) gettext_dir=$dir ;;
    esac
  fi
  if test "$locale_dir" = FAILED && test -f $dir/shar \
     && ($dir/shar --print-text-domain-dir >/dev/null 2>&1)
  then
    locale_dir=`$dir/shar --print-text-domain-dir`
  fi
done
IFS="$save_IFS"
if test "$locale_dir" = FAILED || test "$gettext_dir" = FAILED
then
  echo=echo
else
  TEXTDOMAINDIR=$locale_dir
  export TEXTDOMAINDIR
  TEXTDOMAIN=sharutils
  export TEXTDOMAIN
  echo="$gettext_dir/gettext -s"
fi
if (echo "testing\c"; echo 1,2,3) | grep c >/dev/null
then if (echo -n test; echo 1,2,3) | grep n >/dev/null
     then shar_n= shar_c='
'
     else shar_n=-n shar_c= ; fi
else shar_n= shar_c='\c' ; fi
f=shar-touch.$$
st1=200112312359.59
st2=123123592001.59
st2tr=123123592001.5 # old SysV 14-char limit
st3=1231235901

if touch -am -t ${st1} ${f} >/dev/null 2>&1 && \
   test ! -f ${st1} && test -f ${f}; then
  shar_touch='touch -am -t $1$2$3$4$5$6.$7 "$8"'

elif touch -am ${st2} ${f} >/dev/null 2>&1 && \
   test ! -f ${st2} && test ! -f ${st2tr} && test -f ${f}; then
  shar_touch='touch -am $3$4$5$6$1$2.$7 "$8"'

elif touch -am ${st3} ${f} >/dev/null 2>&1 && \
   test ! -f ${st3} && test -f ${f}; then
  shar_touch='touch -am $3$4$5$6$2 "$8"'

else
  shar_touch=:
  echo
  ${echo} 'WARNING: not restoring timestamps.  Consider getting and'
  ${echo} 'installing GNU `touch'\'', distributed in GNU coreutils...'
  echo
fi
rm -f ${st1} ${st2} ${st2tr} ${st3} ${f}
#
if test ! -d ${lock_dir}
then : ; else ${echo} 'lock directory '${lock_dir}' exists'
  exit 1
fi
if mkdir ${lock_dir}
then ${echo} 'x - created lock directory `'${lock_dir}\''.'
else ${echo} 'x - failed to create lock directory `'${lock_dir}\''.'
  exit 1
fi
# ============= altera_jtag.py ==============
if test -f 'altera_jtag.py' && test "$first_param" != -c; then
  ${echo} 'x -SKIPPING altera_jtag.py (file already exists)'
else
${echo} 'x - extracting altera_jtag.py (text)'
  sed 's/^X//' << 'SHAR_EOF' > 'altera_jtag.py' &&
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
X
import pexpect
import re
import time
#import fpgadbg_conv
import os
class urjtag:
X  def __init__(self):
X    self.p=pexpect.spawn("urjtag")
X    self.p.expect("jtag>")
X    self.af=re.compile("(.*\r\n)*")
X  def cmd(self,line):
X    self.p.sendline(line)
X    self.p.expect_exact("jtag>")
X    if self.p.before.find("Error:")>=0:
X        #res=-1
X        raise("error")
X    elif self.p.before.find("Unknown")>=0 or \
X         self.p.before.find("unknown")>=0:
X        #res=-2   
X        raise ("unknown command or syntax error")
X    return self.p.before
X  def send_dr(self,dr_as_str):
X        w=u.cmd("dr "+dr_as_str+":: shift dr :: dr")
X        #print w
X        g=self.af.search(w)
X        return g.group(1).strip()        
X        return int(g.group(1).strip(), base=2)
X        #int(, base=2)
X
X        
u=urjtag()
u.cmd("cable ByteBlaster ppdev /dev/parport1")
s=u.cmd("reset")
s=u.cmd("detect")
#Here we parse the output of the "detect" command,
#Building the list of the parts
parts=[]
finder=re.compile(r'.*Part\((?P<num>.*?)\):\s*(?P<name>\S*)', re.M)
start=0
while True:
X   rs=finder.search(s,start)
X   if not rs:
X      break
X   # We have found a new part, add it to the list of parts
X   parts.append((rs.group('num'),rs.group('name')))
X   start=rs.span()[1]
# OK, so we set all the parts except the EP2C35 in the BYPASS
# mode
for p in parts:
X   if p[1]=="EP2C35":
X      u.cmd("part "+p[0])
X      u.cmd("register DRS 4")
X      u.cmd("register DRL 64")
X      u.cmd("instruction USER1 0000001110 DRS")
X      u.cmd("instruction USER1L 0000001110 DRL")
X      u.cmd("instruction USER0 0000001100 DRS")
X      u.cmd("instruction USER0L 0000001100 DRL")
X      u.cmd("instruction USER1L")
X      u.cmd("shift ir")
X   else:
X      u.cmd("part "+p[0])
X      u.cmd("instruction BYPASS")
X      u.cmd("shift ir")
# The function bint allows us to convert part of the binary string to int
def bint(astring,beg,end):
X   sbeg=len(astring)-beg-1
X   send=len(astring)-end
X   return int(astring[sbeg:send],base=2)
# Now read the HUB IP Configuration Register
# (Table A-3 in Virtual JTAG (sld_virtual_jtag) 
# Megafunction User Guide)
u.cmd("dr "+64*"0")
u.cmd("shift dr")
u.cmd("instruction USER0 :: shift ir")
st=""
for i in range(0,8):
X  st=u.send_dr("0000")+st
hub_ipv=bint(st,31,27)
n_nodes=bint(st,26,19)
mfg_id=bint(st,18,8)
sum_mn=bint(st,7,0)
print "HUB IP VER: "+hex(hub_ipv)
print "N_NODES: "+str(n_nodes)
print "MFG_ID: "+hex(mfg_id)
print "SUM_MN: "+str(sum_mn)
# Now scan the nodes (Table A-4 in Virtual JTAG
# (sld_virtual_jtag) Megafunction User Guide)
for n in range(1,n_nodes+1):
X   st=""
X   for i in range(0,8):
X     st=u.send_dr("0000")+st
X   node_ver=bint(st,31,27)
X   node_id=bint(st,26,19)
X   mfg_id=bint(st,18,8)
X   node_inst_id=bint(st,7,0)
X   print 10*"*" + " NODE NR "+str(n) + " "+10*"*"
X   print "NODE VER: "+hex(node_ver)
X   print "NODE_ID: "+str(node_id)
X   print "MFG_ID: "+hex(mfg_id)
X   print "NODE_INST: "+str(node_inst_id)
#So now we can define instructions to access the user nodes
#Calculate addr_lan as CEIL(log2(n_nodes+1))
def ceil_log2(n):
X  pow2=1
X  res=0
X  while pow2<n:
X    pow2 <<= 1
X    res+=1
X  return res
X
addr_len=ceil_log2(n_nodes+1)   
vir_len=sum_mn-addr_len
u.cmd("register UDR "+str(sum_mn))
#In my sample design, user node is the node nr 1"
u.cmd("instruction USER1U 0000001110 UDR")
u.cmd("instruction USER1U :: shift ir")
if addr_len == 1 and vir_len == 3:
X  u.send_dr("1000") # 1-bit node number "1", 2-bits contents of VIR "000"
else:
X  raise "This is another design??? addr_len="+str(addr_len)+\
X  " vir_len="+str(vir_len)+", change the DR contents in the above line!"
#In fact, the above should be synthesized basing on the addr_len and vir_len
#values, but I really had no time to implement the proper int->bin_string
# conversion function !!!
#
#Define the register to access the user function (6 bits in my sample design)
u.cmd("register UDR6 6")
u.cmd("instruction USER0U 0000001100 UDR6")
u.cmd("instruction USER0U :: shift ir")
#Now we just blink the LEDS every second...
print "Start blinking!"
while True:
X    u.send_dr("101010")
X    time.sleep(1)
X    u.send_dr("010101")
X    time.sleep(1)
X
X
SHAR_EOF
  (set 20 09 05 27 20 32 08 'altera_jtag.py'; eval "$shar_touch") &&
  chmod 0644 'altera_jtag.py'
if test $? -ne 0
then ${echo} 'restore of altera_jtag.py failed'
fi
  if ${md5check}
  then (
       ${MD5SUM} -c >/dev/null 2>&1 || ${echo} 'altera_jtag.py: MD5 check failed'
       ) << SHAR_EOF
1331cd2ecd786cfad06ecba9167c3531  altera_jtag.py
SHAR_EOF
  else
test `LC_ALL=C wc -c < 'altera_jtag.py'` -ne 4678 && \
  ${echo} 'restoration warning:  size of altera_jtag.py is not 4678'
  fi
fi
# ============= jtag1.vhd ==============
if test -f 'jtag1.vhd' && test "$first_param" != -c; then
  ${echo} 'x -SKIPPING jtag1.vhd (file already exists)'
else
${echo} 'x - extracting jtag1.vhd (text)'
  sed 's/^X//' << 'SHAR_EOF' > 'jtag1.vhd' &&
-------------------------------------------------------------------------------
-- This is PUBLIC DOMAIN code, written by Wojciech M. Zabolotny
-- wzab<at>ise.pw.edu.pl 27.05.2009
-- to show how to access the user registers via Virtual JTAG
-- in Altera FPGA
-- This IP core works e.g. with Python+urJTAG code included
-- in this archive
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
X
entity jtag1 is
X
X  generic
X    (
X      DATA_WIDTH : natural := 8
X      );
X
X  port
X    (
X      leds             : out std_logic_vector(7 downto 0);
X      reconfig_request : out std_logic
X      );
X
end entity;
X
architecture rtl of jtag1 is
X
X  component sld_virtual_jtag
X    generic (
X      sld_auto_instance_index : string;
X      sld_instance_index      : natural;
X      sld_ir_width            : natural;
X      sld_sim_action          : string;
X      sld_sim_n_scan          : natural;
X      sld_sim_total_length    : natural;
X      lpm_type                : string
X      );
X    port (
X      tdi                : out std_logic;
X      tck                : out std_logic;
X      ir_in              : out std_logic_vector (1 downto 0);
X      virtual_state_cir  : out std_logic;
X      virtual_state_pdr  : out std_logic;
X      ir_out             : in  std_logic_vector (1 downto 0);
X      virtual_state_uir  : out std_logic;
X      tdo                : in  std_logic;
X      virtual_state_sdr  : out std_logic;
X      virtual_state_cdr  : out std_logic;
X      virtual_state_udr  : out std_logic;
X      virtual_state_e1dr : out std_logic;
X      virtual_state_e2dr : out std_logic
X      );
X  end component;
X  signal jt_tdi, jt_tdo, jt_tck, jt_udr, jt_cdr, jt_sdr, jt_e1dr, jt_e2dr : std_logic;
X  signal dr                                                               : std_logic_vector(5 downto 0) := "001011";
X  signal sleds                                                            : std_logic_vector(7 downto 0) := "00101100";
begin
X
X  leds             <= sleds;
X  reconfig_request <= '1';
X
X  sld_virtual_jtag_component : sld_virtual_jtag
X    generic map (
X      sld_auto_instance_index => "YES",
X      sld_instance_index      => 0,
X      sld_ir_width            => 2,
X      sld_sim_action          => "",
X      sld_sim_n_scan          => 0,
X      sld_sim_total_length    => 0,
X      lpm_type                => "sld_virtual_jtag"
X      )
X    port map (
X      ir_out             => "00",
X      tdo                => jt_tdo,
X      tdi                => jt_tdi,
X      tck                => jt_tck,
X      ir_in              => sleds(1 downto 0),
X      virtual_state_cir  => open,
X      virtual_state_pdr  => open,
X      virtual_state_uir  => open,
X      virtual_state_sdr  => jt_sdr,
X      virtual_state_cdr  => jt_cdr,
X      virtual_state_udr  => jt_udr,
X      virtual_state_e1dr => jt_e1dr,
X      virtual_state_e2dr => jt_e2dr
X      );
X
X  process(jt_tck)
X  begin
X    if(jt_tck'event and jt_tck = '1') then
X      if jt_sdr = '1' then
X        for i in 0 to 4 loop
X          dr(i+1) <= dr(i);
X        end loop;
X        dr(0)  <= jt_tdi;
X        jt_tdo <= dr(5);
X      end if;
X    end if;
X  end process;
X
X  process(jt_e1dr)
X  begin
X    if jt_e1dr'event and jt_e1dr = '1' then
X      sleds(7 downto 2) <= dr(5 downto 0);
X    end if;
X  end process;
X  
end rtl;
SHAR_EOF
  (set 20 09 05 27 20 03 34 'jtag1.vhd'; eval "$shar_touch") &&
  chmod 0644 'jtag1.vhd'
if test $? -ne 0
then ${echo} 'restore of jtag1.vhd failed'
fi
  if ${md5check}
  then (
       ${MD5SUM} -c >/dev/null 2>&1 || ${echo} 'jtag1.vhd: MD5 check failed'
       ) << SHAR_EOF
f2f86504615f003633e7e5ceee1e68c7  jtag1.vhd
SHAR_EOF
  else
test `LC_ALL=C wc -c < 'jtag1.vhd'` -ne 3254 && \
  ${echo} 'restoration warning:  size of jtag1.vhd is not 3254'
  fi
fi
# ============= pins.txt ==============
if test -f 'pins.txt' && test "$first_param" != -c; then
  ${echo} 'x -SKIPPING pins.txt (file already exists)'
else
${echo} 'x - extracting pins.txt (text)'
  sed 's/^X//' << 'SHAR_EOF' > 'pins.txt' &&
# Below are the pins definition, which I have used
# You should add them to the .qsf file
set_location_assignment PIN_AA11 -to leds[7]
set_location_assignment PIN_AF7 -to leds[6]
set_location_assignment PIN_AE7 -to leds[5]
set_location_assignment PIN_AF8 -to leds[4]
set_location_assignment PIN_AE8 -to leds[3]
set_location_assignment PIN_W12 -to leds[2]
set_location_assignment PIN_W11 -to leds[1]
set_location_assignment PIN_AC10 -to leds[0]
set_location_assignment PIN_AA14 -to reconfig_request
SHAR_EOF
  (set 20 09 05 27 20 34 42 'pins.txt'; eval "$shar_touch") &&
  chmod 0644 'pins.txt'
if test $? -ne 0
then ${echo} 'restore of pins.txt failed'
fi
  if ${md5check}
  then (
       ${MD5SUM} -c >/dev/null 2>&1 || ${echo} 'pins.txt: MD5 check failed'
       ) << SHAR_EOF
066773e567d72b9918f9a72f45c4c5df  pins.txt
SHAR_EOF
  else
test `LC_ALL=C wc -c < 'pins.txt'` -ne 498 && \
  ${echo} 'restoration warning:  size of pins.txt is not 498'
  fi
fi
if rm -fr ${lock_dir}
then ${echo} 'x - removed lock directory `'${lock_dir}\''.'
else ${echo} 'x - failed to remove lock directory `'${lock_dir}\''.'
  exit 1
fi
exit 0
