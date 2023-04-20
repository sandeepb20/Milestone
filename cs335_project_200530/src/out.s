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
     sub $64, %rsp       # stackPointer-= 48
     mov $8, %r14     # a=8
     mov %r14, -8(%rbp)        # Set a in stack
     mov $68, %r15     # b=68
     mov %r15, -16(%rbp)        # Set b in stack
     mov $67, %r12     # c=67
     mov %r12, -24(%rbp)        # Set c in stack
     mov -8(%rbp) ,%r13       # Load a from stack
     mov %r13, %rax
     sal $2, %rax
     mov %rax, %r8
     mov %r8, %r14     # d=_v93
     mov %r14, -32(%rbp)        # Set d in stack
     mov -8(%rbp) ,%r15       # Load a from stack
     mov -16(%rbp) ,%r12       # Load b from stack
     cmp %r12, %r15
     je t3_7t
     mov $0, %r9
     jmp t3_7f
 t3_7t:
     mov $1, %r9
 t3_7f:
     mov -8(%rbp) ,%r13       # Load a from stack
     mov -16(%rbp) ,%r14       # Load b from stack
     cmp %r14, %r13
     jg t3_8t
     mov $0, %r10
     jmp t3_8f
 t3_8t:
     mov $1, %r10
 t3_8f:
     mov -8(%rbp) ,%r15       # Load a from stack
     mov -16(%rbp) ,%r12       # Load b from stack
     cmp %r12, %r15
     jl t3_9t
     mov $0, %r11
     jmp t3_9f
 t3_9t:
     mov $1, %r11
 t3_9f:
     cmp $0, %r10
     je t3_10t
     cmp $0, %r11
     je t3_10t
     mov $1, %r8
     jmp t3_10f
 t3_10t:
     mov $0, %r8
 t3_10f:
     cmp $1, %r9
     je t3_11t
     cmp $1, %r8
     je t3_11t
     mov $0, %r9
     jmp t3_11f
 t3_11t:
     mov $1, %r9
 t3_11f:
     mov -8(%rbp) ,%r13       # Load a from stack
     mov -16(%rbp) ,%r14       # Load b from stack
     cmp %r14, %r13
     jge t3_12t
     mov $0, %r10
     jmp t3_12f
 t3_12t:
     mov $1, %r10
 t3_12f:
     cmp $1, %r9
     je t3_13t
     cmp $1, %r10
     je t3_13t
     mov $0, %r11
     jmp t3_13f
 t3_13t:
     mov $1, %r11
 t3_13f:
     mov -8(%rbp) ,%r15       # Load a from stack
     mov -16(%rbp) ,%r12       # Load b from stack
     cmp %r12, %r15
     jle t3_14t
     mov $0, %r8
     jmp t3_14f
 t3_14t:
     mov $1, %r8
 t3_14f:
     cmp $1, %r11
     je t3_15t
     cmp $1, %r8
     je t3_15t
     mov $0, %r9
     jmp t3_15f
 t3_15t:
     mov $1, %r9
 t3_15f:
     cmp $1, %r9
     jne t3_19
     mov $1, %r13     # e=1
     mov %r13, -40(%rbp)        # Set e in stack
     jmp t3_20
 t3_19:
     mov $0, %r13     # e=0
     mov %r13, -40(%rbp)        # Set e in stack
 t3_20:
     mov $0, %r14     # i=0
     mov %r14, -24(%rbp)        # Set i in stack
 t3_21:
     mov -24(%rbp) ,%r15       # Load i from stack
     cmp $10, %r15
     jl t3_21t
     mov $0, %r10
     jmp t3_21f
 t3_21t:
     mov $1, %r10
 t3_21f:
     cmp $1, %r10
     jne t3_30
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -24(%rbp) ,%r12       # Load i from stack
     mov %r12, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov -24(%rbp) ,%r13       # Load i from stack
     mov %r13, %r11     # _v173=i
     mov -24(%rbp) ,%r14       # Load i from stack
     add $1, %r12      #   i = i + 1
     mov %r12, -24(%rbp)        # Set i in stack
     jmp t3_21
 t3_30:
     sub $8, %rsp       # PushParam 0
     pushq $0       # PushParam 0
     sub $8, %rsp       # PushParam 0
     pushq $0       # PushParam 0
     mov -8(%rbp) ,%r15       # Load a from stack
     sub $8, %rsp       # PushParam a
     pushq %r15       # PushParam a
     call foo1
     mov %rax, %r8     # ReturnValue = _v199
     add $48, %rsp       # stackPointer+= 24
     mov %r8, %r12     # w=_v199
     mov %r12, -24(%rbp)        # Set w in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -32(%rbp) ,%r13       # Load d from stack
     mov %r13, %rsi
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
