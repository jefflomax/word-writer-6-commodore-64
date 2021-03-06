;
 TITLE DATA 
 PAGE
;
 PUBLIC ADDATX
 PUBLIC ADDYTX
 PUBLIC BUFSCN  
 PUBLIC CLOSE15
 PUBLIC INIDSK
 PUBLIC OPEN_FILE_2
 PUBLIC OPNDIC
 PUBLIC PRKECY
 PUBLIC STATUS
 PUBLIC FDLATP
 PUBLIC FDNETP
 PUBLIC HEADAT
 PUBLIC KEYBRD
 PUBLIC LDA_TEXT_0
 PUBLIC LDA_TEXT_Y 
 PUBLIC MESSAGE_ON ;EDITLN
 PUBLIC NEXTLINE ;FOR OUTLINER
 PUBLIC SERPPT
 PUBLIC SERPP0
 PUBLIC TEXCF0
 PUBLIC TEXCFE
 PUBLIC TEXT_TO_NEXTLINE
 PUBLIC TOASCI
 PUBLIC OPEN15
 PUBLIC WORKING_SERPPT
;
 EXTERN OV_ADD_EOR			;TABLED
 EXTERN TAB_ASCII
;
;
TEXCF0:
LDA_TEXT_0:
 LDY #0
TEXCFE:
LDA_TEXT_Y:
 LDA (TEXT),Y
 CMP #ENDT
 RTS
;
;
TOASCI:
;.A NEW CHAR, .X DESTROYED
 CMP #$5D          ;NOT IN SPECIAL 7 CODES + 2 MARKS
 BCC ?NORMAL_CODES ;BIF REGULAR
 CMP #$82          ;ABOVE?
 BCS ?NORMAL_CODES
;
 LDX #6+2
?LOOP:
 CMP EXTENDED_CODES,X
 BEQ ?GOT_CODE
 DEX
 BPL ?LOOP
 LDX #6+2+1
;
?GOT_CODE:
 LDA ASCTYP
 BEQ ?COMM_CODES
 LDA ASCII_SUBST,X
 RTS
?COMM_CODES:
 LDA COMM_SUBST,X
 RTS
;
?NORMAL_CODES:
 CMP #$20
 BCC TOASC2
 CMP #$40
 BCC TOASC3
 ORA #$80
 BMI TOASC3
TOASC2:
 ORA #$40
TOASC3:
 LDX ASCTYP
 BNE REGASC
 RTS
;
REGASC:
 CMP #$41
 BCC REGAS1
 BMI REGAS2
 CMP #$5B
 BCS REGAS1
 EOR #$20
REGAS2:
 AND #$7F
REGAS1:
 RTS
;
;
ASCII_SUBST:
 DB $7B,$7C,$7D,$7E,$5C,$5F,$60,$40,$40,$40
;
COMM_SUBST:
 DB $5B,$DD,$5D,$20,$20,$A4,$27,$40,$40,$40
;
;
FDLATP:
 DEC TEXPAG+1
 LDY #$FF
FDLAT3 DEY
FDLAT1 LDA (TEXPAG),Y
 BPL FDLAT3
 CMP #ENDT
 BCC FDLAT3 ;WAS FDLAT1
 INY
ADDYTP:
 TYA
ADDATP:
 CLC
 ADC TEXPAG
 STA TEXPAG
 BCC FDLAT2
 INC TEXPAG+1
FDLAT2:
 JMP RESET
;
;
NEXTLINE:
;FOR OUTLINER
TEXT_TO_NEXTLINE:
LKFDP1:
;DON'T HARM .X
 LDY #$FF ;-1
LKFDP4:
 INY
LKFDP3:
 LDA (TEXT),Y
 BPL LKFDP4
 INY
 CMP #ENDT
 BCC LKFDP3
LKFDP2:
 BNE ADDYTX
 DEY
ADDYTX:
 TYA
ADDATX:
 CLC
 ADC TEXT
 STA TEXT
 BCC LKFDP5
 INC TEXT+1
LKFDP5:
 RTS
