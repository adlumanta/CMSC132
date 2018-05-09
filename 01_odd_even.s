#############################################################################################################
#
#	1. ODD OR EVEN
#
############################################################################################################
.data

NLNL:	.asciiz "\n\n"

INTEGER_INPUT:
	#.word 0
	.word 4294967295		# Change the value here
EVEN:
	.word 2

STR_to_view_num:
	.asciiz "<integer number> = "
STR_check_odd:
	.asciiz "\nOdd."
STR_check_even:
	.asciiz "\nEven."

.text
.globl main

############################################################################################################
main:

	li $v0, 4
	la $a0, STR_to_view_num
	syscall

	lw $a0, INTEGER_INPUT
	li $v0, 1
	syscall

check_digit:
	addi	$sp, $sp, -4		# PUSH return address
	sw	$ra, 0($sp)

	lw $t0, INTEGER_INPUT		# Load value
	lw $t1, EVEN 				# divisor = 2
	
	div $t0, $t1				# Divide value by 2
	mfhi $t2					# Get remainder

	beq $t2, $zero, print_even	# If $t2 is 0 the number is even, otherwise it is odd
	j print_odd

print_even:						# Print if even
	li $v0, 4
	la $a0, STR_check_even
	syscall

	jr $ra

print_odd:						# Print if odd
	li $v0, 4
	la $a0, STR_check_odd
	syscall

	li  $v0,    10              # System call for exit program
    syscall
############################################################################################################
