.data
first: .asciiz "First integer: "
second: .asciiz "Second integer: "
third: .asciiz "Third integer: "
answer: .asciiz "\n\nThe greatest prime common factor is "
newlines: .asciiz "\n\n"
.text
main:
li $v0, 4
la $a0, first
syscall  # print out prompt asking user for first integer

li $v0, 5
syscall  # read user input for first integer

addi $s0, $v0, 0  # store first integer in $s0

li $v0, 4
la $a0, second
syscall  # print out prompt asking user for second integer

li $v0, 5
syscall  # read user input for second integer

addi $s1, $v0, 0  # store second integer in $s1

li $v0, 4
la $a0, third
syscall  # print out prompt asking user for third integer

li $v0, 5
syscall  # read user input for third integer

addi $s2, $v0, 0  # store third integer in $s2

li $s3, 1  # register to store greatest common prime factor
li $t4, 1  # used in loop

loop:
beq $t4, $s0, loop_done
addi $t4, $t4, 1
div $s0, $t4
mfhi $t5
bne $t5, $0, loop
div $s1, $t4
mfhi $t5
bne $t5, $0, loop
div $s2, $t4
mfhi $t5
bne $t5, $0, loop

addi $a0, $t4, 0
jal is_prime
bne $v0, 0, update_answer
j loop

loop_done:
li $v0, 4
la $a0, answer
syscall

li $v0, 1
addi $a0, $s3, 0
syscall

li $v0, 4
la $a0, newlines
syscall

exit:  # subroutine to exit
li $v0, 10
syscall

update_answer:
addi $s3, $t4, 0
j loop

is_prime:  # subroutine to check if number stored in $a0 is prime
li $t0, 2

is_prime_loop:
beq $t0, $a0, is_prime_done
div $a0, $t0
mfhi $t1
slti $t2, $t1, 1  # if there is remainder, $t2 will be 0, no remainder then $t2 is 1 and number is not prime
addi $t0, $t0, 1
beq $t2, $0, is_prime_loop

li $v0, 0
jr $ra

is_prime_done:
li $v0, 1
jr $ra