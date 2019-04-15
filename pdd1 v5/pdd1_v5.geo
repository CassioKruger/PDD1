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
pslo = mm * 2*2/2/1.5; // slot opening
psl  = mm * 1.8; // upper part slot
pout = mm * 8; // outer radius
pMB  = mm * 0.8 * 2/2; // MB
p  = mm*12*0.05*1.3;    //rotor 

Include "pdd1_v5_stator.geo" ;
Include "pdd1_v5_stator_mags.geo" ;
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

