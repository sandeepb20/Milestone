      .global main
     .data
     .text
 main:
     push %rbp
     mov %rsp, %rbp      # beginFunc
     sub $16, %rsp       # stackPointer-= 16
     mov $10, %r8
     imul $5, %r8      #   _v29 = 10 * 5
     mov %r8, %rax     # a=_v29
     cmp $5, %rax
     jg t2_4t
     mov $0, %r9
     jmp t2_4f
 t2_4t:
     mov $1, %r9
 t2_4f:
     cmp $1, %r9
     jne t2_12
     push %rbx
     push %rcx
     mov $format, %rdi
     mov %rax, %rsi
     call printf
     pop %rdx
     pop %rcx
     mov %rbp, %rsp       # stackPointer = basepointer
     jmp t2_12
 t2_12:
     cmp $5, %rax
     jg t2_12t
     mov $0, %r11
     jmp t2_12f
 t2_12t:
     mov $1, %r11
 t2_12f:
     cmp $1, %r11
     jne t2_17
     mov %rax, %r12     # _v63=a
     sub $1, %rax      #   a = a - 1
     jmp t2_12
 t2_17:
     push %rbx
     push %rcx
     mov $format, %rdi
     mov %rax, %rsi
     call printf
     pop %rdx
     pop %rcx
     mov %rbp, %rsp       # stackPointer = basepointer
     mov %rbp, %rsp
     pop %rbp
     ret       # EndFunc
format:
    .asciz  "%d\n"
