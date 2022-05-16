;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;
.module MAINMENU

SPACING .equ 2

_run:
	ld		hl,0
	ld		(frames),hl

	ld		hl,_t1
	ld		b,3*32
	call	invert

_redraw:
	call	_drawmenuitems
	call	_invertRow

_loop:
	call	framesync

	ld		hl,_textnum

	ld		a,(frames)
	and		a
	ld		a,(hl)
	jr		nz,_nochangetext

	inc		a
	cp		3
	jr		nz,_nochangetext

	xor		a

_nochangetext:
	ld		(hl),a

	ld		hl,_titletextlist
	call	tableget

	ld		de,dfile+1+23*33
	ld		bc,32
	ldir

	ld		a,(INPUT._up)
	and		3						; check for key just released
	cp		2						; %xxxxxx10    pressed last frame, not pressed this
	call	z,_cursUp

	ld		a,(INPUT._down)
	and		3
	cp		2
	call	z,_cursDown

	ld		a,(INPUT._go1)
	and		3
	cp		2
	jp		z,_dorun

	ld		a,(INPUT._go2)
	and		3
	cp		2
	jp		z,_dorun

	jr		_loop


_dorun:
	ld		a,2
	call	AYFX._PLAY
	call	framesync
	call	framesync
	call	framesync
	call	framesync
	call	framesync

	ld		a,(_listRow)
	ld		hl,_fnList
	call	tableget
	ld		(_smfileptr),hl

   call  $02e7               ; go fast - don't use proxy as we really really do need to disable nmis at this point

   ld    hl,ep_start         ; move code to 8K and jump there
   ld    de,$2000
   ld    bc,ep_end-ep_start
   ldir

   jp    $2000

ep_start:
   ld    hl,(ERR_SP)          ; we can't return to the old program now, so clean up the stack
   ld    sp,hl
   ld    hl,$207              ; we want to return via SLOW
   push  hl
_smfileptr=$+1
   ld    de,0
   xor   a
   jp    api_fileop           ; go loader!
ep_end:

; ------------------------------------------------------------




_cursUp:
	ld		a,(_listRow)
	and		a
	ret		z

	call	_invertRow
	ld		a,(_listRow)
	dec		a
	ld		(_listRow),a
	call	_invertRow
	ld		a,1
	jp		AYFX._PLAY

_cursDown:
	ld		a,(_listRow)
	inc		a
	ld		l,a
	ld		a,(_listCount)
	cp		l
	ret		z

	call	_invertRow
	ld		a,(_listRow)
	inc		a
	ld		(_listRow),a
	call	_invertRow
	ld		a,1
	jp		AYFX._PLAY

_invertRow:
	ld		a,(_listRow)
	ld		hl,dfile+1+2+2*33
	ld		de,33*SPACING
	jr		{+}

-:	add		hl,de
	dec		a
+:	and		a
	jr		nz,{-}

	ld		b,28

-:	ld		a,(hl)
	xor		128
	ld		(hl),a
	inc		hl
	djnz	{-}

	ret



-:	inc		hl
_skipnonprintable:
	ld		a,(hl)
	cp		$ff
	ret		z
	cp		$76
	jr		z,{-}
	ret


-:	inc		hl
_skipprintable:
	ld		a,(hl)
	cp		$ff
	ret		z
	cp		$76
	jr		nz,{-}
	ret


_drawmenuitems:
	ld		hl,$8000
	ld		de,dfile+1+2+2*33

_nextline:
	call	_skipnonprintable
	cp		$ff
	ret		z

	push	hl

	ld		b,0
	jr		_countdesc

-:	inc		hl
	inc		b
_countdesc:						; b = count the number of characters in the description
	ld		a,(hl)
	cp		$19
	jr		nz,{-}

	pop		hl
	push	de

	ld		a,28
	sub		b
	srl		a
	call	adda2de

	jr		_printdesc

-:	ld		(de),a
	inc		de
	inc		hl
_printdesc:
	ld		a,(hl)
	cp		$19			; semicolon, separates item text and filename
	jr		nz,{-}

	inc		hl
	call	_addFnToList

	call	_skipprintable
	dec		hl
	ld		a,(hl)
	xor		128
	ld		(hl),a
	inc		hl

	pop		de
	push	hl
	ld		hl,33*SPACING
	add		hl,de
	ex		de,hl
	pop		hl
	jr		_nextline



_addFnToList:
	push	hl
	push	de
	ex		de,hl
	ld		hl,(_listPtr)
	ld		(hl),e
	inc		hl
	ld		(hl),d
	inc		hl
	ld		(_listPtr),hl

	ld		hl,_listCount
	inc		(hl)

	pop		de
	pop		hl
	ret


_listPtr:
	.word	_fnList

_listCount:
	.byte	0

_listRow:
	.byte	0

_fnList:
	.fill	23*2


_textnum:
	.byte	0

_titletextlist:
	.word	_t1,_t2,_t3

			;--------========--------========
_t1	.asc	"  fire/space/nl to run program  "
_t2	.asc	" up/7, down/6 to select program "
_t3	.asc	" press reset to return to menu  "


_menulistfn:
    .asc    "/menu.txt;3276","8"+$80

.endmodule
