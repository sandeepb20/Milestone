      .global main
     .data
     .text
Example1:
     mov $9, %r12     # k=9
     mov %r12, 16(%rbx)        # Set k in heap
     jmp ReturnToConsExample1
 Constructor:
           # Begin Constructor
     pushq %rbp
     mov %rsp, %rbp      # beginCon
     jmp Example1       # Jump to global vars
 ReturnToConsExample1:
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
     sub $32, %rsp       # stackPointer-= 16
     sub $8, %rsp       # PushParam 29
     pushq $29       # PushParam 29
     sub $8, %rsp       # PushParam 27
     pushq $27       # PushParam 27
     mov $36, %r15     # _v72=36
     mov %r15, %rdi     # Load Param _v72
     call malloc
     mov %rax, %rcx     # Get Refernce from return reg in  _v77
     mov %rcx, %rbx     #       Load in rbx
     call Constructor
     mov %rbx, %r8     #       Load from rbx
     add $48, %rsp       # stackPointer+= 24
     mov %r8, %r13     # a=_v78
     mov %r13, -8(%rbp)        # Set a in stack
     mov $10, %r14     # m=10
     mov %r14, -16(%rbp)        # Set m in stack
     mov -8(%rbp) ,%r12       # Load a from stack
     add $16, %r12     #   Get Obj ref 
     mov (%r12), %r9     #   Get Obj Value 
     mov %r9, %r14     # m=_v97
     mov %r14, -16(%rbp)        # Set m in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r13       # Load m from stack
     mov %r13, %rsi
     call printf
     add $32, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov -8(%rbp) ,%r14       # Load a from stack
     add $0, %r14     #   Get Obj ref 
     mov %r14, %r10     #   Copy ref 
     mov $100, %r11
     mov %r11, (%r10)     # Obj assign
     mov -8(%rbp) ,%r12       # Load a from stack
     add $0, %r12     #   Get Obj ref 
     mov (%r12), %r15     #   Get Obj Value 
     mov %r15, %r13     # m=_v124
     mov %r13, -16(%rbp)        # Set m in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -16(%rbp) ,%r13       # Load m from stack
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
