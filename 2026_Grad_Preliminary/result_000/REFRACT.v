module REFRACT(
    input  wire        CLK,
    input  wire        RST,
    input  wire [3:0]  RI,   
    output reg [8:0]  SRAM_A,
    output reg [15:0] SRAM_D,
    input  wire [15:0] SRAM_Q,   // unused
    output reg        SRAM_WE,
    output reg         DONE
);

    reg [15:0] x, y;
    reg [15:0] ans_zx, ans_zy;
    reg [2:0] stage_counter;    // pipeline output暖機
    reg [2:0] global_counter;   // 數0~4
    reg [3:0] RI_reg;
    reg [27:0] DW_div_in_a;
    reg [15:0] DW_div_in_b;
    wire [15:0] DW_div_out_r;
    wire [27:0] DW_div_out_q;
    reg signed [27:0] DW_signed_div_in_a;
    reg signed [16:0] DW_signed_div_in_b;
    wire signed [27:0] DW_signed_div_out_q;
    wire signed [16:0] DW_signed_div_out_r;

    // For x, y
    always @(posedge CLK or posedge RST) begin
        if(RST) begin
            x <= 0;
            y <= 0;
        end else begin
            if(global_counter == 4) begin
                if(x == 15) begin
                    x <= 0;
                    y <= y+1;
                end else begin
                    x <= x+1;
                    y <= y;
                end
            end
        end
    end

    // For global_counter
    always @(posedge CLK or posedge RST) begin
        if(RST) begin
            global_counter <= 0;
        end else if(global_counter == 4) begin
            global_counter <= 0;
        end else begin
            global_counter <= global_counter + 1;
        end
    end

    // For stage_counter
    always @(posedge CLK or posedge RST) begin
        if(RST) begin
            stage_counter <= 0;
        end else begin
            if(stage_counter == 3) begin
                stage_counter <= stage_counter;
            end
            else if(global_counter == 4) begin
                stage_counter <= stage_counter + 1;
            end
        end
    end

    // For DONE
    always @(posedge CLK or posedge RST) begin
        if(RST) begin
            DONE <= 0;
        end else begin
            if(SRAM_A == 9'd511) begin
                DONE <= 1;
            end
        end
    end

//用四個DW square
//stage1計算8次方跟倒數
    reg [15:0] stage1_x, stage1_y;
    reg [15:0] stage1_square_x_2, stage1_square_y_2, stage1_square_x_4, stage1_square_y_4;
    reg [15:0] stage1_DW_square_x_in, stage1_DW_square_y_in;
    wire [31:0] stage1_DW_square_x_out, stage1_DW_square_y_out;
    reg [15:0] stage1_z, stage1_eta, stage1_eta_square;
    
    always @(posedge CLK or posedge RST) begin
        if(RST) begin
            stage1_x <= 'd0;
            stage1_y <= 'd0;
            stage1_DW_square_x_in <= 'd0;
            stage1_DW_square_y_in <= 'd0;
            stage1_square_x_2 <= 'd0;
            stage1_square_y_2 <= 'd0;
            stage1_square_x_4 <= 'd0;
            stage1_square_y_4 <= 'd0;
            stage1_z <= 'd0;
            stage1_eta <= 'd0;
            stage1_eta_square <= 'd0;
        end else begin
            case(global_counter)
                3'd0: begin
                    stage1_x <= x;
                    stage1_y <= y;
                    if((x < 8) && (y < 8))begin
                        stage1_DW_square_x_in <= (8 - x) << 9;  // 左移12, 再右移3
                        stage1_DW_square_y_in <= (8 - y) << 9;
                    end
                    else if((x < 8) && (y >= 8))begin
                        stage1_DW_square_x_in <= (8 - x) << 9;  // 左移12, 再右移3
                        stage1_DW_square_y_in <= (y - 8) << 9;
                    end
                    else if((x >= 8) && (y < 8))begin
                        stage1_DW_square_x_in <= (x - 8) << 9;  // 左移12, 再右移3
                        stage1_DW_square_y_in <= (8 - y) << 9;
                    end
                    else begin
                        stage1_DW_square_x_in <= (x - 8) << 9;  // 左移12, 再右移3
                        stage1_DW_square_y_in <= (y - 8) << 9;
                    end
                end

                3'd1: begin
                    stage1_DW_square_x_in <= stage1_DW_square_x_out[27:12];  // x^2
                    stage1_DW_square_y_in <= stage1_DW_square_y_out[27:12];  // y^2
                    stage1_square_x_2 <= stage1_DW_square_x_out[27:12];
                    stage1_square_y_2 <= stage1_DW_square_y_out[27:12];
                    stage1_eta <= DW_div_out_q[15:0];  // 16'h1000 / RI
                end

                3'd2: begin
                    stage1_DW_square_x_in <= stage1_DW_square_x_out[27:12];  // x^4
                    stage1_DW_square_y_in <= stage1_DW_square_y_out[27:12];  // y^4
                    stage1_square_x_4 <= stage1_DW_square_x_out[27:12];
                    stage1_square_y_4 <= stage1_DW_square_y_out[27:12];
                end
                
                3'd3: begin
                    stage1_z <= 16'h6000 - (stage1_DW_square_x_out[27:12] << 1) - (stage1_DW_square_y_out[27:12] << 1);
                    stage1_DW_square_x_in <= stage1_eta;
                end

                3'd4: begin
                    // stage1_eta_square <= stage1_DW_square_x_out[27:12];
                end

                default: begin
                    ;
                end
            endcase
        end
    end


//stage2計算7次方跟乘法
    reg [15:0] stage2_x, stage2_y;
    reg [15:0] stage2_square_x_2, stage2_square_y_2, stage2_square_x_4, stage2_square_y_4;
    reg [15:0] stage2_DW_mult_x_in, stage2_DW_mult_y_in;
    wire [31:0] stage2_DW_mult_product_gx, stage2_DW_mult_product_gy;
    reg [15:0] stage2_gx, stage2_gy, stage2_g_square, stage2_g_square_r;
    reg [15:0] stage2_z, stage2_eta, stage2_eta_square;

    always @(posedge CLK or posedge RST) begin
        if(RST)begin
            stage2_x <= 0;
            stage2_y <= 0;
            stage2_square_x_2 <= 0;
            stage2_square_y_2 <= 0;
            stage2_square_x_4 <= 0;
            stage2_square_y_4 <= 0;
            stage2_DW_mult_x_in <= 0;
            stage2_DW_mult_y_in <= 0;
            stage2_gx <= 0;
            stage2_gy <= 0;
            stage2_g_square <= 0;
            stage2_z <= 0;
            stage2_eta <= 0; 
            stage2_eta_square <= 0;
            stage2_g_square_r <= 0;
        end
        else begin
            case (global_counter)
                3'd0 : begin
                    stage2_square_x_2 <= stage2_DW_mult_product_gx[27:12];
                    stage2_square_x_4 <= (stage2_x - 8) << 9;
                    stage2_square_y_2 <= stage2_DW_mult_product_gy[27:12];
                    stage2_square_y_4 <= (stage2_y - 8) << 9;
                end
                3'd1 : begin
                    stage2_gx <= stage2_DW_mult_product_gx[27:12] << 1;
                    stage2_gy <= stage2_DW_mult_product_gy[27:12] << 1;
                    stage2_square_x_2 <= stage2_DW_mult_product_gx[27:12] << 1;
                    stage2_square_x_4 <= stage2_DW_mult_product_gx[27:12] << 1;
                    stage2_square_y_2 <= stage2_DW_mult_product_gy[27:12] << 1;
                    stage2_square_y_4 <= stage2_DW_mult_product_gy[27:12] << 1;
                end
                3'd2 : begin
                    stage2_g_square <= (stage2_DW_mult_product_gx[27:12]) + (stage2_DW_mult_product_gy[27:12]) + 16'h1000;
                end
                3'd3 : begin
                    stage2_g_square_r <= 16'h1000 - DW_div_out_q[15:0];
                    stage2_square_x_2 <= stage2_eta;
                    stage2_square_x_4 <= stage2_eta;
                end
                // 3'd4: begin
                //     stage2_eta_square <= stage2_DW_mult_product_gx[27:12];
                // end
                3'd4 :  begin
                    stage2_square_x_2 <= stage1_square_x_2;
                    stage2_square_y_2 <= stage1_square_y_2;
                    stage2_square_x_4 <= stage1_square_x_4;
                    stage2_square_y_4 <= stage1_square_y_4;
                    stage2_z <= stage1_z;
                    stage2_eta <= stage1_eta;
                    stage2_eta_square <= stage1_DW_square_x_out[27:12];
                    stage2_x <= stage1_x;
                    stage2_y <= stage1_y;
                end
                default : begin
                    ;
                end 
            endcase
        end
    end

//stage3
    reg [15:0] stage3_x, stage3_y;
    reg [15:0] stage3_DW_mult_in_a, stage3_DW_mult_in_b;
    wire [31:0] stage3_DW_mult_product;
    reg [31:0] stage3_DW_sqrt_a;
    wire [15:0] stage3_DW_sqrt_root;
    reg [15:0] stage3_gx, stage3_gy, stage3_g_square;
    reg [15:0] stage3_sqrt_kgg, stage3_k, stage3_z, stage3_eta;
    reg signed [15:0] stage3_coef;
    reg signed [15:0] stage3_t;

    always @(posedge CLK or posedge RST) begin
        if(RST) begin
            stage3_x <= 0;
            stage3_y <= 0;
            stage3_DW_mult_in_a <= 0;
            stage3_DW_mult_in_b <= 0;
            stage3_g_square <= 1;   // divide by zero warning
            stage3_z <= 0;
            stage3_eta <= 1;    // divide by zero warning
            stage3_t <= 0;
            stage3_coef <= 0;
            stage3_gx <= 0;
            stage3_gy <= 0;
            stage3_DW_sqrt_a <= 0;
            stage3_sqrt_kgg <= 0;
            stage3_k <= 0;
        end else begin
            case(global_counter)
                3'd0: begin
                    // stage3_DW_mult_in_a <= stage3_DW_mult_product[27:12];   // eta^2
                    // stage3_DW_mult_in_b <= 16'h1000 - DW_div_out_q[15:0];
                    stage3_k <= 16'h1000 - stage3_DW_mult_product[27:12];
                    stage3_DW_mult_in_a <= 16'h1000 - stage3_DW_mult_product[27:12];
                    stage3_DW_mult_in_b <= stage3_g_square;
                end

                3'd1: begin
                    // stage3_k <= 16'h1000 - stage3_DW_mult_product[27:12];
                    // stage3_DW_mult_in_a <= 16'h1000 - stage3_DW_mult_product[27:12];
                    // stage3_DW_mult_in_b <= stage3_g_square;
                    stage3_DW_sqrt_a <= stage3_DW_mult_product; // k * g^2, Q8.24
                end

                3'd2: begin
                    // stage3_DW_sqrt_a <= stage3_DW_mult_product; // k * g^2, Q8.24
                    stage3_sqrt_kgg <= stage3_DW_sqrt_root;
                end

                3'd3: begin
                    // stage3_sqrt_kgg <= stage3_DW_sqrt_root;
                    stage3_coef <= DW_signed_div_out_q[15:0];
                end

                // 3'd4: begin
                //     stage3_t <= DW_signed_div_out_q[15:0];
                // end

                3'd4: begin
                    stage3_g_square <= stage2_g_square;
                    stage3_eta <= stage2_eta;
                    stage3_z <= stage2_z;
                    stage3_x <= stage2_x;
                    stage3_y <= stage2_y;
                    stage3_DW_mult_in_a <= stage2_eta_square;
                    stage3_DW_mult_in_b <= stage2_g_square_r;
                    stage3_gx <= stage2_gx;
                    stage3_gy <= stage2_gy;
                end

                default: begin
                    ;
                end
            endcase
        end
    end


//stage4
    reg [15:0] stage4_x, stage4_y;
    reg signed [15:0] stage4_DW_mult_in_a;
    reg signed [16:0] stage4_DW_mult_in_b;
    wire signed [32:0] stage4_DW_mult_product;
    reg signed [15:0] stage4_gx, stage4_gy;
    reg signed [15:0] stage4_coef;
    reg signed [15:0] stage4_t;

    always @(posedge CLK or posedge RST) begin
        if(RST) begin
            stage4_x <= 0;
            stage4_y <= 0;
            stage4_DW_mult_in_a <= 0;
            stage4_DW_mult_in_b <= 0;
            stage4_gx <= 0;
            stage4_gy <= 0;
            stage4_coef <= 0;
            stage4_t <= 0;
        end else begin
            case(global_counter)
                3'd0: begin
                    stage4_DW_mult_in_a <= stage4_DW_mult_product[27:12];
                    stage4_DW_mult_in_b <= {1'b0, stage4_t};
                end

                3'd1: begin
                    ans_zx <= (stage4_x << 12) + stage4_DW_mult_product[27:12];
                    stage4_DW_mult_in_a <= stage4_gy;
                    stage4_DW_mult_in_b <= {stage4_coef[15], stage4_coef};
                end

                3'd2: begin
                    stage4_DW_mult_in_a <= stage4_DW_mult_product[27:12];
                    stage4_DW_mult_in_b <= {1'b0, stage4_t};
                end

                3'd3: begin
                    ans_zy <= (stage4_y << 12) + stage4_DW_mult_product[27:12];
                end

                3'd4: begin
                    stage4_x <= stage3_x;
                    stage4_y <= stage3_y;
                    stage4_coef <= stage3_coef;
                    stage4_t <= DW_signed_div_out_q[15:0];
                    stage4_gx <= stage3_gx;
                    stage4_gy <= stage3_gy;
                    stage4_DW_mult_in_a <= stage3_gx;
                    stage4_DW_mult_in_b <= {stage3_coef[15], stage3_coef};
                end
            endcase
        end
    end

    // For DW_div
    always @(*) begin
        case(global_counter)
            3'd3: begin // stage 2 1/g^2
                DW_div_in_a = 28'h1000000;
                DW_div_in_b = stage2_g_square;
            end

            3'd1: begin // stage1 eta
                DW_div_in_a = 28'h1000000;
                DW_div_in_b = {RI, 12'd0};
            end

            default : begin
                DW_div_in_a = 28'd1;
                DW_div_in_b = 28'd1;
            end
            // 3'd3: begin // stage3 coef
            //     DW_div_in_a = stage3_eta - stage3_DW_sqrt_root;
            //     DW_div_in_b = stage3_g_square;
            // end
            
            // 3'd4: begin // stage3 t
            //     if(stage_counter == 2) begin
            //         DW_div_in_a = -(stage3_z);
            //         DW_div_in_b = DW_div_out_q - stage3_eta;    // DW_div_out_q = coef
            //     end else begin
            //         DW_div_in_a = 1;
            //         DW_div_in_b = 1;
            //     end
            // end

        endcase
    end
    
    always @(*) begin
        case(global_counter)
            // 3'd0: begin // stage 3 1/g^2
            //     DW_div_in_a = 16'h1000;
            //     DW_div_in_b = stage3_g_square;
            // end

            // 3'd1: begin // stage1 eta
            //     DW_div_in_a = 16'h1000;
            //     DW_div_in_b = RI;
            // end

            3'd3: begin // stage3 coef
                DW_signed_div_in_a = {(stage3_eta - stage3_sqrt_kgg), 12'd0};
                DW_signed_div_in_b = {1'b0, stage3_g_square};
            end
            
            3'd4: begin // stage3 t
                if(stage_counter > 1) begin
                    DW_signed_div_in_a = {-(stage3_z), 12'd0};
                    DW_signed_div_in_b =  {stage3_coef[15], stage3_coef} - {1'b0, stage3_eta};    // DW_signed_div_out_q = coef
                end else begin
                    DW_signed_div_in_a = 1;
                    DW_signed_div_in_b = 1;
                end
            end
            default : begin
                DW_signed_div_in_a = 1;
                DW_signed_div_in_b = 1;
            end

        endcase
    end

    // For SRAM output ports
    // always @(posedge CLK or posedge RST) begin
    //     if(RST) begin
    //         SRAM_D <= 0;
    //     end else begin
    //         if(stage_counter == 3) begin
    //             if(global_counter == 4) begin
    //                 SRAM_D <= ans_zx;
    //             end else if(global_counter == 5) begin
    //                 SRAM_D <= ans_zy;
    //             end
    //         end
    //     end
    // end
    always @(*) begin
        if(stage_counter == 3) begin
            if(global_counter == 3) begin
                SRAM_WE = 1;
                SRAM_D = ans_zx;
                SRAM_A = (stage4_x << 1) + (stage4_y << 5);
            end else if(global_counter == 4) begin
                SRAM_WE = 1;
                SRAM_D = ans_zy;
                SRAM_A = (stage4_x << 1) + (stage4_y << 5) + 1;
            end else begin
                SRAM_WE = 1'd0;
                SRAM_D = 16'd0;
                SRAM_A = 9'd0;
            end
        end else begin
            SRAM_WE = 1'd0;
            SRAM_D = 16'd0;
            SRAM_A = 9'd0;
        end
    end

    // DW modules
    DW_square #(.width(16)) square_x (
        .a(stage1_DW_square_x_in),
        .tc(1'b0),  // unsigned
        .square(stage1_DW_square_x_out)
    );

    DW_square #(.width(16)) square_y (
        .a(stage1_DW_square_y_in),
        .tc(1'b0),  // unsigned
        .square(stage1_DW_square_y_out)
    );

    wire error_div, error_signed_div;

    DW_div #(
        .a_width(28), 
        .b_width(16), 
        .tc_mode(0),  // unsigned
        .rem_mode(1)
    ) div_unsigned (
        .a(DW_div_in_a),
        .b(DW_div_in_b),
        .quotient(DW_div_out_q),
        .remainder(DW_div_out_r), 
        .divide_by_0(error_div)
    );

    DW_div #(
        .a_width(28), 
        .b_width(17), 
        .tc_mode(1),  // signed
        .rem_mode(1)
    ) div_signed (
        .a(DW_signed_div_in_a),
        .b(DW_signed_div_in_b),
        .quotient(DW_signed_div_out_q),
        .remainder(DW_signed_div_out_r), 
        .divide_by_0(error_signed_div)
    );

    DW02_mult #(
        .A_width(16), 
        .B_width(16)
    ) stage2_mult_gx (
        .A(stage2_square_x_2), 
        .B(stage2_square_x_4), 
        .TC(1'b1), 
        .PRODUCT(stage2_DW_mult_product_gx)
    );

    DW02_mult #(
        .A_width(16), 
        .B_width(16)
    ) stage2_mult_gy (
        .A(stage2_square_y_2), 
        .B(stage2_square_y_4), 
        .TC(1'b1), 
        .PRODUCT(stage2_DW_mult_product_gy)
    );

    DW02_mult #(
        .A_width(16), 
        .B_width(16)
    ) stage3_mult (
        .A(stage3_DW_mult_in_a), 
        .B(stage3_DW_mult_in_b), 
        .TC(1'b0), 
        .PRODUCT(stage3_DW_mult_product)
    );

    DW_sqrt #(
        .width(32), 
        .tc_mode(1'b0)
    ) sqrt (
        .a(stage3_DW_sqrt_a), 
        .root(stage3_DW_sqrt_root)
    );

    DW02_mult #(
        .A_width(16), 
        .B_width(17)
    ) stage4_mult (
        .A(stage4_DW_mult_in_a), 
        .B(stage4_DW_mult_in_b), 
        .TC(1'b1), 
        .PRODUCT(stage4_DW_mult_product)
    );

endmodule


