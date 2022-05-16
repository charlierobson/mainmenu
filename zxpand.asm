;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;
.module ZXPAND

; set memory map to 16-48k
;
_memhi:
   ld    a,$b3
   jr    {+}

; set memory map to 8-40k
;
_memlo:
   ld    a,$b2

+: ld    bc,$e007             ; set RAM page window on zxpand
   out   (c),a
   ret



; de points to high-bit-terminated directory name string
; executes a directory command, eg: create, change to, open
;
_dircmd:
   call  api_sendstring

   ld    bc,$6007             ; open dir
   ld    a,0
   out   (c),a
   jp    api_responder




_load:
   xor   a
   jp   api_fileop
