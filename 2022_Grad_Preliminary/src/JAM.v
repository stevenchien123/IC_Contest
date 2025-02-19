module JAM (
input CLK,
input RST,
output reg [2:0] W,
output reg [2:0] J,
input [6:0] Cost,
output reg [3:0] MatchCount,
output reg [9:0] MinCost,
output reg Valid );

/*****
    The application of the Job Assignment Machine (JAM) is quite extensive.  
    When there are n tasks to be completed, and n workers have varying costs for each task,
    determining how to assign each worker to a task in order to minimize the overall cost
    is the primary objective of the JAM.  

    The most straightforward approach to solving the job assignment problem is to
    calculate the cost for all possible combinations and then
    identify the combination with the lowest cost.  

    In this question, input data regarding worker task costs will be provided,
    and participants are required to enumerate all possible pairings using an exhaustive search method. 

    Subsequently, they should find the lowest cost and determine the number of combinations
    that achieve this lowest cost.
*****/

parameter IDLE       = 4'd0;
parameter CAL1       = 4'd1;    // find switch point
parameter CAL2       = 4'd2;    // find the index that is at the right side of switch point and
                                // the index's value is bigger than the switch point's value
parameter CAL3       = 4'd3;    // swap the index's & the switch point's value
parameter CAL4       = 4'd4;    // reverse the right side of switch point
parameter UPT_ASSIGN = 4'd5;    // update MinCost & assign nxt_seq to cur_seq
parameter FINISH     = 4'd6;


reg [3:0] current_state;    // FSM
reg [3:0] next_state;

reg [2:0] cur_seq [7:0];    // for calculate cost
reg [3:0] counter_cost;
reg [9:0] cost_sum;

reg [2:0] nxt_seq [7:0];    // for calculate next sequence
reg [2:0] counter_seq;
reg [2:0] switch_point_index;
reg [2:0] switch_point_min_index;

reg       flag;				// for CAL4, only reverse the right side of the switch point one time


