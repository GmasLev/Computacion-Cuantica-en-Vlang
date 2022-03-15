# Computacion-Cuantica-en-Vlang
traduccion de Curso computación cuántica. T6 - Modelización Java.
https://www.youtube.com/watch?v=UkGkToVryDQ
geneXCodeNow
# $ v run qc19.v


1 qbit state |0>

 Row: 0 ->  1.e+00 prob: 1.
 Total prob = 1.

 > --- Measures ----------------- q = 1000
 # > 0 -> 1000 - 100 % 
  
applies U gate --> must remain the same

 Row: 0 ->  1.e+00 prob: 1.
 Total prob = 1.

 > --- Measures ----------------- q = 1000 
#   0 -> 1000 - 100 % 
  
applies X gate --> must change to (0, 1) that is |1>

 Row: 1 ->  1.e+00 prob: 1.
 Total prob = 1.

   > --- Measures ----------------- q = 1000 
 #    0 -> 1000 - 100 % 

applies X gate again --> must change to (1, 0)  that is |0>

Row: 0 ->  1.e+00 prob: 1.
 Total prob = 1.

 > --- Measures ----------------- q = 1000 
#   0 -> 1000 - 100 % 
 
applies H gate --> in superposition ! --> 1 / sqr(2) (1, 1)

 Row: 0 ->  7.07e-01 prob: 0.5
 Row: 1 ->  7.07e-01 prob: 0.5
 Total prob = 1.

 > --- Measures ----------------- q = 1000 
#   0 -> 500 - 50 % 
#   1 -> 500 - 50 % 

applies H gate again --> so, it's reversible --> |0> again

 Row: 0 ->  1.e+00 prob: 1.
 Total prob = 1.

 > --- Measures ----------------- q = 1000 
#   0 -> 1000 - 100 % 


2 qbit on zero state --> (1, 0, 0 ,0 )   |00> state

 Row: 0 ->  1.e+00 prob: 1.
 Total prob = 1.

 > --- Measures ----------------- q = 1000 
#   00 -> 1000 - 100 % 
  

2 qbit on |00> and then hadamard on first

   > Row: 0 Col: 0 ->  7.07e-01
     Row: 0 Col: 2 ->  7.07e-01
     Row: 1 Col: 1 ->  7.07e-01
     Row: 1 Col: 3 ->  7.07e-01
     Row: 2 Col: 0 ->  7.07e-01
     Row: 2 Col: 2 -> -7.07e-01
     Row: 3 Col: 1 ->  7.07e-01
     Row: 3 Col: 3 -> -7.07e-01
    
 Row: 0 ->  7.07e-01 prob: 0.5
 Row: 2 ->  7.07e-01 prob: 0.5
 Total prob = 1.

   > --- Measures ----------------- q = 1000 
#     00 -> 500 - 50 % 
#     10 -> 500 - 50 % 
 
2 qbits |00> step1: H on first step2: CNOT

 Row: 0 ->  7.07e-01 prob: 0.5
 Row: 3 ->  7.07e-01 prob: 0.5
 Total prob = 1.

 > --- Measures ----------------- q = 1000 
#   00 -> 500 - 50 % 
#   11 -> 500 - 50 % 
  
   >Entanglement !
test
