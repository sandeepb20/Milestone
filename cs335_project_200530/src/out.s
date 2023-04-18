      .global main
     .data
     .text
 foo:
     push %rbp
     mov %rsp, %rbp      # beginFunc
     sub $16 , %rsp
     sub $16, %rsp       # stackPointer-= 16
     mov 24(%rbp) , %r8d     #   Get Argument t
     mov %r8d, -4(%rbp)     #   Store Argument t in stack
     mov 32(%rbp) , %r9d     #   Get Argument w
     mov %r9d, -8(%rbp)     #   Store Argument w in stack
     mov 40(%rbp) , %r10d     #   Get Argument u
     mov %r10d, -12(%rbp)     #   Store Argument u in stack
     sub $16, %rsp       # For print statement
     mov $format, %rdi
     mov -4(%rbp) ,%r12d       # Load t from stack
     mov %r12d, %esi
     call printf
     add $16, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov $1, %eax     # Return 1
     mov %rbp, %rsp
     pop %rbp
     ret       # EndFunc
 main:
     push %rbp
     mov %rsp, %rbp      # beginFunc
     sub $16 , %rsp
     sub $16, %rsp       # stackPointer-= 16
     mov $9, %r13d     # a=9
     mov %r13d, -4(%rbp)        # Set a in stack
     push $37       # PushParam 37
     push $36       # PushParam 36
     push %r13       # PushParam a
     call foo
     mov %eax, %r11d     # ReturnValue = _v81
     add $16, %rsp       # stackPointer+= 16
     mov %r11d, %r14d     # k=_v81
     mov %r14d, -8(%rbp)        # Set k in stack
     mov $3, %r15d     # c=3
     mov %r15d, -12(%rbp)        # Set c in stack
     sub $16, %rsp       # For print statement
     mov $format, %rdi
     mov %r14d, %esi
     call printf
     add $16, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     sub $16, %rsp       # For print statement
     mov $format, %rdi
     mov %r15d, %esi
     call printf
     add $16, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov $1, %eax     # Return 1
     mov %rbp, %rsp
     pop %rbp
     ret       # EndFunc
format:
    .asciz  "%d\n"
