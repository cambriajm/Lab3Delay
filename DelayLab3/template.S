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
    MOVLW 0x05 
    XORWF 0x07,1
    
    MOVLW 0x04
    MOVWF OutCount
    GOTO OuterDelay
    
OuterDelay:
    MOVLW 0xC0
    MOVWF MidCount
    GOTO MidDelay
    
MidDelay:
    MOVLW 0xD7
    MOVWF InCount
    GOTO InDelay
    
InDelay:
    DECFSZ InCount
    GOTO InDelay
    
    DECFSZ MidCount
    GOTO MidDelay 
    
    DECFSZ OutCount
    GOTO OuterDelay
    NOP
    GOTO Main
    
    
    ;1 TCY code not part of delay
   // XORWF PORTC,1                   ;1 TCY code not part of delay

   
    //MOVLW 0x0F                      ;1 TCY delay overhead
    //MOVWF count                     ;1 TCY delay overhead
    
    //DelayLoop:                     
    //DECFSZ count,1                  ;1(2) 1 TCY if not zero, 2 TCY if zero
    //GOTO DelayLoop                  ;2 TCY
    
    //DelayMini:
    

    //GOTO   Main              ;2 TCY code not part of delay
    
 End