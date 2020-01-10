`timescale 1ns / 1ps

module sevenseg(clk_1ms, ps, anode, dout, LED, led_check, CurrPrice, CurrProd, money);
    input wire clk_1ms;
    input wire [2:0] ps;
    input wire [3:0] LED;
    input wire [3:0] CurrProd;
    input wire [3:0] CurrPrice;
    input wire [3:0] money;
    output reg [3:0] anode;
    output reg [6:0] dout;
    output reg led_check;
    
    parameter Reset   =  0;
    parameter ProdSel =  1;
    parameter AmtSel  =  2;
    parameter Disp    =  3;
    parameter Chng    =  4;
    parameter Refund  =  5;
    parameter Stock =  6;
    
    function [6:0] prod_disp; 
    input [3:0] CurrProd;
    input [3:0] CurrPrice;
    input [3:0] anode;
    
    if (anode == 4'b1110)
    begin 
    case (CurrProd)
        4'hA : prod_disp = 7'b0001000;  // A
        4'hB : prod_disp = 7'b0000011;  // B
        4'hC : prod_disp = 7'b1000110;  // C
        4'hD : prod_disp = 7'b0100001;  // D
        4'hE : prod_disp = 7'b0000110;  // E
      default: prod_disp = 7'b1111111;
     endcase
     end  
   else if (anode == 4'b1101)
    case(CurrPrice)
        4'h0 : prod_disp = 7'b1000000;  // 0
        4'h1 : prod_disp = 7'b1111001;  // 1
        4'h2 : prod_disp = 7'b0100100;  // 2
        4'h3 : prod_disp = 7'b0110000;  // 3
        4'h4 : prod_disp = 7'b0011001;  // 4
        4'h5 : prod_disp = 7'b0010010;  // 5
        4'h6 : prod_disp = 7'b0000010;  // 6
        4'h7 : prod_disp = 7'b1111000;  // 7
        4'h8 : prod_disp = 7'b0000000;  // 8
        4'h9 : prod_disp = 7'b0010000;  // 9
        4'hA : prod_disp = 7'b1000000;  // Custom values of lsb for A
        4'hB : prod_disp = 7'b1111001;  //                          B
        4'hC : prod_disp = 7'b0100100;  //                          C
        4'hD : prod_disp = 7'b0110000;  //                          D
        4'hE : prod_disp = 7'b0011001;  //                          E
        4'hF : prod_disp = 7'b0010010;  //                          F
     default : prod_disp = 7'b1111111;
    endcase
    endfunction
    
           
    always @ (posedge clk_1ms)
    begin
        led_check = ~led_check;
        case (anode)
        4'b0111: anode <= 4'b1011;
        4'b1011: anode <= 4'b1101;
        4'b1101: anode <= 4'b1110;
        4'b1110: anode <= 4'b0111;
        default: anode <= 4'b0111;
        endcase
    end
      
    always @ (posedge clk_1ms)
    begin
    case (ps)
        Reset: 
            begin
                if (anode == 4'b1110)//one anode previously
                    dout  <= 7'b0000011;//b
                else if (anode == 4'b0111)
                    dout  <= 7'b1000001;//u
                else if (anode == 4'b1011)
                    dout  <= 7'b0010001;//y
                else dout <= 7'b1111111;//off
            end
        ProdSel:
        begin
            if (anode == 4'b1110)//one anode previously
            begin   
                 dout <= prod_disp(CurrProd, CurrPrice, anode);
            end
            if (anode ==4'b0111)
            begin
                dout <= 7'b1111111;
            end
            if (anode == 4'b1011)
            begin
                if (CurrPrice < 4'hA)
                    dout <= 7'b1000000;  // 0
                else if (CurrPrice == 4'bzzzz)//Hide for startup
                    dout <= 7'b1111111;
                else dout <= 7'b1111001;  // 1
                
            end
            if (anode == 4'b1101)
            begin
                dout <= prod_disp(CurrProd, CurrPrice, anode);
            end
        end
        AmtSel:
        begin
            if (anode == 4'b1110)//one anode previously
            begin   
                 dout <= prod_disp(CurrProd, CurrPrice, anode);
            end
            if (anode ==4'b0111)
            begin
                 dout <= 7'b0111111;
            end
            if (anode == 4'b1011)
            begin
                if ((CurrPrice-money) < 4'hA) //Variable MSB of value
                    dout <= 7'b1000000;  // 0
                else dout <= 7'b1111001;  // 1
            end
            if (anode == 4'b1101)
            begin
                dout <= prod_disp(CurrProd, (CurrPrice-money), anode); //Variable value
            end
        end
        Disp:
        begin 
            if (anode == 4'b1110)//one anode previously
                dout  <= 7'b0100001;//d
            else if (anode == 4'b0111)
                dout  <= 7'b1111001;//i
            else if (anode == 4'b1011)
                dout  <= 7'b0010010;//s
            else dout <= 7'b0001100;//off
        end
        Chng:
        begin 
            if (anode == 4'b1110)//one anode previously
                dout  <= 7'b1000110;//C
            else if (anode == 4'b0111)
                dout  <= 7'b0001001;//H
            else if (anode == 4'b1011)//change doubles as refund also
                if ((money-CurrPrice) < 4'hA) //Variable MSB of value
                    dout <= 7'b1000000;  // 0
                else dout <= 7'b1111001;  // 1
            else dout <= prod_disp(CurrProd, (money-CurrPrice), anode); //display remaining change
        end
        Refund:
        begin
            if (anode == 4'b1110)//one anode previously
                dout  <= 7'b0101111;//r
            else if (anode == 4'b0111)
                dout  <= 7'b0001110;//F
            else if (anode == 4'b1011)//change doubles as refund also
                if ((money) < 4'hA) //Variable MSB of value
                    dout <= 7'b1000000;  // 0
                else dout <= 7'b1111001;  // 1
            else dout <= prod_disp(CurrProd, (money), anode); //display remaining change
        end
        Stock:
        begin
            if (anode == 4'b1110)//one anode previously
                dout  <= 7'b0101011;//n
            else if (anode == 4'b0111)
                dout  <= 7'b0100011;//o
            else if (anode == 4'b1011)
                dout  <= 7'b1111111;//off
            else //Product
                begin
                    case (CurrProd)
                        4'hA : dout <= 7'b0001000;  // A
                        4'hB : dout <= 7'b0000011;  // B
                        4'hC : dout <= 7'b1000110;  // C
                        4'hD : dout <= 7'b0100001;  // D
                        4'hE : dout <= 7'b0000110;  // E
                      default: dout <= 7'b1111111;
                    endcase
                end
        end
        default: 
        begin
            dout <= 7'b1111111;
        end
    endcase
    
    end

endmodule
