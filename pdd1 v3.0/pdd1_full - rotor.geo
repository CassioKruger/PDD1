//Setembro, 2018 - Autor: Cássio T. Kruger
//pdd1 - v2.0

Include "pdd1_full - stator.geo";

Geometry.AutoCoherence = 0;

//Mesh density
m_coarse = 10;
m_normal = 8;
m_gap = 0.5;
m_sl_bot = 4;
m_sl_top = 1;
m_r_in = 10;

//rotor
R_gr = R_gs;

//Slot dimensions
b_1 = 133*u;              //largura da entrada do slot - largura do imã
aux1 = (2*Pi)/(Qr*2);         //angulo da seção


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
  
   // rotate the built points to the i-th slot position
   For t In {dP+0:dP+8}
    Rotate {{0,0,1},{0,0,0}, 2*Pi*i/Qr+2*Pi/Qr/2} {Point{t};}
   EndFor
   If (half==1) //second half
   For t In {dP+0:dP+8}
    Symmetry {Cos(2*Pi*i/Qr+2*Pi/Qr/2),Sin(2*Pi*i/Qr+2*Pi/Qr/2),0,0} {Point{t};}
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
   OuterRotor_[] += dR+4;
   RotorBoundary_[] += {dR+4,dR+1};
   Sliding_[] += {dR+9};
   //Periodic boundary
   If (Qs != N_ss)
     //right boundary
     If (i==0 && half==0)
      //RotortorPeriod_Right_[] = {dR+14,dR+15};
     EndIf
     //left boundary
     If (i == N_ss-1 && half==1)
      //RotorPeriod_Left_[] = {dR+14,dR+15};
     EndIf
   EndIf

        //if mirrorred, then the lines order is reversed
        //direction is important defining the Line Loops
   rev = (half ? -1 : 1);

     //surface of the slot conductors - enrolamento  mais externo
   //Line Loop(newll) = {dR+16,dR+17,dR+18,dR+19};
   //dH = news; Plane Surface(news) = -rev*{newll-1};
   //StatorConductor_Ext[] += dH;

    //surface of the slot conductors - enrolamento  mais interno
   //Line Loop(newll) = {dR+20,dR+21,dR+22,dR+23};
   //dH = news; Plane Surface(news) = -rev*{newll-1};
   //StatorConductor_Int[] += dH;
  
    //surface of the rotor iron
   Line Loop(newll) = {dR+1,dR+3,-(dR+4),-(dR+2)};
   dH = news; Plane Surface(news) = -rev*{newll-1};
   RotorIron_[] += dH;

    //surface of magnetics
   Line Loop(newll) = {dR+4,dR+6,-(dR+7),-(dR+5)};
   dH = news; Plane Surface(news) = -rev*{newll-1};
   RotorMagnetics_[] += dH;

     //wedges - cunha
   //Line Loop(newll) = {dR+8,dR+10,-dR-2,-dR-1};
   //dH = news; Plane Surface(news) = -rev*{newll-1};
   //StatorWedge_[] += dH;
  
    //airgap rotor
   Line Loop(newll) = {dR+7,-(dR+10),-(dR+9),-(dR+8)};
   dH = news; Plane Surface(news) = rev*{newll-1};
   StatorAirgapLayer_[] += dH;

   EndFor
EndFor





//---------------------------------stator-----------------------------------------//
Physical Surface("StatorIron") = {StatorIron_[]};
Physical Surface("StatorWedges") = {StatorWedge_[]};
Physical Surface("StatorAirgap") = {StatorAirgapLayer_[]};
Physical Surface("StatorConductorExt") = {StatorConductor_Ext[]};
Physical Surface("StatorConductorInt") = {StatorConductor_Int[]};

Color SteelBlue {Surface{StatorIron_[]};}
Color Black {Surface{StatorWedge_[]};}
Color SkyBlue {Surface{StatorAirgapLayer_[]};}
Color PaleGoldenrod {Surface{StatorConductor_Ext[]};}
Color Pink {Surface{StatorConductor_Int[]};}

Physical Line("OuterStator") = {OuterStator_[]};
//Physical Line("StatorRight") = {StatorPeriod_Right_[]};
//Physical Line("StatorLeft") = {StatorPeriod_Left_[]};
Physical Line("Sliding_Stator") = {Sliding_[]};

Coherence;
show_stator[] = CombinedBoundary{Surface{StatorIron_[]};};
show_conductor_ext[] = CombinedBoundary{Surface{StatorConductor_Ext[]};};
show_conductor_int[] = CombinedBoundary{Surface{StatorConductor_Int[]};};
Show{ Line{show_stator[]};}
Show{ Line{show_conductor_ext[]};}
Show{ Line{show_conductor_int[]};}

//---------------------------------rotor-----------------------------------------//
Physical Surface("RotorIron") = {RotorIron_[]};
Physical Surface("RotorMagnetics_") = {RotorMagnetics_[]};

Color SteelBlue {Surface{RotorIron_[]};}
Color AliceBlue {Surface{RotorMagnetics_[]};}

Physical Line("OuterRotor") = {OuterRotor_[]};

show_rotor[]  = CombinedBoundary{Surface{RotorIron_[]};};
Show{ Line{show_rotor[]};}

Hide{ Point{Point '*'};}
//Hide{ Line{Line '*'};}
//Mesh.CharacteristicLengthFromCurvature = 1;
//Mesh 2;


