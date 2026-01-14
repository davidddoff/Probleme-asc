#EX 1 --- LAB 0x01



.data
    x: .space 4
    sum: .space 4
    n: .space 4
    v: .space 400    #am pus 400 ca sa am loc de 100 de numere in vector a cate 4B fiecare
    format_In: .asciz "%d\n"
    format_Out: .asciz "In vector sunt %d numere perfecte\n"

.text

.global main

main:

    push $n
    push $format_In
    call printf
    addl $8, %esp
    xorl %ecx, %ecx
    lea $v, %edi
    xorl %ebx, %ebx
    jmp citire_vector

citire_vector:

    cmpl n, %ecx
    je et_afisare
    push %ebx
    push %edi
    push %ecx
    push $x
    push $format_In
    call scanf
    movl x, %eax
    movl %eax, (%edi, %ecx, 4)
    add $8, %esp
    push %eax
    call numar_perfect
    addl $4, %esp
    pop %ecx
    pop %edi
    pop %ebx
    cmp $0, %eax
    je perfect
    jne inperfect
perfect:
    incl %ebx
    incl %ecx
    jmp citire_vector
inperfect:
    incl %ecx
    jmp citire_vector
numar_perfect:
    movl $0, sum
    push %ebp
    movl %esp, %ebp
    movl 8(%ebp), %eax
    xorl %ecx, %ecx
    addl $1, %ecx
    movl %eax, %ebx
    xorl %edx, %edx
    divl $2
divizori_start:
    cmpl %ecx, %eax
    je divizori_stop
    push %eax
    movl %ebx, %eax
    xorl %edx, %edx
    divl %ecx
    pop %eax
    incl %ecx
    cmpl $0, %edx
    jne divizori_start
    subl $1, %ecx
    addl %ecx, sum
    incl %ecx
    jmp divizori_start

divizori_stop:
    cmpl sum, %ebx
    je corect
    movl %ebp, %esp
    popl %ebp
    ret

corect:
    xorl %eax, %eax
    movl %ebp, %esp
    pop %ebp
    ret

et_afisare:
    push %ebx
    push $format_Out
    call printf
    addl $8, %esp

et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
