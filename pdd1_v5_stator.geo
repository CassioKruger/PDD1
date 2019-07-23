//Outubro, 2018 - Autor: Cássio T. Kruger
//UFPel - Eng. de Controle e Automação
//pdd1 - v5.0

Geometry.AutoCoherence = 0;

//dimensões das bobinas (vertical, para o lado esquerdo)
largura_bob = (12.6415*u)/2; 	//[m]
altura_bob 	= 8.2980*u;  	//[m]

//raios dos circulos da ranhura
r1 = 9.4844*u;								//[m]
r2 = 10.5950*u;								//[m]

//altura dos circulos da ranhura em relação ao centro
h_r1 = 169.9967*u;							//[m]
h_r2 = 178.4330*u; 							//[m]

//Slot dimensions
b_1 = 2.5*u;							//largura da entrada do slot
b_2 = r1;								//raio do primeiro circulo do slot
b_3 = r2;								// raio do segundo circulo do slot
aux1 = Acos((b_1/2)/b_2);
h_1 = Sin(aux1)*r1;						//comprimento da entrada do slot (depende do raio interno e do raio do primeiro arco)
aux2 = Asin((b_1/2)/R_sin);

phase_a_plus_ext[] = {0,12,13,24,25,38};		//6
phase_a_plus_int[] = {0,1,2,13,14,26,27};		//7
phase_a_minus_ext[] = {5,6,7,19,18,31,32};		//7
phase_a_minus_int[] = {8,7,20,19,33,34};		//6

phase_b_plus_ext[] = {3,4,16,17,29,30};			//6
phase_b_plus_int[] = {5,6,17,18,30,31,32};		//7
phase_b_minus_ext[] = {10,11,22,23,35,36,37};	//7
phase_b_minus_int[] = {11,12,24,25,37,38};		//6

phase_c_plus_ext[] = {8,9,20,21,33,34};			//6
phase_c_plus_int[] = {9,10,21,22,23,35,36};		//7
phase_c_minus_ext[] = {1,2,14,15,26,27,28};		//7
phase_c_minus_int[] = {3,4,15,16,28,29};		//6


