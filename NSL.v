`timescale 1ns / 1ps


module NSL(
clk_1ms, LED, dispense, change, led_reset, ps, CurrProd, CurrPrice, money, btn, clk_1s, refnd, E_quantity
    );
 input wire clk_1ms;
 input wire clk_1s;
 input wire [3:0] LED;
 output reg dispense;
 output reg [3:0] change;
 output reg led_reset;
 input wire btn;
 input wire refnd;

 
 reg flag = 1'b0;
 reg flag2 = 1'b0;
 
 output reg [2:0] ps;
 reg [2:0] ns;
 parameter Reset   =  0;
 parameter ProdSel =  1;
 parameter AmtSel  =  2;
 parameter Disp    =  3;
 parameter Chng    =  4;
 parameter Refund  =  5;
 parameter Stock =  6;
 
 parameter A_price = 06;
 parameter B_price = 05;
 parameter C_price = 09;
 parameter D_price = 04;
 parameter E_price = 11;
 
 reg [3:0] A_quantity = 10;
 reg [3:0] B_quantity = 4;
 reg [3:0] C_quantity = 1;
 reg [3:0] D_quantity = 3;
 output reg [3:0] E_quantity = 2;
 
 output reg [3:0] CurrProd;
 output reg [3:0] CurrPrice;
 output reg [3:0] money; //Max value it can hold is 15$  

 always @ (posedge clk_1ms)
 ps <= ns;
 
 always @ (posedge clk_1ms)
    begin
    case(ps)
        Reset:  
        begin
            led_reset = 1'b1;
            if (LED == 4'hA ||LED == 4'hB||LED == 4'hC||LED == 4'hD||LED == 4'hE)  
            begin
                ns <= ProdSel;
                CurrProd <= LED;
            end
            else 
                begin
                    flag = 1'b0;
                    flag2 = 1'b0;
                    money = 0;
                    change = 0;
                    dispense = 1'b0;
                    CurrPrice = 4'bzzzz;//default value 0 or z(HiDE)
                end
            //Display "select prod"
            //money wont work show err
        end 
        ProdSel:
        begin
            if (LED == 4'hA || LED == 4'hB || LED == 4'hC || LED == 4'hD || LED == 4'hE)  
            begin
                CurrProd = LED;
                ns <= ProdSel;
            end
            else if (LED == 4'h1 || LED == 4'h2 || LED == 4'h5) //Input money 1,2,5$
            begin
                ns <= AmtSel;
                money <= money + LED;
            end
            case (CurrProd)
                4'hA:CurrPrice = A_price;
                4'hB:CurrPrice = B_price;
                4'hC:CurrPrice = C_price;
                4'hD:CurrPrice = D_price;
                4'hE:CurrPrice = E_price;
                default: CurrPrice = 0;
            endcase
            case (CurrProd)    
                4'hA: if (A_quantity == 4'h0) ns <= Stock;
                4'hB: if (B_quantity == 4'h0) ns <= Stock;
                4'hC: if (C_quantity == 4'h0) ns <= Stock;
                4'hD: if (D_quantity == 4'h0) ns <= Stock;
                4'hE: if (E_quantity == 4'h0) ns <= Stock;
                default : ns <= ProdSel;
            endcase 
        end
        AmtSel: 
        begin
            led_reset = ~led_reset;
            if (refnd)
                ns <= Refund;
            case (LED)
            4'h1: 
            begin
                money <= money + 1;
            end
            4'h2: 
            begin
                money <= money + 2;
            end
            4'h5: 
            begin
                money <= money + 5;
            end
            default: money <= money;
            endcase
            if (money >= CurrPrice)
            begin
                ns <= Disp;
            end
           
        end 
        Disp:   
        begin 
            //dispense item
            dispense <= 1'b1; //Light up an led
            if (flag2 == 1'b0)
            begin 
                case(CurrProd)
                4'hA: A_quantity = A_quantity -1;
                4'hB: B_quantity = B_quantity -1;
                4'hC: C_quantity = C_quantity -1;
                4'hD: D_quantity = D_quantity -1;
                4'hE: E_quantity = E_quantity -1;
                default: A_quantity = A_quantity;
                endcase
            end
            flag2 = 1'b1;
            if (btn)
                ns <= Reset;
            else if (money > CurrPrice)
                ns <= Chng;
            else if (money == CurrPrice)
            begin
                ns <= Disp;
            end
        end 
        Chng:   
        begin
            if (flag == 1'b0)
                change <= (money-CurrPrice);//Change is updated once                 
            if (btn)
                ns <= Reset;
            else 
            begin
                ns <= Chng;
                flag = 1'b1;
            end
            //returns change if there 
        end
        Refund: 
        begin
            change <= money;            //cancel option and refund money
            if (btn)
                ns <= Reset;
            else ns <= Refund;
        end
        Stock:
        begin
            if (btn)
                ns <= Reset;
            else ns <= Stock;
            //No item left
        end
        default: 
        begin 
            ns <= Reset;
            led_reset = 1'b0;
        end
    endcase
    end
    
endmodule
