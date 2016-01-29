library verilog;
use verilog.vl_types.all;
entity tdpram_32x256 is
    port(
        clka            : in     vl_logic;
        wea             : in     vl_logic_vector(0 downto 0);
        addra           : in     vl_logic_vector(7 downto 0);
        dina            : in     vl_logic_vector(31 downto 0);
        douta           : out    vl_logic_vector(31 downto 0);
        clkb            : in     vl_logic;
        web             : in     vl_logic_vector(0 downto 0);
        addrb           : in     vl_logic_vector(7 downto 0);
        dinb            : in     vl_logic_vector(31 downto 0);
        doutb           : out    vl_logic_vector(31 downto 0)
    );
end tdpram_32x256;