//build stator slots
For i In {0:N_ss-1}
	 //build two halfs
	 For half In {0:1}

	 //pontos de uma metade(direita) do slot (ranhura)
	 //Points
	 dP=newp;
	 Point(dP+0) = {0,0,0,1.0};

	 Point(dP+1) = {b_1/2, R_sin*Sin((Pi/2)-aux2), 0, pslo};					//entrada direita do slot
	 Point(dP+2) = {b_1/2, h_r1-Sin(aux1)*r1, 0, pslo};
	 Point(dP+3) = {0, h_r1-Sin(aux1)*r1, 0, pslo};
	 Point(dP+4) = {0, h_r1, 0, psl};																	//centro do circulo inferior
	 Point(dP+5) = {b_2,  h_r1, 0, psl};															//ponto mais a direita do circulo inferior
	 Point(dP+6) = {0, h_r2, 0, psl};																	//centro do circulo superior
	 Point(dP+7) = {b_3, h_r2, 0, psl};																//ponto mais a direita do circulo superior
	 Point(dP+8) = {0, h_r2+r2, 0, pout};															//ponto mais acima do circulo superior
	 Point(dP+9) = {R_sout*Sin(Pi/Qs), R_sout*Cos(Pi/Qs), 0, pout};		//outer stator sector
	 Point(dP+10) = {0, R_sout, 0, pout};															//outer stator center
	 Point(dP+11) = {R_sin*Sin(Pi/Qs), R_sin*Cos(Pi/Qs), 0, pslo};		//inner stator sector
	 Point(dP+12) = {0, R_sin, 0, pslo};															//inner stator center

	 //enrolamento mais interno
	 Point(dP+13) = {0, 165.7920*u, 0, 1.5*psl};
	 Point(dP+14) = {largura_bob, 165.7920*u, 0, psl};
	 Point(dP+15) = {largura_bob, (165.7920*u)+altura_bob, 0, psl};
	 Point(dP+16) = {0, (165.7920*u)+altura_bob, 0, psl};

	 //enrolamento mais externo
	 Point(dP+17) = {0, 176.1630*u, 0, psl};
	 Point(dP+18) = {largura_bob, 176.1630*u, 0, psl};
	 Point(dP+19) = {largura_bob, (176.1630*u)+altura_bob, 0, psl};
	 Point(dP+20) = {0, (176.1630*u)+altura_bob, 0, psl};

	 // rotate the built points to the i-th slot position
	 For t In {dP+0:dP+20}
	 	Rotate {{0,0,1},{0,0,0}, 2*Pi*i/Qs+2*Pi/Qs/2} {Point{t};}
	 EndFor

	 If (half==1) //second half
		 For t In {dP+0:dP+20}
		 	Symmetry {Cos(2*Pi*i/Qs+2*Pi/Qs/2),Sin(2*Pi*i/Qs+2*Pi/Qs/2),0,0} {Point{t};}
		 EndFor
	 EndIf

	 //Lines
	dR=newl-1;

	 Line(dR+1) = {dP+1,dP+2};							//linha ventical da entrada do slot
	 Line(dR+2) = {dP+2,dP+3};							//linha horizontal da entrada do slot
	 Circle(dR+3) = {dP+2,dP+4,dP+5};					//primeiro arco, da antrada até o ponto mais a direita do circ inferor
	 Line(dR+4) = {dP+5,dP+7};							//linha lateral do slot

	 Transfinite Line {dR+2} = 3 Using Progression 1;
	 Transfinite Line {dR+3} = 10 Using Progression 1;

	 Circle(dR+5) = {dP+7,dP+6,dP+8};					//arco direito do circ superior
	 Circle(dR+6) = {dP+11,dP+0,dP+1};					//slot opening arc - parte inferior da seção
	 Circle(dR+7) = {dP+1,dP+0,dP+12};					//arc inner teeth surface  - abertura da entrada do slot

	 Transfinite Line {dR+6} = 15 Using Progression 1;
	 Transfinite Line {dR+7} = 3 Using Progression 1;

	 Circle(dR+8) = {dP+9,dP+0,dP+10};					//outer stator - borda externa do estator
	 Line(dR+9) = {dP+12,dP+3};						//vertical central slot opening - centro da entrada do slot
	 Line(dR+10) = {dP+3,dP+13}; 						// centro do slot (dividido em 3 linhas, pois fica entre as bobinas também)
	 Line(dR+11) = {dP+16,dP+17};
	 Line(dR+12) = {dP+20,dP+8};
	 Line(dR+13) = {dP+8,dP+10}; 						 //centro do slot conectado com linha externa do estator
	 Line(dR+14) = {dP+11,dP+9};						 //sector border via steel - borda da seção (ferro)

	 //-------LINHAS PARA OS ENROLAMENTOS------------------//
	 //enrolamento mais externo
	 Line(dR+15) = {dP+13,dP+14};
	 Line(dR+16) = {dP+14,dP+15};
	 Line(dR+17) = {dP+15,dP+16};
	 Line(dR+18) = {dP+16,dP+13};

	 //enrolamento mais interno
	 Line(dR+19) = {dP+17,dP+18};
	 Line(dR+20) = {dP+18,dP+19};
	 Line(dR+21) = {dP+19,dP+20};
	 Line(dR+22) = {dP+20,dP+17};
