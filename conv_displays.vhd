----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:55:03 10/27/2021 
-- Design Name: 
-- Module Name:    conversor_display - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity conv_displays is
	POrt ( clk : in std_logic;
			 reset : in std_logic;
			 c_b_m : in integer range 0 to 4;-- display mode 0 for normal clock, 1 for normal clock in increment mode, 2 for alarm clock, 3 for timer, 4 for stopwatch
			 switch_time_units :in std_logic;--time_unit display mode '0' for least significant time units mode, '1 for most significant'
			 --normal clock variables
			 c_seg_u : in integer range 0 to 9;
			 c_seg_d : in integer range 0 to 9; 
			 c_min_u : in integer range 0 to 9;
			 c_min_d : in integer range 0 to 5;
			 c_hour_u : in integer range 0 to 9;
			 c_hour_d : in integer range 0 to 2; 
			 --alarm variables
			 c_min_u_alarm : in integer range 0 to 9;
			 c_min_d_alarm : in integer range 0 to 5;
			 c_hour_u_alarm : in integer range 0 to 9;
			 c_hour_d_alarm : in integer range 0 to 2;
			 --timer variables
			 c_seg_u_timer : in integer range 0 to 9;
			 c_seg_d_timer : in integer range 0 to 5;
			 c_min_u_timer : in integer range 0 to 9;
			 c_min_d_timer : in integer range 0 to 5;
			 c_hour_u_timer : in integer range 0 to 9;
			 c_hour_d_timer : in integer range 0 to 2;
			 --stopwatch variables
			 c_centseg_u_sw : in integer range 0 to 9;
			 c_centseg_d_sw : in integer range 0 to 9;
			 c_seg_u_sw : in integer range 0 to 9;
			 c_seg_d_sw : in integer range 0 to 5;
			 c_min_u_sw : in integer range 0 to 9;
			 c_min_d_sw : in integer range 0 to 5;
			 an3 : out std_logic;
			 an2 : out std_logic;
			 an1 : out std_logic;
			 an0 : out std_logic;
			 algarismo : out std_logic_vector(7 downto 0)); 
end conv_displays;

architecture Behavioral of conv_displays is

signal alg : integer range 0 to 9;
signal cont_clock : integer range 0 to 499999;
signal num_alg : std_logic_vector(1 downto 0); 

begin
	co: process (clk, reset)
begin
 if reset = '1' then
	cont_clock <= 0;
 elsif clk'event and clk = '1' then
	if cont_clock = 499999 then
		cont_clock <= 0;
		num_alg <= "00";
	else
		if cont_clock = 124999 then
			num_alg <= "01";
		elsif cont_clock = 249999 then
			num_alg <= "10";
		elsif cont_clock = 374999 then
			num_alg <= "11";
		end if;
		cont_clock <= cont_clock + 1;
	end if;
 end if;
end process;