;
;
PRKECY:
 JSR SERPPT
KEYBRD:
;
 JSR WAIT_FOR_KEY
 BIT KEYABT        ;BMI = $80 = NO ABORTS
 BMI KEYBR2  
;
 CMP #3            ;RUN/STOP ABORTS NOW  
 BEQ KEYBR1
;
KEYBR2:
 CMP #'Y'
 RTS
KEYBR1:
ABORT_FUNCTION:
 LDX #0
 STX CURFLG
;
 JMP ENTERW
;
;
OPEN_C_15:
INIDSK:
 JSR CLRCHN
OPEN_15_NO_NAME:
 LDA #0
;
OPEN15:
 JSR SETNAM
 LDA #$F
OPEN_A_DV_15:
 JSR XDEVICEN
 LDY #$F
;(FT)
OPENE1:
 JSR SETLFS
 JMP OPEN
;
;
INPDEV:
 JSR CLRCHN
 LDX #$F
 JMP CHKIN 
;
;
STATUS:
 JSR INPDEV
STATUS_DEFAULT_IN:
 LDX #$FF
?LOOP:
 JSR CHRIN
 INX 
 CMP #$D
 BEQ ?ERROR_IN
 STA BPCODES,X
 BNE ?LOOP
;
?ERROR_IN:
 STX LSTCLS           ;SAVE LENGTH OF STRING
 JSR CLRCHN
 JSR FILE_STATUS      ;ERROR CMP #'0'
 BEQ ?OUT
;
 LDX LSTCLS
 DEX
?SHOW_ERROR:
 LDA BPCODES,X
 STA VIDEO,X
 DEX
 BPL ?SHOW_ERROR
 SEC
 RTS
;
?OUT:
 CLC
 RTS
;
STATCK:
 JSR STATUS
 JSR CLRCHN ;READY KEYBOARD FOR USE.
;
;HANDLE '63 FILE EXISTS ERROR'
;PROMPT 'FILE EXISTS, ERASE FILE?(Y/N)'
;
 LDA BPCODES
 CMP #'6'
 BNE STATC2     ;NOT FILE EXISTS ERROR.
 LDX BPCODES+1
 CPX #'3'
 BNE STATC2     ;NOT FILE EXISTS ERROR.
;
 LDA #32
 TAY
STATC6:
 STA VIDEO,Y
 DEY
 BPL STATC6
;
 LDX #27              ;FILE EXISTS.
 JSR SERPP0
;
 JSR KEYBRD
 BNE STATC3
;
;NOW THE HARD PART, SCRATCH, AND REOPEN THE FILE.
 LDX #3
 JSR SERPP0
 JSR REMOVE_FILE
;
 JSR OPENFL
 JMP STATCK
; 
;
STATC2:
 ORA BPCODES+1 
 CMP #$30
 BNE STATC1
;
 LDA #$7F       ;GOOD RET
 RTS            ;HOLDS VALUE
;
STATC1:
 LDA #2
 JSR CLOSE
;
 JSR PTCTRL
STATC3:
 LDA #0
 STA PREVIEW
;*NEW* FIND A PLACE TO SUPPRESS PREVIEW ON BAD
 RTS
;
REMOVE_FILE:
;
 JSR CLOSE15
;
 LDA INPBUF+1
 CMP #':'          ;DID USER SPECIFY 1:FILENAME OR 0:FILENAME 
 BNE ?NO_DRIVE
;
 LDA #'S'          ;CONVERT TO S0:FILENAME
 STA INPBUF-1      ;LIKE THIS
 LDA MSLEN
 LDX #<INPBUF-1
 BNE ?OPEN_W_DRIVE
;  
?NO_DRIVE: 
 LDA #'S'
 STA INPBUF-2
 LDA #':'
 STA INPBUF-1
;
 LDX MSLEN
 DEX
;
 TXA
 LDX #<INPBUF-2
?OPEN_W_DRIVE:
 LDY #>INPBUF 
 JMP OPEN15
