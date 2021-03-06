.data
	prompt_for_name: .asciiz "Please input your first name and last name, with a space separating the two (ex. John Doe):\n"
	reverse_result: .asciiz "\nYour name when reversed is: "
	input_name: .space 50
	reversed_name: .space 50
.text
	main:
		#prompt for input
		li $v0, 4
		la $a0, prompt_for_name
		syscall
	
		#get name from user
		li $v0, 8
		la $a0, input_name
		li $a1, 30
		syscall
		
		#this counter is used to determine specific length of string, which is then used later in reversing the string itself
		li $t4, 1		
		count_length:
			add $t1, $t0, $a0
			lb $t2, 0($t1)
			beq $t2, $zero, stop_count #determines if there is no more character to be counted
			addi $t0, $t0, 1
			addi $t3, $t3, 1 #string counter
			j count_length
		stop_count:
		sub $t3, $t3, $t4																																		
		move $s1, $t3 #storing the length in s1 guarantees that it'll be saved and not be tampered with when it is used later on in reverse_loop function							
		
		#display reverse_result instruction
		li $v0, 4
		la $a0, reverse_result
		syscall
		
		#initializing the registers to 0 guarantees no weird computation occurs when arithmetic is applied to those registers
		la $t0, reversed_name
		li $t1, 0
		li $t2, 0
		li $t3, 0
		li $t4, 1
		
		#loop prints out the text that is being transferred from input_name to reversed_name	
		reverse_loop:
			blt $s1, $zero, end_loop
			
			lb $t1, input_name($s1)
			add $t3, $t0, $t2
			sb $t1, 0($t3)
			move $a0, $t3
			syscall
			
			addi $t2, $t2, 1
			sub $s1, $s1, $t4
			
			j reverse_loop
		end_loop:									
								
		#exit program
		li $v0, 10
		syscall
		
		
