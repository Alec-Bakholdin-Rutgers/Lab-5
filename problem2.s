j main

recursive:
    # base case
    addi t0, zero 2
    bge a0, t0, recursive_start
    jr ra
    recursive_start:

    addi sp, sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw ra, 8(sp)
    mv s0, a0

    addi a0, s0, -1
    jal recursive
    mv s1, a0

    addi a0, s0, -2
    jal recursive
    add a0, a0, s1

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 16
    jr ra

iterative:

    mv s0, a0
    addi s1, zero, 0 # i = 0
    addi s2, zero, 1 # first
    addi s3, zero, 1 # second
    addi s4, zero, 1 # next
    loop:
        bge s1, s0, iterative_return
        addi t0, zero, 1
        blt s1, t0, iterativelteone
        beq s1, t0, iterativelteone
        
        j loop

        iterativelteone: # <= 1

        j loop

    iterative_return:
    jr ra

print_integer:
    mv t0, a1

    mv a1, a0
    addi a0, zero, 1
    ecall
    addi a0, zero, 11
    addi a1, zero, '\n'
    ecall

    mv a0, a1
    mv a1, t0

    jr ra

main:
    addi t0, zero, 6

    addi a0, t0,  0
    jal recursive
    jal print_integer
    
    addi a0, t0, 0
    jal iterative
    jal print_integer