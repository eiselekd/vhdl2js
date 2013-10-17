library ieee;
use ieee.std_logic_1164.all;

entity e1 is
  generic (
    gcnt      : integer range 1 to 4  := 1;
    glen      : integer range 0 to 31  := 0
    );
  port (
    clk : in std_logic;
    rst : in std_logic;
    in0 : in std_logic_vector(glen downto 0) ;
    out0 : out std_logic_vector(glen downto 0)
    );
end;

architecture rtl of e1 is
  signal s0,s1 : std_logic;
  signal sv0 : std_logic_vector(glen-1 downto 0);
  
begin
  s1 <= s0 after 2 ns;
  
  p0 : process(rst, in0)
    variable v0, v1 : std_logic := '0';
    variable vv0 : std_logic_vector(glen-1 downto 0);
  begin
    
    v1 := '0';
    v0 := '0';

    vv0(1 downto 0) := v1 & v0;

    if (not (in0(1 downto 0) = "01" or in0(0) = '0')) then
      if (in0(1) = '0') then
        v0 := '0';
      end if;
      v0 := '1';
    else
      v0 := '0';
    end if;

    if (in0(2) = '0') then
      if (in0(3) = '0') then
        v1 := '0';
      end if;
      v1 := '1';
    else
      v1 := '0';
    end if;
    
    out0(1 downto 0) <= v0 & v1; --v0 & v1;
    out0(1) <= v1;
  end process;
  
end;

library ieee;
use ieee.std_logic_1164.all;

package libe1 is

  component e1 
    generic (
      gcnt      : integer range 1 to 4  := 1;
      glen      : integer range 0 to 31  := 0
      );
    port (
      clk : in std_logic;
      rst : in std_logic;
      in0 : in std_logic_vector(glen downto 0);
      out0 : out std_logic_vector(glen downto 0)
      );
  end component;

end;
