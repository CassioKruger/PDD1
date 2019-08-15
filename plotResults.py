import numpy as np
import pandas as pd
from matplotlib import pyplot as plt

flag = input("Voltage and Current = 1 \n Torque = 2 \n Position and Velocity = 3\n")

tempo = pd.read_csv("res/Ua.dat",sep='  ', header=None, index_col=None,usecols=[0],engine= 'python')
tempoPosVel = pd.read_csv("res/P_deg.dat",sep='  ', header=None, index_col=None,usecols=[0],engine= 'python')

tensaoUa = pd.read_csv("res/Ua.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
tensaoUb = pd.read_csv("res/Ub.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
tensaoUc = pd.read_csv("res/Uc.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')

correnteIa = pd.read_csv("res/Ia.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
correnteIb = pd.read_csv("res/Ib.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
correnteIc = pd.read_csv("res/Ic.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')

#torqueRotor = pd.read_csv("res/Tr.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
#torqueEstator = pd.read_csv("res/Ts.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')

posRotor1Deg = pd.read_csv("res/P_deg.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
#posRotor1Rad = pd.read_csv("res/P.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
#veloRotor1Rad_sec = pd.read_csv("res/V.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
veloRotor1Rpm = pd.read_csv("res/Vrpm.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')

posRotor2Deg = pd.read_csv("res/P_deg2.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
#posRotor2Rad = pd.read_csv("res/P2.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
#veloRotor2Rad_sec = pd.read_csv("res/V2.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
veloRotor2Rpm = pd.read_csv("res/Vrpm2.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')

if (flag == '1'):
    print(flag)
    #          (linhas,colunas,posicao)
    plt.figure(1)
    plt.subplot(2,1,1)
    plt.plot(tempo,tensaoUa,color = [0, 0.4470, 0.7410])
    plt.plot(tempo,tensaoUb,color = [0.8500, 0.3250, 0.0980])
    plt.plot(tempo,tensaoUc,color = [0.4660, 0.6740, 0.1880])

    plt.title("Voltage and Current")
    plt.xlabel("Time (s)")
    plt.ylabel("Voltage (V)")
    plt.legend(["Va","Vb","Vc"])

    plt.subplot(2,1,2)
    plt.plot(tempo,correnteIa,color = [0, 0.4470, 0.7410])
    plt.plot(tempo,correnteIb,color = [0.8500, 0.3250, 0.0980])
    plt.plot(tempo,correnteIc,color = [0.4660, 0.6740, 0.1880])

    plt.xlabel("Time (s)")
    plt.ylabel("Current (A)")
    plt.legend(["Ia","Ib","Ic"])
    plt.show()

##-----------------------##
if (flag == '2'):
    print(flag)
    plt.figure(1)
    #plt.subplot(2,1,1)
    plt.plot(tempo,torqueRotor,color = [0, 0.4470, 0.7410])
    plt.plot(tempo,torqueEstator,color = [0.8500, 0.3250, 0.0980])

    plt.title("Torque")
    plt.xlabel("Time (s)")
    plt.ylabel("Torque (Nm)")
    plt.legend(["Tr","Ts"])
    plt.show()

##-----------------------##
if (flag == '3'):
    print(flag)
    plt.figure(1)

    # pos rotor 1
    plt.subplot(1,2,1)
    plt.plot(tempoPosVel,posRotor1Deg,color = [0, 0.4470, 0.7410])
    plt.plot(tempoPosVel,posRotor2Deg,color = [0.8500, 0.3250, 0.0980])
    plt.xlabel("Time (s)")
    plt.ylabel("Position")
    plt.legend(["IPMA","Moduladores"])

    plt.subplot(1,2,2)
    plt.plot(tempoPosVel,veloRotor1Rpm,color = [0, 0.4470, 0.7410])
    plt.plot(tempoPosVel,veloRotor2Rpm,color = [0.8500, 0.3250, 0.0980])
    plt.xlabel("Time (s)")
    plt.ylabel("Velocity")
    plt.legend(["IPMA","Moduladores"])
    plt.show()