/*
	 Transfinite Line {dR+6} = 30 Using Progression 1;
	 Transfinite Line {dR+7} = 6 Using Progression 1;
*/
	 //filling the lists for boundaries
	 If (Flag_OpenStator == 0)
	 	InnerStator_[] += {dR+7,dR+6}; //slot fechado
	 EndIf

	 If (Flag_OpenStator != 0)
	 	InnerStator_[] += {dR+1,dR+6,dR+3,dR+4,dR+5}; //slot aberto
	 EndIf

	 OuterStator_[] += dR+8;

	 //Periodic boundary
	 If (Qs != N_ss)
		 //right boundary
		 If (i==0 && half==0)
		 	StatorPeriod_Right_[] = {dR+14};
		 EndIf
		 //left boundary
		 If (i==(N_ss-1) && half==1)
		 	StatorPeriod_Left_[] = {dR+14};
		 EndIf
	 EndIf
	 	//if mirrorred, then the lines order is reversed
		//direction is important defining the Line Loops
	 rev = (half ? -1 : 1);

	 innerTest_[] += -rev*{(dR+7),(dR+6)};

	//FASE_A_FASE_A_FASE_A_FASE_A_FASE_A_FASE_A_FASE_A_FASE_A_FASE_A_FASE_A_FASE_A_FASE_A_
		 //fases A POSITIVA na parte EXTERNA
		 For aux In {0:5:1}
			 If(i == phase_a_plus_ext[aux])
				 Line Loop(newll) = {dR+20,dR+21,dR+22,dR+19};
				 dH = news; Plane Surface(news) = -rev*{newll-1};
				 PhaseA_Plus_[] += dH;
			 EndIf
		 EndFor

		 //fases A POSITIVA na parte INTERNA
		 For aux In {0:6:1}
			 If(i == phase_a_plus_int[aux])
				 Line Loop(newll) = {dR+16,dR+17,dR+18,dR+15};
				 dH = news; Plane Surface(news) = -rev*{newll-1};
				 PhaseA_Plus_[] += dH;
			 EndIf
		 EndFor

		 //fases A NEGATIVA na parte EXTERNA
		 For aux In {0:6:1}
			 If(i == phase_a_minus_ext[aux])
				 Line Loop(newll) = {dR+20,dR+21,dR+22,dR+19};
				 dH = news; Plane Surface(news) = -rev*{newll-1};
				 PhaseA_Minus_[] += dH;
			 EndIf
		 EndFor

		 //fases A NEGATIVA na parte INTERNA
		 For aux In {0:5:1}
			 If(i == phase_a_minus_int[aux])
				 Line Loop(newll) = {dR+16,dR+17,dR+18,dR+15};
				 dH = news; Plane Surface(news) = -rev*{newll-1};
				 PhaseA_Minus_[] += dH;
			 EndIf
		 EndFor

	//FASE_B_FASE_B_FASE_B_FASE_B_FASE_B_FASE_B_FASE_B_FASE_B_FASE_B_FASE_B_FASE_B_FASE_B_
		//fases B POSITIVA na parte EXTERNA
		For aux In {0:5:1}
			 If(i == phase_b_plus_ext[aux])
				 Line Loop(newll) = {dR+20,dR+21,dR+22,dR+19};
				 dH = news; Plane Surface(news) = -rev*{newll-1};
				 PhaseB_Plus_[] += dH;
			 EndIf
		 EndFor

		 //fases B POSITIVA na parte INTERNA
		 For aux In {0:6:1}
			 If(i == phase_b_plus_int[aux])
				 Line Loop(newll) = {dR+16,dR+17,dR+18,dR+15};
				 dH = news; Plane Surface(news) = -rev*{newll-1};
				 PhaseB_Plus_[] += dH;
			 EndIf
		 EndFor

		 //fases B NEGATIVA na parte EXTERNA
		 For aux In {0:6:1}
			 If(i == phase_b_minus_ext[aux])
				 Line Loop(newll) = {dR+20,dR+21,dR+22,dR+19};
				 dH = news; Plane Surface(news) = -rev*{newll-1};
				 PhaseB_Minus_[] += dH;
			 EndIf
		 EndFor

		 //fases B NEGATIVA na parte INTERNA
		 For aux In {0:5:1}
			 If(i == phase_b_minus_int[aux])
				 Line Loop(newll) = {dR+16,dR+17,dR+18,dR+15};
				 dH = news; Plane Surface(news) = -rev*{newll-1};
				 PhaseB_Minus_[] += dH;
			 EndIf
		 EndFor

	//FASE_C_FASE_C_FASE_C_FASE_C_FASE_C_FASE_C_FASE_C_FASE_C_FASE_C_FASE_C_FASE_C_FASE_C_
		 //fases C POSITIVA na parte EXTERNA
		For aux In {0:5:1}
			 If(i == phase_c_plus_ext[aux])
				 Line Loop(newll) = {dR+20,dR+21,dR+22,dR+19};
				 dH = news; Plane Surface(news) = -rev*{newll-1};
				 PhaseC_Plus_[] += dH;
			 EndIf
		 EndFor

		 //fases C POSITIVA na parte INTERNA
		 For aux In {0:6:1}
			 If(i == phase_c_plus_int[aux])
				 Line Loop(newll) = {dR+16,dR+17,dR+18,dR+15};
				 dH = news; Plane Surface(news) = -rev*{newll-1};
				 PhaseC_Plus_[] += dH;
			 EndIf
		 EndFor

		 //fases C NEGATIVA na parte EXTERNA
		 For aux In {0:6:1}
			 If(i == phase_c_minus_ext[aux])
				 Line Loop(newll) = {dR+20,dR+21,dR+22,dR+19};
				 dH = news; Plane Surface(news) = -rev*{newll-1};
				 PhaseC_Minus_[] += dH;
			 EndIf
		 EndFor

		 //fases C NEGATIVA na parte INTERNA
		 For aux In {0:5:1}
			 If(i == phase_c_minus_int[aux])
				 Line Loop(newll) = {dR+16,dR+17,dR+18,dR+15};
				 dH = news; Plane Surface(news) = -rev*{newll-1};
				 PhaseC_Minus_[] += dH;
			 EndIf
		 EndFor

		//surface of the stator iron
	 Line Loop(newll) = {dR+13, -(dR+8), -(dR+14), dR+6, dR+1, dR+3, dR+4, dR+5};
	 dH = news; Plane Surface(news) = -rev*{newll-1};
	 StatorIron_[] += dH;

		 //wedges - cunha
	 Line Loop(newll) = {dR+1, dR+2, -(dR+9), -(dR+7)};
	 dH = news; Plane Surface(news) = -rev*{newll-1};
	 StatorSlotOpening_[] += dH;

		//air stator
	 Line Loop(newll) = {dR+2, dR+10, dR+15, dR+16, dR+17, dR+11,
	 					 dR+19, dR+20, dR+21, dR+12, -(dR+5), -(dR+4),
	 					 -(dR+3)};
	 dH = news; Plane Surface(news) = rev*{newll-1};
	 StatorAir_[] += dH;




	 EndFor
