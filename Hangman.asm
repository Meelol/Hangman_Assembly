.data
	#List of words
	WORD1: .asciiz "astronomy"
	WORD2: .asciiz "dynamite"
	WORD3: .asciiz "assembly"
	WORD4: .asciiz "logistics"
	WORD5: .asciiz "compiler"
	WORD6: .asciiz "algorithm"
	WORD7: .asciiz"hangman"
	WORD8: .asciiz"programming"
	WORD9: .asciiz"variable"
	WORD10: .asciiz"computer" 
        WORD11: .asciiz"onomatopoeia"
        WORD12: .asciiz"processor"
        WORD13: .asciiz"apocalypse"
        WORD14: .asciiz"blasphemy"
        WORD15: .asciiz"phosphorus"
        WORD16: .asciiz"equilibrium"
        WORD17: .asciiz"incognito"
        WORD18: .asciiz"silhouette"
        WORD19: .asciiz"kaleidoscope"
        WORD20: .asciiz"effervescent"
        wordList: .word WORD1, WORD2, WORD3, WORD4, WORD5, WORD6, WORD7, WORD8, WORD9, WORD10, WORD11, WORD12, WORD13, WORD14, WORD15, WORD16, WORD17, WORD18, WORD19, WORD20
        
        #Global variables
        selectedWord: .space 20
        hiddenWord: .space 20
        wordsGuessed: .space 20
        tempString: .space 20
        correctInput: .word 1
        userInput: .space 1
        lives: .word 6
        
        #Output messages
        welcomeMessage: .asciiz "Welcome to Hangman!\n"
        youLostMessage: .asciiz "You lost! Out of lives.\n"
        youWinMessage: .asciiz "You guessed right! You Win!\n"
        userInputPrompt: .asciiz "Enter next character (A-Z), or 0 (zero) to exit: "
        underscore: .asciiz "_"
        wordMessage: .asciiz "Word: "
        missedMessage: .asciiz "Missed: "
        invalidInputMessage: .asciiz "Invalid input\n"
        blankSpace: .asciiz " "
        newLine: .asciiz "\n"
        
        hangmanDrawing_6Lives: .asciiz "\n |-----|\n |     |\n       |\n       |\n       |\n       |\n       |\n       |\n ---------\n"
        hangmanDrawing_5Lives: .asciiz "\n |-----|\n |     |\n O     |\n       |\n       |\n       |\n       |\n       |\n ---------\n"
        hangmanDrawing_4Lives: .asciiz "\n |-----|\n |     |\n O     |\n |     |\n |     |\n       |\n       |\n       |\n ---------\n"
        hangmanDrawing_3Lives: .asciiz "\n |-----|\n |     |\n O     |\n\\|     |\n |     |\n       |\n       |\n       |\n ---------\n"
        hangmanDrawing_2Lives: .asciiz "\n |-----|\n |     |\n O     |\n\\|/    |\n |     |\n       |\n       |\n       |\n ---------\n"
        hangmanDrawing_1Lives: .asciiz "\n |-----|\n |     |\n O     |\n\\|/    |\n |     |\n/      |\n       |\n       |\n ---------\n"
        hangmanDrawing_0Lives: .asciiz "\n |-----|\n |     |\n O     |\n\\|/    |\n |     |\n/ \\    |\n       |\n       |\n ---------\n"
        
