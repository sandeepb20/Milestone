      .global main
     .data
     .text
 main:
     mov $1, %rax     # a=1
     mov $2, %rbx     # b=2
     mov $0, %rcx     # c=0
     cmp %rbx, %rax
     je t2_5t
     mov $0, %r8
     jmp t2_5f
 t2_5t:
     mov $1, %r8
 t2_5f:
     cmp $1, %rbx
     jg t2_6t
     mov $0, %r9
     jmp t2_6f
 t2_6t:
     mov $1, %r9
 t2_6f:
     cmp $9, %rcx
     jle t2_7t
     mov $0, %r10
     jmp t2_7f
 t2_7t:
     mov $1, %r10
 t2_7f:
     cmp $0, %r9
     je t2_8t
     cmp $0, %r10
     je t2_8t
     mov $1, %r11
     jmp t2_8f
 t2_8t:
     mov $0, %r11
 t2_8f:
     cmp $1, %r8
     je t2_9t
     cmp $1, %r11
     je t2_9t
     mov $0, %r12
     jmp t2_9f
 t2_9t:
     mov $1, %r12
 t2_9f:
     cmp $1, %r12
     jne t2_13
     mov $0, %rcx     # c=0
 t2_13:
     mov $1, %rcx     # c=1
 t2_14:
format:
    .asciz  "%d\n"
