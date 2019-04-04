//Outubro, 2018 - Autor: Cássio T. Kruger
//pdd1 - v3.0

u = 1e-3;       // unidade = mm
cm = 1e-2;      // unidade 
deg2rad = Pi/180; // graus para radianos

Point(0) = {0,0,0,1.0}; //origem

FLAG_FULL = 1;
FLAG_HALF = 2;

DefineConstant[
    FLAG = {0, Name "Input/00Problem", Highlight "Gold", GmshOption "Reset", Autocheck 0,
                Choices {0 = "...",
                         FLAG_FULL = "Inteiro",
                         FLAG_HALF = "Metade "} }
] ;

If (FLAG==FLAG_FULL)
  LinkGeo = "pdd1_full - rotor.geo";
  //LinkPro = "pdd1_full.pro" ;
EndIf
If (FLAG==FLAG_HALF)
  LinkGeo = "pdd1_half - rotor.geo";
  //LinkPro = "pdd1_half.pro" ;
EndIf

Include Str[LinkGeo] ;