an : process(clk, reset)
begin
  if reset = '1' then
		an3 <= '0';
		an2 <= '0';
		an1 <= '0';
		an0 <= '0';
		alg <= 0;
		algarismo(7) <= '1';
  elsif clk'event and clk = '1' then
		if c_b_m = 0 and switch_time_units = '0' then -- display mode for normal clock seconds and minutes
			if num_alg = "00" then
				an3 <= '1';
				an2 <= '1';
				an1 <= '1';
				an0 <= '0';
				alg <= c_seg_u;
				algarismo(7) <= '1';
			elsif num_alg = "01" then
				an3 <= '1';
				an2 <= '1';
				an1 <= '0';
				an0 <= '1';
				alg <= c_seg_d;
				algarismo(7) <= '1';
			elsif num_alg = "10" then
				an3 <= '1';
				an2 <= '0';
				an1 <= '1';
				an0 <= '1';
				alg <= c_min_u;
				algarismo(7) <= '0';
			elsif num_alg = "11" then
				an3 <= '0'; 
				an2 <= '1';
				an1 <= '1';
				an0 <= '1';
				alg <= c_min_d;
				algarismo(7) <= '1';
			end if;
		elsif c_b_m = 0 and switch_time_units = '1'  then---display mode for normal clock with minutes and hours
			if num_alg = "00" then
				an3 <= '1';
				an2 <= '1';
				an1 <= '1';
				an0 <= '0';
				alg <= c_min_u;
				algarismo(7) <= '1';
			elsif num_alg = "01" then
				an3 <= '1';
				an2 <= '1';
				an1 <= '0';
				an0 <= '1';
				alg <= c_min_d;
				algarismo(7) <= '1';
			elsif num_alg = "10" then
				an3 <= '1';
				an2 <= '0';
				an1 <= '1';
				an0 <= '1';
				alg <= c_hour_u;
				algarismo(7) <= '0';
			elsif num_alg = "11" then
				an3 <= '0'; 
				an2 <= '1';
				an1 <= '1';
				an0 <= '1';
				alg <= c_hour_d;
				algarismo(7) <= '1';
			end if;
		elsif c_b_m = 1 and switch_time_units = '0'  then---display mode for normal clock in increment mode with seconds and minutes
			if num_alg = "00" then
				an3 <= '1';
				an2 <= '1';
				an1 <= '1';
				an0 <= '0';
				alg <= c_seg_u;
				algarismo(7) <= '1';
			elsif num_alg = "01" then
				an3 <= '1';
				an2 <= '1';
				an1 <= '0';
				an0 <= '1';
				alg <= c_seg_d;
				algarismo(7) <= '1';
			elsif num_alg = "10" then
				an3 <= '1';
				an2 <= '0';
				an1 <= '1';
				an0 <= '1';
				alg <= c_min_u;
				algarismo(7) <= '0';
			elsif num_alg = "11" then
				an3 <= '0'; 
				an2 <= '1';
				an1 <= '1';
				an0 <= '1';
				alg <= c_min_d;
				algarismo(7) <= '1';
			end if;
		elsif c_b_m = 1 and switch_time_units = '1'  then---display mode for normal clock in increment mode with minutes and hours
			if num_alg = "00" then
				an3 <= '1';
				an2 <= '1';
				an1 <= '1';
				an0 <= '0';
				alg <= c_min_u;
				algarismo(7) <= '1';
			elsif num_alg = "01" then
				an3 <= '1';
				an2 <= '1';
				an1 <= '0';
				an0 <= '1';
				alg <= c_min_d;
				algarismo(7) <= '1';
			elsif num_alg = "10" then
				an3 <= '1';
				an2 <= '0';
				an1 <= '1';
				an0 <= '1';
				alg <= c_hour_u;
				algarismo(7) <= '0';
			elsif num_alg = "11" then
				an3 <= '0'; 
				an2 <= '1';
				an1 <= '1';
				an0 <= '1';
				alg <= c_hour_d;
				algarismo(7) <= '1';
			end if;
		elsif c_b_m = 2 then---display mode for alarm clock in increment mode with minutes and hours
			if num_alg = "00" then
				an3 <= '1';
				an2 <= '1';
				an1 <= '1';
				an0 <= '0';
				alg <= c_min_u_alarm;
				algarismo(7) <= '1';
			elsif num_alg = "01" then
				an3 <= '1';
				an2 <= '1';
				an1 <= '0';
				an0 <= '1';
				alg <= c_min_d_alarm;
				algarismo(7) <= '1';
			elsif num_alg = "10" then
				an3 <= '1';
				an2 <= '0';
				an1 <= '1';
				an0 <= '1';
				alg <= c_hour_u_alarm;
				algarismo(7) <= '0';
			elsif num_alg = "11" then
				an3 <= '0'; 
				an2 <= '1';
				an1 <= '1';
				an0 <= '1';
				alg <= c_hour_d_alarm;
				algarismo(7) <= '1';
			end if;
		elsif c_b_m = 3 and switch_time_units = '0' then---display mode for timer clock in increment mode with seconds and minutes
			if num_alg = "00" then
				an3 <= '1';
				an2 <= '1';
				an1 <= '1';
				an0 <= '0';
				alg <= c_seg_u_timer;
				algarismo(7) <= '1';
			elsif num_alg = "01" then
				an3 <= '1';
				an2 <= '1';
				an1 <= '0';
				an0 <= '1';
				alg <= c_seg_d_timer;
				algarismo(7) <= '1';
			elsif num_alg = "10" then
				an3 <= '1';
				an2 <= '0';
				an1 <= '1';
				an0 <= '1';
				alg <= c_min_u_timer;
				algarismo(7) <= '0';
			elsif num_alg = "11" then
				an3 <= '0'; 
				an2 <= '1';
				an1 <= '1';
				an0 <= '1';
				alg <= c_min_d_timer;
				algarismo(7) <= '1';
			end if;
		elsif c_b_m = 3 and switch_time_units = '1' then---display mode for timer clock in increment mode with minutes and hours
			if num_alg = "00" then
				an3 <= '1';
				an2 <= '1';
				an1 <= '1';
				an0 <= '0';
				alg <= c_min_u_timer;
				algarismo(7) <= '1';
			elsif num_alg = "01" then
				an3 <= '1';
				an2 <= '1';
				an1 <= '0';
				an0 <= '1';
				alg <= c_min_d_timer;
				algarismo(7) <= '1';
			elsif num_alg = "10" then
				an3 <= '1';
				an2 <= '0';
				an1 <= '1';
				an0 <= '1';
				alg <= c_hour_u_timer;
				algarismo(7) <= '0';
			elsif num_alg = "11" then
				an3 <= '0'; 
				an2 <= '1';
				an1 <= '1';
				an0 <= '1';
				alg <= c_hour_d_timer;
				algarismo(7) <= '1';
			end if;	
		elsif c_b_m = 4 and switch_time_units = '0' then---display mode for stopwatch clock in increment mode with centseconds and seconds
			if num_alg = "00" then
				an3 <= '1';
				an2 <= '1';
				an1 <= '1';
				an0 <= '0';
				alg <= c_centseg_u_sw;
				algarismo(7) <= '1';
			elsif num_alg = "01" then
				an3 <= '1';
				an2 <= '1';
				an1 <= '0';
				an0 <= '1';
				alg <= c_centseg_d_sw;
				algarismo(7) <= '1';
			elsif num_alg = "10" then
				an3 <= '1';
				an2 <= '0';
				an1 <= '1';
				an0 <= '1';
				alg <= c_seg_u_sw;
				algarismo(7) <= '0';
			elsif num_alg = "11" then
				an3 <= '0'; 
				an2 <= '1';
				an1 <= '1';
				an0 <= '1';
				alg <= c_seg_d_sw;
				algarismo(7) <= '1';
			end if;
		elsif c_b_m = 4 and switch_time_units = '1' then---display mode for stopwatch clock in increment mode with seconds and minutes
			if num_alg = "00" then
				an3 <= '1';
				an2 <= '1';
				an1 <= '1';
				an0 <= '0';
				alg <= c_seg_u_sw;
				algarismo(7) <= '1';
			elsif num_alg = "01" then
				an3 <= '1';
				an2 <= '1';
				an1 <= '0';
				an0 <= '1';
				alg <= c_seg_d_sw;
				algarismo(7) <= '1';
			elsif num_alg = "10" then
				an3 <= '1';
				an2 <= '0';
				an1 <= '1';
				an0 <= '1';
				alg <= c_min_u_sw;
				algarismo(7) <= '0';
			elsif num_alg = "11" then
				an3 <= '0'; 
				an2 <= '1';
				an1 <= '1';
				an0 <= '1';
				alg <= c_min_d_sw;
				algarismo(7) <= '1';
			end if;
		end if;
 end if;
end process; 
	
al : process(clk, reset)
begin
	if reset = '1' then
		algarismo(6 downto 0) <= "0000001";
	elsif clk'event and clk = '1' then
		case alg is
			when 0 => algarismo(6 downto 0) <= "0000001";
			when 1 => algarismo(6 downto 0) <= "1001111";
			when 2 => algarismo(6 downto 0) <= "0010010";
			when 3 => algarismo(6 downto 0) <= "0000110";
			when 4 => algarismo(6 downto 0) <= "1001100";
			when 5 => algarismo(6 downto 0) <= "0100100";
			when 6 => algarismo(6 downto 0) <= "0100000";
			when 7 => algarismo(6 downto 0) <= "0001111";
			when 8 => algarismo(6 downto 0) <= "0000000";
			when 9 => algarismo(6 downto 0) <= "0000100";
		   when others => algarismo(6 downto 0) <= "0111000";
		end case;
	end if;
end process; 	


end Behavioral;

