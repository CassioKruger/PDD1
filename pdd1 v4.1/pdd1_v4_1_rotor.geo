//Outubro, 2018 - Autor: Cássio T. Kruger
//UFPel - Eng. de Controle e Automação
//pdd1 - v4.0

Geometry.AutoCoherence = 0;

//rotor
R_gr = R_rout+h_m+AG;

//Slot dimensions
b_1 = 133*u;							//largura da entrada do slot - largura do imã
aux1 = (2*Pi)/(Qr*2);					//angulo da seção

 //build stator slots
For i In {0:N_rs-1}
	 //build two halfs
	 For half In {0:1}

	 //Points definitions-----------------------------------------------------------------//
	 //points of one half
		dP=newp;
		Point(dP+0) = {0,0,0,m_coarse};
		 //primeiro ponto da base da seção do rotor
		Point(dP+1) = {0,R_rin,0,m_normal};
		 //ponto mais a direita da base da seção do rotor
		Point(dP+2) = {Cos((Pi/2)-aux1)*R_rin,Sin((Pi/2)-aux1)*R_rin,0,m_normal};
		 //primeiro ponto da parte superior da seção do rotor
		Point(dP+3)={0,R_rout,0,m_normal};
		 //ponto mais a direita da parte ro rotor na seção (metal)
		Point(dP+4) = {Cos((Pi/2)-aux1)*R_rout,Sin((Pi/2)-aux1)*R_rout,0,m_normal};
		 //ponto mais a cima do imã
		Point(dP+5) = {0,R_rout+h_m,0,m_normal};
		 //ponto mais a direita do imã, na borda da seção
		Point(dP+6) = {Cos((Pi/2)-aux1)*(R_rout+h_m),Sin((Pi/2)-aux1)*(R_rout+h_m),0,m_normal};
		 //sliding - centro
		Point(dP+7) = {0,R_gr,0,m_normal};
		 //sliding - borda da seção
		Point(dP+8) = {Cos((Pi/2)-aux1)*(R_gr),Sin((Pi/2)-aux1)*(R_gr),0,m_normal};
	 //Points definitions-----------------------------------------------------------------//
	
	For t In {dP+0:dP+8}
	 	Rotate {{0,0,1},{0,0,0}, RotorAngle_R+2*Pi*i/NbrSectTot} {Point{t};}
	 EndFor

	 If (half==1) //second half
		 For t In {dP+0:dP+8}
		 	Symmetry {Cos(RotorAngle_S+2*Pi*i/NbrSectTot), Sin(RotorAngle_S+2*Pi*i/NbrSectTot),0,0} {Point{t};}
		 EndFor
	 EndIf

	 //Lines definitions-----------------------------------------------------------------//
	//lines of one half
		dR=newl-1;
		 //arco da base da seção
		Circle(dR+1) = {dP+1,dP+0,dP+2};
		 //linha do centro da seção (entre R_rin e R_rout)
		Line(dR+2) = {dP+1,dP+3};
		 //linha da borda da seção (entre R_rin e R_rout)
		Line(dR+3) = {dP+2,dP+4};
		 //arco externo do rotor
		Circle(dR+4) = {dP+3,dP+0,dP+4}; 
		 //linha centro da seção (ligando rotor e imã)
		Line(dR+5) = {dP+3,dP+5};
		 //linha borda da seção (ligando rotor e imã)
		Line(dR+6) = {dP+4,dP+6};
		 //borda externa do imã
		Circle(dR+7) = {dP+5,dP+0,dP+6};
		 //linha centro da seção (imã e airgap)
		Line(dR+8) = {dP+5,dP+7};
		 //sliding (entreferro e imã)
		Circle(dR+9) = {dP+7,dP+0,dP+8};
		 //linha borda da seção (sliding entreferro e imã)
		Line(dR+10) = {dP+8,dP+6};
	 //Lines definitions-----------------------------------------------------------------//


	 //filling the lists for boundaries
	 INnerRotor_[] += dR+1;
	 OuterRotor_[] += dR+4;
	 RotorSliding_[] += {dR+9};

	 //Periodic boundary
	 If (Qr != N_rs)
	 	 //right boundary
		 If (i == 0 && half==0)
		 	RotorPeriod_Right_[] = {dR+3};	 	
		 EndIf
		 //left boundary
		 If (i == (N_rs-1) && half==1)
		 	RotorPeriod_Left_[] = {dR+3};
		 EndIf
	 EndIf	

	 		 	//if mirrorred, then the lines order is reversed
				//direction is important defining the Line Loops
	 rev = (half ? -1 : 1);

		//surface of the rotor iron
	 Line Loop(newll) = {dR+1,dR+3,-(dR+4),-(dR+2)};
	 dH = news; Plane Surface(news) = -rev*{newll-1};
	 RotorIron_[] += dH;

	 If (i%2==0)
			//surface of magnetics (NORTE)
		 Line Loop(newll) = {dR+4,dR+6,-(dR+7),-(dR+5)};
		 dH = news; Plane Surface(news) = -rev*{newll-1};
		 RotorMagneticsNorth_[] += dH;
	 EndIf

	 If (i%2!=0)
	 			//surface of magnetics (SUL)
		 Line Loop(newll) = {dR+4,dR+6,-(dR+7),-(dR+5)};
		 dH = news; Plane Surface(news) = -rev*{newll-1};
		 RotorMagneticsSouth_[] += dH;
		 
	 EndIf

	 
	 //surface of magnetics
	 Line Loop(newll) = {dR+4,dR+6,-(dR+7),-(dR+5)};
	 dH = news; Plane Surface(news) = -rev*{newll-1};
	 RotorMagnetics_[] += dH;

		//airgap rotor
	 Line Loop(newll) = {dR+7,-(dR+10),-(dR+9),-(dR+8)};
	 dH = news; Plane Surface(news) = rev*{newll-1};
	 RotorAirgapLayer_[] += dH;

	 EndFor
