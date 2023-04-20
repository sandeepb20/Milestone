      .global main
     .data
     .text
 foo:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $48, %rsp       # stackPointer-= 32
     mov 16(%rbp) , %r8     #   Get Argument x
     mov %r8, -8(%rbp)     #   Store Argument x in stack
     mov 32(%rbp) , %r9     #   Get Argument y
     mov %r9, -16(%rbp)     #   Store Argument y in stack
     mov 48(%rbp) , %r10     #   Get Argument z
     mov %r10, -24(%rbp)     #   Store Argument z in stack
     sub $8, %rsp       # PushParam 98
     pushq $98       # PushParam 98
     call foo2
     mov %rax, %r11     # ReturnValue = _v64
     add $16, %rsp       # stackPointer+= 8
     mov %r11, %r12     # lll=_v64
     mov %r12, -32(%rbp)        # Set lll in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -32(%rbp) ,%r13       # Load lll from stack
     mov %r13, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -8(%rbp) ,%r14       # Load x from stack
     mov %r14, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r15       # Load y from stack
     mov %r15, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -24(%rbp) ,%r12       # Load z from stack
     mov %r12, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov -8(%rbp) ,%r13       # Load x from stack
     mov %r13, %r8
     add $100, %r8      #   _v101 = x + 100
     mov %r8, %rax     # Return _v101
     jmp return_foo
return_foo:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
 foo2:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $48, %rsp       # stackPointer-= 32
     mov 16(%rbp) , %r9     #   Get Argument p
     mov %r9, -8(%rbp)     #   Store Argument p in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -8(%rbp) ,%r14       # Load p from stack
     mov %r14, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov -8(%rbp) ,%r15       # Load p from stack
     mov %r15, %r10
     add $1000, %r10      #   _v28 = p + 1000
     mov %r10, %rax     # Return _v28
     jmp return_foo2
return_foo2:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
 main:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $32, %rsp       # stackPointer-= 16
     mov $343738336, %r11     # _t1=343738336
     mov %r11, %rdi     # Load Param _t1
     call malloc
     mov %rax, %r8     # Get Refernce from return reg in  _v137
     mov %r8, %r12     # a=_v137
     mov %r12, -8(%rbp)        # Set a in stack
     mov $0, %r13     # i=0
     mov %r13, -16(%rbp)        # Set i in stack
 t4_7:
     mov -16(%rbp) ,%r14       # Load i from stack
     cmp $500000, %r14
     jl t4_7t
     mov $0, %r9
     jmp t4_7f
 t4_7t:
     mov $1, %r9
 t4_7f:
     cmp $1, %r9
     jne t4_17
     mov -16(%rbp) ,%r15       # Load i from stack
     mov %r15, %r10     # _v163=i
     mov %r10, %r10
     imul $2, %r10      #   _v163 = _v163 * 2
     mov %r10, %r10
     add $0, %r10      #   _v163 = _v163 + 0
     imul $8, %r10        # addr * 8
     mov -8(%rbp) ,%r12       # Load a from stack
     add %r10, %r12     # addr + base
     mov %r12, %r11
     mov -16(%rbp) ,%r13       # Load i from stack
     mov %r13, (%r11)     # Array assign
     mov -16(%rbp) ,%r14       # Load i from stack
     mov %r14, %r8     # _v158=i
     mov -16(%rbp) ,%r15       # Load i from stack
     add $1, %r13      #   i = i + 1
     mov %r13, -16(%rbp)        # Set i in stack
     jmp t4_7
 t4_17:
     sub $8, %rsp       # PushParam 103
     pushq $103       # PushParam 103
     sub $8, %rsp       # PushParam 102
     pushq $102       # PushParam 102
     sub $8, %rsp       # PushParam 101
     pushq $101       # PushParam 101
     call foo
     mov %rax, %r9     # ReturnValue = _v192
     add $48, %rsp       # stackPointer+= 24
     mov %r9, %r12     # w=_v192
     mov %r12, -32(%rbp)        # Set w in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -32(%rbp) ,%r13       # Load w from stack
     mov %r13, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
return_main:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
format:
    .asciz  "%d\n"
