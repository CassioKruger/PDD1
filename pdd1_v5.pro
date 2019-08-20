//Novembro, 2018 - Autor: Cássio T. Kruger
//UFPel - Eng. de Controle e Automação
//pdd1 - v5.0

Include "pdd1_v5_data.geo";

DefineConstant
[
  Flag_AnalysisType = {1,  Choices{0="Static",  1="Time domain", 2="Freq Domain"}, Name "Input/01Type of analysis", Highlight "Blue",
    Help Str["- Use 'Static' to compute static fields created in the machine",
      "- Use 'Time domain' to compute the dynamic response of the machine"]} ,

  Flag_SrcType_Stator = { 0, Choices{0="None",1="Current"},
                             Name "Input/02Fonte no estator", Highlight "Blue"},

  Flag_NL = { 1, Choices{0,1}, Name "Input/03Curva BH Não Linear"},

  Flag_NL_law_Type = { 1, Choices{
      0="Analytical", 1="Interpolated",
      2="Analytical VH800-65D", 3="Interpolated VH800-65D"},
    Name "Input/04BH-curve", Highlight "Blue", Visible Flag_NL}
];

Flag_Cir = !Flag_SrcType_Stator ;
Flag_ImposedCurrentDensity = Flag_SrcType_Stator ;

Group{

  Stator_Airgap = Region[STATOR_AIRGAP] ;

  Stator_Bnd_MB = Region[STATOR_BND_MOVING_BAND];
  Stator_Bnd_A0 = Region[STATOR_BND_A0] ;           //direita
  Stator_Bnd_A1 = Region[STATOR_BND_A1] ;           //esquerda

  If(Flag_OpenStator)     //slot aberto do estator
    Stator_Fe     = Region[STATOR_FE] ;
    Stator_Air    = Region[{STATOR_AIR,STATOR_SLOTOPENING}] ;
  EndIf
  If(!Flag_OpenStator)    //slot fechado do estator
    Stator_Fe     = Region[{STATOR_FE,STATOR_SLOTOPENING}] ;
    Stator_Air    = Region[STATOR_AIR] ;
  EndIf

  nbMagnetsStator = NbrStatorPolesTot/SymmetryFactor ;
  For k In {1:nbMagnetsStator}
    Stator_Magnet~{k} = Region[ (STATOR_MAGNET+k-1) ];
    Stator_Magnets += Region[ Stator_Magnet~{k} ];
  EndFor

  nbStatorInds = (Flag_Symmetry) ? NbrStatorPolesTot*NbrSectStatorTot/NbrStatorPolesTot : NbrSectStatorTot ;
  Printf("NbrStatorPolesTot=%g, nbStatorInds=%g SymmetryFactor=%g", NbrStatorPolesTot, nbStatorInds, SymmetryFactor);

  //secondary rotor (modulators)
  Rotor2_Fe     = Region[ROTOR2_FE] ;
  Rotor2_Al     = Region[{}];
  Rotor2_Cu     = Region[{}];

  Rotor2_Airgap = Region[{ROTOR2_AIRGAPTOP,ROTOR2_AIRGAPBOTTOM}] ;
  Rotor2_Air = Region[ROTOR2_AIR];

  Rotor2_Top_Bnd_MB = Region[ROTOR2_TOP_BND_MOVING_BAND];
  Rotor2_Bottom_Bnd_MB = Region[ROTOR2_BOTTOM_BND_MOVING_BAND];
  Rotor2_Bnd_A0 = Region[ROTOR2_BND_A0] ;           //direita
  Rotor2_Bnd_A1 = Region[ROTOR2_BND_A1] ;           //esquerda

  //main rotor (1)
  Rotor_Fe     = Region[ROTOR_FE] ;
  Rotor_Al     = Region[{}];
  Rotor_Cu     = Region[{}];

  Rotor_Airgap = Region[ROTOR_AIRGAP] ;

  Rotor_Bnd_MB = Region[ROTOR_BND_MOVING_BAND] ;
  Rotor_Bnd_A0 = Region[ROTOR_BND_A0] ;           //direita
  Rotor_Bnd_A1 = Region[ROTOR_BND_A1] ;           //esquerda

  MovingBand_PhysicalNb = Region[MOVING_BAND] ;  // Fictitious number for moving band, not in the geo file
  Surf_Inf = Region[SURF_EXT] ;            //OuterStator
  Surf_bn0 = Region[SURF_INT] ;            //InnerRotor
  Surf_cutA0 = Region[{STATOR_BND_A0, ROTOR_BND_A0, ROTOR2_BND_A0}];
  Surf_cutA1 = Region[{STATOR_BND_A1, ROTOR_BND_A1, ROTOR2_BND_A1}];

  Dummy = Region[NICEPOS]; // For getting the movement of the rotor

  //Rotor_Magnets

  nbMagnets = NbrPolesTot/SymmetryFactor ;
  For k In {1:nbMagnets}
    Rotor_Magnet~{k} = Region[ (ROTOR_MAGNET+k-1) ];
    Rotor_Magnets += Region[ Rotor_Magnet~{k} ];
  EndFor

  nbInds = (Flag_Symmetry) ? NbrPolesInModel*NbrSectStatorTot/NbrPolesTot : NbrSectStatorTot ;
  Printf("NbrPolesInModel=%g, nbInds=%g SymmetryFactor=%g", NbrPolesInModel, nbInds, SymmetryFactor);

  Stator_Ind_Ap = Region[{}];            Stator_Ind_Am = Region[STATOR_IND_AM];
  Stator_Ind_Bp = Region[{}];            Stator_Ind_Bm = Region[STATOR_IND_BM];
  Stator_Ind_Cp = Region[STATOR_IND_CP]; Stator_Ind_Cm = Region[{}];
  If(NbrPolesInModel > 1)
    Stator_Ind_Ap += Region[STATOR_IND_AP];
    Stator_Ind_Bp += Region[STATOR_IND_BP];
    Stator_Ind_Cm += Region[STATOR_IND_CM];
  EndIf

  PhaseA = Region[{Stator_Ind_Ap, Stator_Ind_Am}];
  PhaseB = Region[{Stator_Ind_Bp, Stator_Ind_Bm}];
  PhaseC = Region[{Stator_Ind_Cp, Stator_Ind_Cm}];

  // FIXME: Just one physical region for nice graph in Onelab
  PhaseA_pos = Region[Stator_Ind_Am];
  PhaseB_pos = Region[Stator_Ind_Bm];
  PhaseC_pos = Region[Stator_Ind_Cp];

  Stator_IndsP = Region[{Stator_Ind_Ap, Stator_Ind_Bp, Stator_Ind_Cp}];
  Stator_IndsN = Region[{Stator_Ind_Am, Stator_Ind_Bm, Stator_Ind_Cm}];

  Stator_Inds = Region[{PhaseA, PhaseB, PhaseC}] ;
  Rotor_Inds  = Region[{}] ;

  StatorC  = Region[{}] ;
  StatorCC = Region[{Stator_Fe, Stator_Magnets}] ;
  RotorC   = Region[{}] ;
  RotorCC  = Region[{Rotor_Fe, Rotor_Magnets }] ;

  Rotor2C   = Region[{}] ;
  Rotor2CC  = Region[{Rotor2_Fe}] ;

  // Moving band:  with or without symmetry, these BND lines must be complete
  Stator_Bnd_MB = Region[STATOR_BND_MOVING_BAND];

  //secondary rotor (modulators)
        //top sliding
        For k In {1:SymmetryFactor}
          Rotor2_Top_Bnd_MB~{k} = Region[ (ROTOR2_TOP_BND_MOVING_BAND+k-1) ];
          Rotor2_Top_Bnd_MB += Region[ Rotor2_Top_Bnd_MB~{k} ];
        EndFor
        Rotor2_Top_Bnd_MBaux = Region[ {Rotor2_Top_Bnd_MB, -Rotor2_Top_Bnd_MB~{1}}];

        //bottom sliding
        For k In {1:SymmetryFactor}
          Rotor2_Bottom_Bnd_MB~{k} = Region[ (ROTOR2_BOTTOM_BND_MOVING_BAND+k-1) ];
          Rotor2_Bottom_Bnd_MB += Region[ Rotor2_Bottom_Bnd_MB~{k} ];
        EndFor
        Rotor2_Bottom_Bnd_MBaux = Region[ {Rotor2_Bottom_Bnd_MB, -Rotor2_Bottom_Bnd_MB~{1}}];

  //main rotor
  For k In {1:SymmetryFactor}
    Rotor_Bnd_MB~{k} = Region[ (ROTOR_BND_MOVING_BAND+k-1) ];
    Rotor_Bnd_MB += Region[ Rotor_Bnd_MB~{k} ];
  EndFor
  Rotor_Bnd_MBaux = Region[ {Rotor_Bnd_MB, -Rotor_Bnd_MB~{1}}];

}

