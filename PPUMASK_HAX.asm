; iNES assembly directives

  .inesprg 1   ; 1x 16KB bank of PRG code
  .ineschr 1   ; 1x 8KB bank of CHR data
  .inesmap 0   ; mapper 0 = NROM, no bank swapping
  .inesmir 1   ; background mirroring (ignore for now)

; NESASM banks (NESASM arranges everything as 8KB blocks of code)

; PROGRAM BANKS
  .bank 0 ; first PRG bank
  .org $C000
RESET:
  SEI        ; disable IRQs
  CLD        ; disable decimal mode
  LDA #%01000000   ;intensify greens
  STA $2001
Forever:
  LDA #$00
  STA $2001
  LDA #%00100000   ;intensify reds
  STA $2001
  LDA #$1E
  STA $2001

  LDA #$00
  STA $2001
  LDA #%01000000   ;intensify greens
  STA $2001
  LDA #$1E
  STA $2001

  LDA #$00
  STA $2001
  LDA #%10000000   ;intensify blues
  STA $2001
  LDA #$1E
  STA $2001

  JMP Forever     ;infinite loop
NMI:
  RTI

  .bank 1 ; second PRG bank
  .org $FFFA     ;first of the three vectors starts here
  .dw NMI        ;when an NMI happens (once per frame if enabled) JMP to NMI
  .dw RESET      ;when the processor first turns on or is reset, JMP to RESET
  .dw 0          ;external interrupt IRQ is not used in this tutorial

; GRAPHICS BANKS
  .bank 2 ; graphics bank
  .org $0000
  .incbin "mario.chr"
; graphics here