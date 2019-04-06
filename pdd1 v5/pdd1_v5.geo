//Novembro, 2018 - Autor: Cássio T. Kruger
//UFPel - Eng. de Controle e Automação
//pdd1 - v5.0

Solver.AutoShowLastStep = 1;
Mesh.Algorithm = 1;

Include "pdd1_v5_data.geo" ;
Include "pdd1_v5_stator.geo" ;
Include "pdd1_v5_stator_mags.geo" ;
Include "pdd1_v5_rotor1.geo" ;
Include "pdd1_v5_rotor2.geo" ;

Mesh.CharacteristicLengthFactor = 0.01;
//Mesh 2;

// For nice visualisation...
Mesh.Light = 0 ;

Hide { Line{ Line '*' }; }
Hide { Point{ Point '*' }; }

Physical Line("NICEPOS") = { nicepos_rotor[],nicepos_rotor2[], nicepos_stator[],nicepos_stator_mag[] };
Show { Line{ nicepos_rotor[],nicepos_rotor2[], nicepos_stator[],nicepos_stator_mag[] }; }


//For post-processing...
View[PostProcessing.NbViews-1].Light = 0;
View[PostProcessing.NbViews-1].NbIso = 80;              // Number of intervals
View[PostProcessing.NbViews-1].IntervalsType = 1;       // 1 - Iso Values; 2 - Continuous Map

//+
Coherence;
//+
Coherence;
//+
Coherence;
