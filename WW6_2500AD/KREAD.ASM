;COMMODORE KEY READ REPLACEMENT
;
PADDR EQUAL $DC02	;PORT A Data Direction Register(bit 1=OUTPUT/0=INPUT)
PBDDR EQUAL $DC03	;PORT B Data Direction Register(bit 1=OUTPUT/0=INPUT)
PA EQUAL $DC00		;PORT A DATA
PB EQUAL $DC01		;PORT B DATA
; 
; (*) BY NEW-KEY ASSIGNMENTS
;
 PUBLIC BIT_ON
 PUBLIC INITIL_KEYBD
 PUBLIC SCAN_FOR_KEY 
 PUBLIC SHIFT
;
 PUBLIC CTRL_SHIFT
;
INITIL_KEYBD:
 LDY #3
?0:
 LDA DEFSHIFT,Y	;Default shift key values
 STA SLEVEL1,Y	;Store default
 DEY
 BPL ?0
 RTS
;
BITON		;Table of bytes with only the byte offset bit on (1)
		.BYTE	$01,$02,$04,$08,$10,$20,$40   ; $80 ON WRAP
;
BIT_ON:
 DB $80,$40,$20,$10,$08,$04,$02,$01
;                
BITOFF		;Table of bytes with only the byte offset bit off (0)
		.BYTE	$FE,$FD,$FB,$F7,$EF,$DF,$BF,$7F
;                
DEFSHIFT	.BYTE $10,$35,$3B,$3E	;LEFT SHIFT, RIGHT SHIFT, ^, COMMO
;
KEY       DB 0
MATKEY    DB 0
SHIFT     DB 0
KEYCOL    DB 0
SLEVEL    DB 0
SLEVEL1   DB 0
SLEVEL1A  DB 0
SLEVEL2   DB 0
SLEVEL3   DB 0
KCOUNT    DB 0
LASTKEY   DB 0
CTRL_SHIFT DB 0
;
;KEYDEF.INC	;Keyboard scan position translations
;=============================================================================
;COPYRIGHT @ 1987 by Ned Whatley  all rights reserved
; MODIFIED FOR STANDARD COMMODORE KEYBOARD
;=============================================================================
KEYXLATE ;Translation matrix for key values
;NOTE: values listed as $0 are unused keys
	.BYTE 0			;starting position null for no key
;    
;---- unshifted ---------------------------------------------------------------
;Scan row 0 - offsets 1-8
 .BYTE $14	;Delete key	position 0/0
 .BYTE $0D	;Return key	position 0/1
 .BYTE $1D	;right key	position 0/2
 .BYTE $88	;F7 key		position 0/3
 .BYTE $85	;F1 key		position 0/4
 .BYTE $86	;F3 key		position 0/5
 .BYTE $87	;F5 key		position 0/6
 .BYTE $11	;Down key	position 0/7
;
;---- unshifted ---------------------------------------------------------------
;Scan row 1 - offsets 9-16
 .BYTE $33	;"3" key	position 1/0
 .BYTE $57	;"w" key	position 1/1
 .BYTE $41	;"a" key	position 1/2
 .BYTE $34	;"4" key	position 1/3
 .BYTE $5A	;"z" key	position 1/4
 .BYTE $53	;"s" key	position 1/5
 .BYTE $45	;"e" key	position 1/6
 .BYTE $00	;Left shift key	position 1/7
;
;---- unshifted ---------------------------------------------------------------
;Scan row 2 - offsets 17-24
 .BYTE $35	;"5" key	position 2/0
 .BYTE $52	;"r" key	position 2/1
 .BYTE $44	;"d" key	position 2/2
 .BYTE $36	;"6" key	position 2/3
 .BYTE $43	;"c" key	position 2/4
 .BYTE $46	;"f" key	position 2/5
 .BYTE $54	;"t" key	position 2/6
 .BYTE $58	;"x" key	position 2/7
;
;---- unshifted ---------------------------------------------------------------
;Scan row 3 - offsets 25-32
 .BYTE $37	;"7" key	position 3/0
 .BYTE $59	;"y" key	position 3/1
 .BYTE $47	;"g" key	position 3/2
 .BYTE $38	;"8" key	position 3/3
 .BYTE $42	;"b" key	position 3/4
 .BYTE $48	;"h" key	position 3/5
 .BYTE $55	;"u" key	position 3/6
 .BYTE $56	;"v" key	position 3/7
