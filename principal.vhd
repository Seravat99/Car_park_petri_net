----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:27:17 11/03/2021 
-- Design Name: 
-- Module Name:    principal - Behavioral 
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

entity principal is
	Port ( reset : in std_logic;
		clk : in std_logic;
		algarismo : out std_logic_vector(7 downto 0);
		an3 : out std_logic;
		an2 : out std_logic;
		an1 : out std_logic;
		an0 : out std_logic;
		--button modes variables unfiltered(undebounced)
		button_m : in std_logic;-- at 1 click normal clock mode, at 2 clicks alarm clock mode, at 3 clicks timer mode, at 4 clicks stopwatch mode
		button_i_m : in std_logic; -- at 1 click mode increments least significant time at 2 clicks mode increments most significant time 
		button_i : in std_logic; -- at '1' increments
		--extra functions signals
		led_alarm: out std_logic;
		switch_start_stop : in std_logic; -- '0' stop/pause, '1' start
		switch_pause_sw : in std_logic; -- '0' continue, '1' pause
		switch_time_units :in std_logic;--time_unit display mode '0' for least significant time units mode, '1 for most significant'
		led_timer : out std_logic; -- signal that timer reached 0
		switch_alarm_active: in std_logic;
		switch_timer_active: in std_logic;
		--leds for mode detection
	 	led_normal_clock_mode : out std_logic;
	   led_normal_clock_inc_mode : out std_logic;
	   led_alarm_clock_inc_mode : out std_logic;
	   led_timer_clock_inc_mode : out std_logic;
		led_stopwatch_clock_inc_mode : out std_logic
		);
end principal; 

architecture Behavioral of principal is
	COMPONENT button_delaying
		Port ( reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           b_i: in  STD_LOGIC;
           b_m : in  STD_LOGIC;
           b_i_m : in  STD_LOGIC;
			  b_i_d: out  STD_LOGIC;
           b_m_d : out  STD_LOGIC;
           b_i_m_d : out  STD_LOGIC		  
 ); 
 END COMPONENT;

	COMPONENT controler
		PORT(
			reset : in  STD_LOGIC;
         clk : in  STD_LOGIC;
         b_i: in  STD_LOGIC;
         b_m : in  STD_LOGIC;
         b_i_m : in  STD_LOGIC;
			switch_timeunits : in  STD_LOGIC; 
         switch_alarm_active : in  STD_LOGIC;
         switch_timer_active : in  STD_LOGIC;
         switch_starter_stop : in  STD_LOGIC;
         switch_pause_sw : in  STD_LOGIC;
			b_i_out : out  STD_LOGIC := '0';
         b_m_out : out  STD_LOGIC_VECTOR (5 downto 0);
         b_i_m_out : out  STD_LOGIC_VECTOR (1 downto 0);
         switch_alarm_active_out : out  STD_LOGIC := '0';
         switch_timer_active_out : out  STD_LOGIC := '0';
         switch_starter_stop_out : out  STD_LOGIC := '0';
         switch_pause_sw_out : out  STD_LOGIC := '0';
			switch_timeunits_out : out  STD_LOGIC := '0'
 ); 
 END COMPONENT;

	COMPONENT relogio
		PORT(
		   clk : in std_logic;
			reset : in std_logic;
			--normal clock variables
			c_seg_u : out integer range 0 to 9;
			c_seg_d : out integer range 0 to 5; 
		   c_min_u : out integer range 0 to 9;
			c_min_d : out integer range 0 to 5;
			c_hour_u : out integer range 0 to 9;
			c_hour_d : out integer range 0 to 2; 
			--alarm variables
			c_min_u_alarm : out integer range 0 to 9;
			c_min_d_alarm : out integer range 0 to 5;
			c_hour_u_alarm : out integer range 0 to 9;
			c_hour_d_alarm : out integer range 0 to 2;
			--timer variables
			c_seg_u_timer : out integer range 0 to 9;
			c_seg_d_timer : out integer range 0 to 5;
			c_min_u_timer : out integer range 0 to 9;
			c_min_d_timer : out integer range 0 to 5;	
			c_hour_u_timer : out integer range 0 to 9;
			c_hour_d_timer : out integer range 0 to 2;
			--stopwatch variables
			c_centseg_u_sw : out integer range 0 to 9;
			c_centseg_d_sw : out integer range 0 to 9;
			c_seg_u_sw : out integer range 0 to 9;
			c_seg_d_sw : out integer range 0 to 5;
			c_min_u_sw : out integer range 0 to 9;
			c_min_d_sw : out integer range 0 to 5;
			--button modes variables
			button_m : in std_logic_vector(5 downto 0);-- at 1 click normal clock mode, at 2 clicks alarm clock mode, at 3 clicks timer mode, at 4 clicks stopwatch mode
			button_i_m : in std_logic_vector(1 downto 0); -- at 1 click mode increments least significant time at 2 clicks mode increments most significant time 
			button_i : in std_logic; -- at '1' increments
			--switch at 1 most significant time units, switch a 0 least significant units, in this block it will be used to choose what to increment
			switch_time_units : in std_logic;
			-- extra input or output signals
			r_alarm: out std_logic;
			switch_start_stop : in std_logic; -- '0' stop/pause, '1' start
			switch_pause_sw : in std_logic; -- '0' continue, '1' pause
			r_timer_ended : out std_logic; -- signal that timer reached 0
			switch_alarm_active : in std_logic;
			switch_timer_active : in std_logic;
			c_b_m : out integer range 0 to 4;
			--leds for mode detection
			led_normal_clock_mode : out std_logic := '0';
			led_normal_clock_inc_mode : out std_logic := '0';
			led_alarm_clock_inc_mode : out std_logic := '0';
			led_timer_clock_inc_mode : out std_logic := '0';
			led_stopwatch_clock_inc_mode : out std_logic := '0'
 ); 
 END COMPONENT;
 
 COMPONENT conv_displays
	PORT(
		 clk : IN std_logic;
		 reset : IN std_logic;
		 -- display mode in this case
		 c_b_m : IN integer range 0 to 4;--at 1 click normal clock mode, at 2 clicks alarm clock mode, at 3 clicks timer mode, at 4 clicks stopwatch mode
		 switch_time_units :in std_logic;--time_unit display mode '0' for least significant time units mode, '1 for most significant'
		 -- normal clock variables
		 c_seg_u : IN integer range 0 to 9;
		 c_seg_d : IN integer range 0 to 9;
		 c_min_u : IN integer range 0 to 9;
		 c_min_d : IN integer range 0 to 5;
		 c_hour_u : IN integer range 0 to 9;
		 c_hour_d : IN integer range 0 to 3;
		 --alarm variables
		 c_min_u_alarm : IN integer range 0 to 9;
		 c_min_d_alarm : IN integer range 0 to 5;
		 c_hour_u_alarm : IN integer range 0 to 9;
		 c_hour_d_alarm : IN integer range 0 to 2;
		 --timer variables
		 c_seg_u_timer : IN integer range 0 to 9;
		 c_seg_d_timer : IN integer range 0 to 5;
		 c_min_u_timer : IN integer range 0 to 9;
		 c_min_d_timer : IN integer range 0 to 5;
		 c_hour_u_timer : IN integer range 0 to 9;
		 c_hour_d_timer : IN integer range 0 to 2;
		 --stopwatch variables
		 c_centseg_u_sw : IN integer range 0 to 9;
		 c_centseg_d_sw : IN integer range 0 to 9;
		 c_seg_u_sw : IN integer range 0 to 9;
		 c_seg_d_sw : IN integer range 0 to 5;
		 c_min_u_sw : IN integer range 0 to 9;
		 c_min_d_sw : IN integer range 0 to 5;
		 --display output
		 an3 : OUT std_logic;
		 an2 : OUT std_logic;
		 an1 : OUT std_logic;
		 an0 : OUT std_logic;
		 algarismo : OUT std_logic_vector(7 downto 0)
 );
 END COMPONENT;


