module random_generator (CLK, nanos, nivel, reset, rand);

//outputs declaration
output reg [27:0] nanos;
output reg [3:0] rand;

//inputs declaration
input wire CLK;
input wire reset;
input wire [2:0] nivel;

//variables
reg [3:0] next_rand;
reg [31:0] counter_ciclos, velocidad;
reg par;


always @(posedge CLK) begin
	if (reset) begin
		nanos <= 0;
		rand <= 0;
		counter_ciclos <= 0;
		par <= 0;
		velocidad <= 25000000;
	end else begin
		rand <= next_rand;
	end

	if (nanos % 16) begin
		counter_ciclos <= counter_ciclos + 1;
	end
	case (nivel) 
		3'b001:	velocidad <= 125000000;
		3'b010:	velocidad <= 100000000;
		3'b011:	velocidad <= 85000000;
		3'b100:	velocidad <= 50000000;
		3'b101:	velocidad <= 25000000;
		default: velocidad <= 110000000;
	endcase

	if (nanos < velocidad) begin  //100000000
		nanos <= nanos + 1;
	end else begin
		nanos <= 0;
		par <= ~par;
		counter_ciclos <= {counter_ciclos[31:18], counter_ciclos[17:0]};

		next_rand <= {counter_ciclos[25], counter_ciclos[17], counter_ciclos[9], counter_ciclos[0]} + par;
	end
end //always

endmodule


// always @(posedge CLK) begin
// 	if (reset) begin
// 		nanos <= 0;
// 		rand <= 0;
// 	end else begin
// 		rand <= next_rand;
// 	end

// 	if (nanos < 50000000) begin  //268435455
// 		nanos <= nanos + 1;
// 	end else begin
// 		nanos <= 0;
// 		if (rand < 15) begin
// 			next_rand <= rand + 1;
// 		end else begin
// 			next_rand <= 0;
// 		end
// 	end
// end //always