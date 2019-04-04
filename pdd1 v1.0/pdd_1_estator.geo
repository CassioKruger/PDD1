// September 2018 - Author: C. Kruger


Include "pdd_1_ranhuras_estator.geo";

rinterno_estator = 0.160;				//[m]
rexterno_estator = 0.210;				//[m]

step_rad = 90*deg2rad;
initial_ang_rad= 0*deg2rad;
final_ang_rad = 360*deg2rad;

//global variables
rad = 0;
dP=newp;								
dL=newl;								

aux1 = dP;								//primeiro ponto do arco externo			

//loop para criar a borda externa do estator
For rad In {initial_ang_rad:final_ang_rad:step_rad}
	Point(dP)={(Cos(rad)*rexterno_estator),(Sin(rad)*rexterno_estator),0,1.0};
	dP ++;
EndFor

For dL In{dL:dL+6:1}
	Circle(dL)={aux1,0,aux1+1};
	dL++;
	aux1++;
EndFor

Coherence;


