import numpy as np 
import pandas as pd 
from matplotlib import pyplot as plt 

tempo = pd.read_csv("pdd1 v5/res/Ua.dat",sep='  ', header=None, index_col=None,usecols=[0],engine= 'python')

tensaoUa = pd.read_csv("pdd1 v5/res/Ua.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
tensaoUb = pd.read_csv("pdd1 v5/res/Ub.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
tensaoUc = pd.read_csv("pdd1 v5/res/Uc.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')

correnteIa = pd.read_csv("pdd1 v5/res/Ia.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
correnteIb = pd.read_csv("pdd1 v5/res/Ib.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
correnteIc = pd.read_csv("pdd1 v5/res/Ic.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')

torqueRotor = pd.read_csv("pdd1 v5/res/Tr.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')
torqueEstator = pd.read_csv("pdd1 v5/res/Ts.dat",sep='  ', header=None, index_col=None,usecols=[1],engine= 'python')

#          (linhas,colunas,posicao)
plt.figure(1)
plt.subplot(2,1,1)
plt.plot(tempo,tensaoUa,color = [0, 0.4470, 0.7410])
plt.plot(tempo,tensaoUb,color = [0.8500, 0.3250, 0.0980])
plt.plot(tempo,tensaoUc,color = [0.4660, 0.6740, 0.1880])

plt.title("Tensao e Corrente")
plt.xlabel("Tempo (s)")
plt.ylabel("Tensao (V)")
plt.legend(["Va","Vb","Vc"])

plt.subplot(2,1,2)
plt.plot(tempo,correnteIa,color = [0, 0.4470, 0.7410])
plt.plot(tempo,correnteIb,color = [0.8500, 0.3250, 0.0980])
plt.plot(tempo,correnteIc,color = [0.4660, 0.6740, 0.1880])

plt.plot(tempo,correnteIa)

plt.xlabel("Tempo (s)")
plt.ylabel("Corrente (A)")
plt.legend(["Ia","Ib","Ic"])

##-------------------------------##
plt.figure(2)
plt.subplot(2,1,1)
plt.plot(tempo,torqueRotor,color = [0, 0.4470, 0.7410])
plt.plot(tempo,torqueEstator,color = [0.8500, 0.3250, 0.0980])

plt.title("Torques")
plt.xlabel("Tempo (s)")
plt.ylabel("Torque (Nm)")
plt.legend(["Tr","Ts"])

plt.show()



