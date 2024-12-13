----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:38:18 10/07/2021 
-- Design Name: 
-- Module Name:    controlo - Behavioral 
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

entity controler is
    Port ( reset : in  STD_LOGIC;
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
           b_m_out : out  STD_LOGIC_VECTOR (5 downto 0) := (others => '0')  ;
           b_i_m_out : out  STD_LOGIC_VECTOR (1 downto 0) := (others => '0') ;
           switch_alarm_active_out : out  STD_LOGIC := '0';
           switch_timer_active_out : out  STD_LOGIC := '0';
           switch_starter_stop_out : out  STD_LOGIC := '0';
           switch_pause_sw_out : out  STD_LOGIC := '0';
			  switch_timeunits_out : out  STD_LOGIC := '0'
			  );
end controler;

architecture Behavioral of controler is

--Use descriptive names for the states, like st1_reset, st2_search
   type state_type is (c_m_st0_ready , c_m_st1_normal_clock, c_m_st2_increment_mode_clock, c_m_st3_alarm_mode, c_m_st4_timer_mode, c_m_st5_stopwatch_mode,
								i_m_st0_ready,i_m_st1_inc_least_significant, i_m_st2_inc_most_significant,
								alarm_st0_ready,alarm_st1_active, st2_alarm_led,
								timer_st0_ready,timer_st1_active, st2_timer_led,
								stopwatch_st0_ready, st1_stopwatch_active, st2_stopwatch_paused,
								timeunits_st0_ready, timeunits_st1); 
   signal c_m_state : state_type := c_m_st0_ready;
	signal c_m_next_state : state_type := c_m_st0_ready;
	signal i_m_state : state_type := i_m_st0_ready;
	signal i_m_next_state : state_type := i_m_st0_ready;
	signal alarm_state : state_type := alarm_st0_ready;
	signal alarm_next_state : state_type := alarm_st0_ready;
	signal timer_state : state_type := timer_st0_ready;
	signal timer_next_state : state_type := timer_st0_ready;
	signal stopwatch_state : state_type := stopwatch_st0_ready;
	signal stopwatch_next_state : state_type := stopwatch_st0_ready;
	signal timeunits_state : state_type := timeunits_st0_ready;
	signal timeunits_next_state : state_type := timeunits_st0_ready; 
   
  --Declare internal signals for all outputs of the state-machine
   signal b_i_s, b_m_s, b_i_m_s, switch_alarm_active_s, switch_timer_active_s, switch_starter_stop_s, switch_pause_sw_s ,switch_timeunits_s: std_logic:= '0'; 
begin

SYNC_PROC: process (clk,reset)
begin

	if (reset = '1') then
		c_m_state <= c_m_st0_ready;
		i_m_state <= i_m_st0_ready;
		alarm_state <= alarm_st0_ready;
		timer_state <= timer_st0_ready;
		stopwatch_state <= stopwatch_st0_ready;
		timeunits_state <= timeunits_st0_ready;	
    elsif (clk'event and clk = '1') then		
      c_m_state <= c_m_next_state;
		i_m_state <= i_m_next_state;
		alarm_state <= alarm_next_state;
		timer_state <= timer_next_state;
		stopwatch_state <= stopwatch_next_state;
		timeunits_state <= timeunits_next_state;
      -- assign other outputs to internal signals
	end if;		
end process;
-- process for scynchronizing input signals
SYNC_SIGNALS: process (clk,reset)
   begin

		if (reset = '1') then
			b_i_s <= '0';
			b_m_s <= '0';
			b_i_m_s <= '0';
			switch_alarm_active_s <= '0';
			switch_timer_active_s <= '0';
			switch_starter_stop_s <= '0';
			switch_pause_sw_s <= '0';
			switch_timeunits_s <= '0';
		elsif (clk'event and clk = '1') then		
			b_i_s <= b_i;
			b_m_s <= b_m;
			b_i_m_s <= b_i_m;
			switch_alarm_active_s <= switch_alarm_active;
			switch_timer_active_s <= switch_timer_active;
			switch_starter_stop_s <= switch_starter_stop;
			switch_pause_sw_s <= switch_pause_sw;
			switch_timeunits_s <= switch_timeunits;
		end if;		
   end process;
	

 
MODES_NEXT_STATE_DECODE: process (c_m_state, b_i_s, b_m_s)
   begin
      --declare default state for next_state to avoid latches
      c_m_next_state <= c_m_state;  --default is to stay in current state
      --insert statements to decode next_state
      case (c_m_state) is
		
         when c_m_st0_ready =>
            if b_i_s = '1' then
               c_m_next_state <= c_m_st1_normal_clock;
            end if;
				
         when c_m_st1_normal_clock => 
            if b_m_s = '1' then
               c_m_next_state <= c_m_st2_increment_mode_clock;
            end if;
				
         when c_m_st2_increment_mode_clock =>
	         if b_m_s= '1' then
               c_m_next_state <= c_m_st3_alarm_mode;	
            end if;				
			when c_m_st3_alarm_mode =>
	         if b_m_s= '1' then
               c_m_next_state <= c_m_st4_timer_mode;
            end if;
			when c_m_st4_timer_mode =>
	         if b_m_s= '1' then
               c_m_next_state <= c_m_st5_stopwatch_mode;
            end if;
			when c_m_st5_stopwatch_mode =>
	         if b_m_s= '1' then
               c_m_next_state <= c_m_st1_normal_clock;
            end if;	
         when others =>
            c_m_next_state <= c_m_state;
      end case; 	
   end process;
 
	INC_MODE_NEXT_STATE_DECODE: process (i_m_state, b_i_m_s)
   begin
      --declare default state for next_state to avoid latches
      i_m_next_state <= i_m_state;  --default is to stay in current state
      --insert statements to decode next_state
      case (i_m_state) is
		
         when i_m_st0_ready =>
				if b_i_m_s = '1' then
               i_m_next_state <= i_m_st1_inc_least_significant;
            end if;
         when i_m_st1_inc_least_significant => 
            if b_i_m_s = '1' then
               i_m_next_state <= i_m_st2_inc_most_significant;
            end if;	
         when i_m_st2_inc_most_significant =>
	         if b_i_m_s = '1' then
					i_m_next_state <= i_m_st0_ready;			
				end if;
         when others =>
            i_m_next_state <= i_m_state;
      end case; 	
   end process;
	
	ALARM_NEXT_STATE_DECODE: process (alarm_state, switch_alarm_active_s)
   begin
      --declare default state for next_state to avoid latches
      alarm_next_state <= alarm_state;  --default is to stay in current state
      --insert statements to decode next_state
      --below is a simple example
      case (alarm_state) is
		
         when alarm_st0_ready =>
            if switch_alarm_active_s = '1' then
               alarm_next_state <= alarm_st1_active;
            end if;			
         when alarm_st1_active => 
            if switch_alarm_active_s = '0' then
               alarm_next_state <=  alarm_st0_ready;
				end if;
         when others =>
           alarm_next_state <= alarm_state;
      end case; 	
   end process;
	
	TIMER_NEXT_STATE_DECODE: process (timer_state, switch_timer_active_s)
   begin
      --declare default state for next_state to avoid latches
      timer_next_state <= timer_state;  --default is to stay in current state
      --insert statements to decode next_state
      case (timer_state) is		
         when timer_st0_ready =>
            if switch_timer_active_s = '1' then
               timer_next_state <= timer_st1_active;
            end if;			
         when timer_st1_active => 
            if switch_timer_active_s = '0' then
               timer_next_state <=  timer_st0_ready;
				end if;
			when others =>
           timer_next_state <= timer_state;	
      end case; 	
   end process;
	
	STOPWATCH_NEXT_STATE_DECODE: process (stopwatch_state, switch_starter_stop_s, switch_pause_sw_s)
   begin
      --declare default state for next_state to avoid latches
      stopwatch_next_state <= stopwatch_state;  --default is to stay in current state
      --insert statements to decode next_state
      case (stopwatch_state) is
         when stopwatch_st0_ready =>
            if switch_starter_stop_s = '1' then
               stopwatch_next_state <= st1_stopwatch_active;		
            end if;			
         when st1_stopwatch_active => 
            if switch_pause_sw_s = '1' then
               stopwatch_next_state <=  st2_stopwatch_paused;
				elsif switch_starter_stop_s = '0' then
					stopwatch_next_state <=  stopwatch_st0_ready;
            end if;	
			when st2_stopwatch_paused => 
            if switch_pause_sw_s = '0' then
               stopwatch_next_state <= st1_stopwatch_active;
				elsif switch_starter_stop_s = '0' then	
					stopwatch_next_state <= stopwatch_st0_ready;
            end if;
			when others =>
           stopwatch_next_state <= stopwatch_state;	
      end case; 	
   end process;
	
	TIMEUNITS_NEXT_STATE_DECODE: process (timeunits_state, switch_timeunits_s)
   begin
      --declare default state for next_state to avoid latches
      timeunits_next_state <= timeunits_state;  --default is to stay in current state
      --insert statements to decode next_state
      case (timeunits_state) is
         when timeunits_st0_ready =>
            if switch_timeunits_s = '1' then
               timeunits_next_state <= timeunits_st1;
            end if;			
         when timeunits_st1 => 
            if  switch_timeunits_s = '0' then
					timeunits_next_state <= timeunits_st0_ready;
            end if;
			when others =>
				timeunits_next_state <= timeunits_state;
      end case; 	
   end process;

   --MOORE State-Machine - Outputs based on state only
   C_M_OUTPUT_DECODE: process (c_m_state)
   begin
      --insert statements to decode internal output signals    
	  b_m_out <= "000000";--default
	  --c_m_state = st1_normal_clock or c_m_state = st2_increment_mode_clock or c_m_state = st3_alarm_mode or c_m_state = st4_timer_mode or c_m_state = st5_stopwatch_mode
	  case(c_m_state) is
		when c_m_st0_ready =>
			b_m_out <= "000001";
		when c_m_st1_normal_clock =>-- first time this output happens it starts the clock
			b_m_out <= "000010";
		when c_m_st2_increment_mode_clock =>
			b_m_out <= "000100";
		when c_m_st3_alarm_mode =>
			b_m_out <= "001000";
		when c_m_st4_timer_mode =>
			b_m_out <= "010000";
		when c_m_st5_stopwatch_mode =>
			b_m_out <= "100000";
		when others =>
			b_m_out <= "000000";
		end case;	
	
   end process;
		
	I_M_OUTPUT_DECODE: process (i_m_state)
   begin
		b_i_m_out <= "00";--default
	
      --insert statements to decode internal output signals
      if i_m_state = i_m_st0_ready then
			b_i_m_out <= "00";
		elsif i_m_state = i_m_st1_inc_least_significant then	
			b_i_m_out <= "01";
		elsif i_m_state = i_m_st2_inc_most_significant then
			b_i_m_out <= "10";
		else 	
			b_i_m_out <= "00";
		end if;
		 
   end process;
		
	ALARM_OUTPUT_DECODE: process (alarm_state)
   begin
		--default
	   switch_alarm_active_out <= '0';
      --insert statements to decode internal output signals
		if alarm_state = alarm_st0_ready then
			switch_alarm_active_out <= '0';
      elsif alarm_state = alarm_st1_active then
			switch_alarm_active_out <= '1';
		end if;	
   end process;
	
	TIMER_OUTPUT_DECODE: process (timer_state)
   begin
		--default
		switch_timer_active_out <= '0';	
      --insert statements to decode internal output signals
		if timer_state = timer_st0_ready then
			switch_timer_active_out <= '0';
      elsif timer_state = timer_st1_active then
			switch_timer_active_out <= '1';
		end if;	
   end process;
	
	STOPWATCH_OUTPUT_DECODE: process (stopwatch_state)
   begin
		--default
		switch_starter_stop_out <= '0';
		switch_pause_sw_out <= '0';
      --insert statements to decode internal output signals
		if stopwatch_state = stopwatch_st0_ready then
			switch_starter_stop_out <= '0';
      elsif stopwatch_state = st1_stopwatch_active then
			switch_starter_stop_out <= '1';
			switch_pause_sw_out <= '0';
		elsif stopwatch_state = st2_stopwatch_paused then
			switch_pause_sw_out <= '1';
			switch_starter_stop_out <= '1';
		else
			switch_starter_stop_out <= '0';
			switch_pause_sw_out <= '0';
		end if;	
   end process;
	
	TIMEUNITS_OUTPUT_DECODE: process (timeunits_state)
   begin
		--default
		switch_timeunits_out <= '0';		
      --insert statements to decode internal output signals
		if timeunits_state = timeunits_st0_ready then
			switch_timeunits_out <= '0';
      elsif timeunits_state = timeunits_st1 then
			switch_timeunits_out <= '1';	
		end if;	
   end process;
	
	b_i_out <= '1' when b_i_s = '1' else '0' ; 	

end Behavioral;

