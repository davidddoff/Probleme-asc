



.data
    p: .space 400
    n: .long 0
    x: .float 0.0
    sum: .float 0.0
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
    lea p, %edi

citire_vector:
    cmp n, %ecx
    je apel_entropie
    pushl %ecx
    pushl %edi
    pushl $x
    pushl $format_InFloat
    call scanf
    addl $8, %esp
    popl %edi
    popl %ecx
    flds x
    fstps (%edi, %ecx, 4)
    incl %ecx
    jmp citire_vector

apel_entropie:
    call entropie
    jmp afisare

entropie:
    pushl %ebp
    movl %esp, %ebp
    
    xorl %ecx, %ecx
    fldz    #am pus suma in st(0) pana la urma

for_start:
    cmp n, %ecx
    je for_stop
    flds (%edi, %ecx, 4)    #bag p[i] in st(0) si suma se duce in st(1)
    ftst                    #varific daca nu e cumva 0 ca sa nu fac log2(0) ca sarim in aer
    fnstsw %ax
    sahf
    jbe skip_element
    fld1                    #pun 1 in st(0) si p[i] se duce in st(1) iar suma in st(2)
    fld st(1)               #repun p[i] in st(0) si restu se duc mai jos ca am nevoie de p[i] inca o data in st(2) pentru inmultire
    fyl2x                   # fac log2(p[i]) si se salveaza in st(0)
    fmulp                   # p[i]*log2(p[i]) in st0)
    faddp                   # si acum bag in st(0) suma veche plus termenu nou (fac adunare defapt ca sa nu mai inmultesc mereu cu -1 fiecare termen)
    incl %ecx
    jmp for_start

skip_element:
    fstp %st(0)
    incl %ecx
    jmp for_start

for_stop:
    fchs                   #inumultesc suma cu -1
    movl %ebp, %esp
    popl %ebp
    ret

afisare:
    subl $8, %esp
    fstpl (%esp)
    pushl $format_Out
    call printf
    addl $12, %esp

et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
