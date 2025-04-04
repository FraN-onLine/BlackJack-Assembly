#Blackjack simulator

.data
prompt:      .asciiz "\nChoose an option:\n1. Hit\n2. Stand\n3. View Hint\n4.Run Again\n"
winMsg:      .asciiz "\nYou win!\n"
loseMsg:     .asciiz "\nYou lose.\n"
drawMsg:     .asciiz "\nDraw.\n"
scoreMsg:    .asciiz "\nYour total: "
cpuScoreMsg: .asciiz "\nDealer total: "
newline:     .asciiz "\n"
cardLabel:   .asciiz "Card: "
hearts:      .asciiz "\u2665"
diamonds:    .asciiz "\u2666"
clubs:       .asciiz "\u2663"
spades:      .asciiz "\u2660"

# Deck (4 suits x 13 cards) using values 1-52, mapped to value/suit later
fullDeck:    .word 1,2,3,4,5,6,7,8,9,10,11,12,13,
             14,15,16,17,18,19,20,21,22,23,24,25,26,
             27,28,29,30,31,32,33,34,35,36,37,38,39,
             40,41,42,43,44,45,46,47,48,49,50,51,52

deckSize:    .word 52
playerHand:  .space 52
cpuHand:     .space 52
playerCount: .word 0
cpuCount:    .word 0

.text
.globl main


main:
	la $a0, prompt
	li $v0, 4
	syscall
