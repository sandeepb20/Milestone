      .global main
     .data
     .text
 main:
     push %rbp
     mov %rsp, %rbp      # beginFunc
     sub $16, %rsp       # stackPointer-= 16
     mov %rax, -0(%rbp)        # Set c in stack
     mov $5, %rax     # c=5
     mov %rax, %r8
     imul $3, %r8      #   _v31 = c * 3
     mov $5, %r9
     add %r8, %r9      #   _v32 = 5 + _v31
     mov %rbx, -4(%rbp)        # Set a in stack
     mov %r9, %rbx     # a=_v32
     mov %rcx, -8(%rbp)        # Set b in stack
     mov %rbx, %rcx     # b=a
     cmp $5, %rbx
     jg t2_8t
     mov $0, %r10
     jmp t2_8f
 t2_8t:
     mov $1, %r10
 t2_8f:
     cmp $1, %r10
     jne t2_16
     push %rbx
     push %rcx
     mov $format, %rdi
     mov %rbx, %rsi
     call printf
     pop %rdx
     pop %rcx
     mov %rbp, %rsp       # stackPointer = basepointer
     jmp t2_16
 t2_16:
     cmp $5, %rbx
     jg t2_16t
     mov $0, %r12
     jmp t2_16f
 t2_16t:
     mov $1, %r12
 t2_16f:
     cmp $1, %r12
     jne t2_26
     mov %rbx, %r13     # _v82=a
     sub $1, %rbx      #   a = a - 1
     push %rbx
     push %rcx
     mov $format, %rdi
     mov %rbx, %rsi
     call printf
     pop %rdx
     pop %rcx
     mov %rbp, %rsp       # stackPointer = basepointer
     jmp t2_16
 t2_26:
     mov %rbp, %rsp
     pop %rbp
     ret       # EndFunc
format:
    .asciz  "%d\n"
