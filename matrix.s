# Asheesh Yadav 
# filename: matrix.s 
# Description: This file contains assembly lanague for the 3
                # functions copy, transpose and reverseColumns.
                # where they copy the matrix over and then rotate the matrix
                # 90 degrees by transposing it and then reversing the columns    
# Date: 3/15/2024
# Student Number: 301584113
.globl copy
# ***** Version 2 *****
copy:
# A in %rdi, C in %rsi, N in %edx

# Using A and C as pointers

# This function is not a "caller", i.e., it does not call functions. 
# It is a leaf function (a callee). 
# Hence it does not have the responsibility of saving "caller-saved" registers 
# such as %rax, %rdi, %rsi, %rdx, %rcx, %r8 and %r9.
# This signifies that it can use these registers without 
# first saving their content if it needs to use registers.

# Set up registers
    xorl %eax, %eax            # set %eax to 0
    xorl %ecx, %ecx            # i = 0 (row index i is in %ecx)

# For each row
rowLoop_copy:
    xorl %r8d, %r8d            # j = 0 (column index j in %r8d)
    cmpl %edx, %ecx            # while i < N (i - N < 0)
    jge doneWithRows_copy

# For each cell of this row
colLoop_copy:
    cmpl %edx, %r8d            # while j < N (j - N < 0)
    jge doneWithCells_copy

# Copy the element A points to (%rdi) to the cell C points to (%rsi)
    movb (%rdi), %r9b          # temp = element A points to
    movb %r9b, (%rsi)          # cell C points to = temp

# Update A and C so they now point to their next element 
    incq %rdi
    incq %rsi

    incl %r8d                  # j++ (column index in %r8d)
    jmp colLoop_copy           # go to next cell

# Go to next row
doneWithCells_copy:
    incl %ecx                  # i++ (row index in %ecx)
    jmp rowLoop_copy           # go to next row

doneWithRows_copy:                  # bye! bye!
    ret

# start of transpose
.globl transpose
transpose:
    xorl %eax, %eax            # i = 0 (row index i is in %eax)
    xorl %ecx, %ecx            # j = 0 (column index j is in %ecx)
transpose_rowLoop:
    movl %eax, %ecx             # j = i
    cmpl %esi, %eax             # if i < N    
    jge done                    # jump to end if not
transpose_colLoop:
    cmpl %esi, %ecx            # if j< N 
    jge donewithrows_T         # jump to end of row if j>=N
    movl %esi, %edx

    # Calculate the address of A[i][j] and A[j][i]

    movl %edx, %r8d            # Copy N to %r8d
    imull %eax, %r8d           # Multiply i by N
    addl %ecx, %r8d            # Add j
    movb (%rdi,%r8), %r10b     # Calculate the address of A[i][j]

    movl %edx, %r9d            # Copy N to %r9d
    imull %ecx, %r9d           # Multiply j by N
    addl %eax, %r9d            # Add i to the offset
    movb (%rdi,%r9), %r11b     # Calculate the address of A[j][i]

    # Store A[j][i] at A[i][j] and A[i][j] at A[j][i]

    movb  %r10b ,(%rdi,%r9)         # Storing A[j][i] at A[i][j]
    movb %r11b, (%rdi,%r8)          # Storing A[i][j] at A[j][i]
    incl %ecx                       # j++
    jmp transpose_colLoop           # Goto next column
donewithrows_T: 
    incl %eax                     # i++
    jmp transpose_rowLoop         # Goto next row

done:
    ret                         # Return from the function
                                # end of transpose

# start of reverseColumns
.globl reverseColumns
reverseColumns:
    xorl %ecx, %ecx           # i->(%ecx) = 0 
    xorl %r8d, %r8d           # j->(%r8d) = 0
    movl %esi, %edx
reverseColumns_rowLoop:
    xorl %r8d, %r8d           # j = 0
    cmpl %esi, %ecx           # i<n 
    jge done_R                # if i>=n go to end
reverseColumns_colLoop:
    movl %esi, %r9d           # transfer n to a temp 
    shr  $1, %r9d             # divide n by 2   
    cmpl %r9d, %r8d           # j< n/2 

    jge reverseColumns_doneWithCells # if j>=n/2 go to end of row
    
    movl %esi, %edx           # move n to a temp(since the prior n is halfed)
    imull %ecx, %edx          # Multiply i by N
    addl %r8d, %edx           # add j to the offset
    movb (%rdi, %rdx), %r9b   # Calculate the address of A[i][j]

    movl %esi, %r10d         # repeat the same process as above 
    imull %ecx, %r10d 
    addl %esi, %r10d  
    decl %r10d               # n--
    subl %r8d, %r10d         # n-j
    movb (%rdi, %r10), %r11b # Calculate the address of A[i][n-j-1]

    movb %r9b, (%rdi,%r10)           # Store A[j][i] at A[i][j]
    movb %r11b, (%rdi,%rdx)          # Store A[i][j] at A[j][i]
    incl %r8d
    jmp reverseColumns_colLoop       # Go to next column

reverseColumns_doneWithCells:
    incl %ecx                  # i++ (row index in %ecx) 
    jmp reverseColumns_rowLoop  # Go to next row

done_R: 
    ret # Return from the function
    
