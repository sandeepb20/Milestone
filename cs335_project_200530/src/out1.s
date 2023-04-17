      .global main
     .data
     .text
 main:
     mov $0, %rax     # a=0
     mov $3, %r8
     add $6, %r8      #   _v29 = 3 + 6
     mov %r8, %rbx     # b=_v29
     mov $0, %rcx     # c=0
     mov %rcx, %r9
     add $6, %r9      #   _v50 = c + 6
     mov %r9, %r10
     add %rax, %r10      #   _v53 = _v50 + a
     mov %r10, %r11
     add %rbx, %r11      #   _v56 = _v53 + b
     mov %r11, %r12
     add $8, %r12      #   _v59 = _v56 + 8
     mov %r12, %rdx     # d=_v59
    push %rbx
    push %rcx
    push %rdx
    mov $format, %rdi
    mov %rdx, %rsi
    call printf
    pop %rdx
    pop %rcx
    pop %rbx
    ret
format:
        .asciz  "%d\n"

