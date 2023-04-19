     .global main
     .data
     .text
 main:
     pushq %rbp
     movq %rsp, %rbp
     mov $480, %rdi
     call malloc
     mov %rax , -8(%rbp)
     mov $4, %rbx     # c=4
     mov %rbx, -12(%rbp)
     mov $1, %r9     # _v59=1
     imul $6, %r9      #   _v59 = _v59 * 6
     add $2, %r9      #   _v59 = _v59 + 2
     imul $5, %r9      #   _v59 = _v59 * 5
     add $3, %r9      #   _v59 = _v59 + 3
     mov -12(%rbp), %r10
     mov -8(%rbp), %rdx
     mov %r9, %rax
     imul $4, %rax
     add %rdx, %rax
     mov %r10, %rax
     mov $0, %rax 
     popq %rbp 
     ret 
format:
    .asciz  "%d\n"
