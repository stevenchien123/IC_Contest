module DT(
	input 					clk, 
	input					reset,
	output	reg				done ,
	output	reg				sti_rd ,
	output	reg 	[ 9:0]	sti_addr ,
	input			[15:0]	sti_di,
	output	reg				res_wr ,
	output	reg				res_rd ,
	output	reg 	[13:0]	res_addr ,
	output	reg 	[ 7:0]	res_do,
	input			[ 7:0]	res_di
	);

// states
	parameter READ_DATA      = 4'd0;	// read data from sti_ROM
	parameter WRITE_DATA     = 4'd1;	// write the data that read from sti_ROM to res_RAM
	parameter RW_DATA_FINISH = 4'd2;	// reset values
	parameter READ_FORWARD   = 4'd3;	// read forward pass window data from res_RAM & calculate forward data
	parameter WRITE_FORWARD  = 4'd4;	// write forward data to res_RAM
	parameter FORWARD_FINISH = 4'd5;
	parameter READ_BACKWARD  = 4'd6;	// read backward pass window data from res_RAM & calculate backward data
	parameter WRITE_BACKWARD = 4'd7;	// write backward data to res_RAM
	parameter FINISH         = 4'd8;	// finish all the process


// wire & reg
	reg [3:0] cur_state;	// for FSM
	reg [3:0] nxt_state;

	reg [3:0] idx_wr;		// for WRITE_DATA, from 0~15, write res_RAM

	reg [2:0] counter;		// for READ_FORWARD, from -1~4, -1: No data yet, 0:wait for res_di_temp, 1: NW, 2:N, 3:NE, 4:W
							// for READ_BACKWARD, from -1~5, -1: No data yet, 0: wait for res_di_temp, 1:SE, 2:S, 3:SW, 4:E, 5:(x,y)
	
	reg       counter_wr;	// for WRITE_FORWARD & WRITE_BACKWARD, delay 1 clock
	reg [3:0] counter_rd_w; // for WRITE_DATA

	reg [7:0] res_di_temp;

