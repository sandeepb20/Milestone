     .global main
     .data
     .text
 main:
     pushq %rbp
     movq %rsp, %rbp
     mov %r8, %rax     # a=_v27
     mov %rax, -8(%rbp)
     mov %r9, %rbx     # b=_v52
     mov %rbx, -16(%rbp)
     mov $0, %rax 
     popq %rbp 
     ret 
format:
    .asciz  "%d\n"
