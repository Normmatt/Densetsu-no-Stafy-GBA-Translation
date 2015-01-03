 ; Legend of Stafy VWF by Normmatt

.gba				; Set the architecture to GBA
.open "rom/output.gba",0x08000000		; Open input.gba for output.
					; 0x08000000 will be used as the
					; header size

.macro adr,destReg,Address
here:
	.if (here & 2) != 0
		add destReg, r15, (Address-here)-2
	.else
		add destReg, r15, (Address-here)
	.endif
.endmacro

.org 0x080065EC ; routine that puts a character to the map
.area 0x08006600 - 0x080065EC
	mov r2, #15
	add r2,r15
	mov r14, r2
    ldr r2, =putChar+1    ; r2 is best variable to use for jump
    bx r2
.pool
.endarea

.org 0x0832A2FC
.incbin asm/bin/newfont.bin

.org 0x08345344
.incbin asm/bin/newfont2.bin

.org 0x086e0000 ; should be free space to put code
putChar:

	LDR R1, =0x3000E60
	LDR R0, [R1] ;load string address
	LDRB R1, [R0] ; load next byte
	
	ldr r0, =WidthTable
	ldrb r1, [r0,r1]
	
	;Some places in the game don't like odd positions
	;so lets just forcibly align it.
	mov r0, #1
	mov r2, r1
	and r2, r0
	add r1, r1, r2 ;Force alignment if its out

	;Original Code
	LDR R2, =0x3000E70
	;LDR R1, =0x3000E68
	LDR R0, =0x3000E6C
	;LDRB R1, [R1] ; always? loads 0x0C the character width
	LDRB R0, [R0]
	ADD R0, R1, R0
	LDRB R1, [R2]
	ADD R0, R1, R0
	STRB R0, [R2]
	LDR R1, =0x3000E60

	bx lr

.pool
.align 4
WidthTable:
.incbin asm/bin/width.bin

.close

 ; make sure to leave an empty line at the end
