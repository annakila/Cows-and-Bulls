.text
.globl main

main:   

	li $v0,31 
	la $t0,beep 
	lw $a0,0($t0) 
	addi $t2,$a0,12 
	la $t1,duration 
	lbu $a1,0($t1) 
	la $t3,volume 
	lbu $a3,0($t3) 
	move $t4,$a0 
	move $t5,$a1 
	move $t6,$a3 
	syscall 



.data

beep: .byte 72
duration: .byte 100
volume: .byte 127
