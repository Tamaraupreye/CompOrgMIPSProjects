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
jal print
addi $t8, $t8, 1
beq	$t8, $t9, exit

addu $t0, $t0, $t1
addu $t1, $t0, $t1
j fibo

exit:
li $v0, 10
syscall

print:
li $v0, 1
move $a0, $t0
syscall

li $v0, 4
la $a0, delim
syscall

li $v0, 1
move $a0, $t1
syscall

li $v0, 4
la $a0, delim
syscall

j $ra
