.data
answer: .asciiz "The average of all even numbers between 1 and 100 that are multiples of 3 is "
.text
main:

li $t0, 100
li $t1, 6
li $s1, 0  # sum
li $s2, 0  # num
li $s3, 0  # final answer

loop:
beq $t0, $0, done
div $t0, $t1
mfhi $t2  # need the remainder
addi $t0, $t0, -1
bne $t2, $0, loop
add $s1, $s1, $t0
addi $s1, $s1, 1
addi $s2, $s2, 1
j loop

done:
div $s1, $s2
mflo $s3

li $v0, 4
la $a0, answer
syscall

li $v0, 1
addi $a0, $s3, 0
syscall

exit:  # subroutine to exit
li $v0, 10
syscall