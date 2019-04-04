//Setembro, 2018 - Autor: Cássio T. Kruger
//pdd1 - v2.0 

Include "pdd1 - v2 - data.geo";

Geometry.AutoCoherence = 0;

//Stator
R_gs = R_sin-AG;

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


 //build stator slots
For i In {0:N_ss-1}
	 //build two halfs
	 For half In {0:1}

	 //Points definitions-----------------------------------------------------------------//
	 //pontos de uma metade(direita) do slot (ranhura)
	 dP=newp;
	 Point(dP+0) = {0,0,0,m_coarse};
	 //entrada direita do slot
	 Point(dP+1) = {b_1/2, R_sin*Sin((Pi/2)-aux2), 0, 2*m_gap};
	 Point(dP+2) = {b_1/2, h_r1-Sin(aux1)*r1, 0, m_sl_bot};
	 Point(dP+3) = {0, h_r1-Sin(aux1)*r1, 0, m_sl_bot};
	 //centro do circulo inferior
	 Point(dP+4) = {0, h_r1, 0, m_sl_bot};
	 //ponto mais a direita do circulo inferior
	 Point(dP+5) = {b_2,  h_r1, 0, m_sl_bot};
	 //centro do circulo superior
	 Point(dP+6) = {0, h_r2, 0, m_sl_top};
	 //ponto mais a direita do circulo superior
	 Point(dP+7) = {b_3, h_r2, 0, m_sl_top};
	 // ponto mais acima do circulo superior
	 Point(dP+8) = {0, h_r2+r2, 0, m_sl_top};
	 // outer stator sector
	 Point(dP+9) = {R_sout*Sin(Pi/Qs), R_sout*Cos(Pi/Qs), 0, m_s_out};
	 // outer stator center
	 Point(dP+10) = {0, R_sout, 0, m_s_out};
	 // inner stator sector
	 Point(dP+11) = {R_sin*Sin(Pi/Qs), R_sin*Cos(Pi/Qs), 0, 2.5*m_gap};
	 // sliding sector
	 Point(dP+12) = {R_gs*Sin(Pi/Qs), R_gs*Cos(Pi/Qs), 0, 2.4*m_gap};
	 //inner stator center
	 Point(dP+13) = {0, R_sin, 0, 1.5*m_gap};
	 //sliding center
	 Point(dP+14) = {0, R_gs, 0, 1.5*m_gap};

	 //enrolamento mais interno
	 Point(dP+15) = {0, 165.7920*u, 0, 1.5*m_gap}; 			
	 Point(dP+16) = {largura_bob, 165.7920*u, 0, 1.5*m_gap};
	 Point(dP+17) = {largura_bob, (165.7920*u)+altura_bob, 0, 1.5*m_gap};
	 Point(dP+18) = {0, (165.7920*u)+altura_bob, 0, 1.5*m_gap};

	 //enrolamento mais externo
	 Point(dP+19) = {0, 176.1630*u, 0, 1.5*m_gap};
	 Point(dP+20) = {largura_bob, 176.1630*u, 0, 1.5*m_gap};
	 Point(dP+21) = {largura_bob, (176.1630*u)+altura_bob, 0, 1.5*m_gap};
	 Point(dP+22) = {0, (176.1630*u)+altura_bob, 0, 1.5*m_gap};
	 //Points definitions-----------------------------------------------------------------//
	
	 // rotate the built points to the i-th slot position
	 For t In {dP+0:dP+22}
	 	Rotate {{0,0,1},{0,0,0}, 2*Pi*i/Qs+2*Pi/Qs/2} {Point{t};}
	 EndFor
	 If (half==1) //second half
	 For t In {dP+0:dP+22}
	 	Symmetry {Cos(2*Pi*i/Qs+2*Pi/Qs/2),Sin(2*Pi*i/Qs+2*Pi/Qs/2),0,0} {Point{t};}
	 EndFor
	 EndIf

	 //Lines definitions-----------------------------------------------------------------//
	dR=newl-1;
	 //linha ventical da entrada do slot
	 Line(dR+1) = {dP+1,dP+2};
	 //linha horizontal da entrada do slot
	 Line(dR+2) = {dP+2,dP+3};
	 //primeiro arco, da antrada até o ponto mais a direita do circ inferor
	 Circle(dR+3) = {dP+2,dP+4,dP+5};
	 //linha lateral do slot
	 Line(dR+4) = {dP+5,dP+7};
	 //arco direito do circ superior
	 Circle(dR+5) = {dP+7,dP+6,dP+8};
	 //sliding - borda do entreferro
	 Circle(dR+6) = {dP+12,dP+0,dP+14};
	 //slot opening arc - parte inferior da seção
	 Circle(dR+7) = {dP+11,dP+0,dP+1};
	 //arc inner teeth surface  - abertura da entrada do slot
	 Circle(dR+8) = {dP+1,dP+0,dP+13};
	 //outer stator - borda externa do estator
	 Circle(dR+9) = {dP+9,dP+0,dP+10};
	 //vertical central slot opening - centro da entrada do slot
	 Line(dR+10) = {dP+13,dP+3};
	 // centro do slot (dividido em 3 linhas, pois fica entre as bobinas também)
	 Line(dR+11) = {dP+3,dP+15};
	 Line(dR+24) = {dP+18,dP+19};
	 Line(dR+25) = {dP+22,dP+8};
	 //vertical from top of the slot to the stator outer - centro do slot conectado com linha externa do estator
	 Line(dR+12) = {dP+8,dP+10};
	 //sector border via steel - borda da seção (ferro)
	 Line(dR+13) = {dP+11,dP+9};
	 //sector border via airgap - borda da seção (ar)
	 Line(dR+14) = {dP+12,dP+11};
	 //vertical sector center via gap - borda central da seção (ar)
	 Line(dR+15) = {dP+14,dP+13};

	 //-------LINHAS PARA OS ENROLAMENTOS------------------//
	 //enrolamento mais interno
	 Line(dR+16) = {dP+15,dP+16};
	 Line(dR+17) = {dP+16,dP+17};
	 Line(dR+18) = {dP+17,dP+18};
	 Line(dR+19) = {dP+18,dP+15};

	 //enrolamento mais externo
	 Line(dR+20) = {dP+19,dP+20};
	 Line(dR+21) = {dP+20,dP+21};
	 Line(dR+22) = {dP+21,dP+22};
	 Line(dR+23) = {dP+22,dP+19};

	 //Lines definitions-----------------------------------------------------------------//


	 //filling the lists for boundaries
	 OuterStator_[] += dR+9;
	 StatorBoundary_[] += {dR+9,dR+5,dR+3,dR+1,dR+7,dR+4};
	 Sliding_[] += {dR+6};
	 //Periodic boundary
	 If (Qs != N_ss)
		 //right boundary
		 If (i==0 && half==0)
		 	StatorPeriod_Right_[] = {dR+14,dR+15};
		 EndIf
		 //left boundary
		 If (i == N_ss-1 && half==1)
		 	StatorPeriod_Left_[] = {dR+14,dR+15};
		 EndIf
	 EndIf

			 	//if mirrorred, then the lines order is reversed
				//direction is important defining the Line Loops
	 rev = (half ? -1 : 1);

		 //surface of the slot conductors - enrolamento  mais externo
	 Line Loop(newll) = {dR+16,dR+17,dR+18,dR+19};
	 dH = news; Plane Surface(news) = -rev*{newll-1};
	 StatorConductor_Ext[] += dH;

	 	//surface of the slot conductors - enrolamento  mais interno
	 Line Loop(newll) = {dR+20,dR+21,dR+22,dR+23};
	 dH = news; Plane Surface(news) = -rev*{newll-1};
	 StatorConductor_Int[] += dH;
	
		//surface of the stator iron
	 Line Loop(newll) = {dR+1,dR+3,dR+4,dR+5,dR+12,-(dR+9),-(dR+13),dR+7};
	 dH = news; Plane Surface(news) = -rev*{newll-1};
	 StatorIron_[] += dH;

		 //wedges - cunha
	 Line Loop(newll) = {dR+8,dR+10,-dR-2,-dR-1};
	 dH = news; Plane Surface(news) = -rev*{newll-1};
	 StatorWedge_[] += dH;
	
		//airgap stator
	 Line Loop(newll) = {dR+14, dR+7, dR+1, dR+3,dR+4,dR+5, -(dR+25), -(dR+22), -(dR+21), -(dR+20), -(dR+24), -(dR+18), -(dR+17),
	 					-(dR+16), -(dR+11), -(dR+10), -(dR+15), -(dR+6)};
	 dH = news; Plane Surface(news) = rev*{newll-1};
	 StatorAirgapLayer_[] += dH;
	
	 EndFor
EndFor

//---------------- Superficies para as fases (A,B,C) dos enrolamentos 



