`timescale 1ns / 1ps

module nsl_tb();
	reg clk_1ms, clk_1s, btn, refnd;
	reg [3:0] LED;
	wire dispense, led_reset;
	wire [2:0] ps;
	wire [3:0] change, E_quantity, CurrProd, CurrPrice, money;
	
	NSL(.clk_1ms(clk_1ms), .clk_1s(clk_1s), .btn(btn), .refnd(refnd), .LED(LED), .dispense(dispense),
		.led_reset(led_reset), .change(change), .E_quantity(E_quantity), .CurrProd(CurrProd),
		.CurrPrice(CurrPrice), .money(money), .ps(ps));


	initial begin
		clk_1ms = 0;
		forever #10 clk_1ms = ~clk_1ms;
	end

	initial begin
		$dumpfile("Proj_test.vcd");
		$dumpvars;
	end

	initial begin
		$monitor("state: %b input: %h product: %h price: %d money: %d cancel: %b change: %d dispense: %d time: %t",ps, LED, CurrProd, CurrPrice, money, btn, change, dispense, $time);
	end

	initial begin
		btn = 0;
		#40;	//40s
		LED = 4'hB;
		#10; #10;
		LED = 4'h1;
		#40;
		LED = 4'h2;
		#20;
		LED = 4'h2;
		#20;
		LED = 4'h0;
		#60;
		btn = 1'b1;
		#40;
		btn = 1'b0;
		#10;
		LED = 4'hB;
		#10; #10;
		LED = 4'h2;
		#40;
		LED = 4'h2;
		#20;
		LED = 4'h5;
		#20;
		LED = 4'h0;
		#100;
		btn = 1'b1;
		#40;
		$finish;
	end
endmodule