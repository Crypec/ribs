	#+ BITTE NICHT MODIFIZIEREN: Vorgabeabschnitt
	#+ ------------------------------------------

.data

	# Beispiel-Irrgarten-Arrays maze1, maze2, maze3:
maze1:
	.byte 0x08, 0x07, 0x06, 0x05, 0x04, 0x05, 0x06, 0x07
	.byte 0x09, 0x08, 0xFF, 0xFF, 0x03, 0x04, 0xFF, 0x08
	.byte 0x0A, 0xFF, 0xFF, 0x01, 0x02, 0x03, 0xFF, 0x09
	.byte 0x0B, 0x0C, 0xFF, 0xFF, 0xFF, 0x04, 0xFF, 0x0A
	.byte 0x0C, 0x0D, 0x0E, 0x0F, 0xFF, 0xFF, 0xFF, 0x0B
	.byte 0x0D, 0x0E, 0xFF, 0x10, 0xFF, 0x0E, 0x0D, 0x0C
	.byte 0x0E, 0x0F, 0xFF, 0xFF, 0xFF, 0x0F, 0x0E, 0x0D
	.byte 0x0F, 0x10, 0x11, 0x12, 0x11, 0x10, 0x0F, 0x0E
maze2:
	.byte 0x0F, 0x10, 0x11, 0x12, 0x13, 0xFF, 0x00, 0x00
	.byte 0x0E, 0xFF, 0x12, 0xFF, 0x12, 0xFF, 0xFF, 0xFF
	.byte 0x0D, 0xFF, 0x13, 0xFF, 0x11, 0xFF, 0x00, 0x00
	.byte 0x0C, 0xFF, 0xFF, 0xFF, 0x10, 0xFF, 0x00, 0x00
	.byte 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0xFF, 0xFF, 0xFF
	.byte 0x0A, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x02, 0x03
	.byte 0x09, 0xFF, 0x07, 0xFF, 0x05, 0xFF, 0x01, 0x02
	.byte 0x08, 0x07, 0x06, 0x05, 0x04, 0x03, 0x02, 0x03
maze3:
	.byte 0x0B, 0x0A, 0x09, 0x08, 0x07, 0x08, 0x09, 0x0A
	.byte 0x0C, 0xFF, 0xFF, 0xFF, 0x06, 0xFF, 0xFF, 0x09
	.byte 0x0D, 0x0E, 0xFF, 0x04, 0x05, 0x06, 0xFF, 0x08
	.byte 0x0E, 0x0F, 0xFF, 0x03, 0xFF, 0x05, 0x06, 0x07
	.byte 0x0D, 0xFF, 0xFF, 0x02, 0xFF, 0x04, 0xFF, 0x08
	.byte 0x0C, 0x0D, 0xFF, 0x01, 0x02, 0x03, 0xFF, 0x09
	.byte 0x0B, 0xFF, 0xFF, 0xFF, 0xFF, 0x04, 0xFF, 0x0A
	.byte 0x0A, 0x09, 0x08, 0x07, 0x06, 0x05, 0xFF, 0x0B

	# Lookup-Tabelle fuer Hilfsfunktion neighbor (siehe unten):
test_neighbor_lut:
	.word 0x0000f7fe, 0x00fff6fd, 0x00fef5fc, 0x00fdf4fb, 0x00fcf3fa, 0x00fbf2f9, 0x00faf1f8, 0x00f9f000
	.word 0xff00eff6, 0xfef7eef5, 0xfdf6edf4, 0xfcf5ecf3, 0xfbf4ebf2, 0xfaf3eaf1, 0xf9f2e9f0, 0xf8f1e800
	.word 0xf700e7ee, 0xf6efe6ed, 0xf5eee5ec, 0xf4ede4eb, 0xf3ece3ea, 0xf2ebe2e9, 0xf1eae1e8, 0xf0e9e000
	.word 0xef00dfe6, 0xeee7dee5, 0xede6dde4, 0xece5dce3, 0xebe4dbe2, 0xeae3dae1, 0xe9e2d9e0, 0xe8e1d800
	.word 0xe700d7de, 0xe6dfd6dd, 0xe5ded5dc, 0xe4ddd4db, 0xe3dcd3da, 0xe2dbd2d9, 0xe1dad1d8, 0xe0d9d000
	.word 0xdf00cfd6, 0xded7ced5, 0xddd6cdd4, 0xdcd5ccd3, 0xdbd4cbd2, 0xdad3cad1, 0xd9d2c9d0, 0xd8d1c800
	.word 0xd700c7ce, 0xd6cfc6cd, 0xd5cec5cc, 0xd4cdc4cb, 0xd3ccc3ca, 0xd2cbc2c9, 0xd1cac1c8, 0xd0c9c000
	.word 0xcf0000c6, 0xcec700c5, 0xcdc600c4, 0xccc500c3, 0xcbc400c2, 0xcac300c1, 0xc9c200c0, 0xc8c10000

test_rueckgabe: .asciiz "Rueckgabewert: "
test_print_maze_str_header: .asciiz "Irrgarten:\n    0  1  2  3  4  5  6  7\n   -------------------------\n0 | "

.text

.eqv SYS_PUTSTR 4
.eqv SYS_PUTCHAR 11
.eqv SYS_PUTINT 1
.eqv SYS_EXIT 10

