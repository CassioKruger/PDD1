//Novembro, 2018 - Autor: Cássio T. Kruger
//UFPel - Eng. de Controle e Automação
//pdd1 - v5.0

Include "pdd1_v5_data.geo" ;

Solver.AutoShowLastStep = 1;
Mesh.Algorithm = 1;
Geometry.CopyMeshingMethod = 1;

nicepos_rotor[] = {};
nicepos_rotor2[] = {};
nicepos_stator[] = {};
nicepos_stator_mag[] = {};

// some characteristic lengths...
//----------------------------------------
pslo = mm * 3*2/2/1.5; // slot opening
psl  = mm * 2.2; // upper part slot
pout = mm * 12; // outer radius
pMB  = mm * 1 * 2/2; // MB
p  = mm*12*0.05*1.3;    //rotor

Include "pdd1_v5_stator.geo" ;
Include "pdd1_v5_stator_mags.geo" ;


save1 = newll;
Line Loop(save1) = {innerTest_[]};
save2 = newll;
Line Loop(save2) = {topMags_[]};

dH = news; Plane Surface(news) = {save1,save2};
ferro2[] +=dH;

Color SteelBlue {Surface{StatorIron_[],ferro2[]};}
Color SkyBlue {Surface{StatorAir_[]};}

If(Flag_OpenStator)
  Color SkyBlue {Surface{StatorSlotOpening_[]};}
  Physical Surface(STATOR_FE) = {StatorIron_[],ferro2[]};
  Physical Surface(STATOR_AIR) = {StatorAir_[], StatorSlotOpening_[]};
EndIf

If(!Flag_OpenStator)
  Color SteelBlue {Surface{StatorSlotOpening_[]};}
  Physical Surface(STATOR_FE) = {StatorIron_[],ferro2[],StatorSlotOpening_[]};
  Physical Surface(STATOR_AIR) = {StatorAir_[]};
EndIf

Include "pdd1_v5_rotor1.geo" ;
Include "pdd1_v5_rotor2.geo" ;


Mesh.CharacteristicLengthFactor = 1;
//Mesh 2;

// For nice visualisation...
Mesh.Light = 0 ;
Hide { Line{ Line '*' }; }
Hide { Point{ Point '*' }; }

Physical Line("NICEPOS") = { nicepos_rotor[],nicepos_rotor2[], nicepos_stator[],nicepos_stator_mag[] };
Show { Line{ nicepos_rotor[],nicepos_rotor2[], nicepos_stator[],nicepos_stator_mag[] }; }

//For post-processing...
View[PostProcessing.NbViews-1].Light = 0;
View[PostProcessing.NbViews-1].NbIso = 60;              // Number of intervals
View[PostProcessing.NbViews-1].IntervalsType = 1;       // 1 - Iso Values; 2 - Continuous Map
View[PostProcessing.NbViews-1].LineWidth = 2;           // espessura linha
View[PostProcessing.NbViews-1].ColormapNumber = 2;      // color map - 2 default - 10 B&W

General.Trackball = 0;
General.RotationX = 0;
General.RotationY = 0;
General.RotationZ = 0;
General.Color.Background = White;
General.Color.Foreground = Black;
General.Color.Text = Black;
General.Orthographic = 0;
General.Axes = 0;
General.SmallAxes = 0;

//testando git no atom
Line Loop(204118) = {39, -7, -6, 2470, 2471, -2439, -2438, 2406, 2407, -2375, -2374, 2342, 2343, -2311, -2310, 2278, 2279, -2247, -2246, 2214, 2215,
                      -2183, -2182, 2150, 2151, -2119, -2118, 2086, 2087, -2055, -2054, 2022, 2023, -1991, -1990, 1958, 1959, -1927, -1926, 1894, 1895,
                       -1863, -1862, 1830, 1831, -1799, -1798, 1766, 1767, -1735, -1734, 1702, 1703, -1671, -1670, 1638, 1639, -1607, -1606, 1574, 1575,
                        -1543, -1542, 1510, 1511, -1479, -1478, 1446, 1447, -1415, -1414, 1382, 1383, -1351, -1350, 1318, 1319, -1287, -1286, 1254, 1255,
                         -1223, -1222, 1190, 1191, -1159, -1158, 1126, 1127, -1095, -1094, 1062, 1063, -1031, -1030, 998, 999, -967, -966, 934, 935, -903,
                          -902, 870, 871, -839, -838, 806, 807, -775, -774, 742, 743, -711, -710, 678, 679, -647, -646, 614, 615, -583, -582, 550, 551,
                           -519, -518, 486, 487, -455, -454, 422, 423, -391, -390, 358, 359, -327, -326, 294, 295, -263, -262, 230, 231, -199, -198, 166,
                            167, -135, -134, 102, 103, -71, -70, 38};


Line Loop(204119) = {201030, -201017, 201004, -202291, 202278, -202265, 202252, -202239, 202226, -202213, 202200, -202187, 202174, -202161, 202148,
                      -202135, 202122, -202109, 202096, -202083, 202070, -202057, 202044, -202031, 202018, -202005, 201992, -201979, 201966, -201953,
                       201940, -201927, 201914, -201901, 201888, -201875, 201862, -201849, 201836, -201823, 201810, -201797, 201784, -201771, 201758,
                        -201745, 201732, -201719, 201706, -201693, 201680, -201667, 201654, -201641, 201628, -201615, 201602, -201589, 201576,
                         -201563, 201550, -201537, 201524, -201511, 201498, -201485, 201472, -201459, 201446, -201433, 201420, -201407, 201394,
                         -201381, 201368, -201355, 201342, -201329, 201316, -201303, 201290, -201277, 201264, -201251, 201238, -201225, 201212,
                          -201199, 201186, -201173, 201160, -201147, 201134, -201121, 201108, -201095, 201082, -201069, 201056, -201043};