////-----------------------------------------------------------------------------------------------------------------////

Function {

  NbrPhases = 3 ;

  // For a radial remanent b
  For k In {1:nbMagnets}
    br[ Rotor_Magnet~{k} ] = (-1)^(k-1) * b_remanent * Vector[ Cos[Atan2[Y[],X[]]], Sin[Atan2[Y[],X[]]], 0 ];
  EndFor

  For k In {1:nbMagnetsStator}
    br[ Stator_Magnet~{k} ] = (-1)^(k-1) * b_remanent * Vector[ Cos[Atan2[Y[],X[]]], Sin[Atan2[Y[],X[]]], 0 ];
  EndFor

  //Data for modeling a stranded inductor
  NbWires[]  = 30 ; // Number of wires per slot
  // STATOR_IND_AM comprises all the slots in that phase, we need thus to divide by the number of slots
  nbSlots[] = Ceil[nbInds/NbrPhases/2] ;
  //nbSlots[] = 26;
  SurfCoil[] = SurfaceArea[]{STATOR_IND_AM}/nbSlots[] ;//All inductors have the same surface
  Torque_mec[] = 1000;

  //--------------------------------------------------
  FillFactor_Winding = 0.5 ; // percentage of Cu in the surface coil side, smaller than 1
  Factor_R_3DEffects = 1.5 ; // bigger than Adding 50% of resistance

  DefineConstant
  [
    rpm = { rpm_nominal, Name "Input/21Vel. em RPM", Highlight "LemonChiffon", Visible (Flag_AnalysisType==1),
            Help Str["Velocidade do rotor de baixa rotação (turbina)"]
          },

    rpmAlta = { rpm*((NbrSectStatorMag/2)/(NbrPolesInModel/2)), ReadOnly 1, Name "Input/22Vel. em RPM", Highlight "LemonChiffon",
                Help Str["Velocidade do rotor de alta rotação (rotor interno, imas)"]
              },

    passoTempo = { 0.005, Name "Input/23Tempo de passo (s)", Highlight "Linen",
                  Help Str["Intervalo de tempo de cada passo da simulação"]
                 },

    tempoMax = { 0.12, Name "Input/24Tempo de simu (s)", Highlight "Linen",
                Help Str["Tempo máximo da simulação da simulação"]
               },
    passoCarga = { 35, Name "Input/25Passo Carga", Highlight "Linen",
                Help Str["Passo da simulação em que uma carga é adicionada, variando a velocidade"]
               }
  ]; // speed in rpm


    //smoothStep[] = ($TimeStep) <= (3) ? 0. : Tanh[Pi*($Time/0.2)];

  smoothStep[] = ($TimeStep) <= (passoCarga) ? 0. : Tanh[Pi* ( (($TimeStep-passoCarga)*$DTime)/0.03 ) ];

  rpmAux[] = ($TimeStep) <= (passoCarga) ? rpm : rpm - 80*smoothStep[]; //FUNCIONOU!!

  wr[] = rpmAux[]/60*2*Pi ; // speed in rad_mec/s - BAIXA ROTACAO

  wr2[] = wr[]*((NbrSectStatorMag/2)/(NbrPolesInModel/2)) ; // speed in rad_mec/s rotor 2 - ALTA ROTACAO

  // supply at fixed position
  /*DefineConstant
  [
    Freq[] = { wr2[]*NbrPolePairs/(2*Pi), ReadOnly 1, Name "Output/1Freq", Highlight "LightYellow" }
  ];*/

  Freq[] = wr2[]*NbrPolePairs/(2*Pi);

  Omega[] = 2*Pi*Freq[] ;
  T[] = 1/Freq[] ;

    // relaxation of applied voltage, for reducing the transient
    NbTrelax = 2 ; // Number of periods while relaxation is applied
    Trelax[] = NbTrelax*T[];
    Frelax[] = (!Flag_NL || Flag_AnalysisType==0 || $Time>Trelax[]) ? 1. :
               0.5*(1.-Cos[Pi*$Time/Trelax[]]) ; // smooth step function

  DefineConstant
  [
    thetaMax_deg = { 180, Name "Input/11End rotor angle (loop)",Highlight "AliceBlue", Visible (Flag_AnalysisType==1) }
  ];

  theta0   = InitialRotorAngle + 0. ;
  thetaMax = thetaMax_deg * deg2rad ; // end rotor angle (used in doing a loop)

  /*DefineConstant
  [
    NbTurns  = { (thetaMax-theta0)/(2*Pi), Name "Input/14Number of revolutions",
                  Highlight "LightGrey", ReadOnly 1, Visible (Flag_AnalysisType==1)},

    delta_theta_deg = { 1, Name "Input/12Step [deg]",
                        Highlight "AliceBlue", Visible (Flag_AnalysisType==1)}
  ];*/

  //relação de engrenagem de um pdd
  // pH*wH + pL*wL = nP*wP
  // wH is the speed of the inner rotor
  // wL is the speed of the outer rotor
  // wP is the speed of the modulators
  // When one of the three parts of the gear is stationary, there will be a constant relation or gear ratio
  //  between the speeds of other two parts.

  //considering that the outer rotor is stationary, the gear ratio becomes:
  // -> pH*wH = nP*wP
  // -> Gr = wH/wP = nP/pH
  // -> gear ratio = nbr of modulators / nbr of pair-poles at rotor 1

  // in this case, the nbr of modulators is equal to the nbr of poles at the outer rotor, so:

  gear_ratio = ((NbrSectStatorMag/2)/(NbrPolesInModel/2));

  //delta_theta_deg = 1;
  delta_theta_deg[] = rpmAux[]*passoTempo;

  delta_theta_baixa[] = delta_theta_deg[] * deg2rad ;   //angulo de giro do rotor de baixa rotacao
  delta_theta_alta[] = delta_theta_baixa[] * gear_ratio ; //angulo de giro do rotor de alta rotacao

  time0 = 0 ; // at initial rotor position
  delta_time[] = delta_theta_deg[] * deg2rad/wr[];
  timemax[] = thetaMax/wr[];

  NbSteps[] = 30;//Ceil[(timemax[]-time0)/delta_time[]];

  DefineConstant
  [
    gearRatio = { gear_ratio, ReadOnly 1, Name "Input/25Gear Ratio", Highlight "Turquoise",
                  Help Str["Relação de engrenagem produzida por (Num de moduladores/Num de par de polos do rotor de alta rotação)"]
                }
  ];

  /*DefineConstant
  [
    NbSteps = { Ceil[(timemax-time0)/delta_time[]], Name "Input/23Number of steps",
                Highlight "LightGrey", ReadOnly 10, Visible (Flag_AnalysisType==1)}
  ];*/

  RotorPosition[] = InitialRotorAngle + $Time * wr[] ;
  RotorPosition_deg[] = RotorPosition[]*180/Pi;

  Rotor2Position[] = InitialRotor2Angle + $Time * wr2[] ;
  Rotor2Position_deg[] = Rotor2Position[]*180/Pi;

//+++
  Flag_ParkTransformation = 0 ;
  Theta_Park[] = ((RotorPosition[] + Pi/8) - Pi/6) * NbrPolePairs; // electrical degrees
  Theta_Park_deg[] = Theta_Park[]*180/Pi;

  //Theta_Park2[] = ((Rotor2Position[] + Pi/8) - Pi/6) * NbrPolePairs; // electrical degrees
  //Theta_Park_deg2[] = Theta_Park2[]*180/Pi;

  DefineConstant
  [
    ID = { 0, Name "Input/50Id stator current",
          Highlight "AliceBlue", Visible (Flag_SrcType_Stator==1)},
    IQ = { Inominal, Name "Input/51Iq stator current",
          Highlight "AliceBlue", Visible (Flag_SrcType_Stator==1)}
  ] ;

  II = Inominal;
}

// --------------------------------------------------------------------------
// --------------------------------------------------------------------------
// --------------------------------------------------------------------------

If(Flag_SrcType_Stator)
  UndefineConstant["Input/8Load resistance"];
EndIf

If(Flag_Cir)
  Include "pdd1_v5_circuit.pro" ;
EndIf
Include "machine_magstadyn_a_2rotors.pro" ;
