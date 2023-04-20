      .global main
     .data
     .text
 foo:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $32, %rsp       # stackPointer-= 16
     mov 16(%rbp) , %r8     #   Get Argument kkk
     mov %r8, -8(%rbp)     #   Store Argument kkk in stack
     pushq $98       # PushParam 98
     call foo2
     mov %rax, %r9     # ReturnValue = _v54
     add $8, %rsp       # stackPointer+= 8
     mov %r9, %r12     # lll=_v54
     mov %r12, -16(%rbp)        # Set lll in stack
     sub $24, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r13       # Load lll from stack
     mov %r13, %rsi
     call printf
     add $24, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov -8(%rbp) ,%r14       # Load kkk from stack
     mov %r14, %r10
     add $1, %r10      #   _v70 = kkk + 1
     mov %r10, %rax     # Return _v70
     jmp return_foo
return_foo:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
 foo2:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $48, %rsp       # stackPointer-= 32
     mov 16(%rbp) , %r11     #   Get Argument p
     mov %r11, -8(%rbp)     #   Store Argument p in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -8(%rbp) ,%r15       # Load p from stack
     mov %r15, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov -8(%rbp) ,%r12       # Load p from stack
     mov %r12, %r8
     add $1, %r8      #   _v28 = p + 1
     mov %r8, %rax     # Return _v28
     jmp return_foo2
return_foo2:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
 main:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $48, %rsp       # stackPointer-= 32
     mov $343738336, %r9     # _t1=343738336
     mov %r9, %rdi     # Load Param _t1
     call malloc
     mov %rax, %r10     # Get Refernce from return reg in  _v106
     mov %r10, %r13     # a=_v106
     mov %r13, -8(%rbp)        # Set a in stack
     mov $0, %r14     # i=0
     mov %r14, -16(%rbp)        # Set i in stack
 t4_7:
     mov -16(%rbp) ,%r15       # Load i from stack
     cmp $500000, %r15
     jl t4_7t
     mov $0, %r11
     jmp t4_7f
 t4_7t:
     mov $1, %r11
 t4_7f:
     cmp $1, %r11
     jne t4_17
     mov -16(%rbp) ,%r12       # Load i from stack
     mov %r12, %r8     # _v132=i
     mov %r8, %r8
     imul $2, %r8      #   _v132 = _v132 * 2
     mov %r8, %r8
     add $0, %r8      #   _v132 = _v132 + 0
     imul $8, %r8        # addr * 8
     mov -8(%rbp) ,%r13       # Load a from stack
     add %r8, %r13     # addr + base
     mov %r13, %r9
     mov -16(%rbp) ,%r14       # Load i from stack
     mov %r14, (%r9)     # Array assign
     mov -16(%rbp) ,%r15       # Load i from stack
     mov %r15, %r10     # _v127=i
     mov -16(%rbp) ,%r12       # Load i from stack
     add $1, %r12      #   i = i + 1
     mov %r12, -16(%rbp)        # Set i in stack
     jmp t4_7
 t4_17:
     mov $0, %r12     # i=0
     mov %r12, -16(%rbp)        # Set i in stack
 t4_18:
     mov -16(%rbp) ,%r13       # Load i from stack
     cmp $500000, %r13
     jl t4_18t
     mov $0, %r11
     jmp t4_18f
 t4_18t:
     mov $1, %r11
 t4_18f:
     cmp $1, %r11
     jne t4_42
     mov -16(%rbp) ,%r14       # Load i from stack
     mov %r14, %r8     # _v172=i
     mov %r8, %r8
     imul $2, %r8      #   _v172 = _v172 * 2
     mov %r8, %r8
     add $0, %r8      #   _v172 = _v172 + 0
     imul $8, %r8        # addr * 8
     mov -8(%rbp) ,%r15       # Load a from stack
     add %r8, %r15     # addr + base
     mov %r15, %r9
     mov (%r9), %r12     # Array access
     mov %r12, -40(%rbp)        # Set x in stack
     pushq $9       # PushParam 9
     call foo
     mov %rax, %r10     # ReturnValue = _v190
     add $8, %rsp       # stackPointer+= 8
     mov %r10, %r13     # ppp=_v190
     mov %r13, -48(%rbp)        # Set ppp in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -40(%rbp) ,%r14       # Load x from stack
     mov %r14, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r15       # Load i from stack
     mov %r15, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov -16(%rbp) ,%r12       # Load i from stack
     mov %r12, %r11     # _v164=i
     mov -16(%rbp) ,%r13       # Load i from stack
     add $1, %r12      #   i = i + 1
     mov %r12, -16(%rbp)        # Set i in stack
     jmp t4_18
 t4_42:
return_main:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
format:
    .asciz  "%d\n"
