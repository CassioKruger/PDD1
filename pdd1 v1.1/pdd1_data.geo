//Setembro, 2018 - Autor: Cássio T. Kruger

u = 1e-3; 			// unidade = mm
cm = 1e-2;			// unidade 
deg2rad = Pi/180;	// graus para radianos

Point(0) = {0,0,0,1.0}; //origem

DefineConstant
[
  AG = {u, Name "Aspectos Construtivos/var1", Label "Air Gap",Highlight "Gold"},
  rinterno_estator = {0.160, Name "Aspectos Construtivos/var2", Label "Raio Interno do Estator",Highlight "Gold"},
  rexterno_estator = {0.210, Name "Aspectos Construtivos/var3", Label "Raio Externo do Estator",Highlight "Gold"},
  //Poles = {0, Name "Input/var2",Label "Numero de Polos" ,Choices {1 = "1 polo", 2 = "2 polos", 4 = "4 polos"}},
  //Resultado = {Poles*2., Name "Input/var3", ReadOnly 1},
  //AG2 = {2.*AG, Name "Input/var4", Label "Entreferro multiplicado por 2", ReadOnly 1}
  step_deg = {90, Name "Entrada/var4", Label "Passo de Rotação [graus]", Highlight "ForestGreen"},
  ang_ini_deg = {0, Name "Entrada/var5", Label "Ang. Inicial [graus]", Highlight "PaleGoldenrod"},
  ang_fin_deg = {360, Name "Entrada/var6", Label "Ang. Final [graus]", Highlight "AliceBlue"}
];

