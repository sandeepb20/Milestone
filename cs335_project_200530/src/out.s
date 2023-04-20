      .global main
     .data
     .text
 foo:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $32, %rsp       # stackPointer-= 16
     mov 16(%rbp) , %r8     #   Get Argument w
     mov %r8, -8(%rbp)     #   Store Argument w in stack
     mov $10, %r12     # pp=10
     mov %r12, -16(%rbp)        # Set pp in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r13       # Load pp from stack
     mov %r13, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov -8(%rbp) ,%r14       # Load w from stack
     mov %r14, %r9
     add $1, %r9      #   _v38 = w + 1
     mov %r9, %r14     # w=_v38
     mov %r14, -8(%rbp)        # Set w in stack
     mov %r10, %rax     # Return _v-1
     jmp return_foo
return_foo:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
 main:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $64, %rsp       # stackPointer-= 48
     mov $1680, %r11     # _t1=1680
     mov %r11, %rdi     # Load Param _t1
     call malloc
     mov %rax, %r15     # Get Refernce from return reg in  _v87
     mov %r15, %r12     # a=_v87
     mov %r12, -8(%rbp)        # Set a in stack
     mov $1, %rcx     # _v94=1
     mov %rcx, %rcx
     imul $7, %rcx      #   _v94 = _v94 * 7
     mov %rcx, %rcx
     add $2, %rcx      #   _v94 = _v94 + 2
     mov %rcx, %rcx
     imul $6, %rcx      #   _v94 = _v94 * 6
     mov %rcx, %rcx
     add $3, %rcx      #   _v94 = _v94 + 3
     imul $8, %rcx        # addr * 8
     mov -8(%rbp) ,%r13       # Load a from stack
     add %rcx, %r13     # addr + base
     mov %r13, %r8
     mov $5, %r9
     mov %r9, (%r8)     # Array assign
     mov $1, %r10     # _v116=1
     mov %r10, %r10
     imul $7, %r10      #   _v116 = _v116 * 7
     mov %r10, %r10
     add $2, %r10      #   _v116 = _v116 + 2
     mov %r10, %r10
     imul $6, %r10      #   _v116 = _v116 * 6
     mov %r10, %r10
     add $3, %r10      #   _v116 = _v116 + 3
     imul $8, %r10        # addr * 8
     mov -8(%rbp) ,%r14       # Load a from stack
     add %r10, %r14     # addr + base
     mov %r14, %r11
     mov (%r11), %r11     # Array access
     mov %r11, %r15
     imul $8, %r15      #   _v129 = _v126 * 8
     mov %r15, %r12     # x=_v129
     mov %r12, -16(%rbp)        # Set x in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r13       # Load x from stack
     mov %r13, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     sub $8, %rsp       # PushParam 1
     pushq $1       # PushParam 1
     call foo
     mov %rax, %rcx     # ReturnValue = _v146
     add $16, %rsp       # stackPointer+= 8
     mov $9, %r14     # pp=9
     mov %r14, -24(%rbp)        # Set pp in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -24(%rbp) ,%r12       # Load pp from stack
     mov %r12, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov $1, %r8     # _v170=1
     mov %r8, %r8
     imul $7, %r8      #   _v170 = _v170 * 7
     mov %r8, %r8
     add $2, %r8      #   _v170 = _v170 + 2
     mov %r8, %r8
     imul $6, %r8      #   _v170 = _v170 * 6
     mov %r8, %r8
     add $3, %r8      #   _v170 = _v170 + 3
     imul $8, %r8        # addr * 8
     mov -8(%rbp) ,%r13       # Load a from stack
     add %r8, %r13     # addr + base
     mov %r13, %r9
     mov (%r9), %r14     # Array access
     mov %r14, -16(%rbp)        # Set x in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r12       # Load x from stack
     mov %r12, %rsi
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