;
DISKIN:
;IS DISK ON?
 STA REGLOAD ;SET TO USE THES OR DATA PATH
 JSR OPEN_C_15
;
 JSR CLOSE15
 LDX $90     ;STATUS 
 BEQ ?DISK_OK ;OK, PRESENT
;
 LDX #$9
 JSR PTCTRL1 ;NO DRIVE PRESS CTRL
 SEC
 RTS
;
?DISK_OK:
 CLC
 RTS
;
;
BUFSCN:
 LDY #$28
 LDA #' '
?LOOP:
 STA INPBUF,Y 
 STA VIDEO-1,Y     ;SCRN,LEN
 DEY
 BNE ?LOOP
 RTS
;
;
GETFLN:
 LDX #$12
 JSR SERPPT           ;'LOAD FILENAME?'
;
 LDX TEMP0            ;SAVE OR LOAD?
 BEQ ?OUT
;
 LDX #3
?LOOP:
 LDA SAVDAT,X
 STA VIDEO+40,X
 DEX
 BPL ?LOOP
?OUT:
;
GETFL0:
;
 JSR PUSH_TEXT
 LDA #<SAVE_LOAD_STRING
 LDX #>SAVE_LOAD_STRING
 JSR AX_INTO_TEXT 
 LDX SAVE_LOAD_STRING_LEN
 LDA #ENDT
 STA TEMP4
 STA RETRNA
 STA SAVE_LOAD_STRING,X
 JSR DRAWWD0
 JSR POP_TEXT
;
 LDA #$E
 STA MSLEN
;
 LDX SAVE_LOAD_STRING_LEN
 JSR INPUTF
;
 LDX MSLEN
 BEQ GETFL0
;
 STX SAVE_LOAD_STRING_LEN
 TXA
 TAY
?STORE_OFF_FNAME:
 LDA VIDEO,Y
 STA SAVE_LOAD_STRING,Y 
 DEY 
 BPL ?STORE_OFF_FNAME
; 
 LDY #2
GETFL3:
 LDA SPCARS,Y         ;',S,'
 STA INPBUF,X
 INX
 DEY
 BPL GETFL3
 STX MSLEN
 CLC
 RTS
;
;
OPENFL:
 LDX MSLEN
 INX
 TXA
 LDX #<INPBUF
 LDY #>INPBUF
OPNDIC:
 JSR SETNAM
OPEN_FILE_2:
 LDA #2
OPEN_FILE_A:
 JSR XDEVICEN
 TAY
 JSR SETLFS
 JMP OPEN
;
CLOSE15:
 LDA #$F
 DB $2C
CLOSE2:
 LDA #2
CLSANY:
 JSR CLOSE
 JSR CLRCHN
 JMP CLALL ;IRTS
;
ENDLOD:
;
 JSR CLOSE15
 JSR RESET
 JSR FC_CLEAR_HOME_NT
;
 INC MESSAGE_ON
 JMP FULL_SCREEN
;
;
CHKNUM:
 SEC
 SBC #$30 ;AC GONE
 CMP #$A
 RTS ;CS = BAD
;
;
SAVMOD:
;
 LDA #$FE ;FILE TYPE 2
 JSR CHROUT
 JSR SVTABS
;
 LDA IN_DATABASE_MODE	;IS CARDFILE ACTIVE?
 BNE ?SAVE_TABLE	;[1]
;
?TRY_OTHER_MODES:
 LDX CURRENT_FONT
 BMI ?TEXT_MODE 
; 
 LDA #$FE          		;FLAG FONT DEF AS
?SAVE_TABLE:
 JSR CHROUT        		;PRESENT   
;
 LDA #0
 STA POINTER4+1			;START FIELD COUNTER AT ZERO
 JSR SAVE_LOAD_FDEF_TABLE
 JMP SAVMO2
; 
?TEXT_MODE: 
 LDA #0            ;FLAG FONT DEF AS NOT
 JSR CHROUT        ;PRESENT
