;*******************************
;***********lines***************
;*******************************

SW16_LINES

          SET (R1,$BBA8)        ;SCREEN ADDRESS
          SET (R2,16)           ;START COLOR        
          SET (R4,26*40)        ;LEN
          SET (R5,23)           ;END COLOR

SW16_LINES_LP1
          INR R2
          LD R2
          CPR R5
          BM (SW16_LINES_NX1)
          SET (R2,16)
SW16_LINES_NX1
          STat R1 
          STat R1 
          STat R1 

          STat R1 
          STat R1 
          STat R1 

          DCR R4 
          DCR R4 
          DCR R4 
          DCR R4 
          DCR R4 

          BNZ (SW16_LINES_LP1)

          BS  (SW16_PRINT_PRESS_A_KEY)
          BS  (SW16_GET)
          RS