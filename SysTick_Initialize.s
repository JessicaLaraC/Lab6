.include "ivt.s"
.include "gpio_map.inc"
.include "rcc_map.inc"
.include "scb_map.inc"
.include "systick_map.inc"
.section .text
.align	1
.syntax unified
.thumb
.global SysTick_Initialize

SysTick_Initialize:
        #  SysTick_CTRL para habilitar IRQ SysTick y el temporizador de Systick 
        ldr     r0, =SYSTICK_BASE
        #habilitar SysTick IQR y contador de SysTick SELECIONAR EL RELOJ EXTERNO
        mov     r1, #0 
        str     r1, [r0, STK_CTRL_OFFSET]
        # Ciclo de reloj entre dos interrupciones 
        ldr     r2, =1000                       @Intervalo de interrupciones
        str     r2, [r0, STK_LOAD_OFFSET] 
        # Borrar el registro actual del SysTick
        mov     r1, #0 
        str     r1, [r0, STK_VAL_OFFSET]
        
        #Se establece la prioridad de interrupciones 
        ldr     r2, =SCB_BASE
        add     r2, r2, SCB_SHPR3_OFFSET
        mov     r3, 0x20
        strb    r3, [r2, #11] 
        # habilitar el temporizador de SysTick y la interrupcion d
        ldr     r1, [r0, STK_CTRL_OFFSET]
        orr     r1, r1, #3  @ Enable SysTick counter & interrupt
        str     r1, [r0, STK_CTRL_OFFSET] 
        bx      lr        

.size   SysTick_Initialize, .-SysTick_Initialize

