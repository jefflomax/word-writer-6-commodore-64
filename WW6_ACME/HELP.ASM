;
!zone HELP;HELP_SCREEN 
;
!SOURCE "WWSETUP.ASM"
;
;
;
!SOURCE "VARIABLS.ASM"
;
;
FC_HELP:
; LDA #<HELP_BOX
; LDX #>HELP_BOX
; JSR AX_INTO_MSGOUT
; JSR W_INTO_MSGOUT
; DW HELP_BOX
;
 LDA #6  ;CBOFFSET
 JSR PULLDN ;DRAW THE BOX
!word HELP_BOX
 JSR KEYBRD
 JMP FULL_SCREEN
;
;
;
HELP_BOX:
; DB 27
!byte 26
!byte $FF,64,24
!text $FF,32,9,"HELP!",$FF,32,9
!byte $6A
!byte $C3,$CF,$CD,$CD,$A0,$CB,$C5,$D9,$D3
!byte $74,32,111,32,$6A
!byte $C3,$D4,$D2,$CC,$A0,$CB,$C5,$D9,$D3
!byte $74
;
!if ! DEBUGGER_PRESENT { 
;
!text "BOL",'D'-64,"OF",'F'-64,"  ",$6A
!text 'B'+$80,$74,"BOL",'D'-64,"ON",$FF,32,3
;
; DB 93,'CAP','S'-64,'LOC','K'-64,' ',$6A
; DB 'C'+$80,$74,'CLEA','R'-64,'TAB','S'-64,93
;
!text "DE",'L'-64,"CHA",'R'-64,"RT",$6A,'D'+$80,$74,"DELIMITE",'R'-64,' '
;
!text "FONT/STYL",'E'-64,$6A,'F'+$80,$74,"FON",'T'-64,"SELECT"
!text "GOT",'O'-64,"EN",'D'-64,"  ",$6A
!text 'G'+$80,$74,"GOT",'O'-64,"TO",'P'-64,"  "
;
!text "ITALIC",'S'-64,"OFF",$6A,'I'+$80,$74,"ITALIC",'S'-64,'O','N'-64
!text "LOA",'D'-64,"DO",'C'-64,"  ",$6A,'L'+$80,$74,"LOWE",'R'-64,"INDEX"
!text "NEX",'T'-64,"MAR",'K'-64,' ',$6A
!text 'N'+$80,$74,"NEX",'T'-64,"PAG",'E'-64,' '
;
!text "PRIN",'T'-64,"DO",'C'-64,' ',$6A
!text 'P'+$80,$74,"PRE",'V'-64,"PAG",'E'-64,' '
;
!text "QUI",'T'-64,'O','R'-64,"NEW",$6A
!text 'Q'+$80,$74,"QUER",'Y'-64,"MEMRY"
;
!text "RETUR",'N'-64,"TOGL",$6A,'R'+$80,$74,"RAIS",'E'-64,"INDEX"
!text "SAV",'E'-64,"DO",'C'-64,"  ",$6A
!text 'S'+$80,$74,"SE",'T'-64,"MAR",'K'-64,"  "
;
!text "UNDRL",'N'-64,"OF",'F'-64,$6A
!text 'U'+$80,$74,"UNDRL",'N'-64,'O','N'-64,' '
;
!text "VIE",'W'-64,"DI",'R'-64,"  ",$6A,'V'+$80,$74,"VIRTUA",'L'-64,"MAR"
!text "COD",'E'-64,"1 OF",'F'-64,$6A
!text 'W'+$80,$74,"COD",'E'-64,"1 O",'N'-64,' '
;
!text "COD",'E'-64,"2 OF",'F'-64,$6A
!text 'X'+$80,$74,"COD",'E'-64,"2 O",'N'-64,' '
;
!text "COD",'E'-64,"3 OF",'F'-64,$6A
!text 'Y'+$80,$74,"COD",'E'-64,"3 O",'N'-64,' '
;
} 
;
!byte $FF,64,11,249,$FF,64,11,0
;
;
!eof
;
; PUBLIC FC_HELP
; EXTERN AX_INTO_MSGOUT
; EXTERN FULL_SCREEN
; EXTERN KEYBRD
; EXTERN PULLDN
; EXTERN W_INTO_MSGOUT
