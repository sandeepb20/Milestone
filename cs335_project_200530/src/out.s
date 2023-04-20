      .global main
     .data
     .text
 artmet:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $112, %rsp       # stackPointer-= 96
     mov 16(%rbp) , %r8     #   Get Argument k
     mov %r8, -8(%rbp)     #   Store Argument k in stack
     mov 32(%rbp) , %r9     #   Get Argument l
     mov %r9, -16(%rbp)     #   Store Argument l in stack
     mov 48(%rbp) , %r10     #   Get Argument m
     mov %r10, -24(%rbp)     #   Store Argument m in stack
     mov 64(%rbp) , %r11     #   Get Argument n
     mov %r11, -32(%rbp)     #   Store Argument n in stack
     mov 80(%rbp) , %r8     #   Get Argument o
     mov %r8, -40(%rbp)     #   Store Argument o in stack
     mov 96(%rbp) , %r9     #   Get Argument p
     mov %r9, -48(%rbp)     #   Store Argument p in stack
     mov 112(%rbp) , %r10     #   Get Argument q
     mov %r10, -56(%rbp)     #   Store Argument q in stack
     mov -8(%rbp) ,%r12       # Load k from stack
     mov -16(%rbp) ,%r13       # Load l from stack
     mov %r12, %r11
     add %r13, %r11      #   _v53 = k + l
     mov -24(%rbp) ,%r14       # Load m from stack
     mov %r11, %r8
     sub %r14, %r8      #   _v56 = _v53 - m
     mov -32(%rbp) ,%r15       # Load n from stack
     mov -40(%rbp) ,%r12       # Load o from stack
     mov %r15, %r9
     imul %r12, %r9      #   _v62 = n * o
     mov -48(%rbp) ,%r13       # Load p from stack
     mov %r9, %rax
     cdq
     idiv %r13      #   _v65 = _v62 / p
     mov %rax, %r10
     mov -56(%rbp) ,%r14       # Load q from stack
     mov %r10, %r11
     sub %r14, %r11      #   _v68 = _v65 - q
     mov %r11, %r8     # _v70=_v68
     mov %r9, %r10
     add %r8, %r10      #   _v71 = _v56 + _v70
     mov %r10, %r15     # k=_v71
     mov %r15, -8(%rbp)        # Set k in stack
     mov -8(%rbp) ,%r12       # Load k from stack
     mov -16(%rbp) ,%r13       # Load l from stack
     mov %r12, %r11
     add %r13, %r11      #   _v81 = k + l
     mov -24(%rbp) ,%r14       # Load m from stack
     mov %r11, %r8
     sub %r14, %r8      #   _v84 = _v81 - m
     mov %r8, %r15     # a=_v84
     mov %r15, -64(%rbp)        # Set a in stack
     mov -32(%rbp) ,%r12       # Load n from stack
     mov -40(%rbp) ,%r13       # Load o from stack
     mov %r12, %r9
     imul %r13, %r9      #   _v96 = n * o
     mov -48(%rbp) ,%r14       # Load p from stack
     mov %r9, %rax
     cdq
     idiv %r14      #   _v99 = _v96 / p
     mov %rax, %r10
     mov -56(%rbp) ,%r15       # Load q from stack
     mov %r10, %r11
     sub %r15, %r11      #   _v102 = _v99 - q
     mov %r11, %r12     # b=_v102
     mov %r12, -72(%rbp)        # Set b in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -64(%rbp) ,%r13       # Load a from stack
     mov %r13, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -72(%rbp) ,%r14       # Load b from stack
     mov %r14, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -8(%rbp) ,%r15       # Load k from stack
     mov %r15, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov -8(%rbp) ,%r12       # Load k from stack
     mov %r12, %rax     # Return k
     jmp return_artmet
return_artmet:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
 main:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $48, %rsp       # stackPointer-= 32
     mov $1, %r13     # a=1
     mov %r13, -64(%rbp)        # Set a in stack
     mov $4, %r14     # b=4
     mov %r14, -72(%rbp)        # Set b in stack
     mov $2, %r13     # c=2
     mov %r13, -24(%rbp)        # Set c in stack
     sub $8, %rsp       # PushParam 1
     pushq $1       # PushParam 1
     sub $8, %rsp       # PushParam 5
     pushq $5       # PushParam 5
     sub $8, %rsp       # PushParam 2
     pushq $2       # PushParam 2
     sub $8, %rsp       # PushParam 10
     pushq $10       # PushParam 10
     mov -24(%rbp) ,%r14       # Load c from stack
     sub $8, %rsp       # PushParam c
     pushq %r14       # PushParam c
     mov -72(%rbp) ,%r15       # Load b from stack
     sub $8, %rsp       # PushParam b
     pushq %r15       # PushParam b
     mov -64(%rbp) ,%r12       # Load a from stack
     sub $8, %rsp       # PushParam a
     pushq %r12       # PushParam a
     call artmet
     mov %rax, %r8     # ReturnValue = _v197
     add $112, %rsp       # stackPointer+= 56
     mov %r8, %r13     # w=_v197
     mov %r13, -32(%rbp)        # Set w in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -32(%rbp) ,%r14       # Load w from stack
     mov %r14, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov $0, %rax     # Return 0
     jmp return_main
return_main:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
format:
    .asciz  "%d\n"
