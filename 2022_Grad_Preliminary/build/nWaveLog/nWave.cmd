wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/home/ChienShaoHsuan/2022_A-JobAssignmentMachine/110_Job_Assignment_Machine/build/JAM.fsdb}
wvRestoreSignal -win $_nWave1 \
           "/home/ChienShaoHsuan/2022_A-JobAssignmentMachine/110_Job_Assignment_Machine/conf/rtl.rc" \
           -overWriteAutoAlias on -appendSignals on
wvSelectGroup -win $_nWave1 {G1}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/testfixture"
wvGetSignalSetScope -win $_nWave1 "/testfixture/u_JAM"
wvSetPosition -win $_nWave1 {("G1" 15)}
wvSetPosition -win $_nWave1 {("G1" 15)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/testfixture/u_JAM/CLK} \
{/testfixture/u_JAM/Cost\[6:0\]} \
{/testfixture/u_JAM/J\[2:0\]} \
{/testfixture/u_JAM/MatchCount\[3:0\]} \
{/testfixture/u_JAM/MinCost\[9:0\]} \
{/testfixture/u_JAM/RST} \
{/testfixture/u_JAM/Valid} \
{/testfixture/u_JAM/W\[2:0\]} \
{/testfixture/u_JAM/cost_sum\[9:0\]} \
{/testfixture/u_JAM/counter\[3:0\]} \
{/testfixture/u_JAM/current_state\[2:0\]} \
{/testfixture/u_JAM/next_state\[2:0\]} \
{/testfixture/u_JAM/sequence\[7:0\]} \
{/testfixture/u_JAM/switch_point_index\[2:0\]} \
{/testfixture/u_JAM/switch_point_min_index\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 )} 
wvSetPosition -win $_nWave1 {("G1" 15)}
wvSetPosition -win $_nWave1 {("G1" 15)}
wvSetPosition -win $_nWave1 {("G1" 15)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/testfixture/u_JAM/CLK} \
{/testfixture/u_JAM/Cost\[6:0\]} \
{/testfixture/u_JAM/J\[2:0\]} \
{/testfixture/u_JAM/MatchCount\[3:0\]} \
{/testfixture/u_JAM/MinCost\[9:0\]} \
{/testfixture/u_JAM/RST} \
{/testfixture/u_JAM/Valid} \
{/testfixture/u_JAM/W\[2:0\]} \
{/testfixture/u_JAM/cost_sum\[9:0\]} \
{/testfixture/u_JAM/counter\[3:0\]} \
{/testfixture/u_JAM/current_state\[2:0\]} \
{/testfixture/u_JAM/next_state\[2:0\]} \
{/testfixture/u_JAM/sequence\[7:0\]} \
{/testfixture/u_JAM/switch_point_index\[2:0\]} \
{/testfixture/u_JAM/switch_point_min_index\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 )} 
wvSetPosition -win $_nWave1 {("G1" 15)}
wvGetSignalClose -win $_nWave1
wvSelectGroup -win $_nWave1 {G2}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSetPosition -win $_nWave1 {("G1" 2)}
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 6)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G1" 8)}
wvSetPosition -win $_nWave1 {("G1" 9)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 9)}
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 7 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 7 8 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 7 8 9 )} 
wvSetPosition -win $_nWave1 {("G1" 10)}
wvSetPosition -win $_nWave1 {("G1" 11)}
wvSetPosition -win $_nWave1 {("G1" 12)}
wvSetPosition -win $_nWave1 {("G1" 13)}
wvSetPosition -win $_nWave1 {("G1" 14)}
wvSetPosition -win $_nWave1 {("G1" 15)}
wvSetPosition -win $_nWave1 {("G2" 0)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G2" 4)}
wvSetPosition -win $_nWave1 {("G2" 4)}
wvSelectGroup -win $_nWave1 {G3}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSelectSignal -win $_nWave1 {( "G1" 1 4 )} 
wvSelectSignal -win $_nWave1 {( "G1" 1 4 7 )} 
wvSelectSignal -win $_nWave1 {( "G1" 1 4 7 8 )} 
wvSetPosition -win $_nWave1 {("G1" 8)}
wvSetPosition -win $_nWave1 {("G1" 9)}
wvSetPosition -win $_nWave1 {("G1" 11)}
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSetPosition -win $_nWave1 {("G2" 1)}
wvSetPosition -win $_nWave1 {("G2" 2)}
wvSetPosition -win $_nWave1 {("G2" 3)}
wvSetPosition -win $_nWave1 {("G2" 4)}
wvSetPosition -win $_nWave1 {("G3" 0)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 4)}
wvSetPosition -win $_nWave1 {("G3" 4)}
wvSelectGroup -win $_nWave1 {G4}
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvGoToTime -win $_nWave1 633726500
wvSetCursor -win $_nWave1 633725255.899488 -snap {("G4" 0)}
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSetCursor -win $_nWave1 633732432.115528 -snap {("G4" 0)}
wvResizeWindow -win $_nWave1 0 23 1920 1137
wvResizeWindow -win $_nWave1 0 23 1920 1137
wvSetCursor -win $_nWave1 633726508.138229 -snap {("G1" 5)}
wvResizeWindow -win $_nWave1 0 23 1920 1137
wvResizeWindow -win $_nWave1 0 23 1920 1137
wvZoomOut -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSetRadix -win $_nWave1 -format UDec
wvSelectSignal -win $_nWave1 {( "G2" 1 )} 
wvSetPosition -win $_nWave1 {("G2" 1)}
wvExpandBus -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 4)}
wvSelectSignal -win $_nWave1 {( "G2" 1 )} 
wvSelectSignal -win $_nWave1 {( "G2" 1 )} 
wvSetPosition -win $_nWave1 {("G2" 1)}
wvCollapseBus -win $_nWave1
wvSetPosition -win $_nWave1 {("G2" 1)}
wvSetPosition -win $_nWave1 {("G3" 4)}
wvSelectSignal -win $_nWave1 {( "G2" 2 )} 
wvSelectSignal -win $_nWave1 {( "G2" 3 )} 
wvSelectSignal -win $_nWave1 {( "G2" 3 )} 
wvSetRadix -win $_nWave1 -format UDec
wvSelectSignal -win $_nWave1 {( "G2" 4 )} 
wvSelectSignal -win $_nWave1 {( "G2" 4 )} 
wvSetRadix -win $_nWave1 -format UDec
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSetCursor -win $_nWave1 4271.287259 -snap {("G4" 0)}
wvGoToTime -win $_nWave1 633726500
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvSetCursor -win $_nWave1 633727425.173810 -snap {("G1" 5)}
wvSetCursor -win $_nWave1 633726512.226915 -snap {("G1" 5)}
wvSetCursor -win $_nWave1 633710458.218836 -snap {("G1" 5)}
wvSetCursor -win $_nWave1 633723484.014696 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633725440.329471 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633723500.317320 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633725505.539964 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633726499.999975 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633727461.854739 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633726467.394728 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633727478.157362 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633728472.617373 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633737483.892320 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633738462.049708 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633739472.812341 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633740446.894046 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633741506.564550 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633740495.801916 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633741425.051434 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633742468.419314 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633743479.181948 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633742501.024560 -snap {("G3" 3)}
wvSetCursor -win $_nWave1 633743430.274078 -snap {("G3" 3)}
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G4" 0)}
wvSetPosition -win $_nWave1 {("G3" 4)}
wvSetCursor -win $_nWave1 633735172.995486 -snap {("G4" 0)}
wvSetCursor -win $_nWave1 633736493.507959 -snap {("G3" 4)}
