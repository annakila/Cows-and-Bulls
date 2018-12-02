.data
	words: 		.asciiz "/0"
	wordCount: 	.word 
	
	Welc01: 	.asciiz "Cows and Bulls: Word Version\n"
	Welc02: 	.asciiz "Authors: \n\n\n\n"
	Menu00: 	.asciiz "Choose from the following:\n\n"
	Menu01: 	.asciiz "[1] Start a new game\n"
	Menu02:		.asciiz "[2] How to play\n"
	Menu03:		.asciiz "[3] Exit game\n"
	mPrompt:	.asciiz "Please enter a choice [1-3]: "
	MenuErr:	.asciiz "That was not a valid menu option."
	
	Guess00:	.asciiz "Enter a 4 letter word with no repeating letters:\n"
	Guess01:	.asciiz "Valid input is lowercase letters a-z. \n"
	Guess03:	.asciiz "Enter STOP to give up."
	GuessE01:	.asciiz "Answer must contain 4 letters."
	GuessE02:	.asciiz "Answer cannot contain repeated letters."
	GuessE03:	.asciiz "Input has already been guessed."
	GuessE04:	.asciiz "An invalid character was used."
	uGuess:		.space 64
	
	Answer:		.space 64
	return:		.asciiz "\n"
	MenuChoice:	.space 64
	Instructions:	.asciiz "Welcome to the Bulls and Cows: Word Edition game. The object of the game is to correctly guess a randomly generated 4 letter word. For each guess, the computer will return one of three options. A 'Bull' indicates that a letter you guessed is correct and in the correct position within the mystery word. A 'Cow' indicates that a letter you guessed is in the mystery word, however it is in a different location. A 'Miss' indicates that the letter you guessed is not in the word at all. To make a valid guess, enter a 4 letter word from the english language with no repeating letters. " 
	
	Score01:	.asciiz "\nYour guess has "
	Score02:	.asciiz "has "
	bScore01:	.asciiz " Bull and "
	bScore02:	.asciiz " Bulls and "
	cScore01:	.asciiz " Cow \n"
	cScore02:	.asciiz " Cows \n"
	
	quit:		.asciiz "You gave up... The word to guess was: "
	win:		.asciiz "\nCongradulations! You won!\n"
	time01:		.asciiz "It took you "
	time02:		.asciiz " seconds\n"
	time03:		.word 86400000		# miliseconds per day
	
.text
	
	#generate a random number
	lw	$a1, wordCount
	li	$v0, 42				
	syscall
	
	#use number to select a word from the list
	sll 	$a0, $a0, 2			# multiply random number by 4 to account for word lengths
	la 	$t0, words			# $t0=start address of words data
	add 	$a0, $t0, $a0			# $a0 is start position of words
	jal 	loadAndCheckBytes		# Load the word starting at $a0 (this is necessary instead of lw because the word may not start at a word boundary)
	move 	$s0, $v0			# $s0 = random word selected by computer
	
main:
	la 	$t0, Welc01
	la 	$t9, return			#load new line char into t9 reg so we can use frequently
	li 	$v0, 4
	add 	$a0, $t0, $zero			#load address of $t0 to $a0
	syscall					#call prints string
	la 	$t0, Welc02
	add 	$a0, $t0, $zero			#load second message to $a0
	syscall					#print it
	jal 	ShowMenu				#jump to showmenu function and show the menu...	

