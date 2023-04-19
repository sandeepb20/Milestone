      .global main
     .data
     .text
 foo1:
     push %rbp
     mov %rsp, %rbp      # beginFunc
     sub $40, %rsp       # stackPointer-= 40
     mov 16(%rbp) , %r8     #   Get Argument k
     mov %r8, -8(%rbp)     #   Store Argument k in stack
     mov 24(%rbp) , %r9     #   Get Argument l
     mov %r9, -16(%rbp)     #   Store Argument l in stack
     mov 32(%rbp) , %r10     #   Get Argument m
     mov %r10, -24(%rbp)     #   Store Argument m in stack
     mov -8(%rbp) ,%r12       # Load k from stack
     cmp $0, %r12
     je t2_5t
     mov $0, %r11
     jmp t2_5f
 t2_5t:
     mov $1, %r11
 t2_5f:
     cmp $1, %r11
     jne t2_9
     mov $0, %rax     # Return 0
     jmp return_foo1
     jmp t2_9
 t2_9:
     mov %r12, %r8     # _v121=k
     sub $1, %r12      #   k = k - 1
     sub $16, %rsp       # For print statement
     mov $format, %rdi
     mov %r12, %rsi
     call printf
     add $16, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     push $10000000       # PushParam 10000000
     call foo2
     mov %rax, %r9     # ReturnValue = _v136
     add $8, %rsp       # stackPointer+= 8
     push $8888       # PushParam 8888
     call foo3
     mov %rax, %r10     # ReturnValue = _v144
     add $0, %rsp       # stackPointer+= 0
     mov -24(%rbp) ,%r13       # Load m from stack
     push %r13       # PushParam m
     mov -16(%rbp) ,%r14       # Load l from stack
     push %r14       # PushParam l
     push %r12       # PushParam k
     call foo1
     mov %rax, %r11     # ReturnValue = _v158
     add $24, %rsp       # stackPointer+= 24
     mov %r8, %rax     # Return _v-1
     jmp return_foo1
return_foo1:
     mov %rbp, %rsp
     pop %rbp
     ret       # EndFunc
 foo2:
     push %rbp
     mov %rsp, %rbp      # beginFunc
     sub $24, %rsp       # stackPointer-= 24
     mov 16(%rbp) , %r9     #   Get Argument z
     mov %r9, -8(%rbp)     #   Store Argument z in stack
     sub $16, %rsp       # For print statement
     mov $format, %rdi
     mov -8(%rbp) ,%r15       # Load z from stack
     mov %r15, %rsi
     call printf
     add $16, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov %r15, %rax     # Return z
     jmp return_foo2
return_foo2:
     mov %rbp, %rsp
     pop %rbp
     ret       # EndFunc
 foo3:
     push %rbp
     mov %rsp, %rbp      # beginFunc
     sub $8, %rsp       # stackPointer-= 8
     mov $88888, %r12     # p=88888
     mov %r12, -8(%rbp)        # Set p in stack
     sub $16, %rsp       # For print statement
     mov $format, %rdi
     mov %r12, %rsi
     call printf
     add $16, %rsp       #For print stmt
     add $0, %rsp       # stackPointer+= 0
     mov %r12, %rax     # Return p
     jmp return_foo3
return_foo3:
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
     push $0       # PushParam 0
     push %r14       # PushParam c
     push %r13       # PushParam a
     call foo1
     mov %rax, %r10     # ReturnValue = _v209
     add $24, %rsp       # stackPointer+= 24
     mov $0, %rax     # Return 0
     jmp return_main
return_main:
     mov %rbp, %rsp
     pop %rbp
     ret       # EndFunc
format:
    .asciz  "%d\n"
