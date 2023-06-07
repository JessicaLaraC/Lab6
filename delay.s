.section .text
.align	1
.syntax unified
.thumb
.global delay
#r0 es la entrada de TimeDelay
delay:
        mov     r10, r0          @Se hace una copia de TimeDelay
.loop:
        cmp     r10, #0        
        bne     .loop
        bx      lr

.size   delay, .-delay


