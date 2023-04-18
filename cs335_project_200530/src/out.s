     .global main
     .data
     .text
 main:
     pushq %rbp
     movq %rsp, %rbp
     mov $1, %rax     # a=1
     mov %rax, -4(%rbp)
     mov $2, %rbx     # b=2
     mov %rbx, -8(%rbp)
     mov %rax, %r8
     sub $85, %r8      #   _v34 = a - 85
     mov %r8, %rcx     # c=_v34
     mov %rcx, -12(%rbp)
     mov $format, %rdi
     mov %rcx, %rsi
     call printf
     mov %rsi, %r9
     mov $0, %rax 
     popq %rbp 
     ret 
format:
    .asciz  "%d\n"
