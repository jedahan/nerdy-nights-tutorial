; iNES assembly directives

  .inesprg 1   ; 1x 16KB bank of PRG code
  .ineschr 1   ; 1x 8KB bank of CHR data
  .inesmap 0   ; mapper 0 = NROM, no bank swapping
  .inesmir 1   ; background mirroring (ignore for now)

; NESASM banking (NESASM arranges everything as 8KB blocks of code)

  .bank 0 ; first PRG bank
  .org $C000
; some code here

  .bank 1 ; second PRG bank
  .org $E000
; more code here

  .bank 2 ; graphics bank
  .org $0000
  .incbin "mario.chr"
; graphics here
