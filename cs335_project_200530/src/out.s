      .global main
     .data
     .text
 foo1:
     push %rbp
     mov %rsp, %rbp      # beginFunc
     sub $8, %rsp       # stackPointer-= 8
     mov 16(%rbp) , %r8     #   Get Argument k
     mov %r8, -8(%rbp)     #   Store Argument k in stack
     mov -8(%rbp) ,%r12       # Load k from stack
     cmp $0, %r12
     je t2_3t
     mov $0, %r9
     jmp t2_3f
 t2_3t:
     mov $1, %r9
 t2_3f:
     cmp $1, %r9
     jne t2_7
     mov $0, %rax     # Return 0
     jmp return_foo1
     jmp t2_7
 t2_7:
     mov %r12, %r10     # _v35=k
     sub $1, %r12      #   k = k - 1
     sub $16, %rsp       # For print statement
     mov $format, %rdi
     mov %r12, %rsi
     call printf
     add $16, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     push %r12       # PushParam k
     call foo1
     mov %rax, %r11     # ReturnValue = _v50
     add $8, %rsp       # stackPointer+= 8
     mov %r8, %rax     # Return _v-1
     jmp return_foo1
return_foo1:
     mov %rbp, %rsp
     pop %rbp
     ret       # EndFunc
 main:
     push %rbp
     mov %rsp, %rbp      # beginFunc
     sub $16, %rsp       # stackPointer-= 16
     mov $69, %r13     # a=69
     mov %r13, -8(%rbp)        # Set a in stack
     mov $68, %r14     # c=68
     mov %r14, -16(%rbp)        # Set c in stack
     sub $16, %rsp       # For print statement
     mov $format, %rdi
     mov %r13, %rsi
     call printf
     add $16, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     push %r13       # PushParam a
     call foo1
     mov %rax, %r9     # ReturnValue = _v95
     add $8, %rsp       # stackPointer+= 8
     mov $0, %rax     # Return 0
     jmp return_main
return_main:
     mov %rbp, %rsp
     pop %rbp
     ret       # EndFunc
format:
    .asciz  "%d\n"
