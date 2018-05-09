############################################################################################################
#
# 	3. SUBSTRING
#
############################################################################################################
	.data
STRING_1:						# Substring
	.asciiz "naba"
STRING_2:
	.asciiz "nanaba"	# Main string

	.globl DBG
	.text
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

DBG:	##### DEBUGG BREAKPOINT ######

  addi    $v0, $zero, 0           # Initialize Sum to zero.
	add		$s0, $zero, $zero		# Initialize array index i to zero.

is_substring:
	addi 	$sp, $sp, -4							# Push
	sw 		$ra, 0($sp)								# Save return address
	
	add 	$s1, $zero, $zero 						# Initialize index i (string 2)
	add 	$s2, $zero, $zero 						# Initialize index j (string 1)
	addi 	$v0, $zero, 1							# Initiate output to 1 (false)

loop_substring:
	add 	$s3, $a1, $s1 							# Get address of current character for string 2
	lb 		$s4, 0($s3) 							# Get character
	beq 	$s4, $zero, end_substring 				# End of string 2

	add 	$s3, $a0, $s2 							# Get address of current character string 1
	lb 		$s5, 0($s3) 							# Get character
	beq 	$s4, $s5, inner_substring  				# End of string 1

substring_loop_continue:
	addi 	$s2, $zero, 0 							# reset j loop
	addi 	$s1, $s1, 1 							# i++
	j 		loop_substring

inner_substring:
	addi 	$s6, $s1, 1 							# k = i + 1
	addi 	$s2, $s2, 1								# j++

inner_loop_substring:
	add 	$s3, $a1, $s6							# Get address of current string 2 character
  lb 		$s4, 0($s3)								# Load
	add 	$s3, $a0, $s2 							# Get address of current string 1 character
	lb 		$s5, 0($s3)								# Load character
	beq 	$s5, $zero, substring_true	 			# If a[i] == NULL, end
	bne 	$s4, $s5, substring_loop_continue 		# If a[k] != b[j], reset
	addi 	$s6, $s6, 1 							# k++
	addi 	$s2, $s2, 1 							# j++
	j 		inner_loop_substring

substring_true:
	addi 	$v0, $zero, 0

end_substring:
	lw		$ra, 0($sp)								# Pop return address to caller
	addi	$sp, $sp, 4		 
	jr		$ra

############################################################################################################
#
# MAIN: Main calls various subroutines and print out results.
#
############################################################################################################
	.data

STR_the_string:
	.asciiz "<string> = "

STR_comma:
	.asciiz ", "

STR_newLine:
	.asciiz "\n"
	
	.text
	.globl main

main:

	li $v0, 4
	la $a0, STR_the_string
	syscall

	li $v0, 4
	la $a0, STRING_1
	syscall

	li $v0, 4
	la $a0, STR_comma
	syscall

	li $v0, 4
	la $a0, STR_the_string
	syscall

	li $v0, 4
	la $a0, STRING_2
	syscall

	li $v0, 4
	la $a0, STR_newLine
	syscall

	addi	$sp, $sp, -4	# PUSH return address
	sw		$ra, 0($sp)

	la		$a0, STRING_1
	la		$a1, to_upper
	jal		string_for_each

	la		$a0, STRING_2
	la		$a1, to_upper
	jal		string_for_each

	la 		$a0, STRING_1
	la 		$a1, STRING_2
    jal 	is_substring

	jal 	print_substring

	li      $v0, 10         # System exit
    syscall 
############################################################################################################
print_substring:
	.data

STR_substring:
	.asciiz "Substring.\n"

STR_not_substring:
	.asciiz "Not a substring.\n"

	.text 

	##
	###	Load $v0 0 - TRUE, 1 - FALSE
	##

	addi 	$t0, $v0, 0

	la		$a0, STR_substring

	beq 	$t0, $zero, print_result

	la		$a0, STR_not_substring

print_result:
	li	$v0, 4
	syscall

	jr		$ra
############################################################################################################