// FSM
  // nxt_state logic
	always @(*) begin
		case (cur_state)
			READ_DATA: 
				nxt_state = WRITE_DATA;

			WRITE_DATA: begin
				if(counter_rd_w == 4'd15)	begin				// read the last data & write the last bit of data
					if(sti_addr == 10'd1023)
						nxt_state = RW_DATA_FINISH;
					else
						nxt_state = READ_DATA;
				end
				else
					nxt_state = WRITE_DATA;
			end

			RW_DATA_FINISH: begin
				nxt_state = READ_FORWARD;
			end
				
			READ_FORWARD: begin
				if(counter == 3'd4)
					nxt_state = WRITE_FORWARD;
				else if(res_addr == 14'd16255)
					nxt_state = FORWARD_FINISH;
				else
					nxt_state = READ_FORWARD;
			end

			WRITE_FORWARD: begin
				if(res_addr == 14'd16254)				// (x,y) = (126,126)
					nxt_state = FORWARD_FINISH;
				else if(counter_wr == 1'd1)
					nxt_state = READ_FORWARD;
			end

			FORWARD_FINISH: begin
				nxt_state = READ_BACKWARD;
			end

			READ_BACKWARD: begin
				if(counter == 3'd4)
					nxt_state = WRITE_BACKWARD;
				else if(res_addr == 14'd128)
					nxt_state = FINISH;
				else	
					nxt_state = READ_BACKWARD;
			end

			WRITE_BACKWARD: begin
				if(res_addr == 14'd129)					// (x,y) = (1,1)
					nxt_state = FINISH;
				else if(counter_wr == 1'd1)
					nxt_state = READ_BACKWARD;
			end

			default: 
				nxt_state = READ_DATA;
		endcase
	end

  // state register
	always @(posedge clk or negedge reset) begin
		if(!reset)
			cur_state <= READ_DATA;
		else
			cur_state <= nxt_state;
	end

// sti_rd
	always @(posedge clk or negedge reset) begin
		if(!reset)
			sti_rd <= 1'd0;
		else if(cur_state == READ_DATA)
			sti_rd <= 1'd1;
		else
			sti_rd <= 1'd0;
	end

// sti_addr
	always @(posedge clk or negedge reset) begin
		if(!reset)
			sti_addr <= 10'd1023;
		else if(cur_state == READ_DATA)
			sti_addr <= sti_addr + 10'd1;
	end

// res_rd
	always @(posedge clk or negedge reset) begin
		if(!reset)
			res_rd <= 1'd0;
		else if(cur_state == READ_FORWARD   || cur_state == READ_BACKWARD ||
		        cur_state == RW_DATA_FINISH || cur_state == FORWARD_FINISH)
			res_rd <= 1'd1;
		else if((cur_state == WRITE_FORWARD && counter_wr == 1'd1) ||
		        (cur_state == WRITE_BACKWARD && counter_wr == 1'd1))
			res_rd <= 1'd1;
		else
			res_rd <= 1'd0;
	end

// res_wr
	always @(posedge clk or negedge reset) begin
		if(!reset)
			res_wr <= 1'd0;
		else if(cur_state == WRITE_DATA || ((cur_state == WRITE_FORWARD || cur_state == WRITE_BACKWARD) && counter_wr == 1'd0))
			res_wr <= 1'd1;
		else
			res_wr <= 1'd0;
	end

// idx_wr
	always @(posedge clk or negedge reset) begin
		if(!reset)
			idx_wr <= 4'd15;
		else if(cur_state == WRITE_DATA) begin
			if(idx_wr == 4'd0)
				idx_wr <= idx_wr;
			else
				idx_wr <= idx_wr - 4'd1;
		end
		else
			idx_wr <= 4'd15;
	end

// res_addr
	always @(posedge clk or negedge reset) begin
		if(!reset)
			res_addr <= 14'd0;
		else if(cur_state == WRITE_DATA) begin
			if(counter == 3'd1)
				res_addr <= res_addr + 14'd1;
		end
		else if(cur_state == RW_DATA_FINISH)
			res_addr <= 14'd129;
		else if(cur_state == READ_FORWARD) begin
			case(counter)
				3'd0: begin								// (x,y), to check if (x,y) is object
					if(res_di == 8'd0)
						res_addr <= res_addr + 14'd1;
					else								// NW
						res_addr <= res_addr - 14'd129;
				end
				3'd1:									// N
					res_addr <= res_addr + 14'd1;

				3'd2:									// NE
					res_addr <= res_addr + 14'd1;

				3'd3:									// W
					res_addr <= res_addr + 14'd126;

			endcase
		end
		else if(cur_state == WRITE_FORWARD) begin
			// if(nxt_state == READ_FORWARD)			// NW, new round of forward operation, update res_addr
			// 	res_addr <= res_addr - 14'd128;
			// else if(nxt_state == READ_BACKWARD)		// WRITE_FORWARD finish, nxt_state = READ_BACKWARD, reset res_addr to 16254
			// 	res_addr <= 14'd16254;
			res_addr <= res_addr + 14'd1;			// update res_addr for writing backward value
		end
		else if(cur_state == FORWARD_FINISH)
			res_addr <= 14'd16254;
		else if(cur_state == READ_BACKWARD) begin
			case(counter)
				3'd0: begin								// (x,y)
					if(res_di == 8'd0)
						res_addr <= res_addr - 14'd1;
					else 								// SE
						res_addr <= res_addr + 14'd129;
				end

				3'd1: 									// S
					res_addr <= res_addr - 14'd1;

				3'd2:									// SW
					res_addr <= res_addr - 14'd1;

				3'd3:									// E
					res_addr <= res_addr - 14'd126;

			endcase
		end
		else if(cur_state == WRITE_BACKWARD) begin
			res_addr <= res_addr - 14'd1;			// update res_addr for writing backward value
		end
	end

// res_do
	always @(posedge clk or negedge reset) begin
		if(!reset)
			res_do <= 8'd0;
		else if(cur_state == WRITE_DATA)
			res_do <= sti_di[idx_wr];
		else if(cur_state == READ_FORWARD) begin
			if(counter == 3'd1)						// NW, direactly assign the first value to res_do
				res_do <= res_di;
			else if(counter == 3'd4) begin			// W, add 1 at the last value
				if(res_do < res_di)
					res_do <= res_do + 8'd1;
				else
					res_do <= res_di + 8'd1;
			end
			else									// others, compare
				res_do <= (res_do < res_di)? res_do : res_di;
		end
		else if(cur_state == READ_BACKWARD) begin
			if(counter == 3'd0)						// (x,y), direactly assign the first value to res_do
				res_do <= res_di;
			else									// others, compare add 1 values
				res_do <= (res_do < res_di + 8'd1)? res_do : res_di + 8'd1;
		end
	end

// res_di_temp (reduce the critical path)
	// always @(posedge clk or negedge reset) begin
	// 	if(!reset)
	// 		res_di_temp <= 8'd0;
	// 	else if(cur_state == READ_FORWARD || cur_state == READ_BACKWARD)
	// 		res_di_temp <= res_di;
	// 	else
	// 		res_di_temp <= 8'd0;
	// end

// counter
	always @(posedge clk or negedge reset) begin
		if(!reset)
			counter <= 3'd0;
		else if(cur_state == WRITE_DATA) begin
			if(counter == 3'd1)
				counter <= counter;
			else
				counter <= counter + 3'd1;
		end
		else if(cur_state == READ_FORWARD || cur_state == READ_BACKWARD) begin
			if(counter == 3'd0 && res_di == 8'd0)
				counter <= 3'd0;
			else
				counter <= counter + 3'd1;
		end
		else
			counter <= 3'd0;
	end

// counter_wr
	always @(posedge clk or negedge reset) begin
		if(!reset)
			counter_wr <= 1'd0;
		else if(cur_state == WRITE_FORWARD || cur_state == WRITE_BACKWARD)
			counter_wr <= counter_wr + 1'd1;
	end

// counter_rd_w
	always @(posedge clk or negedge reset) begin
		if(!reset)
			counter_rd_w <= 4'd0;
		else if(cur_state == WRITE_DATA && counter == 3'd1)
			counter_rd_w <= counter_rd_w + 4'd1;
		else
			counter_rd_w <= 4'd0;
	end

// done
	always @(posedge clk or negedge reset) begin
		if(!reset)
			done <= 1'd0;
		else if(cur_state == FINISH)
			done <= 1'd1;
		else 
			done <= 1'd0;
	end

endmodule
