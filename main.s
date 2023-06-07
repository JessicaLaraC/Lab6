.thumb              @ Assembles using thumb mode
.cpu cortex-m3      @ Generates Cortex-M3 instructions
.syntax unified

.include "ivt.s"
.include "gpio_map.inc"
.include "rcc_map.inc"
.include "afio_map.inc"
.include "exti_map.inc"
.include "nvic_reg_map.inc"
.extern delay
.extern SysTick_Handler
.extern check_speed
.extern SysTick_Initialize
.extern output
.section .text
.align	1
.syntax unified
.thumb
.global __main
__main:

        # Prologue
        push    {r7, lr}
        sub     sp, #16
        add     r7, sp, #0  
setup: @ Starts peripheral settings
        # enables clock in Port A
        ldr     r0, =RCC_BASE
        mov     r1, #4
        str     r1, [r0, RCC_APB2ENR_OFFSET]
        # configures pin 0 to 7 in GPIOA_CRL
        ldr     r0, =GPIOA_BASE                 @ moves base address of GPIOA registers
        ldr     r1, =0x33333333                 @ PA[4:0] works as output, PA[6:5] as inputs
        str     r1, [r0, GPIOx_CRL_OFFSET]      @ M[GPIOA_CRL] gets 0x48833333
        # disables pin 8 to 15 in GPIOA_CRL
        # configures pin 8 to 15 in GPIOA_CRH   @ General-purpose I/O config. register port(8-F)
        ldr     r1, =0x44444883
        str     r1, [r0, GPIOx_CRH_OFFSET]      @ M[GPIOA_CRL] gets 0x44444883

        # Configure EXI11 and EXI10
        ldr r0, =AFIO_BASE                      @ Loads AFIO base
        eor r1, r1 @ Clears r1
        str r1, [r0, AFIO_EXTICR3_OFFSET]       @Selects PA 11 and 10 as inputs

        ldr r0, =EXTI_BASE @Loads EXIT base
        ldr r1, =0x00000C00
        str r1, [r0, EXTI_RTST_OFFSET]          @ Rising Trigger event lines PA 11 and 10
        str r1, [r0, EXTI_IMR_OFFSET]           @ Unmask the interrupt request from 11 and 10
        eor r1, r1
        str r1, [r0, EXTI_FTST_OFFSET]          @ Unmask the interrupt request from 11 and 10
        # Configures NVIC to attends EXIT Request
        ldr r0, =NVIC_BASE
        ldr r1, =0x00000100
        str r1, [r0, NVIC_ISER1_OFFSET]         @ Enables EXIT [15:10]

        # SysTick Configuration
        bl  SysTick_Initialize

        movs    r5, #0                          @counter 
                               
        movs    r8, #1                          @speed
        movs    r9, #0                          @mode 
loop:          
        bl      check_speed
        mov     r6, r0
        mov	r3, r9
        cmp     r3, #0
        bne     L10

        #counter++
        
        adds    r5, r5, #1
        
        b       L11
L10:
        #counter --
        
        subs    r5, r5, #1
       
L11:
        #output
        mov r0, r5
        
        bl      output
        
        mov     r0, r6
        bl      delay   
        b       loop   
