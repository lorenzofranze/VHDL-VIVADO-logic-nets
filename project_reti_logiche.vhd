
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity operations is
port(
    i_clk: in std_logic;
    i_data: in std_logic_vector(7 downto 0);
    i_rst: in std_logic;
    r1_sel: in std_logic;
    r1_load: in std_logic;
    r2_load: in std_logic;
    r3_sel: in std_logic;
    r3_load: in std_logic;
    r1_val: out std_logic_vector(7 downto 0);
    fine: out std_logic;
    r2_val: out std_logic_vector(7 downto 0);
    r3_val: out std_logic_vector(2 downto 0);
    conv_Uk: out std_logic;
    conv_fine: out std_logic;
    conv_mid: out std_logic
    );
end operations;

architecture operations_arch of operations is

signal mux1: std_logic_vector(7 downto 0); -- uscita del mux 1
signal sub1: std_logic_vector(7 downto 0);  -- uscita sottrattore
signal reg1: std_logic_vector(7 downto 0); -- segnale interno: valore salvato in register 1
signal reg2: std_logic_vector(7 downto 0); -- segnale interno: valore salvato in register 2
signal mux3: std_logic_vector(2 downto 0); -- uscita mux 3
signal sub3: std_logic_vector(2 downto 0); -- uscita sub 3
signal reg3: std_logic_vector(2 downto 0); --segnale interno: valore salvato in register 3
--segnali interni

begin

    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            r1_val<="00000000";
            reg1<="00000000";
        elsif i_clk'event and i_clk='1' then
            if(r1_load = '1') then
                r1_val <= mux1;
                reg1 <= mux1;
            end if;
        end if;
    end process;
    
    sub1 <= std_logic_vector(unsigned(reg1)-1);
    
    
    with r1_sel select
        mux1 <= i_data when '1',
                sub1 when '0',
                "XXXXXXXX" when others;
        
    fine <= '1' when (reg1 = "00000000") else '0';
    
    process(i_clk, i_rst)
        begin
            if i_rst = '1' then
                r2_val<="00000000";
                reg2<="00000000";
            elsif i_clk'event and i_clk='1' then
                if(r2_load = '1') then
                    r2_val <= i_data;
                    reg2 <= i_data;
                end if;
            end if;
        end process;
        
    with r3_sel select
        mux3<= "111" when '1',
                sub3 when '0',
                "XXX" when others;
    
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
                r3_val<="000";
                reg3<="000";
        elsif i_clk'event and i_clk='1' then
                if(r3_load = '1') then
                      r3_val <= mux3;
                      reg3 <= mux3;
                end if;
        end if;
    end process;
    
    sub3 <= std_logic_vector(unsigned(reg3)-1);
    
    conv_fine <= '1' when (reg3 = "00000000") else '0';
    
    conv_Uk <= i_data(to_integer(unsigned(reg3)));
    
    conv_mid <= '1' when (reg3 = "00000100") else '0';
    
end operations_arch;
           
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
        
entity convolutore is
port(
    conv_rst: in std_logic;
    i_clk: in std_logic;
    conv_on: in std_logic;
    conv_Uk: in std_logic;
    conv_P1k: out std_logic;
    conv_P2k: out std_logic;
    variaz: out std_logic
    );
end convolutore;

architecture convolutore_arch of convolutore is
type state_type is (s0, s1, s2, s3);
signal next_state, cur_state: state_type;
signal variaz_int: std_logic;  -- segnale interno per modificare segnale variaz in out
    
