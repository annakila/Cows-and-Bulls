#playing around wioth creating a simulation of the game...
######################################################################
#       Bitmap Display Settings:                                     #
#	Unit Width: 8						     #
#	Unit Height: 8						     #
#	Display Width: 512					     #
#	Display Height: 512					     #
#	Base Address for Display: 0x10008000 ($gp)		     #
######################################################################
.data
	screenWidth:	.word 64
	screenHeight:	.word 64
	
	#colors
	bullColor:	.word 0x2bcc2e		#green
	cowColor:	.word 0xffd700		#orange
	wrongColor:	.word 0x000000		#black
	background:	.word 0xffffff		#white
	border:		.word 0x2bcc2e		#green again
	
	#score
	bulls:		.word 0
	cows:		.word 0
	wrongGuess:	.word 0
	
	score_for_one:	.word 1
	
	#Messages
	prompt: .asciiz "Enter a guess: "
	quit:	.asciiz "You gave up. The word to guess was: "
	win:	.asciiz "You win! Number of guesses was: "
	time:	.asciiz "seconds"
	
.text

main:
	lw $a0, screenWidth		#screenwidth
	lw $a1, background		#background coior
	mul $a2, $a0, $a0		#total pixels on screen
	mul $a2, $a2, 4			#addresses
	add $a2, $a2, $gp		#add base of gp
	add $a0, $gp, $zero		#loop counter
FillLoop:
	beq $a0, $a2, Init
	sw $a1, 0($a0)			#store color
	addiu $a0, $a0, 4		#increment counter
	j FillLoop
	
Init:
	#variable initialization	not sure I did this right..
	li $t0, 10
	sw $t0, score_for_one
	sw $zero, bulls
	sw $zero, cows
	sw $zero, wrongGuess

DrawBorder:
		li $t1, 0	#load Y coordinate for the left border
LeftLoop:
	move $a1, $t1	#move y coordinate into $a1
	li $a0, 0	# load x direction to 0, doesnt change
	jal CoordinateToAddress	#get screen coordinates
	move $a0, $v0	# move screen coordinates into $a0
	lw $a1, border	#move color code into $a1
	jal DrawPixel	#draw the color at the screen location
	add $t1, $t1, 1	#increment y coordinate
	
	bne $t1, 64, LeftLoop	#loop through to draw entire left border
	
	li $t1, 0	#load Y coordinate for right border
RightLoop:
	move $a1, $t1	#move y coordinate into $a1
	li $a0, 63	#set x coordinate to 63 (right side of screen)
	jal CoordinateToAddress	#convert to screen coordinates
	move $a0, $v0	# move coordinates into $a0
	lw $a1, border	#move color data into $a1
	jal DrawPixel	#draw color at screen coordinates
	add $t1, $t1, 1	#increment y coordinate
	
	bne $t1, 64, RightLoop	#loop through to draw entire right border
	
	li $t1, 0	#load X coordinate for top border
TopLoop:
	move $a0, $t1	# move x coordinate into $a0
	li $a1, 0	# set y coordinate to zero for top of screen
	jal CoordinateToAddress	#get screen coordinate
	move $a0, $v0	#  move screen coordinates to $a0
	lw $a1, border	# store color data to $a1
	jal DrawPixel	#draw color at screen coordinates
	add $t1, $t1, 1 #increment X position
	
	bne $t1, 64, TopLoop #loop through to draw entire top border
	
	li $t1, 0	#load X coordinate for bottom border
BottomLoop:
	move $a0, $t1	# move x coordinate to $a0
	li $a1, 63	# load Y coordinate for bottom of screen
	jal CoordinateToAddress	#get screen coordinates
	move $a0, $v0	#move screen coordinates to $a0
	lw $a1, border	#put color data into $a1
	jal DrawPixel	#draw color at screen position
	add $t1, $t1, 1	#increment X coordinate
	
	bne $t1, 64, BottomLoop	# loop through to draw entire bottom border
	
CoordinateToAddress:
	lw $v0, screenWidth 	#Store screen width into $v0
	mul $v0, $v0, $a1	#multiply by y position
	add $v0, $v0, $a0	#add the x position
	mul $v0, $v0, 4		#multiply by 4
	add $v0, $v0, $gp	#add global pointer from bitmap display
	jr $ra			#return $v0
	
DrawPixel:
	sw $a1, ($a0) 	#fill the coordinate with specified color
	jr $ra		#return


