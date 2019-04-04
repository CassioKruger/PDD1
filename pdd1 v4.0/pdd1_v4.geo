//Outubro, 2018 - Autor: Cássio T. Kruger
//UFPel - Eng. de Controle e Automação
//pdd1 - v4.0

Solver.AutoShowLastStep = 1;
Mesh.Algorithm = 1;

Include "pdd1_v4_data.geo" ;
Include "pdd1_v4_stator.geo" ;
Include "pdd1_v4_rotor.geo" ;

Mesh.CharacteristicLengthFactor = 0.01;
//Mesh 2;

// For nice visualisation...
Mesh.Light = 0 ;

Hide { Line{ Line '*' }; }
Hide { Point{ Point '*' }; }

Physical Line("NICEPOS") = { nicepos_rotor[], nicepos_stator[] };
Show { Line{ nicepos_rotor[], nicepos_stator[] }; }

//For post-processing...
View[PostProcessing.NbViews-1].Light = 0;
View[PostProcessing.NbViews-1].NbIso = 50; // Number of intervals
View[PostProcessing.NbViews-1].IntervalsType = 1;

//que merda de git
//ta tudo certo já, nos entendemos

