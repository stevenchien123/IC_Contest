
`timescale 1ns/10ps

module  CONV(
	input		             clk,
	input		             reset,
	output reg	             busy,	
	input		             ready,	
			
	output reg        [11:0] iaddr,
	input signed      [19:0] idata,	
	
	output reg 	             cwr,
	output reg        [11:0] caddr_wr,
	output reg signed [19:0] cdata_wr,
	
	output reg 	             crd,
	output reg        [11:0] caddr_rd,
	input signed      [19:0] cdata_rd,
	
	output reg        [2:0]  csel
	);

// FSM states
parameter IDLE         = 4'd0;
parameter READ_CONV_0  = 4'd1;
parameter WRITE_CONV_0 = 4'd2;
parameter READ_CONV_1  = 4'd3;
parameter WRITE_CONV_1 = 4'd4;
parameter READ_MAX_0   = 4'd5;
parameter WRITE_MAX_0  = 4'd6;
parameter READ_MAX_1   = 4'd7;
parameter WRITE_MAX_1  = 4'd8;
parameter READ_FLAT_0  = 4'd9;
parameter WRITE_FLAT_0 = 4'd10;
parameter READ_FLAT_1  = 4'd11;
parameter WRITE_FLAT_1 = 4'd12;
parameter FINISH       = 4'd13;

// // kernal_0 & kernal_1
// parameter kernal_0_1 = 20'h0A89E; parameter kernal_0_2 = 20'h092D5; parameter kernal_0_3 = 20'h06D43;
// parameter kernal_0_4 = 20'h01004; parameter kernal_0_5 = 20'hF8F71; parameter kernal_0_6 = 20'hF6E54;
// parameter kernal_0_7 = 20'hFA6D7; parameter kernal_0_8 = 20'hFC834; parameter kernal_0_9 = 20'hFAC19;

// parameter kernal_1_1 = 20'hFDB55; parameter kernal_1_2 = 20'h02992; parameter kernal_1_3 = 20'hFC994;
// parameter kernal_1_4 = 20'h050FD; parameter kernal_1_5 = 20'h02F20; parameter kernal_1_6 = 20'h0202D;
// parameter kernal_1_7 = 20'h03BD7; parameter kernal_1_8 = 20'hFD369; parameter kernal_1_9 = 20'h05E68;

// // bias_0 & bias_1
// parameter bias_0 = 20'h01310;
// parameter bias_1 = 20'hF7295;


reg         [3:0] cur_state;
reg         [3:0] nxt_state;

reg         [5:0] x;
reg         [5:0] y;
reg         [5:0] x_wr;
reg         [5:0] y_wr;
wire        [5:0] x_before;
wire        [5:0] x_after;
wire        [5:0] y_before;
wire        [5:0] y_after;

reg         [3:0] counter;

reg signed  [19:0] kernal;
reg signed  [19:0] bias;

reg signed  [43:0] conv_value;	// 2^20 * 2^20 * 2^4 = 2^44, multiply by 9 pixels will increase 4 bits
								// 4 bits integer * 4 bits integer * 9 -> 12 bits integer
								// retrieve 4 bits integer & 17 bits fraction -> [35:15]
wire signed [20:0] round_value;


// nxt_state
always @(*) begin
	case (cur_state)
		IDLE: begin
			if(ready)
				nxt_state = READ_CONV_0;
			else
				nxt_state = IDLE;
		end

		READ_CONV_0: begin
			if(counter == 4'd11)			// 1 clock cycle late for reading data from memory
											// 1~9 for calculate with kernal, 10 for bias, 11 for ReLU
				nxt_state = WRITE_CONV_0;
			else
				nxt_state = READ_CONV_0;
		end

		WRITE_CONV_0: begin
			if(x == 6'd63 && y == 6'd63)
				nxt_state = READ_CONV_1;
			else
				nxt_state = READ_CONV_0;
		end

		READ_CONV_1: begin
			if(counter == 4'd11)
				nxt_state = WRITE_CONV_1;
			else
				nxt_state = READ_CONV_1;
		end

		WRITE_CONV_1: begin
			if(x == 6'd63 && y == 6'd63)
				nxt_state = READ_MAX_0;
			else
				nxt_state = READ_CONV_1;
		end

		READ_MAX_0: begin
			if(counter == 4'd4)
				nxt_state = WRITE_MAX_0;
			else
				nxt_state = READ_MAX_0;
		end

		WRITE_MAX_0: begin
			if(x == 6'd62 && y == 6'd62)
				nxt_state = READ_MAX_1;
			else
				nxt_state = READ_MAX_0;
		end

		READ_MAX_1: begin
			if(counter == 4'd4)
				nxt_state = WRITE_MAX_1;
			else
				nxt_state = READ_MAX_1;
		end

		WRITE_MAX_1: begin
			if(x == 6'd62 && y == 6'd62)
				nxt_state = READ_FLAT_0;
			else
				nxt_state = READ_MAX_1;
		end

		READ_FLAT_0: begin
			if(counter == 4'd1)
				nxt_state = WRITE_FLAT_0;
			else
				nxt_state = READ_FLAT_0;
		end

		WRITE_FLAT_0: begin
			if(x_wr == 6'd62 && y_wr == 6'd31)
				nxt_state = READ_FLAT_1;
			else
				nxt_state = READ_FLAT_0;
		end

		READ_FLAT_1: begin
			if(counter == 4'd1)
				nxt_state = WRITE_FLAT_1;
			else
				nxt_state = READ_FLAT_1;
		end

		WRITE_FLAT_1: begin
			if(x_wr == 6'd62 && y_wr == 6'd31)
				nxt_state = FINISH;
			else
				nxt_state = READ_FLAT_1;
		end

		FINISH: begin
			nxt_state = FINISH;
		end

		default:  begin
			nxt_state = IDLE;
		end

	endcase
end

// state register
always @(posedge clk or posedge reset) begin
	if(reset)
		cur_state <= IDLE;
	else
		cur_state <= nxt_state;
end

// // kernal
// always @(posedge clk or posedge reset) begin
// 	if(reset)
// 		kernal <= 20'd0;
// 	else if(cur_state == READ_CONV_0) begin
// 		if(counter == 4'd0)
// 				kernal <= 20'h0A89E;
// 			else if(counter == 4'd1)
// 				kernal <= 20'h092D5;
// 			else if(counter == 4'd2)
// 				kernal <= 20'h06D43;
// 			else if(counter == 4'd3)
// 				kernal <= 20'h01004;
// 			else if(counter == 4'd4)
// 				kernal <= 20'hF8F71;
// 			else if(counter == 4'd5)
// 				kernal <= 20'hF6E54;
// 			else if(counter == 4'd6)
// 				kernal <= 20'hFA6D7;
// 			else if(counter == 4'd7)
// 				kernal <= 20'hFC834;
// 			else if(counter == 4'd8)
// 				kernal <= 20'hFAC19;
// 	end
// 	else if(cur_state == READ_CONV_1) begin
// 		if(counter == 4'd0)
// 				kernal <= 20'hFDB55;
// 			else if(counter == 4'd1)
// 				kernal <= 20'h02992;
// 			else if(counter == 4'd2)
// 				kernal <= 20'hFC994;
// 			else if(counter == 4'd3)
// 				kernal <= 20'h050FD;
// 			else if(counter == 4'd4)
// 				kernal <= 20'h02F20;
// 			else if(counter == 4'd5)
// 				kernal <= 20'h0202D;
// 			else if(counter == 4'd6)
// 				kernal <= 20'h03BD7;
// 			else if(counter == 4'd7)
// 				kernal <= 20'hFD369;
// 			else if(counter == 4'd8)
// 				kernal <= 20'h05E68;
// 	end
// end

// // bias
// always @(posedge clk or posedge reset) begin
// 	if(reset)
// 		bias <= 20'd0;
// 	else if(cur_state == READ_CONV_0) begin
// 		bias <= 20'h01310;
// 	end
// 	else if(cur_state == READ_CONV_1) begin
// 		bias <= 20'hF7295;
// 	end
// end

// kernal
always @(*) begin
	//kernal = 20'd0;
	case (cur_state)
		READ_CONV_0: begin
			if(counter == 4'd1)
				kernal = 20'h0A89E;
			else if(counter == 4'd2)
				kernal = 20'h092D5;
			else if(counter == 4'd3)
				kernal = 20'h06D43;
			else if(counter == 4'd4)
				kernal = 20'h01004;
			else if(counter == 4'd5)
				kernal = 20'hF8F71;
			else if(counter == 4'd6)
				kernal = 20'hF6E54;
			else if(counter == 4'd7)
				kernal = 20'hFA6D7;
			else if(counter == 4'd8)
				kernal = 20'hFC834;
			else if(counter == 4'd9)
				kernal = 20'hFAC19;
			else
				kernal = 20'd0;					
		end

		READ_CONV_1: begin
			if(counter == 4'd1)
				kernal = 20'hFDB55;
			else if(counter == 4'd2)
				kernal = 20'h02992;
			else if(counter == 4'd3)
				kernal = 20'hFC994;
			else if(counter == 4'd4)
				kernal = 20'h050FD;
			else if(counter == 4'd5)
				kernal = 20'h02F20;
			else if(counter == 4'd6)
				kernal = 20'h0202D;
			else if(counter == 4'd7)
				kernal = 20'h03BD7;
			else if(counter == 4'd8)
				kernal = 20'hFD369;
			else if(counter == 4'd9)
				kernal = 20'h05E68;
			else
				kernal = 20'd0;	
		end
		default: begin
			kernal = 20'd0;			
		end
	endcase
end

// bias
always @(*) begin
	//bias = 20'd0;
	case (cur_state)
		READ_CONV_0: begin
			bias = 20'h01310;
		end

		READ_CONV_1: begin
			bias = 20'hF7295;
		end
		default: begin
			bias = 20'd0;			
		end
	endcase
end

// x
always @(posedge clk or posedge reset) begin
	if(reset)
		x <= 6'd0;
	else begin
		if(cur_state == WRITE_CONV_0 || cur_state == WRITE_CONV_1)								// Accumulate by 1
		   begin
				if(x == 6'd63)
					x <= 6'd0;
				else
					x <= x + 6'd1;
		   end
			
		else if(cur_state == WRITE_MAX_0  || cur_state == WRITE_MAX_1 ||
				cur_state == WRITE_FLAT_0 || cur_state == WRITE_FLAT_1)							// Accumulate by 2
			begin
				if(x == 6'd62)
					x <= 6'd0;
				else
					x <= x + 6'd2;
			end
			
	end
end

// y
always @(posedge clk or posedge reset) begin
	if(reset)
		y <= 6'd0;
	else begin
		if(cur_state == WRITE_CONV_0 || cur_state == WRITE_CONV_1)								// Accumulate by 1
		   begin
				if(x == 6'd63)
					y <= y + 6'd1;
		   end
			
		else if(cur_state == WRITE_MAX_0  || cur_state == WRITE_MAX_1 ||
				cur_state == WRITE_FLAT_0 || cur_state == WRITE_FLAT_1)							// Accumulate by 2
			begin
				if(x == 6'd62)
					y <= y + 6'd2;
			end
		// else if(cur_state == WRITE_FLAT_0 || cur_state == WRITE_FLAT_1)
		// 	begin
		// 		if(x == 6'd62)
		// 			y <= y + 6'd1;
		// 	end
	end
end

// x_wr
always @(posedge clk or posedge reset) begin
	if(reset)
		x_wr <= 6'd0;
	else if(cur_state == WRITE_FLAT_0 || cur_state == WRITE_FLAT_1) begin
		if(x_wr == 6'd62)
			x_wr <= 6'd0;
		else
			x_wr <= x_wr + 6'd2;
	end
end

// y_wr
always @(posedge clk or posedge reset) begin
	if(reset)
		y_wr <= 6'd0;
	else if(cur_state == WRITE_FLAT_0 || cur_state == WRITE_FLAT_1) begin
		if(x_wr == 6'd62)
			y_wr <= y_wr + 6'd1;
		else if(y_wr == 6'd31 && x_wr == 6'd62)
			y_wr <= 6'd0;
	end
end

// counter
always @(posedge clk or posedge reset) begin
	if(reset)
		counter <= 4'd0;
	else if(ready)
		counter <= 4'd0;
	else if(cur_state == WRITE_CONV_0 || cur_state == WRITE_CONV_1 ||							// Reset to 0
	        cur_state == WRITE_MAX_0  || cur_state == WRITE_MAX_1  ||
			cur_state == WRITE_FLAT_0 || cur_state == WRITE_FLAT_1)
		counter <= 4'd0;
	else
		counter <= counter + 4'd1;
end

// busy
always @(posedge clk or posedge reset) begin
	if(reset)
		busy <= 1'd0;
	else if(cur_state == FINISH)
		busy <= 1'd0;
	else if(ready)
		busy <= 1'd1;
end

// iaddr
always @(posedge clk or posedge reset) begin
	if(reset)
		iaddr <= 12'd0;
	else if(cur_state == READ_CONV_0 || cur_state == READ_CONV_1) begin
		if(counter == 4'd0)
			iaddr <= {y_before, x_before};
		else if(counter == 4'd1)
			iaddr <= {y_before, x};
		else if(counter == 4'd2)
			iaddr <= {y_before, x_after};
		else if(counter == 4'd3)
			iaddr <= {y, x_before};
		else if(counter == 4'd4)
			iaddr <= {y, x};
		else if(counter == 4'd5)
			iaddr <= {y, x_after};
		else if(counter == 4'd6)
			iaddr <= {y_after, x_before};
		else if(counter == 4'd7)
			iaddr <= {y_after, x};
		else if(counter == 4'd8)
			iaddr <= {y_after, x_after};
	end
end

// crd
always @(posedge clk or posedge reset) begin
	if(reset)
		crd <= 1'd0;
	else if(cur_state == READ_CONV_0 || cur_state == READ_CONV_1 ||
	        cur_state == READ_MAX_0  || cur_state == READ_MAX_1  ||
			cur_state == READ_FLAT_0 || cur_state == READ_FLAT_1)
		crd <= 1'd1;
end

// caddr_rd
always @(posedge clk or posedge reset) begin
	if(reset)
		caddr_rd <= 12'd0;
	else if (cur_state == READ_MAX_0 || cur_state == READ_MAX_1) begin
		if(counter == 4'd0)
			caddr_rd <= {y, x};
		else if(counter == 4'd1)
			caddr_rd <= {y, x_after};
		else if(counter == 4'd2)
			caddr_rd <= {y_after, x};
		else if(counter == 4'd3)
			caddr_rd <= {y_after, x_after};
	end
	else if(cur_state == READ_FLAT_0 || cur_state == READ_FLAT_1) begin
		caddr_rd <= {y[5:1], x[5:1]};
	end
end

// caddr_wr
always @(posedge clk or posedge reset) begin
	if(reset)
		caddr_wr <= 12'd0;
	else if(cur_state == WRITE_CONV_0 || cur_state == WRITE_CONV_1)
		caddr_wr <= {y, x};
	else if(cur_state == WRITE_MAX_0  || cur_state == WRITE_MAX_1)
		caddr_wr <= {y[5:1], x[5:1]};
	else if(cur_state == WRITE_FLAT_0)
		caddr_wr <= {y_wr, x_wr};
	else if(cur_state == WRITE_FLAT_1)
		caddr_wr <= {y_wr, x_wr} + 12'd1;
end

// conv_value
always @(posedge clk or posedge reset) begin
	if(reset)
		conv_value <= 44'd0;
	else if(cur_state == READ_CONV_0 || cur_state == READ_CONV_1) begin
		if(counter == 4'd1 && (x != 6'd0 && y != 6'd0))
			conv_value <= conv_value + idata * kernal;
		else if(counter == 4'd2 && (y != 6'd0))
			conv_value <= conv_value + idata * kernal;
		else if(counter == 4'd3 && (x != 6'd63 && y != 6'd0))
			conv_value <= conv_value + idata * kernal;
		else if(counter == 4'd4 && (x != 6'd0))
			conv_value <= conv_value + idata * kernal;
		else if(counter == 4'd5)
			conv_value <= conv_value + idata * kernal;
		else if(counter == 4'd6 && (x != 6'd63))
			conv_value <= conv_value + idata * kernal;
		else if(counter == 4'd7 && (x != 6'd0 && y != 6'd63))
			conv_value <= conv_value + idata * kernal;
		else if(counter == 4'd8 && (y != 6'd63))
			conv_value <= conv_value + idata * kernal;
		else if(counter == 4'd9 && (x != 6'd63 && y != 6'd63))
			conv_value <= conv_value + idata * kernal;						// conv_value is [43:0], conv_value[35:15] is 4 bits integer, 16 bits fraction, and last bit for rounding
		else if(counter == 4'd10)
			conv_value <= conv_value + {bias, 16'd0};						// bias is [19:0]. For calculation, conv_value[35:15] + {bias[35:16], 0}, so bias have to left shift 16 bits 0
	end
	else if(cur_state == WRITE_CONV_0 || cur_state == WRITE_CONV_1) begin
		conv_value <= 44'd0;
	end
end

// cdata_wr
always @(posedge clk or posedge reset) begin
	if(reset)
		cdata_wr <= 20'd0;
	else if(cur_state == WRITE_CONV_0 || cur_state == WRITE_CONV_1) begin
		if(round_value[20])
			cdata_wr <= 20'd0;
		else
			cdata_wr <= round_value[20:1];
	end
	else if(cur_state == READ_MAX_0  || cur_state == READ_MAX_1) begin
		if(counter == 4'd1)
			cdata_wr <= cdata_rd;
		else
			cdata_wr <= (cdata_wr > cdata_rd)? cdata_wr : cdata_rd;
	end
	else if(cur_state == WRITE_FLAT_0 || cur_state == WRITE_FLAT_1)
		cdata_wr <= cdata_rd;
end

// csel
always @(posedge clk or posedge reset) begin
	if(reset)
		csel <= 3'd0;
	else if(cur_state == WRITE_CONV_0 || cur_state == READ_MAX_0)
		csel <= 3'd1;
	else if(cur_state == WRITE_CONV_1 || cur_state == READ_MAX_1)
		csel <= 3'd2;
	else if(cur_state == WRITE_MAX_0  || cur_state == READ_FLAT_0)
		csel <= 3'd3;
	else if(cur_state == WRITE_MAX_1  || cur_state == READ_FLAT_1)
		csel <= 3'd4;
	else if(cur_state == WRITE_FLAT_0 || cur_state == WRITE_FLAT_1)
		csel <= 3'd5;
end

// cwr
always @(posedge clk or posedge reset) begin
	if(reset)
		cwr <= 1'd0;
	else if(cur_state == WRITE_CONV_0 || cur_state == WRITE_CONV_1 ||
	        cur_state == WRITE_MAX_0  || cur_state == WRITE_MAX_1  ||
			cur_state == WRITE_FLAT_0 || cur_state == WRITE_FLAT_1)
		cwr <= 1'd1;
	else
		cwr <= 1'd0;
end

// x_before, x_after, y_before, y_after
assign x_before = x - 6'd1;
assign x_after  = x + 6'd1;
assign y_before = y - 6'd1;
assign y_after  = y + 6'd1;

// round_value
assign round_value = conv_value[35:15] + 21'd1;

endmodule

