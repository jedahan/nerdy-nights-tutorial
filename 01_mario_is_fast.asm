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

SETPALETTE:
  LDA $2002    ; read PPU status to reset the high/low latch to high
  LDA #$3F
  STA $2006    ; write the high byte of $3F10 address
  LDA #$00
  STA $2006    ; write the low byte of $3F10 address
PaletteData:
  .db $0F,$31,$32,$33,$0F,$35,$36,$37,$0F,$39,$3A,$3B,$0F,$3D,$3E,$0F  ;background palette data
  .db $0F,$1C,$15,$14,$0F,$02,$38,$3C,$0F,$1C,$15,$14,$0F,$02,$38,$3C  ;sprite palette data
  LDX #$00                ; start out at 0
LoadPalettesLoop:
  LDA PaletteData, x      ; load data from address (PaletteData + the value in x)
                          ; 1st time through loop it will load PaletteData+0
                          ; 2nd time through loop it will load PaletteData+1
                          ; 3rd time through loop it will load PaletteData+2
                          ; etc
  STA $2007               ; write to PPU
  INX                     ; X = X + 1
  CPX #$20                ; Compare X to hex $20, decimal 32
  BNE LoadPalettesLoop    ; Branch to LoadPalettesLoop if compare was Not Equal to zero
                          ; if compare was equal to 32, keep going down
GetReadyToWriteSprites:
  LDA #$00
  STA $2003  ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014  ; set the high byte (02) of the RAM address, start the transfer
WriteDatSprite:
  LDA #$80
  STA $0200        ;put sprite 0 in center ($80) of screen vertically
  STA $0203        ;put sprite 0 in center ($80) of screen horizontally
  LDA #$00
  STA $0201        ;tile number = 0
  STA $0202        ;color palette = 0, no flipping
  ;STA #%00100010

  LDA #%10000000   ; enable NMI, sprites from Pattern Table 0
  STA $2000

  LDA #%00010000   ; no intensify (black background), enable sprites
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