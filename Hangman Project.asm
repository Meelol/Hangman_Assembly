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
        correctWord: .space 20
        wordsGuessed: .space 20
        tempString: .space 20
        true: .word 1
        false: .word 0
        correctInput: .word
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
        newLine: .asciiz "\n"
        same: .asciiz "Strings are the same"
        notsame: .asciiz "Strings are not the same"
        
        hangmanDrawing_6Lives: .asciiz "\n |-----|\n |     |\n       |\n       |\n       |\n       |\n       |\n       |\n ---------\n"
        hangmanDrawing_5Lives: .asciiz "\n |-----|\n |     |\n O     |\n       |\n       |\n       |\n       |\n       |\n ---------\n"
        hangmanDrawing_4Lives: .asciiz "\n |-----|\n |     |\n       |\n |     |\n |     |\n       |\n       |\n       |\n ---------\n"
        hangmanDrawing_3Lives: .asciiz "\n |-----|\n |     |\n       |\n \\|   |\n |     |\n       |\n       |\n       |\n ---------\n"
        hangmanDrawing_2Lives: .asciiz "\n |-----|\n |     |\n       |\n \\|/  |\n |     |\n       |\n       |\n       |\n ---------\n"
        hangmanDrawing_1Lives: .asciiz "\n |-----|\n |     |\n       |\n \\|/  |\n |     |\n/      |\n       |\n       |\n ---------\n"
        hangmanDrawing_0Lives: .asciiz "\n |-----|\n |     |\n       |\n       |\n       |\n/\\    |\n       |\n       |\n ---------\n"
        
.text

main:
	#Print welcome message
	li $v0, 4
	la $a0, welcomeMessage
	syscall
	#Start game
	jal startGame
	#End of program
	li $v0, 10
	syscall
		
startGame: 
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	#Generate random number 0 - 19
	li $v0, 42
	la $a1, 20
	syscall
        move $s0, $a0		#$s0 = Random number
        mul $t0, $s0, 4		#Get correct wordList member
        lw $s1, wordList($t0)	#$s1 = wordList[$s0]	
       	sw $s1, selectedWord 	#selectedWord = $s1
       	
       	#Print selectedWord to check
        li $v0,  4
        lw $a0, selectedWord
        syscall
        
        #Find length of word
        lw $a0, selectedWord
        jal findWordLength
        move $s2, $v1		#$s2 = selectedWord.length
        
        #Print length
        li $v0, 1
        move $a0, $v1
        syscall
        
        li $t0, 0			#for loop counter set to 0
        
 	la $t1, correctWord
        la $t2, underscore
        
        appendUnderScoreLoop:
        	addi $t0, $t0, 1
        	lb $t3, ($t2)
        	sb $t3, ($t1)
        	addi $t1, $t1, 1
		ble $t0, $s2, appendUnderScoreLoop
        
        #Print underscore
        li $v0, 4
        la $a0, correctWord
        syscall
        	 
        #Return to main
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra
        
findWordLength:
      	li $t0, 0 		#initialize the count to zero
	loop:
		lb $t1, 0($a0) 		#load the next character into t1
		beqz $t1, exit 		#check for the null character
		addi $a0, $a0, 1 	#increment the string pointer
		addi $t0, $t0, 1 	#increment the count
		j loop 			#return to the top of the loop
	exit:
		move $v1, $t0
		jr $ra
	

	la $t4, wordsGuessed
	jal stringcompare
	
	beq $v0, $zero, equal
	li $v0, 4
	la $a0, notsame
	syscall
	j exit2
equal:
	li $v0, 4
	la $a0, same
	j exit2

stringcompare:
	lb $t5, ($s1)
	lb $t6, ($t4)
	beqz $t5,check
	beqz $t6,missmatch
	slt $t7, $t3, $t4
	bnez, $t7, missmatch
	addi $s1, $s1, 1
	addi $t4,$t4, 1
	j stringcompare

missmatch:
	addi $v0, $zero, 1
	jr $ra

check:
	bnez $6, missmatch
	add $v0, $zero, $zero
	
exit2:
	li $v0, 10
	syscall

	