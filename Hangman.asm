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
        usedWords: .space 30
        wordsMissed: .space 20
        tempString: .space 20
        userInput: .space 1
        lives: .word 6
        
        #Output messages
        welcomeMessage: .asciiz "Welcome to Hangman!"
        goodbyeMessage: .asciiz "\nGoodbye!"
        repeatedInputMessage: .asciiz "\nYou already guessed that letter! Try another one! \n"
        correctAnswerMessage: .asciiz "Correct answer: "
        youLostMessage: .asciiz "You lost! Out of lives.\n"
        youWinMessage: .asciiz "You guessed right! You Win!\n"
        userInputPrompt: .asciiz "Enter next character (A-Z), or 0 (zero) to exit: "
        underscore: .asciiz "_"
        wordMessage: .asciiz "Word: "
        missedMessage: .asciiz "Missed: "
        invalidInputMessage: .asciiz "\nInvalid input\n"
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
		lw	$t9, lives	# Number of lives = 6
		syscall
		#Start game
		jal startGame
		#Pint goodbyeMessage
		li	$v0, 4
		la	$a0, goodbyeMessage
		syscall
		#End of program
		li	$v0, 10
		syscall
		
	startGame:
		addi	$sp, $sp, -4		#Add space in stack memory
		sw	$ra, 0($sp)		#Save adress of main in stack
		#Generate random number 0 - 19
		li	$v0, 42			#Generate random number stored in $a0
		la	$a1, 20			#Upper bound set to 20 (a0 < 20)
		syscall
        	move	$s0, $a0		#$s0 = Random number
        	mul	$t0, $s0, 4		#Get correct wordList member
        	lw	$s1, wordList($t0)	#$s1 = wordList[$s0]	
        	sw	$s1, selectedWord 	#selectedWord = $s1
        	####UNCOMMENT TO CHECK ANSWER
        	#Print selectedWord to check
        	#li    	$v0,  4
        	#lw	$a0, selectedWord
        	#syscall
        	###############################
        	#Find length of word
        	lw	$a0, selectedWord	#Load selected word to $a0
        	jal	findWordLength		#call funtion with selectedWord as parameter
        	move	$s2, $v1		#$s2 = selectedWord.length()
        	#Append underscores to hiddenWord depending on the number of letters in selectedWord
        	li	$t0, 0			#For loop counter set to 0
        	la	$t1, hiddenWord		#Load address of hiddenWord
        	la	$t2, underscore		#Load address of underscore
        	appendUnderScoreLoop:
        	addi	$t0, $t0, 1		#Incerease counter by 1
        	lb	$t3, 0($t2)		#Load underscore "_" to $t3
        	sb	$t3, 0($t1)		#Add underscore to correctWord
        	addi	$t1, $t1, 1		#Go to next memory location in correctWord
        	blt	$t0, $s2, appendUnderScoreLoop	#Keep looping until counter matches the length of selectedWord
        	#Print newLine
        	li	$v0, 4
        	la	$a0, newLine
        	syscall
        	#Game Loop
        	gameLoop:
        	#Set tempString to correctWord, tempString is later compared to correctWord to decide if the user lost a life or not
        	la	$t0, tempString		#Load address of tempString to $t0
        	la	$t1, hiddenWord		#Load address of hiddenWord to $t1
        	assignString:
        	lb	$t2, 0($t1)		#Load byte from current member of hiddenWord to $t2
        	beqz	$t2, continue1		#If $t2 is null then exit the loop and continue the game
        	sb	$t2, 0($t0)		#Else store $t2 in current base of tempString 
        	addi	$t1, $t1, 1		#Go to next member of hiddenWord
        	addi	$t0, $t0, 1		#Go to next member of tempString
        	j	assignString
        	continue1:
        	#Lose condition
        	beqz	$t9, youLose		#If lives == 0; then go to youLose	
        	#Win condition, if selectedWord == hiddenWord you win
       		lw	$t0, selectedWord	#Load selectedWord to $t0
       		la	$t1, hiddenWord		#Load hiddenWord address to $t1
       		compareString:
       		lb      $t2, 0($t0)             #Get next char from selectedWord
    		lb      $t3, 0($t1)             #Get next char from hiddenWord
    		bne     $t2,$t3,continue2       #If chars are different continue game
    		beq     $t2,$zero,youWin        #If last char is null then strings are equal
    		addi    $t0,$t0,1               # point to next char
    		addi    $t1,$t1,1               # point to next char
    		j       compareString		# go to next iteration
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
    		#Print wordsMissed
    		li	$v0, 4
    		la	$a0, wordsMissed
    		syscall
    		move	$a1, $t9	# hangmanDrawings(lives)
    		jal	hangmanDrawings
    		#Ask user for input
    		askUserGuess:
    		#Print userInputPrompt
    		li	$v0, 4
    		la	$a0, userInputPrompt
    		syscall
    		#Read char from user
    		li	$v0, 12
    		syscall
    		#Verify if user's input is valid (0 to exit)
    		beq	$v0, 48, exitGame	#ASCII code of '0' is 48
    		blt	$v0, 65, invalidInput	#All the ASCII values below 65 aren't letters, invalid input
    		bgt	$v0, 90, verifyChar	#If ASCII value of char > than 90; go to verifyChar
    		addi	$v0, $v0, 32		#Else input is in uppercase, add 32 to parse it into lowercase
    		#Check if userInput is repeated
    		sb	$v0, userInput 		#Save input in userInput
    		lb	$t0, userInput		#Load userInput to $t0
       		la	$t1, usedWords		#Load address of usedWords to $t1
       		#Compare userInput with each value of usedWords
    		checkRepeated:
    		lb      $t2, 0($t1)		#Load char in base of usedWords to $t2         
    		beqz    $t2, continue3      	#If $t2 is null then exit checkRepeated
    		beq     $t0,$t2, repeatedInput  #If userInput matches $t2 then go to repeatedInput    
    		addi    $t1,$t1,1               #point to next char in usedWords
    		j       checkRepeated		#Go to next iteration
    		repeatedInput:
    		#Print repeatedInputMessage
    		li	$v0, 4
    		la	$a0, repeatedInputMessage
    		syscall
    		j	askUserGuess		#Ask user for input again
    		verifyChar:
    		#If ((ASCII value of char < 97 && > 90)) || ASCII value of char > 122) then invalidInput
    		blt	$v0, 97, invalidInput
    		bgt	$v0, 122, invalidInput
    		sb	$v0, userInput 		#Save input in userInput
    		lb	$t0, userInput		#Load userInput to $t0
       		la	$t1, usedWords		#Load address of usedWords to $t1
    		j	checkRepeated	 	#Check if input is repeated
    		invalidInput:
    		#Print invalidInputMessage
    		li	$v0, 4
    		la	$a0, invalidInputMessage
    		syscall
    		j	askUserGuess		#Ask user to enter input again
    		exitGame:
    		#Return to main
        	lw	$ra, 0($sp)		#Load address of main from stack memory
        	addi	$sp, $sp, 4		#Restore stack memory back to normal
        	jr	$ra			#Go back to main
        	#######################################################################
    		continue3:
    		#Print many newLines
    		li	$a1, 11
    		jal printManyNewLines
    		#Add char to usedWords
    		lb	$t0, userInput		#Load userInput to $t0
       		la	$t1, usedWords		#Load address of usedWords to $t1
       		#Check if member is null to add userInput
       		checkIfNull:
       		lb	$t2, 0($t1)		#Load member in base of usedWords to $t2 
       		beqz	$t2, addUsedChar	#If $t2 is null then addUsedChar
       		addi	$t1, $t1, 1		#Go to next member in usedWords
       		j	checkIfNull		#Check if member is null again
       		addUsedChar:
       		sb	$t0, 0($t1)		#Store userInput in current base of $t1	
    		#Update hiddenWord with userInput
    		lb	$t1, userInput		#Load char from userInput
    		la	$t2, hiddenWord		#Load address of hiddenWord to $t2
    		lw	$t3, selectedWord	#Load selectedWord to $t3
    		#Update hiddenWord with userInput if it matches any letter in selectedWord
    		loopUpdateHiddenWord:
    		lb	$t5, 0($t2)		#Load char from hiddenWord
    		lb	$t6, 0($t3)		#Load char from selectedWord
    		beqz	$t6, continue4		#If $t6 is null then exit loop
    		bne	$t1, $t6, nextChar	#If userInput is equal to $t6 then go to nextChar
    		sb	$t1, 0($t2)		#Else store userInput in hiddenWord
    		nextChar:
    		addi	$t2, $t2, 1		#Go to next member of hiddenWord
    		addi	$t3, $t3, 1		#Go to next member of selectedWord
    		j	loopUpdateHiddenWord	#Go to next iteration
    		#Compare tempString with hiddenWord to determine if user lost any lives
    		continue4:
    		la	$t0, tempString		#Load address of tempString in $t0
       		la	$t1, hiddenWord		#Load address of hiddenWord in $t1
    		compareString2:
    		lb      $t2, 0($t0)             #Get next char from tempString
    		lb      $t3, 0($t1)             #Get next char from hiddenWord
    		bne     $t2,$t3, gameLoop       #If different continue game
    		beq     $t2,$zero, loseLife     #If last char is null then strings are equal
    		addi    $t0,$t0,1               #point to next char
    		addi    $t1,$t1,1               #point to next char
    		j       compareString2		#Go to next iteration
    		loseLife:
    		subi	$t9, $t9, 1		#Subtract life - 1
    		#Append userInput to wordsMissed if user guessed wrong
        	la	$t1, wordsMissed	#Load adress of wordsMissed to $t1
        	lb	$t2, userInput		#Load userInput to $t2
        	appendUserInput:
        	lb	$t4, 0($t1)		#Load char from wordsMissed
        	bnez	$t4, nextChar2		#If $t4 != null; then go to nextChar2
        	sb	$t2, 0($t1)		#Add userInput to wordsMissed
        	j	gameLoop		#continue to next gameLoop iterattion
        	nextChar2:
        	addi	$t1, $t1, 1		#Go to next char in wordsMissed
        	j	appendUserInput		#Go to next iteration
    		youLose:
    		move	$a1, $t9		#Store number of lives in $a1 to pass it as a parameter
    		jal hangmanDrawings		#hangmanDrawings(lives)
    		#Print youLostMessage
    		li	$v0, 4
    		la	$a0, youLostMessage
    		syscall
    		#Print correctAnswerMessage to check
        	li    	$v0,  4
        	la	$a0, correctAnswerMessage
        	syscall
    		#Print selectedWord to check
        	li    	$v0,  4
        	lw	$a0, selectedWord
        	syscall
        	#Return to main
        	lw	$ra, 0($sp)		#Load address of main from stack memory
        	addi	$sp, $sp, 4		#Restore stack memory back to normal
        	jr	$ra			#Go back to main
        	youWin:
    		move	$a1, $t9		#Store number of lives in $a1 to pass it as a parameter
    		jal hangmanDrawings		#hangmanDrawings(lives)
    		#Print youWinMessage
    		li	$v0, 4
    		la	$a0, youWinMessage
    		syscall
        	#Return to main
        	lw	$ra, 0($sp)		#Load address of main from stack memory
        	addi	$sp, $sp, 4		#Restore stack memory back to normal
        	jr	$ra			#Go back to main
        
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
        la	$a0, hangmanDrawing_6Lives
        syscall
        jr	$ra
        fiveLives:
        li	$v0, 4
        la	$a0, hangmanDrawing_5Lives
        syscall
        jr	$ra
        fourLives:
        li	$v0, 4
        la	$a0, hangmanDrawing_4Lives
        syscall
        jr	$ra
        threeLives:
        li	$v0, 4
        la	$a0, hangmanDrawing_3Lives
        syscall
        jr	$ra
        twoLives:
        li	$v0, 4
        la	$a0, hangmanDrawing_2Lives
        syscall
        jr	$ra
        oneLive:
        li	$v0, 4
        la	$a0, hangmanDrawing_1Lives
        syscall
        jr	$ra
        zeroLives:
        li	$v0, 4
        la	$a0, hangmanDrawing_0Lives
        syscall
        jr	$ra														
        																								    																																								
        findWordLength:
      		li 	$t0, 0 			#initialize the count to 0
		lengthLoop:
		lb 	$t1, 0($a0) 		#Load the next character into t1
		beqz 	$t1, exitLenghtLoop 	#Exit if  null character
		addi 	$a0, $a0, 1 		#Increment the string pointer
		addi 	$t0, $t0, 1 		#Increment the count
		j 	lengthLoop 		#Loop
		exitLenghtLoop:
		move	$v1, $t0
		jr 	$ra
	printManyNewLines:
		#Print newLine
    		li	$v0, 4
    		la	$a0, newLine
    		syscall
    		subi	$a1, $a1, 1
    		bgt	$a1, 0, printManyNewLines
    		jr	$ra
                
                