gameLoop:
	#begin time counter
	li 	$v0, 30				#get system time
	syscall
	lw 	$t0, time03			#calculate with miliseconds/day
	div 	$a0, $t0
	mfhi 	$s2				#$s2 converted to hold ms per day
	li 	$t0, 1000
	div 	$s2, $t0
	mflo 	$s2				#$s2 converted to hold s per day
	
	#game begins
	li 	$v0, 4				
	la 	$t0, Guess00
	add 	$a0, $t0, $zero
	syscall				#syscall displays guess0 prompt to user
	la 	$t0, Guess01
	add 	$a0, $t0, $zero
	syscall				#displays guess1 prompt
	la 	$t0, Guess02
	add 	$a0, $t0, $zero
	syscall				#displays guess2 prompt
	li 	$v0, 8
	la 	$a0, uGuess
	li 	$a1, 64
	syscall				#stores input to uGuess variable
	la 	$t0, uGuess
	li 	$v0, 4			#print
	add 	$a0, $t0, $zero
	syscall
	
	
	#check for user input errors
	la 	$t0, UserGuess
	
	lb 	$t1, ($t0)		#setting 0th bit to s1
	lb 	$t2, 1($t0)		#setting 1st bit to s2
	lb 	$t3, 2($t0)		#setting 2nd bit to s3
	lb 	$t4, 3($t0)		#setting 3rd bit to s4
	
	
	# A = 65 , Z = 90 , a = 97 , and z = 122 for the ascii table. Use for err checking. 
	# big ol mips 'if statements' check that input matches a-z ascii values
	addi 	$t5, $zero, 65
	blt 	$t1, $t5, InputErr
	addi 	$t5, $zero, 90
	ble 	$t1, $t5, Check02
	addi 	$t5, $zero, 97
	blt 	$t1, $t5, InputErr
	addi 	$t5, $zero, 122
	ble 	$t1, $t5, Check02
	
	#correct input
	
	
Check02:
	addi 	$t5, $zero, 65
	blt 	$t2, $t5, InputErr
	addi 	$t5, $zero, 90
	ble 	$t2, $t5, Check02
	addi 	$t5, $zero, 97
	blt 	$t2, $t5, InputErr
	addi 	$t5, $zero, 122
	ble 	$t2, $t5, Check02
	
Check03:
	addi 	$t5, $zero, 65
	blt 	$t2, $t5, InputErr
	addi 	$t5, $zero, 90
	ble 	$t1, $t5, Check03
	addi 	$t5, $zero, 97
	blt 	$t1, $t5, InputErr
	addi 	$t5, $zero, 122
	ble 	$t1, $t5, Check03
	
Check04:
	addi 	$t5, $zero, 65
	blt 	$t1, $t5, InputErr
	addi 	$t5, $zero, 90
	ble 	$t1, $t5, Check04
	addi 	$t5, $zero, 97
	blt 	$t1, $t5, InputErr
	addi 	$t5, $zero, 122
	ble 	$t1, $t5, Check04
	
	
	#check for duplicate entries
	beq $t1, $t2, GuessE02
	beq $t1, $t3, GuessE02
	beq $t1, $t4, GuessE02
	beq $t2, $t3, GuessE02
	beq $t2, $t4, GuessE02
	beq $t3, $t4, GuessE02
	
InputErr:				#for invalid character entry
	li 	$v0, 4
	la 	$t0, GuessE04
	add	$a0, $t0, $zero
	syscall
	jgameLoop
	
ShowMenu:
	li 	$v0, 4
	la 	$t0, Menu00
	add	$a0, $t0, $zero
	syscall
	la 	$t0, Menu01
	add	$a0, $t0, $zero
	syscall
	la 	$t0, Menu02
	add	$a0, $t0, $zero
	syscall
	la 	$t0, Menu03
	add 	$a0, $t0, $zero
	syscall
	la 	$t0, Menu04
	add 	$a0, $t0, $zero
	syscall
	la 	$t0, mPrompt
	add 	$a0, $t0, $zero
	syscall
	li 	$v0, 8			#Loading the input as a string to avoid problems
	la 	$a0, uGuess
	li 	$a1, 64
	syscall				#storing string in UserGuess
	lb 	$t1, ($a0)		#just pulling the first byte
	
	addi 	$t0, $zero, 49
	beq 	$t1, $t0, gameLoop  	#starting the game
	addi 	$t0, $zero, 50	
	beq 	$t1, $t0, Instructions	#Showing instructions
	addi 	$t0, $zero, 51	
	bne 	$t1, $t0, mError	#if they didn't choose any valid menu options print error message and go back to the menu
				
	li 	$v0, 10			#exits the program
	syscall
	
mError:					#for invalid menu entry
	li $v0, 4
	la $t0, MenuErr
	add $a0, $t0, $zero
	syscall
	
	j ShowMenu

	
#################################################################################################
#												#
# Exit:												#
#	#play a sound tune to signify game over		some codee I found idk if it works	#
#	li $v0, 31										#
#	li $a0, 28										#
#	li $a1, 250										#
#	li $a2, 32										#
#	li $a3, 127										#
#	syscall											#
#												#
#################################################################################################