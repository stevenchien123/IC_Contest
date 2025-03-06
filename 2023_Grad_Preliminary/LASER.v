module LASER (
    input            CLK,
    input            RST,
    input      [3:0] X,
    input      [3:0] Y,
    output reg [3:0] C1X,
    output reg [3:0] C1Y,
    output reg [3:0] C2X,
    output reg [3:0] C2Y,
    output           DONE
);

/*************************

    The question assumes a fixed area of 16x16 with 40 targets.
    Only two laser shots are allowed on this area,
    and the lasers have a circular shape with a radius of 4.
    
    Please find the positions of the centers of these two circles such that
    they cover the maximum number of targets.

*************************/

// state definition
    parameter READ      = 3'd0;   // read input data
    parameter CIRCLE1   = 3'd1;   // traverse all index (x, y)
    parameter ASSIGN1   = 3'd2;   // assign (best_X, best_Y) to (C1X, C1Y) & update flag_1
    parameter CIRCLE2   = 3'd3;   // traverse all index (x, y)
    parameter ASSIGN2   = 3'd4;   // assign (best_X, best_Y) to (C2X, C2Y) & update flag_2
    parameter FINISH    = 3'd5;   // when DONE setted


// wire & reg
    wire signed [8:0] distance_temp_1; // distance from (temp_X, temp_Y) to point index counter_rd
    wire signed [8:0] distance_temp_2; // distance from (temp_X, temp_Y) to point index counter_rd + 1
    wire signed [8:0] distance1_1;     // distance from (C1X, C1Y) to point index counter_rd
    wire signed [8:0] distance2_1;     // distance from (C2X, C2Y) to point index counter_rd
    wire signed [8:0] distance1_2;     // distance from (C1X, C1Y) to point index counter_rd + 1
    wire signed [8:0] distance2_2;     // distance from (C2X, C2Y) to point index counter_rd + 1

    reg  [2:0] cur_state;
    reg  [2:0] nxt_state;

    reg  [3:0] temp_X;
    reg  [3:0] temp_Y;

    reg  [9:0] prev_max_points;  // the previous maximum number of points inside circle1 & circle2
    reg  [9:0] prev_max_points1; // the previous maximum number of points inside circle1
    reg  [9:0] prev_max_points2; // the previous maximum number of points inside circle2
    reg  [9:0] count_points;     // count how many points inside circle1 & circle2
    reg  [9:0] count_points1;    // count how many points inside circle1
    reg  [9:0] count_points2;    // count how many points inside circle2
    reg  [9:0] max_points;       // maximum number of points inside circle1 & circle2

    reg  [3:0] store_X [39:0];   // store the input data: X
    reg  [3:0] store_Y [39:0];   // store the input data: Y

    reg  [5:0] counter_rd;       // count from 0 to 39
    reg  [2:0] counter;




