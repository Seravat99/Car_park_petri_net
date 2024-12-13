----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:11:19 12/29/2021 
-- Design Name: 
-- Module Name:    car_park - Behavioral 
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

entity car_park is
	Port(
		reset : IN std_logic;
		clk : IN std_logic;
		switch0 : IN std_logic;
		switch1 : IN std_logic;
		switch2 : IN std_logic;
		switch3 : IN STD_LOGIC;
      switch4 : IN STD_LOGIC;
		switch5 : IN STD_LOGIC;
		switch6 : IN STD_LOGIC;
		switch7 : IN STD_LOGIC;
      button0 : IN STD_LOGIC;
		button1 : IN STD_LOGIC;
		button2 : IN STD_LOGIC;
      led0 : OUT STD_LOGIC;
		led1 : OUT STD_LOGIC;
		led2 : OUT STD_LOGIC;
		led3 : OUT STD_LOGIC;
		led4 : OUT STD_LOGIC;
		led5 : OUT STD_LOGIC;
		led6 : OUT STD_LOGIC;
		led7 : OUT STD_LOGIC;
		--display output
		an3 : OUT std_logic;
		an2 : OUT std_logic;
		an1 : OUT std_logic;
		an0 : OUT std_logic;
		algarismo : OUT std_logic_vector(7 downto 0)
	);
end car_park;

architecture Behavioral of car_park is

	Component multiplexer_controler
		Port(
			RESET : IN STD_LOGIC;
			CLK : IN STD_LOGIC;
			SWITCH0 : IN STD_LOGIC := '0';
			SWITCH1 : IN STD_LOGIC := '0';
			SWITCH2 : IN STD_LOGIC := '0';
			SWITCH3 : IN STD_LOGIC := '0';
			SWITCH4 : IN STD_LOGIC := '0';
			SWITCH5 : IN STD_LOGIC := '0';
			SWITCH6 : IN STD_LOGIC := '0';
			SWITCH7 : IN STD_LOGIC := '0';
			BUTTON0 : IN STD_LOGIC := '0';
			BUTTON1 : IN STD_LOGIC := '0';
			BUTTON2 : IN STD_LOGIC := '0';
			LED0 : OUT STD_LOGIC;
			LED1 : OUT STD_LOGIC;
			LED2 : OUT STD_LOGIC;
			LED3 : OUT STD_LOGIC;
			LED4 : OUT STD_LOGIC;
			LED5 : OUT STD_LOGIC;
			LED6 : OUT STD_LOGIC;
			LED7 : OUT STD_LOGIC;
			--DISPLAY OUTPUT
			AN3 : OUT STD_LOGIC;
			AN2 : OUT STD_LOGIC;
			AN1 : OUT STD_LOGIC;
			AN0 : OUT STD_LOGIC;
			ALGARISMO : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	End Component;

begin
	mp : multiplexer_controler
	port map(
		RESET => reset,
		CLK => clk,
		SWITCH0 => switch0,
		SWITCH1 => switch1,
		SWITCH2 => switch2,
		SWITCH3 => switch3,
		SWITCH4 => switch4,
		SWITCH5 => switch5,
		SWITCH6 => switch6,
		SWITCH7 => switch7,
		BUTTON0 => button0,
		BUTTON1 => button1,
		BUTTON2 => button2,
		LED0 => led0,
		LED1 => led1,
		LED2 => led2,
		LED3 => led3,
		LED4 => led4,
		LED5 => led5,
		LED6 => led6,
		LED7 => led7,
		--DISPLAY OUTPUT
		AN3 => an3,
		AN2 => an2,
		AN1 => an1,
		AN0 => an0,
		ALGARISMO => algarismo
	);
end Behavioral;