EndFor

// Completing moving band
NN = #RotorSliding_[] ;
k1 = (NbrPolesInModel==1)?NbrPolesInModel:NbrPolesInModel+1;
For k In {k1:NbrPolesTot-1}
  RotorSliding_[] += Rotate {{0, 0, 1}, {0, 0, 0}, k*NbrSect*2*(Pi/NbrSectTot)} { Duplicata{ Line{RotorSliding_[{0:NN-1}]};} };
EndFor


//---------------------------------rotor-----------------------------------------//
Physical Surface(ROTOR_FE) = {RotorIron_[]};
Physical Surface(ROTOR_AIRGAP) = {RotorAirgapLayer_[]};
Physical Surface("RotorMagNORTE") = {RotorMagneticsNorth_[]};
If (N_rs>1)
	Physical Surface("RotorMagSUL") = {RotorMagneticsSouth_[]};
	Color Blue {Surface{RotorMagneticsSouth_[]};}
EndIf

//Physical Surface(ROTOR_MAGNET) = {RotorMagnetics_[]};

auxiliar = 0;

NN = (Flag_Symmetry)?NbrPolesInModel:NbrPolesTot;
Printf("rotor magnet %g",NN);
For k In {0:(NN-1)*2:2}
  Physical Surface(Sprintf("rotor magnet %g",auxiliar),ROTOR_MAGNET+auxiliar) = {RotorMagnetics_[k],RotorMagnetics_[k+1]}; // Magnets
  auxiliar++;
EndFor

Color SteelBlue {Surface{RotorIron_[]};}
Color SkyBlue {Surface{RotorAirgapLayer_[]};}
Color Orchid {Surface{RotorMagneticsNorth_[]};}

If (Qr != N_rs)
	RotorBoundary_[] = {INnerRotor_[],OuterRotor_[],RotorPeriod_Right_[],RotorPeriod_Left_[]};
	Physical Line(ROTOR_BND_A0) = {RotorPeriod_Right_[]};
	Physical Line(ROTOR_BND_A1) = {RotorPeriod_Left_[]};
EndIf

If (Qr == N_rs)
	RotorBoundary_[] = {INnerRotor_[],OuterRotor_[]};
EndIf

Physical Line(SURF_INT) = {INnerRotor_[]};
Physical Line(ROTOR_BND_MOVING_BAND) = {RotorSliding_[]};

Coherence;

nicepos_rotor[] = CombinedBoundary{Surface{RotorIron_[]};};
nicepos_rotor[] += CombinedBoundary{Surface{RotorMagneticsSouth_[]};};
nicepos_rotor[] += CombinedBoundary{Surface{RotorMagneticsNorth_[]};};
nicepos_rotor[] += CombinedBoundary{Surface{RotorAirgapLayer_[]};};





