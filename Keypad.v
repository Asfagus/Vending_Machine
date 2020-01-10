`timescale 1ns / 1ps


module Keypad(clk_1ms, row, col, LED, clk_1s);
    input wire clk_1ms;
    input wire clk_1s;
    input wire [3:0] row; 
    output reg [3:0] col = 4'b0000;
    output reg [3:0] LED;

     always @ (posedge clk_1s)
        begin
            case(col)
                4'b0111:
                begin
                    if(row == 4'b0111)//D
                    LED = 13;
                    else if(row == 4'b1011)//C
                    LED = 12;
                    else if(row == 4'b1101)//B
                    LED = 11;
                    else if(row == 4'b1110)//A
                    LED = 10;
                    else LED = 0;
                end
                4'b1011:
                begin
                    if(row == 4'b0111)//e
                    LED = 14;
                    else if(row == 4'b1011)//9
                    LED = 9;
                    else if(row == 4'b1101)//6
                    LED = 6;
                    else if(row == 4'b1110)//3
                    LED = 3;
                    else LED = 0;
                end
                4'b1101:
                begin
                    if(row == 4'b0111)//F
                    LED = 15;
                    else if(row == 4'b1011)//8
                    LED = 8;
                    else if(row == 4'b1101)//5
                    LED = 5;
                    else if(row == 4'b1110)//2
                    LED = 2;
                    else LED = 0;
                end
                4'b1110:
                begin
                    if(row == 4'b0111)//0
                    LED = 0;
                    else if(row == 4'b1011)//7
                    LED = 7;
                    else if(row == 4'b1101)//4
                    LED = 4;
                    else if(row == 4'b1110)//1
                    LED = 1;
                    else LED = 0;
                    end
                    default: LED = 0;//changed from 0 to Z// works only for col not rows
        endcase
       end
       
       always @ (posedge clk_1s)
       begin
       case (col)
       4'b0111: col <= 4'b1011;
       4'b1011: col <= 4'b1101;
       4'b1101: col <= 4'b1110;
       4'b1110: col <= 4'b0111;
       default: col <= 4'b0111;   
       endcase
       end
       
endmodule
