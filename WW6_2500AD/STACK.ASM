;
 TITLE STACK
;
 PW 118
;
 INCLUDE WWSETUP.ASM
 INCLUDE VARIABLS.ASM
;
;=============================================================================
;COPYRIGHT @ 1987 by Ned Whatley  all rights reserved
;=============================================================================
 PUBLIC POP_A		;Retrieve .A from stack
 PUBLIC POP_AX		;Retrieve .A,.X(LSB,MSB) from stack
 PUBLIC POP_AXY		;Restore .A,.X,.Y from stack
 PUBLIC POP_EOT         ;RETRIEVE EOT
 PUBLIC POP_PT		;Retrieve value of POINTER from stack
 PUBLIC POP_P1		;Retrieve value of POINTER1 from stack
 PUBLIC POP_P2		;RETRIEVE VALUE OF POINTER2 FROM STACK
 PUBLIC POP_P3
 PUBLIC POP_TEXT        ;RETRIEVE TEXT
 PUBLIC POP_X		;Retrieve .X from pseudo-stack
 PUBLIC POP_Y		;Retrieve .Y from pseudo-stack
;
 PUBLIC PUSH_A		;Save .A on stack
 PUBLIC PUSH_AX		;Save .A,.X(LSB,MSB) on stack
 PUBLIC PUSH_AXY	;Save .A,.X,.Y on stack
 PUBLIC PUSH_EOT        ;SAVE EOT
 PUBLIC PUSH_PT		;Save value of POINTER on stack
 PUBLIC PUSH_P1		;Save value of POINTER1 on stack
 PUBLIC PUSH_P2		;SAVE VALUE OF POINTER2 ON STACK
 PUBLIC PUSH_P3
 PUBLIC PUSH_TEXT       ;SAVE TEXT
 PUBLIC PUSH_X		;Save .X on pseudo-stack
 PUBLIC PUSH_Y		;Save .Y on pseudo-stack
;
 EXTERN AX_INTO_TEXT    ;.A.X = TEXT
 EXTERN PT_INTO_AX	;Get current value of POINTER
 EXTERN P1_INTO_AX	;Get current value of POINTER1
 EXTERN P2_INTO_AX	;Get current value of POINTER2
 EXTERN P3_INTO_AX
 EXTERN AX_INTO_PT	;Store value of POINTER
 EXTERN AX_INTO_P1	;Store value of POINTER1
 EXTERN AX_INTO_P2	;Store value of POINTER2
 EXTERN AX_INTO_P3
 EXTERN TEXT_INTO_AX
;
;
.LIST ON
;
STACK:	   EQU $110	;Bottom of push/POP stack
;
PUSH_P2:
 STX STAC_X		;SAVE .X
 LDX #POINTER2
 BNE PUSH_ZP_IN_X
;
PUSH_EOT:
 STX STAC_X        ;SAVE .X
 LDX #EOT
 BNE PUSH_ZP_IN_X  ;PUSH EOT POINTER
;
PUSH_P3:
 STX STAC_X        ;SAVE .X
 LDX #POINTER3
 BNE PUSH_ZP_IN_X  ;PUSH POINTER3
;
PUSH_PT:
 STX STAC_X        ;SAVE .X
 LDX #POINTER
 BNE PUSH_ZP_IN_X  ;PUSH POINTER
;
PUSH_TEXT:
 STX STAC_X        ;SAVE .X
 LDX #TEXT
 BNE PUSH_ZP_IN_X  ;PUSH TEXT POINTER
;
PUSH_P1:
 STX STAC_X        ;SAVE .X
 LDX #POINTER1     ;.X INDEXES LB OF ZP POINTER
;
PUSH_ZP_IN_X:
 PHA               ;SAVE .A
 STY STAC_Y        ;SAVE .Y 
 LDY STACKY        ;GET USER STACK POINTER
 LDA $00,X         ;GET LB OF ZP POINTER
 STA STACK,Y       ;PUT LB ON USER STACK
 LDA $01,X         ;GET HB OF ZP POINTER
 STA STACK+1,Y     ;PUT HB ON USER STACK
;
 INY
 INY               ;BUMP INDEX UP BY 2
 STY STACKY        ;AND SET FOR NEXT ACTION
;
PUSH_POP_END:
 LDY STAC_Y        ;RESTORE .Y
 LDX STAC_X        ;RESTORE .X
 PLA               ;RESTORE .A
 RTS            
;
;
POP_P2:
 STX STAC_X
 LDX #POINTER2
 BNE POP_ZP_IN_X
;
POP_EOT:
 STX STAC_X        ;SAVE .X
 LDX #EOT         
 BNE POP_ZP_IN_X   ;POP EOT POINTER
;
POP_P3:
 STX STAC_X        ;SAVE .X
 LDX #POINTER3         
 BNE POP_ZP_IN_X   ;POP POINTER3
;
POP_PT:
 STX STAC_X        ;SAVE .X
 LDX #POINTER         
 BNE POP_ZP_IN_X   ;POP POINTER
;
POP_TEXT:
 STX STAC_X        ;SAVE .X
 LDX #TEXT         
 BNE POP_ZP_IN_X   ;POP TEXT POINTER
