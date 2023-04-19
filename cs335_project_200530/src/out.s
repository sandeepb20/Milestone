     .global main
     .data
     .text
 main:
     pushq %rbp
     movq %rsp, %rbp
     mov $480, %rdi
     call malloc
     mov %rax , -8(%rbp)
     mov $1, %r9     # _v53=1
     imul $6, %r9      #   _v53 = _v53 * 6
     add $2, %r9      #   _v53 = _v53 + 2
     imul $5, %r9      #   _v53 = _v53 * 5
     add $3, %r9      #   _v53 = _v53 + 3
     mov -8(%rbp), %rdx
     mov %r9, %rax
     mov (%rdx,%rax,4), %r10
     mov %r10, %rbx     # c=_v63
     mov %rbx, -12(%rbp)
     mov $1, %r11     # _v71=1
     imul $6, %r11      #   _v71 = _v71 * 6
     add $2, %r11      #   _v71 = _v71 + 2
     imul $5, %r11      #   _v71 = _v71 * 5
     add $3, %r11      #   _v71 = _v71 + 3
     mov -12(%rbp), %r12
     mov -8(%rbp), %rdx
     mov %r11, %rax
     imul $4, %rax
     add %rdx, %rax
     mov %r12, %rax
     mov $0, %rax 
     popq %rbp 
     ret 
format:
    .asciz  "%d\n"
