#Paul Travis, CS331 HW 5
#This program compares two dates stored in memory and overrites the older date with the newer one
#Dates to be stored in memory at the following addresses when the program begins
#
#0x10010004
#0x10010008

lui $s0,0x1001 #ori isn't needed in this case as the remaining bytes are set to 0.

# 0x010F0903 #date 1: 3 September, 2015 | a
# 0x01120404 #date 2: 4 April, 2018     | b

lw $t0, 4($s0) # store the first date at 0x10010004  | to be treated as a
lw $t1, 8($s0) # store the second date at 0x10010008 | to be treated as b

beq $t0, $t1, done # if (a == b) goto done

#not $t1, $t1 # ~b
#addi $t1, $t1, 1 # b + 1 
#add $t2, $t1, $t0 # a + b (aka subtract)
sub $t2, $t0, $t1
srl $t2, $t2, 31

beq $t2, $0, bLssThanA # if (b < a) goto bLssThanA
  
  sw $t1, 4($s0) #store a in b
  
j done # goto end

bLssThanA:

  sw $t0, 8($s0)
   
j done #goto end, technically unecessary, but keeps things neaterish

done: