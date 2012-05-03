# hangman.asm
# Michael Breedlove
#


	.data
wordlist: 
	.asciiz "/home/mbreedlove/Programming/Hangman-mips/words.txt"
words:
	.space 128
word:
	.space 16
mystery_word:
	.space 16
user_guess:
	.space 4
	
	
hangman_info1:
	.asciiz "Word: '"
hangman_info2:
	.asciiz "' | Guesses left: "
hangman_prompt:
	.asciiz "Enter a letter: "
	
hangman_win_msg:
	.asciiz "You win!"
hangman_lose_msg:
	.asciiz "You lose!"
error_msg:
	.asciiz "An error has been caught\n"
newline:
	.asciiz "\n"
dnewline:
	.asciiz "\n\n"
	
	
	.text
	.globl	__main

__main:
	jal 	__load_wordlist
	jal	__get_rand_word
	jal	__hangman
	
	
	j	__exit
		
__load_wordlist:
	li	$v0,	13		# syscall for open file
	la	$a0,	wordlist
	li	$a1,	0		# read flag
	li	$a2,	0		# mode is ignored
	syscall
	move	$s0,	$v0		# save file descriptor to $s0
	
	bltz  	$s0,	__error
	
	li	$v0,	14		# syscall for read file
	move	$a0,	$s0		# pass file descriptor
	la	$a1,	words
	li	$a2,	64		# read (bytes / 2) characters
	syscall
	
	li	$v0,	16		# syscall for close file
	move	$a0,	$s0		# pass file descriptor
	syscall
	
	jr	$ra
	
__get_rand_word:
	li	$v0,	42		# syscall for random int range
	li	$a0,	2
	li	$a1,	5		# Sets upper bound to 5
	syscall
	
	
	move	$t0,	$a0		# Random int; newlines to skip
	la	$s0,	words		# Address to current letter
	
__get_rand_word_loop:

	beqz	$t0,	__get_rand_word_copy
	lb	$t2,	($s0)
	
	bne	$t2,	0x0a,	__get_rand_word_loop2
	subi	$t0,	$t0,	1
__get_rand_word_loop2:
	addi	$s0,	$s0,	1
	b	__get_rand_word_loop
	
__get_rand_word_copy:
	la	$t0,	word

__get_rand_word_copy_loop:
	lb	$t1,	($s0)
	beq	$t1,	0x0a,	__get_rand_word_copy_exit	# Exit on newline
	sb	$t1,	($t0)		# Copy byte into word
	addi	$s0,	$s0,	1	# offset address of wordlist
	addi	$t0,	$t0,	1	# offset address of word
	b	__get_rand_word_copy_loop
	
__get_rand_word_copy_exit:	
	b	__sub_exit
	
__hangman:
	li	$s0,	5		# Guesses left
	
	la	$t0,	word
	la	$t1,	mystery_word
	li	$t2,	0x2D		# Hex for -
	li	$s1,	0
__hangman_fill:
	sb	$t2,	($t1)		# store - in mystery_word
	
	addi	$t0,	$t0,	1		# inc address of word
	addi	$t1,	$t1,	1		# inc address of mystery_word
	
	lb	$t3,	($t0)
	bne	$t3,	0x00,	__hangman_fill	# keep going until null-byte
	
__hangman_loop:
	jal	__hangman_print_info
	jal	__hangman_guess

	li	$v0,	4
	la	$a0,	dnewline
	syscall
	
	jal	__finished			# if hangman finished ? 1 : 0
	beqz	$a0,	__hangman_loop
	
	li	$s1,	1			# Finished puzzle and with guesses left; 1 for win
	j	__hangman_exit
	
	
__hangman_print_info:
	### Word '
	li	$v0,	4
	la	$a0,	hangman_info1
	syscall
	
	### print contents of word
	li	$v0,	4
	la	$a0,	mystery_word
	syscall	

	### ' | Guesses left: 
	li	$v0,	4
	la	$a0,	hangman_info2
	syscall

	### Prints guesses left
	li	$v0,	1
	move	$a0,	$s0
	syscall
	
	### Newline
	li	$v0,	4
	la	$a0,	newline
	syscall
	
	
	b	__sub_exit
	
__hangman_guess:
	### Enter a letter: 
	### Correct!
	
__hangman_guess_prompt:
	li	$v0,	4
	la	$a0,	hangman_prompt
	syscall
	
	li	$v0,	8
	la	$a0,	user_guess
	li	$a1,	2
	syscall
	
__hangman_guess_check:
	#TODO = Check if word contains user_guess
	####
	###	iterate over word, mystery_word
	###	  if word[i] == user_guess
	###	    mystery_word[i] = user_guess
	
	li	$t0,	0	# current index
	la	$t9,	user_guess
	lb	$t1,	($t9)	# load character into $t1
	la	$t2,	word
	la	$t3,	mystery_word
	li	$t9,	0	# 0 -> not found letter | 1 -> found letter
__hangman_guess_check_loop:	
	lb	$t4,	($t2)	# load current char of word
	beq	$t4,	0x00,	__hangman_guess_exit
	bne	$t4,	$t1,	__hangman_guess_check_false
	sb	$t1,	($t3)	# reveal letter
	li	$t9, 	1
__hangman_guess_check_false:
	addi	$t2,	$t2,	1
	addi	$t3,	$t3,	1
	b	__hangman_guess_check_loop
	
__hangman_guess_exit:
	beq	$t9,	1,	__sub_exit
	
	# OR if the letter WAS NOT found...
	subi	$s0,	$s0,	1
	b	__sub_exit
	
__hangman_exit:
	jal	__hangman_print_info
	beqz	$s1,	__hangman_exit_lose
	b	__hangman_exit_win
	
__hangman_exit_win:
	li	$v0,	4
	la	$a0,	hangman_win_msg
	syscall
	
	j	__exit
	#TODO
	
	
__hangman_exit_lose:
	li	$v0,	4
	la	$a0,	hangman_lose_msg
	syscall
	
	j	__exit
	#TODO
		
__finished:	
	# Check if out of guesses
	blez	$s0,	__hangman_exit
	
	la	$t1,	mystery_word
	
__finished_loop:
	lb	$t2,	($t1)
	beq	$t2,	0x00,	__finished_true
	beq	$t2,	0x2D,	__finished_false	# if its a dash then not complete
	addi	$t1,	$t1,	1
	b	__finished_loop

__finished_true:
	li	$s1,	1
	b	__sub_exit
	
__finished_false:
	li	$a0,	0
	b	__sub_exit
	
__sub_exit:
	jr	$ra
		

__error:
	li	$v0,	4
	la	$a0,	error_msg
	syscall
	j __exit

__exit:
	li	$v0,	10
	syscall
