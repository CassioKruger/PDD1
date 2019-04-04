//pdd1_full.geo

DefineConstant
[
  AG = {u, Name "Aspectos Construtivos/var1", Label "Air Gap",Highlight "Gold"},
  R_sin = {0.160, Name "Aspectos Construtivos/Estator/var2", Label "Raio Interno do Estator [m]",Highlight "SteelBlue"},
  R_sout = {0.210, Name "Aspectos Construtivos/Estator/var3", Label "Raio Externo do Estator [m]",Highlight "SteelBlue"},
  Qs = {38, Name "Aspectos Construtivos/Estator/var4", Label "Num total de slots no estator",Highlight "SteelBlue"},
  N_ss = {38, Name "Aspectos Construtivos/Estator/var5", Label "Num de slots a mostrar",Highlight "SteelBlue"}
  R_rin = {0.0495, Name "Aspectos Construtivos/Rotor/var6", Label "Raio Interno do Rotor [m]",Highlight "SkyBlue"},
  R_rout = {0.133, Name "Aspectos Construtivos/Rotor/var7", Label "Raio Externo do Rotor [m]",Highlight "SkyBlue"},
  Qr = {6, Name "Aspectos Construtivos/Rotor/var8", Label "Num total de slots no Rotor",Highlight "SkyBlue"},
  N_rs = {6, Name "Aspectos Construtivos/Rotor/var9", Label "Num de slots a mostrar",Highlight "SkyBlue"},
  h_m = {0.008, Name "Aspectos Construtivos/Rotor/var10", Label "Altura do Imã [m]",Highlight "ForestGreen"}
  //Poles = {0, Name "Input/var2",Label "Numero de Polos" ,Choices {1 = "1 polo", 2 = "2 polos", 4 = "4 polos"}},
  //Resultado = {Poles*2., Name "Input/var3", ReadOnly 1},
  //AG2 = {2.*AG, Name "Input/var4", Label "Entreferro multiplicado por 2", ReadOnly 1}
  //step_deg = {90, Name "Entrada/var6", Label "Passo de Rotação [graus]", Highlight "ForestGreen"},
  //ang_ini_deg = {0, Name "Entrada/var7", Label "Ang. Inicial [graus]", Highlight "PaleGoldenrod"},
  //ang_fin_deg = {360, Name "Entrada/var8", Label "Ang. Final [graus]", Highlight "AliceBlue"}
];

//Mesh density
m_coarse = 20;
m_normal = 12;
m_gap = 0.55;
m_sl_top = 7;
m_sl_bot = 1.5;
m_s_out = 12;

Mesh.CharacteristicLengthFactor = 0.01;
Mesh.Light = 0 ;
