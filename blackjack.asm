#Blackjack simulator test
#fucking difficult raah
#github test

.data
prompt:         .asciiz "\nChoose an option:\n1. Hit\n2. Stand\n3. Run Again\n> "
winMsg:         .asciiz "\nYou win!\n"
loseMsg:        .asciiz "\nYou lose.\n"
cardLabel:      .asciiz "Card: "
suits:          .asciiz "SHCD"         # Spade, Heart, Club, Diamond
deck:           .asciiz "A23456789TJQK" #T is 10
newline:        .asciiz "\n"

deckSize:       .word 52
playerHand:     .space 52
dealerHand:        .space 52
playerCount:    .word 0
dealerCount:       .word 0

.text
.globl main

main:

    li   $v0, 42  #randomint
    li   $a1, 52  #Draws Between 1-52
    syscall
    move $t0, $a0  #move number to $t0
    
    #rank determiner
    li   $t1, 13            #there are 13 ranks
    divu $t0, $t1
    mfhi $t2  #HI is the location where the REMAINDER is stored after divu/ div

    #suit determiner
    mflo $t3   #LO is the location where the QUOTIENT is stored after divu/ div

    la   $t4, deck  #load deck
    add  $t4, $t4, $t2 #add rank# to deck to determine card
    lbu  $t5, 0($t4) #loads it to $t5

    #load suits
    la   $t6, suits 
    add  $t6, $t6, $t3
    lbu  $t7, 0($t6) #loads it to $t7

    #label print
    li   $v0, 4
    la   $a0, cardLabel
    syscall

    #print rank
    li   $v0, 11
    move $a0, $t5
    syscall

    #print suit
    li   $v0, 11
    move $a0, $t7
    syscall

    #newline
    li   $v0, 4
    la   $a0, newline
    syscall

    #exit
    li   $v0, 10
    syscall

