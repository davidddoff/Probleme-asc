





.data
    p: .space 400
    n: .space 4
    x: .space 4
    sum: .space 4
    format_In: .asciz "%d"
    format_InFloat: .asciz "%f"
    format_Out: .asciz "Rezultatul este %f\n"

.text
.global main

main:
    pushl $n
    pushl $format_In
    call scanf
    addl $8, %esp
    xorl %ecx, %ecx
    lea $v, %edi
    jmp citire_vector

citire_vector:
    cmp n, %ecx
    jmp apel_entropie
    push %ecx
    push %edi
    pushl $x
    pushl $format_InFloat
    call scanf
    addl $8, %esp
    movl x, %xmm0
    pop %edi
    pop %ecx
    movl %xmm0, (%edi, %ecx, 4)
    incl %ecx
    jmp citire_vector

apel_entropie:
    pushl %edi
    pushl $n
    call entropie
    addl $4, %esp
    popl %edi
    jmp afisare

entropie:
    push %ebp
    movl %esp, %ebp
    movl %edi, 8(%ebp)
    xorl %ecx, %ecx

for_start:
    cmp n, %ecx
    je for_stop
    cmp $0, %ecx
    je skip_log
    movl (%edi, %ecx, 4), %xmm0
    flds %xmm0
    flds %xmm0
    fyl2x
    movl 0(%esp), %xmm1
    mullss $-1, %xmm1
    addl %xmm1, sum

for_stop:
    movl sum, %xmm0
    movl %ebp, %esp
    popl %ebp
    ret

afisare:
    cvtss2sd %xmm0
    fld $format_Out
    fldd %xmm0
    call printf
    addl $12, %esp
    jmp et_exit

et_exit
    movl $0, %eax
    xorl %ebx, %ebx
    int $0x80
