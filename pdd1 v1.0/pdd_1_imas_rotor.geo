// September 2018 - Author: C. Kruger

Include "pdd_1_estator.geo";

m2mm	= 0.001;
mm2m 	= 1000;
deg2rad = Pi/180 ;
airgap = 0.01;						//[m]
reixo = 0.0495;						//[m]
rinterno_estator = 0.160;			//[m]
espessura_imas = 0.008;				//[m]
polos = 6;

rexterno_imas = rinterno_estator - airgap;
rinterno_imas = rexterno_imas - espessura_imas;

dP=newp;
dL=newl;

aux1=dP;

//criando os imas
For rad In {0:360*deg2rad:(360/polos)*deg2rad}
	Point(dP)={Cos(rad)*rexterno_imas,Sin(rad)*rexterno_imas,0,1.0};
	dP ++;
	Point(dP)={Cos(rad)*rinterno_imas,Sin(rad)*rinterno_imas,0,1.0};
	dP ++;
EndFor

For j In {0:(polos*2)-1:1}
	Circle(dL)={aux1+j,0,(aux1+j)+2};
	dL++;
EndFor

dL = newl;
For j In {0:11:2}
	Line(dL)={aux1+j,aux1+j+1};
	dL ++;
EndFor

dP=newp;
aux1=dP;

//criando o rotor
For rad In {0:360*deg2rad:(360/polos)*deg2rad}
	Point(dP)={Cos(rad)*reixo,Sin(rad)*reixo,0,1.0};
	dP ++;
EndFor

dL = newl;
For j In {0:(polos-1):1}
	Circle(dL)={aux1+j,0,(aux1+j)+1};
	dL++;
EndFor

Coherence;