;
SAVMO2:
 JSR TEXCF0
 JSR OV_ADD_EOR	   ;ADD EOR IF NEEDED, TABLED, MAY HARM .X
 BEQ SAVMO1
 JSR CHROUT
 JSR INCTE1
 LDX $90           ;STATUS
 BEQ SAVMO2        ;OK,GO BACK
 RTS               ;RETURN & CHECK STATUS!
SAVMO1:
 JMP CHROUT        ;END
;
;
SAVE_LOAD_FDEF_TABLE:
;
 STA POINTER4            ;0 = SAVE $80 = LOAD $C0 = READ, IGNORE
;
SAVE_LOAD_FDEF_TABLE1:
;NO ASSURED STATUS ON EXIT
;
 TAY			;[SETFLAGS] IS THIS SAVE?
 BNE ?LOAD		;IF NOT, GO DO LOAD
;
 LDA IN_DATABASE_MODE	;IF SAVE, IS IT CARDFILE?
 BNE ?CARDS
 BEQ ?TEXT
;
?LOAD:
 LDA POINTER4
 AND #1
 BNE ?CARDS
;
?TEXT:
 JSR W_INTO_P3
 DW INSTALL_FONTS        ;ADDRESS TO LOAD/SAVE
 JSR W_INTO_P2 
 DW FONT_DEF_LEN+1       ;LENGTH TO LOAD/SAVE         
 JMP ?NORMAL
;
?CARDS:
 JSR W_INTO_P3
 DW FIELD_NAMES         ;ADDRESS TO LOAD/SAVE
 JSR W_INTO_P2
 DW 254			;11*23 + 1
;
?NORMAL:
 LDY #0
;
?LS_LOOP:
 LDA POINTER4            ;DO I LOAD OR SAVE?
 BNE ?LOAD_FDEF
;
 LDA (POINTER3),Y        ;GET A BYTE 
 JSR CHROUT              ;PUT THE BYTE (SAVE)
 JMP ?REJOIN
;
?LOAD_FDEF:
 JSR CHRIN
 BIT POINTER4            ;IS IGNORE?
 BVS ?REJOIN             ;IF SO, DO NOT UPDATE
 STA (POINTER3),Y
;
?REJOIN:
 LDX $90
 BNE ?BAD_IO
;
 JSR INC_P3_BY_1         ;POINT AT NEXT
 JSR DEC_P2_BY_1
 ORA POINTER2+1          ;ARE WE DONE?
 BNE ?LS_LOOP
;
 CLC
 RTS
;
?BAD_IO:
 SEC 
 RTS 
;
;
LDTABS:
;
 LDX POINTER4			;IS THIS A "MERGE"?
 CPX #$C0			;IF SO, IGNORE ALL
 BNE ?NORMAL
;
 LDX #20+2+2+2			;20 TABS TOP BOTTOM
 JMP PULLX			;STRIP .X AND RETURN
;
.IF REMOVE_TEXT
?NORMAL:
 LDX #0
?LOOP:
 JSR CHRIN
 CPX #6			;ALLOW TABS 0..5
 BCS ?STRIP6_20 
 STA TAB_TABLE,X
?STRIP6_20:
 INX
 CPX #20
 BCC ?LOOP
.ENDIF
;
;
?NORMAL:
 LDY #0
; STY POINTER+1		;ASCII TAB POSITION
 STY COLUMN		;ASCII TAB POSITION
?LOOP:
; STY POINTER
; LDY POINTER		;GET ACTUAL TAB POSITION
 STY COUNT  
 LDY COUNT  		;GET ACTUAL TAB POSITION
;
 JSR CHRIN
 CPY #6			;ALLOW TABS 0..5
 BCS ?STRIP6_20 
 STA TAB_TABLE,Y
 TAX			;SET FLAGS
 BMI ?STRIP6_20		;IF $FF, NO CHAR SET 
 JSR AXASCII		;.A = .X.A IN ASCII
 LDY COLUMN   
 STA TAB_ASCII+1,Y
 TXA
 STA TAB_ASCII,Y
 INY
 INY
 LDA #','
 STA TAB_ASCII,Y
 INY
 STY COLUMN    
