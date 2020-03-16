;)              _
;)  ___ ___ _ _|_|___ ___
;) |  _| .'|_'_| |_ -|_ -|
;) |_| |__,|_,_|_|___|___|
;)    raxiss (c) 2019,2020

;====================================
; Resources helper
;------------------------------------

_pics
    .word _pic_0
    .word _pic_1
    .word _pic_2
    .word _pic_3
    .word _pic_4
    .word _pic_5
    .word _pic_6
    .word _pic_7
    .word _pic_8

; input: A   = picture number
; output X:A = picture offset, Y - destroyed
_get_pic
    asl
    tay
    lda  _pics,y
    ldx  _pics+1,y
    rts
