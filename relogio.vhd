----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:06:32 10/27/2021 
-- Design Name: 
-- Module Name:    relogio - Behavioral 
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


entity relogio is
 Port ( clk : in std_logic;
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
 button_m : in std_logic_vector(5 downto 0);-- at 1 click normal clock mode, at 2 clicks alarm clock mode, at 3 clicks timer mode
 button_i_m : in std_logic_vector(1 downto 0); -- at 1 click mode increments minutes at 2 clicks mode increments hours -- maybe add decrement
 button_i : in std_logic; -- at '1' increments
 --switch at 1 most significant time units, switch a 0 least significant units, in this block it will be used to choose what to increment
 switch_time_units : in std_logic;
 -- extra input or output signals
 r_alarm: out std_logic;
 switch_start_stop : in std_logic; -- '0' stop/pause, '1' start
 switch_pause_sw : in std_logic; -- '0' continue, '1' pause
 r_timer_ended : out std_logic;-- signal that timer reached 0
 c_b_m : out integer range 0 to 4;
 switch_alarm_active : in std_logic;
 switch_timer_active : in std_logic;
 --leds for mode check
 led_normal_clock_mode : out std_logic;
 led_normal_clock_inc_mode : out std_logic;
 led_alarm_clock_inc_mode : out std_logic;
 led_timer_clock_inc_mode : out std_logic;
 led_stopwatch_clock_inc_mode : out std_logic
 ); 
end relogio;

architecture Behavioral of relogio is
--for normal clock
signal clock_active : std_logic := '0'; --used to start the normal clock
signal c_clock_active: integer range 0 to 1 := 0; --used as a complementary for the start of the normal clock
signal cont_subseg : integer range 0 to 50000000;
signal cont_seg_u, cont_min_u : integer range 0 to 9;
signal cont_seg_d, cont_min_d : integer range 0 to 5;
signal cont_hour_u : integer range 0 to 9;
signal cont_hour_d : integer range 0 to 2;
signal seg_u, seg_d, min_u, min_d, hour_u, hour_d : std_logic;
--for alarm
signal cont_min_u_alarm, cont_hour_u_alarm: integer range 0 to 9;
signal cont_min_d_alarm : integer range 0 to 5;
signal cont_hour_d_alarm : integer range 0 to 2;
signal min_d_alarm,hour_d_alarm :std_logic;
--for timer
signal seg_d_timer,min_u_timer,min_d_timer, hour_u_timer, hour_d_timer: std_logic;
signal cont_min_u_timer : integer range 0 to 9;
signal cont_min_d_timer : integer range 0 to 5;
signal cont_seg_u_timer : integer range 0 to 9;
signal cont_seg_d_timer : integer range 0 to 5;
signal cont_hour_u_timer : integer range 0 to 9;
signal cont_hour_d_timer: integer range 0 to 2;
-- for buttons (controling modes)
signal cont_b_m : integer range 0 to 4; -- 0 for no mode, just normal clock, 1 - normal clock mode for increment, 2 - alarm clock, 3 - timer, 4 - cronometer  
signal cont_b_i_m : integer range 0 to 2;-- 1 for minutes 2 for hours
--for stopwatch
signal cont_centseg_u_sw, cont_centseg_d_sw : integer range 0 to 9;
signal cont_seg_u_sw, cont_min_u_sw: integer range 0 to 9;
signal cont_seg_d_sw, cont_min_d_sw : integer range 0 to 5;
signal centseg_u_sw, centseg_d_sw, seg_u_sw, seg_d_sw, min_u_sw, min_d_sw : std_logic;
signal cont_subcentseg : integer range 0 to 50000000;

begin

