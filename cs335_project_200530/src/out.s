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
     mov -8(%rbp) ,%r12       # Load a from stack
     mov -8(%rbp) ,%r13       # Load a from stack
     mov %r12, %r10
     imul %r13, %r10      #   _v34 = a * a
     mov -16(%rbp) ,%r14       # Load b from stack
     cmp %r10, %r14
     je t2_6t
     mov $0, %r11
     jmp t2_6f
 t2_6t:
     mov $1, %r11
 t2_6f:
     cmp $1, %r11
     jne t2_13
     mov %rbx, %r15    #       move offset
     add $8, %r15     #   Get Obj ref 
     mov -8(%rbp) ,%r12       # Load a from stack
     mov %r12, (%r15)     # Field access
     mov %rbx, %rcx    #       move offset
     add $0, %rcx     #   Get Obj ref 
     mov -16(%rbp) ,%r13       # Load b from stack
     mov %r13, (%rcx)     # Field access
     jmp t2_18
 t2_13:
     mov %rbx, %r8    #       move offset
     add $8, %r8     #   Get Obj ref 
     mov -8(%rbp) ,%r14       # Load a from stack
     mov %r14, (%r8)     # Field access
     mov %rbx, %r9    #       move offset
     add $0, %r9     #   Get Obj ref 
     mov -8(%rbp) ,%r12       # Load a from stack
     mov -8(%rbp) ,%r13       # Load a from stack
     mov %r12, %r10
     imul %r13, %r10      #   _v78 = a * a
     mov %r10, (%r9)     # Field access
 t2_18:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
 get_x:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $32, %rsp       # stackPointer-= 16
     mov 16(%rbp) , %r11     #   Get Argument sr1
     mov %r11, -8(%rbp)     #   Store Argument sr1 in stack
     mov -8(%rbp) ,%r14       # Load sr1 from stack
     add $8, %r14     #   Get Obj ref 
     mov (%r14), %r15     #   Get Obj Value 
     mov %r15, %r12     # temp=_v148
     mov %r12, -16(%rbp)        # Set temp in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r13       # Load temp from stack
     mov %r13, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov -16(%rbp) ,%r14       # Load temp from stack
     mov %r14, %rax     # Return temp
     jmp return_get_x
return_get_x:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
 get_y:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $32, %rsp       # stackPointer-= 16
     mov 16(%rbp) , %rcx     #   Get Argument sr
     mov %rcx, -8(%rbp)     #   Store Argument sr in stack
     mov -8(%rbp) ,%r12       # Load sr from stack
     add $0, %r12     #   Get Obj ref 
     mov (%r12), %r8     #   Get Obj Value 
     mov $1, %r9
     add %r8, %r9      #   _v110 = 1 + _v109
     mov %r9, %r13     # temps=_v110
     mov %r13, -16(%rbp)        # Set temps in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r14       # Load temps from stack
     mov %r14, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov -16(%rbp) ,%r12       # Load temps from stack
     mov %r12, %rax     # Return temps
     jmp return_get_y
return_get_y:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
 main:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $48, %rsp       # stackPointer-= 32
     sub $8, %rsp       # PushParam 19
     pushq $19       # PushParam 19
     sub $8, %rsp       # PushParam 4
     pushq $4       # PushParam 4
     mov $44, %r10     # _v184=44
     mov %r10, %rdi     # Load Param _v184
     call malloc
     mov %rax, %r11     # Get Refernce from return reg in  _v189
     mov %r11, %rbx     #       Load in rbx
     call Constructor
     mov %rbx, %r15     #       Load from rbx
     add $48, %rsp       # stackPointer+= 24
     mov %r15, %r13     # num=_v190
     mov %r13, -8(%rbp)        # Set num in stack
     mov -8(%rbp) ,%r14       # Load num from stack
     add $0, %r14     #   Get Obj ref 
     mov (%r14), %rcx     #   Get Obj Value 
     mov %rcx, %r12     # x1=_v201
     mov %r12, -16(%rbp)        # Set x1 in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r13       # Load x1 from stack
     mov %r13, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov -8(%rbp) ,%r14       # Load num from stack
     sub $8, %rsp       # PushParam num
     pushq %r14       # PushParam num
     call get_x
     mov %rax, %r8     # ReturnValue = _v221
     add $16, %rsp       # stackPointer+= 8
     mov %r8, %r12     # w=_v221
     mov %r12, -24(%rbp)        # Set w in stack
     mov -8(%rbp) ,%r13       # Load num from stack
     sub $8, %rsp       # PushParam num
     pushq %r13       # PushParam num
     call get_y
     mov %rax, %r9     # ReturnValue = _v234
     add $16, %rsp       # stackPointer+= 8
     mov %r9, %r14     # r=_v234
     mov %r14, -32(%rbp)        # Set r in stack
return_main:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
format:
    .asciz  "%d\n"