; 
?STRIP6_20:
 LDY COUNT  
 INY
 CPY COLUMN   
 BCC ?NO_PAD
 LDA #' ' 
 STA TAB_ASCII-1,Y 
; 
?NO_PAD:
 CPY #20
 BCC ?LOOP
;
;
 LDX #0
 STX COUNT
?LOOP1:
 JSR CHRIN
 STA PRTWIN_TOPMAR,X
 JSR CHRIN
 STA PRTWIN_TOPMAR+1,X
 JSR ADJUST_X_INDEX      ;0,20,60
 BCC ?LOOP1 
 RTS
;
;
ADJUST_X_INDEX: 
 TXA
?SKPIT:
 CLC
 ADC #15                ;PRTDRP_WIDTH 19
 CMP #30                ;PRTDRP_WIDTH *2
 BEQ ?SKPIT
;
 TAX
 CMP #60
 RTS
;
;
SVTABS:
 LDX #0
 TXA
?LOOP:
 CMP #$FF
 BEQ ?FF_PAD
 LDA TAB_TABLE,X	;SENDS 20 BYTES, BUT 6..20 ARE JUST GARBAGE
?FF_PAD:
 PHA
 JSR CHROUT
 PLA
 INX
 CPX #20
 BCC ?LOOP
;
 LDX #0
?LOOP1:
 LDA PRTWIN_TOPMAR,X
 JSR CHROUT
 LDA PRTWIN_TOPMAR+1,X
 JSR CHROUT
 JSR ADJUST_X_INDEX      ;0,20,60
 BCC ?LOOP1
 RTS
;
;
FDNETP:
 LDY #$FF
?LOOP:
 INY
 LDA (TEXPAG),Y
 BPL ?LOOP
 CMP #ENDT
 BCC ?LOOP
 BEQ FDNET1        ;IF EOT, POINT AT EOT
 INY               ;ELSE POINT 1 PAST
FDNET1:
 JMP ADDYTP
;
;
PTCTRL:
 LDX #6                 ;PRINT PRESS CTRL
PTCTRL1:
 JSR SERPP0
;
WAIT_FOR_KEY_AND_HEADER:
 JSR WAIT_FOR_KEY
 JMP HEADER
;
;
MESSAGE_ON:
 DB 0           ;0=MESSAGE UP, NZ = NOT
;
WORKING_SERPPT:
 LDX #3		;'WORKING MESSAGE'
SERPPT: 
;
 JSR BUFSCN
;
SERPP0:
;
 LDY #0
 STY MESSAGE_ON
 LDA #<SERDAT
 STA MSGOUT
 LDA #>SERDAT
 STA MSGOUT+1
;
 TXA               ;SET FLAGS
 BEQ SERPP3
;
SERPP2:
 LDA (MSGOUT),Y    ;SET AT PROMPT .X
 JSR INC_MSGOUT_1
SERPP1:
 CMP #'>'
 BEQ SERPP6
 CMP #'<'
 BNE SERPP2
;
SERPP6:
 DEX            ;FOUND > OR <
 BNE SERPP2     ;LOOK AGAIN
;
SERPP3:
;.X SHOULD BE ZERO HERE
;.Y SHOULD BE ZERO HERE AND RETURN 0
?MAIN_LOOP:
 LDA (MSGOUT),Y
 BPL ?NORMAL_LETTER
 AND #$7F               ;'THIS LETTER IS FOLLOWED BY A SPACE'
 STA VIDEO+$28,X
 INX                    ;X IS SCREEN INDEX
 LDA #' '               ;DROP THRU SPACE TO FOLLOW
?NORMAL_LETTER:
 CMP #'>'               ;ARE WE DONE FOR REAL?
 BEQ ?DO_END
 CMP #'<'               ;COMMAND FOR ?(Y/N) TRAILER?
 BNE ?PUT_OUT
 LDA #<QUESTN
 STA MSGOUT
 LDA #>QUESTN   
 STA MSGOUT+1           ;POINT MSGOUT AT TRAILER
 BNE ?MAIN_LOOP         ;BRA
