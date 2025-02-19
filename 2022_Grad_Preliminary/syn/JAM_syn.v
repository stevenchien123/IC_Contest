/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03
// Date      : Tue Feb 11 13:27:03 2025
/////////////////////////////////////////////////////////////


module JAM_DW01_add_0 ( A, B, CI, SUM, CO );
  input [9:0] A;
  input [9:0] B;
  output [9:0] SUM;
  input CI;
  output CO;
  wire   n1, n2, n3;
  wire   [9:1] carry;

  ADDFXL U1_4 ( .A(A[4]), .B(B[4]), .CI(carry[4]), .CO(carry[5]), .S(SUM[4])
         );
  ADDFXL U1_3 ( .A(A[3]), .B(B[3]), .CI(carry[3]), .CO(carry[4]), .S(SUM[3])
         );
  ADDFXL U1_2 ( .A(A[2]), .B(B[2]), .CI(carry[2]), .CO(carry[3]), .S(SUM[2])
         );
  ADDFXL U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6])
         );
  ADDFXL U1_5 ( .A(A[5]), .B(B[5]), .CI(carry[5]), .CO(carry[6]), .S(SUM[5])
         );
  ADDFXL U1_1 ( .A(A[1]), .B(B[1]), .CI(n1), .CO(carry[2]), .S(SUM[1]) );
  AND2X2 U1 ( .A(B[0]), .B(A[0]), .Y(n1) );
  XNOR2X1 U2 ( .A(A[9]), .B(n3), .Y(SUM[9]) );
  XOR2XL U3 ( .A(A[8]), .B(n2), .Y(SUM[8]) );
  XOR2XL U4 ( .A(A[7]), .B(carry[7]), .Y(SUM[7]) );
  XOR2XL U5 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
  AND2X2 U6 ( .A(A[7]), .B(carry[7]), .Y(n2) );
  NAND2X1 U7 ( .A(A[8]), .B(n2), .Y(n3) );
endmodule