;
POP_P1:
 STX STAC_X        ;SAVE .X
 LDX #POINTER1     ;.X INDEXES ZP POINTER
;
POP_ZP_IN_X:
 PHA               ;SAVE .A
 STY STAC_Y        ;SAVE .Y
 LDY STACKY        ;GET USER STACK INDEX
 DEY
 DEY               ;MOVE DOWN 2 ENTRIES
 STY STACKY        ;SET FOR NEXT ACTION
 LDA STACK,Y       ;GET LB OF POINTER
 STA $00,X         ;PUT LB IN ZP
 LDA STACK+1,Y     ;GET HB OF POINTER
 STA $01,X         ;PUT HB IN ZP
 JMP PUSH_POP_END
;
;
;# THIS COSTS 7 EXTRA BYTES, BECAUSE PUSHA IS STILL REQUIRED
;
;PUSH_AX_0:
; STA STACK,Y
; STX STACK+1,Y
; INY
; INY
; STY STACKY       ;11 BYTES
; RTS              ;29 CC W/JSR-RTS
;
PUSH_AX_0		   ;Save .A,.X(LSB,MSB) on stack
	JSR PUSHA		;Save .A on stack & adjust offsets
	TXA			   ;Transfer to storable register
PUSHA:
	STA STACK,Y		;Save input .A
	INC STACKY		;Pseudo stack pointer for non-stack stack
	INY            ;11 BYTES
	RTS            ;52 CC W/JSR-RTS
;
AXY_SAVE:		;Save .A & .X
	STX ax			;Entry .X
	STA aa			;Entry .A
	STY STAC_Y		;Preserve entry .Y
	LDY STACKY		;Pseudo stack pointer for non-stack stack
	RTS
;
PUSH_X:	;Save .X on pseudo-stack
;
	JSR AXY_SAVE		;Save .A & .X
	TXA			;Value to store
	JMP STAC_1		;Save .A, restore .A and .Y
;
PUSH_A:	;Save .A on stack
;  INPUT REGISTERS USED: .A
;  INPUT POINTERS USED: None
;  RETURN REGISTERS USED: None 
;  RETURN POINTERS USED: None 
	JSR AXY_SAVE		;Save .A & .X
	JMP STAC_1		;Save .A, restore .A and .Y
;=============================================================================
PUSH_Y:	;Save .Y on pseudo-stack
;  INPUT REGISTERS USED: .Y
;  INPUT POINTERS USED: None
;  RETURN REGISTERS USED: None 
;  RETURN POINTERS USED: None 
	JSR AXY_SAVE	;Save .A & .X
	LDA STAC_Y		;Value to store
	JMP STAC_1		;Save .A, restore .A and .Y
;=============================================================================
;PUSH_EOT:
;;
; JSR AXY_SAVE      ;SAVE .A,.X
; JSR EOT_INTO_AX   ;.A.X = EOT
; JSR PUSH_AX_0     ;SAVE .AX
; BNE AXY_RESTORE
;
;PUSH_TEXT:	;Save value of TEXT POINTER on stack
;
;JSR AXY_SAVE		   ;Save .A & .X
;JSR TEXT_INTO_AX		;Get current value of POINTER1
;JSR PUSH_AX_0		   ;Save .A,.X(LSB,MSB) on stack
;BNE AXY_RESTORE		;Restore .A & .X
;
;PUSH_PT:	;Save value of POINTER on stack
;  INPUT REGISTERS USED: None 
;  INPUT POINTERS USED: POINTER
;  RETURN REGISTERS USED: .A,.X(LSB,MSB)
;  RETURN POINTERS USED: None
;	JSR AXY_SAVE		;Save .A & .X
;	JSR PT_INTO_AX		;Get current value of POINTER
;	JSR PUSH_AX_0		;Save .A,.X(LSB,MSB) on stack
;	BNE AXY_RESTORE		;Restore .A & .X
;
;PUSH_P1:	;Save value of POINTER1 on stack
;  INPUT REGISTERS USED: None 
;  INPUT POINTERS USED: POINTER1
;  RETURN REGISTERS USED: .A,.X(LSB,MSB)
;  RETURN POINTERS USED: None
;	JSR AXY_SAVE		;Save .A & .X
;	JSR P1_INTO_AX		;Get current value of POINTER1
;	JSR PUSH_AX_0		;Save .A,.X(LSB,MSB) on stack
;	BNE AXY_RESTORE		;Restore .A & .X
;
;
;PUSH_P3:	;Save value of POINTER1 on stack
;
;JSR AXY_SAVE		;Save .A & .X
;JSR P3_INTO_AX		;Get current value of POINTER1
;JSR PUSH_AX_0		;Save .A,.X(LSB,MSB) on stack
;BNE AXY_RESTORE		;Restore .A & .X
;
PUSH_AXY:	;Save .A,.X,.Y on stack
;  INPUT REGISTERS USED: .A,.X,.Y
;  INPUT POINTERS USED: None
;  RETURN REGISTERS USED: None 
;  RETURN POINTERS USED: None 
	JSR AXY_SAVE		;Save .A & .X
	JSR PUSH_AX_0		;Save .A,.X on stack
	LDA STAC_Y		;Get caller's .Y
	JSR PUSHA		;Save .A on stack & adjust offsets
	BNE AXY_RESTORE		;Restore caller's registers
