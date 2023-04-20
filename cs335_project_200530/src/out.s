      .global main
     .data
     .text
 Constructor:
           # Begin Constructor
     pushq %rbp
     mov %rsp, %rbp      # beginCon
     sub $32, %rsp       # stackPointer-= 16
     mov 16(%rbp) , %r8     #   Get Argument a1
     mov %r8, -8(%rbp)     #   Store Argument a1 in stack
     mov 32(%rbp) , %r9     #   Get Argument b1
     mov %r9, -16(%rbp)     #   Store Argument b1 in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r12       # Load b1 from stack
     mov %r12, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov %rbx, %r10    #       move offset
     add $0, %r10     #   Get Obj ref 
     mov  -16(%rbp) , %r11       # Get b1 from stack
     mov %r11, (%r10)     # Field access
     mov %rbx, %r15    #       move offset
     add $8, %r15     #   Get Obj ref 
     mov  -8(%rbp) , %rcx       # Get a1 from stack
     mov %rcx, (%r15)     # Field access
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
 get_x:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $32, %rsp       # stackPointer-= 16
     mov 16(%rbp) , %r8     #   Get Argument sr
     mov %r8, -8(%rbp)     #   Store Argument sr in stack
     mov -8(%rbp) ,%r13       # Load sr from stack
     add $8, %r13     #   Get Obj ref 
     mov (%r13), %r9     #   Get Obj Value 
     mov %r9, %r14     # temp=_v112
     mov %r14, -16(%rbp)        # Set temp in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r12       # Load temp from stack
     mov %r12, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov -16(%rbp) ,%r13       # Load temp from stack
     mov %r13, %rax     # Return temp
     jmp return_get_x
return_get_x:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
 get_y:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $32, %rsp       # stackPointer-= 16
     mov 16(%rbp) , %r10     #   Get Argument sr
     mov %r10, -8(%rbp)     #   Store Argument sr in stack
     mov -8(%rbp) ,%r14       # Load sr from stack
     add $0, %r14     #   Get Obj ref 
     mov (%r14), %r11     #   Get Obj Value 
     mov %r11, %r12     # temps=_v74
     mov %r12, -16(%rbp)        # Set temps in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r13       # Load temps from stack
     mov %r13, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov -16(%rbp) ,%r14       # Load temps from stack
     mov %r14, %rax     # Return temps
     jmp return_get_y
return_get_y:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
 main:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $64, %rsp       # stackPointer-= 48
     sub $8, %rsp       # PushParam 16
     pushq $16       # PushParam 16
     sub $8, %rsp       # PushParam 4
     pushq $4       # PushParam 4
     mov $44, %r15     # _v148=44
     mov %r15, %rdi     # Load Param _v148
     call malloc
     mov %rax, %rcx     # Get Refernce from return reg in  _v153
     mov %rcx, %rbx     #       Load in rbx
     call Constructor
     mov %rbx, %r8     #       Load from rbx
     add $48, %rsp       # stackPointer+= 24
     mov %r8, %r12     # num=_v154
     mov %r12, -8(%rbp)        # Set num in stack
     mov -8(%rbp) ,%r13       # Load num from stack
     sub $8, %rsp       # PushParam num
     pushq %r13       # PushParam num
     call get_x
     mov %rax, %r9     # ReturnValue = _v166
     add $16, %rsp       # stackPointer+= 8
     mov %r9, %r14     # a=_v166
     mov %r14, -16(%rbp)        # Set a in stack
     mov -8(%rbp) ,%r12       # Load num from stack
     sub $8, %rsp       # PushParam num
     pushq %r12       # PushParam num
     call get_y
     mov %rax, %r10     # ReturnValue = _v179
     add $16, %rsp       # stackPointer+= 8
     mov %r10, %r13     # b=_v179
     mov %r13, -24(%rbp)        # Set b in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r14       # Load a from stack
     mov %r14, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -24(%rbp) ,%r12       # Load b from stack
     mov %r12, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
return_main:
     mov %rbp, %rsp
     popq %rbp
     ret       # EndFunc
format:
    .asciz  "%d\n"
