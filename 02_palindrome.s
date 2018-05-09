############################################################################################################
#
# 	2. PALINDROME
#
############################################################################################################
.data

NLNL:	
	.asciiz "\n\n"

STR:
	.asciiz "Bob"

STR_intro:
		.asciiz "<string> = '"
STR_close:
		.asciiz "'\n"

.text
.globl main

############################################################################################################
#				|
# STRING LENGTH | Input: $a0, Output: $v0
#				|
############################################################################################################

string_length:
    addi    $v0, $zero, 0           				# Initialize return value to zero

loop_string_length:
	lb 		$s1, 0($a0)								# n = string[i]
	beq 	$s1, $zero, end_loop_string_length		# Done if n == NULL
	addi 	$v0, $v0, 1								# length++
	addi 	$a0, $a0, 1								# i++
	j 		loop_string_length 		 				# next character

end_loop_string_length:
	jr		$ra
############################################################################################################
#				|
# for_each  	| Input: $a0
#				|
############################################################################################################

string_for_each:

	addi	$sp, $sp, -4							# PUSH return address to caller
	sw		$ra, 0($sp)

	#### Write your solution here ####
	loop_string_print:
	lb 		$s1, 0($a0)								# n = string[i]
	beq 	$s1, $zero, end_loop_string_print		# Done if n == NULL
	
	addi 	$sp, $sp, -4							# PUSH string address to stack
	sw 		$a0, 0($sp)
	
	jal 	$a1										# call subroutine
	
	lw 		$a0, 0($sp)								# POP string address back
	addi 	$sp, $sp, 4
	
	addi 	$a0, $a0, 1								# address to next character
	j 		loop_string_print 						# next character

end_loop_string_print:
	lw		$ra, 0($sp)								# Pop return address to caller
	addi	$sp, $sp, 4		

	jr		$ra
############################################################################################################
#				|
# TO UPPERCASE 	| Input: $a0
#				|
############################################################################################################

to_upper:
    lb 		$s0, 0($a0)					# Load character
    slti 	$s1, $s0, 123 				# Compare if char is less than or equal to the int value of 'z'
    slti	$s2, $s0, 97				# Compare if char is less than to the int value of 'a'
    slt 	$s3, $s2, $s1				# Compare if $s1 is 1 and $ss2 is 0
    bne 	$s3, $zero, to_uppercase	# if $s3 is 1, it means that the char ($s0) is in lowercase
    j 		to_upper_end

 to_uppercase:
 	addi	$s0, $s0, -32				# subtract int value of char by 32 to obtain uppercase form
 	sb 		$s0, 0($a0)					# save new value to $a0

 to_upper_end:
	jr		$ra

############################################################################################################
#				|
# PALINDROME 	| Input: $a0, Output, $v0
#				|
############################################################################################################

is_palindrome:
	addi 	$sp, $sp, -4	                  	# Push
    sw      $ra, 0 ($sp)                    	# Save return address
    sw      $a0, 4 ($sp)                    	# Save argument value

    jal     string_length                       # Get string length value
    addi    $s0, $v0, 0                      	# Save length

    lw      $a0  4($sp)                      	# Load the argument
    addi    $s1, $a0, 0             		    # save its value to t1

    li      $s2, 1                        		# set counter to 1
 
    addi 	$s8, $zero, 2                       # Divisor
    div     $s0, $s8
    mflo 	$s3                 				# Calculate string length / 2 to get the middle character (or the half value of the string length if even, if odd, it will just go to mflo anyway)
    addi    $s3, $s3, 1                   		# Add 1 to the string length midpoint incase of an even number

    li      $v0, 0     							# Set return value to 1 (or true)

palindrome_loop:
    beq     $s2, $s3, palindrome_end     		# End loop if all characters has been compared
    lb      $s4, 0($a0)                      	# Get character in index from the left of the string

    sub     $s5, $s0, $s2                 		# Get maximum string index from lefthand of the string
    add     $s6, $s5, $s1                 		# add index from the end of the string to start address
    lb      $s7, 0($s6)                      	# Get opposite character from the right of the string

    beq     $s4, $s7, palindrome_continue      	# Check characters if the same ascii value
    li      $v0, 1                          	# Return 0 if system will detect that opposite letters are not of the same ascii value
    j       palindrome_end

palindrome_continue:
    addi    $a0, $a0, 1                   		# Incrment pointer to string address
    addi    $s2, $s2, 1                   		# Counter++
    j       palindrome_loop

palindrome_end:
    lw      $ra,  0($sp)                      	# Load return address
    addi    $sp,  $sp, 8                   		# Pop from stack
    jr      $ra          

############################################################################################################
#				|
# MAIN  		|	
#				|
############################################################################################################
main:
    la      $a0, STR                        # Load string

    li		$v0, 4
	la		$a0, STR_intro
	syscall

	li		$v0, 4
	la		$a0, STR
	syscall

	li		$v0, 4
	la		$a0, STR_close
	syscall

	la		$a0, STR 						# Convert to all uppercase
	la		$a1, to_upper
	jal		string_for_each

	la		$a0, STR
    jal     is_palindrome                   # Execute palindrome

    jal		print_palindrome

    li      $v0, 10            				# System exit
    syscall   

############################################################################################################
print_palindrome:

.data

STR_palindrome:
	.asciiz "Palindrome.\n"

STR_not_palindrome:
	.asciiz "Not a palindrome.\n"

.text

	add 	$t0, $v0, $zero

	la		$a0, STR_palindrome

	beq 	$t0, $zero, print_result

	la		$a0, STR_not_palindrome

	print_result:
	li		$v0, 4
	syscall

	jr	$ra
                            
############################################################################################################