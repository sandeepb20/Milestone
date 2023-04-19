      .global main
     .data
     .text
 main:
     push %rbp
     mov %rsp, %rbp      # beginFunc
     mov $800, %r8     # _t1=800
     mov %r8, %rdi     # Load Param _t1
     call malloc
     mov %rax, %r9     # Get Refernce from return reg in  _v35
     mov %r9, %r12     # a=_v35
     mov %r12, -8(%rbp)        # Set a in stack
     mov $0, %r10     # _v45=0
     mov %r10, %r10
     imul $10, %r10      #   _v45 = _v45 * 10
     mov %r10, %r10
     add $0, %r10      #   _v45 = _v45 + 0
     mov %r11, %r13     # x=_v51
     mov %r13, -16(%rbp)        # Set x in stack
     mov -8(%rbp), %rdx
     mov %r10, %rax
     mov %r11, (%rdx,%rax,8) 
     mov %r11, %r13     # x=_v51
     mov %r13, -16(%rbp)        # Set x in stack
     sub $16, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r14       # Load x from stack
     mov %r14, %rsi
     call printf
     add $16, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov $0, %r8     # _v68=0
     mov %r8, %r8
     imul $10, %r8      #   _v68 = _v68 * 10
     mov %r8, %r8
     add $0, %r8      #   _v68 = _v68 + 0
     mov %r9, %r13     # x=_v74
     mov %r13, -16(%rbp)        # Set x in stack
     mov -8(%rbp), %rdx
     mov %r8, %rax
     mov %r9, (%rdx,%rax,8) 
     mov %r9, %r13     # x=_v74
     mov %r13, -16(%rbp)        # Set x in stack
     sub $16, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r15       # Load x from stack
     mov %r15, %rsi
     call printf
     add $16, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov $0, %rax     # Return 0
     jmp return_main
return_main:
     mov %rbp, %rsp
     pop %rbp
     ret       # EndFunc
format:
    .asciz  "%d\n"
