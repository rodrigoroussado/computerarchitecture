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
;funções


;main
main:


.data
;defines, etc...


.stack
stack_top:
    .space 10