begin
    process(i_clk, conv_rst)
    begin
         if conv_rst = '1' then
            cur_state <= s0;
            variaz <= '0';
            variaz_int <= '0';
         elsif i_clk'event and i_clk = '1' and conv_on ='1' then
            cur_state <= next_state;
            variaz <= not variaz_int;
            variaz_int <= not variaz_int;
         end if;
    end process;
    
    DELTA_LAMBDA: process(cur_state, conv_Uk)
    begin
        case cur_state is
            when s0 =>
                if conv_Uk = '0' then
                    conv_P1k <= '0';
                    conv_P2k <= '0';
                    next_state<=s0;
                else 
                    conv_P1k <= '1';
                    conv_P2k <= '1';
                    next_state <= s2;
                end if;
            when s1 =>
                if conv_Uk = '0' then
                    conv_P1k <= '1';
                    conv_P2k <= '1';
                    next_state<=s0;
                else 
                    conv_P1k <= '0';
                    conv_P2k <= '0';
                    next_state <= s2;
                end if;
            when s2 =>
                if conv_Uk = '0' then
                    conv_P1k <= '0';
                    conv_P2k <= '1';
                    next_state<=s1;
                else 
                    conv_P1k <= '1';
                    conv_P2k <= '0';
                    next_state <= s3;
                end if;
            when s3 =>
                if conv_Uk = '0' then
                    conv_P1k <= '1';
                    conv_P2k <= '0';
                    next_state<=s1;
                else 
                    conv_P1k <= '0';
                    conv_P2k <= '1';
                    next_state <= s3;
                end if;
        end case;
    end process;
    
end convolutore_arch;


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity project_reti_logiche is
port (
    i_clk : in std_logic;
    i_rst : in std_logic;
    i_start : in std_logic;
    i_data : in std_logic_vector(7 downto 0);
    o_address : out std_logic_vector(15 downto 0);
    o_done : out std_logic;
    o_en : out std_logic;
    o_we : out std_logic;
    o_data : out std_logic_vector (7 downto 0)
      );
end project_reti_logiche;

architecture project_reti_logiche_arch of project_reti_logiche is
    component operations is
    port(
        i_clk: in std_logic;
        i_data: in std_logic_vector(7 downto 0);
        i_rst: in std_logic;
        r1_sel: in std_logic;
        r1_load: in std_logic;
        r2_load: in std_logic;
        r3_sel: in std_logic;
        r3_load: in std_logic;
        r1_val: out std_logic_vector(7 downto 0);
        fine: out std_logic;
        r2_val: out std_logic_vector(7 downto 0);
        r3_val: out std_logic_vector(2 downto 0);
        conv_Uk: out std_logic;
        conv_fine: out std_logic;
        conv_mid: out std_logic
        );
    end component;
    
    component convolutore is
    port(
        conv_rst: in std_logic;
        i_clk: in std_logic;
        conv_on: in std_logic;
        conv_Uk: in std_logic;
        conv_P1k: out std_logic;
        conv_P2k: out std_logic;
        variaz: out std_logic
        );
    end component;
    
signal r1_sel: std_logic;
signal r1_load: std_logic;
signal r2_load: std_logic;
signal r3_sel: std_logic;
signal r3_load: std_logic;
signal r1_val: std_logic_vector(7 downto 0);
signal fine: std_logic;
signal r2_val: std_logic_vector(7 downto 0);
signal r3_val: std_logic_vector(2 downto 0);
signal conv_Uk: std_logic;
signal conv_fine: std_logic;
signal conv_mid: std_logic;

signal conv_rst: std_logic;
signal conv_on: std_logic;
signal conv_P1k: std_logic;
signal conv_P2k: std_logic;
signal variaz: std_logic;

type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11);
signal cur_state, next_state: state_type;
signal data1: std_logic_vector(7 downto 0);
signal data2: std_logic_vector(7 downto 0);    
    --segnali interni
