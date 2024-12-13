----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:11:19 12/29/2021 
-- Design Name: 
-- Module Name:    multiplexer_controler - Behavioral 
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


entity multiplexer_controler is
		Port(
			reset : in std_logic;
			clk : in std_logic;
			switch0 : in std_logic := '0';
			switch1 : in std_logic := '0';
			switch2 : in std_logic := '0';
			switch3 : in std_logic := '0';
			switch4 : in std_logic := '0';
			switch5 : in std_logic := '0';
			switch6 : in std_logic := '0';
			switch7 : in std_logic := '0';
			button0 : in std_logic := '0';
			button1 : in std_logic := '0';
			button2 : in std_logic := '0';
			led0 : out std_logic;
			led1 : out std_logic;
			led2 : out std_logic;
			led3 : out std_logic;
			led4 : out std_logic;
			led5 : out std_logic;
			led6 : out std_logic;
			led7 : out std_logic;
			--display output
			an3 : out std_logic;
			an2 : out std_logic;
			an1 : out std_logic;
			an0 : out std_logic;
			algarismo : out std_logic_vector(7 downto 0)
		);
end multiplexer_controler;

architecture Behavioral of multiplexer_controler is
	
	Component park_main
	Port(
		CLK : IN STD_LOGIC;
		PRES1_IN1 : IN STD_LOGIC;
		PRES2_IN1 : IN STD_LOGIC;
		TICKET_IN1 : IN STD_LOGIC;
		PRES1_OUT1 : IN STD_LOGIC;
		PRES2_OUT1 : IN STD_LOGIC;
		TICKET_OUT1 : IN STD_LOGIC;
		PRES1_OUT2 : IN STD_LOGIC;
		PRES2_OUT2 : IN STD_LOGIC;
		TICKET_OUT2 : IN STD_LOGIC;
		PRES1_IN2 : IN STD_LOGIC;
		PRES2_IN2 : IN STD_LOGIC;
		TICKET_IN2 : IN STD_LOGIC;
		AND_12A : IN STD_LOGIC;
		AND_12B : IN STD_LOGIC;
		AND_21A : IN STD_LOGIC;
		AND_21B : IN STD_LOGIC;
		AND_23A : IN STD_LOGIC;
		AND_23B : IN STD_LOGIC;
		OPEN_IN : IN STD_LOGIC;
		OPEN_OUT : IN STD_LOGIC;
		CANC_IN1 : OUT STD_LOGIC;
		CANC_OUT1 : OUT STD_LOGIC;
		CANC_OUT2 : OUT STD_LOGIC;
		CANC_IN2 : OUT STD_LOGIC;
		AVAILABLE_CAPACITY : OUT INTEGER RANGE 0 TO 150;
		OCCUPIED_CAPACITY : OUT INTEGER RANGE 0 TO 150;
		FLOOR1_OCCUPIED : OUT INTEGER RANGE 0 TO 50;
		FLOOR2_OCCUPIED : OUT INTEGER RANGE 0 TO 50;
		FLOOR3_OCCUPIED : OUT INTEGER RANGE 0 TO 50;
		CARS_ENTERED_TODAY : OUT INTEGER RANGE 0 TO 100000;
		CARS_EXITED_TODAY : OUT INTEGER RANGE 0 TO 100000;
		CARS_ENTERED_YESTERDAY : OUT INTEGER RANGE 0 TO 100000;
		CARS_EXITED_YESTERDAY : OUT INTEGER RANGE 0 TO 100000;
		ENABLE : IN STD_LOGIC;
		RESET : IN STD_LOGIC
	);
	End component park_main;
	
	Component conv_displays
	Port ( 
		CLK : IN STD_LOGIC;
		RESET : IN STD_LOGIC;
		C_B_M : IN INTEGER RANGE 0 TO 4;-- display mode 0 for normal clock, 1 for normal clock in increment mode, 2 for alarm clock, 3 for timer, 4 for stopwatch
		SWITCH_TIME_UNITS :IN STD_LOGIC;--time_unit display mode '0' for least significant time units mode, '1 for most significant'
		--normal clock variables
		C_SEG_U : IN INTEGER RANGE 0 TO 9;
		C_SEG_D : IN INTEGER RANGE 0 TO 9; 
		C_MIN_U : IN INTEGER RANGE 0 TO 9;
		C_MIN_D : IN INTEGER RANGE 0 TO 5;
		C_HOUR_U : IN INTEGER RANGE 0 TO 9;
		C_HOUR_D : IN INTEGER RANGE 0 TO 2; 
		--alarm variables
		C_MIN_U_ALARM : IN INTEGER RANGE 0 TO 9;
		C_MIN_D_ALARM : IN INTEGER RANGE 0 TO 5;
		C_HOUR_U_ALARM : IN INTEGER RANGE 0 TO 9;
		C_HOUR_D_ALARM : IN INTEGER RANGE 0 TO 2;
		--timer variables
		C_SEG_U_TIMER : IN INTEGER RANGE 0 TO 9;
		C_SEG_D_TIMER : IN INTEGER RANGE 0 TO 5;
		C_MIN_U_TIMER : IN INTEGER RANGE 0 TO 9;
		C_MIN_D_TIMER : IN INTEGER RANGE 0 TO 5;
		C_HOUR_U_TIMER : IN INTEGER RANGE 0 TO 9;
		C_HOUR_D_TIMER : IN INTEGER RANGE 0 TO 2;
		--stopwatch variables
		C_CENTSEG_U_SW : IN INTEGER RANGE 0 TO 9;
		C_CENTSEG_D_SW : IN INTEGER RANGE 0 TO 9;
		C_SEG_U_SW : IN INTEGER RANGE 0 TO 9;
		C_SEG_D_SW : IN INTEGER RANGE 0 TO 5;
		C_MIN_U_SW : IN INTEGER RANGE 0 TO 9;
		C_MIN_D_SW : IN INTEGER RANGE 0 TO 5;
		AN3 : OUT STD_LOGIC;
		AN2 : OUT STD_LOGIC;
		AN1 : OUT STD_LOGIC;
		AN0 : OUT STD_LOGIC;
		ALGARISMO : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		); 
	end Component conv_displays;
	
	Component principal
	Port ( 
		RESET : in std_logic;
		CLK : in std_logic;
		ALGARISMO : out std_logic_vector(7 downto 0);
		AN3 : out std_logic;
		AN2 : out std_logic;
		AN1 : out std_logic;
		AN0 : out std_logic;
		--button modes variables unfiltered(undebounced)
		BUTTON_M : in std_logic;-- at 1 click normal clock mode, at 2 clicks alarm clock mode, at 3 clicks timer mode, at 4 clicks stopwatch mode
		BUTTON_I_M : in std_logic; -- at 1 click mode increments least significant time at 2 clicks mode increments most significant time 
		BUTTON_I : in std_logic; -- at '1' increments
		--extra functions signals
		LED_ALARM: out std_logic;
		SWITCH_START_STOP : in std_logic; -- '0' stop/pause, '1' start
		SWITCH_PAUSE_SW : in std_logic; -- '0' continue, '1' pause
		SWITCH_TIME_UNITS :in std_logic;--time_unit display mode '0' for least significant time units mode, '1 for most significant'
		LED_TIMER : out std_logic; -- signal that timer reached 0
		SWITCH_ALARM_ACTIVE: in std_logic;
		SWITCH_TIMER_ACTIVE: in std_logic;
		--leds for mode detection
	 	LED_NORMAL_CLOCK_MODE : out std_logic;
	   LED_NORMAL_CLOCK_INC_MODE : out std_logic;
	   LED_ALARM_CLOCK_INC_MODE : out std_logic;
	   LED_TIMER_CLOCK_INC_MODE : out std_logic;
		LED_STOPWATCH_CLOCK_INC_MODE : out std_logic
		);
	end Component principal; 
	
	procedure separation (val : integer; signal unit, dozens, hundreds : out integer) is
		variable hundreds_aux, dozens_units, dozens_aux : integer;
		begin
			if (val < 100) then
				hundreds_aux := 0;
			elsif (val < 200) then
				hundreds_aux := 1;
			elsif (val < 300) then
				hundreds_aux := 2;
			elsif (val < 400) then
				hundreds_aux := 3;
			elsif (val < 500) then
				hundreds_aux := 4;
			elsif (val < 600) then
				hundreds_aux := 5;
			elsif (val < 700) then
				hundreds_aux := 6;
			elsif (val < 800) then
				hundreds_aux := 7;
			elsif (val < 900) then
				hundreds_aux := 8;
			else
				hundreds_aux := 9;
			end if;
			dozens_units := val - (hundreds_aux * 100);
			if (dozens_units < 10) then
				dozens_aux := 0;
			elsif (dozens_units < 20) then
				dozens_aux := 1;
			elsif (dozens_units < 30) then
				dozens_aux := 2;
			elsif (dozens_units < 40) then
				dozens_aux := 3;
			elsif (dozens_units < 50) then
				dozens_aux := 4;
			elsif (dozens_units < 60) then
				dozens_aux := 5;
			elsif (dozens_units < 70) then
				dozens_aux := 6;
			elsif (dozens_units < 80) then
				dozens_aux := 7;
			elsif (dozens_units < 90) then
				dozens_aux := 8;
			else
				dozens_aux := 9;
			end if;
			unit <= dozens_units - (dozens_aux * 10);
			dozens <= dozens_aux;
			hundreds <= hundreds_aux;			
		end separation;
	
