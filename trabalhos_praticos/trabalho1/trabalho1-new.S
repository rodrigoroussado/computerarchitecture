.section .startup
b _start
b .

_start:
    ; secção start
    ; VER COMO IR PARA A MAIN SEM A LIMITAÇÃO DE SALTO - 

.data

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
    mov r0,#0   ; ISTO É O RETURN DO MAIN?????
