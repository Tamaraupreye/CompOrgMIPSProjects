.data
msg: .asciiz "The first 50 fibonacci numbers are \n"
delim: .asciiz "\n"
.align 2
num: .space 48
.text
main:
li $v0, 4
la $a0, msg
syscall

li $t0, 0
addi $t1, $0, 1
li $t8, 0
li $t9, 25

fibo:
move $t3, $t0
jal print_num
move $t3, $t1
jal print_num
addi $t8, $t8, 1
beq	$t8, $t9, exit

addu $t0, $t0, $t1
addu $t1, $t0, $t1
j fibo

exit:
li $v0, 10
syscall

print_num:
la $s0, num
addi $s1, $0, 10
addi $t4, $0, 0
loop:
divu $t3, $s1
mfhi $t2
mflo $t3
sw $t2, 0($s0)
addi $s0, $s0, 4
addi $t4, $t4, 1
bne $t3, $0, loop

print_loop:
addi $s0, $s0, -4
li $v0, 1
lw $a0, 0($s0)
syscall
addi $t4, $t4, -1
bne $t4, $0, print_loop

li $v0, 4
la $a0, delim
syscall

j $ra