signal pres1_in1, pres2_in1, ticket_in1, pres1_out1, pres2_out1, ticket_out1, pres1_out2, pres2_out2, ticket_out2, pres1_in2, pres2_in2, ticket_in2, and_12a, and_12b, and_21a, and_21b, and_23a, and_23b, open_in, open_out, canc_in1, canc_out1, canc_out2, canc_in2 : std_logic := '0';
signal available_capacity, occupied_capacity : integer range 0 to 150;
signal floor1_occupied,	floor2_occupied, floor3_occupied : integer range 0 to 50;
signal cars_entered_today, cars_exited_today, cars_entered_yesterday, cars_exited_yesterday, current_totalizer, yesterday_totalizer : integer range 0 to 100000;
signal an0_cd, an1_cd, an2_cd, an3_cd, an0_p, an1_p, an2_p, an3_p : std_logic := '0';
signal algarismo_cd, algarismo_p, algarismo_totalizer, algarismo0_clock, algarismo1_clock, algarismo2_clock, algarismo3_clock : std_logic_vector(7 downto 0);
signal algarismo0_oh, algarismo1_oh, algarismo3_oh, algarismo0_ch, algarismo1_ch, algarismo2_ch : std_logic_vector(7 downto 0);
signal algarismo2_oh : std_logic_vector(7 downto 0);
signal algarismo3_ch : std_logic_vector(7 downto 0);
signal button_m, button_i_m, button_i, led_normal_clock_mode, led_normal_clock_inc_mode, led_alarm_clock_inc_mode, led_timer_clock_inc_mode, led_stopwatch_clock_inc_mode : std_logic := '0';
signal an, unit, dozens, hundreds, level, number_disp, mode : integer := 0;
signal clock_on, entrances_closed, connected_buttons : std_logic := '0';