;
?PUT_OUT:
 STA VIDEO+$28,X
 JSR INC_MSGOUT_1       ;INCREMENT MSGOUT PTR (.Y REMAINS 0)
 INX
 BNE ?MAIN_LOOP         ;BRA
;
?DO_END:
SERPP4:
;
 LDA #$77
?LOOP:
 CPX #40
 BCS ?DONE
;
 STA VIDEO+$28,X   ;FILL 2ND LINE
 INX
 BNE ?LOOP
;
?DONE:
 RTS			;RETURN .Y = 0
;
INC_MSGOUT_1:
 INC MSGOUT
 BNE ?SKP
 INC MSGOUT+1
?SKP:  
 RTS 
; 
;
;DATA SECTION
;
HEADAT:
HEADOT: EQU $+12
HEAINS: EQU $+21
 DB 'WORD WRITER 6      '
 DB '     P: 01 L:01 C: 01'
SERDAT:
;0 
 DB 'SEARC','H'+$80,'FOR?>'
 DB 'REPLAC','E'+$80,'WITH?>'  
 DB 'DRIVE','R'+$80,'NO','T'+$80,'FOUND>'
WORKING_MSG:
 DB 'WORKING...>'
 DB 'NE','W'+$80,'DOCUMEN','T'+$80,'O','R'+$80,'QUIT?(N/Q)>'
;
SAVDAT:
;5
 DB 'SAVE',','+$80,'LOAD',','+$80,'O','R'+$80,'MERGE?(S/L/M)>'
PRESS_ANY_KEY_MSG:
 DB 'PRESS ANY KEY TO CONTINUE>'
 DB 'PLAC','E'+$80,'PROGRA','M'+$80,'DIS','K'+$80,'I','N'+$80
 DB 'DAT','A'+$80,'DRIVE>'
 DB 'INSER','T'+$80,'GEO','S'+$80,'DISK>'
 DB 'DEVIC','E'+$80,'NO','T'+$80,'PRESENT>'
;DB '123456BYTES,123% FREE.>'
 DB ' '+$80,' '+$80,' '+$80,'BYTES',','+$80,' '+$80,'%'+$80,'FREE.>'
;11
 DB 'WW',','+$80,'DM-REPORT',','+$80,'PETASCII?(W/D/P)>'
 DB 'CHANGE','S'+$80,'WIL','L'+$80,'B','E'+$80
 DB 'LOST',','+$80,'AR','E'+$80,'YO','U'+$80,'SURE<' 
 DB 'ENTE','R'+$80,'DIS','K'+$80,'COMMAND>'
 DB 'MOV','E'+$80,'CURSO','R'+$80,'OU','T'+$80,'O','F'+$80,'BLOCK>'
;15
 DB 'NUMBE','R'+$80,'O','F'+$80,'FIELDS?(3-23)>'
 DB 'CRS','R'+$80,'T','O'+$80,'SELECT',','+$80
 DB 'RETUR','N'+$80,'T','O'+$80,'DELETE>'
 DB 'PRIN','T'+$80,'FILENAME?>'
 DB 'LOA','D'+$80,'FILENAME?>'
 DB 'PRES','S'+$80,'RETUR','N'+$80,'A','T'+$80,'NE','W'+$80,'LOCATION>'
;20
 DB 'SAV','E'+$80,'FRO','M'+$80,'CURSOR<'
 DB 'PRES','S'+$80,'F','3'+$80,'T','O'+$80
 DB 'RETUR','N'+$80,'T','O'+$80,'DOCUMENT>' 
 DB 'SAV','E'+$80,'DOCUMENT<'
 DB 'UNABL','E'+$80,'T','O'+$80,'FORMAT>'
 DB 'FON','T'+$80,'NO','T'+$80,'FOUND>'
