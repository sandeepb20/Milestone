      .global main
     .data
     .text
Example1:
     mov $4, %r8
     mov $20, %rax
     cdq
     idiv %r8      #   _v14 = 20 / 4
     mov %rax, %r9
     mov $1, %r10
     add %r9, %r10      #   _v15 = 1 + _v14
     mov %r10, %r12     # x=_v15
     mov %r12, 0(%rbx)        # Set x in heap
     mov 0(%rbx) ,%r13       # Load x from heap
     mov %r13, %rax
     sal $2, %rax
     mov %rax, %r11
     mov %r11, %r14     # y=_v25
     mov %r14, 8(%rbx)        # Set y in heap
     mov 8(%rbx) ,%r15       # Load y from heap
     mov %r15, %r8
     add $1, %r8      #   _v35 = y + 1
     mov %r8, %r12     # k=_v35
     mov %r12, 16(%rbx)        # Set k in heap
     jmp ReturnToConsExample1
 Constructor:
           # Begin Constructor
     pushq %rbp
     mov %rsp, %rbp      # beginCon
     jmp Example1       # Jump to global vars
 ReturnToConsExample1:
     sub $32, %rsp       # stackPointer-= 16
     mov 16(%rbp) , %r9     #   Get Argument a
     mov %r9, -8(%rbp)     #   Store Argument a in stack
     mov 32(%rbp) , %r10     #   Get Argument b
     mov %r10, -16(%rbp)     #   Store Argument b in stack
     mov %rbx, %r11    #       move offset
     add $0, %r11     #   Get Obj ref 
     mov  -8(%rbp) , %r9       # Get a from stack
     mov %r9, (%r11)     # Field access
     mov %rbx, %r8    #       move offset
     add $8, %r8     #   Get Obj ref 
     mov  -16(%rbp) , %r10       # Get b from stack
     mov %r10, (%r8)     # Field access
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
 main:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $64, %rsp       # stackPointer-= 48
     mov $80, %r9     # _t1=80
     mov %r9, %rdi     # Load Param _t1
     call malloc
     mov %rax, %r10     # Get Refernce from return reg in  _v126
     mov %r10, %r13     # arr=_v126
     mov %r13, -8(%rbp)        # Set arr in stack
     sub $8, %rsp       # PushParam 3
     pushq $3       # PushParam 3
     sub $8, %rsp       # PushParam 29
     pushq $29       # PushParam 29
     mov $44, %r11     # _v136=44
     mov %r11, %rdi     # Load Param _v136
     call malloc
     mov %rax, %r8     # Get Refernce from return reg in  _v141
     mov %r8, %rbx     #       Load in rbx
     call Constructor
     mov %rbx, %r9     #       Load from rbx
     add $48, %rsp       # stackPointer+= 24
     mov %r9, %r14     # a=_v142
     mov %r14, -8(%rbp)        # Set a in stack
     sub $8, %rsp       # PushParam 10
     pushq $10       # PushParam 10
     sub $8, %rsp       # PushParam 5
     pushq $5       # PushParam 5
     mov $44, %r10     # _v153=44
     mov %r10, %rdi     # Load Param _v153
     call malloc
     mov %rax, %r11     # Get Refernce from return reg in  _v158
     mov %r11, %rbx     #       Load in rbx
     call Constructor
     mov %rbx, %r8     #       Load from rbx
     add $48, %rsp       # stackPointer+= 24
     mov %r8, %r15     # b=_v159
     mov %r15, -16(%rbp)        # Set b in stack
     sub $8, %rsp       # PushParam 100
     pushq $100       # PushParam 100
     mov -8(%rbp) ,%r12       # Load a from stack
     mov %r12, %rbx       #   Load Obj ref in rbx
     call setX
     mov %rax, %r9     # ReturnValue = _v175
     add $16, %rsp       # stackPointer+= 8
     mov %r9, %r13     # temp=_v175
     mov %r13, -32(%rbp)        # Set temp in stack
     mov -16(%rbp) ,%r14       # Load b from stack
     add $0, %r14     #   Get Obj ref 
     mov (%r14), %r10     #   Get Obj Value 
     mov %r10, %r15     # c=_v187
     mov %r15, -40(%rbp)        # Set c in stack
     mov -8(%rbp) ,%r12       # Load a from stack
     add $16, %r12     #   Get Obj ref 
     mov (%r12), %r11     #   Get Obj Value 
     mov %r11, %r13     # d=_v199
     mov %r13, -48(%rbp)        # Set d in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -40(%rbp) ,%r14       # Load c from stack
     mov %r14, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -48(%rbp) ,%r15       # Load d from stack
     mov %r15, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -32(%rbp) ,%r12       # Load temp from stack
     mov %r12, %rsi
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
     mov 16(%rbp) , %r8     #   Get Argument k2
     mov %r8, -8(%rbp)     #   Store Argument k2 in stack
     mov %rbx, %r9    #       move offset
     add $0, %r9     #   Get Obj ref 
     mov  -8(%rbp) , %r8       # Get k2 from stack
     mov %r8, (%r9)     # Field access
     mov -8(%rbp) ,%r13       # Load k2 from stack
     mov %r13, %rax     # Return k2
     jmp return_setX
return_setX:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
format:
    .asciz  "%d\n"
