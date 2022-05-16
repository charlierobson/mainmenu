;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;
.module INSTRUCTIONS

_run:
	ld		hl,_text
	ld		de,dfile+1
	ld		bc,_textend-_text
	ldir

_loop:
	call	framesync

	ld		a,(INPUT._go1)
	and		3
	cp		1
	ret		z

	ld		a,(INPUT._go2)
	and		3
	cp		1
	ret		z

	jr		_loop


_text:
			;--------========--------========
	.asc	"instructions screen. press fire."
_textend:

.endmodule