;25
 DB 'PRES','S'+$80,'RETUR','N'+$80,'T','O'+$80,'PRIN','T'+$80
 DB '(A-O',')'+$80,'T','O'+$80,'CHANGE>'
 DB 'UPPE','R'+$80,'O','R'+$80,'LOWE','R'+$80,'CASE?(U/L)>'
 DB 'FIL','E'+$80,'EXISTS',','+$80,'OVERWRITE<'
 DB 'CHEC','K'+$80,'SPELLING<'
 DB 'INSER','T'+$80,'DICTIONAR','Y'+$80,'DISK>'
;30
 DB '<' 
 DB 'F1:REPLAC','E'+$80,'WOR','D'+$80,' '+$80
 DB 'F3:NEX','T'+$80,'WOR','D'+$80,' '+$80,'F8:EXIT>'
 DB 'SORTING',','+$80,'PLEAS','E'+$80,'WAIT>'
 DB 'CHECKIN','G'+$80,'WORDS>'
 DB 'EXI','T'+$80,'SPELLIN','G'+$80,'CHECKER<'
;35
 DB 'SAV','E'+$80,'SUSPEC','T'+$80,'WORDS<'
 DB 'N','O'+$80,'MEMORY-PRES','S'+$80,'F1>'
 DB 'USIN','G'+$80,'A'+$80,'PERSONA','L'+$80,'DICTIONARY<'
 DB 'PU','T'+$80,'DIS','K'+$80,'I','N'+$80
 DB 'DAT','A'+$80,'DRIVE',','+$80,'ENTE','R'+$80,'FILENAME>'
 DB 'INSER','T'+$80,'THESAURU','S'+$80,'DISK',','+$80
 DB 'TYP','E'+$80,'WOR','D'+$80,'T','O'+$80,'FIND>'
;40		   
 DB 'OUTLINE','R'+$80,'O','R'+$80,'CARDFILE?(O/C)>'
 DB 'NO','T'+$80,'FOUND>'
 DB 'ENTE','R'+$80,'WOR','D'+$80,'#',','+$80
 DB 'CURSO','R'+$80,'UP/DOWN',','+$80,'O','R'+$80,'RETURN>'  
 DB 'EXI','T'+$80
DB_OUT_TEXT:
 DB 'OUTLINER<'		
 DB 'THI','S'+$80,'ERASE','S'+$80
 DB 'MEMORY',','+$80,'SAV','E'+$80,'FILE<'
;45
 DB 'RETURN-CHANG','E'+$80,'CRSR-SELEC','T'+$80,'RUN/STOP-EXIT>'
 DB 'SAV','E'+$80,'SETTINGS<'
 DB 'EXI','T'+$80,'CARDFILE<' 
 DB 'FIEL','D'+$80,'NAME?>'
 DB 'PRINTER?(4/5)>'
;50
 DB 'DEFIN','E'+$80,'MACRO?(1/2)>'
 DB 'MACR','O'+$80,'ENDED>'
 DB 'SORT?(A/D)>'
 DB 'DELET','E'+$80,'CARD<'
 DB 'GOT','O'+$80,'#>'
;55
 DB 'VERSIO','N'+$80,'V1-1.0>'
 DB '>' 
;
;1234567890123456789012345678901234567890
;IN TEXT MODE: UL BD IT SP SB U1 U2 U3 00
;IN TEXT MODE: -Z-     U B I + - 1 2 3 00
 DB 'I','N'+$80,'TEX','T'+$80,'MODE',':'+$80,'-'+$80,'-'+$80,' '+$80
; DB 'U','L'+$80,'B','D'+$80,'I','T'+$80
; DB 'S','P'+$80,'S','B'+$80,'U','1'+$80,'U','2'+$80,'U','3'+$80,'00>'
 DB 'U'+$80,'B'+$80,'I'+$80
 DB '+'+$80,'-'+$80,'W'+$80,'X'+$80,'Y'+$80,'00>'
;
 DB 'WOR','D'+$80,'WRITE','R'+$80,'6'+$80
 DB 'B','Y'+$80,'JEF','F'+$80,'LOMAX>'
;
QUESTN:
 DB '?(Y/N)>'
;
SPCARS:
 DB ',S,'
;
;
;
 END
;
