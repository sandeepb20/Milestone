      .global main
     .data
     .text
 main:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $32, %rsp       # stackPointer-= 16
     mov $10, %r12     # size=10
     mov %r12, -8(%rbp)        # Set size in stack
     mov $80, %r8     # _t1=80
     mov %r8, %rdi     # Load Param _t1
     call malloc
     mov %rax, %r9     # Get Refernce from return reg in  _v35
     mov %r9, %r13     # arr=_v35
     mov %r13, -16(%rbp)        # Set arr in stack
     mov $0, %r14     # k=0
     mov %r14, -24(%rbp)        # Set k in stack
 t2_8:
     mov -24(%rbp) ,%r12       # Load k from stack
     mov -8(%rbp) ,%r13       # Load size from stack
     cmp %r13, %r12
     jl t2_8t
     mov $0, %r10
     jmp t2_8f
 t2_8t:
     mov $1, %r10
 t2_8f:
     cmp $1, %r10
     jne t2_24
     mov -24(%rbp) ,%r14       # Load k from stack
     mov %r14, %r11     # _v62=k
     imul $8, %r11        # addr * 8
     mov -16(%rbp) ,%r12       # Load arr from stack
     add %r11, %r12     # addr + base
     mov %r12, %r15
     mov -8(%rbp) ,%r13       # Load size from stack
     mov -24(%rbp) ,%r14       # Load k from stack
     mov %r13, %rcx
     sub %r14, %rcx      #   _v69 = size - k
     mov %rcx, (%r15)     # Array assign
     mov -24(%rbp) ,%r12       # Load k from stack
     mov %r12, %r8     # _v75=k
     imul $8, %r8        # addr * 8
     mov -16(%rbp) ,%r13       # Load arr from stack
     add %r8, %r13     # addr + base
     mov %r13, %r9
     mov -24(%rbp) ,%r14       # Load k from stack
     mov %r14, %r10     # _v81=k
     imul $8, %r10        # addr * 8
     mov -16(%rbp) ,%r12       # Load arr from stack
     add %r10, %r12     # addr + base
     mov %r12, %r11
     mov (%r11), %r11     # Array access
     mov %r11, %r15
     imul $10, %r15      #   _v86 = _v83 * 10
     mov %r15, (%r9)     # Array assign
     mov -24(%rbp) ,%r13       # Load k from stack
     mov %r13, %rcx     # _v57=k
     mov -24(%rbp) ,%r14       # Load k from stack
     add $1, %r13      #   k = k + 1
     mov %r13, -24(%rbp)        # Set k in stack
     jmp t2_8
 t2_24:
     mov $0, %r12     # i=0
     mov %r12, -32(%rbp)        # Set i in stack
 t2_25:
     mov -32(%rbp) ,%r13       # Load i from stack
     mov -8(%rbp) ,%r14       # Load size from stack
     cmp %r14, %r13
     jl t2_25t
     mov $0, %r8
     jmp t2_25f
 t2_25t:
     mov $1, %r8
 t2_25f:
     cmp $1, %r8
     jne t2_71
     mov -32(%rbp) ,%r12       # Load i from stack
     mov %r12, %r9
     add $1, %r9      #   _v122 = i + 1
     mov %r9, %r13     # j=_v122
     mov %r13, -40(%rbp)        # Set j in stack
 t2_29:
     mov -40(%rbp) ,%r14       # Load j from stack
     mov -8(%rbp) ,%r12       # Load size from stack
     cmp %r12, %r14
     jl t2_29t
     mov $0, %r10
     jmp t2_29f
 t2_29t:
     mov $1, %r10
 t2_29f:
     cmp $1, %r10
     jne t2_61
     mov $0, %r13     # tmp=0
     mov %r13, -48(%rbp)        # Set tmp in stack
     mov -32(%rbp) ,%r14       # Load i from stack
     mov %r14, %r11     # _v149=i
     imul $8, %r11        # addr * 8
     mov -16(%rbp) ,%r12       # Load arr from stack
     add %r11, %r12     # addr + base
     mov %r12, %r15
     mov (%r15), %r13     # Array access
     mov %r13, -56(%rbp)        # Set p in stack
     mov -40(%rbp) ,%r14       # Load j from stack
     mov %r14, %rcx     # _v162=j
     imul $8, %rcx        # addr * 8
     mov -16(%rbp) ,%r12       # Load arr from stack
     add %rcx, %r12     # addr + base
     mov %r12, %r8
     mov (%r8), %r13     # Array access
     mov %r13, -64(%rbp)        # Set q in stack
     mov -32(%rbp) ,%r14       # Load i from stack
     mov %r14, %r9     # _v174=i
     imul $8, %r9        # addr * 8
     mov -16(%rbp) ,%r12       # Load arr from stack
     add %r9, %r12     # addr + base
     mov %r12, %r10
     mov -40(%rbp) ,%r13       # Load j from stack
     mov %r13, %r11     # _v180=j
     imul $8, %r11        # addr * 8
     mov -16(%rbp) ,%r14       # Load arr from stack
     add %r11, %r14     # addr + base
     mov %r14, %r15
     mov (%r15), %r15     # Array access
     mov (%r10), %r10     # Array access
     cmp %r15, %r10
     jg t2_44t
     mov $0, %rcx
     jmp t2_44f
 t2_44t:
     mov $1, %rcx
 t2_44f:
     cmp $1, %rcx
     jne t2_58
     mov -32(%rbp) ,%r12       # Load i from stack
     mov %r12, %r8     # _v190=i
     imul $8, %r8        # addr * 8
     mov -16(%rbp) ,%r13       # Load arr from stack
     add %r8, %r13     # addr + base
     mov %r13, %r9
     mov (%r9), %r14     # Array access
     mov %r14, -48(%rbp)        # Set tmp in stack
     mov -32(%rbp) ,%r12       # Load i from stack
     mov %r12, %r10     # _v198=i
     imul $8, %r10        # addr * 8
     mov -16(%rbp) ,%r13       # Load arr from stack
     add %r10, %r13     # addr + base
     mov %r13, %r11
     mov -40(%rbp) ,%r14       # Load j from stack
     mov %r14, %r15     # _v204=j
     imul $8, %r15        # addr * 8
     mov -16(%rbp) ,%r12       # Load arr from stack
     add %r15, %r12     # addr + base
     mov %r12, %rcx
     mov (%rcx), %r8     # Array Array assign
     mov %r8, (%r11)     # Array Array assign
     mov -40(%rbp) ,%r13       # Load j from stack
     mov %r13, %r9     # _v213=j
     imul $8, %r9        # addr * 8
     mov -16(%rbp) ,%r14       # Load arr from stack
     add %r9, %r14     # addr + base
     mov %r14, %r10
     mov -48(%rbp) ,%r12       # Load tmp from stack
     mov %r12, (%r10)     # Array assign
     jmp t2_58
 t2_58:
     mov -40(%rbp) ,%r13       # Load j from stack
     mov %r13, %r11     # _v133=j
     mov -40(%rbp) ,%r14       # Load j from stack
     add $1, %r13      #   j = j + 1
     mov %r13, -40(%rbp)        # Set j in stack
     jmp t2_29
 t2_61:
     mov -32(%rbp) ,%r12       # Load i from stack
     mov %r12, %r15     # _v234=i
     imul $8, %r15        # addr * 8
     mov -16(%rbp) ,%r13       # Load arr from stack
     add %r15, %r13     # addr + base
     mov %r13, %rcx
     mov (%rcx), %r14     # Array access
     mov %r14, -72(%rbp)        # Set x in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -72(%rbp) ,%r12       # Load x from stack
     mov %r12, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov -32(%rbp) ,%r13       # Load i from stack
     mov %r13, %r8     # _v111=i
     mov -32(%rbp) ,%r14       # Load i from stack
     add $1, %r13      #   i = i + 1
     mov %r13, -32(%rbp)        # Set i in stack
     jmp t2_25
 t2_71:
return_main:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
format:
    .asciz  "%d\n"
