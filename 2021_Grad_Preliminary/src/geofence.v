module geofence ( clk,reset,X,Y,R,valid,is_inside);
input clk;
input reset;
input [9:0] X;
input [9:0] Y;
input [10:0] R;
output valid;
output is_inside;

// parameter
    parameter IDLE      = 4'd0;
    parameter READ      = 4'd1;         // store the input values X, Y, R
    parameter SORT1     = 4'd2;         // calculate cross product of two nodes
    parameter SORT2     = 4'd3;         // swap
    parameter SORT3     = 4'd4;         // increase counter_st for next round of insertion sort
    parameter TRI_AREA1 = 4'd5;         // calculate triangle edge
    parameter TRI_AREA2 = 4'd6;         // calculate left part of triangle formula
    parameter TRI_AREA3 = 4'd7;         // calculate right part of triangle formula
    parameter TRI_AREA4 = 4'd8;         // accumulate triangle area
    parameter HEX_AREA  = 4'd9;         // calculate hexagon area
    parameter RETURN    = 4'd10;        // determine if the point outside the hexagon

// wire & port
    reg [3:0] cur_state;
    reg [3:0] nxt_state;

    reg [2:0] counter_rd;               // for READ state
    reg [2:0] counter_st;               // for SORT 1, 2, 3 states
    reg [2:0] counter_tri;              // for TRI_AREA 1, 2, 3, 4 states

    reg [9:0] store_X [0:5];            // store input values
    reg [9:0] store_Y [0:5];
    reg [9:0] store_R [0:5];

    reg         [ 2:0] index_i;         // for insertion sort & calculate triangle area
    reg         [ 2:0] index_j;

    wire signed [22:0] cross_product;

    wire        [ 9:0] edge_c;          // edge a, b have stored in store_R
    wire        [19:0] edge_c_temp;     // edge_c = sqrt(edge_c_temp)
    wire        [10:0] s;               // s = (a+b+c)/2
    wire        [10:0] s_temp;          // s = s_temp/2

    wire        [10:0] left_sqrt;       // left part of triangle formula
    wire        [20:0] left_sqrt_temp;  // left_sqrt = sqrt(left_sqrt_temp)
    wire        [10:0] right_sqrt;      // right part of triangle formula
    wire        [20:0] right_sqrt_temp; // right_sqrt = sqrt(right_sqrt_temp)
    reg         [22:0] accu_tri_area;   // total triangle area

    wire        [22:0] hex_area;        // hexagon area
    wire        [22:0] hex_area_temp;   // hex_area = hex_area_temp/2

    wire               flag;            // check if three points of triangle are almost in a line


