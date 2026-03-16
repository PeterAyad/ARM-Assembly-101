
org 100h

jmp code
     
    data1  dw 0D37Eh,0F8A8h,5463h 
    data2  dw 92C2h,3408h,87DEh
    output dw 3 dup(?)           ;result should be 6640h,2CB1h,0DC42h

code:

          mov   ax, data1
          add   ax, data2
          mov   output, ax
          
          mov   ax, data1[2]
          adc   ax, data2[2]
          mov   output[2], ax
          
          mov   ax, data1[4]
          adc   ax, data2[4]
          mov   output[4], ax
          
        hlt
