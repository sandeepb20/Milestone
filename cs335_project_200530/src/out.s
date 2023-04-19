      .global main
     .data
     .text
 foo:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $32, %rsp       # stackPointer-= 16
     mov 16(%rbp) , %r8     #   Get Argument kkk
     mov %r8, -8(%rbp)     #   Store Argument kkk in stack
     mov $0, %r12     # lll=0
     mov %r12, -16(%rbp)        # Set lll in stack
     mov -8(%rbp) ,%r13       # Load kkk from stack
     mov %r13, %r9
     add $1, %r9      #   _v30 = kkk + 1
     mov %r9, %rax     # Return _v30
     jmp return_foo
return_foo:
     mov %rbp, %rsp
     leave 
     ret       # EndFunc
 main:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $48, %rsp       # stackPointer-= 32
     mov $343738336, %r10     # _t1=343738336
     mov %r10, %rdi     # Load Param _t1
     call malloc
     mov %rax, %r11     # Get Refernce from return reg in  _v66
     mov %r11, %r14     # a=_v66
     mov %r14, -8(%rbp)        # Set a in stack
     mov $0, %r15     # i=0
     mov %r15, -16(%rbp)        # Set i in stack
 t3_7:
     mov -16(%rbp) ,%r12       # Load i from stack
     cmp $500000, %r12
     jl t3_7t
     mov $0, %r8
     jmp t3_7f
 t3_7t:
     mov $1, %r8
 t3_7f:
     cmp $1, %r8
     jne t3_17
     mov -16(%rbp) ,%r13       # Load i from stack
     mov %r13, %r9     # _v92=i
     mov %r9, %r9
     imul $2, %r9      #   _v92 = _v92 * 2
     mov %r9, %r9
     add $0, %r9      #   _v92 = _v92 + 0
     imul $8, %r9        # addr * 8
     mov -8(%rbp) ,%r14       # Load a from stack
     add %r9, %r14     # addr + base
     mov %r14, %r10
     mov -16(%rbp) ,%r15       # Load i from stack
     mov %r15, (%r10)     # Array assign
     mov -16(%rbp) ,%r12       # Load i from stack
     mov %r12, %r11     # _v87=i
     mov -16(%rbp) ,%r13       # Load i from stack
     add $1, %r12      #   i = i + 1
     mov %r12, -16(%rbp)        # Set i in stack
     jmp t3_7
 t3_17:
     mov $0, %r12     # i=0
     mov %r12, -16(%rbp)        # Set i in stack
 t3_18:
     mov -16(%rbp) ,%r14       # Load i from stack
     cmp $500000, %r14
     jl t3_18t
     mov $0, %r8
     jmp t3_18f
 t3_18t:
     mov $1, %r8
 t3_18f:
     cmp $1, %r8
     jne t3_32
     mov -16(%rbp) ,%r15       # Load i from stack
     mov %r15, %r9     # _v132=i
     mov %r9, %r9
     imul $2, %r9      #   _v132 = _v132 * 2
     mov %r9, %r9
     add $0, %r9      #   _v132 = _v132 + 0
     imul $8, %r9        # addr * 8
     mov -8(%rbp) ,%r12       # Load a from stack
     add %r9, %r12     # addr + base
     mov %r12, %r10
     mov (%r10), %r13     # Array access
     mov %r13, -32(%rbp)        # Set x in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -32(%rbp) ,%r14       # Load x from stack
     mov %r14, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov -16(%rbp) ,%r15       # Load i from stack
     mov %r15, %r11     # _v124=i
     mov -16(%rbp) ,%r12       # Load i from stack
     add $1, %r12      #   i = i + 1
     mov %r12, -16(%rbp)        # Set i in stack
     jmp t3_18
 t3_32:
return_main:
     mov %rbp, %rsp
     leave 
     ret       # EndFunc
format:
    .asciz  "%d\n"
