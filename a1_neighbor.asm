	#+ BITTE NICHT MODIFIZIEREN: Vorgabeabschnitt
	#+ ------------------------------------------

.data

test_neighbor_header: .asciiz "\nPos\toben\tlinks\tunten\trechts\n---\t----\t-----\t-----\t------\n"

.text

.eqv SYS_PUTSTR 4
.eqv SYS_PUTCHAR 11
.eqv SYS_PUTINT 1
.eqv SYS_EXIT 10

main:   
	li $v0, SYS_PUTSTR
	la $a0, test_neighbor_header
	syscall
	
	move $s0, $zero

test_neighbor_loop_position:

	li $v0, SYS_PUTINT
	move $a0, $s0
	syscall
	
	li $v0, SYS_PUTCHAR
	li $a0, '\t'
	syscall
	
	move $s1, $zero

test_neighbor_loop_direction:
	move $v0, $zero
	move $a0, $s0
	move $a1, $s1
	jal neighbor
	
	move $a0, $v0   
	li $v0, SYS_PUTINT
	syscall
	
	li $v0, SYS_PUTCHAR
	li $a0, '\t'
	syscall
	
	addi $s1, $s1, 1
	blt $s1, 4, test_neighbor_loop_direction

	li $v0, SYS_PUTCHAR
	li $a0, '\n'
	syscall

	addi $s0, $s0, 1
	blt $s0, 64, test_neighbor_loop_position

	li $v0, SYS_EXIT
	syscall

	#+ BITTE VERVOLLSTAENDIGEN: Persoenliche Angaben zur Hausaufgabe 
	#+ -------------------------------------------------------------

	# Vorname: Simon
	# Nachname: Kunz
	# Matrikelnummer: 470255
	
	#+ Loesungsabschnitt
	#+ -----------------

neighbor:
	# decode packed position into x ($t0) and y ($t1) cordinates

	# check for bogus position
	bgt $a0, 63, err_exit
	
	# and with 0b0000_0111 bitmask to extract the last 3 bits of the position
	andi $t0, $a0, 7

	# shift 3 bits to the right to get the y cordinate from the upper 3 bits
	srl $t1, $a0, 3
	

	# jump to case for direction
	beq $a1, 0, case_direction_up
	beq $a1, 1, case_direction_left
	beq $a1, 2, case_direction_down
	beq $a1, 3, case_direction_right
	bgt $a1, 3, case_direction_err

case_direction_up:
	# if y == 0 
	beq $t1, 0, err_exit,
	li $t3, 1
	sub $t1, $t1, $t3
	j calc_index_and_return

case_direction_down:
	# if y > 7
	bge $t1, 7, err_exit
	addi $t1, $t1, 1
	j calc_index_and_return

case_direction_left:
	# if x == 0
	beq $t0, 0, err_exit
	
	li $t3, 1
	sub $t0, $t0, $t3
	j calc_index_and_return
		
case_direction_right:
	# if x >= 7	
	bge $t0, 7, err_exit

	addi $t0, $t0, 1
	j calc_index_and_return

case_direction_err: 
	j err_exit

err_exit:
	li $v0, -1 
	jr $ra

calc_index_and_return:
	# index = y * 8 + x
	mul $t2, $t1, 8
	addu $v0, $t2, $t0
	jr $ra
