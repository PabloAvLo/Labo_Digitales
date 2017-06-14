module Video_Memory(  input clk,
			 		  input [18:0] Read_address,
					  input [18:0] Write_address,
					  input iwrite,
					  input [2:0] iRGB_Data,
					  output [2:0] oRGB_Data);

reg [2:0] VIDEO_RAM [307200:0];
reg [2:0] oRGB_Data;

always @(posedge clk) begin

	if(iwrite)
		 	VIDEO_RAM[Write_address] <= iRGB_Data;
 	oRGB_Data <= VIDEO_RAM[Read_address];
end
endmodule