// FSM
  // nxt_state logic
    always @(*) begin
        case (cur_state)
            READ: begin
                if(counter_rd == 6'd39)
                    nxt_state = CIRCLE1;
                else
                    nxt_state = READ;
            end

            CIRCLE1: begin
                if(temp_X == 4'd15 && temp_Y == 4'd15 && counter_rd == 6'd40)
                    nxt_state = ASSIGN1;
                else
                    nxt_state = CIRCLE1;
            end

            ASSIGN1:
                if(counter_rd == 6'd1) begin
                    if(DONE)
                    nxt_state = READ;
                    else
                        nxt_state = CIRCLE2;
                end
                else
                    nxt_state = ASSIGN1;

            CIRCLE2: begin
                if(temp_X == 4'd15 && temp_Y == 4'd15 && counter_rd == 6'd40)
                    nxt_state = ASSIGN2;
                else
                    nxt_state = CIRCLE2;
            end

            ASSIGN2:
                if(counter_rd == 6'd1) begin
                    if(DONE)
                    nxt_state = READ;
                    else
                        nxt_state = CIRCLE1;
                end
                else
                    nxt_state = ASSIGN2;

            default: 
                nxt_state = READ;
        endcase
    end

  // state register
    always @(posedge CLK) begin
        if(RST)
            cur_state <= READ;
        else
            cur_state <= nxt_state;
    end


// counter_rd
    always @(posedge CLK) begin
        if(RST)
            counter_rd <= 6'd0;
        else if(cur_state == ASSIGN1 || cur_state == ASSIGN2) begin
            if(counter_rd == 6'd1)
                counter_rd <= 6'd0;
            else
                counter_rd <= counter_rd + 6'd1;
        end
        else if(cur_state == READ) begin
            if(counter_rd == 6'd39)
                counter_rd <= 6'd0;
            else if(~DONE)
                counter_rd <= counter_rd + 6'd1;
        end
        else begin
            if(counter_rd == 6'd40)
                counter_rd <= 6'd0;
            else if(~DONE)
                counter_rd <= counter_rd + 6'd2;
        end
    end


// store_X
    integer idx;
    always @(posedge CLK) begin
        if(RST) begin
            for(idx=0; idx<40; idx=idx+1)
                store_X[idx] <= 4'd0;
        end
        else if(cur_state == READ)
            store_X[counter_rd] <= X;
    end


// store_Y
    always @(posedge CLK) begin
        if(RST) begin
            for(idx=0; idx<40; idx=idx+1)
                store_Y[idx] <= 4'd0;
        end
        else if(cur_state == READ)
            store_Y[counter_rd] <= Y;
    end


// temp_X & temp_Y
    always @(posedge CLK) begin
        if(RST) begin
            temp_X <= 4'd0;
            temp_Y <= 4'd0;
        end
        else if(cur_state == CIRCLE1 || cur_state == CIRCLE2) begin
            if(counter_rd == 6'd40) begin
                if(temp_X == 4'd15) begin
                    temp_X <= 4'd0;
                    temp_Y <= temp_Y + 4'd1;
                end
                else
                    temp_X <= temp_X + 4'd1;
            end
            else begin
                temp_X <= temp_X;
                temp_Y <= temp_Y; 
            end
        end
        else if(cur_state == ASSIGN1 || cur_state == ASSIGN2) begin
            temp_X <= 4'd0;
            temp_Y <= 4'd0;
        end
        else if(DONE) begin
            temp_X <= 4'd0;
            temp_Y <= 4'd0;
        end   
    end


// C1X & C1Y
    always @(posedge CLK) begin
        if(RST) begin
            C1X <= 4'd0;
            C1Y <= 4'd0;
        end
        else if(cur_state == CIRCLE1) begin
            if(count_points >= max_points) begin
                C1X <= temp_X;
                C1Y <= temp_Y;
            end
        end
        else if(cur_state == READ) begin
            C1X <= 4'd0;
            C1Y <= 4'd0;
        end
    end


// C2X & C2Y
    always @(posedge CLK) begin
        if(RST) begin
            C2X <= 4'd0;
            C2Y <= 4'd0;
        end
        else if(cur_state == CIRCLE2) begin
            if(count_points >= max_points) begin
                C2X <= temp_X;
                C2Y <= temp_Y;
            end
        end
        else if(cur_state == READ) begin
            C2X <= 4'd0;
            C2Y <= 4'd0;
        end
    end


// prev_max_points
    always @(posedge CLK) begin
        if(RST)
            prev_max_points <= 10'd0;
        else if((cur_state == ASSIGN1 || cur_state == ASSIGN2) && counter_rd == 6'd0)
            prev_max_points <= max_points;
        else if(cur_state == READ)
            prev_max_points <= 10'd0;
    end


// distance1 (x1-x0)^2 + (y1-y0)^2
    assign distance_temp_1 = (temp_X-store_X[counter_rd])*(temp_X-store_X[counter_rd]) + (temp_Y-store_Y[counter_rd])*(temp_Y-store_Y[counter_rd]);

// distance2 (x1-x0)^2 + (y1-y0)^2
    assign distance_temp_2 = (temp_X-store_X[counter_rd + 6'd1])*(temp_X-store_X[counter_rd + 6'd1]) + (temp_Y-store_Y[counter_rd + 6'd1])*(temp_Y-store_Y[counter_rd + 6'd1]);

// distance1_1 (x1-x0)^2 + (y1-y0)^2
    assign distance1_1 = (C1X-store_X[counter_rd])*(C1X-store_X[counter_rd]) + (C1Y-store_Y[counter_rd])*(C1Y-store_Y[counter_rd]);

// distance2_1 (x1-x0)^2 + (y1-y0)^2
    assign distance2_1 = (C2X-store_X[counter_rd])*(C2X-store_X[counter_rd]) + (C2Y-store_Y[counter_rd])*(C2Y-store_Y[counter_rd]);

// distance1_2 (x1-x0)^2 + (y1-y0)^2
    assign distance1_2 = (C1X-store_X[counter_rd + 6'd1])*(C1X-store_X[counter_rd + 6'd1]) + (C1Y-store_Y[counter_rd + 6'd1])*(C1Y-store_Y[counter_rd + 6'd1]);

// distance2_2 (x1-x0)^2 + (y1-y0)^2
    assign distance2_2 = (C2X-store_X[counter_rd + 6'd1])*(C2X-store_X[counter_rd + 6'd1]) + (C2Y-store_Y[counter_rd + 6'd1])*(C2Y-store_Y[counter_rd + 6'd1]);


// count_points
    always @(posedge CLK) begin
        if(RST)
            count_points <= 10'd0;
        else if(cur_state == CIRCLE1) begin
            if(counter_rd == 6'd40)
                count_points <= 10'd0;
            else if((distance_temp_1 <= 9'd16 && distance2_2 <= 9'd16) || (distance_temp_2 <= 9'd16 && distance2_1 <= 9'd16) ||
                    (distance_temp_1 <= 9'd16 && distance_temp_2 <= 9'd16) || (distance2_1 <= 9'd16 && distance2_2 <= 9'd16))
                count_points <= count_points + 10'd2;
            else if(distance_temp_1 > 9'd16 && distance_temp_2 > 9'd16 && distance2_1 > 9'd16 && distance2_2 > 9'd16)
                count_points <= count_points;
            else
                count_points <= count_points + 10'd1;
        end
        else if(cur_state == CIRCLE2) begin
            if(counter_rd == 6'd40)
                count_points <= 10'd0;
            else if((distance_temp_1 <= 9'd16 && distance1_2 <= 9'd16) || (distance_temp_2 <= 9'd16 && distance1_1 <= 9'd16) ||
                    (distance_temp_1 <= 9'd16 && distance_temp_2 <= 9'd16) || (distance1_1 <= 9'd16 && distance1_2 <= 9'd16))
                count_points <= count_points + 10'd2;
            else if(distance_temp_1 > 9'd16 && distance_temp_2 > 9'd16 && distance1_1 > 9'd16 && distance1_2 > 9'd16)
                count_points <= count_points;
            else
                count_points <= count_points + 10'd1;
        end
        else
            count_points <= 10'd0;                           // initialize to 0 before each round
    end


// max_points
    always @(posedge CLK) begin
        if(RST)
            max_points <= 10'd0;
        else if(DONE)
            max_points <= 10'd0;
        else begin
            if(count_points > max_points)
                max_points <= count_points;
        end
    end


// counter
    always @(posedge CLK) begin
        if(RST)
            counter <= 3'd0;
        else if((cur_state == ASSIGN1 || cur_state == ASSIGN2) && counter_rd == 6'd0) begin
            if(max_points == prev_max_points)
                counter <= counter + 3'd1;
            else
                counter <= 3'd0;
        end
        else if(cur_state == READ)
            counter <= 3'd0;
    end


// DONE
    assign DONE = (counter == 3'd3)? 1'd1 : 1'd0;

endmodule


