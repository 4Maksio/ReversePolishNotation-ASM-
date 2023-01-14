;----------THIS-IS-THE-FINAL-VERSION----------
;---------------------------------------------
;--------------------ABOUT--------------------
;---------------------------------------------
;-This--program-gets-operation-and-writes-its-
;-representation--in--Reverse-Polish-Notation-
;-meanwhile-calculating-it.-Result-is-written-
;-beneath-------------------------------------
;-------------------FEATURES------------------
;-Program-valuates-the-entry.-----------------
;-Program-can-calculate-negative-numbers.-----
;-Program-detects-the-overflow----------------
;-Spacebar-is-ignored-------------------------

org 100h

    FINIT

start:

    call    mv_down
                    ;   Get Entry
    mov	ah,10
	mov	dx,STRING
	int	21h
					;	Prepare
	call	mv_down
	call	VALIDATE
	mov	bx,STRING+2
	mov	cl,[STRING+1]
	xor	ch,ch
	sub	sp,2		;	Reserve one word on stack
	mov	bp,sp
	mov	di,LIFO
	xor	si,si		;	For indicating the previous char
                    ;   Main Loop
ML:
					;	Is char a number
	mov	dl,[bx]
	xor	dh,dh
	cmp	dl,48
	jb	CHAR
	cmp	dl,57
	ja	CHAR
					;	If it is
	sub	dx,48
	mov	[bp],dx
	fild	word	[bp]
	cmp	si,0
	je	FDIG
	fild	word	[TEN]
	fmulp	st2,st0
	faddp	st1,st0
FDIG:
	or	si,1
					;	Exit of CHAR
ENDCHAR:
	inc	bx
loop	ML
					;	Writing	last number if necessary
	cmp	si,0
	je	PART2
	fist	word	[bp]
	mov	ax,[bp]
	push	ax
	call	WrNum
	push	word	32
	call	WrCh
					;	Finish calculating that's left
PART2:
	add	sp,2
	mov	si,LIFO
UNFILL:
	call	CALC
	cmp	si,di
	jne	UNFILL
					;	Check and write the result
PRE_FINE:
	call	mv_down
	fist	dword	[RES]
	mov	ax,[RES+2]
	cmp	ax,0xFFFF
	jne	WR_RES
	mov	dx,[RES]
	xor	dx,0xFFFF
	inc	dx
	push	dx
	push	word	45
	call	WrCh
	call	WrNum
	jmp	FINE

WR_RES:
	sub	sp,2
	mov	bp,sp
	fistp	word	[bp]
	call	WrNum
					;	End the program
FINE:
	mov	ax, 4C00h
	int	21h

;-------------------------
;--------FUNCTIONS--------
;-------------------------

;	Make calculation from end of LIFO
CALC:
				;	If LIFO empty
	mov	ax,di
	mov	dx,LIFO
	sub	ax,dx
	cmp ax,0
	je	endcalc
				;	Get and write desired char
	sub	di,2
	mov	dx,[di]
	push	dx
	call	WrCh
	push	word	32
	call	WrCh

	cmp	dl,43	;	+
	je	SUM
	cmp	dl,45	;	-
	je	DIFFER
	cmp	dl,42	;	*
	je	PRODUCT
	cmp	dl,47	;	/
	je	QUOTIENT

endcalc:
ret

;   Checks if entry is a valid mathematical operation
VALIDATE:
    pusha
    push    ER_ARG
                            ;   Preparation
        mov bx,STRING+2
        mov	cl,[bx-1]
		xor	ch,ch
		xor	ax,ax
                            ;   Active loop
        val_loop:
        mov	dl,[bx]
    		cmp	dl,32
    		je	v_e_loop
    		cmp	dl,40
    		je	brac_add
    		cmp	dl,41
    		je	brac_sub
    		cmp	dl,43
	    	je	escalate
	    	cmp	dl,45
    		je	escalate
    		cmp	dl,42
    		je	escalate
    		cmp	dl,47
    		je	escalate
    		xor	al,al
    		jmp	v_e_loop
    brac_add:
            add ah,1
            jmp v_e_loop
    brac_sub:
            sub ah,1
            cmp ah,0x20
            ja  THROW
            jmp v_e_loop
    escalate:
            add al,1
            cmp al,1
            ja  THROW

    v_e_loop:
        inc bx
        loop    val_loop

        cmp ah,0
        jne THROW
    add sp,2
    popa
