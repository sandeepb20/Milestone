      .global main
     .data
     .text
 foo:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $48, %rsp       # stackPointer-= 32
     mov 16(%rbp) , %r8     #   Get Argument w
     mov %r8, -8(%rbp)     #   Store Argument w in stack
     mov -8(%rbp) ,%r12       # Load w from stack
     mov %r12, %r9
     add $1, %r9      #   _v23 = w + 1
     mov %r9, %r12     # w=_v23
     mov %r12, -8(%rbp)        # Set w in stack
     mov %r10, %rax     # Return _v-1
     jmp return_foo
return_foo:
     mov %rbp, %rsp
     leave 
     ret       # EndFunc
 main:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $32, %rsp       # stackPointer-= 16
     mov $1680, %r11     # _t1=1680
     mov %r11, %rdi     # Load Param _t1
     call malloc
     mov %rax, %r8     # Get Refernce from return reg in  _v71
     mov %r8, %r13     # a=_v71
     mov %r13, -8(%rbp)        # Set a in stack
     mov $1, %r9     # _v81=1
     mov %r9, %r9
     imul $7, %r9      #   _v81 = _v81 * 7
     mov %r9, %r9
     add $2, %r9      #   _v81 = _v81 + 2
     mov %r9, %r9
     imul $6, %r9      #   _v81 = _v81 * 6
     mov %r9, %r9
     add $3, %r9      #   _v81 = _v81 + 3
     imul $8, %r9        # addr * 8
     mov -8(%rbp) ,%r14       # Load a from stack
     add %r9, %r14     # addr + base
     mov %r14, %r10
     mov (%r10), %r15     # Array access
     mov %r15, -16(%rbp)        # Set x in stack
     pushq $1       # PushParam 1
     call foo
     mov %rax, %r11     # ReturnValue = _v101
     add $32, %rsp       # stackPointer+= 32
     mov $1, %r8     # _v109=1
     mov %r8, %r8
     imul $7, %r8      #   _v109 = _v109 * 7
     mov %r8, %r8
     add $2, %r8      #   _v109 = _v109 + 2
     mov %r8, %r8
     imul $6, %r8      #   _v109 = _v109 * 6
     mov %r8, %r8
     add $3, %r8      #   _v109 = _v109 + 3
     imul $8, %r8        # addr * 8
     mov -8(%rbp) ,%r12       # Load a from stack
     add %r8, %r12     # addr + base
     mov %r12, %r9
     mov (%r9), %r15     # Array access
     mov %r15, -16(%rbp)        # Set x in stack
      sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r13       # Load x from stack
     mov %r13, %rsi
     call printf
      add $32, %rsp       #For print stmt
      add $0, %rsp       # stackPointer+= 0
     mov $0, %rax     # Return 0
     jmp return_main
return_main:
     mov %rbp, %rsp
     leave 
     ret       # EndFunc
format:
    .asciz  "%d\n"
