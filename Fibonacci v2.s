.data
msg: .asciiz "The first 50 fibonacci numbers are \n"
delim: .asciiz "\n"
.align 2
x: .space 96
y: .space 96
.text
main:
# print out initial message
li $v0, 4
la $a0, msg
syscall

la $s0, x  # $s0 is first number
la $s1, y  # $s0 is second number
li $t0, 0  # $t0 is number of digits of first number
li $t1, 0  # $t1 is number of digits of second number
li $s2, 10  # we'll divide by 10 quite a few times
li $t6, 0  # carry for addition

# make the first number 0
li $t4, 0
sw $t4, 0($s0)
addi $s0, $s0, 4
addi $t0, $t0, 1

# make the second number 1
li $t4, 1
sw $t4, 0($s1)
addi $s1, $s1, 4
addi $t1, $t1, 1

li $t8, 0  # count
li $t9, 50  # print 50 numbers

# iteratively find next fibonacci numbers
fibo:
move $s3, $s0
move $t3, $t0
jal print
move $s3, $s1
move $t3, $t1
jal print
addi $t8, $t8, 2
beq	$t8, $t9, exit

# add the numbers to get the next numbers
la $s0, x
la $s1, y

move $t5, $t0
move $t7, $t1
li $t0, 0

my_add:
lw $t2, 0($s0)
lw $t3, 0($s1)
add $t4, $t2, $t3
add $t4, $t4, $t6
div $t4, $s2
mfhi $t4
mflo $t6
sw $t4, 0($s0)
addi $s0, $s0, 4
addi $t5, $t5, -1
addi $s1, $s1, 4
addi $t7, $t7, -1
addi $t0, $t0, 1
bgt $t5, $0, my_add
bgt $t7, $0, my_add
bgt $t6, $0, my_add

la $s5, x
la $s6, y

move $t5, $t0
move $t7, $t1
li $t1, 0

my_add_2:
lw $t2, 0($s5)
lw $t3, 0($s6)
add $t4, $t2, $t3
add $t4, $t4, $t6
div $t4, $s2
mfhi $t4
mflo $t6
sw $t4, 0($s6)
addi $s5, $s5, 4
addi $t5, $t5, -1
addi $s6, $s6, 4
addi $t7, $t7, -1
addi $t1, $t1, 1
bgt $t5, $0, my_add_2
bgt $t7, $0, my_add_2
bgt $t6, $0, my_add_2

move $s1, $s6

j fibo

exit:
li $v0, 10
syscall

print:
addi $s3, $s3, -4
li $v0, 1
lw $a0, 0($s3)
syscall
addi $t3, $t3, -1
bne $t3, $0, print

li $v0, 4
la $a0, delim
syscall

j $ra
