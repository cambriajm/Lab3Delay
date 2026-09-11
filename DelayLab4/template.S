//Cambria Morgan
//RCET3373
//First Program
//git

    
; PIC16F883 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1
  CONFIG  FOSC = XT             ; Oscillator Selection bits (XT oscillator: Crystal/resonator on RA6/OSC2/CLKOUT and RA7/OSC1/CLKIN)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled and can be enabled by SWDTEN bit of the WDTCON register)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE = ON            ; RE3/MCLR pin function select bit (RE3/MCLR pin function is MCLR)
  CONFIG  CP = OFF              ; Code Protection bit (Program memory code protection is disabled)
  CONFIG  CPD = OFF             ; Data Code Protection bit (Data memory code protection is disabled)
  CONFIG  BOREN = OFF           ; Brown Out Reset Selection bits (BOR disabled)
  CONFIG  IESO = OFF            ; Internal External Switchover bit (Internal/External Switchover mode is disabled)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is disabled)
  CONFIG  LVP = OFF             ; Low Voltage Programming Enable bit (RB3 pin has digital I/O, HV on MCLR must be used for programming)

; CONFIG2
  CONFIG  BOR4V = BOR40V        ; Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
  CONFIG  WRT = OFF             ; Flash Program Memory Self Write Enable bits (Write protection off)

// config statements should precede project file includes.
#include <xc.inc>
  count EQU 0x20 ; use data memory address 0x20 as part of an 8 bit counter 
 ;Reset Vector at 0000h. Execution starts here after reset 
PSECT resetVect,class=CODE,delta=2
ResetVector:
    NOP
    NOP
    goto Setup
    
;Main code section starts at 0008h. User code goes here.
PSECT code,class=CODE,delta=2 //after PSECT everything is grouped until the next PSECT

Setup:
    ; add device setup here 
    BCF 0x03,6 ;set bank 0 active
    BCF 0x03,5;set bank 0
    CLRF 0x06 ;portb cleared for reset low 
    CLRF 0x07 ; portc cleared 
   
    
    BCF 0x03,6 ;set bank 1 active 
    BSF 0x03,5 ;set bank 1 active 
    //MOVLW 0xFF
    CLRF 0x86 ;sets as output trisb
    
    CLRF 0x87 ;sets as output trisc
    
    BSF 0x03,6 ;set bank 2 active 
    BCF 0x03,5 ;set bank 2 active 
    BSF 0x09,1 ;turn TTG function off
    
    BSF 0x03,6 ;set bank 3 active 
    BSF 0x03,5 ;set bank 3 active 
    CLRF 0x89 ;anselh turn off
    
   // BSF 0x81,7
    //CLRF 0x8B
   
    BCF 0x03,6 ;set bank 0 active
    BCF 0x03,5 ;set bank 0
    OutCount EQU 0x20
    MidCount EQU 0x21
    InCount EQU 0x22
    MOVLW 0x30 ; Setting portC to display the 0 
    MOVWF 0x07
    
    goto Main

Main: 
    //main code goes here. Repeats forever because setup goes once 
    MOVLW 0x05 ;1 TCY
    XORWF 0x07,1 ; 1 TCY
    NOP ; 1 TCY
    NOP; 1 TCY
    NOP; 1 TCY
    NOP; 1 TCY
    NOP
    
    CALL OuterDelay ;2 TCY
    GOTO Main ; 2 TCY
 
OuterDelay: 
    MOVLW 0x04; 1 TCY 
    MOVWF OutCount  ; 1 TCY
      
OuterLoop: 
    NOP; 1 TCY
    NOP; 1 TCY
    NOP; 1 TCY
    NOP; 1 TCY
    NOP; 1 TCY
    NOP; 1 TCY
    CALL MidDelay ; 2 TCY 
    DECFSZ OutCount ; 1(2) TCY
    GOTO OuterLoop ; 2 TCY 
  Return ; 2 TCY 
  
MidDelay:
    MOVLW 0xB7; 1 TCY
    MOVWF MidCount ; 1 TCY 
   
MidLoop:
    
    CALL InDelay ; 2 TCY 
    DECFSZ MidCount ;1(2) TCY 
    GOTO MidLoop ; 2 TCY 
  Return ; 2 TCY 
   
InDelay:
    MOVLW 0xE1 ; 1 TCY 
    MOVWF InCount ; 1 TCY 
   
InLoop:
    DECFSZ InCount ; 1(2) TCY 
    GOTO InLoop  ; 2 TCY 
  Return ; 2 TCY 

    
 End