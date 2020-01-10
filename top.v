`timescale 1ns / 1ps
//Products = 5 Amt Selection = 3
//No of states = 7

 
module top(
    clk, row, col,
    an, seg, led_reset, led_check, ps, dispense, money, btn, refnd, dp, E_quantity
    );
    
    input wire clk;
    input wire [3:0] row;
    input wire btn;
    input wire refnd;
    output [3:0] an;
    output reg dp = 1'b1;
    output [6:0] seg;
    output led_reset;
    output wire [3:0] col;
    output wire dispense; 
    output wire [2:0] ps;
    output wire led_check;
    output wire [3:0] money; 
    output wire [3:0] E_quantity;
    wire clk_1ms, clk_1s;
    wire [3:0] LED;
    wire [3:0] change;
    wire [2:0] ns;
    wire [6:0] dout;
    wire [3:0] CurrProd;
    wire [3:0] CurrPrice;
    clock_divider c1 (.clk(clk), .clk_1ms(clk_1ms), .clk_1s(clk_1s));   
    Keypad k1(.clk_1ms(clk_1ms), .row(row), .col(col), .LED(LED), .clk_1s(clk_1s));
    NSL n1(.clk_1ms(clk_1s), .LED(LED), .dispense(dispense), .change(change), .led_reset(led_reset), .ps(ps), .CurrProd(CurrProd), .CurrPrice(CurrPrice), .money(money), .btn(btn), .refnd(refnd), .E_quantity(E_quantity)); 
    sevenseg s1(.clk_1ms(clk_1ms), .ps(ps), .anode(an), .dout(seg), .LED(LED), .led_check(led_check), .CurrProd(CurrProd), .CurrPrice(CurrPrice), .money(money));
    //NSL given 100ms 
endmodule