main:
	la $t0, test_maze_select
	lw $a0, 0($t0)
	la $t0, test_maze_destination
	lw $a1, 0($t0)
	jal trace_back
	
	move $t0, $v0
	li $v0, SYS_PUTSTR
	la $a0, test_rueckgabe
	syscall
	
	li $v0, SYS_PUTINT
	move $a0, $t0
	syscall
	
	li $v0, SYS_PUTCHAR
	li $a0, '\n'
	syscall

	la $t0, test_maze_select
	lw $a0, 0($t0)
	jal print_maze
	
	li $v0, SYS_EXIT
	syscall

	# Hilfsfunktion neighbor, arbeitet mittels Lookup-Tabelle:
	# Parameter $a0: Ausgangsfeld-Index
	#           $a1: Richtung (0=oben, 1=links, 2=unten, 3=rechts)
	# Rueckgabewert $v0: Nachbarfeld-Index
neighbor: 
	sll $a0, $a0, 2
	andi $a1, $a1, 3
	xori $a1, $a1, 3
	or $a0, $a0, $a1
	andi $a0, $a0, 255
	la $t0, test_neighbor_lut
	add $t0, $a0, $t0
	lbu $t0, 0($t0)
	xori $t0, $t0, 255
	sll $t0, $t0, 24
	sra $v0, $t0, 24
	jr $ra

	# Funktion print_maze: wird von dem Vorgabecode aus aufgerufen und gibt den in $a0
	# uebergebene Irrgarten als Text aus.
	# Parameter $a0: Irrgarten-Array
	# Rueckgabewert: keiner
print_maze:
	# $t0: position, $t1: index
	move $t0, $a0
	move $t1, $zero

	li $v0, SYS_PUTSTR
	la $a0, test_print_maze_str_header
	syscall
	
print_maze_loop:
	# $t2: zero if end of line
	and $t2, $t1, 7
	xor $t2, $t2, 7

	# $t3: current field, $t4: next field (or zero, if end of line)
	lbu $t3, 0($t0)
	move $t4, $zero
	beq $t2, $zero, print_maze_dont_read_next
	lbu $t4, 1($t0)
print_maze_dont_read_next:
	
	beq $t3, 0, print_maze_empty
	beq $t3, 255, print_maze_barr
	beq $t3, 254, print_maze_route
	
	ble $t3, 99, print_maze_not_too_big
	li $t3, 99
print_maze_not_too_big:
	
	li $v0, SYS_PUTINT
	move $a0, $t3
	syscall
	
	li $v0, SYS_PUTCHAR
	li $a0, ' '
	syscall
	bge $t3, 10, print_maze_single_space
	syscall
print_maze_single_space:
	j print_maze_entry_end

print_maze_empty:
	li $v0, SYS_PUTCHAR
	la $a0, ' '
	syscall
	syscall
	syscall
	j print_maze_entry_end

print_maze_route:
	la $a0, '+'
	j print_maze_barr_or_route
print_maze_barr:
	la $a0, 'X'
print_maze_barr_or_route:
	li $v0, SYS_PUTCHAR
	syscall
	syscall
	beq $t4, $t3, print_maze_long
	la $a0, ' '
print_maze_long:
	syscall
	j print_maze_entry_end

print_maze_entry_end:   
	# print newline at end of row
	bne $t2, $zero, print_maze_no_nl
	li $v0, SYS_PUTCHAR
	li $a0, '\n'
	syscall

	bge $t1, 63, print_maze_loop_end
			
	li $v0, SYS_PUTINT
	srl $a0, $t1, 3
	addi $a0, $a0, 1
	syscall
	
	li $v0, SYS_PUTCHAR
	li $a0, ' '
	syscall 
	li $a0, '|'
	syscall 
	li $a0, ' '
	syscall 
print_maze_no_nl:

	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j print_maze_loop

print_maze_loop_end:
	li $v0, SYS_PUTCHAR
	li $a0, '\n'
	syscall     

	jr $ra

	#+ BITTE VERVOLLSTAENDIGEN: Persoenliche Angaben zur Hausaufgabe 
	#+ -------------------------------------------------------------

	# Vorname:
	# Nachname:
	# Matrikelnummer:
	
	#+ Loesungsabschnitt
	#+ -----------------

.data
	test_maze_select: .word maze1
	test_maze_destination: .word 43

.text

trace_back:
	# store current_index in $t0	
	move $t0, $a1
	
	# store maz in $t1
	move $t1, $a1
main_loop:	
	# $t2 = maze[current_index]
	lw $t2, $a0($t0)

	# if maze[current_index] == 1 return step_count
	beq $t2, 1, return_and_exit_with_step_count

	li $a0, 0 # direction left
	move $a1, $t2 # current_index
	move $a2, $t0 # maze
	jal update_current_pos


	li $a0, 1 # direction right
	move $a1, $t2 # current_index
	move $a2, $t0 # maze
	jal update_current_pos

	li $a0, 2 # direction up
	move $a1, $t2 # current_index
	move $a2, $t0 # maze
	jal update_current_pos

	li $a0, 3 # direction down
	move $a1, $t2 # current_index
	move $a2, $t0 # maze
	jal update_current_pos

	move $t0, $v0
	
	li $t7, 244
	sw $t7, $a0($t0)
	j main_loop

return_and_exit_with_step_count:
	lw $v0, $a0($a1)
	jr $ra


# u8 update_current_pos(u8 direction, u8 current_index, u8* maze)
update_current_pos:
	move $t4, $a1

	jal neighbor 
	beq $v0, -1 return_current_index
	
	lw $t5, $a2($v0)
	lw $t6, $a2($t4)
	blt $t5, $t6, update_current_index_and_return

	move $v0, $t4
	jr $ra

update_current_index_and_return:
	# new index is already in $v0
	jr $ra

return_current_index:
	move $v0, $t4
	jr $ra	