ret

;	Set CPU flags to FPU flags
FLAG:
	pusha
		fstsw	ax
		sahf
	popa
ret

;	Throw error from stack
THROW:
	mov	ah,2
	mov	dl,13
	int	21h
	pop	dx
	add	ah,7
	int 21h
	add	sp,16
jmp	FINE

;	If char is not a number
CHAR:

	cmp	dl,32	;	skip spacebar
	je	ENDCHAR

	cmp	si,0
	je	ch_main
	xor	si,si
	sub	sp,2
	mov	bp,sp
	fist	word	[bp]
	call	WrNum
	push	word	32
	call	WrCh

ch_main:
				;	Priority
	xor	ax,ax
				;	(
	cmp	dl,40
	je	WEIGHT
				;	)
	cmp	dl,41
	je	WEIGHT

	inc	al
				;	+
	cmp	dl,43
	je	WEIGHT
				;	-
	cmp	dl,45
	je	WEIGHT

	inc	al
				;	*
	cmp	dl,42
	je	WEIGHT
				;	/
	cmp	dl,47
	je	WEIGHT
				;	any other
	pusha
	push	ER_ARG
	jmp	THROW

WEIGHT:
	add	dh,al

	mov	[di],dx
	add	di,2
	
CHECK:
	mov	dx,[di-4]
	mov	ah,dh
	cmp	ah,al
	jb	ENDCHAR
					;	If that's ( or ()
	cmp	dl,40
	je	double
	mov	dx,[di-2]
	cmp	dl,40
	je	ENDCHAR
	jmp	engage

double:
	mov	dx,[di-2]
	cmp	dl,40
	je	ENDCHAR
	sub	di,4
	jmp	ENDCHAR

engage:
	sub	di,2
	mov	dx,[di]
	mov	[TMP],dx
	call	CALC
	mov	dx,[TMP]
	mov	al,dh
	mov	[di],dx
	add	di,2
	jmp	CHECK

jmp	ENDCHAR

;	Write char from stack
WrCh:
	pusha
		mov	bp,sp
		mov	dx,[bp+18]
		mov	ah,2
		int	21h
		mov	dx,[bp+16]
		mov	[bp+18],dx
	popa
	add	sp,2
ret

;	Write new line
mv_down:
	pusha
		mov	ah,2
		mov	dl,10
		int	21h
		mov	dl,13
		int	21h
	popa
ret

;	Write number from stack
WrNum:
	pusha
	mov	bp,sp
	mov	ax,[bp+18]
		xor	cx,cx
		xor	dx,dx

	WC_loop1:
		mov	bx,10
		div	bx
		push	dx
		inc	cx
		xor	dx,dx
		cmp	ax,0
		jne	WC_loop1

		mov	ah,2

	WC_loop2:
		pop	dx
		add	dx,48
		int	21h
		loop	WC_loop2

	mov	dx,[bp+16]
	mov	[bp+18],dx
	popa
	add	sp,2
ret

;	Add
SUM:
	faddp	st1,st0
jmp	endcalc

;	Substract
DIFFER:
	fsubp	st1,st0
jmp	endcalc

;	Multiply
PRODUCT:
	fmulp	st1,st0
jmp	endcalc

;	Divide
QUOTIENT:
	fldz
	fcomp
	call	FLAG
	pusha
	push	ER_Z
	je	THROW
	add	sp,18
	fdivp	st1,st0
jmp	endcalc

;-------------------------
;--------VARIABLES--------
;-------------------------
STRING	db	26
	    db	0
	    times	27	db	"$"
	dw	0
LIFO    times	18	dw	"$"
TEN		dw	10
TMP		dw	0
RES		dq	0
ER_ARG	db	"ERROR: Not a valid entry!$"
ER_Z	db	"ERROR: There was a try of dividing by zero!$"
ER_O	db	"ERROR: The result is out of bound!$"