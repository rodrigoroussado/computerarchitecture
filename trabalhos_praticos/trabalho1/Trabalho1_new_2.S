.section startup

ldr sp, stack_top_addr
mov r0, pc
add lr, r0, #4
ldr pc, main_addr
b .
stack_top_addr:
.word stack_top
main_addr:
.word main

.text

color_scale:
; r0 = t, r1 = c, r2 = CRITICAL_TIME, r3 = WARNING_TIME

    ldr r1, green_scale_addr
    ldr r2, critical_time_addr
    ldr r3, warning_time_addr

if:
    cmp r0, r2
    blo if_end

    cmp r3,r0
    blo if_end

    ldr r1, ambar_scale_addr    ; ação que está dentro do if

if_end:

else_if:

    cmp r0, r2
    bhs else_if_end

    ldr r1, red_scale_addr

else_if_end:

    mov r0, r1  ; retorna o valor de c em r0
    mov pc,lr   ; retornar ao ponto do código onde a rotina foi invocada


test_color_scale:
;r4 - i, r5 - array_t_size, r6 - array_t, r7 - array_c
    push lr
    push r4
    push r5
    push r6
    push r7

for:
    mov r4, #0
    cmp r4, r5
    bhs for_end
;array_c[color_scale(array_t[i])]++
    lsl r2, r4, #1
    ldr r0, [r6, r2]
    bl color_scale
    ldr r7, [r0, r2]
    add r7, r7, #1 

for_cond:
    add r4, r4, #1 ; i++
    b for
for_end:
    pop r7
    pop r6
    pop r5
    pop r4
    pop pc

main:
; r0 = i
    mov r0, #0
    mov r1, #3  ; para o compare

while_cond:
    cmp r0,r1   ; comparação unsigned
    bhs while_end

    ; color_histograms[i++] = 0

while_end:
    ; b test_color_scale
    bl test_color_scale

    mov r0,#0   

.data

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


.stack
stack_top:
    .space 10
