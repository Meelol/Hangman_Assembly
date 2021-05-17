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
		li	$v0, 4
		la	$a0, welcomeMessage
		syscall
		#Start game
		jal startGame
		#End of program
		li	$v0, 10
		syscall
		
	startGame:
        