;=============================================================================
PUSH_AX:	;Save .A,.X on stack
;  INPUT REGISTERS USED: .A,.X
;  INPUT POINTERS USED: None
;  RETURN REGISTERS USED: None 
;  RETURN POINTERS USED: None 
	JSR AXY_SAVE	;Save .A & .X
PU00:
	JSR PUSHA		;Save .A on stack & adjust offsets
	TXA			   ;Transfer to storable register
STAC_1		      ; INC STACKY ,save .A, restore .A and .Y
	JSR PUSHA		;Save .A on stack & adjust offsets
AXY_RESTORE:			;Restore .A & .X
	.BYTE	$A2		;Opcode for LDX #
ax	.byte	0		;Entry .A
	.BYTE	$A9		;Opcode for LDA #
aa	.byte	0		;Entry .A
	LDY STAC_Y		;Restore entry .Y
	RTS
;=============================================================================
POP_X:	;Retrieve .X from pseudo-stack
;  INPUT REGISTERS USED: .X
;  INPUT POINTERS USED: None
;  RETURN REGISTERS USED: None 
;  RETURN POINTERS USED: None 
	STY STAC_Y	;Preserve entry .Y
STAC_2:			;Retrieve .X, restore .Y
	DEC STACKY		;Pseudo stack pointer for non-stack stack
	LDY STACKY		;Pseudo stack pointer for non-stack stack
	LDX STACK,Y		;Retrieve
	LDY STAC_Y		;Preserve entry .Y
	RTS
;=============================================================================
POP_AXY:	;Restore .A,.X,.Y from stack
;  INPUT REGISTERS USED: None
;  INPUT POINTERS USED: None 
;  RETURN REGISTERS USED: .A,.X,.Y
;  RETURN POINTERS USED: None 
	JSR POP_Y		;Get caller's .Y
POP_AX:	;Retrieve .A,.X(LSB,MSB) from stack
;  INPUT REGISTERS USED:  None
;  INPUT POINTERS USED: None
;  RETURN REGISTERS USED: .A,.X(LSB,MSB)
;  RETURN POINTERS USED: None 
	JSR POP_X	;Retrieve .X from pseudo-stack
POP_A:	;Retrieve .A from stack
;  INPUT REGISTERS USED: .A
;  INPUT POINTERS USED: None
;  RETURN REGISTERS USED: None 
;  RETURN POINTERS USED: None 
	STY STAC_Y		;Preserve entry .Y
	DEC STACKY		;Pseudo stack pointer for non-stack stack
	LDY STACKY		;Pseudo stack pointer for non-stack stack
	LDA STACK,Y		;Retrieve stored.A
	LDY STAC_Y		;Preserve entry .Y
	RTS
;=============================================================================
POP_Y:	;Retrieve .Y from pseudo-stack
;  INPUT REGISTERS USED: .Y
;  INPUT POINTERS USED: None
;  RETURN REGISTERS USED: None 
;  RETURN POINTERS USED: None 
	STX STAC_Y		;Preserve entry .X
	DEC STACKY		;Pseudo stack pointer for non-stack stack
	LDX STACKY		;Pseudo stack pointer for non-stack stack
	LDY STACK,X		;Retrieve
	LDX STAC_Y		;Restore entry .X
	RTS
;=============================================================================
;POP_TEXT:	;Retrieve value of POINTER from stack
;
;	JSR AXY_SAVE		   ;Save .A & .X
;	JSR POP_AX		      ;Retrieve .A,.X(LSB,MSB) from stack
;	JSR AX_INTO_TEXT		;Store value of POINTER
;	JMP AXY_RESTORE		;Restore .A & .X
;
;POP_PT:	;Retrieve value of POINTER from stack
;  INPUT REGISTERS USED: None 
;  INPUT POINTERS USED: None
;  RETURN REGISTERS USED: None
;  RETURN POINTERS USED: POINTER
;JSR AXY_SAVE		;Save .A & .X
;JSR POP_AX		;Retrieve .A,.X(LSB,MSB) from stack
;JSR AX_INTO_PT		;Store value of POINTER
;JMP AXY_RESTORE		;Restore .A & .X
;=============================================================================
;POP_P1:	;Retrieve value of POINTER1 from stack
;
;	JSR AXY_SAVE		;Save .A & .X
;	JSR POP_AX		;Retrieve .A,.X(LSB,MSB) from stack
;	JSR AX_INTO_P1		;Store value of POINTER1
;	JMP AXY_RESTORE		;Restore .A & .X
;
;POP_P3:	;Retrieve value of POINTER1 from stack
;
;	JSR AXY_SAVE	;Save .A & .X
;	JSR POP_AX		;Retrieve .A,.X(LSB,MSB) from stack
;	JSR AX_INTO_P3	;Store value of POINTER1
;	JMP AXY_RESTORE;Restore .A & .X
;
;
 END
;
