.cpu cortex-m3      @ Generates Cortex-M3 instructions
.section .text
.align	1
.syntax unified
.thumb
.global SysTick_Handler
#NVIC aplica automaticamente ocho registros r0-r3,r12, lr, psr y pc
SysTick_Handler: 
        sub     r10, #1         @DECREMENTAR TIME DELAY
        bx      lr

.size   SysTick_Handler, .-SysTick_Handler
