;DEFINES
.equ STACK_SIZE 64

.equ RED_SCALE 2
.equ AMBAR_SCALE 1
.equ GREEN_SCALE 0

.equ WARNING_TIME, 300
.equ CRITICAL_TIME, 150


.section startup

ldr sp, stack_top_addr ; iniciar o stack
mov r0, pc             ; bl indireto 
add lr, r0, #4         ; + 4 para chegar ao b .
ldr pc, main_addr      ; porque a main nao esta nesta secção
b .
stack_top_addr:
.word stack_top
main_addr:
.word main


.text

color_scale:
; r0 = t, r1 = c, r2 = CRITICAL_TIME, r3 = WARNING_TIME

    mov r1, #GREEN_SCALE & 0xff
    movt r1, #(GREEN_SCALE >> 8) & 0xff

    mov r2, #CRITICAL_TIME & 0xff
    movt r2, #(CRITICAL_TIME >> 8) & 0xff

    mov r3, #WARNING_TIME & 0xff
    movt r3, #(WARNING_TIME >> 8) & 0xff

if:
    cmp r0, r2
    blo if_end

    cmp r3,r0
    blo if_end

    mov r1, AMBAR_SCALE    ; ação que está dentro do if

if_end:

else_if:

    cmp r0, r2
    bhs else_if_end

    mov r1, RED_SCALE

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

    mov r4, #0
for:
    cmp r4, r5
    bhs for_end

;array_c[color_scale(array_t[i])]++
    ldr r0, [r6, r4]    ; r0 <- array_t[i]
    bl color_scale      ; entra na função com argumento em r0 e devolve em r0  

    ldrb r1, [r7, r0]   ; r1 <- array_c[color_scale(array_t[i])]
    add r1, r1, #1      ; array_c[color_scale(array_t[i])]++
    strb r1, [r7, r0]   ; guarda na memória o valor incrementado

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
    push lr

    mov r0, #0
    mov r1, #3  ; para o compare

while_cond:
    cmp r0,r1   ; comparação unsigned
    bhs while_end

    ;CONFIRMAR TUDO ABAIXO DISTO!!!
    ; color_histograms[i++] = 0 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    lsl r0, r0, #1  ;porquê lsl? não precisamos de andar de 2 em 2
    ldr r1, color_histograms_addr
    ldr r2, [r1, r0]    ; r2 <- color_histograms[i]
    add r2, r2, #1
    str r2, [r1, r0]
    mov r2, #0

while_end:
    ; b test_color_scale
    bl test_color_scale

    mov r0,#0   


.data

;defines
;PUXAR OS ADDR PARA O .TEXT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

;array
times_addr:
    .word   times

times:
    .word   65535, 500, 301, 300, 299, 151, 150, 149, 1, 0


color_histograms_addr:
    .word color_histograms


color_histograms:
    .space 3


.stack
.space STACK_SIZE
stack_top:
