#Author: Paul Travis
#Created: 19/04/2018
#Desc: Recreates the functionality of the multiplication operator, but with half the reason to exist, and with double the jokes.
#      Loads the contents of four seperate addresses and then proceeds to "multiply" them together.

lui $s1, 0x1001 #Fill $s1 with the memory address to start writing to.
lw $a0, 0($s1) #Load a from memory address offset 0 into $a0
lw $a1, 4($s1) #Load b from memory address offset 4 into $a1
jal multiply #send to multiply function.

bne $v1, $0, Skip #If Flag is set to anything other than zero goto End
sw $v0, 0($s1) #If not flagged, store c back into memory location of most recent a

Skip:
lw $a0, 8($s1) #Load a from memory address offset 8 into $a0
lw $a1, 0xC($s1) #load b from memory address offset 0xC into $a1
jal multiply #send to multiply function.

sw $v0, 8($s1) #store c back into memory location of most recent a
sw $v1, 0x14($s1) #store flag into memory offset 0x14

j End #End It All, sadly doesn't also end unenjoyable experiences when jumped to....

#Takes Two Arguments $a0, $a1 (a and b respectively). $a1 (b) must be within the range 15 > b > -15 else $v0 will return 0, and $v1 will return 1.
#If provided numbers are within range, the function will then test them for negativity. If both #'s are positive, function will
#add a + a, b number of times. If a is negative or b is negative, the function will subtract a - a, b number of times.
multiply:
  addi, $t1, $0, -15 #Set t1 = -15
  addi, $t2, $0, 15 #Set t2 = 15
  #slt $t0, $a1, $t1 #Check If b is less than -15
  sub $t0, $a1, $t1
  srl $t0, $t0, 31
  #
  bne $t0, $0, OutOfBounds #If b is less than -15 return.
  #slt $t0, $t2, $a1 #Check if b is greater than 15
  sub $t0, $t2, $a1
  srl $t0, $t0, 31
  #
  bne $t0, $0, OutOfBounds #if b is greater than 15 reuturn.
  add $t1, $0, $0 #Zero Out t1, i
  add $t2, $0, $0 #Zero Out t2, c
  
  #Check if A Or B is negative
  #slt $t0, $a0, $0 #Check if a is less than 0
  sub $t0, $a0, $0
  srl $t0, $t0, 31
  #
  bne $t0, $0, NegativeA #if (a < 0) goto NegativeA
  #slt $t0, $a1, $0 #Check if b is less than 0
  sub $t0, $a1, $0
  srl $t0, $t0, 31
  #
  bne $t0, $0, continueNegative #if (b < 0) goto continueNegative
  j continuePositive

  NegativeA:
    #slt $t0, $a1, $0 #Check if b is less than 0
    sub $t0, $a1, $0
    srl $t0, $t0, 31
    #
    beq $t0, $0, NegatizeB #if (b > 0) goto NegatizeB 
    j continueNegative #b is already negative, goto continueNegative
  NegatizeB:
    sub $a1, $0, $a1 #b = 0 - b
    j continueNegative #goto continueNegative, technically unecessary in current structure, but allows for restructuring if necessary.
    
continueNegative:
  beq $t1, $a1, done#If (i == b) goto done
  sub $t2, $t2, $a0 #c -= a
  addi $t1, $t1, -1 #i--
  j continueNegative
  
continuePositive: 
  beq $t1, $a1, done #If (i == b) goto done
  add $t2, $t2, $a0  #c += a 
  addi $t1, $t1, 1   #i++
  j continuePositive

done:
  add $v0, $0, $t2 #Return C
  add $v1, $0, $0  #Set Flag to 0
  j return

OutOfBounds:
  addi $v0, $0, 0 #Zero Out Result
  addi $v1, $0, 1 #Set Flag to 1
  j return
    
return:
  jr $ra #Return To Sender (Address Unkown.... I'll Let Myself Out Now)

End: #This is the End, my Friend, the end.