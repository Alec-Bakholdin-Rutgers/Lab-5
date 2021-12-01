j main

output: # args: (int *array, int length)
    mv t0, a0               # t0 = array (int*)
    mv t1, a1               # t1 = length (int)
    addi t2, zero, 0        # int i = 0
    output_loop:
        bge t2, t1, output_endloop    # while i < length
        addi a0, zero, 1    # set ecall to print_integer
        lw a1, 0(t0)        # print array[i]
        ecall

        addi a0, zero, 11   # set ecall to print_char
        addi a1, zero, ' ' # print '\n'
        ecall

        addi t0, t0, 4      # array++
        addi t2, t2, 1      # i++
        j output_loop


    output_endloop:
    addi a0, zero, 11
    addi a1, zero, '\n'
    ecall
    jr ra

main:
    la a1, array
    lw a2, array_len

    lw s0, odd_negatives
    addi s1, zero, 0
    lw s2, even_negatives
    addi s3, zero, 0
    lw s4, zeros
    addi s5, zero, 0

    addi t0, zero, 0 # j = 0
    loop:
        slli t1, t0, 2 # t1 = j*4
        add t1, a1, t1 # t1 = array + 4j
        lw t1, 0(t1) # t1 = array[t1]
        
        blt t1, zero, ltzero
        beq t1, zero, zero
        j continue

        zero:
        slli t2, s5, 2 # zero_counter * 4
        add t2, s4, t2 # t2 = zeros + zero_counter*4
        sw zero, 0(t2) # zeros[zero_counter] = 0
        addi s5, s5, 1 # zero_counter++
        j continue

        ltzero:
        andi t2, t1, 1 # determine if even
        beq t2, zero, even
        # odds here
        slli t2, s1, 2 # odd_counter * 4
        add t2, s0, t2 # t2 = odds + odd_counter*4
        sw t1, 0(t2) # odds[odd_counter] = array[j]
        addi s1, s1, 1 # odd_counter++
        j continue
        even:
        slli t2, s3, 2 # even_counter * 4
        add t2, s2, t2 # t2 = evens + even_counter*4
        sw t1, 0(t2) # evens[even_counter] = array[j]
        addi s3, s3, 1 # even_counter++

        continue:
            addi t0, t0, 1 # j++
            bge t0, a2, endloop # while j < array_len
            j loop
    endloop:
        
    lw a0, odd_negatives
    mv a1, s1
    jal output

    lw a0, even_negatives
    mv a1, s3
    jal output
        
    lw a0, zeros
    mv a1, s5
    jal output

.data
    odd_negatives: .word 0x40000004
    even_negatives: .word 0x20000002
    zeros: .word 0x50000000
    array: .word -8 -6 -4 0 22 -1
    array_len: .word 6