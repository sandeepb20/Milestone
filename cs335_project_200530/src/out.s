      .global main
     .data
     .text
 foo:
     push %rbp
     mov %rsp, %rbp      # beginFunc
     sub $16, %rsp       # stackPointer-= 16
     mov $9, %r12     # k=9
     mov %r12, -12(%rbp)        # Set k in stack
     push %rbx
     push %rcx
     mov $format, %rdi
     mov %r12, %rsi
     call printf
     pop %rdx
     pop %rcx
     mov %rbp, %rsp       # stackPointer = basepointer
     mov %rbp, %rsp
     pop %rbp
     ret       # EndFunc
 main:
     push %rbp
     mov %rsp, %rbp      # beginFunc
     sub $16, %rsp       # stackPointer-= 16
     mov $5, %r13     # c=5
     mov %r13, -0(%rbp)        # Set c in stack
     mov $6, %r8
     imul $9, %r8      #   _v76 = 6 * 9
     mov $5, %r9
     add %r8, %r9      #   _v77 = 5 + _v76
     mov $3, %r10
     imul $4, %r10      #   _v83 = 3 * 4
     mov %r10, %r11     # _v85=_v83
     mov %r9, %r8
     add %r11, %r8      #   _v86 = _v77 + _v85
     mov %r8, %r14     # a=_v86
     mov %r14, -4(%rbp)        # Set a in stack
     push %rbx
     push %rcx
     mov $format, %rdi
     mov %r14, %rsi
     call printf
     pop %rdx
     pop %rcx
     mov %rbp, %rsp       # stackPointer = basepointer
     mov %r14, %r15     # b=a
     mov %r15, -8(%rbp)        # Set b in stack
     push %rbx
     push %rcx
     mov $format, %rdi
     mov %r15, %rsi
     call printf
     pop %rdx
     pop %rcx
     mov %rbp, %rsp       # stackPointer = basepointer
     mov $5, %r13     # c=5
     mov %r13, -0(%rbp)        # Set c in stack
     mov $69, %r14     # a=69
     mov %r14, -4(%rbp)        # Set a in stack
     mov %rbp, %rsp       # stackPointer = basepointer
     mov %r9, %r12     # wz=_v142
     mov %r12, -12(%rbp)        # Set wz in stack
     push %rbx
     push %rcx
     mov $format, %rdi
     mov %r12, %rsi
     call printf
     pop %rdx
     pop %rcx
     mov %rbp, %rsp       # stackPointer = basepointer
     mov %rbp, %rsp
     pop %rbp
     ret       # EndFunc
format:
    .asciz  "%d\n"
