.text
.globl main

main:
   subu $sp, $sp, 32
   sw $ra,20($sp)
   sw $fp, 16($sp)
   addiu $fp,$sp,28 


beginning:   
   add $s0,$zero,$zero
   add $s1,$zero,$zero   
   add $s2,$zero,$zero
   add $s3,$zero,$zero
   add $s4,$zero,$zero
   add $s5,$zero,$zero            
   add $s6,$zero,$zero   
   add $s7,$zero,$zero   
   la $a0,STR3
   li $v0,4
   syscall
      
   la $v0,5      
   syscall
   
   beq $v0,$zero,Fixed         
       j Float        
 Fixed:                    
   la $a0,STR1
   li $v0,4
   syscall
   
   li $v0, 5
   syscall
  
   add $s0,$s0,$v0
   
   la $a0,STR2
   li $v0,4
   syscall
   
   li $v0,5
   syscall
   
   add $s1,$s1,$v0
   
   srlv $s3,$s0,$s1

   loop:
       beq $s3,$zero,halt
       srl $s3,$s3,1
       addi $s2,$s2,1
       j loop
   halt:
   
   addi $t0,$t0,32
   sub $s4,$t0,$s1
   sllv $s4,$s0,$s4
  
   add $s5, $zero, $zero
  
   loop2:
      beq $s4,$zero,halt2
      sll $s4,$s4,1
      addi $s5,$s5,1
       j loop2
   halt2:
   
   addi $s3,$s2,126
   sll $s3,$s3,23

   add $s4,$s2,$s5

   loop3:
      andi $s7,$s0,0x80000000
      bne $s7,$zero,halt3
      sll $s0,$s0,1
      j loop3
   halt3:   

   sll $s0,$s0,1
   srl $s6,$s0,9
   
   or  $s0,$s6,$s3
   
   
      mtc1  $s0, $f12   # moves integer to floating point register
      li    $v0, 2      # syscall 2 (print_float)
      syscall           # outputs the float at $f12
   
   j beginning
   
   Float:
   
   la $a0,STR4
   li $v0, 4
   syscall
   
   li $v0, 6
   syscall
   
   mfc1 $t3,$f0
   
   add $t0, $t3,$zero #holds original
   add $s4, $t3,$zero

   la $a0,STR2
   li $v0,4
   syscall
   
   li $v0,5
   syscall
   
   add $s2, $v0,$zero
   
   
   srl $t0,$t0,23
   subi $t1,$t0,127
   add $s1,$t1,$zero  #holds mantissa
   sll $s5,$s4,9
      
   loop5:#shifts mantissa amount to left
      beq $t1,$zero,halt5
      sll $s5,$s5,1
      addi $t1,$t1,-1
      j loop5
 
    halt5:
    add $s1,$zero,$zero 
   loop6:#checks how many number there is after the decimal
      beq $s5,$zero,halt6
      sll $s5,$s5,1
      addi $s1,$s1,1  #holds how many number after decimal
       j loop6
   halt6:
   
   sll $s6,$s4,8
   ori $s6, $s6,0x80000000
   
   loop7:#shifts right til lsb is 1
      andi $s7,$s6,0x00000001
      bne $s7,$zero,halt7
      srl $s6,$s6,1
      j loop7
   halt7:

   sub $t1,$s2,$s1
   
   loop8:
    beq $t1,$zero,halt8
    addi $t1,$t1,-1
    sll $s6,$s6,1
    j loop8
   
   halt8:
   

   li $v0,1
   add $a0,$s6,$zero
   syscall
   
   
     
   
   j beginning
   
   
DONE:

.data
 
STR1:
   .asciiz "Enter an Integer:\n"
   
STR2:
   .asciiz "Enter Decimal location: \n"
   
STR3:
   .asciiz "\n0 for Fixed to Float, 1 for Float to Fixed: \n"
   
STR4:
   .asciiz "Enter a Float: \n"