begin
    OPER: operations port map(
    i_clk,
    i_data,
    i_rst,
    r1_sel,
    r1_load,
    r2_load,
    r3_sel,
    r3_load,
    r1_val,
    fine,
    r2_val,
    r3_val,
    conv_Uk,
    conv_fine,
    conv_mid
    );
    
    CONV: convolutore port map(
        conv_rst,
        i_clk,
        conv_on,
        conv_Uk,
        conv_P1k,
        conv_P2k,
        variaz
    );
        
        
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            cur_state <= s0;
        elsif i_clk'event and i_clk = '1' then
            cur_state<=next_state;
        end if;
    end process;
    
    DELTA: process(cur_state, i_start, fine, conv_fine, conv_mid)
    begin
        case cur_state is
            when s0 =>
                if i_start = '1' then
                    next_state <= s1;
                else
                    next_state <= s0;
                end if;
            when s1 =>
                next_state <= s2;
            when s2 =>
                next_state <= s3;
            when s3 =>
                if fine='1' then
                    next_state <= s4;
                else
                    next_state <= s6;
                end if;
            when s4 => 
                if i_start = '1' then
                    next_state <= s4;
                else
                    next_state <= s5;
                end if;
            when s5 =>
                if i_start = '1' then
                    next_state <= s1;
                else 
                    next_state <= s5;
                end if;
            when s6 =>
                if fine = '1' then
                    next_state <= s4;
                else
                    next_state <= s7;
                end if;
            when s7 =>
                next_state <= s8;
            when s8 =>
                if conv_mid = '1' then
                    next_state <= s9;
                else
                    next_state <= s8;
                end if;
            when s9 =>
                if conv_fine = '1' then
                    next_state <= s10;
                else
                    next_state <= s9;
                end if;
            when s10 =>
                next_state <= s11;
            when s11 =>
                if fine = '1' then
                    next_state <= s4;
                else
                    next_state <= s6;
                end if;
        end case;
    end process;
    
    
    LAMBDA: process (cur_state, conv_P1k, conv_P2k, variaz)
    begin
        r1_sel <= '0';
        r1_load <= '0';
        r2_load <= '0';
        r3_sel <= '0';
        r3_load <= '0';
        conv_rst <= '0';
        conv_on <= '0';
        o_address <= "0000000000000000";
        o_data <= "00000000";
        o_done <= '0';
        o_en <= '0';
        o_we <= '0'; 
        
        case cur_state is
            when s0=>
            when s1 =>
                o_address <= "0000000000000000";
                o_en <= '1';
                conv_rst <= '1';
            when s2 =>
                r1_sel <= '1';
                r1_load <= '1';
                r2_load <= '1';
            when s3 =>
            when s4 =>
                o_done <= '1';
            when s5 =>
                o_done <= '0';
            when s6 => 
                o_address <= std_logic_vector(unsigned(r2_val) - unsigned(r1_val) +1 + "0000000000000000");
                o_en <= '1';
                r3_sel <= '1';
                r3_load<= '1';
                data1 <= "00000000";
                data2 <= "00000000";
            when s7 => 
            when s8 =>
                conv_on <= '1';
                data1(2*(to_integer(unsigned(r3_val)) mod 4)+ 1) <= conv_P1k;
                data1(2*(to_integer(unsigned(r3_val)) mod 4)) <= conv_P2k;
                r3_load <= '1';
            when s9 =>
                conv_on <= '1';
                data2(2*(to_integer(unsigned(r3_val)) mod 4)+ 1) <= conv_P1k;
                data2(2*(to_integer(unsigned(r3_val)) mod 4)) <= conv_P2k;
                r3_load <= '1';   
            when s10 => 
                o_address <= std_logic_vector(to_unsigned(1000 + 2*(to_integer(unsigned(r2_val)-unsigned(r1_val))+1)-2, 16)+"0000000000000000");
                o_data <= data1;
                o_en <= '1';
                o_we <= '1';
            when s11 => 
                o_address <= std_logic_vector(to_unsigned(1000 + 2*(to_integer(unsigned(r2_val)-unsigned(r1_val))+1)-1, 16)+"0000000000000000");
                o_data <= data2;
                o_en <= '1';
                o_we <= '1';
                r1_load <= '1';
       end case;
   end process;
end project_reti_logiche_arch;    
                
                 
               
