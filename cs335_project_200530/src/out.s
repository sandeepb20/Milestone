      .global main
     .data
     .text
 foo:
     push %rbp
     mov %rsp, %rbp      # beginFunc
     sub $80, %rsp       # stackPointer-= 64
     mov 16(%rbp) , %r8     #   Get Argument x
     mov %r8, -8(%rbp)     #   Store Argument x in stack
     mov 24(%rbp) , %r9     #   Get Argument y
     mov %r9, -16(%rbp)     #   Store Argument y in stack
     mov 32(%rbp) , %r10     #   Get Argument z
     mov %r10, -24(%rbp)     #   Store Argument z in stack
     mov -32(%rbp) ,%r12       # Load a from stack
     mov $5, %r12     # a=5
     mov %r12, -32(%rbp)        # Set a in stack
     mov $3, %r11
     add $2, %r11      #   _v68 = 3 + 2
     mov -32(%rbp) ,%r13       # Load a from stack
     mov %r11, %r8
     add %r13, %r8      #   _v71 = _v68 + a
     mov -64(%rbp) ,%r14       # Load k from stack
     mov %r8, %r14     # k=_v71
     mov %r14, -64(%rbp)        # Set k in stack
     mov -64(%rbp) ,%r15       # Load k from stack
     mov -8(%rbp) ,%r12       # Load x from stack
     mov %r15, %r9
     add %r12, %r9      #   _v81 = k + x
     mov -16(%rbp) ,%r13       # Load y from stack
     mov %r9, %r10
     add %r13, %r10      #   _v84 = _v81 + y
     mov -24(%rbp) ,%r14       # Load z from stack
     mov %r10, %r11
     add %r14, %r11      #   _v87 = _v84 + z
     push $100       # PushParam 100
     call foo2
     mov %rax, %r8     # ReturnValue = _v93
     add $8, %rsp       # stackPointer+= 8
     mov %r9, %r10
     add %r8, %r10      #   _v94 = _v87 + _v93
     mov %r10, %rax     # Return _v94
     jmp return_foo
return_foo:
     mov %rbp, %rsp
     pop %rbp
     ret       # EndFunc
 foo2:
     push %rbp
     mov %rsp, %rbp      # beginFunc
     sub $24, %rsp       # stackPointer-= 8
     mov 16(%rbp) , %r11     #   Get Argument p
     mov %r11, -8(%rbp)     #   Store Argument p in stack
     mov -8(%rbp) ,%r15       # Load p from stack
     mov %r15, %rax     # Return p
     jmp return_foo2
return_foo2:
     mov %rbp, %rsp
     pop %rbp
     ret       # EndFunc
 main:
     push %rbp
     mov %rsp, %rbp      # beginFunc
     sub $64, %rsp       # stackPointer-= 48
     mov -8(%rbp) ,%r12       # Load n1 from stack
     mov $5, %r12     # n1=5
     mov %r12, -8(%rbp)        # Set n1 in stack
     mov -16(%rbp) ,%r13       # Load n2 from stack
     mov $1, %r13     # n2=1
     mov %r13, -16(%rbp)        # Set n2 in stack
     mov -24(%rbp) ,%r14       # Load n from stack
     mov $1, %r14     # n=1
     mov %r14, -24(%rbp)        # Set n in stack
     mov -32(%rbp) ,%r15       # Load count from stack
     mov $10, %r15     # count=10
     mov %r15, -32(%rbp)        # Set count in stack
     mov -40(%rbp) ,%r12       # Load i from stack
     mov $0, %r12     # i=0
     mov %r12, -40(%rbp)        # Set i in stack
 t4_7:
     mov -40(%rbp) ,%r13       # Load i from stack
     mov -32(%rbp) ,%r14       # Load count from stack
     cmp %r14, %r13
     jl t4_7t
     mov $0, %r8
     jmp t4_7f
 t4_7t:
     mov $1, %r8
 t4_7f:
     cmp $1, %r8
     jne t4_26
     push $4       # PushParam 4
     push $3       # PushParam 3
     push $2       # PushParam 2
     call foo
     mov %rax, %r9     # ReturnValue = _v171
     add $24, %rsp       # stackPointer+= 24
     mov -24(%rbp) ,%r15       # Load n from stack
     mov %r9, %r15     # n=_v171
     mov %r15, -24(%rbp)        # Set n in stack
     sub $16, %rsp       # For print statement
     mov $format, %rdi
     mov -24(%rbp) ,%r12       # Load n from stack
     mov %r12, %rsi
     call printf
     add $16, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov -16(%rbp) ,%r13       # Load n2 from stack
     mov -8(%rbp) ,%r14       # Load n1 from stack
     mov %r13, %r14     # n1=n2
     mov %r14, -8(%rbp)        # Set n1 in stack
     mov -24(%rbp) ,%r15       # Load n from stack
     mov %r15, %r13     # n2=n
     mov %r13, -16(%rbp)        # Set n2 in stack
     mov -40(%rbp) ,%r12       # Load i from stack
     mov %r12, %r10     # _v156=i
     mov -40(%rbp) ,%r13       # Load i from stack
     add $1, %r12      #   i = i + 1
     mov %r12, -40(%rbp)        # Set i in stack
     jmp t4_7
 t4_26:
     mov $0, %rax     # Return 0
     jmp return_main
return_main:
     mov %rbp, %rsp
     pop %rbp
     ret       # EndFunc
format:
    .asciz  "%d\n"