;
;---- unshifted ---------------------------------------------------------------
;Scan row 4 - offsets 33-40
 .BYTE $39	;"9" key	position 4/0
 .BYTE $49	;"i" key	position 4/1
 .BYTE $4A	;"j" key	position 4/2
 .BYTE $30	;"0" key	position 4/3
 .BYTE $4D	;"m" key	position 4/4
 .BYTE $4B	;"k" key	position 4/5
 .BYTE $4F	;"o" key	position 4/6
 .BYTE $4E	;"n" key	position 4/7
;
;---- unshifted ---------------------------------------------------------------
;Scan row 5 - offsets 41-48
 .BYTE $2B	;"+" key	position 5/0
 .BYTE $50	;"p" key	position 5/1
 .BYTE $4C	;"l" key	position 5/2
 .BYTE $2D	;"-" key	position 5/3
 .BYTE $2E	;"." key	position 5/4
 .BYTE $3A	;":" key	position 5/5
 .BYTE $40	;"@" key	position 5/6
 .BYTE $2C	;"," key	position 5/7
;
;---- unshifted ---------------------------------------------------------------
;Scan row 6 - offsets 49-56
 .BYTE $5C	;British pound symbol key	position 6/0
 .BYTE $2A	;"*" key	position 6/1
 .BYTE $3B	;";" key	position 6/2
 .BYTE $13	;CLR/HOME key	position 6/3
 .BYTE $00	;Right shift key	position 6/4
 .BYTE $3D	;"=" key	position 6/5
 .BYTE $5E	;"^" key	position 6/6
 .BYTE $2F	;"/" key	position 6/7
;
;---- unshifted ---------------------------------------------------------------
;Scan row 7 - offsets 57-64
 .BYTE $31	;"1" key	position 7/0
 .BYTE $5f	;arrow left key	position 7/1 (top left key on board)
 .BYTE $00	;Control key	position 7/2
 .BYTE $32	;"2" key	position 7/3
 .BYTE $20	;Space bar	position 7/4
 .BYTE $00	;Commodore key	position 7/5
 .BYTE $51	;"q" key	position 7/6
 .BYTE $03	;RUN/STOP key	position 7/7
;=============================================================================
;---- shifted ---------------------------------------------------------------
;Scan row 0 - offsets 1-8
 .BYTE $94	;Shifted Delete key	position 0/0 (insert)
 .BYTE $8D	;Shifted Return key	position 0/1
 .BYTE $9D	;Shifted right key(left)position 0/2
 .BYTE $8C	;Shifted F7 key		position 0/3
 .BYTE $89	;Shifted F1 key		position 0/4
 .BYTE $8A	;Shifted F3 key		position 0/5
 .BYTE $8B	;Shifted F5 key		position 0/6
 .BYTE $91	;Shifted Down key(up)	position 0/7