EndFor



//---------------------------------stator-----------------------------------------//
Physical Surface("StatorSlotOpening", STATOR_SLOTOPENING) = {StatorSlotOpening_[]};



If (Qs != N_ss)
	Physical Line(STATOR_BND_A0) = {StatorPeriod_Right_[]};
	Physical Line(STATOR_BND_A1) = {StatorPeriod_Left_[]};
EndIf

Physical Line(SURF_EXT) = {OuterStator_[]};
Physical Line(INNER_STATOR) = {innerTest_[]};

//---------------- Superficies para as fases (A,B,C) dos enrolamentos

Physical Surface("stator phase A (-)", STATOR_IND_AM) = {PhaseA_Minus_[]};
Physical Surface("stator phase C (+)", STATOR_IND_CP) = {PhaseC_Plus_[]};
Physical Surface("stator phase B (-)", STATOR_IND_BM) = {PhaseB_Minus_[]};
If(NbrSectStator>2)
  Physical Surface("stator phase A (+)", STATOR_IND_AP) = {PhaseA_Plus_[]};
  Physical Surface("stator phase C (-)", STATOR_IND_CM) = {PhaseC_Minus_[]};
  Physical Surface("stator phase B (+)", STATOR_IND_BP) = {PhaseB_Plus_[]};
EndIf

//-------PHASE A--------//
Color Red1 {Surface{PhaseA_Plus_[]};}
Color Red4 {Surface{PhaseA_Minus_[]};}

//-------PHASE B--------//
Color Green1 {Surface{PhaseB_Plus_[]};}
Color Green4 {Surface{PhaseB_Minus_[]};}

//-------PHASE C--------//
Color Yellow1 {Surface{PhaseC_Plus_[]};}
Color Goldenrod4 {Surface{PhaseC_Minus_[]};}

Coherence;

If(Flag_OpenStator)
  nicepos_stator[] = CombinedBoundary{Surface{StatorIron_[]};};
  nicepos_stator[] += CombinedBoundary{Surface{StatorSlotOpening_[], StatorAir_[]};};
EndIf
If(!Flag_OpenStator)
  nicepos_stator[] = CombinedBoundary{Surface{StatorIron_[],StatorSlotOpening_[]};};
  nicepos_stator[] += CombinedBoundary{Surface{StatorAir_[]};};
EndIf