--interconect signals
signal c_seg_d_aux, c_seg_u_aux, c_min_u_aux, c_hour_u_aux, c_min_u_alarm_aux,c_hour_u_alarm_aux,c_hour_u_timer_aux,c_min_u_timer_aux,c_seg_u_timer_aux,c_centseg_u_sw_aux,c_centseg_d_sw_aux,c_seg_u_sw_aux,c_min_u_sw_aux : integer range 0 to 9;
signal c_min_d_aux,c_min_d_alarm_aux,c_min_d_timer_aux,c_seg_d_timer_aux,c_seg_d_sw_aux,c_min_d_sw_aux: integer range 0 to 5; 
signal c_hour_d_aux,c_hour_d_alarm_aux, c_hour_d_timer_aux : integer range 0 to 2; 
signal cont_b_m_aux : integer range 0 to 4;
signal b_i_aux,switch_alarm_active_aux,switch_timer_active_aux,switch_starter_stop_aux,switch_pause_sw_aux,switch_timeunits_aux:std_logic := '0';
signal b_m_aux : std_logic_vector(5 downto 0) := (others => '0');
signal b_i_m_aux : std_logic_vector(1 downto 0) := (others => '0');
signal b_i_d_aux, b_m_d_aux, b_i_m_d_aux : std_logic := '0'; 
         
