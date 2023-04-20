      .global main
     .data
     .text
 main:
     pushq %rbp
     mov %rsp, %rbp      # beginFunc
     sub $64, %rsp       # stackPointer-= 48
     mov $69, %r12     # a=69
     mov %r12, -8(%rbp)        # Set a in stack
     mov $3, %r13     # b=3
     mov %r13, -16(%rbp)        # Set b in stack
     mov -8(%rbp) ,%r14       # Load a from stack
     mov -16(%rbp) ,%r15       # Load b from stack
     mov %r14, %rax
     cdq
     idiv %r15      #   _v38 = a / b
     mov %rax, %r8
     mov %r8, %r12     # c=_v38
     mov %r12, -24(%rbp)        # Set c in stack
     sub $32, %rsp       # For print statement
     mov $format, %rdi
     mov -24(%rbp) ,%r13       # Load c from stack
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
