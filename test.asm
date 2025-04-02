.data

prompt1: .asciiz "Enter Integer: "

prompt2: .asciiz "Enter Bit Position(0-31): "

output: .asciiz "\nOutput: "

.text

.globl main

main:

	li $v0, 4

	la $a0, prompt1

	syscall

	li $v0, 5

	syscall

	move $s0, $v0 #store integer input

getBitPosition:

	li $v0, 4

	la $a0, prompt2

	syscall

	li $v0, 5

	syscall

	move $s1, $v0 #store bit position

	bgt $s1, 31, getBitPosition

	

	srlv $t0, $s0, $s1  # Shift right by $s1 bits

    	andi $t0, $t0, 1   # Isolate the least significant bit

    	#this is because a bitwise and with ..0000001 will get the lsb

    	li $v0, 4

	la $a0, output

	syscall

	li $v0, 1

	move $a0, $t0

	syscall

  	li $v0, 10 # Exit program 

	syscall

