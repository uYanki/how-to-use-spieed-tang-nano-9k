// 8位宽*2048深 = 2048字节

// din  数据输入, dout 数据输出, addr 目标地址, mode 读写模式
// 读模式下(mode=0): 在时钟(clk_in)的控制下，将数据(din)写入到RAM的某地址(addr)
// 写模式下(mode=1): 在时钟(clk_in)的控制下，从RAM的某地址(addr)处读出数据到缓冲区(dout)

// 使用  初始化 SRAM 里的内容, 并配合 mode <= `mode_read

//`define USE_LOGIC_ANALYZER // 使用逻辑分析仪(右键*.rao启用逻辑分析仪功能)
//`define READ_ONLY // 只读模式

// read / write mode (const)
`define mode_read 1'b0
`define mode_write 1'b1

// timer target value

`ifndef USE_LOGIC_ANALYZER
`define target 24'd1349_9999
`else
`define target 24'd10 // 调小计数值,方便分析捕获的波形
`endif

`ifndef READ_ONLY 
// RAM depth = 2048
`define addr_max 11'd2047
`else
// 用 defparam sp_inst_0.INIT_RAM_00 对 RAM 进行初始化
`define addr_max 11'd32 // 256bit/8=32byte
`endif

module main (
    input btn_rst,
    input clk_in,
    output wire[7:0] dout // ram output
    );

    reg mode; // 读写标志位
    reg [10:0] addr; // ram input
    reg [7:0] din; // 8-bit, 8位宽

    Gowin_SP ram_inst(
                .dout(dout), // output [7:0] dout
                .clk(clk_in), // input clk
                .oce(1'b1), // input oce
                .ce(1'b1), // input ce
                .reset(!btn_rst), // input reset
                .wre(mode), // input wre
                .ad(addr), // input [10:0] ad
                .din(din) // input [7:0] din
            );

    /* timer */

    reg [23:0] counter;

    always @(posedge clk_in or negedge btn_rst)
    begin
        if( !btn_rst )
        counter <= 24'd0;
        else
        begin
            // 24'd1349_9999 -> 0.5s
            counter <= (counter < `target)?(counter + 1'b1):(24'd0);
        end
    end

    /* ram r/w */

    always @(posedge clk_in or negedge btn_rst)
    begin
        if( !btn_rst )
        begin
            addr <= 11'd0; // reset address
`ifdef READ_ONLY

            mode <= `mode_read;
`else
            mode <= `mode_write;
            din <= 8'b1111_1110; // init input data
`endif

        end
        /* 写模式 */
        else if( mode == `mode_write )
        begin
            if( addr < `addr_max )
            begin
                addr <= addr + 1'b1;
                din <= {din[6:0],din[7]}; // 循环左移
            end
            else
            begin
                addr <= 1'b0; // reset address
                mode <= `mode_read; // switch read ram mode
            end
        end
        /* 读模式 */
        else
        begin
            if(counter == `target)
            begin
                addr <= addr + 1'b1; // 地址递增
                if( addr === `addr_max )
                begin
                    addr <= 11'd0; // reset address
`ifndef READ_ONLY
                            mode <= `mode_write; // switch write ram mode
`endif

                end
            end
        end

    end

endmodule
