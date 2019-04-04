u = 1e-3 ; // unit = mm
deg2rad = Pi/180 ;

pp = "Input/Constructive parameters/";

DefineConstant
[
  AG = {u, Name "Input/var1", Label "Air Gap",Highlight "Grey"},
  Poles = {0, Name "Input/var2",Label "Numero de Polos" ,Choices {1 = "1 polo", 2 = "2 polos", 4 = "4 polos"}},
  Resultado = {Poles*2., Name "Input/var3", ReadOnly 1},
  AG2 = {2.*AG, Name "Input/var4", Label "Entreferro multiplicado por 2", ReadOnly 1}
];

