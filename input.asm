;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;
.module INPUT

; 724T, constant

_read:
	ld		bc,$e007				; initiate a zxpand joystick read
	ld		a,$a0
	out		(c),a

_inputptr=$+1
	ld		hl,_titleinput			; !! self modified
	nop								; timing

	in		a,(c)
	ld		d,a

	ld		c,$fe					; keyboard input port

	; point at first input state block,
	; return from update function pointing to next
	;
	call	_update ; (up)
	call	_update ; (down)
	call	_update ;  etc.
	call	_update ;

	; fall into here for last input

_update:
	ld		a,d						; js value
	and		(hl)					; and with js mask, 0 if dirn pressed
	sub		1						; carry set if result was 0. have to SUB, DEC doesnt affect carry :(
	rl		e						; js result: bit 0 set if dirn detected. starting value of e is irrelevant
	inc		hl						; -> kb port address
	ld		b,(hl)
	in		a,(c)					; read keyboard
	inc		hl						; -> key row mask
	and		(hl)					; result will be 0 if key pressed
	sub		1						; carry set if key pressed
	rla								; carry into bit 0
	or		e						; integrate js results, only care about bit 0
	rra								; completed result back into carry
	inc		hl						; ->key state
	rl		(hl)					; shift carry into input bit train, job done
	inc		hl						; -> next input in table
	ret


;	-input port- 			-bit-
;							4  3  2  1  0

;	$FE %11111110			V, C, X, Z, SH	
;	$FD %11111101			G, F, D, S, A	
;	$FB %11111011			T, R, E, W, Q	
;	$F7 %11110111			5, 4, 3, 2, 1	
;	$EF %11101111			6, 7, 8, 9, 0	
;	$DF %11011111			Y, U, I, O, P	
;	$BF %10111111			H, J, K, L, NL	
;	$7F %01111111			B, N, M, ., SP
;
; input state data:
;
; joystick bit, or $ff/%11111111 for no joy
; key row input port address,
; key mask, or $ff/%11111111 for no key
; output trigger impulse

_titleinput:
	.byte	%10000000,$ef,%00001000,0		; up (7)
	.byte	%01000000,$ef,%00010000,0		; down (6)
	.byte	%00001000,$bf,%00000001,0		; go (newline)
	.byte	%00001000,$7f,%00000001,0		; go2 (space)
	.byte	%11111111,$ff,%11111111,0		; 

; calculate actual input impulse addresses
;
_up		= _titleinput + 3
_down	= _titleinput + 7
_go1	= _titleinput + 11
_go2	= _titleinput + 15

.endmodule