module JAM ( CLK, RST, W, J, Cost, MatchCount, MinCost, Valid );
  output [2:0] W;
  output [2:0] J;
  input [6:0] Cost;
  output [3:0] MatchCount;
  output [9:0] MinCost;
  input CLK, RST;
  output Valid;
  wire   N81, N82, N83, N84, N85, N86, N87, N88, N89, N90, N91, N92, n758,
         n759, n760, n761, n762, n763, n764, n765, n766, n767, n768, n769,
         n770, n771, n772, \counter_cost[3] , \cur_seq[7][2] , \cur_seq[7][1] ,
         \cur_seq[7][0] , \cur_seq[6][2] , \cur_seq[6][1] , \cur_seq[6][0] ,
         \cur_seq[5][2] , \cur_seq[5][1] , \cur_seq[5][0] , \cur_seq[4][2] ,
         \cur_seq[4][1] , \cur_seq[4][0] , \cur_seq[3][2] , \cur_seq[3][1] ,
         \cur_seq[3][0] , \cur_seq[2][2] , \cur_seq[2][1] , \cur_seq[2][0] ,
         \cur_seq[1][2] , \cur_seq[1][1] , \cur_seq[1][0] , \cur_seq[0][2] ,
         \cur_seq[0][1] , \cur_seq[0][0] , N128, N129, N130, \nxt_seq[7][2] ,
         \nxt_seq[7][1] , \nxt_seq[7][0] , \nxt_seq[6][2] , \nxt_seq[6][1] ,
         \nxt_seq[6][0] , \nxt_seq[5][2] , \nxt_seq[5][1] , \nxt_seq[5][0] ,
         \nxt_seq[4][2] , \nxt_seq[4][1] , \nxt_seq[4][0] , \nxt_seq[3][2] ,
         \nxt_seq[3][1] , \nxt_seq[3][0] , \nxt_seq[2][2] , \nxt_seq[2][1] ,
         \nxt_seq[2][0] , \nxt_seq[1][2] , \nxt_seq[1][1] , \nxt_seq[1][0] ,
         \nxt_seq[0][2] , \nxt_seq[0][1] , \nxt_seq[0][0] , N131, N132, N133,
         N134, N135, N136, N137, N138, N139, flag, N423, N424, N425, N426,
         N427, N428, N429, N430, N431, N432, N433, N434, N435, N436, N437,
         N438, N439, N440, N441, N442, N450, N451, N452, N453, N498, N499,
         N500, n97, n98, n99, n100, n101, n102, n103, n104, n107, n109, n110,
         n111, n125, n164, n167, n183, n187, n199, n200, n201, n202, n203,
         n204, n205, n206, n207, n208, n209, n210, n211, n212, n213, n214,
         n215, n216, n217, n218, n219, n220, n221, n222, n223, n224, n225,
         n226, n227, n228, n229, n230, n231, n232, n233, n235, n236, n237,
         n238, n239, n240, n241, n242, n243, n244, n245, n246, n247, n248,
         n249, n250, n251, n252, n253, n254, n255, n256, n257, n258, n259,
         n260, n261, n262, n263, n264, n265, n266, n267, n268, n269, n270,
         n271, n272, n273, n274, n275, n276, n277, n278, n279, n280, n281,
         n282, n283, n284, n285, n286, n287, n288, n289, n290, n291, n292,
         n293, n294, n295, n296, n297, n298, n299, n300, n301, n302, n303,
         n304, n305, n306, n307, n308, n309, n310, n311, n312, n313, n314,
         n315, n316, n317, n318, n319, n320, n321, n322, n323, n324, n325,
         n326, n327, n328, n329, n330, n331, n332, n333, n334, n335, n336,
         n337, n338, n339, n340, n341, n342, n343, n344, n345, n346, n347,
         n348, n349, n350, n351, n353, n354, n355, n356, n357, n358, n359,
         n360, n361, n362, n363, n364, n365, n366, n367, n368, n369, n370,
         n371, n372, n373, n374, n375, n376, n377, n378, n379, n380, n381,
         n382, n383, n384, n385, n386, n387, n388, n389, n390, n391, n392,
         n393, n394, n395, n396, n397, n398, n399, n400, n401, n402, n403,
         n404, n405, n406, n407, n408, n409, n410, n411, n412, n413, n414,
         n415, n416, n417, n418, n419, n420, n421, n422, n423, n424, n425,
         n426, n427, n428, n429, n430, n431, n432, n433, n434, n435, n436,
         n437, n438, n439, n440, n441, n442, n443, n444, n445, n446, n447,
         n448, n449, n450, n451, n452, n454, n455, n456, n457, n458, n459,
         n460, n461, n462, n463, n464, n465, n466, n467, n468, n469, n470,
         n471, n472, n473, n474, n475, n476, n477, n478, n479, n480, n481,
         n482, n483, n484, n485, n486, n487, n488, n489, n490, n491, n492,
         n493, n494, n495, n496, n497, n498, n499, n500, n501, n502, n503,
         n504, n505, n506, n507, n508, n509, n510, n511, n512, n513, n514,
         n515, n516, n517, n518, n519, n520, n521, n522, n523, n541, n542,
         n543, n548, n549, n550, n551, n552, n553, n554, n556, n557, n558,
         n559, n560, n561, n562, n563, n564, n565, n566, n567, n568, n569,
         n570, n571, n572, n573, n574, n575, n576, n577, n578, n579, n580,
         n581, n582, n583, n584, n585, n586, n587, n588, n589, n590, n591,
         n592, n593, n594, n595, n596, n597, n598, n599, n600, n601, n602,
         n603, n604, n605, n606, n607, n608, n609, n610, n611, n612, n613,
         n614, n615, n616, n617, n618, n619, n620, n621, n622, n623, n624,
         n625, n626, n627, n628, n629, n630, n631, n632, n633, n634, n635,
         n636, n637, n638, n639, n640, n641, n642, n643, n644, n645, n646,
         n647, n648, n649, n650, n651, n652, n653, n654, n655, n656, n657,
         n658, n659, n660, n661, n662, n663, n664, n665, n666, n667, n668,
         n669, n670, n671, n672, n673, n674, n675, n676, n677, n678, n679,
         n680, n681, n682, n683, n684, n685, n686, n687, n688, n689, n690,
         n691, n692, n693, n694, n695, n696, n697, n698, n699, n700, n701,
         n702, n703, n704, n705, n706, n707, n708, n709, n710, n711, n712,
         n713, n714, n715, n716, n717, n718, n719, n720, n721, n722, n723,
         n724, n725, n726, n727, n728, n729, n730, n731, n732, n733, n734,
         n735, n736, n737, n738, n739, n740, n741, n742, n743, n744, n745,
         n746, n747, n748, n749, n750, n751, n752, n753, n754, n755, n756,
         n757;
  wire   [3:0] current_state;
  wire   [9:0] cost_sum;

  OAI31X2 U229 ( .A0(n378), .A1(n377), .A2(n379), .B0(n640), .Y(n242) );
  OAI31X2 U268 ( .A0(n409), .A1(\nxt_seq[1][0] ), .A2(n719), .B0(n410), .Y(
        n252) );
  JAM_DW01_add_0 add_228 ( .A(cost_sum), .B({1'b0, 1'b0, 1'b0, Cost}), .CI(
        1'b0), .SUM({N432, N431, N430, N429, N428, N427, N426, N425, N424, 
        N423}) );
  DFFQX1 \counter_cost_reg[3]  ( .D(N453), .CK(CLK), .Q(\counter_cost[3] ) );
  DFFQX1 flag_reg ( .D(n643), .CK(CLK), .Q(flag) );
  DFFQX1 \cost_sum_reg[7]  ( .D(N440), .CK(CLK), .Q(cost_sum[7]) );
  DFFQX1 \cost_sum_reg[8]  ( .D(N441), .CK(CLK), .Q(cost_sum[8]) );
  DFFX1 \cost_sum_reg[6]  ( .D(N439), .CK(CLK), .Q(cost_sum[6]), .QN(n167) );
  DFFX1 \cost_sum_reg[9]  ( .D(N442), .CK(CLK), .Q(cost_sum[9]), .QN(n164) );
  DFFQX1 \cost_sum_reg[5]  ( .D(N438), .CK(CLK), .Q(cost_sum[5]) );
  DFFQX1 \cost_sum_reg[4]  ( .D(N437), .CK(CLK), .Q(cost_sum[4]) );
  DFFQX1 \cost_sum_reg[1]  ( .D(N434), .CK(CLK), .Q(cost_sum[1]) );
  DFFQX1 \cost_sum_reg[0]  ( .D(N433), .CK(CLK), .Q(cost_sum[0]) );
  DFFQX1 \cost_sum_reg[2]  ( .D(N435), .CK(CLK), .Q(cost_sum[2]) );
  DFFQX1 \cost_sum_reg[3]  ( .D(N436), .CK(CLK), .Q(cost_sum[3]) );
  DFFQX1 \nxt_seq_reg[6][0]  ( .D(n499), .CK(CLK), .Q(\nxt_seq[6][0] ) );
  DFFQX1 \nxt_seq_reg[7][0]  ( .D(n493), .CK(CLK), .Q(\nxt_seq[7][0] ) );
  DFFQX1 \switch_point_index_reg[2]  ( .D(n519), .CK(CLK), .Q(N89) );
  DFFQX1 \switch_point_min_index_reg[2]  ( .D(n518), .CK(CLK), .Q(N86) );
  DFFQX1 \nxt_seq_reg[7][2]  ( .D(n520), .CK(CLK), .Q(\nxt_seq[7][2] ) );
  DFFQX1 \nxt_seq_reg[0][1]  ( .D(n516), .CK(CLK), .Q(\nxt_seq[0][1] ) );
  DFFX1 \cur_seq_reg[7][2]  ( .D(n490), .CK(CLK), .Q(\cur_seq[7][2] ), .QN(n97) );
  DFFQX1 \cur_seq_reg[6][2]  ( .D(n487), .CK(CLK), .Q(\cur_seq[6][2] ) );
  DFFQX1 \cur_seq_reg[2][2]  ( .D(n475), .CK(CLK), .Q(\cur_seq[2][2] ) );
  DFFQX1 \cur_seq_reg[3][2]  ( .D(n478), .CK(CLK), .Q(\cur_seq[3][2] ) );
  DFFX1 \cur_seq_reg[6][0]  ( .D(n485), .CK(CLK), .Q(\cur_seq[6][0] ), .QN(
        n100) );
  DFFX1 \cur_seq_reg[2][0]  ( .D(n473), .CK(CLK), .Q(\cur_seq[2][0] ), .QN(
        n109) );
  DFFX1 \cur_seq_reg[7][1]  ( .D(n489), .CK(CLK), .Q(\cur_seq[7][1] ), .QN(n98) );
  DFFX1 \cur_seq_reg[7][0]  ( .D(n488), .CK(CLK), .Q(\cur_seq[7][0] ), .QN(n99) );
  DFFX1 \cur_seq_reg[3][1]  ( .D(n477), .CK(CLK), .Q(\cur_seq[3][1] ), .QN(
        n107) );
  DFFQX1 \cur_seq_reg[2][1]  ( .D(n474), .CK(CLK), .Q(\cur_seq[2][1] ) );
  DFFQX1 \cur_seq_reg[6][1]  ( .D(n486), .CK(CLK), .Q(\cur_seq[6][1] ) );
  DFFQX1 \cur_seq_reg[3][0]  ( .D(n476), .CK(CLK), .Q(\cur_seq[3][0] ) );
  DFFX1 \cur_seq_reg[1][2]  ( .D(n472), .CK(CLK), .Q(\cur_seq[1][2] ), .QN(
        n110) );
  DFFX1 \cur_seq_reg[4][2]  ( .D(n481), .CK(CLK), .Q(\cur_seq[4][2] ), .QN(
        n103) );
  DFFQX1 \cur_seq_reg[5][2]  ( .D(n484), .CK(CLK), .Q(\cur_seq[5][2] ) );
  DFFQX1 \cur_seq_reg[0][2]  ( .D(n469), .CK(CLK), .Q(\cur_seq[0][2] ) );
  DFFX1 \cur_seq_reg[1][1]  ( .D(n471), .CK(CLK), .Q(\cur_seq[1][1] ), .QN(
        n111) );
  DFFX1 \cur_seq_reg[5][1]  ( .D(n483), .CK(CLK), .Q(\cur_seq[5][1] ), .QN(
        n101) );
  DFFX1 \cur_seq_reg[5][0]  ( .D(n482), .CK(CLK), .Q(\cur_seq[5][0] ), .QN(
        n102) );
  DFFX1 \cur_seq_reg[4][1]  ( .D(n480), .CK(CLK), .Q(\cur_seq[4][1] ), .QN(
        n104) );
  DFFQX1 \cur_seq_reg[1][0]  ( .D(n470), .CK(CLK), .Q(\cur_seq[1][0] ) );
  DFFQX1 \cur_seq_reg[0][0]  ( .D(n491), .CK(CLK), .Q(\cur_seq[0][0] ) );
  DFFQX1 \cur_seq_reg[0][1]  ( .D(n468), .CK(CLK), .Q(\cur_seq[0][1] ) );
  DFFQX1 \cur_seq_reg[4][0]  ( .D(n479), .CK(CLK), .Q(\cur_seq[4][0] ) );
  DFFQX1 \counter_cost_reg[1]  ( .D(N451), .CK(CLK), .Q(N91) );
  DFFQX1 \counter_cost_reg[0]  ( .D(N450), .CK(CLK), .Q(N90) );
  DFFQX1 \current_state_reg[2]  ( .D(N130), .CK(CLK), .Q(current_state[2]) );
  DFFQX1 \current_state_reg[0]  ( .D(N128), .CK(CLK), .Q(current_state[0]) );
  DFFQX1 \nxt_seq_reg[4][0]  ( .D(n505), .CK(CLK), .Q(\nxt_seq[4][0] ) );
  DFFQX1 \nxt_seq_reg[0][0]  ( .D(n517), .CK(CLK), .Q(\nxt_seq[0][0] ) );
  DFFQX1 \nxt_seq_reg[6][2]  ( .D(n497), .CK(CLK), .Q(\nxt_seq[6][2] ) );
  DFFQX1 \nxt_seq_reg[4][1]  ( .D(n504), .CK(CLK), .Q(\nxt_seq[4][1] ) );
  DFFQX1 \nxt_seq_reg[5][0]  ( .D(n502), .CK(CLK), .Q(\nxt_seq[5][0] ) );
  DFFQX1 \nxt_seq_reg[4][2]  ( .D(n503), .CK(CLK), .Q(\nxt_seq[4][2] ) );
  DFFQX1 \nxt_seq_reg[5][2]  ( .D(n500), .CK(CLK), .Q(\nxt_seq[5][2] ) );
  DFFQX1 \nxt_seq_reg[7][1]  ( .D(n492), .CK(CLK), .Q(\nxt_seq[7][1] ) );
  DFFQX1 \counter_cost_reg[2]  ( .D(N452), .CK(CLK), .Q(N92) );
  DFFQX1 \MatchCount_reg[0]  ( .D(n456), .CK(CLK), .Q(n761) );
  DFFQX1 \MinCost_reg[8]  ( .D(n459), .CK(CLK), .Q(n763) );
  DFFQX1 \MinCost_reg[2]  ( .D(n465), .CK(CLK), .Q(n769) );
  DFFQX1 \MinCost_reg[7]  ( .D(n460), .CK(CLK), .Q(n764) );
  DFFQX1 \MinCost_reg[5]  ( .D(n462), .CK(CLK), .Q(n766) );
  DFFQX1 \MatchCount_reg[2]  ( .D(n454), .CK(CLK), .Q(n759) );
  DFFQX1 \MinCost_reg[9]  ( .D(n458), .CK(CLK), .Q(n762) );
  DFFQX1 \MinCost_reg[1]  ( .D(n466), .CK(CLK), .Q(n770) );
  DFFX1 \MinCost_reg[0]  ( .D(n467), .CK(CLK), .Q(n771), .QN(n187) );
  DFFX1 \MinCost_reg[4]  ( .D(n463), .CK(CLK), .Q(n767), .QN(n183) );
  DFFQX1 \MinCost_reg[3]  ( .D(n464), .CK(CLK), .Q(n768) );
  DFFQX1 \MatchCount_reg[1]  ( .D(n455), .CK(CLK), .Q(n760) );
  DFFQX1 \MinCost_reg[6]  ( .D(n461), .CK(CLK), .Q(n765) );
  DFFQX1 \MatchCount_reg[3]  ( .D(n457), .CK(CLK), .Q(n758) );
  DFFX1 \current_state_reg[1]  ( .D(N129), .CK(CLK), .Q(current_state[1]), 
        .QN(n681) );
  DFFX1 \counter_seq_reg[1]  ( .D(N499), .CK(CLK), .Q(N82), .QN(n581) );
  DFFX1 \counter_seq_reg[0]  ( .D(N498), .CK(CLK), .Q(N81), .QN(n582) );
  DFFX1 \nxt_seq_reg[0][2]  ( .D(n515), .CK(CLK), .Q(\nxt_seq[0][2] ), .QN(
        n720) );
  DFFX1 \nxt_seq_reg[1][0]  ( .D(n514), .CK(CLK), .Q(\nxt_seq[1][0] ), .QN(
        n729) );
  DFFX1 \nxt_seq_reg[1][1]  ( .D(n513), .CK(CLK), .Q(\nxt_seq[1][1] ), .QN(
        n702) );
  DFFX1 \nxt_seq_reg[5][1]  ( .D(n501), .CK(CLK), .Q(\nxt_seq[5][1] ), .QN(
        n711) );
  DFFX1 \nxt_seq_reg[2][2]  ( .D(n509), .CK(CLK), .Q(\nxt_seq[2][2] ), .QN(
        n716) );
  DFFX1 \nxt_seq_reg[3][2]  ( .D(n506), .CK(CLK), .Q(\nxt_seq[3][2] ), .QN(
        n726) );
  DFFX1 \nxt_seq_reg[3][1]  ( .D(n507), .CK(CLK), .Q(\nxt_seq[3][1] ), .QN(
        n713) );
  DFFX1 \nxt_seq_reg[3][0]  ( .D(n508), .CK(CLK), .Q(\nxt_seq[3][0] ), .QN(
        n733) );
  EDFFTRXL Valid_reg ( .RN(n645), .D(1'b1), .E(n523), .CK(CLK), .Q(n772) );
  DFFX2 \switch_point_index_reg[0]  ( .D(n496), .CK(CLK), .Q(N87), .QN(n618)
         );
  DFFX2 \nxt_seq_reg[2][0]  ( .D(n511), .CK(CLK), .Q(\nxt_seq[2][0] ), .QN(
        n728) );
  DFFX2 \nxt_seq_reg[2][1]  ( .D(n510), .CK(CLK), .Q(\nxt_seq[2][1] ), .QN(
        n712) );
  DFFX2 \switch_point_min_index_reg[0]  ( .D(n495), .CK(CLK), .Q(N84), .QN(
        n704) );
  DFFX2 \switch_point_index_reg[1]  ( .D(n637), .CK(CLK), .Q(N88), .QN(n709)
         );
  DFFX2 \switch_point_min_index_reg[1]  ( .D(n494), .CK(CLK), .Q(N85), .QN(
        n708) );
  DFFQX1 \nxt_seq_reg[6][1]  ( .D(n498), .CK(CLK), .Q(\nxt_seq[6][1] ) );
  DFFX2 \counter_seq_reg[2]  ( .D(N500), .CK(CLK), .Q(N83), .QN(n580) );
  DFFX2 \nxt_seq_reg[1][2]  ( .D(n512), .CK(CLK), .Q(\nxt_seq[1][2] ), .QN(
        n724) );
  NOR3BXL U478 ( .AN(n321), .B(n338), .C(n671), .Y(n353) );
  OAI221X1 U479 ( .A0(n351), .A1(n676), .B0(n353), .B1(n304), .C0(n560), .Y(
        n340) );
  CLKINVX1 U480 ( .A(n765), .Y(n749) );
  CLKINVX1 U481 ( .A(n760), .Y(n756) );
  CLKINVX1 U482 ( .A(n768), .Y(n751) );
  CLKINVX1 U483 ( .A(n770), .Y(n753) );
  CLKINVX1 U484 ( .A(n762), .Y(n746) );
  CLKINVX1 U485 ( .A(n759), .Y(n757) );
  CLKINVX1 U486 ( .A(n766), .Y(n750) );
  CLKINVX1 U487 ( .A(n764), .Y(n748) );
  CLKINVX1 U488 ( .A(n769), .Y(n752) );
  CLKINVX1 U489 ( .A(n763), .Y(n747) );
  CLKINVX1 U490 ( .A(n761), .Y(n754) );
  OAI211X1 U491 ( .A0(n304), .A1(n552), .B0(n305), .C0(n286), .Y(n288) );
  INVX16 U492 ( .A(n747), .Y(MinCost[8]) );
  OA22X1 U493 ( .A0(n548), .A1(n622), .B0(N92), .B1(n621), .Y(n521) );
  OA22X1 U494 ( .A0(n548), .A1(n626), .B0(N92), .B1(n625), .Y(n522) );
  AND3X2 U495 ( .A(current_state[1]), .B(n677), .C(current_state[2]), .Y(n523)
         );
  NAND2XL U496 ( .A(\nxt_seq[3][2] ), .B(n716), .Y(n417) );
  NAND4XL U497 ( .A(n422), .B(N81), .C(N82), .D(n580), .Y(n421) );
  AOI211XL U498 ( .A0(current_state[1]), .A1(n677), .B0(n678), .C0(n434), .Y(
        n433) );
  NAND2XL U499 ( .A(current_state[1]), .B(n446), .Y(n445) );
  INVX3 U500 ( .A(\nxt_seq[6][1] ), .Y(n125) );
  NOR2X2 U501 ( .A(n708), .B(N84), .Y(n596) );
  AOI32XL U502 ( .A0(n417), .A1(n713), .A2(\nxt_seq[2][1] ), .B0(
        \nxt_seq[2][2] ), .B1(n726), .Y(n416) );
  OAI31X1 U503 ( .A0(n412), .A1(\nxt_seq[2][0] ), .A2(n717), .B0(n413), .Y(
        n254) );
  NOR2X2 U504 ( .A(n709), .B(N87), .Y(n614) );
  NAND3XL U505 ( .A(N88), .B(N87), .C(n557), .Y(n278) );
  OAI22X1 U507 ( .A0(n579), .A1(n580), .B0(N83), .B1(n578), .Y(N131) );
  OAI22X1 U508 ( .A0(n617), .A1(n608), .B0(n557), .B1(n607), .Y(N138) );
  OAI22X1 U509 ( .A0(n616), .A1(n617), .B0(n557), .B1(n615), .Y(N137) );
  XOR2X1 U510 ( .A(n768), .B(cost_sum[3]), .Y(n220) );
  OAI22X1 U511 ( .A0(n598), .A1(n600), .B0(n558), .B1(n597), .Y(N134) );
  OAI22X1 U512 ( .A0(n617), .A1(n604), .B0(n557), .B1(n603), .Y(N139) );
  BUFX16 U513 ( .A(n758), .Y(MatchCount[3]) );
  INVX12 U514 ( .A(n749), .Y(MinCost[6]) );
  INVX12 U515 ( .A(n756), .Y(MatchCount[1]) );
  INVX12 U516 ( .A(n751), .Y(MinCost[3]) );
  BUFX12 U517 ( .A(n767), .Y(MinCost[4]) );
  BUFX12 U518 ( .A(n771), .Y(MinCost[0]) );
  OAI22X1 U519 ( .A0(n580), .A1(n571), .B0(N83), .B1(n570), .Y(N132) );
  BUFX12 U520 ( .A(n772), .Y(Valid) );
  INVX12 U521 ( .A(n753), .Y(MinCost[1]) );
  INVX12 U522 ( .A(n746), .Y(MinCost[9]) );
  INVX12 U523 ( .A(n757), .Y(MatchCount[2]) );
  INVX12 U524 ( .A(n750), .Y(MinCost[5]) );
  XOR2XL U525 ( .A(n766), .B(cost_sum[5]), .Y(n217) );
  INVX12 U526 ( .A(n748), .Y(MinCost[7]) );
  XOR2XL U527 ( .A(n764), .B(cost_sum[7]), .Y(n221) );
  INVX12 U528 ( .A(n752), .Y(MinCost[2]) );
  XOR2XL U529 ( .A(n769), .B(cost_sum[2]), .Y(n215) );
  OAI32XL U530 ( .A0(n209), .A1(n763), .A2(n745), .B0(n762), .B1(n164), .Y(
        n224) );
  XOR2XL U531 ( .A(MinCost[8]), .B(cost_sum[8]), .Y(n214) );
  INVX12 U532 ( .A(n754), .Y(MatchCount[0]) );
  INVX12 U533 ( .A(n548), .Y(W[2]) );
  INVXL U534 ( .A(N137), .Y(n664) );
  NOR2XL U535 ( .A(n664), .B(N131), .Y(n385) );
  NOR2XL U536 ( .A(n685), .B(N131), .Y(n380) );
  INVXL U537 ( .A(N139), .Y(n657) );
  NAND2XL U538 ( .A(n760), .B(n761), .Y(n200) );
  OR2X1 U539 ( .A(n205), .B(n647), .Y(n199) );
  NAND2X1 U540 ( .A(n667), .B(n675), .Y(n299) );
  OA22X1 U541 ( .A0(n634), .A1(n548), .B0(N92), .B1(n633), .Y(n541) );
  CLKBUFX3 U542 ( .A(n645), .Y(n559) );
  OAI21XL U543 ( .A0(n388), .A1(n389), .B0(n559), .Y(n255) );
  INVX1 U544 ( .A(N138), .Y(n662) );
  OA21XL U545 ( .A0(n304), .A1(n277), .B0(n271), .Y(n286) );
  CLKINVX1 U546 ( .A(N135), .Y(n690) );
  NAND2X1 U547 ( .A(n669), .B(n557), .Y(n310) );
  NOR3BXL U548 ( .AN(n408), .B(n254), .C(n252), .Y(n257) );
  CLKINVX1 U549 ( .A(n328), .Y(n674) );
  OAI21XL U550 ( .A0(n703), .A1(n252), .B0(n253), .Y(n246) );
  CLKINVX1 U551 ( .A(n354), .Y(n693) );
  CLKINVX1 U552 ( .A(n239), .Y(n696) );
  CLKINVX1 U553 ( .A(n276), .Y(n698) );
  OAI21XL U554 ( .A0(n224), .A1(n225), .B0(n226), .Y(n206) );
  CLKINVX1 U555 ( .A(RST), .Y(n645) );
  OAI31XL U556 ( .A0(n415), .A1(\nxt_seq[3][0] ), .A2(n715), .B0(n416), .Y(
        n408) );
  OAI31XL U557 ( .A0(n402), .A1(\nxt_seq[6][0] ), .A2(n723), .B0(n403), .Y(
        n392) );
  OAI31XL U558 ( .A0(n405), .A1(\nxt_seq[4][0] ), .A2(n689), .B0(n406), .Y(
        n391) );
  CLKINVX1 U559 ( .A(\nxt_seq[4][1] ), .Y(n714) );
  OAI31XL U560 ( .A0(n399), .A1(\nxt_seq[5][0] ), .A2(n687), .B0(n400), .Y(
        n398) );
  CLKINVX1 U561 ( .A(\nxt_seq[6][2] ), .Y(n722) );
  CLKBUFX3 U562 ( .A(n278), .Y(n551) );
  NAND2X1 U563 ( .A(n675), .B(n653), .Y(n304) );
  NAND3X2 U564 ( .A(n677), .B(n681), .C(current_state[2]), .Y(n269) );
  CLKBUFX3 U565 ( .A(n363), .Y(n549) );
  NOR3X2 U566 ( .A(N87), .B(n557), .C(n709), .Y(n338) );
  NAND3X1 U567 ( .A(N85), .B(n704), .C(n558), .Y(n263) );
  CLKINVX1 U568 ( .A(\nxt_seq[0][0] ), .Y(n659) );
  CLKINVX1 U569 ( .A(\nxt_seq[4][0] ), .Y(n731) );
  CLKINVX1 U570 ( .A(n247), .Y(n638) );
  INVX3 U571 ( .A(n542), .Y(n561) );
  INVX3 U572 ( .A(n563), .Y(n562) );
  INVX3 U573 ( .A(n320), .Y(n643) );
  CLKINVX1 U574 ( .A(n299), .Y(n666) );
  CLKINVX1 U575 ( .A(n281), .Y(n670) );
  CLKINVX1 U576 ( .A(n255), .Y(n640) );
  NAND3X1 U577 ( .A(n242), .B(n559), .C(n678), .Y(n247) );
  NOR2X1 U578 ( .A(n292), .B(n664), .Y(n264) );
  NAND2X1 U579 ( .A(n675), .B(n559), .Y(n320) );
  CLKBUFX3 U580 ( .A(n235), .Y(n553) );
  NAND2X1 U581 ( .A(n561), .B(n559), .Y(n235) );
  NOR2X1 U582 ( .A(n292), .B(n685), .Y(n262) );
  NAND2X1 U583 ( .A(n648), .B(n199), .Y(n203) );
  CLKINVX1 U584 ( .A(n306), .Y(n641) );
  CLKINVX1 U585 ( .A(n292), .Y(n644) );
  CLKINVX1 U586 ( .A(n323), .Y(n649) );
  CLKINVX1 U587 ( .A(n288), .Y(n650) );
  CLKBUFX3 U588 ( .A(n542), .Y(n563) );
  AND2X2 U589 ( .A(n236), .B(n559), .Y(n237) );
  CLKINVX1 U590 ( .A(n273), .Y(n651) );
  OAI21XL U591 ( .A0(n693), .A1(n313), .B0(n559), .Y(n342) );
  CLKINVX1 U592 ( .A(n260), .Y(n652) );
  CLKINVX1 U593 ( .A(n298), .Y(n663) );
  NAND2X1 U594 ( .A(n376), .B(n248), .Y(n387) );
  CLKINVX1 U595 ( .A(n303), .Y(n656) );
  NOR3X1 U596 ( .A(n673), .B(n667), .C(n668), .Y(n321) );
  INVX3 U597 ( .A(n310), .Y(n668) );
  CLKINVX1 U598 ( .A(n451), .Y(n669) );
  CLKINVX1 U599 ( .A(n248), .Y(n661) );
  CLKINVX1 U600 ( .A(n291), .Y(n697) );
  NOR2X1 U601 ( .A(n669), .B(n617), .Y(n452) );
  NAND2X1 U602 ( .A(n673), .B(n675), .Y(n297) );
  CLKINVX1 U603 ( .A(n362), .Y(n694) );
  NAND2X1 U604 ( .A(n671), .B(n675), .Y(n281) );
  INVX12 U605 ( .A(n521), .Y(J[0]) );
  INVX12 U606 ( .A(n522), .Y(J[1]) );
  CLKINVX1 U607 ( .A(W[1]), .Y(n635) );
  INVX12 U608 ( .A(n541), .Y(J[2]) );
  CLKINVX1 U609 ( .A(n543), .Y(n636) );
  OAI22XL U610 ( .A0(n380), .A1(n381), .B0(N134), .B1(n684), .Y(n379) );
  OAI21XL U611 ( .A0(n382), .A1(n383), .B0(n384), .Y(n378) );
  OAI22XL U612 ( .A0(N133), .A1(n655), .B0(N132), .B1(n690), .Y(n381) );
  NAND3BX1 U613 ( .AN(n377), .B(n242), .C(n559), .Y(n241) );
  NOR4X1 U614 ( .A(n257), .B(n254), .C(n252), .D(n387), .Y(n389) );
  OAI221XL U615 ( .A0(n241), .A1(n582), .B0(n704), .B1(n242), .C0(n245), .Y(
        n495) );
  OAI21XL U616 ( .A0(n661), .A1(n246), .B0(n638), .Y(n245) );
  OAI221XL U617 ( .A0(n241), .A1(n581), .B0(n708), .B1(n242), .C0(n243), .Y(
        n494) );
  OAI21XL U618 ( .A0(n661), .A1(n244), .B0(n638), .Y(n243) );
  AND2X2 U619 ( .A(N429), .B(n550), .Y(N439) );
  AND2X2 U620 ( .A(n428), .B(n559), .Y(n542) );
  AOI2BB1X1 U621 ( .A0N(W[1]), .A1N(n562), .B0(N450), .Y(n426) );
  NOR2X1 U622 ( .A(n561), .B(W[0]), .Y(N450) );
  OAI32XL U623 ( .A0(n683), .A1(N138), .A2(n385), .B0(N137), .B1(n684), .Y(
        n383) );
  INVXL U624 ( .A(N132), .Y(n683) );
  CLKINVX1 U625 ( .A(n340), .Y(n642) );
  CLKBUFX3 U626 ( .A(n645), .Y(n560) );
  NAND2X1 U627 ( .A(n549), .B(n559), .Y(n292) );
  OAI22XL U628 ( .A0(n688), .A1(n288), .B0(n650), .B1(n289), .Y(n503) );
  AOI222XL U629 ( .A0(n643), .A1(n290), .B0(n262), .B1(n291), .C0(n697), .C1(
        n264), .Y(n289) );
  OAI222XL U630 ( .A0(n716), .A1(n551), .B0(n720), .B1(n552), .C0(n724), .C1(
        n277), .Y(n290) );
  OAI22XL U631 ( .A0(n725), .A1(n273), .B0(n651), .B1(n274), .Y(n500) );
  AOI222XL U632 ( .A0(n698), .A1(n264), .B0(n643), .B1(n275), .C0(n262), .C1(
        n276), .Y(n274) );
  OAI22XL U633 ( .A0(n720), .A1(n277), .B0(n724), .B1(n551), .Y(n275) );
  AND2X2 U634 ( .A(N428), .B(n550), .Y(N438) );
  OA21XL U635 ( .A0(n755), .A1(n199), .B0(n203), .Y(n201) );
  CLKINVX1 U636 ( .A(n200), .Y(n755) );
  INVX3 U637 ( .A(n554), .Y(n648) );
  OAI211X1 U638 ( .A0(n321), .A1(n304), .B0(n322), .C0(n559), .Y(n306) );
  OAI21XL U639 ( .A0(n674), .A1(n691), .B0(n549), .Y(n322) );
  OAI22XL U640 ( .A0(n733), .A1(n306), .B0(n641), .B1(n317), .Y(n508) );
  AOI22X1 U641 ( .A0(n644), .A1(n318), .B0(n643), .B1(n319), .Y(n317) );
  OAI222XL U642 ( .A0(n729), .A1(n552), .B0(n659), .B1(n310), .C0(n728), .C1(
        n277), .Y(n319) );
  OAI22XL U643 ( .A0(n657), .A1(n312), .B0(n691), .B1(n655), .Y(n318) );
  OAI22XL U644 ( .A0(n713), .A1(n306), .B0(n641), .B1(n314), .Y(n507) );
  AOI22X1 U645 ( .A0(n644), .A1(n315), .B0(n643), .B1(n316), .Y(n314) );
  OAI222XL U646 ( .A0(n702), .A1(n552), .B0(n700), .B1(n310), .C0(n712), .C1(
        n277), .Y(n316) );
  OAI22XL U647 ( .A0(n662), .A1(n312), .B0(n691), .B1(n690), .Y(n315) );
  NAND2X1 U648 ( .A(n250), .B(n244), .Y(n251) );
  CLKINVX1 U649 ( .A(n223), .Y(n647) );
  OAI211X1 U650 ( .A0(n336), .A1(n304), .B0(n337), .C0(n286), .Y(n323) );
  OAI21XL U651 ( .A0(n338), .A1(n692), .B0(n549), .Y(n337) );
  NOR2X1 U652 ( .A(n674), .B(n668), .Y(n336) );
  OAI21XL U653 ( .A0(n668), .A1(n697), .B0(n549), .Y(n305) );
  NOR4BXL U654 ( .AN(N133), .B(N139), .C(n385), .D(n386), .Y(n382) );
  NOR2XL U655 ( .A(N132), .B(n662), .Y(n386) );
  OAI211X1 U656 ( .A0(n618), .A1(n255), .B0(n256), .C0(n251), .Y(n496) );
  OAI21XL U657 ( .A0(n660), .A1(n252), .B0(n250), .Y(n256) );
  CLKINVX1 U658 ( .A(n259), .Y(n660) );
  OAI22XL U659 ( .A0(n730), .A1(n273), .B0(n651), .B1(n283), .Y(n502) );
  AOI22X1 U660 ( .A0(n644), .A1(n284), .B0(n643), .B1(n285), .Y(n283) );
  OAI22XL U661 ( .A0(n659), .A1(n277), .B0(n729), .B1(n551), .Y(n285) );
  OAI22XL U662 ( .A0(n657), .A1(n276), .B0(n698), .B1(n655), .Y(n284) );
  OAI22XL U663 ( .A0(n642), .A1(n345), .B0(n702), .B1(n340), .Y(n513) );
  AOI211X1 U664 ( .A0(n693), .A1(n663), .B0(n346), .C0(n347), .Y(n345) );
  OAI22XL U665 ( .A0(n714), .A1(n299), .B0(n348), .B1(n269), .Y(n346) );
  OAI21XL U666 ( .A0(n693), .A1(n282), .B0(n559), .Y(n347) );
  OAI22XL U667 ( .A0(n339), .A1(n642), .B0(n724), .B1(n340), .Y(n512) );
  AOI211X1 U668 ( .A0(n693), .A1(n665), .B0(n341), .C0(n342), .Y(n339) );
  OAI22XL U669 ( .A0(n688), .A1(n299), .B0(n343), .B1(n269), .Y(n341) );
  CLKINVX1 U670 ( .A(n311), .Y(n665) );
  NAND3X1 U671 ( .A(n543), .B(n563), .C(W[1]), .Y(n424) );
  INVXL U672 ( .A(N134), .Y(n685) );
  NAND3BXL U673 ( .AN(n380), .B(n690), .C(N132), .Y(n384) );
  AND2X2 U674 ( .A(N427), .B(n550), .Y(N437) );
  INVXL U675 ( .A(N131), .Y(n684) );
  NOR2X1 U676 ( .A(n427), .B(n561), .Y(N451) );
  XOR2X1 U677 ( .A(n636), .B(W[1]), .Y(n427) );
  NAND2X1 U678 ( .A(n559), .B(n419), .Y(n236) );
  OAI21XL U679 ( .A0(n671), .A1(n696), .B0(n549), .Y(n419) );
  OAI2BB2XL U680 ( .B0(n236), .B1(n707), .A0N(n237), .A1N(n418), .Y(n520) );
  OAI22XL U681 ( .A0(n239), .A1(n664), .B0(n696), .B1(n685), .Y(n418) );
  OAI2BB2XL U682 ( .B0(n236), .B1(n706), .A0N(n237), .A1N(n240), .Y(n493) );
  OAI22XL U683 ( .A0(n239), .A1(n657), .B0(n696), .B1(n655), .Y(n240) );
  OAI2BB2XL U684 ( .B0(n236), .B1(n705), .A0N(n237), .A1N(n238), .Y(n492) );
  OAI22XL U685 ( .A0(n239), .A1(n662), .B0(n696), .B1(n690), .Y(n238) );
  AND2X2 U686 ( .A(N426), .B(n550), .Y(N436) );
  OAI31XL U687 ( .A0(n310), .A1(n720), .A2(n269), .B0(n560), .Y(n309) );
  NAND2X1 U688 ( .A(n286), .B(n287), .Y(n273) );
  OAI21XL U689 ( .A0(n673), .A1(n698), .B0(n549), .Y(n287) );
  OAI22XL U690 ( .A0(n711), .A1(n273), .B0(n651), .B1(n279), .Y(n501) );
  AOI221XL U691 ( .A0(n663), .A1(n698), .B0(n666), .B1(n556), .C0(n280), .Y(
        n279) );
  OAI221XL U692 ( .A0(n702), .A1(n281), .B0(n698), .B1(n282), .C0(n560), .Y(
        n280) );
  OAI221XL U693 ( .A0(n648), .A1(n737), .B0(n753), .B1(n554), .C0(n560), .Y(
        n466) );
  NAND2X1 U694 ( .A(n271), .B(n272), .Y(n260) );
  OAI21XL U695 ( .A0(n667), .A1(n699), .B0(n549), .Y(n272) );
  AND2X2 U696 ( .A(N425), .B(n550), .Y(N435) );
  CLKINVX1 U697 ( .A(n422), .Y(n646) );
  AND2X2 U698 ( .A(N424), .B(n550), .Y(N434) );
  CLKINVX1 U699 ( .A(N136), .Y(n655) );
  NAND2X1 U700 ( .A(N139), .B(n549), .Y(n270) );
  NAND2X1 U701 ( .A(N134), .B(n549), .Y(n313) );
  NAND2X1 U702 ( .A(N137), .B(n549), .Y(n311) );
  NAND2XL U703 ( .A(N138), .B(n549), .Y(n298) );
  CLKINVX1 U704 ( .A(n558), .Y(n600) );
  NAND2X1 U705 ( .A(N135), .B(n549), .Y(n282) );
  NAND2X1 U706 ( .A(N136), .B(n549), .Y(n303) );
  NOR2BX1 U707 ( .AN(n390), .B(n391), .Y(n393) );
  NOR3X1 U708 ( .A(n252), .B(n254), .C(n408), .Y(n390) );
  AND3X2 U709 ( .A(n253), .B(n259), .C(n258), .Y(n376) );
  NAND2X1 U710 ( .A(n393), .B(n398), .Y(n259) );
  NAND3X1 U711 ( .A(n393), .B(n392), .C(n686), .Y(n253) );
  CLKINVX1 U712 ( .A(n557), .Y(n617) );
  NAND4BX1 U713 ( .AN(n209), .B(n210), .C(n211), .D(n212), .Y(n205) );
  NOR3BXL U714 ( .AN(n219), .B(n220), .C(n221), .Y(n211) );
  NOR4X1 U715 ( .A(n213), .B(n214), .C(n215), .D(n216), .Y(n212) );
  NAND2BX1 U716 ( .AN(n217), .B(n218), .Y(n213) );
  NAND2X1 U717 ( .A(n390), .B(n391), .Y(n248) );
  CLKINVX1 U718 ( .A(n398), .Y(n686) );
  NAND2BX1 U719 ( .AN(n257), .B(n258), .Y(n244) );
  CLKINVX1 U720 ( .A(n254), .Y(n703) );
  NAND2X1 U721 ( .A(n709), .B(n618), .Y(n451) );
  CLKINVX1 U722 ( .A(n359), .Y(n654) );
  INVX3 U723 ( .A(n269), .Y(n675) );
  CLKINVX1 U724 ( .A(n277), .Y(n667) );
  CLKINVX1 U725 ( .A(n552), .Y(n673) );
  CLKINVX1 U726 ( .A(n551), .Y(n671) );
  CLKINVX1 U727 ( .A(n558), .Y(n695) );
  CLKINVX1 U728 ( .A(n327), .Y(n692) );
  NAND3X1 U729 ( .A(n704), .B(n708), .C(n558), .Y(n291) );
  NAND3X1 U730 ( .A(n708), .B(n695), .C(n704), .Y(n362) );
  OAI21XL U731 ( .A0(n618), .A1(n709), .B0(n451), .Y(n450) );
  NOR2X1 U732 ( .A(n451), .B(n557), .Y(n372) );
  CLKINVX1 U733 ( .A(n312), .Y(n691) );
  CLKINVX1 U734 ( .A(n263), .Y(n699) );
  OAI22XL U735 ( .A0(n713), .A1(n277), .B0(n714), .B1(n551), .Y(n332) );
  CLKINVX1 U736 ( .A(n388), .Y(n678) );
  CLKINVX1 U737 ( .A(n556), .Y(n700) );
  CLKBUFX3 U738 ( .A(n734), .Y(n548) );
  INVXL U739 ( .A(N92), .Y(n734) );
  BUFX16 U740 ( .A(N90), .Y(W[0]) );
  BUFX16 U741 ( .A(N91), .Y(W[1]) );
  CLKBUFX3 U742 ( .A(N90), .Y(n543) );
  AND2X2 U743 ( .A(N432), .B(n550), .Y(N442) );
  AND2X2 U744 ( .A(N431), .B(n550), .Y(N441) );
  OAI222XL U745 ( .A0(n376), .A1(n247), .B0(n241), .B1(n580), .C0(n695), .C1(
        n242), .Y(n518) );
  AND2X2 U746 ( .A(N430), .B(n550), .Y(N440) );
  OAI32X1 U747 ( .A0(n548), .A1(\counter_cost[3] ), .A2(n424), .B0(n425), .B1(
        n735), .Y(N453) );
  OA21XL U748 ( .A0(N92), .A1(n562), .B0(n426), .Y(n425) );
  OAI22XL U749 ( .A0(n426), .A1(n548), .B0(N92), .B1(n424), .Y(N452) );
  AOI31X1 U750 ( .A0(n709), .A1(n617), .A2(N87), .B0(n693), .Y(n351) );
  CLKINVX1 U751 ( .A(n549), .Y(n676) );
  OAI32X1 U752 ( .A0(n350), .A1(RST), .A2(n642), .B0(n729), .B1(n340), .Y(n514) );
  AOI221XL U753 ( .A0(n656), .A1(n354), .B0(n693), .B1(n658), .C0(n355), .Y(
        n350) );
  OAI22XL U754 ( .A0(n731), .A1(n299), .B0(n356), .B1(n269), .Y(n355) );
  CLKINVX1 U755 ( .A(n270), .Y(n658) );
  OAI22XL U756 ( .A0(n722), .A1(n260), .B0(n652), .B1(n261), .Y(n497) );
  AOI222XL U757 ( .A0(n643), .A1(\nxt_seq[0][2] ), .B0(n262), .B1(n263), .C0(
        n699), .C1(n264), .Y(n261) );
  OAI22XL U758 ( .A0(n561), .A1(n103), .B0(n553), .B1(n688), .Y(n481) );
  OAI22XL U759 ( .A0(n561), .A1(n107), .B0(n553), .B1(n713), .Y(n477) );
  OAI22XL U760 ( .A0(n561), .A1(n102), .B0(n553), .B1(n730), .Y(n482) );
  OAI22XL U761 ( .A0(n561), .A1(n97), .B0(n553), .B1(n707), .Y(n490) );
  OAI22XL U762 ( .A0(n561), .A1(n98), .B0(n553), .B1(n705), .Y(n489) );
  OAI22XL U763 ( .A0(n561), .A1(n99), .B0(n553), .B1(n706), .Y(n488) );
  NOR2X1 U764 ( .A(n428), .B(RST), .Y(n223) );
  OAI2BB1XL U765 ( .A0N(MatchCount[3]), .A1N(n207), .B0(n208), .Y(n457) );
  OR4XL U766 ( .A(MatchCount[3]), .B(n757), .C(n199), .D(n200), .Y(n208) );
  OAI21XL U767 ( .A0(n759), .A1(n199), .B0(n201), .Y(n207) );
  CLKBUFX3 U768 ( .A(n222), .Y(n554) );
  AO21X1 U769 ( .A0(n206), .A1(n223), .B0(RST), .Y(n222) );
  OAI2BB2XL U770 ( .B0(n553), .B1(n125), .A0N(n563), .A1N(\cur_seq[6][1] ), 
        .Y(n486) );
  OAI2BB2XL U771 ( .B0(n553), .B1(n729), .A0N(n563), .A1N(\cur_seq[1][0] ), 
        .Y(n470) );
  OAI2BB2XL U772 ( .B0(n553), .B1(n725), .A0N(n563), .A1N(\cur_seq[5][2] ), 
        .Y(n484) );
  OAI2BB2XL U773 ( .B0(n553), .B1(n722), .A0N(n563), .A1N(\cur_seq[6][2] ), 
        .Y(n487) );
  OAI2BB2XL U774 ( .B0(n553), .B1(n712), .A0N(n563), .A1N(\cur_seq[2][1] ), 
        .Y(n474) );
  OAI2BB2XL U775 ( .B0(n553), .B1(n733), .A0N(n563), .A1N(\cur_seq[3][0] ), 
        .Y(n476) );
  OAI22XL U776 ( .A0(n726), .A1(n306), .B0(n641), .B1(n307), .Y(n506) );
  AOI211X1 U777 ( .A0(n672), .A1(\nxt_seq[1][2] ), .B0(n308), .C0(n309), .Y(
        n307) );
  CLKINVX1 U778 ( .A(n297), .Y(n672) );
  OAI222XL U779 ( .A0(n311), .A1(n312), .B0(n691), .B1(n313), .C0(n716), .C1(
        n299), .Y(n308) );
  NOR2X1 U780 ( .A(n640), .B(RST), .Y(n250) );
  CLKINVX1 U781 ( .A(n249), .Y(n637) );
  AOI221XL U782 ( .A0(n246), .A1(n250), .B0(N88), .B1(n640), .C0(n639), .Y(
        n249) );
  CLKINVX1 U783 ( .A(n251), .Y(n639) );
  OAI22XL U784 ( .A0(n125), .A1(n260), .B0(n652), .B1(n265), .Y(n498) );
  AOI22X1 U785 ( .A0(n644), .A1(n266), .B0(n643), .B1(n556), .Y(n265) );
  OAI22XL U786 ( .A0(n662), .A1(n263), .B0(n699), .B1(n690), .Y(n266) );
  OAI22XL U787 ( .A0(n731), .A1(n288), .B0(n650), .B1(n300), .Y(n505) );
  AOI211X1 U788 ( .A0(n670), .A1(\nxt_seq[2][0] ), .B0(n301), .C0(n302), .Y(
        n300) );
  OAI222XL U789 ( .A0(n270), .A1(n291), .B0(n697), .B1(n303), .C0(n729), .C1(
        n299), .Y(n301) );
  OAI21XL U790 ( .A0(n659), .A1(n297), .B0(n559), .Y(n302) );
  OAI22XL U791 ( .A0(n716), .A1(n323), .B0(n649), .B1(n324), .Y(n509) );
  AOI221XL U792 ( .A0(n675), .A1(n325), .B0(n666), .B1(\nxt_seq[3][2] ), .C0(
        n326), .Y(n324) );
  OAI222XL U793 ( .A0(n724), .A1(n310), .B0(n720), .B1(n328), .C0(n688), .C1(
        n551), .Y(n325) );
  OAI221XL U794 ( .A0(n692), .A1(n313), .B0(n311), .B1(n327), .C0(n560), .Y(
        n326) );
  OAI22XL U795 ( .A0(n714), .A1(n288), .B0(n650), .B1(n294), .Y(n504) );
  AOI211X1 U796 ( .A0(n670), .A1(\nxt_seq[2][1] ), .B0(n295), .C0(n296), .Y(
        n294) );
  OAI222XL U797 ( .A0(n298), .A1(n291), .B0(n697), .B1(n282), .C0(n702), .C1(
        n299), .Y(n295) );
  OAI21XL U798 ( .A0(n700), .A1(n297), .B0(n559), .Y(n296) );
  AOI2BB1X1 U799 ( .A0N(n304), .A1N(n551), .B0(RST), .Y(n271) );
  OAI22XL U800 ( .A0(n728), .A1(n323), .B0(n649), .B1(n333), .Y(n511) );
  AOI221XL U801 ( .A0(n675), .A1(n334), .B0(n666), .B1(\nxt_seq[3][0] ), .C0(
        n335), .Y(n333) );
  OAI222XL U802 ( .A0(n729), .A1(n310), .B0(n659), .B1(n328), .C0(n731), .C1(
        n551), .Y(n334) );
  OAI221XL U803 ( .A0(n692), .A1(n303), .B0(n270), .B1(n327), .C0(n560), .Y(
        n335) );
  OAI22XL U804 ( .A0(n712), .A1(n323), .B0(n649), .B1(n329), .Y(n510) );
  AOI2BB2X1 U805 ( .B0(n644), .B1(n330), .A0N(n331), .A1N(n320), .Y(n329) );
  AOI221XL U806 ( .A0(n674), .A1(n556), .B0(n668), .B1(\nxt_seq[1][1] ), .C0(
        n332), .Y(n331) );
  OAI22XL U807 ( .A0(n662), .A1(n327), .B0(n692), .B1(n690), .Y(n330) );
  OAI32XL U808 ( .A0(n199), .A1(n759), .A2(n200), .B0(n201), .B1(n757), .Y(
        n454) );
  OAI32XL U809 ( .A0(n199), .A1(n760), .A2(n754), .B0(n202), .B1(n756), .Y(
        n455) );
  OA21XL U810 ( .A0(n761), .A1(n199), .B0(n203), .Y(n202) );
  OAI221XL U811 ( .A0(n561), .A1(n110), .B0(n542), .B1(n724), .C0(n560), .Y(
        n472) );
  OAI221XL U812 ( .A0(n561), .A1(n111), .B0(n542), .B1(n702), .C0(n560), .Y(
        n471) );
  OAI221XL U813 ( .A0(n561), .A1(n109), .B0(n563), .B1(n728), .C0(n560), .Y(
        n473) );
  AO22X1 U814 ( .A0(n557), .A1(n640), .B0(n387), .B1(n250), .Y(n519) );
  CLKINVX1 U815 ( .A(N84), .Y(n599) );
  OAI221XL U816 ( .A0(n562), .A1(n104), .B0(n563), .B1(n714), .C0(n560), .Y(
        n480) );
  OAI221XL U817 ( .A0(n562), .A1(n101), .B0(n563), .B1(n711), .C0(n560), .Y(
        n483) );
  OAI221XL U818 ( .A0(n562), .A1(n100), .B0(n563), .B1(n710), .C0(n560), .Y(
        n485) );
  OAI221XL U819 ( .A0(n561), .A1(n721), .B0(n542), .B1(n720), .C0(n560), .Y(
        n469) );
  CLKINVX1 U820 ( .A(\cur_seq[0][2] ), .Y(n721) );
  OAI221XL U821 ( .A0(n561), .A1(n718), .B0(n563), .B1(n716), .C0(n560), .Y(
        n475) );
  CLKINVX1 U822 ( .A(\cur_seq[2][2] ), .Y(n718) );
  OAI221XL U823 ( .A0(n561), .A1(n727), .B0(n563), .B1(n726), .C0(n560), .Y(
        n478) );
  CLKINVX1 U824 ( .A(\cur_seq[3][2] ), .Y(n727) );
  OAI221XL U825 ( .A0(n562), .A1(n679), .B0(n563), .B1(n659), .C0(n560), .Y(
        n491) );
  CLKINVX1 U826 ( .A(\cur_seq[0][0] ), .Y(n679) );
  OAI221XL U827 ( .A0(n562), .A1(n732), .B0(n563), .B1(n731), .C0(n560), .Y(
        n479) );
  CLKINVX1 U828 ( .A(\cur_seq[4][0] ), .Y(n732) );
  OAI221XL U829 ( .A0(n562), .A1(n701), .B0(n563), .B1(n700), .C0(n559), .Y(
        n468) );
  CLKINVX1 U830 ( .A(\cur_seq[0][1] ), .Y(n701) );
  OAI22XL U831 ( .A0(n754), .A1(n203), .B0(n204), .B1(n647), .Y(n456) );
  AOI2BB1XL U832 ( .A0N(n761), .A1N(n205), .B0(n206), .Y(n204) );
  OAI221XL U833 ( .A0(n648), .A1(n164), .B0(n746), .B1(n554), .C0(n559), .Y(
        n458) );
  OAI221XL U834 ( .A0(n648), .A1(n167), .B0(n749), .B1(n554), .C0(n559), .Y(
        n461) );
  OAI221XL U835 ( .A0(n648), .A1(n743), .B0(n748), .B1(n554), .C0(n645), .Y(
        n460) );
  OAI221XL U836 ( .A0(n648), .A1(n739), .B0(n752), .B1(n554), .C0(n645), .Y(
        n465) );
  OAI221XL U837 ( .A0(n648), .A1(n745), .B0(n747), .B1(n554), .C0(n645), .Y(
        n459) );
  OAI221XL U838 ( .A0(n648), .A1(n740), .B0(n751), .B1(n554), .C0(n645), .Y(
        n464) );
  OAI221XL U839 ( .A0(n648), .A1(n742), .B0(n750), .B1(n554), .C0(n559), .Y(
        n462) );
  OAI31XL U840 ( .A0(n682), .A1(RST), .A2(n431), .B0(n292), .Y(N130) );
  AOI2BB1X1 U841 ( .A0N(current_state[1]), .A1N(n432), .B0(n677), .Y(n431) );
  OAI221XL U842 ( .A0(n648), .A1(n736), .B0(n187), .B1(n554), .C0(n560), .Y(
        n467) );
  CLKINVX1 U843 ( .A(cost_sum[0]), .Y(n736) );
  OAI221XL U844 ( .A0(n648), .A1(n741), .B0(n183), .B1(n554), .C0(n560), .Y(
        n463) );
  CLKINVX1 U845 ( .A(cost_sum[4]), .Y(n741) );
  OAI22XL U846 ( .A0(n710), .A1(n260), .B0(n652), .B1(n267), .Y(n499) );
  AOI211X1 U847 ( .A0(n656), .A1(n263), .B0(n268), .C0(RST), .Y(n267) );
  OAI22XL U848 ( .A0(n659), .A1(n269), .B0(n263), .B1(n270), .Y(n268) );
  NOR2X1 U849 ( .A(n377), .B(RST), .Y(n422) );
  OAI21XL U850 ( .A0(n420), .A1(n580), .B0(n421), .Y(N500) );
  AOI2BB1X1 U851 ( .A0N(N82), .A1N(n646), .B0(N498), .Y(n420) );
  NOR2X1 U852 ( .A(n646), .B(N81), .Y(N498) );
  OAI211XL U853 ( .A0(n770), .A1(n737), .B0(n232), .C0(n738), .Y(n231) );
  OAI21XL U854 ( .A0(n210), .A1(n187), .B0(n219), .Y(n232) );
  OAI21XL U855 ( .A0(n214), .A1(n209), .B0(n744), .Y(n226) );
  OAI22XL U856 ( .A0(MinCost[7]), .A1(n743), .B0(n227), .B1(n221), .Y(n225) );
  CLKINVX1 U857 ( .A(n224), .Y(n744) );
  OA22XL U858 ( .A0(n167), .A1(n765), .B0(n216), .B1(n228), .Y(n227) );
  OA22XL U859 ( .A0(n766), .A1(n742), .B0(n229), .B1(n217), .Y(n228) );
  AOI32X1 U860 ( .A0(n230), .A1(n231), .A2(n218), .B0(cost_sum[4]), .B1(n183), 
        .Y(n229) );
  OAI21XL U861 ( .A0(n215), .A1(n220), .B0(n738), .Y(n230) );
  CLKINVX1 U862 ( .A(n233), .Y(n738) );
  OAI32XL U863 ( .A0(n220), .A1(n769), .A2(n739), .B0(n768), .B1(n740), .Y(
        n233) );
  OAI221XL U864 ( .A0(n369), .A1(n359), .B0(n654), .B1(n659), .C0(n559), .Y(
        n517) );
  AOI221XL U865 ( .A0(n675), .A1(n373), .B0(n666), .B1(\nxt_seq[5][0] ), .C0(
        n374), .Y(n369) );
  OAI221XL U866 ( .A0(n731), .A1(n552), .B0(n710), .B1(n551), .C0(n375), .Y(
        n373) );
  OAI22XL U867 ( .A0(n270), .A1(n362), .B0(n694), .B1(n303), .Y(n374) );
  OAI32X1 U868 ( .A0(RST), .A1(current_state[0]), .A2(n435), .B0(n680), .B1(
        n647), .Y(N128) );
  CLKINVX1 U869 ( .A(n432), .Y(n680) );
  AOI32X1 U870 ( .A0(\counter_cost[3] ), .A1(n636), .A2(n444), .B0(n445), .B1(
        n682), .Y(n435) );
  OAI221XL U871 ( .A0(n358), .A1(n359), .B0(n654), .B1(n720), .C0(n560), .Y(
        n515) );
  AOI221XL U872 ( .A0(n675), .A1(n360), .B0(n666), .B1(\nxt_seq[5][2] ), .C0(
        n361), .Y(n358) );
  OAI221XL U873 ( .A0(n688), .A1(n552), .B0(n722), .B1(n551), .C0(n364), .Y(
        n360) );
  OAI22XL U874 ( .A0(n311), .A1(n362), .B0(n694), .B1(n313), .Y(n361) );
  OAI221XL U875 ( .A0(n365), .A1(n359), .B0(n654), .B1(n700), .C0(n560), .Y(
        n516) );
  AOI221XL U876 ( .A0(n675), .A1(n366), .B0(n666), .B1(\nxt_seq[5][1] ), .C0(
        n367), .Y(n365) );
  OAI221XL U877 ( .A0(n714), .A1(n552), .B0(n125), .B1(n551), .C0(n368), .Y(
        n366) );
  OAI22XL U878 ( .A0(n298), .A1(n362), .B0(n694), .B1(n282), .Y(n367) );
  CLKBUFX3 U879 ( .A(n429), .Y(n550) );
  NOR2BX1 U880 ( .AN(n430), .B(RST), .Y(n429) );
  NAND4BX1 U881 ( .AN(W[1]), .B(n636), .C(n548), .D(n735), .Y(n430) );
  AND2X2 U882 ( .A(N423), .B(n550), .Y(N433) );
  NOR2X1 U883 ( .A(n423), .B(n646), .Y(N499) );
  XOR2X1 U884 ( .A(n582), .B(N82), .Y(n423) );
  CLKBUFX3 U885 ( .A(\nxt_seq[0][1] ), .Y(n556) );
  XOR2X1 U886 ( .A(n753), .B(cost_sum[1]), .Y(n219) );
  NOR2X1 U887 ( .A(n433), .B(RST), .Y(N129) );
  NOR3X1 U888 ( .A(n432), .B(current_state[1]), .C(n677), .Y(n434) );
  XOR2X1 U889 ( .A(n746), .B(n164), .Y(n209) );
  CLKBUFX3 U890 ( .A(N86), .Y(n558) );
  XOR2X1 U891 ( .A(n749), .B(n167), .Y(n216) );
  OAI21XL U892 ( .A0(n556), .A1(n702), .B0(\nxt_seq[0][0] ), .Y(n409) );
  AOI32X1 U893 ( .A0(n411), .A1(n702), .A2(n556), .B0(\nxt_seq[0][2] ), .B1(
        n724), .Y(n410) );
  CLKINVX1 U894 ( .A(n411), .Y(n719) );
  NAND4BX1 U895 ( .AN(n392), .B(n686), .C(n393), .D(n394), .Y(n258) );
  OAI21XL U896 ( .A0(\nxt_seq[7][2] ), .A1(n722), .B0(n395), .Y(n394) );
  OAI22XL U897 ( .A0(\nxt_seq[6][2] ), .A1(n707), .B0(n396), .B1(n397), .Y(
        n395) );
  NOR2X1 U898 ( .A(\nxt_seq[7][1] ), .B(n125), .Y(n397) );
  NAND2X1 U899 ( .A(\nxt_seq[1][2] ), .B(n720), .Y(n411) );
  OAI21XL U900 ( .A0(\nxt_seq[1][1] ), .A1(n712), .B0(\nxt_seq[1][0] ), .Y(
        n412) );
  AOI32X1 U901 ( .A0(n414), .A1(n712), .A2(\nxt_seq[1][1] ), .B0(
        \nxt_seq[1][2] ), .B1(n716), .Y(n413) );
  CLKINVX1 U902 ( .A(n414), .Y(n717) );
  NAND2X1 U903 ( .A(\nxt_seq[2][2] ), .B(n724), .Y(n414) );
  CLKBUFX3 U904 ( .A(N89), .Y(n557) );
  OAI21XL U905 ( .A0(\nxt_seq[2][1] ), .A1(n713), .B0(\nxt_seq[2][0] ), .Y(
        n415) );
  CLKINVX1 U906 ( .A(n417), .Y(n715) );
  OAI21XL U907 ( .A0(\nxt_seq[3][1] ), .A1(n714), .B0(\nxt_seq[3][0] ), .Y(
        n405) );
  CLKINVX1 U908 ( .A(n407), .Y(n689) );
  AOI32X1 U909 ( .A0(n407), .A1(n714), .A2(\nxt_seq[3][1] ), .B0(
        \nxt_seq[3][2] ), .B1(n688), .Y(n406) );
  NAND2X1 U910 ( .A(\nxt_seq[4][2] ), .B(n726), .Y(n407) );
  INVX3 U911 ( .A(\nxt_seq[4][2] ), .Y(n688) );
  OAI21XL U912 ( .A0(\nxt_seq[4][1] ), .A1(n711), .B0(\nxt_seq[4][0] ), .Y(
        n399) );
  CLKINVX1 U913 ( .A(n401), .Y(n687) );
  AOI32X1 U914 ( .A0(n401), .A1(n711), .A2(\nxt_seq[4][1] ), .B0(
        \nxt_seq[4][2] ), .B1(n725), .Y(n400) );
  NAND2X1 U915 ( .A(\nxt_seq[5][2] ), .B(n688), .Y(n401) );
  CLKINVX1 U916 ( .A(\nxt_seq[5][2] ), .Y(n725) );
  OAI21XL U917 ( .A0(\nxt_seq[5][1] ), .A1(n125), .B0(\nxt_seq[5][0] ), .Y(
        n402) );
  AOI32X1 U918 ( .A0(n404), .A1(n125), .A2(\nxt_seq[5][1] ), .B0(
        \nxt_seq[5][2] ), .B1(n722), .Y(n403) );
  CLKINVX1 U919 ( .A(n404), .Y(n723) );
  NAND2X1 U920 ( .A(\nxt_seq[6][2] ), .B(n725), .Y(n404) );
  CLKINVX1 U921 ( .A(cost_sum[2]), .Y(n739) );
  AOI211X1 U922 ( .A0(\nxt_seq[7][1] ), .A1(n125), .B0(n710), .C0(
        \nxt_seq[7][0] ), .Y(n396) );
  CLKINVX1 U923 ( .A(cost_sum[3]), .Y(n740) );
  XOR2X1 U924 ( .A(n187), .B(cost_sum[0]), .Y(n210) );
  CLKINVX1 U925 ( .A(\nxt_seq[6][0] ), .Y(n710) );
  NOR3XL U926 ( .A(W[1]), .B(current_state[1]), .C(N92), .Y(n444) );
  CLKINVX1 U927 ( .A(cost_sum[1]), .Y(n737) );
  CLKINVX1 U928 ( .A(\nxt_seq[7][2] ), .Y(n707) );
  XOR2X1 U929 ( .A(n183), .B(cost_sum[4]), .Y(n218) );
  NOR2X1 U930 ( .A(n370), .B(n371), .Y(n359) );
  OA21XL U931 ( .A0(n694), .A1(n372), .B0(n549), .Y(n370) );
  AOI211X1 U932 ( .A0(n328), .A1(n353), .B0(flag), .C0(n269), .Y(n371) );
  CLKINVX1 U933 ( .A(flag), .Y(n653) );
  INVX3 U934 ( .A(current_state[0]), .Y(n677) );
  NAND3X2 U935 ( .A(N88), .B(n618), .C(n557), .Y(n277) );
  CLKBUFX3 U936 ( .A(n293), .Y(n552) );
  NAND3X1 U937 ( .A(N87), .B(n709), .C(n557), .Y(n293) );
  AOI221XL U938 ( .A0(n338), .A1(\nxt_seq[0][0] ), .B0(n668), .B1(
        \nxt_seq[2][0] ), .C0(n357), .Y(n356) );
  OAI22XL U939 ( .A0(n730), .A1(n551), .B0(n733), .B1(n552), .Y(n357) );
  AOI222XL U940 ( .A0(n668), .A1(\nxt_seq[3][1] ), .B0(n338), .B1(
        \nxt_seq[1][1] ), .C0(n674), .C1(\nxt_seq[2][1] ), .Y(n368) );
  AOI222XL U941 ( .A0(n668), .A1(\nxt_seq[3][2] ), .B0(n338), .B1(
        \nxt_seq[1][2] ), .C0(n674), .C1(\nxt_seq[2][2] ), .Y(n364) );
  AOI222XL U942 ( .A0(n668), .A1(\nxt_seq[3][0] ), .B0(n338), .B1(
        \nxt_seq[1][0] ), .C0(n674), .C1(\nxt_seq[2][0] ), .Y(n375) );
  AOI221XL U943 ( .A0(n338), .A1(n556), .B0(n668), .B1(\nxt_seq[2][1] ), .C0(
        n349), .Y(n348) );
  OAI22XL U944 ( .A0(n711), .A1(n551), .B0(n713), .B1(n552), .Y(n349) );
  AOI221XL U945 ( .A0(n338), .A1(\nxt_seq[0][2] ), .B0(n668), .B1(
        \nxt_seq[2][2] ), .C0(n344), .Y(n343) );
  OAI22XL U946 ( .A0(n725), .A1(n551), .B0(n726), .B1(n552), .Y(n344) );
  NOR3X1 U947 ( .A(n681), .B(current_state[2]), .C(n677), .Y(n363) );
  CLKINVX1 U948 ( .A(cost_sum[8]), .Y(n745) );
  CLKINVX1 U949 ( .A(cost_sum[5]), .Y(n742) );
  NAND3X1 U950 ( .A(n681), .B(n682), .C(current_state[0]), .Y(n388) );
  NAND3X1 U951 ( .A(n708), .B(n695), .C(N84), .Y(n354) );
  CLKINVX1 U952 ( .A(current_state[2]), .Y(n682) );
  NAND3X1 U953 ( .A(n677), .B(n682), .C(current_state[1]), .Y(n377) );
  NAND3X1 U954 ( .A(N87), .B(n617), .C(N88), .Y(n328) );
  NAND3X1 U955 ( .A(current_state[2]), .B(n681), .C(current_state[0]), .Y(n428) );
  NAND3X1 U956 ( .A(n704), .B(n695), .C(N85), .Y(n327) );
  NAND4BX1 U957 ( .AN(n372), .B(n447), .C(n448), .D(n449), .Y(n446) );
  XOR2X1 U958 ( .A(N87), .B(N81), .Y(n448) );
  XOR2X1 U959 ( .A(n581), .B(n450), .Y(n449) );
  XOR2X1 U960 ( .A(n580), .B(n452), .Y(n447) );
  CLKINVX1 U961 ( .A(cost_sum[7]), .Y(n743) );
  NAND3X1 U962 ( .A(N84), .B(n695), .C(N85), .Y(n312) );
  NAND3X1 U963 ( .A(N84), .B(n708), .C(n558), .Y(n276) );
  NAND3X1 U964 ( .A(N85), .B(N84), .C(n558), .Y(n239) );
  CLKINVX1 U965 ( .A(\nxt_seq[5][0] ), .Y(n730) );
  NAND4X1 U966 ( .A(n436), .B(n437), .C(n438), .D(n439), .Y(n432) );
  NOR4X1 U967 ( .A(n441), .B(\cur_seq[0][0] ), .C(\cur_seq[0][2] ), .D(
        \cur_seq[0][1] ), .Y(n438) );
  NOR4X1 U968 ( .A(n443), .B(n97), .C(n99), .D(n98), .Y(n436) );
  NOR4X1 U969 ( .A(n440), .B(\cur_seq[2][2] ), .C(\cur_seq[4][0] ), .D(
        \cur_seq[3][2] ), .Y(n439) );
  NOR4X1 U970 ( .A(n442), .B(n102), .C(n107), .D(n103), .Y(n437) );
  NAND3X1 U971 ( .A(\cur_seq[2][1] ), .B(\cur_seq[1][0] ), .C(\cur_seq[3][0] ), 
        .Y(n442) );
  NAND3X1 U972 ( .A(n101), .B(n100), .C(n104), .Y(n440) );
  NAND3X1 U973 ( .A(n110), .B(n109), .C(n111), .Y(n441) );
  NAND3X1 U974 ( .A(\cur_seq[6][1] ), .B(\cur_seq[5][2] ), .C(\cur_seq[6][2] ), 
        .Y(n443) );
  CLKINVX1 U975 ( .A(\counter_cost[3] ), .Y(n735) );
  CLKINVX1 U976 ( .A(\nxt_seq[7][1] ), .Y(n705) );
  CLKINVX1 U977 ( .A(\nxt_seq[7][0] ), .Y(n706) );
  NOR2X1 U978 ( .A(n581), .B(N81), .Y(n577) );
  NOR2X1 U979 ( .A(n581), .B(n582), .Y(n576) );
  NOR2X1 U980 ( .A(n582), .B(N82), .Y(n574) );
  NOR2X1 U981 ( .A(N81), .B(N82), .Y(n573) );
  AO22X1 U982 ( .A0(\nxt_seq[5][0] ), .A1(n574), .B0(\nxt_seq[4][0] ), .B1(
        n573), .Y(n564) );
  AOI221XL U983 ( .A0(\nxt_seq[6][0] ), .A1(n577), .B0(\nxt_seq[7][0] ), .B1(
        n576), .C0(n564), .Y(n567) );
  AO22X1 U984 ( .A0(\nxt_seq[1][0] ), .A1(n574), .B0(\nxt_seq[0][0] ), .B1(
        n573), .Y(n565) );
  AOI221XL U985 ( .A0(\nxt_seq[2][0] ), .A1(n577), .B0(\nxt_seq[3][0] ), .B1(
        n576), .C0(n565), .Y(n566) );
  OAI22XL U986 ( .A0(n580), .A1(n567), .B0(N83), .B1(n566), .Y(N133) );
  AO22X1 U987 ( .A0(\nxt_seq[5][1] ), .A1(n574), .B0(\nxt_seq[4][1] ), .B1(
        n573), .Y(n568) );
  AOI221XL U988 ( .A0(\nxt_seq[6][1] ), .A1(n577), .B0(\nxt_seq[7][1] ), .B1(
        n576), .C0(n568), .Y(n571) );
  AO22X1 U989 ( .A0(\nxt_seq[1][1] ), .A1(n574), .B0(n556), .B1(n573), .Y(n569) );
  AOI221XL U990 ( .A0(\nxt_seq[2][1] ), .A1(n577), .B0(\nxt_seq[3][1] ), .B1(
        n576), .C0(n569), .Y(n570) );
  AO22X1 U991 ( .A0(\nxt_seq[5][2] ), .A1(n574), .B0(\nxt_seq[4][2] ), .B1(
        n573), .Y(n572) );
  AOI221XL U992 ( .A0(\nxt_seq[6][2] ), .A1(n577), .B0(\nxt_seq[7][2] ), .B1(
        n576), .C0(n572), .Y(n579) );
  AO22X1 U993 ( .A0(\nxt_seq[1][2] ), .A1(n574), .B0(\nxt_seq[0][2] ), .B1(
        n573), .Y(n575) );
  AOI221XL U994 ( .A0(\nxt_seq[2][2] ), .A1(n577), .B0(\nxt_seq[3][2] ), .B1(
        n576), .C0(n575), .Y(n578) );
  NOR2X1 U995 ( .A(n708), .B(n599), .Y(n595) );
  NOR2X1 U996 ( .A(n599), .B(N85), .Y(n593) );
  NOR2X1 U997 ( .A(N84), .B(N85), .Y(n592) );
  AO22X1 U998 ( .A0(\nxt_seq[5][0] ), .A1(n593), .B0(\nxt_seq[4][0] ), .B1(
        n592), .Y(n583) );
  AOI221XL U999 ( .A0(\nxt_seq[6][0] ), .A1(n596), .B0(\nxt_seq[7][0] ), .B1(
        n595), .C0(n583), .Y(n586) );
  AO22X1 U1000 ( .A0(\nxt_seq[1][0] ), .A1(n593), .B0(\nxt_seq[0][0] ), .B1(
        n592), .Y(n584) );
  AOI221XL U1001 ( .A0(\nxt_seq[2][0] ), .A1(n596), .B0(\nxt_seq[3][0] ), .B1(
        n595), .C0(n584), .Y(n585) );
  OAI22XL U1002 ( .A0(n600), .A1(n586), .B0(n558), .B1(n585), .Y(N136) );
  AO22X1 U1003 ( .A0(\nxt_seq[5][1] ), .A1(n593), .B0(\nxt_seq[4][1] ), .B1(
        n592), .Y(n587) );
  AOI221XL U1004 ( .A0(\nxt_seq[6][1] ), .A1(n596), .B0(\nxt_seq[7][1] ), .B1(
        n595), .C0(n587), .Y(n590) );
  AO22X1 U1005 ( .A0(\nxt_seq[1][1] ), .A1(n593), .B0(n556), .B1(n592), .Y(
        n588) );
  AOI221XL U1006 ( .A0(\nxt_seq[2][1] ), .A1(n596), .B0(\nxt_seq[3][1] ), .B1(
        n595), .C0(n588), .Y(n589) );
  OAI22XL U1007 ( .A0(n600), .A1(n590), .B0(n558), .B1(n589), .Y(N135) );
  AO22X1 U1008 ( .A0(\nxt_seq[5][2] ), .A1(n593), .B0(\nxt_seq[4][2] ), .B1(
        n592), .Y(n591) );
  AOI221XL U1009 ( .A0(\nxt_seq[6][2] ), .A1(n596), .B0(\nxt_seq[7][2] ), .B1(
        n595), .C0(n591), .Y(n598) );
  AO22X1 U1010 ( .A0(\nxt_seq[1][2] ), .A1(n593), .B0(\nxt_seq[0][2] ), .B1(
        n592), .Y(n594) );
  AOI221XL U1011 ( .A0(\nxt_seq[2][2] ), .A1(n596), .B0(\nxt_seq[3][2] ), .B1(
        n595), .C0(n594), .Y(n597) );
  NOR2X1 U1012 ( .A(n709), .B(n618), .Y(n613) );
  NOR2X1 U1013 ( .A(n618), .B(N88), .Y(n611) );
  NOR2X1 U1014 ( .A(N87), .B(N88), .Y(n610) );
  AO22X1 U1015 ( .A0(\nxt_seq[5][0] ), .A1(n611), .B0(\nxt_seq[4][0] ), .B1(
        n610), .Y(n601) );
  AOI221XL U1016 ( .A0(\nxt_seq[6][0] ), .A1(n614), .B0(\nxt_seq[7][0] ), .B1(
        n613), .C0(n601), .Y(n604) );
  AO22X1 U1017 ( .A0(\nxt_seq[1][0] ), .A1(n611), .B0(\nxt_seq[0][0] ), .B1(
        n610), .Y(n602) );
  AOI221XL U1018 ( .A0(\nxt_seq[2][0] ), .A1(n614), .B0(\nxt_seq[3][0] ), .B1(
        n613), .C0(n602), .Y(n603) );
  AO22X1 U1019 ( .A0(\nxt_seq[5][1] ), .A1(n611), .B0(\nxt_seq[4][1] ), .B1(
        n610), .Y(n605) );
  AOI221XL U1020 ( .A0(\nxt_seq[6][1] ), .A1(n614), .B0(\nxt_seq[7][1] ), .B1(
        n613), .C0(n605), .Y(n608) );
  AO22X1 U1021 ( .A0(\nxt_seq[1][1] ), .A1(n611), .B0(n556), .B1(n610), .Y(
        n606) );
  AOI221XL U1022 ( .A0(\nxt_seq[2][1] ), .A1(n614), .B0(\nxt_seq[3][1] ), .B1(
        n613), .C0(n606), .Y(n607) );
  AO22X1 U1023 ( .A0(\nxt_seq[5][2] ), .A1(n611), .B0(\nxt_seq[4][2] ), .B1(
        n610), .Y(n609) );
  AOI221XL U1024 ( .A0(\nxt_seq[6][2] ), .A1(n614), .B0(\nxt_seq[7][2] ), .B1(
        n613), .C0(n609), .Y(n616) );
  AO22X1 U1025 ( .A0(\nxt_seq[1][2] ), .A1(n611), .B0(\nxt_seq[0][2] ), .B1(
        n610), .Y(n612) );
  AOI221XL U1026 ( .A0(\nxt_seq[2][2] ), .A1(n614), .B0(\nxt_seq[3][2] ), .B1(
        n613), .C0(n612), .Y(n615) );
  NOR2X1 U1027 ( .A(n635), .B(n543), .Y(n632) );
  NOR2X1 U1028 ( .A(n635), .B(n636), .Y(n631) );
  NOR2X1 U1029 ( .A(n636), .B(W[1]), .Y(n629) );
  NOR2X1 U1030 ( .A(W[0]), .B(W[1]), .Y(n628) );
  AO22X1 U1031 ( .A0(\cur_seq[5][0] ), .A1(n629), .B0(\cur_seq[4][0] ), .B1(
        n628), .Y(n619) );
  AOI221XL U1032 ( .A0(\cur_seq[6][0] ), .A1(n632), .B0(\cur_seq[7][0] ), .B1(
        n631), .C0(n619), .Y(n622) );
  AO22X1 U1033 ( .A0(\cur_seq[1][0] ), .A1(n629), .B0(\cur_seq[0][0] ), .B1(
        n628), .Y(n620) );
  AOI221XL U1034 ( .A0(\cur_seq[2][0] ), .A1(n632), .B0(\cur_seq[3][0] ), .B1(
        n631), .C0(n620), .Y(n621) );
  AO22X1 U1035 ( .A0(\cur_seq[5][1] ), .A1(n629), .B0(\cur_seq[4][1] ), .B1(
        n628), .Y(n623) );
  AOI221XL U1036 ( .A0(\cur_seq[6][1] ), .A1(n632), .B0(\cur_seq[7][1] ), .B1(
        n631), .C0(n623), .Y(n626) );
  AO22X1 U1037 ( .A0(\cur_seq[1][1] ), .A1(n629), .B0(\cur_seq[0][1] ), .B1(
        n628), .Y(n624) );
  AOI221XL U1038 ( .A0(\cur_seq[2][1] ), .A1(n632), .B0(\cur_seq[3][1] ), .B1(
        n631), .C0(n624), .Y(n625) );
  AO22X1 U1039 ( .A0(\cur_seq[5][2] ), .A1(n629), .B0(\cur_seq[4][2] ), .B1(
        n628), .Y(n627) );
  AOI221XL U1040 ( .A0(\cur_seq[6][2] ), .A1(n632), .B0(\cur_seq[7][2] ), .B1(
        n631), .C0(n627), .Y(n634) );
  AO22X1 U1041 ( .A0(\cur_seq[1][2] ), .A1(n629), .B0(\cur_seq[0][2] ), .B1(
        n628), .Y(n630) );
  AOI221XL U1042 ( .A0(\cur_seq[2][2] ), .A1(n632), .B0(\cur_seq[3][2] ), .B1(
        n631), .C0(n630), .Y(n633) );
endmodule