// nxt_state logic
    always @(*) begin
        case(cur_state)
            IDLE: begin
                if(reset)
                    nxt_state = IDLE;
                else
                    nxt_state = READ;
            end
                
            READ: begin                         // store the input values X, Y, R
                if(counter_rd == 3'd5)
                    nxt_state = SORT1;
                else
                    nxt_state = READ;
            end

            SORT1:                              // calculate cross product of two nodes
                nxt_state = SORT2;

            SORT2: begin                        // swap
                if(index_j == 3'd1)
                    nxt_state = SORT3;
                else
                    nxt_state = SORT1;
            end

            SORT3: begin                        // increase counter_st for next round of insertion sort
                if(counter_st == 3'd3)
                    nxt_state = TRI_AREA1;
                else
                    nxt_state = SORT1;
            end

            TRI_AREA1: begin                    // calculate edge
                nxt_state = TRI_AREA2; 
            end

            TRI_AREA2: begin                    // left part of triangle formula
                nxt_state = TRI_AREA3; 
            end

            TRI_AREA3: begin                    // right part of triangle formula
                nxt_state = TRI_AREA4; 
            end

            TRI_AREA4: begin                    // accumulate triangle area
                if(counter_tri == 3'd5)         // 0~5, total 6 triangle areas have been calculated
                    nxt_state = HEX_AREA;
                else
                    nxt_state = TRI_AREA1; 
            end
            HEX_AREA:
                nxt_state = RETURN;

            RETURN:
                nxt_state = READ;

            default:
                nxt_state = IDLE;
        endcase
    end

// state register
    always @(posedge clk or posedge reset) begin
        if(reset)
            cur_state <= READ;
        else
            cur_state <= nxt_state;
    end

// counter_rd
    always @(posedge clk or posedge reset) begin
        if(reset)
            counter_rd <= 3'd0;
        else if(cur_state == RETURN)
            counter_rd <= 3'd0;
        else if(cur_state == READ)
            counter_rd <= counter_rd + 3'd1;
        else
            counter_rd <= 3'd0;
    end


// counter_st
    always @(posedge clk or posedge reset) begin
        if(reset)
            counter_st <= 3'd0;
        else if(cur_state == RETURN)
            counter_st <= 3'd0;
        else begin
            case(cur_state)
                SORT1:
                    counter_st <= counter_st;
                SORT2:
                    counter_st <= counter_st;
                SORT3:
                    counter_st <= counter_st + 3'd1;
                default:
                    counter_st <= 3'd0;
            endcase
        end
    end

// counter_tri
always @(posedge clk or posedge reset) begin
    if(reset)
        counter_tri <= 3'd0;
    else if(cur_state == RETURN)
        counter_tri <= 3'd0;
    else if(cur_state == TRI_AREA1 || cur_state == TRI_AREA2 || cur_state == TRI_AREA3)
        counter_tri <= counter_tri;
    else if(cur_state == TRI_AREA4) begin
        if(counter_tri == 3'd5)
            counter_tri <= 3'd1;
        else
            counter_tri <= counter_tri + 3'd1;
    end
end

// store_X
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            store_X[0] <= 10'd0;
            store_X[1] <= 10'd0;
            store_X[2] <= 10'd0;
            store_X[3] <= 10'd0;
            store_X[4] <= 10'd0;
            store_X[5] <= 10'd0;
        end
        else if(cur_state == RETURN) begin
            store_X[0] <= 10'd0;
            store_X[1] <= 10'd0;
            store_X[2] <= 10'd0;
            store_X[3] <= 10'd0;
            store_X[4] <= 10'd0;
            store_X[5] <= 10'd0;
        end
        else if(cur_state == READ) begin
            store_X[counter_rd] <= X;
        end
        else if(cur_state == SORT2) begin           // swap values at index_i & index_j
            if(cross_product < 0) begin
                store_X[index_i] <= store_X[index_j];
                store_X[index_j] <= store_X[index_i];
            end
        end
    end

// store_Y
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            store_Y[0] <= 10'd0;
            store_Y[1] <= 10'd0;
            store_Y[2] <= 10'd0;
            store_Y[3] <= 10'd0;
            store_Y[4] <= 10'd0;
            store_Y[5] <= 10'd0;
        end
        else if(cur_state == RETURN) begin
            store_Y[0] <= 10'd0;
            store_Y[1] <= 10'd0;
            store_Y[2] <= 10'd0;
            store_Y[3] <= 10'd0;
            store_Y[4] <= 10'd0;
            store_Y[5] <= 10'd0;
        end
        else if(cur_state == READ) begin
            store_Y[counter_rd] <= Y;
        end
        else if(cur_state == SORT2) begin           // swap values at index_i & index_j
            if(cross_product < 0) begin
                store_Y[index_i] <= store_Y[index_j];
                store_Y[index_j] <= store_Y[index_i];
            end
        end
    end

// store_R
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            store_R[0] <= 10'd0;
            store_R[1] <= 10'd0;
            store_R[2] <= 10'd0;
            store_R[3] <= 10'd0;
            store_R[4] <= 10'd0;
            store_R[5] <= 10'd0;
        end
        else if(cur_state == RETURN) begin
            store_R[0] <= 10'd0;
            store_R[1] <= 10'd0;
            store_R[2] <= 10'd0;
            store_R[3] <= 10'd0;
            store_R[4] <= 10'd0;
            store_R[5] <= 10'd0;
        end
        else if(cur_state == READ) begin
            store_R[counter_rd] <= R;
        end
        else if(cur_state == SORT2) begin           // swap values at index_i & index_j
            if(cross_product < 0) begin
                store_R[index_i] <= store_R[index_j];
                store_R[index_j] <= store_R[index_i];
            end
        end
    end

// index_i
    always @(posedge clk or posedge reset) begin
        if(reset)
            index_i <= 3'd2;
        else if(cur_state == RETURN)
            index_i <= 3'd2;
        else if(cur_state == SORT2) begin
            if(cross_product < 0)                // swap values at index_i & index_j
                index_i <= index_j;
        end
        else if(cur_state == SORT3)
            if(nxt_state == TRI_AREA1)
                index_i <= 3'd1;
            else
                index_i <= counter_st + 3'd3;
        else if(cur_state == TRI_AREA4)
            if(counter_tri == 3'd4)
                index_i <= 3'd0;
            else
                index_i <= index_i + 3'd1;
        else
            index_i <= index_i;
    end

// index_j
    always @(posedge clk or posedge reset) begin
        if(reset)
            index_j <= 3'd1;
        else if(cur_state == RETURN)
            index_j <= 3'd1;
        else if(cur_state == SORT2) begin
            index_j <= index_j - 3'd1;
        end
        else if(cur_state == SORT3)
            if(nxt_state == TRI_AREA1)
                index_j <= 3'd0;
            else
                index_j <= counter_st + 3'd2;
        else if(cur_state == TRI_AREA4)
            index_j <= index_i;
        else
            index_j <= index_j;
    end

// accu_tri_area
    always @(posedge clk or posedge reset) begin
        if(reset)
            accu_tri_area <= 42'd0;
        else if(cur_state == RETURN)
            accu_tri_area <= 42'd0;
        else if(cur_state == TRI_AREA4)
            accu_tri_area <= accu_tri_area + (left_sqrt * right_sqrt);
    end

// edge_c
    DW_sqrt #(.width(20)) edgeC(
        .a(edge_c_temp),       // input
        .root(edge_c)          // output
    );

// s
    assign s = {1'b0, s_temp[10:1]};

// left_sqrt 
    DW_sqrt #(.width(21)) leftSqrt(
        .a(left_sqrt_temp), 
        .root(left_sqrt)
    );

// right_sqrt  
    DW_sqrt #(.width(21)) rightSqrt(
        .a(right_sqrt_temp), 
        .root(right_sqrt)
    );

// hex_area
    assign hex_area = {1'b0, hex_area_temp[22:1]};

// cross_product (x1-x0)*(y2-y0) - (x2-x0)*(y1-y0)
    assign cross_product = ((store_X[index_j]-store_X[0])*(store_Y[index_i]-store_Y[0])) - ((store_X[index_i]-store_X[0])*(store_Y[index_j]-store_Y[0]));

// edge_c_temp  (x1-x0)^2 + (y1-y0)^2
    assign edge_c_temp = (store_X[index_i]-store_X[index_j])*(store_X[index_i]-store_X[index_j]) + (store_Y[index_i]-store_Y[index_j])*(store_Y[index_i]-store_Y[index_j]);

// s_temp
    assign s_temp = store_R[index_i] + store_R[index_j] + edge_c;

// left_sqrt_temp  (s*(s-a))
    assign left_sqrt_temp = s * (s - store_R[index_j]);

// right_sqrt_temp  ((s-b)*(s-c))
    assign right_sqrt_temp = (s - store_R[index_i]) * (s - edge_c);

// hex_area_temp
    assign hex_area_temp = (store_X[0]*store_Y[1])-(store_X[1]*store_Y[0]) + (store_X[1]*store_Y[2])-(store_X[2]*store_Y[1])
                         + (store_X[2]*store_Y[3])-(store_X[3]*store_Y[2]) + (store_X[3]*store_Y[4])-(store_X[4]*store_Y[3])
                         + (store_X[4]*store_Y[5])-(store_X[5]*store_Y[4]) + (store_X[5]*store_Y[0])-(store_X[0]*store_Y[5]);

// valid
    assign valid = (cur_state == RETURN)? 1'd1 : 1'd0;

// is_inside
    assign is_inside = (hex_area < accu_tri_area && cur_state == RETURN)? 1'd0 : 1'd1;

// flag
//    assign flag = ($unsigned(s) < $unsigned(store_R[index_j]) || $unsigned(s) < $unsigned(store_R[index_i]) || $unsigned(s) < $unsigned(edge_c))? 1'd1 : 1'd0;


endmodule