--Process button delaying process
process (clk, reset)
	begin
		if ( reset = '1') then
			c_clock_active <= 0;
      elsif ( clk'event and clk = '1') then
			if(button_m = "0000010") then
				c_clock_active <= 1; -- in this case we'll use the button increment to start the clock since it will only be used once
			end if;	
      end if;
end process;

clock_active <= '1' when c_clock_active = 1 else '0';
	
--Process code for subseg 
process (clk, reset)
	begin
		if ( reset = '1') then
			cont_subseg <= 0;
      elsif ( clk'event and clk = '1') then
			if(clock_active = '1') then
				if ( cont_subseg = 49999999) then
					cont_subseg <= 0;
				else
					cont_subseg <= cont_subseg + 1;								
				end if;  
			end if;
      end if;
end process;

seg_u <= '1' when cont_subseg = 49999999 else '0';

--Process code for seg_u
process (clk, reset)
	begin
		if ( reset = '1') then
			cont_seg_u <= 0;
      elsif ( clk'event and clk = '1') then
         if ( seg_u = '1' ) then
				if ( cont_seg_u = 9 ) then
					cont_seg_u <= 0;
				else
					cont_seg_u <= cont_seg_u + 1;								
				end if; 
			 end if;
      end if;
end process;

seg_d <= '1' when cont_seg_u = 9 and seg_u = '1' else '0';
c_seg_u <= cont_seg_u; 

--Process code for seg_d
process (clk, reset)
	begin
		if ( reset = '1') then
			cont_seg_d <= 0;
      elsif ( clk'event and clk = '1') then
			if ( seg_d = '1' ) then
				if ( cont_seg_d = 5 ) then
					cont_seg_d <= 0;
				else
					cont_seg_d <= cont_seg_d + 1;								
				end if;  
			end if;	
      end if;
end process;

c_seg_d <= cont_seg_d; 

--Process code for min_u
process (clk, reset)
	begin
		if ( reset = '1') then
			cont_min_u <= 0;
      elsif ( clk'event and clk = '1') then
			if ( min_u = '1' ) then
				if ( cont_min_u = 9 ) then
					cont_min_u <= 0;
				else
					cont_min_u <= cont_min_u + 1;								
				end if;  
			end if;	
      end if;
end process;

min_d <= '1' when cont_min_u = 9 and min_u = '1' else '0';
c_min_u <= cont_min_u; 

--Process code for min_d
process (clk, reset)
	begin
		if ( reset = '1') then
			cont_min_d <= 0;
      elsif ( clk'event and clk = '1') then
			if ( min_d = '1' ) then
				if ( cont_min_d = 5 ) then
					cont_min_d <= 0;
				else
					cont_min_d <= cont_min_d + 1;								
				end if;  
			end if; 	
      end if;
end process;

c_min_d <= cont_min_d; 

--Process code for hour_u
process (clk, reset)
	begin
		if ( reset = '1') then
			cont_hour_u <= 0;
      elsif ( clk'event and clk = '1') then
			if ( hour_u = '1' ) then
				if ( cont_hour_u = 9 ) then	
					cont_hour_u <= 0;
				elsif( cont_hour_u = 3 and cont_hour_d = 2 )	then
					cont_hour_u <= 0;
				else
					cont_hour_u <= cont_hour_u + 1;								
				end if;  
			end if;
      end if;
end process;
c_hour_u <= cont_hour_u; 
hour_d <= '1' when ( cont_hour_u = 9 or ( cont_hour_u = 3 and cont_hour_d = 2) ) and hour_u = '1' else '0';

--Process code for hour_d
process (clk, reset)
	begin
		if ( reset = '1') then
			cont_hour_d <= 0;
      elsif ( clk'event and clk = '1') then
			if ( hour_d = '1' ) then
				if ( cont_hour_u = 3  and cont_hour_d = 2 ) then
					cont_hour_d <= 0;
				else
					cont_hour_d <= cont_hour_d + 1;								
				end if;  
			 end if;
      end if;
end process;

c_hour_d <= cont_hour_d; 

--Processo para os botoes de modo horas relogio cont_b_m = 1 ou horas alarme cont_b_m = 2  ou temporizador cont_b_m = 3 ou cronometro cont_b_m = 4
process(clk, reset)
	begin
		if(reset = '1') then
			cont_b_m <= 0;
		elsif ( clk'event and clk = '1') then
			if( button_m(1) = '1') then
				cont_b_m <= 0;
			elsif(button_m(2) = '1') then
				cont_b_m <= 1;
			elsif(button_m(3) = '1') then
				cont_b_m <= 2;
			elsif(button_m(4) = '1') then
				cont_b_m <= 3;
			elsif(button_m(5) = '1') then
				cont_b_m <= 4;
			else
				cont_b_m <= 0;
			end if;	
		end if;
end process;

--Processo para os botoes de modo incremento minutos cont_b_i_m = 1 ou horas cont_b_i_m = 2 
process(clk, reset,button_i_m)
	begin
		if(reset = '1' ) then
			cont_b_i_m <= 0;		
		elsif ( clk'event and clk = '1') then
			if(cont_b_m /= 0) then -- if the button mode is not at 0
				if( button_i_m = "00" ) then
					cont_b_i_m <= 0;
				elsif( button_i_m = "01" ) then
					cont_b_i_m <= 1;
				elsif( button_i_m = "10" ) then
					cont_b_i_m <= 2;
				else
					cont_b_i_m <= 0;
				end if;
			end if;
		end if;
end process;

min_u <= '1' when ( cont_b_m = 1 and cont_b_i_m = 1 and button_i = '1' ) or ( cont_seg_d = 5 and seg_d = '1' ) else '0'; 
hour_u <= '1' when ( cont_b_m = 1 and cont_b_i_m = 2 and button_i = '1' ) or (cont_min_d = 5 and min_d = '1') else '0';


--Processo set alarme min unidades
process(clk, reset)
	begin
		if(reset = '1') then
			cont_min_u_alarm <= 0;
		elsif ( clk'event and clk = '1') then
			if(cont_b_m = 2) then
				if(cont_b_i_m = 1) then
					if( button_i = '1' ) then
						if(cont_min_u_alarm = 9) then
							cont_min_u_alarm <= 0;
						else	
							cont_min_u_alarm <= cont_min_u_alarm + 1;
						end if;	
					end if;
				end if;	
			end if;	
		end if;
end process;

c_min_u_alarm <= cont_min_u_alarm;

min_d_alarm <= '1' when cont_min_u_alarm = 9 and button_i = '1' and cont_b_m = 2 else '0';

--Processo set alarme min dezenas
process(clk, reset)
	begin
		if(reset = '1') then
			cont_min_d_alarm <= 0;
		elsif ( clk'event and clk = '1') then
			if(cont_b_m = 2) then
				if( min_d_alarm = '1' ) then
					if(cont_min_d_alarm = 5) then
						cont_min_d_alarm <= 0;
					else	
						cont_min_d_alarm <= cont_min_d_alarm + 1;
					end if;	
				end if;
			end if;	
		end if;
end process;

c_min_d_alarm <= cont_min_d_alarm;

--Processo set alarme horas unidades
process(clk, reset)
	begin
		if(reset = '1') then
			cont_hour_u_alarm <= 0;
		elsif ( clk'event and clk = '1') then
			if(cont_b_m = 2) then
				if(cont_b_i_m = 2) then
					if( button_i = '1' ) then
						if ( cont_hour_u_alarm = 9 ) then	
							cont_hour_u_alarm <= 0;
						elsif( cont_hour_u_alarm = 3 and cont_hour_d_alarm = 2 )	then
							cont_hour_u_alarm <= 0;
						else
							cont_hour_u_alarm <= cont_hour_u_alarm + 1;								
						end if;  
					end if;
				end if;
			end if;	
		end if;
end process;

c_hour_u_alarm <= cont_hour_u_alarm;

hour_d_alarm <= '1' when ( cont_hour_u_alarm = 9 or ( cont_hour_u_alarm = 3 and cont_hour_d_alarm = 2) ) and button_i = '1' else '0';

--Processo set alarme horas dezenas
process(clk, reset)
	begin
		if(reset = '1') then
			cont_hour_d_alarm <= 0;
		elsif ( clk'event and clk = '1') then
			if(cont_b_m = 2) then
				if(hour_d_alarm = '1') then		
					if ( cont_hour_u_alarm = 3  and cont_hour_d_alarm = 2 ) then
						cont_hour_d_alarm <= 0;
					else
						cont_hour_d_alarm <= cont_hour_d_alarm + 1;								
					end if; 
				end if;
			end if;
		end if;
end process;

c_hour_d_alarm <= cont_hour_d_alarm;

--Gerador de alarme
r_alarm <= '1' when cont_min_u = cont_min_u_alarm and cont_min_d = cont_min_d_alarm and cont_hour_u = cont_hour_u_alarm and cont_hour_d = cont_hour_d_alarm and switch_alarm_active = '1' else '0';


--processo unidades de minuto do temporizador
process(clk, reset)
	begin
		if(reset = '1') then
			cont_min_u_timer <= 0;
		elsif ( clk'event and clk = '1') then
			if(switch_timer_active = '1') then-- in working mode
				if(min_u_timer = '1') then
					if(cont_seg_u_timer = 0 and cont_seg_d_timer = 0 and cont_min_u_timer = 0 and cont_min_d_timer = 0 and cont_hour_u_timer = 0 and cont_hour_d_timer = 0) then
						--
					elsif(cont_min_u_timer = 0) then
						cont_min_u_timer <= 9;
					else	
						cont_min_u_timer <= cont_min_u_timer - 1;
					end if;
				end if;
			elsif(cont_b_m = 3) then-- if it's in setting mode
				if( (button_i = '1' and switch_timer_active = '0' and cont_b_i_m = 2 and switch_time_units = '0') or (button_i = '1' and switch_timer_active = '0' and cont_b_i_m = 1 and switch_time_units = '1') ) then		
					if ( cont_min_u_timer = 9) then
						cont_min_u_timer <= 0;
					else
						cont_min_u_timer <= cont_min_u_timer + 1;								
					end if; 
				end if;	
			end if;		
		end if;
end process;
min_u_timer <= '1' when  (cont_seg_u_timer = 0 and cont_seg_d_timer = 0 and seg_u = '1' and switch_timer_active = '1') else '0';
min_d_timer <= '1' when (cont_min_u_timer = 9 and switch_timer_active = '0' and button_i = '1') or (cont_min_u_timer = 0 and min_u_timer = '1' and switch_timer_active = '1') or (cont_hour_u_timer = 0 and hour_u_timer = '1' and switch_timer_active = '1' ) else '0';
c_min_u_timer <= cont_min_u_timer;
--processo dezenas de minuto do temporizador
process(clk, reset)
	begin
		if(reset = '1') then
			cont_min_d_timer <= 0;
		elsif ( clk'event and clk = '1') then
			if(switch_timer_active = '1') then
				if(min_d_timer = '1') then
					if(cont_min_d_timer = 0 and cont_hour_u_timer = 0 and cont_hour_d_timer = 0 ) then
					-- do nothing
					else-- decrementing time
						if(cont_min_d_timer = 0) then
							cont_min_d_timer <= 5;
						else	
							cont_min_d_timer <= cont_min_d_timer - 1;
						end if;	
					end if;
				end if;
			elsif(cont_b_m = 3) then
				if(cont_b_i_m /= 0) then
					if( min_d_timer = '1' and switch_timer_active = '0') then--setting time
						if ( cont_min_d_timer = 5) then
							cont_min_d_timer <= 0;
						else
							cont_min_d_timer <= cont_min_d_timer + 1;								
						end if; 
					end if;		
				end if;
			end if;
		end if;
end process;

c_min_d_timer <= cont_min_d_timer;

--process unidades de hora timer
hour_u_timer <= '1' when cont_min_u_timer = 0 and cont_min_d_timer = 0 and min_u_timer = '1' else '0';
process(clk, reset)
	begin
		if(reset = '1') then
			cont_hour_u_timer <= 0;
		elsif ( clk'event and clk = '1') then
			if(switch_timer_active = '1') then-- in working mode
				if(hour_u_timer = '1') then
					if(cont_seg_u_timer = 0 and cont_seg_d_timer = 0 and cont_min_u_timer = 0 and cont_min_d_timer = 0 and cont_hour_u_timer = 0 and cont_hour_d_timer = 0  ) then
						--
					elsif(cont_hour_u_timer = 0) then
						cont_hour_u_timer <= 9;
					else	
						cont_hour_u_timer <= cont_hour_u_timer - 1;
					end if;
				end if;
			elsif(cont_b_m = 3) then-- if it's in setting mode
				if(cont_b_i_m = 2 and switch_time_units = '1') then
					if( button_i = '1' and switch_timer_active = '0') then		
						if ( cont_hour_u_timer = 9 or (cont_hour_u_timer = 3 and cont_hour_d_timer = 2)) then
							cont_hour_u_timer <= 0;
						else
							cont_hour_u_timer <= cont_hour_u_timer + 1;								
						end if; 
					end if;	
				end if;	
			end if;	
		end if;
end process;
c_hour_u_timer <= cont_hour_u_timer;

hour_d_timer <= '1' when (cont_hour_u_timer = 9 and switch_timer_active = '0' and button_i = '1') or (cont_hour_u_timer = 3 and cont_hour_d_timer = 2 and  button_i = '1') or ( hour_u_timer = '1' and switch_timer_active = '1') else '0';

--processo dezenas de horas do temporizador
process(clk, reset)
	begin
		if(reset = '1') then
			cont_hour_d_timer <= 0;
		elsif ( clk'event and clk = '1') then
			if(switch_timer_active = '1') then
				if(hour_u_timer = '1' and cont_hour_u_timer = 0) then
					if(cont_hour_d_timer /= 0) then-- decrementing time
						cont_hour_d_timer <= cont_hour_d_timer - 1;
					end if;
				end if;
			elsif(cont_b_m = 3) then
				if(cont_b_i_m = 2 and switch_time_units = '1') then
					if( hour_d_timer = '1' and switch_timer_active = '0') then--setting time
						if ( cont_hour_d_timer = 2) then
							cont_hour_d_timer <= 0;
						else
							cont_hour_d_timer <= cont_hour_d_timer + 1;								
						end if; 
					end if;		
				end if;
			end if;
		end if;
end process;
c_hour_d_timer <= cont_hour_d_timer;

--process Start timer
process(clk,reset)
	begin
		 if(reset = '1') then
			cont_seg_u_timer <= 0;
			cont_seg_d_timer <= 0;
		 elsif ( clk'event and clk = '1') then
				if( switch_timer_active = '0') then
					if (switch_time_units = '0') then
						if(cont_b_m = 3) then
							if(cont_b_i_m = 1) then
								if(button_i = '1') then
									if(cont_seg_u_timer = 9) then
										cont_seg_u_timer <= 0;
									else
										cont_seg_u_timer <= cont_seg_u_timer + 1;
									end if;
								end if;
								if(seg_d_timer = '1' and switch_timer_active = '0') then
									if(cont_seg_d_timer = 5) then
										cont_seg_d_timer <= 0;
									else
										cont_seg_d_timer <= cont_seg_d_timer + 1;
									end if;
								end if;	
							end if;
						end if;
					end if;		
				end if;	
				if(switch_timer_active = '1') then -- start decrementing the time
					if(seg_u = '1') then
						if(cont_seg_u_timer = 0 and cont_seg_d_timer = 0 and cont_min_u_timer = 0 and cont_min_d_timer = 0 and cont_hour_u_timer = 0 and cont_hour_d_timer = 0  ) then
						--
						elsif(cont_seg_u_timer = 0) then
							cont_seg_u_timer <= 9;
						else	
							cont_seg_u_timer <= cont_seg_u_timer - 1;
						end if;	
					end if;
					if(seg_d_timer = '1') then
						if(cont_seg_u_timer = 0 and cont_seg_d_timer = 0 and cont_min_u_timer = 0 and cont_min_d_timer = 0 and cont_hour_u_timer = 0 and cont_hour_d_timer = 0  ) then
						--
						elsif(cont_seg_d_timer = 0 ) then
							cont_seg_d_timer <= 5;
						else	
							cont_seg_d_timer <= cont_seg_d_timer - 1;
						end if;	
					end if;
				end if;	
		end if;
end process;
seg_d_timer <= '1' when (cont_seg_u_timer = 0 and seg_u = '1' and switch_timer_active = '1') or ( cont_seg_u_timer = 9 and switch_timer_active = '0' and button_i = '1' and switch_timer_active = '0') else '0';
c_seg_u_timer <= cont_seg_u_timer;
c_seg_d_timer <= cont_seg_d_timer;

--signal timer has reached 0
r_timer_ended <= '1' when cont_seg_u_timer = 0 and cont_seg_d_timer = 0 and cont_min_u_timer = 0 and cont_min_d_timer = 0 and cont_hour_u_timer = 0 and cont_hour_d_timer = 0  and switch_timer_active = '1' else '0';

--Process start/stop stopwatch -- signal switch_start_stop (puts everything at 0 if '0' and if '1' starts it), signal switch_pause_sw (pauses at '1' continues at '0')
--process cria centesimos de segundo
--Process code for subseg 
process (clk, reset)
	begin
		if ( reset = '1') then
			cont_subcentseg <= 0;
      elsif ( clk'event and clk = '1') then
         if ( cont_subcentseg = 499999) then--499999
				cont_subcentseg <= 0;
         else
				cont_subcentseg <= cont_subcentseg + 1;								
         end if;  
			
      end if;
end process;

centseg_u_sw <= '1' when cont_subcentseg = 499999 and switch_start_stop = '1' and switch_pause_sw = '0' else '0';

--Process unidades centesimo de segundo
process (clk, reset,switch_start_stop)
	begin
		if ( reset = '1') then
			cont_centseg_u_sw <= 0;
		elsif(switch_start_stop = '0') then
			cont_centseg_u_sw <= 0;	
		elsif(switch_start_stop = '0') then
			cont_centseg_u_sw <= 0;
      elsif ( clk'event and clk = '1') then
         if ( centseg_u_sw = '1' ) then
				if ( cont_centseg_u_sw = 9 ) then
					cont_centseg_u_sw <= 0;
				else
					cont_centseg_u_sw <= cont_centseg_u_sw + 1;								
				end if; 
			 end if;
      end if;
end process;

centseg_d_sw <= '1' when cont_centseg_u_sw = 9 and centseg_u_sw = '1' and switch_start_stop = '1' and switch_pause_sw = '0' else '0';
c_centseg_u_sw <= cont_centseg_u_sw; 

--Process dezenas  centesimo de segundo
process (clk, reset,switch_start_stop)
	begin
		if ( reset = '1') then
			cont_centseg_d_sw <= 0;
	   elsif(switch_start_stop = '0') then
			cont_centseg_d_sw <= 0;
      elsif ( clk'event and clk = '1') then
			if ( centseg_d_sw = '1' ) then
				if ( cont_centseg_d_sw = 9 ) then
					cont_centseg_d_sw <= 0;
				else
					cont_centseg_d_sw <= cont_centseg_d_sw + 1;								
				end if;  
			end if;	
      end if;
end process;

c_centseg_d_sw <= cont_centseg_d_sw; 
seg_u_sw <= '1' when cont_centseg_d_sw = 9 and cont_centseg_u_sw = 9 and centseg_u_sw = '1' and switch_start_stop = '1' and switch_pause_sw = '0' else '0';

--process Stop Watch unidades de segundo
process(clk,reset,switch_start_stop)
	begin
		 if(reset = '1' ) then
			cont_seg_u_sw <= 0;
		 elsif(switch_start_stop = '0') then
			cont_seg_u_sw <= 0;
		 elsif ( clk'event and clk = '1') then
				if(seg_u_sw = '1') then 
					if ( cont_seg_u_sw = 9 ) then
						cont_seg_u_sw <= 0;
					else
						cont_seg_u_sw <= cont_seg_u_sw + 1;								
					end if; 
				end if;		
		end if;
end process;

c_seg_u_sw <= cont_seg_u_sw; 
seg_d_sw <= '1' when cont_seg_u_sw = 9 and seg_u_sw = '1' and switch_start_stop = '1' and switch_pause_sw = '0' else '0';

--process Stop Watch dezenas de segundo
process(clk,reset,switch_start_stop)
	begin
		 if(reset = '1' ) then
			cont_seg_d_sw <= 0;
		 elsif(switch_start_stop = '0') then
			cont_seg_d_sw <= 0;	
		 elsif ( clk'event and clk = '1') then
				if(seg_d_sw = '1') then 
					if ( cont_seg_d_sw = 5 ) then
						cont_seg_d_sw <= 0;
					else
						cont_seg_d_sw <= cont_seg_d_sw + 1;								
					end if; 
				end if;		
		 end if;
end process;

c_seg_d_sw <= cont_seg_d_sw; 
min_u_sw <= '1' when cont_seg_d_sw = 5 and cont_seg_u_sw = 9 and seg_u_sw = '1' and switch_start_stop = '1' and switch_pause_sw = '0' else '0';

--process Stop Watch unidades de minuto
process(clk,reset,switch_start_stop)
	begin
		 if(reset = '1' ) then
			cont_min_u_sw <= 0;
		 elsif(switch_start_stop = '0') then
			cont_min_u_sw <= 0;		
		 elsif ( clk'event and clk = '1') then
				if(min_u_sw = '1') then
					if ( cont_min_u_sw = 9 ) then
						cont_min_u_sw <= 0;
					else
						cont_min_u_sw <= cont_min_u_sw + 1;								
					end if; 
				end if;		
		 end if;
end process;

c_min_u_sw <= cont_min_u_sw; 
min_d_sw <= '1' when cont_min_u_sw = 9 and min_u_sw = '1' and switch_start_stop = '1' and switch_pause_sw = '0' else '0';

--process Stop Watch unidades de minuto
process(clk,reset,switch_start_stop)
	begin
		 if(reset = '1' ) then
			cont_min_d_sw <= 0;
		 elsif(switch_start_stop = '0') then
			cont_min_d_sw <= 0;		
		 elsif ( clk'event and clk = '1') then
				if(min_d_sw = '1') then 
					if ( cont_min_d_sw = 5 ) then
						cont_min_d_sw <= 0;
					else
						cont_min_d_sw <= cont_min_d_sw + 1;								
					end if; 
				end if;		
		 end if;
end process;

c_min_d_sw <= cont_min_d_sw; 
c_b_m <= cont_b_m;


led_normal_clock_mode <= '1' when cont_b_m = 0 else '0';
led_normal_clock_inc_mode <= '1' when cont_b_m = 1 else '0';
led_alarm_clock_inc_mode <= '1' when cont_b_m = 2 or cont_b_i_m = 0  else '0';
led_timer_clock_inc_mode <= '1' when cont_b_m = 3 or cont_b_i_m = 1  else '0';
led_stopwatch_clock_inc_mode <= '1' when cont_b_m = 4 or cont_b_i_m = 2 else '0';



end Behavioral;

