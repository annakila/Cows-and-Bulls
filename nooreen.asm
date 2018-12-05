.data
	uGuess:		.ascii "blue"
	Answer:		.ascii "bleu"
.text
main:
	jal BullCowCheck          		# will go to that spot, keep reference to that location
	move $a0, $v0 				# moving bull counter to the integer printing parameter
	move $a1, $v1				# moving cow counter to different register
	li $v0, 1				# preparing integer syscall
	syscall
	move $a0, $a1				# moving cow counter to integer printing parameter
	syscall
	li $v0, 10				# pls dont crash my computer again
	syscall
	

BullCowCheck: 
	la $t1, Answer	      # load address for Answer b/c need to start from beginning again
	li $t2, 0             # loads position counter; initalized to 0
	li $t3, 0             # loads bulls counter; initialized to 0
	li $t4, 0             # loads cow counter; initialized to 0
	lb $t5, ($t1)	      # loading first character from Answer

	
	LoopOne: 
		beq $t2, 4, LoopExit     # b/c at end of word
		li $t6, 0                # counter for loopTwo
		la $t0, uGuess        	# load address for UserGuess
		lb $t7, ($t0)            # load first character from uGuess
		
		j LoopTwo 
		
		LoopOneEnd: 
			addi $t1, $t1, 1 # going to next character in Answer
			lb $t5, ($t1)	# loading next character in Answer
			addi $t2, $t2, 1 # incrementing position counter
			j LoopOne
		
	LoopTwo: 
		beq $t6, 4, LoopOneEnd   # go back to outer loop
		beq $t2, $t6, BullCheck  # if position counter and letter are same
		bne $t5, $t7, LoopTwoEnd    # first was incorrect, need to increment LoopTwo counter
		addi $t4, $t4, 1         # if not branching, then increment cow counter bc WE HAVE A COW
		
		j LoopOneEnd
		
		LoopTwoEnd:
			addi $t6, $t6, 1         # incrementing LoopTwo counter
			addi $t0, $t0, 1         # going to next character in uGuess
			lb $t7, ($t0)            # load first character from uGuess
			j LoopTwo		# jump back to LoopOne because if match already found, remaining letters won't be a match no matter what
		
	BullCheck:
		bne $t5, $t7, LoopTwoEnd    # first was incorrect, need to increment LoopTwo counter
		addi $t3, $t3, 1         # if not branching, then increment bull counter bc WE HAVE A BULL 
		
		j LoopTwoEnd		# jump back to LoopOne because if match already found, remaining letters won't be a match no matter what
		
	LoopExit:
		move $v0, $t3		# moving bull counter
		move $v1, $t4		# moving cow counter
		jr $ra			 
