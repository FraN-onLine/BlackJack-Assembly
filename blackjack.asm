#Blackjack simulator test
#fucking difficult raah

.data
prompt:      .asciiz "\nChoose an option:\n1. Hit\n2. Stand\n3. Run Again\n> "
winMsg:      .asciiz "\nYou win!\n"
loseMsg:     .asciiz "\nYou lose.\n"
drawMsg:     .asciiz "\nDraw.\n"
hintMsg:     .asciiz "\nCalculating Hint...\n"
scoreMsg:    .asciiz "\nYour total: "
cpuScoreMsg: .asciiz "\nDealer total: "
newline:     .asciiz "\n"
cardLabel:   .asciiz "Card: "

deck: .asciiz "A23456789IJQK" #I is 10
deckSize:    .word 52
playerHand:  .space 52
cpuHand:     .space 52
playerCount: .word 0
cpuCount:    .word 0

.text
.globl main

main:
    	li   $v0, 42 #randomint
    	li   $a1, 52  #Draws Between 1-52
    	syscall            
	
	move $v0, $t1
        rem $t1, 12 #52 % 12 = to loop between Ace to King
        divu $t2, $v0, 12 #result would be 0-3 mapped with Spade-Heart-Club-Diamonds
	la $t0, deck #loads the adress of the string
        add  $t0, $t0, $v0
	lbu $a0, 0($t0)
	li $v0, 11
	syscall

	#a $a0,  prompt
	#i $v0, 4
	#yscall
