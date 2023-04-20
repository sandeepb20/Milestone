      .global main
     .data
     .text
 foo1:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $64, %rsp       # stackPointer-= 48
     mov 16(%rbp) , %r8     #   Get Argument k
     mov %r8, -8(%rbp)     #   Store Argument k in stack
     mov 32(%rbp) , %r9     #   Get Argument l
     mov %r9, -16(%rbp)     #   Store Argument l in stack
     mov 48(%rbp) , %r10     #   Get Argument m
     mov %r10, -24(%rbp)     #   Store Argument m in stack
     mov -8(%rbp) ,%r12       # Load k from stack
     mov %r12, %r11
     sub $1, %r11      #   _v33 = k - 1
     mov %r11, %r12     # k=_v33
     mov %r12, -8(%rbp)        # Set k in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -8(%rbp) ,%r13       # Load k from stack
     mov %r13, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov $66, %rax     # Return 66
     jmp return_foo1
return_foo1:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
 main:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $80, %rsp       # stackPointer-= 64
     mov $8, %r14     # a=8
     mov %r14, -8(%rbp)        # Set a in stack
     mov $68, %r15     # b=68
     mov %r15, -16(%rbp)        # Set b in stack
     mov $67, %r12     # c=67
     mov %r12, -24(%rbp)        # Set c in stack
     mov -8(%rbp) ,%r13       # Load a from stack
     mov %r13, %r8     # _v92=a
     mov -8(%rbp) ,%r14       # Load a from stack
     mov -8(%rbp) ,%r15       # Load a from stack
     sub $1, %r15      #   a = a - 1
     mov %r15, -8(%rbp)        # Set a in stack
     mov %r8, %r12     # d=_v92
     mov %r12, -32(%rbp)        # Set d in stack
     mov -8(%rbp) ,%r13       # Load a from stack
     mov -8(%rbp) ,%r14       # Load a from stack
     sub $1, %r14      #   a = a - 1
     mov %r14, -8(%rbp)        # Set a in stack
     mov -8(%rbp) ,%r15       # Load a from stack
     mov %r15, %r9     # _v103=a
     mov %r9, %r12     # e=_v103
     mov %r12, -40(%rbp)        # Set e in stack
     mov $0, %r13     # i=0
     mov %r13, -48(%rbp)        # Set i in stack
 t3_12:
     mov -48(%rbp) ,%r14       # Load i from stack
     cmp $10, %r14
     jl t3_12t
     mov $0, %r10
     jmp t3_12f
 t3_12t:
     mov $1, %r10
 t3_12f:
     cmp $1, %r10
     jne t3_17
     mov -48(%rbp) ,%r15       # Load i from stack
     mov %r15, %r11     # _v125=i
     mov -48(%rbp) ,%r12       # Load i from stack
     add $1, %r12      #   i = i + 1
     mov %r12, -48(%rbp)        # Set i in stack
     jmp t3_12
 t3_17:
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -32(%rbp) ,%r13       # Load d from stack
     mov %r13, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -40(%rbp) ,%r14       # Load e from stack
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
