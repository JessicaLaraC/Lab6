.section .text
.align	1
.syntax unified
.thumb
.global check_speed

check_speed:
  
    cmp     r8, #1          @ if (speed == 1)
    bne     L2
    mov     r3, #1000       @ return 1000;
    b       L3
L2:
    cmp     r8, #2          @ else if (speed == 2){
    bne     L4
    mov     r3, #500        @ return 500;
    b       L3
L4:
    cmp     r8, #3          @ else if (speed == 3)
    bne     L5
    movs    r3, #250        @ return 250;
    b       L3
L5:
    cmp     r8, #4          @ else if (speed == 4)
    bne     L6
    movs    r3, #125        @ return 125;
    b       L3
L6:
    movs    r8, #1          @ speed = 1;
    mov     r3, #1000       @ return 1000;
L3:
    mov     r0, r3
    bx      lr


.size   check_speed, .-check_speed


