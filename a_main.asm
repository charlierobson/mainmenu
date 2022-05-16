;-------------------------------------------------------------------------------
;
.module A_MAIN

ERR_NR		.equ	$4000
FLAGS		.equ	$4001
ERR_SP		.equ	$4002
RAMTOP		.equ	$4004
MODE		.equ	$4006
PPC			.equ	$4007

	.org	$4009

	.exportmode NO$GMB
	.export

	.include	charmap.asm

versn	.byte	$00
e_ppc	.word	$0000
d_file	.word	dfile
df_cc	.word	dfile+1 
vars	.word	_var
dest	.word	$0000 
e_line	.word	_var+1 
ch_add	.word	_last-1 
x_ptr	.word	$0000 
stkbot	.word	_last 
stkend	.word	_last 
breg	.byte	$00 
mem		.word	membot 
unuseb	.byte	$00 
df_sz	.byte	$02 
s_top	.word	$0000 
last_k	.word	$ffff 
db_st	.byte	$ff
margin	.byte	55 
nxtlin	.word	_line10 
oldpc	.word	$0000
flagx	.byte	$00
strlen	.word	$0000 
t_addr	.word	$0c6b
seed	.word	$0000 
frames	.word	$ffff
coords	.byte	$00 
		.byte	$00 
pr_cc	.byte	188 
s_posn	.byte	33 
s_psn1	.byte	24 
cdflag	.byte	64 
prtbuff	.fill	32,0		; if you're tight on memory there's 65 bytes free here ;)
prbend	.byte	$76			;
membot	.fill	32,0		;


; wait for long command to finish, a has response code on return
;
api_responder  .equ $1ff6

; de = fname pointer, with optional start,length;  a = operation.: 0 = load, 1 = delete, 2 = rename, 80-ff = save
;
api_fileop     .equ $1ff8

; de = high bit terminated string, terminating zero will be sent
;
api_sendstring .equ $1ffa

; de = memory to xfer, l = len, a = mode: 0 = read, 1 = write
;
api_xfer       .equ $1ffc

; C has joy bits on return 7:5 := UDLRF---
;
api_rdjoy      .equ $1ffe


;-------------------------------------------------------------------------------


_line1:
	.byte	0,1
	.word	_line1end-$-2
	.byte	$ea

	call	ZXPAND._memlo				; 8-40k

	ld		de,MAINMENU._menulistfn
	call	ZXPAND._load
	ld		(hl),$ff

	ld		hl,$8000					; ascii to zeddy
	call	TXT._transcodeAtoZ

	ld		hl,AYFX._soundbank
	call	AYFX._INIT

	; enable our custom display handler.
	; runs input processing in the vertical sync and enables use of IY register.
	ld 		ix,DISPLAY._GENERATE
	call	framesync

-:	call	MAINMENU._run
    jr      {-}


;-------------------------------------------------------------------------------


	.include s_mainmenu.asm

	.include general.asm
	.include txt.asm
	.include input.asm
	.include displaydriver.asm
	.include ayfxplayer.asm
	.include zxpand.asm


dfile:
	.byte	$76,$80,$80,$a8,$b4,$b2,$b5,$ba,$b9,$aa,$b7,$80,$ad,$ae,$b8,$b9,$b4,$b7,$be,$80,$b2,$ba,$b8,$aa,$ba,$b2,$80,$b2,$aa,$b3,$ba,$80,$80
	.repeat 22
	.byte	$76,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80
;	.byte	$76,$80,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$80 ; for debugging
	.loop
	.byte	$76,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
	.byte   $76


;-------------------------------------------------------------------------------

.module A_MAIN

	.byte	$76
_line1end:
_line10:
	.byte	0,2
	.word	_line10end-$-2
	.byte	$F9,$D4,$C5,$0B				; RAND USR VAL "
	.byte	$1D,$22,$21,$1D,$20			; 16514 
	.byte	$0B							; "
	.byte	076H						; N/L
_line10end:

_var:
	.byte	080H
_last:

.endmodule
	.end
