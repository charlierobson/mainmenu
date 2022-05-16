;-------------------------------------------------------------------------------
;
.module	TXT

; transcode ascii text at hl
;
_transcodeAtoZ:
	ld		de,_convtable
	jr		{+}

-:	ld		a,(de)
	ld		(hl),a
	inc		hl

+:	ld		e,(hl)
	bit		7,e
	jr		z,{-}
	ret


; ascii -> zeddy conversion table
	.align 256
_convtable:
   .byte $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $76, $0F, $0f, $76, $0F, $0F
   .byte $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $77, $0F, $0F, $0F, $0F
   .byte $00, $0F, $0B, $0F, $0D, $0F, $0F, $0F, $10, $11, $17, $15, $1A, $16, $1B, $18
   .byte $1C, $1D, $1E, $1F, $20, $21, $22, $23, $24, $25, $0E, $19, $13, $14, $12, $0F
   .byte $0F, $26, $27, $28, $29, $2A, $2B, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $34
   .byte $35, $36, $37, $38, $39, $3A, $3B, $3C, $3D, $3E, $3F, $0F, $18, $0F, $0F, $0F
   .byte $0F, $26, $27, $28, $29, $2A, $2B, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $34
   .byte $35, $36, $37, $38, $39, $3A, $3B, $3C, $3D, $3E, $3F, $0F, $0F, $0F, $0F, $0F
   