module CELDA_TOPO(

	input reset,
	input wire PONER_TOPO,
	input wire GOLPE,
	input wire SELECT,
	output wire HIT,
	output wire [2:0] RGB
	);

	wire TOPO;
	wire SELECTED;
	assign TOPO = (reset)? 0 : (SELECTED && TOPO && GOLPE)? 0: PONER_TOPO;
	assign SELECTED = (reset)? 0 : SELECT;

	// Si no esta seleccionado y no es topo, esta verde. Si no, si esta seleccionado es amarillo y si no esta seleccionado es topo.
	assign RGB = (!SELECTED && !TOPO)? 3'b010: (SELECTED && TOPO)? 3'b101: (SELECTED)? 3'b001: 3'b110;
								    // (GREEN)			  (RED) (YELLO W)													
	assign HIT = (SELECTED && TOPO && GOLPE)? 1 : 0;

endmodule
