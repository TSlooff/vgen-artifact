-------------------------------------------------------------------------------
-- Title      : DDBEN
-- Project    : 
-------------------------------------------------------------------------------
-- File       : aes_tb.vhd
-- Author     : Francesco Regazzoni  <regazzoni@alari.ch>
-- Company    : Advanced Learning and Research Insitute, Lugano 
-- Created    : 2013-11-3
-- Last update: 2013-11-3
-- Platform   : ModelSim (simulation), Synopsys (synthesis)
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Test bench for the AES core of Frank 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 Francesco Regazzoni
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-11-3  1.0      rf      Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
--use work.aes_pack.all;

entity present_tb is
end present_tb;


architecture tb of present_tb is   

 
 signal   Plaintext      : std_logic_vector (63 downto 0);
 signal   Key            : std_logic_vector (79 downto 0);
 signal   Ciphertext      : std_logic_vector (63 downto 0);

 

  signal clk,reset,ready : std_logic;                    -- driving clock
 
   




  component present
  port(
       Plaintext : in std_logic_vector(63 downto 0); 
       Key:   in std_logic_vector(79 downto 0); 
       clk:   in std_logic; 
       reset: in std_logic; 
       ready: out std_logic;     
       Ciphertext: out std_logic_vector(63 downto 0) 
  );
  end component;
       


   
begin

  -- Instantiate the module under test (MUT)
  mut: present
    port map (
       Plaintext => Plaintext,
       Key  => Key,
       clk  => clk,
       reset  => reset,
       ready  => ready,
       Ciphertext => Ciphertext
  );

  -- Generate the clock
--  ClkxC <= not (ClkxC) after clkphasehigh;


  Tb_clkgen : process
  begin
     clk <= '1';
     wait for 50 ns;
     clk <= '0';
     wait for 50 ns;
  end process Tb_clkgen;

  -- obtain stimulus and apply it to MUT
  ----------------------------------------------------------------------------
  B1 : block
   begin


  -- timing of clock and simulation events
 


  Tb_stimappli : process
    variable INLine   : line;
    variable temp_p   : STD_LOGIC_VECTOR(63 downto 0);
    variable temp_c   : STD_LOGIC_VECTOR(63 downto 0);   
    variable temp_k   : STD_LOGIC_VECTOR(79 downto 0); 
    constant clkphasehigh: time:= 50 ns;
    constant clkphaselow: time:= 50 ns;
 
    constant resetactivetime:         time:= 25 ns;

  -- declaration of stimuli, expected responses, and simulation report files
  file stimulifile, simreptfile : text;
  constant stimulifilename : string := "HDL/TBENCH/newstimuli.txt";
  constant simreptfilename : string := "OUT/aessim.rpt";

  file INPUT_file,keyfile,ptfile,ctfile : TEXT;


begin
    file_open(keyfile, "Key.txt", read_mode);
    file_open(ptfile, "PT.txt", read_mode);
    file_open(ctfile, "CT.txt", write_mode);  
 
    

    -- process until we run out of stimuli
    appli_loop : while not (endfile(keyfile)) loop
      readline(keyfile,INLine);
      hread(INLine,temp_k);
      Key <= temp_k;
      readline(ptfile,INLine);
      hread(INLine,temp_p);
      Plaintext <= temp_p ;
      reset      <= '0';
      wait for resetactivetime;
      reset      <= '1';
    
    wait for 2*clkphasehigh*32-resetactivetime -clkphasehigh;
    temp_c:=Ciphertext;
    hwrite(INLine,temp_c);
    writeline(ctfile,INLine);
    wait for clkphasehigh;
  
    end loop appli_loop;
    wait until clk'event and clk = '1';
    file_close(INPUT_file);
    wait;
  end process Tb_stimappli;
end block;
end tb;
