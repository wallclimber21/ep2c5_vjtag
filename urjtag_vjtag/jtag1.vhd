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

entity jtag1 is

  generic
    (
      DATA_WIDTH : natural := 8
      );

  port
    (
      leds             : out std_logic_vector(7 downto 0);
      reconfig_request : out std_logic
      );

end entity;

architecture rtl of jtag1 is

  component sld_virtual_jtag
    generic (
      sld_auto_instance_index : string;
      sld_instance_index      : natural;
      sld_ir_width            : natural;
      sld_sim_action          : string;
      sld_sim_n_scan          : natural;
      sld_sim_total_length    : natural;
      lpm_type                : string
      );
    port (
      tdi                : out std_logic;
      tck                : out std_logic;
      ir_in              : out std_logic_vector (1 downto 0);
      virtual_state_cir  : out std_logic;
      virtual_state_pdr  : out std_logic;
      ir_out             : in  std_logic_vector (1 downto 0);
      virtual_state_uir  : out std_logic;
      tdo                : in  std_logic;
      virtual_state_sdr  : out std_logic;
      virtual_state_cdr  : out std_logic;
      virtual_state_udr  : out std_logic;
      virtual_state_e1dr : out std_logic;
      virtual_state_e2dr : out std_logic
      );
  end component;
  signal jt_tdi, jt_tdo, jt_tck, jt_udr, jt_cdr, jt_sdr, jt_e1dr, jt_e2dr : std_logic;
  signal dr                                                               : std_logic_vector(5 downto 0) := "001011";
  signal sleds                                                            : std_logic_vector(7 downto 0) := "00101100";
begin

  leds             <= sleds;
  reconfig_request <= '1';

  sld_virtual_jtag_component : sld_virtual_jtag
    generic map (
      sld_auto_instance_index => "YES",
      sld_instance_index      => 0,
      sld_ir_width            => 2,
      sld_sim_action          => "",
      sld_sim_n_scan          => 0,
      sld_sim_total_length    => 0,
      lpm_type                => "sld_virtual_jtag"
      )
    port map (
      ir_out             => "00",
      tdo                => jt_tdo,
      tdi                => jt_tdi,
      tck                => jt_tck,
      ir_in              => sleds(1 downto 0),
      virtual_state_cir  => open,
      virtual_state_pdr  => open,
      virtual_state_uir  => open,
      virtual_state_sdr  => jt_sdr,
      virtual_state_cdr  => jt_cdr,
      virtual_state_udr  => jt_udr,
      virtual_state_e1dr => jt_e1dr,
      virtual_state_e2dr => jt_e2dr
      );

  process(jt_tck)
  begin
    if(jt_tck'event and jt_tck = '1') then
      if jt_sdr = '1' then
        for i in 0 to 4 loop
          dr(i+1) <= dr(i);
        end loop;
        dr(0)  <= jt_tdi;
        jt_tdo <= dr(5);
      end if;
    end if;
  end process;

  process(jt_e1dr)
  begin
    if jt_e1dr'event and jt_e1dr = '1' then
      sleds(7 downto 2) <= dr(5 downto 0);
    end if;
  end process;
  
end rtl;
