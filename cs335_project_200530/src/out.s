      .global main
     .data
     .text
 main:
     mov $1, %rax     # a=1
     mov $2, %rbx     # b=2
     mov %rax, %r8
     add %rbx, %r8      #   _v38 = a + b
     mov %r8, %rcx     # c=_v38
     mov %rcx, %r9
     add $66, %r9      #   _v50 = c + 66
     mov %r9, %rdx     # d=_v50
     push %rbx
     push %rcx
     push %rdx
     mov $format, %rdi
     mov %rdx, %rsi
     call printf
     pop %rdx
     pop %rcx
     pop %rbx
format:
    .asciz  "%d\n"
