      .global main
     .data
     .text
 main:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $32, %rsp       # stackPointer-= 16
     mov $10, %r12     # x=10
     mov %r12, -8(%rbp)        # Set x in stack
     mov -8(%rbp) ,%r13       # Load x from stack
     sub $8, %rsp       # PushParam x
     pushq %r13       # PushParam x
     call rec
     mov %rax, %r8     # ReturnValue = _v92
     add $16, %rsp       # stackPointer+= 8
     mov %r8, %r14     # y=_v92
     mov %r14, -16(%rbp)        # Set y in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r15       # Load y from stack
     mov %r15, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov $0, %rax     # Return 0
     jmp return_main
return_main:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
 rec:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $32, %rsp       # stackPointer-= 16
     mov 16(%rbp) , %r9     #   Get Argument x
     mov %r9, -8(%rbp)     #   Store Argument x in stack
     mov -8(%rbp) ,%r12       # Load x from stack
     cmp $0, %r12
     jl t3_3t
     mov $0, %r10
     jmp t3_3f
 t3_3t:
     mov $1, %r10
 t3_3f:
     cmp $1, %r10
     jne t3_7
     mov $0, %rax     # Return 0
     jmp return_rec
     jmp t3_7
 t3_7:
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -8(%rbp) ,%r13       # Load x from stack
     mov %r13, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov -8(%rbp) ,%r14       # Load x from stack
     mov %r14, %r11
     sub $1, %r11      #   _v42 = x - 1
     mov %r11, %r12     # x=_v42
     mov %r12, -8(%rbp)        # Set x in stack
     mov -8(%rbp) ,%r15       # Load x from stack
     sub $8, %rsp       # PushParam x
     pushq %r15       # PushParam x
     call rec
     mov %rax, %r8     # ReturnValue = _v54
     add $16, %rsp       # stackPointer+= 8
     mov %r8, %r12     # y=_v54
     mov %r12, -16(%rbp)        # Set y in stack
     mov -16(%rbp) ,%r13       # Load y from stack
     mov %r13, %rax     # Return y
     jmp return_rec
return_rec:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
format:
    .asciz  "%d\n"