;
;---- shifted ---------------------------------------------------------------
;Scan row 1 - offsets 9-16
 .BYTE $23	;Shifted "3" key (#)	position 1/0
 .BYTE $D7	;Shifted "w" key	position 1/1
 .BYTE $C1	;Shifted "a" key	position 1/2
 .BYTE $24	;Shifted "4" key ($)	position 1/3
 .BYTE $DA	;Shifted "z" key	position 1/4
 .BYTE $D3	;Shifted "s" key	position 1/5
 .BYTE $C5	;Shifted "e" key	position 1/6
 .BYTE $00	;Shifted Left shift key	position 1/7
;
;---- shifted ---------------------------------------------------------------
;Scan row 2 - offsets 17-24
 .BYTE $25	;Shifted "5" key (%)	position 2/0
 .BYTE $D2	;Shifted "r" key	position 2/1
 .BYTE $C4	;Shifted "d" key	position 2/2
 .BYTE $26	;Shifted "6" key (&)	position 2/3
 .BYTE $C3	;Shifted "c" key	position 2/4
 .BYTE $C6	;Shifted "f" key	position 2/5
 .BYTE $D4	;Shifted "t" key	position 2/6
 .BYTE $D8	;Shifted "x" key	position 2/7
;
;---- shifted ---------------------------------------------------------------
;Scan row 3 - offsets 25-32
 .BYTE $27	;Shifted "7" key (')	position 3/0
 .BYTE $D9	;Shifted "y" key	position 3/1
 .BYTE $C7	;Shifted "g" key	position 3/2
 .BYTE $28	;Shifted "8" key (()	position 3/3
 .BYTE $C2	;Shifted "b" key	position 3/4
 .BYTE $C8	;Shifted "h" key	position 3/5
 .BYTE $D5	;Shifted "u" key	position 3/6
 .BYTE $D6	;Shifted "v" key	position 3/7
;
;---- shifted ---------------------------------------------------------------
;Scan row 4 - offsets 33-40
 .BYTE $29	;Shifted "9" key ())	position 4/0
 .BYTE $C9	;Shifted "i" key	position 4/1
 .BYTE $CA	;Shifted "j" key	position 4/2
 .BYTE $30	;Shifted "0" key	position 4/3
 .BYTE $CD	;Shifted "m" key	position 4/4
 .BYTE $CB	;Shifted "k" key	position 4/5
 .BYTE $CF	;Shifted "o" key	position 4/6
 .BYTE $CE	;Shifted "n" key	position 4/7
;
;---- shifted ---------------------------------------------------------------
;Scan row 5 - offsets 41-48
 .BYTE $DB	;Shifted "+" key (+)	position 5/0
 .BYTE $D0	;Shifted "p" key	position 5/1
 .BYTE $CC	;Shifted "l" key	position 5/2
 .BYTE $DD	;Shifted "-" key (-)	position 5/3
 .BYTE $3E	;Shifted "." key (>)	position 5/4
 .BYTE $5B	;Shifted ":" key ([)	position 5/5
 .BYTE $BA	;Shifted "@" key (@)	position 5/6
 .BYTE $3C	;Shifted "," key (<)	position 5/7
;
;---- shifted ---------------------------------------------------------------
;Scan row 6 - offsets 49-56
 .BYTE $A9	;Shifted British pound symbol key	position 6/0
 .BYTE $C0	;Shifted "*" key	position 6/1
 .BYTE $5D	;Shifted ";" key (])	position 6/2
 .BYTE $93	;Shifted CLR/HOME key	position 6/3
 .BYTE $00	;Shifted Right shift key	position 6/4
 .BYTE $3D	;Shifted "=" key	position 6/5
 .BYTE $DE	;Shifted "^" key	position 6/6
 .BYTE $3F	;Shifted "/" key (?)	position 6/7
;
;---- shifted ---------------------------------------------------------------
;Scan row 7 - offsets 57-64
 .BYTE $21	;Shifted "1" key (!)	position 7/0
 .BYTE $5f	;Shifted arrow left key	position 7/1 (top left key on board)
 .BYTE $00	;Shifted Control key	position 7/2
 .BYTE $22	;Shifted "2" key (")	position 7/3
 .BYTE $A0	;Shifted Space bar	position 7/4
 .BYTE $00	;Shifted Commodore key	position 7/5
 .BYTE $D1	;Shifted "q" key	position 7/6
 .BYTE $83	;Shifted RUN/STOP key	position 7/7
;=============================================================================    
;---- control ---------------------------------------------------------------
;Scan row 0 - offsets 1-8
 .BYTE $0	;Control Delete key	position 0/0
 .BYTE $0	;Control Return key	position 0/1
 .BYTE $0	;Control right key	position 0/2
 .BYTE $0	;Control F7 key		position 0/3
 .BYTE $0	;Control F1 key		position 0/4
 .BYTE $0	;Control F3 key		position 0/5
 .BYTE $0	;Control F5 key		position 0/6
 .BYTE $0	;Control Down key	position 0/7
;
;---- control ---------------------------------------------------------------
;Scan row 1 - offsets 9-16
 .BYTE $1C;Control "3" key	position 1/0
 .BYTE $17;Control "w" key	position 1/1
 .BYTE $01;Control "a" key	position 1/2
 .BYTE $9F;Control "4" key	position 1/3
 .BYTE $1A;Control "z" key	position 1/4
 .BYTE $13;Control "s" key	position 1/5
 .BYTE $05;Control "e" key	position 1/6
 .BYTE $0	;Control Left shift key	position 1/7
;
;---- control ---------------------------------------------------------------
;Scan row 2 - offsets 17-24
 .BYTE $9C;Control "5" key	position 2/0
 .BYTE $12;Control "r" key	position 2/1
 .BYTE $04;Control "d" key	position 2/2
 .BYTE $1E;Control "6" key	position 2/3
 .BYTE $03;Control "c" key	position 2/4
 .BYTE $06;Control "f" key	position 2/5
 .BYTE $14;Control "t" key	position 2/6
 .BYTE $18;Control "x" key	position 2/7
;
;---- control ---------------------------------------------------------------
;Scan row 3 - offsets 25-32
 .BYTE $1F;Control "7" key	position 3/0
 .BYTE $19;Control "y" key	position 3/1
 .BYTE $07;Control "g" key	position 3/2
 .BYTE $9E;Control "8" key	position 3/3
 .BYTE $02;Control "b" key	position 3/4
 .BYTE $08;Control "h" key	position 3/5
 .BYTE $15;Control "u" key	position 3/6
 .BYTE $16;Control "v" key	position 3/7
;
;---- control ---------------------------------------------------------------
;Scan row 4 - offsets 33-40
 .BYTE $12;Control "9" key	position 4/0
 .BYTE $09;Control "i" key	position 4/1
 .BYTE $0A;Control "j" key	position 4/2
 .BYTE $92;Control "0" key	position 4/3
 .BYTE $0D;Control "m" key	position 4/4
 .BYTE $0B;Control "k" key	position 4/5
 .BYTE $0F;Control "o" key	position 4/6
 .BYTE $0E;Control "n" key	position 4/7
;
;---- control ---------------------------------------------------------------
;Scan row 5 - offsets 41-48
 .BYTE $FC;Control "+" key	position 5/0 (*)
 .BYTE $10;Control "p" key	position 5/1
 .BYTE $0C;Control "l" key	position 5/2
 .BYTE $0	;Control "-" key	position 5/3
 .BYTE $0	;Control "." key	position 5/4
 .BYTE $1B;Control ":" key	position 5/5
 .BYTE $0	;Control "@" key	position 5/6
 .BYTE $0	;Control "," key	position 5/7
;
;---- control ---------------------------------------------------------------
;Scan row 6 - offsets 49-56
 .BYTE $1C;Control British pound symbol key	position 6/0
 .BYTE $0	;Control "*" key	position 6/1
 .BYTE $1D;Control ";" key	position 6/2
 .BYTE $0	;Control CLR/HOME key	position 6/3
 .BYTE $0	;Control Right shift key	position 6/4
 .BYTE $1F;Control "=" key	position 6/5
 .BYTE $1E;Control "^" key	position 6/6
 .BYTE $0	;Control "/" key	position 6/7
;
;---- control ---------------------------------------------------------------
;Scan row 7 - offsets 57-64
 .BYTE $90;Control "1" key	position 7/0
 .BYTE $06;Control arrow left key	position 7/1 (top left key on board)
 .BYTE $0	;Control Control key	position 7/2
 .BYTE $05;Control "2" key	position 7/3
 .BYTE $0	;Control Space bar	position 7/4
 .BYTE $0	;Control Commodore key	position 7/5
 .BYTE $11;Control "q" key	position 7/6
 .BYTE $0	;Control RUN/STOP key	position 7/7
;=============================================================================
;---- Commodore ---------------------------------------------------------------
;Scan row 0 - offsets 1-8
 .BYTE $FE;Commodore Delete key	position 0/0   (*)
 .BYTE $0	;Commodore Return key	position 0/1
 .BYTE $0	;Commodore right key	position 0/2
 .BYTE $88;Commodore F7 key		position 0/3
 .BYTE $85;Commodore F1 key		position 0/4
 .BYTE $86;Commodore F3 key		position 0/5
 .BYTE $87;Commodore F5 key		position 0/6
 .BYTE $0	;Commodore Down key	position 0/7
;
;---- Commodore ---------------------------------------------------------------
;Scan row 1 - offsets 9-16
 .BYTE $96	;Commodore "3" key	position 1/0
 .BYTE $0A	;Commodore "w" key	position 1/1
 .BYTE $B0	;Commodore "a" key	position 1/2
 .BYTE $97	;Commodore "4" key	position 1/3
 .BYTE $AD	;Commodore "z" key	position 1/4
 .BYTE $AE	;Commodore "s" key	position 1/5
 .BYTE $B1	;Commodore "e" key	position 1/6
 .BYTE $00	;Commodore Left shift key	position 1/7
;
;---- Commodore ---------------------------------------------------------------
;Scan row 2 - offsets 17-24
 .BYTE $98	;Commodore "5" key	position 2/0
 .BYTE $B2	;Commodore "r" key	position 2/1
 .BYTE $AC	;Commodore "d" key	position 2/2
 .BYTE $99   ;Commodore "6" key	position 2/3
 .BYTE $BC	;Commodore "c" key	position 2/4
 .BYTE $BB	;Commodore "f" key	position 2/5
 .BYTE $A3	;Commodore "t" key	position 2/6
 .BYTE $BD	;Commodore "x" key	position 2/7
;
;---- Commodore ---------------------------------------------------------------
;Scan row 3 - offsets 25-32
 .BYTE $9A	;Commodore "7" key	position 3/0
 .BYTE $B7	;Commodore "y" key	position 3/1
 .BYTE $A5	;Commodore "g" key	position 3/2
 .BYTE $9B	;Commodore "8" key	position 3/3
 .BYTE $BF	;Commodore "b" key	position 3/4
 .BYTE $B4	;Commodore "h" key	position 3/5
 .BYTE $B8	;Commodore "u" key	position 3/6
 .BYTE $BE	;Commodore "v" key	position 3/7
;
;---- Commodore ---------------------------------------------------------------
;Scan row 4 - offsets 33-40
 .BYTE $00	;Commodore "9" key	position 4/0
 .BYTE $A2	;Commodore "i" key	position 4/1
 .BYTE $B5	;Commodore "j" key	position 4/2
 .BYTE $00	;Commodore "0" key	position 4/3
 .BYTE $A7	;Commodore "m" key	position 4/4
 .BYTE $A1	;Commodore "k" key	position 4/5
 .BYTE $B9	;Commodore "o" key	position 4/6
 .BYTE $AA	;Commodore "n" key	position 4/7
;
;---- Commodore ---------------------------------------------------------------
;Scan row 5 - offsets 41-48
 .BYTE $A6   ;Commodore "+" key	position 5/0
 .BYTE $AF	;Commodore "p" key	position 5/1
 .BYTE $B6	;Commodore "l" key	position 5/2
 .BYTE $DC	;Commodore "-" key	position 5/3
 .BYTE $0	;Commodore "." key	position 5/4
 .BYTE $0	;Commodore ":" key	position 5/5
 .BYTE $A4	;Commodore "@" key	position 5/6
 .BYTE $0	;Commodore "," key	position 5/7
;
;---- Commodore ---------------------------------------------------------------
;Scan row 6 - offsets 49-56
 .BYTE $A8	;Commodore British pound symbol key	position 6/0
 .BYTE $DF;Commodore "*" key	position 6/1
 .BYTE $0	;Commodore ";" key	position 6/2
 .BYTE $0	;Commodore CLR/HOME key	position 6/3
 .BYTE $0	;Commodore Right shift key	position 6/4
 .BYTE $0	;Commodore "=" key	position 6/5
 .BYTE $0	;Commodore "^" key	position 6/6
 .BYTE $0	;Commodore "/" key	position 6/7
;
;---- Commodore ---------------------------------------------------------------
;Scan row 7 - offsets 57-64
 .BYTE $81	;Commodore "1" key	position 7/0
 .BYTE $FD;Commodore arrow left key	position 7/1 (*) (top left key on board)
 .BYTE $0	;Commodore Control key	position 7/2
 .BYTE $95	;Commodore "2" key	position 7/3
 .BYTE $0	;Commodore Space bar	position 7/4
 .BYTE $0	;Commodore Commodore key	position 7/5
 .BYTE $AB	;Commodore "q" key	position 7/6
 .BYTE $0	;Commodore RUN/STOP key	position 7/7
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
 ASL A		;Row times two
 ASL A		;Row times four
 ASL A		;Row times eight
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
 BNE ?SKKP
 LDA #1
 BNE ?ONE
;
?SKKP:
 LDA CTRL_SHIFT
 CMP #$C0
 BNE ?ZRO
;
 LDA #5
 DB $2C
?ZRO:
 LDA #0
?ONE:
 STA CTRL_SHIFT
;
 LDA MATKEY	;Matrix position of found key
 BEQ ?2			;No key
 CLC
 ADC SHIFT	;Adjust if shifted
 CMP LASTKEY
 BNE ?NEW_KEY
 DEC KCOUNT
 BNE ?NO_KEY
;                
?NEW_KEY:        
 TAX
 STX LASTKEY
 LDA #$39
 STA KCOUNT
 LDA KEYXLATE,X
 LDX CTRL_SHIFT
 CPX #5
 BNE ?2
 SEC
 SBC #$C0
?2:
 RTS
;
?NO_KEY:
 LDA #0
 RTS
;-----------------------------------------------------------------------------
;SETSL3	LDA #192	;Offset for third shift matrix values
;	.BYTE $2C	;Pseudo BIT absolute to bypass LDA #
SETSL2	LDA #128	;Offset for second shift matrix values
	.BYTE $2C	;Pseudo BIT absolute to bypass LDA #
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
 END
;