// next state logic
always @(*) begin
    case (current_state)
        IDLE:
            if(RST) next_state = IDLE;
            else    next_state = CAL1;
        CAL1:
            next_state = CAL2;
        CAL2:
            if(counter_seq == switch_point_index - 1)
                next_state = CAL3;
            else
                next_state = CAL2;
        CAL3:
            next_state = CAL4;
        CAL4:
            if(counter_cost == 4'd8)
                next_state = UPT_ASSIGN;
            else
                next_state = CAL4;
        UPT_ASSIGN:
            if(cur_seq[0] == 3'd0 && cur_seq[1] == 3'd1 && cur_seq[2] == 3'd2
            && cur_seq[3] == 3'd3 && cur_seq[4] == 3'd4 && cur_seq[5] == 3'd5
            && cur_seq[6] == 3'd6 && cur_seq[7] == 3'd7)
                 next_state = FINISH;
            else next_state = CAL1;
        FINISH:
            next_state = FINISH;
        default:
            next_state = IDLE;
    endcase
end

// state register
always @(posedge CLK) begin
    if(RST) current_state <= IDLE;
    else    current_state <= next_state;
end

// nxt_seq & cur_seq
always @(posedge CLK) begin
    if(RST) begin
        cur_seq[0] <= 3'd7;
        cur_seq[1] <= 3'd6;
        cur_seq[2] <= 3'd5;
        cur_seq[3] <= 3'd4;
        cur_seq[4] <= 3'd3;
        cur_seq[5] <= 3'd2;
        cur_seq[6] <= 3'd1;
        cur_seq[7] <= 3'd0;

        nxt_seq[0] <= 3'd7;
        nxt_seq[1] <= 3'd6;
        nxt_seq[2] <= 3'd5;
        nxt_seq[3] <= 3'd4;
        nxt_seq[4] <= 3'd3;
        nxt_seq[5] <= 3'd2;
        nxt_seq[6] <= 3'd1;
        nxt_seq[7] <= 3'd0;
        switch_point_index       <= 3'd0;
        switch_point_min_index   <= 3'd0;
    end
    else begin
        case (current_state)
            CAL1: begin                                 // find switch point
                if(nxt_seq[0] > nxt_seq[1]) begin
                    switch_point_index     <= 3'd1;
                    switch_point_min_index <= 3'd0;     // 0 is at the right side of 1 and
                                                        // nxt_seq[0] is bigger than nxt_seq[1]
                end
                else if(nxt_seq[1] > nxt_seq[2]) begin
                    switch_point_index     <= 3'd2;
                    switch_point_min_index <= 3'd1;
                end
                else if(nxt_seq[2] > nxt_seq[3]) begin
                    switch_point_index     <= 3'd3;
                    switch_point_min_index <= 3'd2;
                end
                else if(nxt_seq[3] > nxt_seq[4]) begin
                    switch_point_index     <= 3'd4;
                    switch_point_min_index <= 3'd3;
                end
                else if(nxt_seq[4] > nxt_seq[5]) begin
                    switch_point_index     <= 3'd5;
                    switch_point_min_index <= 3'd4;
                end
                else if(nxt_seq[5] > nxt_seq[6]) begin
                    switch_point_index     <= 3'd6;
                    switch_point_min_index <= 3'd5;
                end
                else if(nxt_seq[6] > nxt_seq[7]) begin
                    switch_point_index     <= 3'd7;
                    switch_point_min_index <= 3'd6;
                end
            end

            CAL2: begin                                 // find the index that is at the right side of switch point and
                                                        // the index's value is bigger than the switch point's value
                if(nxt_seq[counter_seq] < nxt_seq[switch_point_min_index] &&
                   nxt_seq[counter_seq] > nxt_seq[switch_point_index])
                    switch_point_min_index <= counter_seq;
            end

            CAL3: begin                                 // swap the index's & the switch point's value
                nxt_seq[switch_point_index]     <= nxt_seq[switch_point_min_index];
                nxt_seq[switch_point_min_index] <= nxt_seq[switch_point_index];
            end

            CAL4: begin                                 // reverse the right side of switch point
                if (flag == 1'd0) begin
                    if(switch_point_index == 3'd2) begin
                        nxt_seq[1] <= nxt_seq[0];
                        nxt_seq[0] <= nxt_seq[1];
                    end
                    else if(switch_point_index == 3'd3) begin
                        nxt_seq[2] <= nxt_seq[0];
                        nxt_seq[0] <= nxt_seq[2];
                    end
                    else if(switch_point_index == 3'd4) begin
                        nxt_seq[3] <= nxt_seq[0];
                        nxt_seq[0] <= nxt_seq[3];
                        nxt_seq[2] <= nxt_seq[1];
                        nxt_seq[1] <= nxt_seq[2];
                    end
                    else if(switch_point_index == 3'd5) begin
                        nxt_seq[4] <= nxt_seq[0];
                        nxt_seq[0] <= nxt_seq[4];
                        nxt_seq[3] <= nxt_seq[1];
                        nxt_seq[1] <= nxt_seq[3];
                    end
                    else if(switch_point_index == 3'd6) begin
                        nxt_seq[5] <= nxt_seq[0];
                        nxt_seq[0] <= nxt_seq[5];
                        nxt_seq[4] <= nxt_seq[1];
                        nxt_seq[1] <= nxt_seq[4];
                        nxt_seq[3] <= nxt_seq[2];
                        nxt_seq[2] <= nxt_seq[3];
                    end
                    else if(switch_point_index == 3'd7) begin
                        nxt_seq[6] <= nxt_seq[0];
                        nxt_seq[0] <= nxt_seq[6];
                        nxt_seq[5] <= nxt_seq[1];
                        nxt_seq[1] <= nxt_seq[5];
                        nxt_seq[4] <= nxt_seq[2];
                        nxt_seq[2] <= nxt_seq[4];
                    end
                end
            end

            UPT_ASSIGN: begin
                cur_seq[0] <= nxt_seq[0];
                cur_seq[1] <= nxt_seq[1];
                cur_seq[2] <= nxt_seq[2];
                cur_seq[3] <= nxt_seq[3];
                cur_seq[4] <= nxt_seq[4];
                cur_seq[5] <= nxt_seq[5];
                cur_seq[6] <= nxt_seq[6];
                cur_seq[7] <= nxt_seq[7];
            end

            default:                                    // do nothing...
                nxt_seq[0] <= nxt_seq[0];
        endcase
    end
end


// cost_sum
always @(posedge CLK) begin
    if(RST)
        cost_sum <= 10'd0;
    else begin
        if(counter_cost == 4'd0)
            cost_sum <= 10'd0;
        else
            cost_sum <= cost_sum + Cost;
    end
end

// counter_cost
always @(posedge CLK) begin
    if(RST)
        counter_cost <= 3'd0;
    else if(current_state == UPT_ASSIGN)    // reset to 0
        counter_cost <= 3'd0;
    else
        counter_cost <= counter_cost + 3'd1;
end

// W
always @(*) begin
    W = counter_cost;
end

// J
always @(*) begin
    J = cur_seq[counter_cost];
end

// MinCost & MatchCount
always @(posedge CLK) begin
    if(RST) begin
        MinCost    <= 10'b1111111111;
        MatchCount <= 4'd0;
    end
    else begin
        if(current_state == UPT_ASSIGN) begin
            if(MinCost > cost_sum) begin
                MinCost    <= cost_sum;
                MatchCount <= 4'd1;
            end
            else if(MinCost == cost_sum) begin
                MatchCount <= MatchCount + 4'd1;
            end
        end
    end
end

// counter_seq
always @(posedge CLK) begin
    if(RST)
        counter_seq <= 3'd0;
    else if (current_state == CAL2)
        counter_seq <= counter_seq + 3'd1;
    else
        counter_seq <= 3'd0;
end

// flag
always @(posedge CLK) begin
    if(RST)
        flag <= 1'd0;
    else if(current_state == CAL4)
        flag <= 1'd1; 
    else
        flag <= 1'd0;
end

// Valid
always @(posedge CLK) begin
    if(RST) Valid <= 1'd0;
    else begin
        if(current_state == FINISH)
            Valid <= 1'd1;
    end
end

endmodule
