// September 2018 - Author: C. Kruger

mili2metro = 0.001;
metro2mili = 1000;
deg2rad = Pi/180 ;
largura_bob = 8.2980*mili2metro; 	//[m]
altura_bob 	= 12.6415*mili2metro;  //[m]

dP = newp;
dL = newl;

Point(dP) = {165.7920*mili2metro,-(altura_bob/2),0,1.0};
Point(dP+1) = {165.7920*mili2metro + largura_bob,-(altura_bob/2),0,1.0};
Point(dP+2) = {165.7920*mili2metro + largura_bob,+(altura_bob/2),0,1.0};
Point(dP+3) = {165.7920*mili2metro,+(altura_bob/2),0,1.0};

Line(dL) = {dP,dP+1};
Line(dL+1) = {dP+1,dP+2};
Line(dL+2) = {dP+2,dP+3};
Line(dL+3) = {dP+3,dP};

Point(dP+4) = {176.1630*mili2metro,-(altura_bob/2),0,1.0};
Point(dP+5) = {176.1630*mili2metro + largura_bob,-(altura_bob/2),0,1.0};
Point(dP+6) = {176.1630*mili2metro + largura_bob,+(altura_bob/2),0,1.0};
Point(dP+7) = {176.1630*mili2metro,+(altura_bob/2),0,1.0};

Line(dL+4) = {dP+4,dP+5};
Line(dL+5) = {dP+5,dP+6};
Line(dL+6) = {dP+6,dP+7};
Line(dL+7) = {dP+7,dP+4};

i=38;
For x In {0:i:1}
	Rotate {{0, 0, 1}, {0,0,0}, (360/39)*deg2rad*x} 
	{
	  Duplicata { Point{dP};Point{dP+1};Point{dP+2};Point{dP+3};Point{dP+4};Point{dP+5};Point{dP+6};Point{dP+7};
	   			  Line{dL};Line{dL+1};Line{dL+2};Line{dL+3};Line{dL+4};Line{dL+5};Line{dL+6};Line{dL+7};
	   			}
	}
EndFor
