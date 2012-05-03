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
guesses:
	.space 16
error_msg:
	.asciiz "An error has been caught\n"
newline:
	.asciiz "\n"
	
	
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
#Copy word at offset $t0 to word
__get_rand_word_copy_loop:
	lb	$t1,	($s0)
	beq	$t1,	0x0a,	__get_rand_word_copy_exit
	sb	$t1,	($t0)
	addi	$s0,	$s0,	1
	addi	$t0,	$t0,	1
	b	__get_rand_word_copy_loop
	
__get_rand_word_copy_exit:	
	b	__sub_exit
	
	
__hangman:
	# t0  
	l	
	
	
	
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