.text

	main:
		#Print welcome message
		li	$v0, 4
		la	$a0, welcomeMessage
		syscall
		#Start game
		jal startGame
		#End of program
		li	$v0, 10
		syscall
		
	startGame:
		addi	$sp, $sp, -4
		sw	$ra, 0($sp)
		#Generate random number 0 - 19
		lw	$t7, lives	# Number of lives = 6
		li	$v0, 42
		la	$a1, 20
		syscall
        	move	$s0, $a0		#$s0 = Random number
        	mul	$t0, $s0, 4		#Get correct wordList member
        	lw	$s1, wordList($t0)	#$s1 = wordList[$s0]	
        	sw	$s1, selectedWord 	#selectedWord = $s1
        	#Print selectedWord to check
        	li    	$v0,  4
        	lw	$a0, selectedWord
        	syscall
        	
        	#Find length of word
        	lw	$a0, selectedWord
        	jal	findWordLength
        	move	$s2, $v1		#$s2 = selectedWord.length()
        	#Print length
              	li	$v0, 1
        	move	$a0, $s2
        	syscall
        	#Append underscores to hiddenWord depending on the number of letters in selectedWord
        	li	$t0, 0			#For loop counter set to 0
        	la	$t1, hiddenWord
        	la	$t2, underscore
        	appendUnderScoreLoop:
        	addi	$t0, $t0, 1		#Incerease counter by 1
        	lb	$t3, 0($t2)		#Load underscore "_" to $t3
        	sb	$t3, 0($t1)		#Add underscore to correctWord
        	addi	$t1, $t1, 1		#Go to next memory location in correctWord
        	blt	$t0, $s2, appendUnderScoreLoop	#Keep looping until counter matches the length of selectedWord
        	
        	#Print hiddenWord to check the number of underscores
        	li	$v0, 4
        	la	$a0, hiddenWord
        	syscall
        	
        	#Print newLine
        	li	$v0, 4
        	la	$a0, newLine
        	syscall
        	
        	#Game Loop
        	gameLoop:
        	#Set tempString to correctWord
        	la	$t0, tempString
        	la	$t1, hiddenWord
        	assignString:
        	lb	$t2, 0($t1)
        	beqz	$t2, continue1
        	sb	$t2, 0($t0)
        	addi	$t1, $t1, 1
        	addi	$t0, $t0, 1
        	j	assignString
        	continue1:
        	#Lose condition
        	beqz	$t7, youLose
        	#Win condition 
       		la	$t0, selectedWord
       		la	$t1, hiddenWord
       		compareString:
       		lb      $t2,($t0)                   #Get next char from selectedWord
    		lb      $t3,($t1)                   #Get next char from hiddenWord
    		bne     $t2,$t3,continue2           #If different continue game
    		beq     $t2,$zero,youWin            #If last char is null then strings are equal
    		addi    $s2,$s2,1                   # point to next char
    		addi    $s3,$s3,1                   # point to next char
    		j       compareString
    		continue2:
    		#Print game messages
    		#Print wordMessage
    		li	$v0, 4
    		la	$a0, wordMessage
    		syscall
    		#Print hiddenWord
    		li	$v0, 4
    		la	$a0, hiddenWord
    		syscall
    		#Print newLine
    		li	$v0, 4
    		la	$a0, newLine
    		syscall
    		#Print missedMessage
    		li	$v0, 4
    		la	$a0, missedMessage
    		syscall
    		#Print wordsGuessed
    		li	$v0, 4
    		la	$a0, wordsGuessed
    		move	$a1, $t7	# hangmanDrawings(lives)
    		jal	hangmanDrawings
    		askUserGuess:
    		lw	$t6, correctInput #Flag
    		#Print userInputPrompt
    		li	$v0, 4
    		la	$a0, userInputPrompt
    		syscall
    		#Read char from user
    		li	$v0, 12
    		syscall
    		move	$t5, $v0 	#Save input in t5
    		
    		youLose:
    		move	$a1, $t7
    		jal hangmanDrawings
    		#Print youLostMessage
    		li	$v0, 4
    		la	$a0, youLostMessage
    		syscall
        	#Return to main
        	lw	$ra, 0($sp)
        	addi	$sp, $sp, 4
        	jr	$ra
        	youWin:
    		move	$a1, $t7
    		jal hangmanDrawings
    		#Print youWinMessage
    		li	$v0, 4
    		la	$a0, youWinMessage
    		syscall
        	#Return to main
        	lw	$ra, 0($sp)
        	addi	$sp, $sp, 4
        	jr	$ra
        
        #Prints type of hangman according to the number of lives left							
        hangmanDrawings:
        beq	$a1, 6, sixLives
        beq	$a1, 5, fiveLives
        beq	$a1, 4, fourLives
        beq	$a1, 3, threeLives
        beq	$a1, 2, twoLives
        beq	$a1, 1, oneLive
        beqz	$a1, zeroLives
        sixLives:
        li	$v0, 4
        la	$a1, hangmanDrawing_6Lives
        syscall
        jr	$ra
        fiveLives:
        li	$v0, 4
        la	$a1, hangmanDrawing_5Lives
        syscall
        jr	$ra
        fourLives:
        li	$v0, 4
        la	$a1, hangmanDrawing_4Lives
        syscall
        jr	$ra
        threeLives:
        li	$v0, 4
        la	$a1, hangmanDrawing_3Lives
        syscall
        jr	$ra
        twoLives:
        li	$v0, 4
        la	$a1, hangmanDrawing_2Lives
        syscall
        jr	$ra
        oneLive:
        li	$v0, 4
        la	$a1, hangmanDrawing_1Lives
        syscall
        jr	$ra
        zeroLives:
        li	$v0, 4
        la	$a1, hangmanDrawing_0Lives
        syscall
        jr	$ra														
        																								    																																								
        findWordLength:
      		li 	$t0, 0 		#initialize the count to 0
		lengthLoop:
		lb 	$t1, 0($a0) 	#Load the next character into t1
		beqz 	$t1, exit 	#Exit if  null character
		addi 	$a0, $a0, 1 	#Increment the string pointer
		addi 	$t0, $t0, 1 	#Increment the count
		j 	lengthLoop 	#Loop
		exit:
		move	$v1, $t0
		jr 	$ra
                
                
