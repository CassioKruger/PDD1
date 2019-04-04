// September 2018 - Author: C. Kruger

m2mm	= 0.001;
mm2m 	= 1000;
deg2rad = Pi/180 ;
airgap = 0.0005;					//[m]
rinterno_estator = 0.160;			//[m]

Point(0)={0,0,0,1.0};				//pt central, referência para os arcos
//pontos dos centros dos circulos da ranhura
//centros
dP = newp;							//newp retorna a ultima tag de pontos utilizada
dL = 1;								//newl retorna a ultima tag de curvas utilizada (linhas ou arcos)
centro_rr1 = 0.1699975;				//[m]
centro_rr2 = 0.1784328;				//[m]

Point(dP)={centro_rr1,0,0,1.0};		//centro do arco maior da ranhura
pt_centro_rr1 = dP;
dP++;

Point(dP)={centro_rr2,0,0,1.0};		//centro do arco menor da ranhura
pt_centro_rr2 = dP;
dP++;

//raios dos circulos da ranhura
rr1 = 0.00948;							//[m]
rr2 = 0.0106;							//[m]

// loops para o segundo circulo da ranhura (maior)
For rad In {-Pi/2:Pi/2:Pi/4}
	posx = Cos(rad)*rr2 + centro_rr2;
	posy = Sin(rad)*rr2;
	Point(dP)={posx,posy,0,1.0};
	dP++;
EndFor
aux1 = dP;
For dP In {dP-1:dP-4:-1}
	Circle(dL)={dP,pt_centro_rr2,dP-1};
	dL++;
EndFor
dP = aux1;

// loops para o primeiro circulo da ranhura (interno)
aux2 = 8*deg2rad;
aux3 = 14*deg2rad;
posx = Cos(Pi/2+aux3)*rr1 + centro_rr1;
posy = Sin(Pi/2+aux3)*rr1;
Point(dP)={posx,posy,0,1.0};
dP ++;
posx = Cos(Pi-aux2)*rr1 + centro_rr1;
posy = Sin(Pi-aux2)*rr1;
Point(dP)={posx,posy,0,1.0};
dP ++;
Circle(dL)={dP-1,pt_centro_rr1,dP-2};
dL++;

posx = Cos(Pi+aux2)*rr1 + centro_rr1;
posy = Sin(Pi+aux2)*rr1;
Point(dP)={posx,posy,0,1.0};
dP ++;
posx = Cos(-Pi/2-aux3)*rr1 + centro_rr1;
posy = Sin(-Pi/2-aux3)*rr1;
Point(dP)={posx,posy,0,1.0};
dP ++;
Circle(dL)={dP-1,pt_centro_rr1,dP-2};
dL++;

//direto no software
Line(dL) = {11, 3};
Line(dL+1) = {8, 7};

Point(dP) = {(Cos(Pi+aux2)*rr1 + centro_rr1 - 0.5*m2mm),(Sin(Pi+aux2)*rr1), 0, 1.0};
dP ++;
Point(dP) = {(Cos(Pi-aux2)*rr1 + centro_rr1 - 0.5*m2mm),(Sin(Pi-aux2)*rr1), 0, 1.0};
dP ++;

Line(dL+2) = {9, 13};
Line(dL+3) = {12, 10};

i=38;
For x In {0:i:1}
	Rotate {{0, 0, 1}, {0,0,0}, (360/39)*deg2rad*x} 
	{
	  Duplicata { Line{5}; Line{8}; Line{1}; Line{2}; Line{3}; Line{4}; Line{7}; 
	  			Line{6}; Line{9}; Line{10}; Point{12}; Point{10}; Point{9}; Point{13};  Point{8};
	  			 Point{7}; Point{6}; Point{5}; Point{4}; Point{3}; Point{11}; Point{1}; Point{2}; }
	}
EndFor

dL=newl;
Circle(dL)={13,0,56};
Circle(dL+1)={1644,0,12};

For x In {0:i-2:1}
	dL=newl;
	Circle(dL)={(43*x)+53,0,(43*x)+99};
EndFor






