;COMMODORE KEY READ REPLACEMENT
;
!zone KREAD
PADDR = AL $DC02	;PORT A Data Direction Register(bit 1=OUTPUT/0=INPUT)
PBDDR = AL $DC03	;PORT B Data Direction Register(bit 1=OUTPUT/0=INPUT)
PA = AL $DC00		;PORT A DATA
PB = AL $DC01		;PORT B DATA
;
; (*) BY NEW-KEY ASSIGNMENTS
;
;
;
INITIL_KEYBD:
 LDY #3
.NUM0:
 LDA DEFSHIFT,Y	;Default shift key values
 STA SLEVEL1,Y	;Store default
 DEY
 BPL .NUM0
 RTS
;
BITON		;Table of bytes with only the byte offset bit on (1)
!byte $01,$02,$04,$08,$10,$20,$40; $80 ON WRAP
;
BIT_ON:
!byte $80,$40,$20,$10,$08,$04,$02,$01
;
BITOFF		;Table of bytes with only the byte offset bit off (0)
!byte $FE,$FD,$FB,$F7,$EF,$DF,$BF,$7F
;
DEFSHIFT
!byte $10,$35,$3B,$3E;LEFT SHIFT, RIGHT SHIFT, ^, COMMO
;
KEY
!byte 0
MATKEY
!byte 0
SHIFT
!byte 0
KEYCOL
!byte 0
SLEVEL
!byte 0
SLEVEL1
!byte 0
SLEVEL1A
!byte 0
SLEVEL2
!byte 0
SLEVEL3
!byte 0
KCOUNT
!byte 0
LASTKEY
!byte 0
CTRL_SHIFT
!byte 0
;
;KEYDEF.INC	;Keyboard scan position translations
;=============================================================================
;COPYRIGHT @ 1987 by Ned Whatley  all rights reserved
; MODIFIED FOR STANDARD COMMODORE KEYBOARD
;=============================================================================
KEYXLATE ;Translation matrix for key values
;NOTE: values listed as $0 are unused keys
!byte 0;starting position null for no key
;
;---- unshifted ---------------------------------------------------------------
;Scan row 0 - offsets 1-8
!byte $14;Delete key	position 0/0
!byte $0D;Return key	position 0/1
!byte $1D;right key	position 0/2
!byte $88;F7 key		position 0/3
!byte $85;F1 key		position 0/4
!byte $86;F3 key		position 0/5
!byte $87;F5 key		position 0/6
!byte $11;Down key	position 0/7
;
;---- unshifted ---------------------------------------------------------------
;Scan row 1 - offsets 9-16
!byte $33;"3" key	position 1/0
!byte $57;"w" key	position 1/1
!byte $41;"a" key	position 1/2
!byte $34;"4" key	position 1/3
!byte $5A;"z" key	position 1/4
!byte $53;"s" key	position 1/5
!byte $45;"e" key	position 1/6
!byte $00;Left shift key	position 1/7
;
;---- unshifted ---------------------------------------------------------------
;Scan row 2 - offsets 17-24
!byte $35;"5" key	position 2/0
!byte $52;"r" key	position 2/1
!byte $44;"d" key	position 2/2
!byte $36;"6" key	position 2/3
!byte $43;"c" key	position 2/4
!byte $46;"f" key	position 2/5
!byte $54;"t" key	position 2/6
!byte $58;"x" key	position 2/7
;
;---- unshifted ---------------------------------------------------------------
;Scan row 3 - offsets 25-32
!byte $37;"7" key	position 3/0
!byte $59;"y" key	position 3/1
!byte $47;"g" key	position 3/2
!byte $38;"8" key	position 3/3
!byte $42;"b" key	position 3/4
!byte $48;"h" key	position 3/5
!byte $55;"u" key	position 3/6
!byte $56;"v" key	position 3/7
;
;---- unshifted ---------------------------------------------------------------
;Scan row 4 - offsets 33-40
!byte $39;"9" key	position 4/0
!byte $49;"i" key	position 4/1
!byte $4A;"j" key	position 4/2
!byte $30;"0" key	position 4/3
!byte $4D;"m" key	position 4/4
!byte $4B;"k" key	position 4/5
!byte $4F;"o" key	position 4/6
!byte $4E;"n" key	position 4/7
;
;---- unshifted ---------------------------------------------------------------
;Scan row 5 - offsets 41-48
!byte $2B;"+" key	position 5/0
!byte $50;"p" key	position 5/1
!byte $4C;"l" key	position 5/2
!byte $2D;"-" key	position 5/3
!byte $2E;"." key	position 5/4
!byte $3A;":" key	position 5/5
!byte $40;"@" key	position 5/6
!byte $2C;"," key	position 5/7
;
;---- unshifted ---------------------------------------------------------------
;Scan row 6 - offsets 49-56
!byte $5C;British pound symbol key	position 6/0
!byte $2A;"*" key	position 6/1
!byte $3B;";" key	position 6/2
!byte $13;CLR/HOME key	position 6/3
!byte $00;Right shift key	position 6/4
!byte $3D;"=" key	position 6/5
!byte $5E;"^" key	position 6/6
!byte $2F;"/" key	position 6/7
;
;---- unshifted ---------------------------------------------------------------
;Scan row 7 - offsets 57-64
!byte $31;"1" key	position 7/0
!byte $5f;arrow left key	position 7/1 (top left key on board)
!byte $00;Control key	position 7/2
!byte $32;"2" key	position 7/3
!byte $20;Space bar	position 7/4
!byte $00;Commodore key	position 7/5
!byte $51;"q" key	position 7/6
!byte $03;RUN/STOP key	position 7/7
;=============================================================================
;---- shifted ---------------------------------------------------------------
;Scan row 0 - offsets 1-8
!byte $94;Shifted Delete key	position 0/0 (insert)
!byte $8D;Shifted Return key	position 0/1
!byte $9D;Shifted right key(left)position 0/2
!byte $8C;Shifted F7 key		position 0/3
!byte $89;Shifted F1 key		position 0/4
!byte $8A;Shifted F3 key		position 0/5
!byte $8B;Shifted F5 key		position 0/6
!byte $91;Shifted Down key(up)	position 0/7
;
;---- shifted ---------------------------------------------------------------
;Scan row 1 - offsets 9-16
!byte $23;Shifted "3" key (#)	position 1/0
!byte $D7;Shifted "w" key	position 1/1
!byte $C1;Shifted "a" key	position 1/2
!byte $24;Shifted "4" key ($)	position 1/3
!byte $DA;Shifted "z" key	position 1/4
!byte $D3;Shifted "s" key	position 1/5
!byte $C5;Shifted "e" key	position 1/6
!byte $00;Shifted Left shift key	position 1/7
;
;---- shifted ---------------------------------------------------------------
;Scan row 2 - offsets 17-24
!byte $25;Shifted "5" key (%)	position 2/0
!byte $D2;Shifted "r" key	position 2/1
!byte $C4;Shifted "d" key	position 2/2
!byte $26;Shifted "6" key (&)	position 2/3
!byte $C3;Shifted "c" key	position 2/4
!byte $C6;Shifted "f" key	position 2/5
!byte $D4;Shifted "t" key	position 2/6
!byte $D8;Shifted "x" key	position 2/7
;
;---- shifted ---------------------------------------------------------------
;Scan row 3 - offsets 25-32
!byte $27;Shifted "7" key (')	position 3/0
!byte $D9;Shifted "y" key	position 3/1
!byte $C7;Shifted "g" key	position 3/2
!byte $28;Shifted "8" key (()	position 3/3
!byte $C2;Shifted "b" key	position 3/4
!byte $C8;Shifted "h" key	position 3/5
!byte $D5;Shifted "u" key	position 3/6
!byte $D6;Shifted "v" key	position 3/7
;
;---- shifted ---------------------------------------------------------------
;Scan row 4 - offsets 33-40
!byte $29;Shifted "9" key ())	position 4/0
!byte $C9;Shifted "i" key	position 4/1
!byte $CA;Shifted "j" key	position 4/2
!byte $30;Shifted "0" key	position 4/3
!byte $CD;Shifted "m" key	position 4/4
!byte $CB;Shifted "k" key	position 4/5
!byte $CF;Shifted "o" key	position 4/6
!byte $CE;Shifted "n" key	position 4/7
;
;---- shifted ---------------------------------------------------------------
;Scan row 5 - offsets 41-48
!byte $DB;Shifted "+" key (+)	position 5/0
!byte $D0;Shifted "p" key	position 5/1
!byte $CC;Shifted "l" key	position 5/2
!byte $DD;Shifted "-" key (-)	position 5/3
!byte $3E;Shifted "." key (>)	position 5/4
!byte $5B;Shifted ":" key ([)	position 5/5
!byte $BA;Shifted "@" key (@)	position 5/6
!byte $3C;Shifted "," key (<)	position 5/7
;
;---- shifted ---------------------------------------------------------------
;Scan row 6 - offsets 49-56
!byte $A9;Shifted British pound symbol key	position 6/0
!byte $C0;Shifted "*" key	position 6/1
!byte $5D;Shifted ";" key (])	position 6/2
!byte $93;Shifted CLR/HOME key	position 6/3
!byte $00;Shifted Right shift key	position 6/4
!byte $3D;Shifted "=" key	position 6/5
!byte $DE;Shifted "^" key	position 6/6
!byte $3F;Shifted "/" key (?)	position 6/7
;
;---- shifted ---------------------------------------------------------------
;Scan row 7 - offsets 57-64
!byte $21;Shifted "1" key (!)	position 7/0
!byte $5f;Shifted arrow left key	position 7/1 (top left key on board)
!byte $00;Shifted Control key	position 7/2
!byte $22;Shifted "2" key (")	position 7/3
!byte $A0;Shifted Space bar	position 7/4
!byte $00;Shifted Commodore key	position 7/5
!byte $D1;Shifted "q" key	position 7/6
!byte $83;Shifted RUN/STOP key	position 7/7
;=============================================================================
;---- control ---------------------------------------------------------------
;Scan row 0 - offsets 1-8
!byte $0;Control Delete key	position 0/0
!byte $0;Control Return key	position 0/1
!byte $0;Control right key	position 0/2
!byte $0;Control F7 key		position 0/3
!byte $0;Control F1 key		position 0/4
!byte $0;Control F3 key		position 0/5
!byte $0;Control F5 key		position 0/6
!byte $0;Control Down key	position 0/7
;
;---- control ---------------------------------------------------------------
;Scan row 1 - offsets 9-16
!byte $1C;Control "3" key	position 1/0
!byte $17;Control "w" key	position 1/1
!byte $01;Control "a" key	position 1/2
!byte $9F;Control "4" key	position 1/3
!byte $1A;Control "z" key	position 1/4
!byte $13;Control "s" key	position 1/5
!byte $05;Control "e" key	position 1/6
!byte $0;Control Left shift key	position 1/7
;
;---- control ---------------------------------------------------------------
;Scan row 2 - offsets 17-24
!byte $9C;Control "5" key	position 2/0
!byte $12;Control "r" key	position 2/1
!byte $04;Control "d" key	position 2/2
!byte $1E;Control "6" key	position 2/3
!byte $03;Control "c" key	position 2/4
!byte $06;Control "f" key	position 2/5
!byte $14;Control "t" key	position 2/6
!byte $18;Control "x" key	position 2/7
;
;---- control ---------------------------------------------------------------
;Scan row 3 - offsets 25-32
!byte $1F;Control "7" key	position 3/0
!byte $19;Control "y" key	position 3/1
!byte $07;Control "g" key	position 3/2
!byte $9E;Control "8" key	position 3/3
!byte $02;Control "b" key	position 3/4
!byte $08;Control "h" key	position 3/5
!byte $15;Control "u" key	position 3/6
!byte $16;Control "v" key	position 3/7
;
;---- control ---------------------------------------------------------------
;Scan row 4 - offsets 33-40
!byte $12;Control "9" key	position 4/0
!byte $09;Control "i" key	position 4/1
!byte $0A;Control "j" key	position 4/2
!byte $92;Control "0" key	position 4/3
!byte $0D;Control "m" key	position 4/4
!byte $0B;Control "k" key	position 4/5
!byte $0F;Control "o" key	position 4/6
!byte $0E;Control "n" key	position 4/7
;
;---- control ---------------------------------------------------------------
;Scan row 5 - offsets 41-48
!byte $FC;Control "+" key	position 5/0 (*)
!byte $10;Control "p" key	position 5/1
!byte $0C;Control "l" key	position 5/2
!byte $0;Control "-" key	position 5/3
!byte $0;Control "." key	position 5/4
!byte $1B;Control ":" key	position 5/5
!byte $0;Control "@" key	position 5/6
!byte $0;Control "," key	position 5/7
;
;---- control ---------------------------------------------------------------
;Scan row 6 - offsets 49-56
!byte $1C;Control British pound symbol key	position 6/0
!byte $0;Control "*" key	position 6/1
!byte $1D;Control ";" key	position 6/2
!byte $0;Control CLR/HOME key	position 6/3
!byte $0;Control Right shift key	position 6/4
!byte $1F;Control "=" key	position 6/5
!byte $1E;Control "^" key	position 6/6
!byte $0;Control "/" key	position 6/7
;
;---- control ---------------------------------------------------------------
;Scan row 7 - offsets 57-64
!byte $90;Control "1" key	position 7/0
!byte $06;Control arrow left key	position 7/1 (top left key on board)
!byte $0;Control Control key	position 7/2
!byte $05;Control "2" key	position 7/3
!byte $0;Control Space bar	position 7/4
!byte $0;Control Commodore key	position 7/5
!byte $11;Control "q" key	position 7/6
!byte $0;Control RUN/STOP key	position 7/7
;=============================================================================
;---- Commodore ---------------------------------------------------------------
;Scan row 0 - offsets 1-8
!byte $FE;Commodore Delete key	position 0/0   (*)
!byte $0;Commodore Return key	position 0/1
!byte $0;Commodore right key	position 0/2
!byte $88;Commodore F7 key		position 0/3
!byte $85;Commodore F1 key		position 0/4
!byte $86;Commodore F3 key		position 0/5
!byte $87;Commodore F5 key		position 0/6
!byte $0;Commodore Down key	position 0/7
;
;---- Commodore ---------------------------------------------------------------
;Scan row 1 - offsets 9-16
!byte $96;Commodore "3" key	position 1/0
!byte $0A;Commodore "w" key	position 1/1
!byte $B0;Commodore "a" key	position 1/2
!byte $97;Commodore "4" key	position 1/3
!byte $AD;Commodore "z" key	position 1/4
!byte $AE;Commodore "s" key	position 1/5
!byte $B1;Commodore "e" key	position 1/6
!byte $00;Commodore Left shift key	position 1/7
;
;---- Commodore ---------------------------------------------------------------
;Scan row 2 - offsets 17-24
!byte $98;Commodore "5" key	position 2/0
!byte $B2;Commodore "r" key	position 2/1
!byte $AC;Commodore "d" key	position 2/2
!byte $99;Commodore "6" key	position 2/3
!byte $BC;Commodore "c" key	position 2/4
!byte $BB;Commodore "f" key	position 2/5
!byte $A3;Commodore "t" key	position 2/6
!byte $BD;Commodore "x" key	position 2/7
;
;---- Commodore ---------------------------------------------------------------
;Scan row 3 - offsets 25-32
!byte $9A;Commodore "7" key	position 3/0
!byte $B7;Commodore "y" key	position 3/1
!byte $A5;Commodore "g" key	position 3/2
!byte $9B;Commodore "8" key	position 3/3
!byte $BF;Commodore "b" key	position 3/4
!byte $B4;Commodore "h" key	position 3/5
!byte $B8;Commodore "u" key	position 3/6
!byte $BE;Commodore "v" key	position 3/7
;
;---- Commodore ---------------------------------------------------------------
;Scan row 4 - offsets 33-40
!byte $00;Commodore "9" key	position 4/0
!byte $A2;Commodore "i" key	position 4/1
!byte $B5;Commodore "j" key	position 4/2
!byte $00;Commodore "0" key	position 4/3
!byte $A7;Commodore "m" key	position 4/4
!byte $A1;Commodore "k" key	position 4/5
!byte $B9;Commodore "o" key	position 4/6
!byte $AA;Commodore "n" key	position 4/7
;
;---- Commodore ---------------------------------------------------------------
;Scan row 5 - offsets 41-48
!byte $A6;Commodore "+" key	position 5/0
!byte $AF;Commodore "p" key	position 5/1
!byte $B6;Commodore "l" key	position 5/2
!byte $DC;Commodore "-" key	position 5/3
!byte $0;Commodore "." key	position 5/4
!byte $0;Commodore ":" key	position 5/5
!byte $A4;Commodore "@" key	position 5/6
!byte $0;Commodore "," key	position 5/7
;
;---- Commodore ---------------------------------------------------------------
;Scan row 6 - offsets 49-56
!byte $A8;Commodore British pound symbol key	position 6/0
!byte $DF;Commodore "*" key	position 6/1
!byte $0;Commodore ";" key	position 6/2
!byte $0;Commodore CLR/HOME key	position 6/3
!byte $0;Commodore Right shift key	position 6/4
!byte $0;Commodore "=" key	position 6/5
!byte $0;Commodore "^" key	position 6/6
!byte $0;Commodore "/" key	position 6/7
;
;---- Commodore ---------------------------------------------------------------
;Scan row 7 - offsets 57-64
!byte $81;Commodore "1" key	position 7/0
!byte $FD;Commodore arrow left key	position 7/1 (*) (top left key on board)
!byte $0;Commodore Control key	position 7/2
!byte $95;Commodore "2" key	position 7/3
!byte $0;Commodore Space bar	position 7/4
!byte $0;Commodore Commodore key	position 7/5
!byte $AB;Commodore "q" key	position 7/6
!byte $0;Commodore RUN/STOP key	position 7/7
;=============================================================================
;
;
SCAN_FOR_KEY:	;Scan keyboard for depressed key/combination
 LDX #$FF	   ;All output
 TXA
 STX PADDR 	;PORT A Data Direction Register(bit 1=OUTPUT/0=INPUT)
 INX		   ;Convert to 0 (all input)
 STX CTRL_SHIFT
 STX PBDDR 	;PORT B Data Direction Register(bit 1=OUTPUT/0=INPUT)
 STX KEY		;Default no key pressed
 STX MATKEY	;Default no key pressed
 STX SHIFT	;Default no SHIFT active
 STX PA		;Set all data lines low
;
;LDA #$FF	   ;Value for all lines high
 CMP PB		;.A=255 still
 BEQ KOUT9	;NO KEY DEPRESSED (CODE-$FF)
; NOW SCAN FOR ACTIVE KEY
 LDX #7		;MAIN SCANNING ALGORITHM
KS0:
 LDY #7
KS1:
 JSR TMESH	;Test for switch closed at matrix intersection .X,.Y
 BNE KS2		;No mesh at this intersection
; Second test for debounce
 JSR TMESH	;Retest for switch closed at matrix intersection .X,.Y
 BNE KS1		;Bounce detected retry position
; Third test for debounce
; JSR TMESH	;Retest for switch closed at matrix intersection .X,.Y
; BNE KS1		;Bounce detected retry position
;   found key down - now test for shift
 TXA		;Row number 0-7
 ASL		;Row times two
 ASL		;Row times four
 ASL		;Row times eight
 STY KEYCOL	;Save column number
 SEC		;Force value + 1 so zero remains invalid
 ADC KEYCOL	;Add column number
 CMP SLEVEL1	;First shift level key?
 BEQ SETSL1	;Yes
 CMP SLEVEL1A	;First shift level alternate key?
 BEQ SETSL1	;Yes
 CMP SLEVEL2	;Second shift level key?
 BEQ SETSL2	;Yes
 CMP SLEVEL3	;Third shift level key?
 BEQ SETSL3	;Yes
 STA MATKEY	;Store key matrix position
KS2:
 DEY		;Set for next column
 BPL KS1		;Valid column
 DEX		;Set for next row
 BPL KS0		;Valid row
;--------------------------
;      END OF SCAN
;--------------------------
KOUT9:
;
 LDA SHIFT
 CMP #$C0
 BNE .SKKP
 LDA #1
 BNE .ONE
;
.SKKP:
 LDA CTRL_SHIFT
 CMP #$C0
 BNE .ZRO
;
 LDA #5
!byte $2C
.ZRO:
 LDA #0
.ONE:
 STA CTRL_SHIFT
;
 LDA MATKEY	;Matrix position of found key
 BEQ .NUM2			;No key
 CLC
 ADC SHIFT	;Adjust if shifted
 CMP LASTKEY
 BNE .NEW_KEY
 DEC KCOUNT
 BNE .NO_KEY
;
.NEW_KEY:        
 TAX
 STX LASTKEY
 LDA #$39
 STA KCOUNT
 LDA KEYXLATE,X
 LDX CTRL_SHIFT
 CPX #5
 BNE .NUM2
 SEC
 SBC #$C0
.NUM2:
 RTS
;
.NO_KEY:
 LDA #0
 RTS
;-----------------------------------------------------------------------------
;SETSL3	LDA #192	;Offset for third shift matrix values
;	.BYTE $2C	;Pseudo BIT absolute to bypass LDA #
SETSL2	LDA #128	;Offset for second shift matrix values
!byte $2C;Pseudo BIT absolute to bypass LDA #
SETSL1	LDA #64		;Offset for first shift matrix values
	STA SHIFT	;Set shift offset
 ORA CTRL_SHIFT
 STA CTRL_SHIFT
 BCS KS2		;Return to scan matrix (Carry uneffected from CMP)
SETSL3:
 LDA #192
 STA SHIFT
 BCS KS2
;
TMESH:
 LDA BITOFF,X;Get pattern with bit .X off and other bits set
 STA PA		;Set key matrix row scan
 LDA PB		;Read for switches closed (bits turned off)
 AND BITON,Y	;Retest for valid column in row
 RTS
;
;
!eof
;

; PUBLIC BIT_ON
; PUBLIC INITIL_KEYBD
; PUBLIC SCAN_FOR_KEY
; PUBLIC SHIFT
; PUBLIC CTRL_SHIFT
