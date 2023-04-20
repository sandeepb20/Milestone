      .global main
     .data
     .text
 Constructor:
           # Begin Constructor
     pushq %rbp
     mov %rsp, %rbp      # beginCon
     sub $32, %rsp       # stackPointer-= 16
     mov 16(%rbp) , %r8     #   Get Argument a
     mov %r8, -8(%rbp)     #   Store Argument a in stack
     mov 32(%rbp) , %r9     #   Get Argument b
     mov %r9, -16(%rbp)     #   Store Argument b in stack
     mov %rbx, %r10    #       move offset
     add $0, %r10     #   Get Obj ref 
     mov  -8(%rbp) , %r8       # Get a from stack
     mov %r8, (%r10)     # Field access
     mov %rbx, %r11    #       move offset
     add $8, %r11     #   Get Obj ref 
     mov  -16(%rbp) , %r9       # Get b from stack
     mov %r9, (%r11)     # Field access
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
 main:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $64, %rsp       # stackPointer-= 48
     mov $80, %r8     # _t1=80
     mov %r8, %rdi     # Load Param _t1
     call malloc
     mov %rax, %r9     # Get Refernce from return reg in  _v105
     mov %r9, %r12     # arr=_v105
     mov %r12, -8(%rbp)        # Set arr in stack
     sub $8, %rsp       # PushParam 3
     pushq $3       # PushParam 3
     sub $8, %rsp       # PushParam 29
     pushq $29       # PushParam 29
     mov $44, %r10     # _v115=44
     mov %r10, %rdi     # Load Param _v115
     call malloc
     mov %rax, %r11     # Get Refernce from return reg in  _v120
     mov %r11, %rbx     #       Load in rbx
     call Constructor
     mov %rbx, %r8     #       Load from rbx
     add $48, %rsp       # stackPointer+= 24
     mov %r8, %r13     # a=_v121
     mov %r13, -8(%rbp)        # Set a in stack
     sub $8, %rsp       # PushParam 10
     pushq $10       # PushParam 10
     sub $8, %rsp       # PushParam 5
     pushq $5       # PushParam 5
     mov $44, %r9     # _v132=44
     mov %r9, %rdi     # Load Param _v132
     call malloc
     mov %rax, %r10     # Get Refernce from return reg in  _v137
     mov %r10, %rbx     #       Load in rbx
     call Constructor
     mov %rbx, %r11     #       Load from rbx
     add $48, %rsp       # stackPointer+= 24
     mov %r11, %r14     # b=_v138
     mov %r14, -16(%rbp)        # Set b in stack
     mov -8(%rbp) ,%r15       # Load a from stack
     add $24, %r15     #   Get Obj ref 
     mov (%r15), %r8     #   Get Obj Value 
     mov %r8, %r12     # temp=_v150
     mov %r12, -32(%rbp)        # Set temp in stack
     mov -16(%rbp) ,%r13       # Load b from stack
     add $0, %r13     #   Get Obj ref 
     mov (%r13), %r9     #   Get Obj Value 
     mov %r9, %r14     # c=_v162
     mov %r14, -40(%rbp)        # Set c in stack
     mov -8(%rbp) ,%r15       # Load a from stack
     add $0, %r15     #   Get Obj ref 
     mov (%r15), %r10     #   Get Obj Value 
     mov %r10, %r12     # d=_v174
     mov %r12, -48(%rbp)        # Set d in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -40(%rbp) ,%r13       # Load c from stack
     mov %r13, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -48(%rbp) ,%r14       # Load d from stack
     mov %r14, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
return_main:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
 setX:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $48, %rsp       # stackPointer-= 32
     mov 48(%rbp) , %r11     #   Get Argument k
     mov %r11, -24(%rbp)     #   Store Argument k in stack
     mov %rbx, %r8    #       move offset
     add $0, %r8     #   Get Obj ref 
     mov  -24(%rbp) , %r11       # Get k from stack
     mov %r11, (%r8)     # Field access
     mov -24(%rbp) ,%r15       # Load k from stack
     mov %r15, %rax     # Return k
     jmp return_setX
return_setX:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
format:
    .asciz  "%d\n"
