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

  LDX #$00                 ; start at 0
LoadSpritesLoop:
  LDA SpriteData, x     ; load data from address (SpriteData + x)
  STA $0200, x          ; store into RAM address ($0200 + x)
  INX                   ; X = X + 1
  CPX #$10              ; Compare X to hex $10, decimal 16
  BNE LoadSpritesLoop   ; Branch to LoadSpritesLoop if compare was Not Equal to zero
                        ; if compare was equal to 16, continue down

Forever:
GetReadyToWriteSprites:
  LDA #$00
  STA $2003  ; set the low byte (00) of the RAM address
  LDA #$02
  STA $4014  ; set the high byte (02) of the RAM address, start the transfer
WriteAllSprites:
  LDA #%10000000   ; enable NMI, sprites from Pattern Table 0
  STA $2000

  LDA #%00010000   ; no intensify (black background), enable sprites
  STA $2001
LOOP:
  JMP Forever     ;infinite loop

NMI:
CheckForInput:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016       ; tell both the controllers to latch buttons

  LDA $4016     ; player 1 - A
  AND #%00000001
  BEQ ReadADone
ReadADone:
  LDA $4016     ; player 1 - B
  AND #%00000001
  BEQ ReadBDone
ReadBDone:
  LDA $4016     ; player 1 - Select
  AND #%00000001
  BEQ ReadSelectDone
ReadSelectDone:
  LDA $4016     ; player 1 - Start
  AND #%00000001
  BEQ ReadStartDone
ReadStartDone:
ReadUp:
  LDA $4016     ; player 1 - Up
  AND #%00000001
  BEQ ReadUpDone
  LDA $0200   ; load sprite X (horizontal) position
  SEC         ; make sure the carry flag is set
  SBC #$01    ; A = A - 1
  STA $0200   ; save sprite X (horizontal) position

  LDA $0204   ; load sprite X (horizontal) position
  SEC         ; make sure the carry flag is set
  SBC #$01    ; A = A - 1
  STA $0204   ; save sprite X (horizontal) position

  LDA $0208   ; load sprite X (horizontal) position
  SEC         ; make sure the carry flag is set
  SBC #$01    ; A = A - 1
  STA $0208   ; save sprite X (horizontal) position

  LDA $020C   ; load sprite X (horizontal) position 
  SEC         ; make sure the carry flag is set
  SBC #$01    ; A = A - 1
  STA $020C   ; save sprite X (horizontal) position

ReadUpDone:
ReadDown:
  LDA $4016     ; player 1 - Down
  AND #%00000001
  BEQ ReadDownDone
  LDA $0200   ; load sprite X (horizontal) position
  CLC         ; make sure the carry flag is clear
  ADC #$01    ; A = A + 1
  STA $0200   ; save sprite X (horizontal) position

  LDA $0204   ; load sprite X (horizontal) position
  CLC         ; make sure the carry flag is clear
  ADC #$01    ; A = A + 1
  STA $0204   ; save sprite X (horizontal) position

  LDA $0208   ; load sprite X (horizontal) position
  CLC         ; make sure the carry flag is clear
  ADC #$01    ; A = A + 1
  STA $0208   ; save sprite X (horizontal) position

  LDA $020C   ; load sprite X (horizontal) position 
  CLC         ; make sure the carry flag is clear
  ADC #$01    ; A = A + 1
  STA $020C   ; save sprite X (horizontal) position
ReadDownDone:
ReadLeft:
  LDA $4016     ; player 1 - Left
  AND #%00000001
  BEQ ReadLeftDone
  LDA $0203   ; load sprite X (horizontal) position
  SEC         ; make sure the carry flag is set
  SBC #$01    ; A = A - 1
  STA $0203   ; save sprite X (horizontal) position

  LDA $0207   ; load sprite X (horizontal) position
  SEC         ; make sure the carry flag is set
  SBC #$01    ; A = A - 1
  STA $0207   ; save sprite X (horizontal) position

  LDA $020B   ; load sprite X (horizontal) position
  SEC         ; make sure the carry flag is set
  SBC #$01    ; A = A - 1
  STA $020B   ; save sprite X (horizontal) position

  LDA $020F   ; load sprite X (horizontal) position 
  SEC         ; make sure the carry flag is set
  SBC #$01    ; A = A - 1
  STA $020F   ; save sprite X (horizontal) position
ReadLeftDone:
ReadRight:
  LDA $4016     ; player 1 - Right
  AND #%00000001
  BEQ ReadRightDone
  LDA $0203   ; load sprite X (horizontal) position
  CLC         ; make sure the carry flag is clear
  ADC #$01    ; A = A + 1
  STA $0203   ; save sprite X (horizontal) position

  LDA $0207   ; load sprite X (horizontal) position
  CLC         ; make sure the carry flag is clear
  ADC #$01    ; A = A + 1
  STA $0207   ; save sprite X (horizontal) position

  LDA $020B   ; load sprite X (horizontal) position
  CLC         ; make sure the carry flag is clear
  ADC #$01    ; A = A + 1
  STA $020B   ; save sprite X (horizontal) position

  LDA $020F   ; load sprite X (horizontal) position 
  CLC         ; make sure the carry flag is clear
  ADC #$01    ; A = A + 1
  STA $020F   ; save sprite X (horizontal) position
ReadRightDone:
  LDA $4017     ; player 2 - A
  AND #%00000001
  BEQ Read2ADone
Read2ADone:
  LDA $4017     ; player 2 - B
  AND #%00000001
  BEQ Read2BDone
Read2BDone:
  LDA $4017     ; player 2 - Select
  AND #%00000001
  BEQ Read2SelectDone
Read2SelectDone:
  LDA $4017     ; player 2 - Start
  AND #%00000001
  BEQ Read2StartDone
Read2StartDone:
  LDA $4017     ; player 2 - Up
  AND #%00000001
  BEQ Read2UpDone
Read2UpDone:
  LDA $4017     ; player 2 - Down
  AND #%00000001
  BEQ Read2DownDone
Read2DownDone:
  LDA $4017     ; player 2 - Left
  AND #%00000001
  BEQ Read2LeftDone
Read2LeftDone:
  LDA $4017     ; player 2 - Right
  AND #%00000001
  BEQ Read2RightDone
  LDA $0203   ; load sprite X (horizontal) position
  CLC         ; make sure the carry flag is clear
  ADC #$01    ; A = A + 1
  STA $0203   ; save sprite X (horizontal) position
Read2RightDone:
  RTI

  .bank 1        ;second PRG bank
  .org $E000
PaletteData:
  .db $0F,$31,$32,$33,$0F,$35,$36,$37,$0F,$39,$3A,$3B,$0F,$3D,$3E,$0F  ;background palette data
  .db $0F,$1C,$15,$14,$0F,$02,$38,$3C,$0F,$1C,$15,$14,$0F,$02,$38,$3C  ;sprite palette data
SpriteData:
     ;vert tile attr horiz
  .db $80, $32, $00, $80   ;sprite 0
  .db $80, $33, $00, $88   ;sprite 1
  .db $88, $34, $00, $80   ;sprite 2
  .db $88, $35, $00, $88   ;sprite 3

  .org $FFFA     ;first of the three vectors starts here
  .dw NMI        ;when an NMI happens (once per frame if enabled) JMP to NMI
  .dw RESET      ;when the processor first turns on or is reset, JMP to RESET
  .dw 0          ;external interrupt IRQ is not used in this tutorial

  .bank 2        ;graphics bank
  .org $0000
  .incbin "mario.chr"