begin

	core : process (clk)
	begin
		if (clk'event and clk = '1') then
			if (switch0 = '0' and switch1 = '0' and switch2 = '0') then
				if (switch3 = '1') then
					pres1_in1 <= switch6;
					pres2_in1 <= switch7;
					ticket_in1 <= button1;
					pres1_in2 <= switch4;
					pres2_in2 <= switch5;
					ticket_in2 <= button0;
					separation(available_capacity, unit, dozens, hundreds);
					level <= 0;
					an <= 0;
				else
					button_m <= button2;
					button_i_m <= button1;
					button_i <= button0;
					an <= 1;
				end if;
				led0 <= '0';
				led1 <= '0';
				led2 <= '0';
			elsif (switch0 = '1' and switch1 = '0' and switch2 = '0') then
				if (switch3 = '1') then
					pres1_out1 <= switch6;
					pres2_out1 <= switch7;
					ticket_out1 <= button1;
					pres1_out2 <= switch4;
					pres2_out2 <= switch5;
					ticket_out2 <= button0;
					separation(occupied_capacity, unit, dozens, hundreds);
					level <= 0;
					an <= 0;
				else
					button_m <= button2;
					button_i_m <= button1;
					button_i <= button0;
					an <= 1;
				end if;
				led0 <= '1';
				led1 <= '0';
				led2 <= '0';
			elsif (switch0 = '0' and switch1 = '1' and switch2 = '0') then
				and_12a <= switch6;
				and_12b <= switch7;
				and_21a <= switch4;
				and_21b <= switch5;
				if (switch3 = '1') then
					separation(floor2_occupied, unit, dozens, hundreds);
					level <= 2;
					an <= 0;
				else
					separation(floor1_occupied, unit, dozens, hundreds);
					level <= 1;
					an <= 0;
				end if;
				led0 <= '0';
				led1 <= '1';
				led2 <= '0';
			elsif (switch0 = '1' and switch1 = '1' and switch2 = '0') then
				and_23a <= switch6;
				and_23b <= switch7;
				if (switch3 = '1') then
					separation(floor3_occupied, unit, dozens, hundreds);
					level <= 3;
					an <= 0;
				else
					separation(floor2_occupied, unit, dozens, hundreds);
					level <= 2;
					an <= 0;
				end if;		
				led0 <= '1';
				led1 <= '1';
				led2 <= '0';
			elsif (switch0 = '0' and switch1 = '0' and switch2 = '1') then
				--show open hour
				if (switch3 = '0' and switch5 = '0' and switch6 = '0' and switch7 = '0') then
					an <= 3;
				--show close hour
				elsif (switch3 = '1' and switch5 = '0' and switch6 = '0' and switch7 = '0') then
					an <= 2;
				--edit normal hour
				elsif (switch3 = '0' and switch5 = '1' and switch6 = '0' and switch7 = '0') then
					button_m <= button2;
					if (led_normal_clock_inc_mode = '1') then
						button_i_m <= button1;
						button_i <= button0;
					else
						button_i_m <= '0';
						button_i <= '0';
					end if;
					an <= 1;
				--edit close hour
				elsif (switch3 = '0' and switch5 = '0' and switch6 = '1' and switch7 = '0') then
					button_m <= button2;
					if (led_alarm_clock_inc_mode = '1') then
						button_i_m <= button1;
						button_i <= button0;
					else
						button_i_m <= '0';
						button_i <= '0';
					end if;
					if (an0_p = '0' and an1_p = '1' and an2_p = '1' and an3_p = '1') then
						algarismo0_ch <= algarismo_p;
					elsif (an0_p = '1' and an1_p = '0' and an2_p = '1' and an3_p = '1') then
						algarismo1_ch <= algarismo_p;
					elsif (an0_p = '1' and an1_p = '1' and an2_p = '0' and an3_p = '1') then
						algarismo2_ch <= algarismo_p;
					elsif (an0_p = '1' and an1_p = '1' and an2_p = '1' and an3_p = '0') then
						algarismo3_ch <= algarismo_p;
					end if;
					an <= 1;
				--edit open hour
				elsif (switch3 = '0' and switch4 = '0' and switch5 = '0' and switch6 = '0' and switch7 = '1') then
					button_m <= button2;
					if (led_alarm_clock_inc_mode = '1') then
						button_i_m <= button1;
						button_i <= button0;
					else
						button_i_m <= '0';
						button_i <= '0';
					end if;
					if (an0_p = '0' and an1_p = '1' and an2_p = '1' and an3_p = '1') then
						algarismo0_oh <= algarismo_p;
					elsif (an0_p = '1' and an1_p = '0' and an2_p = '1' and an3_p = '1') then
						algarismo1_oh <= algarismo_p;
					elsif (an0_p = '1' and an1_p = '1' and an2_p = '0' and an3_p = '1') then
						algarismo2_oh <= algarismo_p;
					elsif (an0_p = '1' and an1_p = '1' and an2_p = '1' and an3_p = '0') then
						algarismo3_oh <= algarismo_p;
					end if;
					an <= 1;
				end if;
				led0 <= '0';
				led1 <= '0';
				led2 <= '1';
			elsif (switch0 = '1' and switch1 = '0' and switch2 = '1') then
				if (switch3 = '0') then
					--Show current Totalizer
					if (switch4 = '1' and switch5 = '0' and switch6 = '0') then
						separation(current_totalizer, unit, dozens, hundreds);
						level <= 0;
						an <= 0;
					--Show current Exits 
					elsif (switch4 = '0' and switch5 = '1' and switch6 = '0') then
						separation(cars_exited_today, unit, dozens, hundreds);
						level <= 0;
						an <= 0;
					--Show current Entrance
					elsif (switch4 = '0' and switch5 = '0' and switch6 = '1') then
						separation(cars_entered_today, unit, dozens, hundreds);
						level <= 0;
						an <= 0;
					end if;
				else
					--Show the day before Totalizer
					if (switch4 = '1' and switch5 = '0' and switch6 = '0') then
						separation(yesterday_totalizer, unit, dozens, hundreds);
						level <= 0;
						an <= 0;
					--Show the day before Exits
					elsif (switch4 = '0' and switch5 = '1' and switch6 = '0') then
						separation(cars_exited_yesterday, unit, dozens, hundreds);
						level <= 0;
						an <= 0;
					--Show the day before Entrance
					elsif (switch4 = '0' and switch5 = '0' and switch6 = '1') then
						separation(cars_entered_yesterday, unit, dozens, hundreds);
						level <= 0;
						an <= 0;
					end if;
				end if;
				led0 <= '1';
				led1 <= '0';
				led2 <= '1';
			end if;
		end if;
	end process;
		
	update_clock : process (clk)
	begin
		if (clk'event and clk = '1') then
			if (an0_p = '0' and an1_p = '1' and an2_p = '1' and an3_p = '1') then
				algarismo0_clock <= algarismo_p;
			elsif (an0_p = '0' and an1_p = '1' and an2_p = '1' and an3_p = '1') then
				algarismo1_clock <= algarismo_p;
			elsif (an0_p = '0' and an1_p = '1' and an2_p = '1' and an3_p = '1') then
				algarismo2_clock <= algarismo_p;
			elsif (an0_p = '0' and an1_p = '1' and an2_p = '1' and an3_p = '1') then
				algarismo3_clock <= algarismo_p;
			end if;
		end if;
	end process;
	
	open_close : process (clk)
	begin
		if (clk'event and clk = '1') then
			if (algarismo0_clock = algarismo0_oh and algarismo1_clock = algarismo1_oh and algarismo2_clock = algarismo2_oh and algarismo3_clock = algarismo3_oh) then
				open_in <= '1';
				open_out <= '1';
			elsif (algarismo0_clock = algarismo0_ch and algarismo1_clock = algarismo1_ch and algarismo2_clock = algarismo2_ch and algarismo3_clock = algarismo3_ch) then
				open_in <= '0';
				entrances_closed <= '1';
			elsif (algarismo0_clock = algarismo0_ch and algarismo2_clock = algarismo2_ch and algarismo3_clock = algarismo3_ch and entrances_closed = '1') then
				open_out <= '0';
				entrances_closed <= '0';
			end if;
		end if;
	end process;
	
	save_totalizer : process (clk)
	begin
		if (clk'event and clk = '1') then
			if (an0_p = '0' and an1_p = '1' and an2_p = '1' and an3_p = '1' and algarismo_totalizer /= algarismo_p) then
				algarismo_totalizer <= algarismo_p;
				current_totalizer <= current_totalizer + occupied_capacity;
			end if;
		end if;
	end process;
	
	display : process (clk)
	begin
		if (clk'event and clk = '1') then
			if (an = 0) then
				an0 <= an0_cd;
				an1 <= an1_cd;
				an2 <= an2_cd;
				an3 <= an3_cd;
				algarismo <= algarismo_cd;
			elsif (an = 1) then
				an0 <= an0_p;
				an1 <= an1_p;
				an2 <= an2_p;
				an3 <= an3_p;
				algarismo <= algarismo_p;
			elsif (an = 2) then
				if (number_disp = 0) then
					an0 <= '0';
					an1 <= '1';
					an2 <= '1';
					an3 <= '1';
					algarismo <= algarismo0_ch;
					number_disp <= 1;
				elsif (number_disp = 1) then
					an0 <= '1';
					an1 <= '0';
					an2 <= '1';
					an3 <= '1';
					algarismo <= algarismo1_ch;
					number_disp <= 2;
				elsif (number_disp = 2) then
					an0 <= '1';
					an1 <= '1';
					an2 <= '0';
					an3 <= '1';
					algarismo <= algarismo2_ch;
					number_disp <= 3;
				elsif (number_disp = 3) then
					an0 <= '1';
					an1 <= '1';
					an2 <= '1';
					an3 <= '0';
					algarismo <= algarismo3_ch;
					number_disp <= 0;
				end if;
			elsif (an = 3) then
				if (number_disp = 0) then
					an0 <= '0';
					an1 <= '1';
					an2 <= '1';
					an3 <= '1';
					algarismo <= algarismo0_oh;
					number_disp <= 1;
				elsif (number_disp = 1) then
					an0 <= '1';
					an1 <= '0';
					an2 <= '1';
					an3 <= '1';
					algarismo <= algarismo1_oh;
					number_disp <= 2;
				elsif (number_disp = 2) then
					an0 <= '1';
					an1 <= '1';
					an2 <= '0';
					an3 <= '1';
					algarismo <= algarismo2_oh;
					number_disp <= 3;
				elsif (number_disp = 3) then
					an0 <= '1';
					an1 <= '1';
					an2 <= '1';
					an3 <= '0';
					algarismo <= algarismo3_oh;
					number_disp <= 0;
				end if;
			end if;
		end if;
	end process;
	
	cancel_leds : process (clk)
	begin
		if (clk'event and clk = '1') then
			if (switch3 = '1') then
				led7 <= canc_in1;
			elsif (switch3 = '0') then
				led7 <= led_stopwatch_clock_inc_mode;
			end if;
			if (switch3 = '1') then
				led6 <= canc_in2;
			elsif (switch3 = '0') then
				led6 <= led_timer_clock_inc_mode;
			end if;
			if (switch3 = '1') then
				led5 <= canc_out1;
			elsif (switch3 = '0') then
				led5 <= led_alarm_clock_inc_mode;
			end if;
			if (switch3 = '1') then
				led4 <= canc_out2;
			elsif (switch3 = '0') then
				led4 <= led_normal_clock_inc_mode;
			end if;
			if (switch3 = '0') then
				led3 <= led_normal_clock_mode;
			else
				led3 <= '0';
			end if;
		end if;
	end process;

	pm : park_main
	Port map(
		CLK => clk,
		ENABLE => '1',
		RESET => reset,
		PRES1_IN1 => pres1_in1,
		PRES2_IN1 => pres2_in1,
		TICKET_IN1 => ticket_in1,
		PRES1_OUT1 => pres1_out1,
		PRES2_OUT1 => pres2_out1,
		TICKET_OUT1 => ticket_out1,
		PRES1_OUT2 => pres1_out2,
		PRES2_OUT2 => pres2_out2,
		TICKET_OUT2 => ticket_out2,
		PRES1_IN2 => pres1_in2,
		PRES2_IN2 => pres2_in2,
		TICKET_IN2 => ticket_in2,
		AND_12A => and_12a,
		AND_12B => and_12b,
		AND_21A => and_21a,
		AND_21B => and_21b,
		AND_23A => and_23a,
		AND_23B => and_23b,
		OPEN_IN => open_in,
		OPEN_OUT => open_out,
		CANC_IN1 => canc_in1,
		CANC_OUT1 => canc_out1,
		CANC_OUT2 => canc_out2,
		CANC_IN2 => canc_in2,
		AVAILABLE_CAPACITY => available_capacity,
		OCCUPIED_CAPACITY => occupied_capacity,
		FLOOR1_OCCUPIED => floor1_occupied,
		FLOOR2_OCCUPIED => floor2_occupied,
		FLOOR3_OCCUPIED => floor3_occupied,
		CARS_ENTERED_TODAY => cars_entered_today,
		CARS_EXITED_TODAY => cars_exited_today,
		CARS_ENTERED_YESTERDAY => cars_entered_yesterday,
		CARS_EXITED_YESTERDAY => cars_exited_yesterday
	);

	cd_cp : conv_displays
	port map(
		RESET => reset,
		CLK => clk,
		C_B_M => 0,--display mode here
		SWITCH_TIME_UNITS => '0',--time unit display modes
		C_SEG_U => unit,
		C_SEG_D => dozens,
		C_MIN_U => hundreds,
		C_MIN_D => level,
		C_HOUR_U => 0,
		C_HOUR_D => 0,
		C_MIN_U_ALARM => 0,
		C_MIN_D_ALARM => 0,
		C_HOUR_U_ALARM => 0,
		c_hour_d_alarm => 0,
		C_SEG_U_TIMER => 0,
		C_SEG_D_TIMER => 0,
		C_MIN_U_TIMER => 0,
		C_MIN_D_TIMER => 0,
		C_HOUR_U_TIMER => 0,
		C_HOUR_D_TIMER => 0,
		C_CENTSEG_U_SW => 0,
		C_CENTSEG_D_SW => 0,
		C_SEG_U_SW => 0,
		C_SEG_D_SW => 0,
		C_MIN_U_SW => 0,
		C_MIN_D_SW => 0,		 
		ALGARISMO => algarismo_cd,
		AN3 => an3_cd,
		AN2 => an2_cd,
		AN1 => an1_cd,
		AN0 => an0_cd
	);
		
	p : principal
	Port map( 
		RESET => reset,
		CLK => clk,
		ALGARISMO => algarismo_p,
		AN3 => an3_p,
		AN2 => an2_p,
		AN1 => an1_p,
		AN0 => an0_p,
		--button modes variables unfiltered(undebounced)
		BUTTON_M => button_m,
		BUTTON_I_M => button_i_m,
		BUTTON_I => button_i,
		--extra functions signals
		LED_ALARM => open,
		SWITCH_START_STOP => '0',
		SWITCH_PAUSE_SW => '0',
		SWITCH_TIME_UNITS => '1',
		LED_TIMER => open,
		SWITCH_ALARM_ACTIVE => '0',
		SWITCH_TIMER_ACTIVE => '0',
		--leds for mode detection
	 	LED_NORMAL_CLOCK_MODE => led_normal_clock_mode,
	   LED_NORMAL_CLOCK_INC_MODE => led_normal_clock_inc_mode,
	   LED_ALARM_CLOCK_INC_MODE => led_alarm_clock_inc_mode,
	   LED_TIMER_CLOCK_INC_MODE => led_timer_clock_inc_mode,
		LED_STOPWATCH_CLOCK_INC_MODE => led_stopwatch_clock_inc_mode
	); 

end Behavioral;