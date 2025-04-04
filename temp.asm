# Blackjack Game in MIPS32 Assembly
# Features: Menu (Hit, Stand, Run Again, View Hint), Deck without replacement, Probability hint
# Author: ChatGPT

.data
prompt:      .asciiz "\nChoose an option:\n1. Hit\n2. Stand\n3. Run Again\n4. View Hint\n> "
winMsg:      .asciiz "\nYou win!\n"
loseMsg:     .asciiz "\nYou lose.\n"
drawMsg:     .asciiz "\nDraw.\n"
hintMsg:     .asciiz "\nCalculating Hint...\n"
scoreMsg:    .asciiz "\nYour total: "
cpuScoreMsg: .asciiz "\nDealer total: "
newline:     .asciiz "\n"

# Deck (4 suits x 13 cards)
deck:        .word 1,2,3,4,5,6,7,8,9,10,10,10,10
             .word 1,2,3,4,5,6,7,8,9,10,10,10,10
             .word 1,2,3,4,5,6,7,8,9,10,10,10,10
             .word 1,2,3,4,5,6,7,8,9,10,10,10,10
deckSize:    .word 52

# Player and CPU hands
playerHand:  .space 52
cpuHand:     .space 52
playerCount: .word 0
cpuCount:    .word 0

.text
.globl main

main:
    jal initGame
main_menu:
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    move $t0, $v0

    beq $t0, 1, do_hit
    beq $t0, 2, do_stand
    beq $t0, 3, restart
    beq $t0, 4, view_hint
    j main_menu

restart:
    jal initGame
    j main_menu

initGame:
    # Reset deck size
    li $t0, 52
    la $t1, deckSize
    sw $t0, 0($t1)

    # Reset hand counts
    li $t0, 0
    sw $t0, playerCount
    sw $t0, cpuCount

    # Deal 2 cards to player and CPU
    la $a0, playerHand
    la $a1, playerCount
    jal drawCard
    jal drawCard

    la $a0, cpuHand
    la $a1, cpuCount
    jal drawCard
    jal drawCard

    jr $ra

do_hit:
    la $a0, playerHand
    la $a1, playerCount
    jal drawCard

    jal print_player_score
    jal check_player_bust

    j main_menu

do_stand:
    # Dealer draws until 17+
    la $a0, cpuHand
    la $a1, cpuCount
cpu_loop:
    jal calc_total
    move $t1, $v0
    bge $t1, 17, cpu_done
    jal drawCard
    j cpu_loop
cpu_done:

    jal print_player_score
    jal print_cpu_score
    jal determine_winner
    j main_menu

view_hint:
    li $v0, 4
    la $a0, hintMsg
    syscall

    # Load current total
    la $a0, playerHand
    la $a1, playerCount
    jal calc_total
    move $t0, $v0

    # Load deck and deckSize
    la $t1, deck
    lw $t2, deckSize

    li $t3, 0    # safe
    li $t4, 0    # bust
    li $t5, 0    # index

hint_loop:
    beq $t5, $t2, hint_done
    sll $t6, $t5, 2
    add $t7, $t1, $t6
    lw $t8, 0($t7)
    add $t9, $t0, $t8
    ble $t9, 21, safe
    addi $t4, $t4, 1
    j hint_continue
safe:
    addi $t3, $t3, 1
hint_continue:
    addi $t5, $t5, 1
    j hint_loop

hint_done:
    # Print percentages
    li $v0, 1
    move $a0, $t3
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    li $v0, 1
    move $a0, $t4
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    j main_menu

check_player_bust:
    la $a0, playerHand
    la $a1, playerCount
    jal calc_total
    li $t0, 21
    ble $v0, $t0, continue
    li $v0, 4
    la $a0, loseMsg
    syscall
    j restart
continue:
    jr $ra

determine_winner:
    la $a0, playerHand
    la $a1, playerCount
    jal calc_total
    move $t0, $v0

    la $a0, cpuHand
    la $a1, cpuCount
    jal calc_total
    move $t1, $v0

    bgt $t0, 21, player_bust
    bgt $t1, 21, cpu_bust

    bgt $t0, $t1, player_wins
    blt $t0, $t1, cpu_wins
    li $v0, 4
    la $a0, drawMsg
    syscall
    jr $ra

player_bust:
    li $v0, 4
    la $a0, loseMsg
    syscall
    jr $ra

cpu_bust:
    li $v0, 4
    la $a0, winMsg
    syscall
    jr $ra

player_wins:
    li $v0, 4
    la $a0, winMsg
    syscall
    jr $ra

cpu_wins:
    li $v0, 4
    la $a0, loseMsg
    syscall
    jr $ra

print_player_score:
    la $a0, playerHand
    la $a1, playerCount
    jal calc_total
    li $v0, 4
    la $a0, scoreMsg
    syscall
    li $v0, 1
    move $a0, $v0
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    jr $ra

print_cpu_score:
    la $a0, cpuHand
    la $a1, cpuCount
    jal calc_total
    li $v0, 4
    la $a0, cpuScoreMsg
    syscall
    li $v0, 1
    move $a0, $v0
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    jr $ra

# =============== drawCard ===============
# $a0: hand array, $a1: hand count
# modifies: $v0 = drawn card


.drawCard:
    la $t0, deckSize
    lw $t1, 0($t0)
    li $v0, 42
    li $a1, 52
    syscall
    move $t2, $v0
    rem $t2, $t2, $t1

    sll $t3, $t2, 2
    la $t4, deck
    add $t5, $t4, $t3
    lw $t6, 0($t5)
    move $v0, $t6

    # Swap with last unused card
    addi $t1, $t1, -1
    sll $t7, $t1, 2
    add $t8, $t4, $t7
    lw $t9, 0($t8)
    sw $t9, 0($t5)
    sw $t6, 0($t8)

    sw $t1, deckSize

    # Add to hand
    lw $t0, 0($a1)
    sll $t1, $t0, 2
    add $t2, $a0, $t1
    sw $t6, 0($t2)
    addi $t0, $t0, 1
    sw $t0, 0($a1)
    jr $ra

# =============== calc_total ===============
# $a0: hand array, $a1: count
# returns total in $v0

.calc_total:
    lw $t0, 0($a1)
    li $t1, 0  # sum
    li $t2, 0  # ace count
    li $t3, 0  # index
loop_sum:
    beq $t3, $t0, done_sum
    sll $t4, $t3, 2
    add $t5, $a0, $t4
    lw $t6, 0($t5)
    beq $t6, 1, count_ace
    add $t1, $t1, $t6
    j cont_sum
count_ace:
    addi $t2, $t2, 1
    addi $t1, $t1, 11
cont_sum:
    addi $t3, $t3, 1
    j loop_sum
done_sum:
    # Adjust for Aces if bust
adjust_ace:
    ble $t1, 21, set_sum
    beq $t2, 0, set_sum
    addi $t1, $t1, -10
    addi $t2, $t2, -1
    j adjust_ace
set_sum:
    move $v0, $t1
    jr $ra
