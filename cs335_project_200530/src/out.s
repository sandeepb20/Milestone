      .global main
     .data
     .text
 fib:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $32, %rsp       # stackPointer-= 16
     mov 16(%rbp) , %r8     #   Get Argument n
     mov %r8, -8(%rbp)     #   Store Argument n in stack
     mov -8(%rbp) ,%r12       # Load n from stack
     cmp $1, %r12
     jle t2_3t
     mov $0, %r9
     jmp t2_3f
 t2_3t:
     mov $1, %r9
 t2_3f:
     cmp $1, %r9
     jne t2_7
     mov -8(%rbp) ,%r13       # Load n from stack
     mov %r13, %rax     # Return n
     jmp return_fib
     jmp t2_7
 t2_7:
     sub $8, %rsp       # PushParam AdditiveExpression
     pushq $AdditiveExpression       # PushParam AdditiveExpression
     mov -8(%rbp) ,%r14       # Load n from stack
     mov %r14, %r10
     sub $1, %r10      #   _v36 = n - 1
     call fib
     mov %rax, %r11     # ReturnValue = _v38
     add $16, %rsp       # stackPointer+= 8
     mov %r11, %r12     # a=_v38
     mov %r12, -16(%rbp)        # Set a in stack
     sub $8, %rsp       # PushParam AdditiveExpression
     pushq $AdditiveExpression       # PushParam AdditiveExpression
     mov -8(%rbp) ,%r13       # Load n from stack
     mov %r13, %r15
     sub $2, %r15      #   _v52 = n - 2
     call fib
     mov %rax, %rcx     # ReturnValue = _v54
     add $16, %rsp       # stackPointer+= 8
     mov -16(%rbp) ,%r14       # Load a from stack
     mov %r14, %r8
     add %rcx, %r8      #   _v55 = a + _v54
     mov %r8, %rax     # Return _v55
     jmp return_fib
return_fib:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
 main:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $32, %rsp       # stackPointer-= 16
     mov $10, %r12     # N=10
     mov %r12, -8(%rbp)        # Set N in stack
     mov -8(%rbp) ,%r13       # Load N from stack
     sub $8, %rsp       # PushParam N
     pushq %r13       # PushParam N
     call fib
     mov %rax, %r9     # ReturnValue = _v88
     add $16, %rsp       # stackPointer+= 8
     mov %r9, %r14     # ans=_v88
     mov %r14, -16(%rbp)        # Set ans in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r12       # Load ans from stack
     mov %r12, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
return_main:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
format:
    .asciz  "%d\n"
