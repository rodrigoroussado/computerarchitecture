;defines
red_scale_addr:
    .word   RED_SCALE

RED_SCALE:
    .byte  2

ambar_scale_addr:
    .word   AMBAR_SCALE
    
AMBAR_SCALE:
    .byte   1

green_scale_addr:
    .word   GREEN_SCALE

GREEN_SCALE:
    .byte  0

warning_time_addr:
    .word   WARNING_TIME
    
WARNING_TIME:
    .byte   300

critical_time_addr:
    .word   CRITICAL_TIME

CRITICAL_TIME:
    .byte   150

;array
times_addr:
    .word   times

times:
    .word   65535, 500, 301, 300, 299, 151, 150, 149, 1, 0


color_scale:
; r0 = t, r1 = c, r2 = CRITICAL_TIME, r3 = WARNING_TIME
    ldr r1, green_scale_addr
    ldr r2, critical_time_addr
    ldr r3, warning_time_addr
if:
    cmp r0, r2
    blo else_if
    cmp r0, r3
    ; como fazemos o <= WARNING_TIME
    ldr r1, ambar_scale_addr
else_if:
    cmp r0, r2
    bhs else_if_end
    ldr r1, red_scale_addr
else_if_end:
    mov r0, r1  ; retorna o valor de c em r0
    