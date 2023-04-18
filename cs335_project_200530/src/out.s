      .global main
     .data
     .text
 main:
     mov $10, %rax     # a=10
     mov $2, %rbx     # b=2
     mov $0, %rcx     # c=0
 t2_5:
     cmp $5, %rax
     jg t2_5t
     mov $0, %r8
     jmp t2_5f
 t2_5t:
     mov $1, %r8
 t2_5f:
     cmp $1, %r8
     jne t2_10
     mov %rax, %r9     # _v48=a
     sub $1, %rax      #   a = a - 1
     jmp t2_5
 t2_10:
     ret 
format:
    .asciz  "%d\n"
