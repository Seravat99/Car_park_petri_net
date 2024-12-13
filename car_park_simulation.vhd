--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:34:06 12/29/2021
-- Design Name:   
-- Module Name:   /home/sl/car_park/car_park_simulation.vhd
-- Project Name:  car_park
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: car_park
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY car_park_simulation IS
END car_park_simulation;
 
ARCHITECTURE behavior OF car_park_simulation IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT car_park
    PORT(
         reset : IN  std_logic;
         clk : IN  std_logic;
         switch0 : IN  std_logic;
         switch1 : IN  std_logic;
         switch2 : IN  std_logic;
         switch3 : IN  std_logic;
         switch4 : IN  std_logic;
         switch5 : IN  std_logic;
         switch6 : IN  std_logic;
         switch7 : IN  std_logic;
         button0 : IN  std_logic;
         button1 : IN  std_logic;
         led0 : OUT  std_logic;
         led1 : OUT  std_logic;
         led2 : OUT  std_logic;
         led3 : OUT  std_logic;
         led4 : OUT  std_logic;
         led5 : OUT  std_logic;
         led6 : OUT  std_logic;
         led7 : OUT  std_logic;
         an3 : OUT  std_logic;
         an2 : OUT  std_logic;
         an1 : OUT  std_logic;
         an0 : OUT  std_logic;
         algarismo : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal switch0 : std_logic := '0';
   signal switch1 : std_logic := '0';
   signal switch2 : std_logic := '0';
   signal switch3 : std_logic := '0';
   signal switch4 : std_logic := '0';
   signal switch5 : std_logic := '0';
   signal switch6 : std_logic := '0';
   signal switch7 : std_logic := '0';
   signal button0 : std_logic := '0';
   signal button1 : std_logic := '0';

 	--Outputs
   signal led0 : std_logic;
   signal led1 : std_logic;
   signal led2 : std_logic;
   signal led3 : std_logic;
   signal led4 : std_logic;
   signal led5 : std_logic;
   signal led6 : std_logic;
   signal led7 : std_logic;
   signal an3 : std_logic;
   signal an2 : std_logic;
   signal an1 : std_logic;
   signal an0 : std_logic;
   signal algarismo : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: car_park PORT MAP (
          reset => reset,
          clk => clk,
          switch0 => switch0,
          switch1 => switch1,
          switch2 => switch2,
          switch3 => switch3,
          switch4 => switch4,
          switch5 => switch5,
          switch6 => switch6,
          switch7 => switch7,
          button0 => button0,
          button1 => button1,
          led0 => led0,
          led1 => led1,
          led2 => led2,
          led3 => led3,
          led4 => led4,
          led5 => led5,
          led6 => led6,
          led7 => led7,
          an3 => an3,
          an2 => an2,
          an1 => an1,
          an0 => an0,
          algarismo => algarismo
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
