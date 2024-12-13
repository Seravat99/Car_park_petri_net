----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:14:04 12/05/2021 
-- Design Name: 
-- Module Name:    button_delaying - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity button_delaying is
	Port ( reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           b_i: in  STD_LOGIC;
           b_m : in  STD_LOGIC;
           b_i_m : in  STD_LOGIC;
			  b_i_d: out  STD_LOGIC;
           b_m_d : out  STD_LOGIC;
           b_i_m_d : out  STD_LOGIC
			  );
end button_delaying;

architecture Behavioral of button_delaying is
signal delay : integer range 0 to 5000000;
begin

--Process button delaying process
BUTTON_DELAYING: process (clk, reset)
	begin
		if ( reset = '1') then
			delay <= 0;
			b_m_d <= '0';
			b_i_m_d <= '0';
			b_i_d <= '0';
      elsif ( clk'event and clk = '1') then
         if ( delay = 4999999) then
				delay <= 0;
				if(b_m = '1') then
					b_m_d <= '1';
				end if;	
				if(b_i_m = '1') then
					b_i_m_d <= '1';
				end if;	
				if(b_i = '1') then
					b_i_d <= '1';						
				end if;	
         else
				delay <= delay + 1;
				
				b_m_d <= '0';
				b_i_m_d <= '0';
				b_i_d <= '0';
			end if;
      end if;
	end process;	
	

end Behavioral;

