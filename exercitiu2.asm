#Ex 9 --- Lab 0x01



#Prima varianta e fara recursivitate ca uitasem

.data
    n: .space 4
    a: .long 0
    b: .long 1
    c: .long 1
    format_In: .asciz "%d"
    format_Out: .asciz "Termenul %d din sirul lui Fibonacci este %d"

.text
.global main

main:
    movl $1, n
    push $n
    push $format_In
    call scanf
    addl $8, %esp
    movl n, %eax
    cmp $3, %eax
    jel gasit_rapid
    xorl %ecx, %ecx
    addl $3, %ecx   #verificam incepand de la al 4-lea termen 
    push %ecx
    call termen
    addl $4, %esp
    push $n
    push %eax
    push $format_Out
    call printf
    addl $12, %esp
    jmp et_exit


termen:
    push %ebp
    movl %esp, %ebp
    movl %ecx, 8(%ebp)
for_start:
    cmp n, %ecx
    je sfarsit_for
    movl b, a           #a<--b
    movl c, b           #b<--c
    add a, c            #c=a+b dar cum b e fostul c facem doar c=c+a
    incl %ecx
    jmp for_start
    
sfarsit_for:
    movl c, %eax
    movl %ebp, %esp
    pop %ebp
    ret

gasit_rapid:
    cmp $2, %eax   # stiu deja ca e mai mic sau egal cu 3 si cum al 3 lea si al 2 lea termeni sunt egali nu conteaza cat e n pentru ca e acelasi rezultat
    jl poate_unu   # daca e mai mic decat 2 singura sansa mai e sa fie primul termen 
    push $n
    push $c
    push $format_Out
    call printf
    addl $12, %esp 
    jmp et_exit
poate_unu:
    push $n
    push $a
    push $format_Out
    call printf
    addl $12, %esp 
    jmp et_exit
et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80





# Varianta recursiva

.data
    n: .space 4
    a: .long 0
    b: .long 1
    c: .long 1
    format_In: .asciz "%d"
    format_Out: .asciz "Al %d-lea element din sirul lui Fibonacci este %d.\n"

.text
.global main

main:
    pushl $n
    pushl $format_In
    call scanf
    addl $8, %esp
    pushl n
    call termen
    addl $4, %esp
    pushl %eax       
    pushl n          
    pushl $format_Out
    call printf
    addl $12, %esp
    jmp et_exit
termen:
    pushl %ebp
    movl %esp, %ebp
    movl 8(%ebp), %eax   
    cmpl $0, %eax
    je gata
    cmpl $1, %eax
    je gata
    pushl %ebx
    decl %eax
    pushl %eax
    call termen
    addl $4, %esp
    movl %eax, %ebx       
    movl 8(%ebp), %eax
    subl $2, %eax
    pushl %eax
    call termen
    addl $4, %esp
    addl %ebx, %eax       
    popl %ebx

gata:
    movl %ebp, %esp
    popl %ebp
    ret

et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
