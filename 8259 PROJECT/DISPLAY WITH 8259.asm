                          
.model medium

.data
word db 'hellow 8086$' 
word1 db 'interrupted$'

.code

lcd_command: MOV AL,AH 
         CALL portA
          
         MOV AL,01H 
         CALL portB
         
         MOV AL,00H
         CALL portB 
         
         MOV CX,100
         CALL DELAY 
         RET
         
lcd_data: MOV AL,AH 
         CALL portA
          
         MOV AL,05H
         CALL portB 
         
         MOV AL,04H
         CALL portB
         
         MOV CX,100
         CALL DELAY
         RET
         

portA:OUT 80H,AL
    RET 

portB:OUT 82H,AL 
    RET 
    
portC:OUT 84H,AL 
    RET      

DELAY: JCXZ @DELAY_END
	@DEL_LOOP:
	LOOP @DEL_LOOP	
	@DELAY_END:
	RET 
STRING:  
                @LCD_PRINTSTR_LT:
            		LODSB
            		CMP AL,'$'
            		JE @LCD_PRINTSTR_EXIT
            		MOV AH,AL
            		CALL lcd_data	
            	JMP @LCD_PRINTSTR_LT
            	
            ;return
            	@LCD_PRINTSTR_EXIT: 
            	RET

INTR:PUSH AX
     PUSH BX
     
     PUSH DX 
     
     mov ah,0C1H
     call lcd_command   
     
     lea SI,word1
     call STRING 
     
      
                       	 	        
     POP DX
       
     POP BX
     POP AX
       
     MOV AL,20H  ;EOI
     OUT 60H,AL     
      
     IRET
	   
start: MOV AX,@data
   MOV DS,AX
   
   MOV AX,00h
   MOV ES,AX 
    
    
  
  
  
   ;INITIALISE 8255  
   MOV AL,80H
   OUT 86H,AL  
  
    ;  ;INITIALISE 8259
       MOV AL,13H ;ICW1
       OUT 60H,AL  
       
       MOV AL,30H ;ICW2 VECTOR NUMBER 48
       OUT 62H,AL 
       
       MOV AL,01H ;1CW4 
       OUT 62H,AL 
       
     LEA AX,INTR
       MOV DI,00C0H
       STOSW
       
       mov ax,cs
       stosw 
       STI 
;   
            
   
   ;INITIALISE LCD
   
  ;delay 20msafter VCC rises to 4.5V
    	MOV CX,1000
    	CALL DELAY
        	
        ;Send function set command to LCD: 2 Line, 8-bit, 5x7 dots
    	MOV AH,38H
    	CALL lcd_command
;        	
        ;Send display ON/OFF control command to LCD: Display ON, Cursor off, Blink off
    	MOV AH,0CH
    	CALL lcd_command
;       
 	     ;Set LCD Cursor
            mov ah,80H
            call lcd_command

      
    
    ;Display string on LCD
        lea SI,word
        call STRING 
        
     
        
         
@SHIFT: 
        MOV CX,10
        mov ah,18h
        call lcd_command
         
       
          
        JMP @SHIFT       
        
      
     
       
HLT
   
end start	             