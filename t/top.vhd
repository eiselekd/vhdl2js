library ieee;
use ieee.std_logic_1164.all;
use work.libe1.all;

entity top is
  generic (
    gcnt      : integer range 1 to 4  := 1;
    glen      : integer range 0 to 31  := 0
    );
  port (
    clk   : in std_logic;
    tin0  : in std_logic_vector(gcnt-1 downto 0)
    );
end;

architecture rtl of top is
  
  type vectyp is array (0 to gcnt-1) of std_logic_vector(glen downto 1);

  signal rst : std_logic;
  signal i0 : vectyp;
  signal o0 : vectyp;
  
begin

  e0: for i in gcnt-1 downto 0 generate
    t0 : e1
      generic map ( gcnt, glen )
      port map (tin0(i), clk, i0(i), o0(i));
  end generate e0;
  
end;

