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

li $t8, 0  # count
li $t9, 50  # print 50 numbers

# make the first number (at $s0) 0
li $t4, 0
sw $t4, 0($s0)
addi $s0, $s0, 4
addi $t0, $t0, 1

# make the second number (at $s1) 1
li $t4, 1
sw $t4, 0($s1)
addi $s1, $s1, 4
addi $t1, $t1, 1

# iteratively find next fibonacci numbers
fibo:
# print subroutine uses $s3 as a base address and iterates through $t3 number of digits backwards
# recall at this point $s0 should be the last digit in number
# numbers are stored backwards for easy addition
move $s3, $s0
move $t3, $t0
jal print

# increment number of fibonacci numbers printed and exit if we're done else continue
addi $t8, $t8, 1
beq	$t8, $t9, exit

# call print for $s1 too
move $s3, $s1
move $t3, $t1
jal print

# increment number of fibonacci numbers printed and exit if we're done else continue
addi $t8, $t8, 1
beq	$t8, $t9, exit

# add the numbers to get the next numbers
# so the add subroutine takes too base address (this time the beginning of the number not the end so we need la to get back to beginning)
# add subroutine uses base address $s5 and $s6 and overwrites $s6 with the sum
# also $t5 and $t7 hold the number of digits of the two numbers for iterating
# $s4 holds the number of digits of the sum

# we do two adds at once
# like a += b, b += a, so a and b will be the next two fibonacci numbers and always a < b
# should be easier than doing one at a time where on the next iteration b < a and we have to consider that every other iteration
la $s5, y
la $s6, x

move $t5, $t0
move $t7, $t1
li $s4, 0

# call add subroutine after copying requires $s5, $s6, $t5 and $t7
jal my_add

# at this point $s6 holds the address of the last digit of the sum kinda, which we need for print, and $s4 holds num of digits
# copy those to $s0, $t0 for calling print function
move $s0, $s6
move $t0, $s4

la $s5, x
la $s6, y

move $t5, $t0
move $t7, $t1
li $s4, 0

# call add subroutine after copying requires $s5, $s6, $t5 and $t7
jal my_add

# at this point $s6 holds the address of the last digit of the sum kinda, which we need for print, and $s4 holds num of digits
# copy those to $s0, $t0 for calling print function
move $s1, $s6
move $t1, $s4

j fibo  # keep running this loop this we have printed all the numbers required and branch to exit

# syscall to exit program
exit:
li $v0, 10
syscall

# Print Subroutine
print:
# $s3 would actually have the next address after the last digit so we need to first move back one digit, and also keep moving back on next iter
addi $s3, $s3, -4
li $v0, 1
lw $a0, 0($s3)
syscall  # syscall to print digit
addi $t3, $t3, -1  # reduce num of digits left to print
bne $t3, $0, print  # print next digit if more digits, else print delimiter (new line) and return to caller

li $v0, 4
la $a0, delim
syscall

# return to subroutine caller
j $ra

# Add Subroutine
my_add:
# recall $s5 and $s6 are base addresses of the numbers to add (address of first digit)
# $t5 and $t7 are the number of digits in the numbers to be added
# $t6 is carry (0 or 1)
lw $t2, 0($s5)  # load next digits
lw $t3, 0($s6)
add $t4, $t2, $t3  # add them
add $t4, $t4, $t6  # then add carry
# if it is greater than 10 right, we need to carry one and keep the units digit
# can achieve by division of sum by 10. quotient in LO is the new carry, remainder in HI is the bit we save
div $t4, $s2
mfhi $t4
mflo $t6
# save digit to $s6
sw $t4, 0($s6)
# increment $s5, $s6, decrement number of bits left to add ($t5, $t7)
addi $s5, $s5, 4
addi $t5, $t5, -1
addi $s6, $s6, 4
addi $t7, $t7, -1
addi $s4, $s4, 1
# we want to exit when done adding, so $t5 and $t7 should be zero
# use bgt not bne because when $t5 and $t7 are zero but there is a carry, $t5 and $t7 are decremented to -1 and are not eq to 0
bgt $t5, $0, my_add
bgt $t7, $0, my_add
# also need carry to be zero because if carry is 1 at end after adding, we need to save it as well
bgt $t6, $0, my_add

# return to subroutine caller
j $ra
