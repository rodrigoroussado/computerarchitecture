; RESPOSTA ÀS ALÍNEAS TEÓRICAS ( 1b, 3b e 4a ):

; 1.b) Para a implementação proposta, os símbolos são definidos com a diretiva ".equ" que não apresenta requisitos de memória, ou seja,
; estes são de 0 bytes. Por outro lado, se os símbolos tivessem sido definidos na diretiva ".data", poderiam ocupar espaço na memória,
; dependendo este de como fossem indicados (byte ou word).

; 3.b) 

; 4.a) A rotina test_color_scale não é uma rotina folha, ou seja, invoca outras rotinas (neste caso, a rotina color_scale). Devido às
; convenções de programação para os registos, uma rotina não precisa de preservar os valores de R0..R3. Assim, se usássemos R3 para
; armazenar o valor da variável local i, quando fosse invocada a rotina folha color_scale, este valor poderia ser modificado, o que 
; causaria problemas quando voltássemos à rotina test_color_scale. Assim, ao usar o registo R4 para este fim, garantimos que o valor 
; não é perdido (visto fazer parte dos registos cujos valores têm de ser mantidos intactos).

;---------------------------------------------


; defines
.equ STACK_SIZE, 64

.equ RED_SCALE, 2
.equ AMBAR_SCALE, 1
.equ GREEN_SCALE, 0

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

    ; carregar as constantes para registos de forma a poder fazer os compares
    mov r1, #GREEN_SCALE & 0xff
    movt r1, #(GREEN_SCALE >> 8) & 0xff

    mov r2, #CRITICAL_TIME & 0xff
    movt r2, #(CRITICAL_TIME >> 8) & 0xff

    mov r3, #WARNING_TIME & 0xff
    movt r3, #(WARNING_TIME >> 8) & 0xff

if:
    ; if(t >= CRITICAL_TIME && t <= WARNING_TIME)
    cmp r0, r2
    blo if_end

    cmp r3,r0
    blo if_end

    mov r1, #AMBAR_SCALE    ; ação que é executada no if

if_end:

else_if:

    ; else if(t < CRITICAL_TIME)
    cmp r0, r2
    bhs else_if_end

    mov r1, #RED_SCALE      ; ação que é executada no else if

else_if_end:

    mov r0, r1  ; retorna o valor de c em r0 (return da rotina)
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
    
    cmp r4, r5  ; condição do for (i < array_t_size)
    bhs for_end

    ;array_c[color_scale(array_t[i])]++
    ldr r0, [r6, r4]    ; r0 <- array_t[i]
    bl color_scale      ; entra na função com argumento em r0 e devolve em r0  

    ldrb r1, [r7, r0]   ; r1 <- array_c[color_scale(array_t[i])]
    add r1, r1, #1      ; array_c[color_scale(array_t[i])]++
    strb r1, [r7, r0]   ; guarda na memória o valor incrementado

for_cond:
    add r4, r4, #2 ; i++ (de word em word, ou seja, de 2 em 2 posições de memória)
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

while_cond:

    ; verificar a condição do while (i < 3)
    mov r1, #3  ; para o compare
    cmp r0,r1   ; comparação unsigned
    bhs while_end

    ; color_histograms[i++] = 0 (colocar os valores do histograma a 0)
    ldr r1, color_histograms_addr
    mov r2,#0
    str r2, [r1, r0]
    add r0, r0, #1

    b while_cond

while_end:

    push lr
    push r5
    push r6
    push r7

    ; passagem de parâmetros à rotina test_color_scale
    mov r5,#20  ; colocamos 20 em R5 porque existem 10 words no array (20 bytes)
    ldr r6,times_addr
    ldr r7,color_histograms_addr

    bl test_color_scale

    pop r7
    pop r6
    pop r5
    pop pc

    mov r0,#0       ; return 0 



times_addr:
    .word   times

color_histograms_addr:
    .word color_histograms


.data

times:
    .word   65535, 500, 301, 300, 299, 151, 150, 149, 1, 0

color_histograms:
    .space 3

.stack
.space STACK_SIZE
stack_top:
