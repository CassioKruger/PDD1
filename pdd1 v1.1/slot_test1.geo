//Setembro, 2018 - Autor: Cássio T. Kruger

Geometry.AutoCoherence = 0;

//----------------------------------//----------------------------------//----------------------------------//----------------------------------
//----------------------------------//        COMEÇANDO PELAS RANHURAS NO ESTATOR 							//----------------------------------
//----------------------------------//----------------------------------//----------------------------------//----------------------------------
//pontos dos centros dos circulos da ranhura
//centros
dP = newp;							//newp retorna a ultima tag de pontos utilizada
dL = newl;							//newl retorna a ultima tag de curvas utilizada (linhas ou arcos)
centro_rr1 = 0.1699975;				//[m]
centro_rr2 = 0.1784328;				//[m]

Point(dP)={centro_rr1,0,0,1.0};		//centro do arco maior da ranhura
pt_centro_rr1 = dP;

Point(dP+1)={centro_rr2,0,0,1.0};		//centro do arco menor da ranhura
pt_centro_rr2 = dP+1;

//raios dos circulos da ranhura
rr1 = 0.00948;							//[m]
rr2 = 0.0106;							//[m]

dP = newp;
// loops para o segundo circulo da ranhura (maior)
For rad In {-Pi/2:Pi/2:Pi/2}
	Point(dP)={Cos(rad)*rr2 + centro_rr2,Sin(rad)*rr2,0,1.0};
	dP++;
EndFor

For dP In {dP-1:dP-2:-1}
	Circle(dL)={dP,pt_centro_rr2,dP-1};
	dL++;
EndFor
dP = newp;

// loops para o primeiro circulo da ranhura (interno)
aux2 = 8*deg2rad;
aux3 = 14*deg2rad;

ang_aux = Asin((1.25*u)/(160*u));

Point(dP)={Cos(Pi/2+aux3)*rr1 + centro_rr1,Sin(Pi/2+aux3)*rr1,0,1.0};						//dP = 6
Point(dP+1)={Cos(Pi-aux2)*rr1 + centro_rr1,Sin(Pi-aux2)*rr1,0,1.0};							//dP = 7
Point(dP+2) = {(Cos(ang_aux*deg2rad)*rinterno_estator -u*u*15),(Sin(Pi-aux2)*rr1), 0, 1.0};			//dP = 8
Point(dP+3) = {(Cos(-ang_aux*deg2rad)*rinterno_estator -u*u*15),(Sin(Pi+aux2)*rr1), 0, 1.0};			//dP = 9
Point(dP+4)={Cos(Pi+aux2)*rr1 + centro_rr1,Sin(Pi+aux2)*rr1,0,1.0};							//dP = 10
Point(dP+5)={Cos(-Pi/2-aux3)*rr1 + centro_rr1,Sin(-Pi/2-aux3)*rr1,0,1.0};					//dP = 11

Line(newl) = {dP,dP-1};																		// linha 5 e 6
Circle(newl) = {dP,pt_centro_rr1,dP+1};														// arco 6 e 7
Line(newl) = {dP+1,dP+2};																	// linha 7 e 8
Line(newl) = {dP+3,dP+4};																	// linha 9 e 10
Circle(newl) = {dP+4,pt_centro_rr1,dP+5};													// arco 10 e 11
Line(newl) = {dP+5,dP-3};																	// linha 11 e 3
Line(newl) = {dP+1,dP+4};

For i In {0:newp-2:1}
	slot_points [i] = i+1;
EndFor
For i In {0:newl-2:1}
	slot_lines [i] = i+1;
EndFor

aux1 = newp;
aux2 = newl;

i=38;
For x In {0:i:1}
	For j In {0:aux1-2:1}
		Rotate {{0, 0, 1}, {0,0,0}, (360/39)*deg2rad*x} 
		{
			Duplicata { Point{slot_points[j]};}
		}
	EndFor
	For j In {0:aux2-2:1}
		Rotate {{0, 0, 1}, {0,0,0}, (360/39)*deg2rad*x} 
		{
			Duplicata { Line{slot_lines[j]};}
		}
	EndFor
EndFor

Coherence;

//Printf ("teste %g", slot_lines[0]);
