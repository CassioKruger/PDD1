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

Physical Line(NICEPOS) = { nicepos_rotor[],nicepos_rotor2[], nicepos_stator[],nicepos_stator_mag[] };
Show { Line{ nicepos_rotor[],nicepos_rotor2[], nicepos_stator[],nicepos_stator_mag[] }; }

//For post-processing...
View[PostProcessing.NbViews-1].Light = 0;
View[PostProcessing.NbViews-1].NbIso = 30;              // Number of intervals
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
