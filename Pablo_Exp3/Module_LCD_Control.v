`include "Defintions.v"

module Module_LCD_Control (Clock, Reset, LCD_E, LCD_RS, 
							oLCD_StrataFlashControl, LCD_RW, SF_DATA);

input wire Clock;
input wire Reset;
output wire LCD_E;
output LCD_RS; //0=Command, 1=Data
output wire oLCD_StrataFlashControl;
output wire LCD_RW;
output reg[3:0] SF_DATA;

reg [7:0] rCurrentState, rNextState;
reg [31:0] rTimeCount;
reg rTimeCountReset;
wire wWriteDone;
wire initDone;


//----------------------------------------------
//Next State and delay logic
always @ ( posedge Clock ) begin
	if (Reset) begin
		rCurrentState = `IDLE;
		rTimeCount <= 32'b0;
	end
	else begin
		if (rTimeCountReset) begin
			rTimeCountReset <= 1'b0;
			rTimeCount <= 32'b0;
		end else
			rTimeCount <= rTimeCount + 32'b1;
	rCurrentState <= rNextState; 
	end
end


//----------------------------------------------
//Current state and output logic
always @ (*) begin
	case(rCurrentState)
	//------------------------------------------
	`IDLE:
	begin
		LCD_E <= 1'b0;
		LCD_RW <= 1'b0;
		LCD_RS <= 1'b0;
		SF_DATA <= 4'b0;
		initDone <= 1'b0;
		if (~Reset) begin
			rTimeCountReset <= 1'b1;
			rNextState <= `FIFTEENMS; 
		end else
			rNextState <= `IDLE;
	end	
	//------------------------------------------
	`FIFTEENMS:
	begin
		LCD_E <= 1'b1;
		LCD_RW <= 1'b0;
		LCD_RS <= 1'b0;
		SF_DATA <= 4'b0;
		initDone <= 1'b0;
		if (rTimeCount < 800000)
			rNextState <= `FIFTEENMS;
		else begin
			rTimeCountReset <= 1'b1;
			rNextState <= `ONE;
	end end
	//------------------------------------------
	`ONE:
	begin
		LCD_E <= 1;
		LCD_RW <= 1'b0;
		LCD_RS <= 1'b0;
		SF_DATA <= 4'b0011;
		initDone <= 1'b0;
		if (rTimeCount < 20)
			rNextState <= `ONE;
		else begin
			rTimeCountReset <= 1'b1;
			rNextState <= `TWO;
		end
	end
	//------------------------------------------
	`TWO:
	begin
		LCD_E <= 0;
		LCD_RW <= 1'b0;
		LCD_RS <= 1'b0;
		SF_DATA <= 4'b0011;
		initDone <= 1'b0;
		if (rTimeCount < 230000)
			rNextState <= `TWO;
		else begin
			rTimeCountReset <= 1'b1;
			rNextState <= `THREE;
		end
	end
	//------------------------------------------
	`THREE:
	begin
		LCD_E <= 1'b1;
		LCD_RW <= 1'b0;
		LCD_RS <= 1'b0;
		SF_DATA <= 4'b0011;
		initDone <= 1'b0;
		if (rTimeCount < 20)
			rNextState <= `THREE;
		else begin
			rTimeCountReset <= 1'b1;
			rNextState <= `FOUR;
		end	
	end
	//------------------------------------------
	`FOUR:
	begin
		LCD_E <= 1'b0;
		LCD_RW <= 1'b0;
		LCD_RS <= 1'b0;
		SF_DATA <= 4'b0011;
		initDone <= 1'b0;
		if (rTimeCount < 5500)
			rNextState <= `FOUR;
		else begin
			rTimeCountReset <= 1'b1;
			rNextState <= `FIVE;
		end		
	end
	//------------------------------------------
	`FIVE:
	begin
		LCD_E <= 1'b1;
		LCD_RW <= 1'b0;
		LCD_RS <= 1'b0;
		SF_DATA <= 4'b0011;
		initDone <= 1'b0;
		if (rTimeCount < 20)
			rNextState <= `FIVE;
		else begin
			rTimeCountReset <= 1'b1;
			rNextState <= `SIX;
		end	
	end
	//------------------------------------------
	`SIX:
	begin
		LCD_E <= 1'b0;
		LCD_RW <= 1'b0;
		LCD_RS <= 1'b0;
		SF_DATA <= 4'b0011;
		initDone <= 1'b0;
		if (rTimeCount < 2200)
			rNextState <= `SIX;
		else begin
			rTimeCountReset <= 1'b1;
			rNextState <= `SEVEN;
		end		
	end
	//------------------------------------------
	`SEVEN:
	begin
		LCD_E <= 1'b1;
		LCD_RW <= 1'b0;
		LCD_RS <= 1'b0;
		SF_DATA <= 4'b0010;
		initDone <= 1'b0;
		if (rTimeCount < 20)
			rNextState <= `SEVEN;
		else begin
			rTimeCountReset <= 1'b1;
			rNextState <= `EIGHT;
		end	
	end
	//------------------------------------------
	`EIGHT:
	begin
		LCD_E <= 1'b0;
		LCD_RW <= 1'b0;
		LCD_RS <= 1'b0;
		SF_DATA <= 4'b0010;
		initDone <= 1'b0;
		if (rTimeCount < 2200)
			rNextState <= `EIGHT;
		else begin
			rTimeCountReset <= 1'b1;
			rNextState <= `DONE;
		end
	end
	//------------------------------------------
	`DONE:
	begin
		LCD_E <= 1'b0;
		LCD_RW <= 1'b0;
		LCD_RS <= 1'b0;
		SF_DATA <= 4'b0010;
		initDone <= 1'b1;
	end
	//------------------------------------------
	default:
	begin
		LCD_E <= 1'b0;
		LCD_RW <= 1'b0;
		LCD_RS <= 1'b0;
		SF_DATA <= 4'b0;
		initDone <= 1'b0;
		if (init) begin
			rTimeCountReset <= 1'b1;
			rNextState <= `FIFTEENMS; 
		end else
			rNextState <= `IDLE;
	end
end

endmodule