begin

 bd : button_delaying
 port map(reset => reset,
			clk => clk,
         b_i => button_i,
         b_m => button_m,
         b_i_m => button_i_m,
			b_i_d => b_i_d_aux,
         b_m_d => b_m_d_aux,
         b_i_m_d => b_i_m_d_aux
			);

 c : controler
 port map(reset => reset,
			clk => clk,
         b_i => b_i_d_aux,
         b_m => b_m_d_aux,
         b_i_m => b_i_m_d_aux,
			switch_timeunits => switch_time_units, 
         switch_alarm_active => switch_alarm_active,
         switch_timer_active => switch_timer_active,
         switch_starter_stop => switch_start_stop,
         switch_pause_sw => switch_pause_sw,
			b_i_out => b_i_aux,
         b_m_out => b_m_aux,
         b_i_m_out => b_i_m_aux,
         switch_alarm_active_out => switch_alarm_active_aux,
         switch_timer_active_out => switch_timer_active_aux,
         switch_starter_stop_out => switch_starter_stop_aux,
         switch_pause_sw_out => switch_pause_sw_aux,
			switch_timeunits_out => switch_timeunits_aux 
			);
 r : relogio
 port map(reset => reset,
		 clk => clk,
		 c_seg_u => c_seg_u_aux,
		 c_seg_d => c_seg_d_aux,
		 c_min_u => c_min_u_aux,
		 c_min_d => c_min_d_aux,
		 c_hour_u => c_hour_u_aux,
		 c_hour_d => c_hour_d_aux,	
		 c_min_u_alarm => c_min_u_alarm_aux,
		 c_min_d_alarm => c_min_d_alarm_aux,
	    c_hour_u_alarm => c_hour_u_alarm_aux,
		 c_hour_d_alarm => c_hour_d_alarm_aux,
		 c_seg_u_timer => c_seg_u_timer_aux,
		 c_seg_d_timer => c_seg_d_timer_aux,
		 c_min_u_timer => c_min_u_timer_aux,
		 c_min_d_timer => c_min_d_timer_aux,
		 c_hour_u_timer => c_hour_u_timer_aux,
		 c_hour_d_timer => c_hour_d_timer_aux,
		 c_centseg_u_sw => c_centseg_u_sw_aux,
		 c_centseg_d_sw => c_centseg_d_sw_aux,
		 c_seg_u_sw => c_seg_u_sw_aux,
		 c_seg_d_sw => c_seg_d_sw_aux,
		 c_min_u_sw => c_min_u_sw_aux,
		 c_min_d_sw => c_min_d_sw_aux,
		 button_m => b_m_aux,
		 button_i => b_i_aux,
		 button_i_m => b_i_m_aux,
		 switch_time_units => switch_timeunits_aux,
		 switch_start_stop => switch_starter_stop_aux,
		 switch_pause_sw => switch_pause_sw_aux,
		 r_timer_ended => led_timer,
		 r_alarm => led_alarm,
		 switch_alarm_active => switch_alarm_active_aux,
		 switch_timer_active => switch_timer_active_aux,
		 c_b_m => cont_b_m_aux,
		 led_normal_clock_mode => led_normal_clock_mode,
		 led_normal_clock_inc_mode => led_normal_clock_inc_mode,
		 led_alarm_clock_inc_mode => led_alarm_clock_inc_mode,
		 led_timer_clock_inc_mode => led_timer_clock_inc_mode,
		 led_stopwatch_clock_inc_mode => led_stopwatch_clock_inc_mode
		 );
		 
 cd : conv_displays
 port map(reset => reset,
		 clk => clk,
		 c_b_m => cont_b_m_aux,--display mode here
		 switch_time_units => switch_timeunits_aux,--time unit display modes
		 c_seg_u => c_seg_u_aux,
		 c_seg_d => c_seg_d_aux,
		 c_min_u => c_min_u_aux,
		 c_min_d => c_min_d_aux,
		 c_hour_u => c_hour_u_aux,
		 c_hour_d => c_hour_d_aux,
		 c_min_u_alarm => c_min_u_alarm_aux,
		 c_min_d_alarm => c_min_d_alarm_aux,
	    c_hour_u_alarm => c_hour_u_alarm_aux,
		 c_hour_d_alarm => c_hour_d_alarm_aux,
		 c_seg_u_timer => c_seg_u_timer_aux,
		 c_seg_d_timer => c_seg_d_timer_aux,
		 c_min_u_timer => c_min_u_timer_aux,
		 c_min_d_timer => c_min_d_timer_aux,
		 c_hour_u_timer => c_hour_u_timer_aux,
		 c_hour_d_timer => c_hour_d_timer_aux,
		 c_centseg_u_sw => c_centseg_u_sw_aux,
		 c_centseg_d_sw => c_centseg_d_sw_aux,
		 c_seg_u_sw => c_seg_u_sw_aux,
		 c_seg_d_sw => c_seg_d_sw_aux,
		 c_min_u_sw => c_min_u_sw_aux,
		 c_min_d_sw => c_min_d_sw_aux,		 
		 algarismo => algarismo,
		 an3 => an3,
		 an2 => an2,
		 an1 => an1,
		 an0 => an0
		 );
 
end Behavioral;

