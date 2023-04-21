.LC0:
  .string "%d"
.LC1:
  .string "\n"
.LC2:
  .string "fun "
.LC3:
  .string "a="
.LC4:
  .string " b="
.LC5:
  .string "a="
.LC6:
  .string " b="
.LC7:
  .string " c="
.LC8:
  .string " d="
.LC9:
  .string " e="
.LC10:
  .string " f="
.LC11:
  .string " g="
.LC12:
  .string " h1="
.LC13:
  .string " h2="
test_15_fun:
  pushq %rbp
  movq %rsp, %rbp
  subq $48, %rsp
  movq $0, %rax
  cmpq 24(%rbp), %rax
  setle %al
  movzbl %al, %eax
  movq %rax, -8(%rbp)
  movq 24(%rbp), %rbx
  mov %rbx, %rax
  leave
  ret
.L2:
  movq $.LC2, %rdi
  movl $0, %eax
  call printf
  movq 24(%rbp), %r10
  movq %r10, %rsi
  movq $.LC0, %rdi
  movl $0, %eax
  call printf
  movq $.LC1, %rdi
  movl $0, %eax
  call printf
  movq 24(%rbp), %r11
  movq $1, %r12
  subq %r11, %r12
  movq %r12, -40(%rbp)
  pushq -40(%rbp)
  pushq 16(%rbp)
  call test_15_fun
  movq %rax, -32(%rbp)
  addq $16, %rsp
  movq -32(%rbp), %r13
  mov %r13, %rax
  leave
  ret
  leave
  ret
  .globl main
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $352, %rsp
  movq $100, %r14
  movq %r14, -8(%rbp)
  movq $5, %rbx
  movq %rbx, -16(%rbp)
  movq $.LC3, %rdi
  movl $0, %eax
  call printf
  movq -8(%rbp), %r10
  movq %r10, %rsi
  movq $.LC0, %rdi
  movl $0, %eax
  call printf
  movq $.LC4, %rdi
  movl $0, %eax
  call printf
  movq -16(%rbp), %r11
  movq %r11, %rsi
  movq $.LC0, %rdi
  movl $0, %eax
  call printf
  movq $.LC1, %rdi
  movl $0, %eax
  call printf
  movq -8(%rbp), %rax
  imulq -16(%rbp), %rax
  movq %rax, -104(%rbp)
  movq -104(%rbp), %r12
  movq %r12, -24(%rbp)
  movq -8(%rbp), %r13
  movq -24(%rbp), %r14
  addq %r13, %r14
  movq %r14, -112(%rbp)
  movq -112(%rbp), %rbx
  movq %rbx, -32(%rbp)
  movq -8(%rbp), %r10
  movq -16(%rbp), %r11
  addq %r10, %r11
  movq %r11, -136(%rbp)
  movq -136(%rbp), %r12
  movq -24(%rbp), %r13
  addq %r12, %r13
  movq %r13, -128(%rbp)
  movq -128(%rbp), %r14
  movq -32(%rbp), %rbx
  addq %r14, %rbx
  movq %rbx, -120(%rbp)
  movq -120(%rbp), %r10
  movq %r10, -40(%rbp)
  movq -8(%rbp), %r11
  movq -16(%rbp), %r12
  addq %r11, %r12
  movq %r12, -168(%rbp)
  movq -168(%rbp), %r13
  movq -24(%rbp), %r14
  addq %r13, %r14
  movq %r14, -160(%rbp)
  movq -160(%rbp), %rbx
  movq -32(%rbp), %r10
  addq %rbx, %r10
  movq %r10, -152(%rbp)
  movq -152(%rbp), %r11
  movq -40(%rbp), %r12
  addq %r11, %r12
  movq %r12, -144(%rbp)
  movq -144(%rbp), %r13
  movq %r13, -48(%rbp)
  movq -8(%rbp), %rax
  imulq -16(%rbp), %rax
  movq %rax, -256(%rbp)
  movq -256(%rbp), %rax
  imulq -24(%rbp), %rax
  movq %rax, -248(%rbp)
  movq -248(%rbp), %rax
  imulq -32(%rbp), %rax
  movq %rax, -240(%rbp)
  movq -240(%rbp), %rax
  imulq -40(%rbp), %rax
  movq %rax, -232(%rbp)
  movq -232(%rbp), %rax
  imulq -48(%rbp), %rax
  movq %rax, -224(%rbp)
  movq -224(%rbp), %rax
  imulq -8(%rbp), %rax
  movq %rax, -216(%rbp)
  movq -216(%rbp), %rax
  imulq -16(%rbp), %rax
  movq %rax, -208(%rbp)
  movq -208(%rbp), %rax
  imulq -24(%rbp), %rax
  movq %rax, -200(%rbp)
  movq -200(%rbp), %rax
  imulq -32(%rbp), %rax
  movq %rax, -192(%rbp)
  movq -192(%rbp), %rax
  imulq -40(%rbp), %rax
  movq %rax, -184(%rbp)
  movq -184(%rbp), %rax
  imulq -48(%rbp), %rax
  movq %rax, -176(%rbp)
  movq -176(%rbp), %r14
  movq %r14, -56(%rbp)
  movq $100, %rbx
  movq %rbx, -64(%rbp)
  pushq $1
  pushq 16(%rbp)
  call test_15_fun
  movq %rax, -280(%rbp)
  addq $16, %rsp
  pushq -280(%rbp)
  pushq 16(%rbp)
  call test_15_fun
  movq %rax, -272(%rbp)
  addq $16, %rsp
  pushq -272(%rbp)
  pushq 16(%rbp)
  call test_15_fun
  movq %rax, -264(%rbp)
  addq $16, %rsp
  movq -264(%rbp), %r10
  movq %r10, -72(%rbp)
  pushq $1
  pushq 16(%rbp)
  call test_15_fun
  movq %rax, -296(%rbp)
  addq $16, %rsp
  pushq -296(%rbp)
  pushq 16(%rbp)
  call test_15_fun
  movq %rax, -288(%rbp)
  addq $16, %rsp
  movq -288(%rbp), %r11
  movq %r11, -80(%rbp)
  pushq $55
  pushq 16(%rbp)
  call test_15_fun
  movq %rax, -304(%rbp)
  addq $16, %rsp
  movq -304(%rbp), %r12
  movq %r12, -88(%rbp)
  movq -72(%rbp), %r13
  movq %r13, %rsi
  movq $.LC0, %rdi
  movl $0, %eax
  call printf
  movq $.LC1, %rdi
  movl $0, %eax
  call printf
  movq -80(%rbp), %r14
  movq %r14, %rsi
  movq $.LC0, %rdi
  movl $0, %eax
  call printf
  movq $.LC1, %rdi
  movl $0, %eax
  call printf
  movq -88(%rbp), %rbx
  movq %rbx, %rsi
  movq $.LC0, %rdi
  movl $0, %eax
  call printf
  movq $.LC1, %rdi
  movl $0, %eax
  call printf
  movq $.LC5, %rdi
  movl $0, %eax
  call printf
  movq -8(%rbp), %r10
  movq %r10, %rsi
  movq $.LC0, %rdi
  movl $0, %eax
  call printf
  movq $.LC6, %rdi
  movl $0, %eax
  call printf
  movq -16(%rbp), %r11
  movq %r11, %rsi
  movq $.LC0, %rdi
  movl $0, %eax
  call printf
  movq $.LC7, %rdi
  movl $0, %eax
  call printf
  movq -24(%rbp), %r12
  movq %r12, %rsi
  movq $.LC0, %rdi
  movl $0, %eax
  call printf
  movq $.LC8, %rdi
  movl $0, %eax
  call printf
  movq -32(%rbp), %r13
  movq %r13, %rsi
  movq $.LC0, %rdi
  movl $0, %eax
  call printf
  movq $.LC9, %rdi
  movl $0, %eax
  call printf
  movq -40(%rbp), %r14
  movq %r14, %rsi
  movq $.LC0, %rdi
  movl $0, %eax
  call printf
  movq $.LC10, %rdi
  movl $0, %eax
  call printf
  movq -48(%rbp), %rbx
  movq %rbx, %rsi
  movq $.LC0, %rdi
  movl $0, %eax
  call printf
  movq $.LC11, %rdi
  movl $0, %eax
  call printf
  movq -56(%rbp), %r10
  movq %r10, %rsi
  movq $.LC0, %rdi
  movl $0, %eax
  call printf
  movq $.LC12, %rdi
  movl $0, %eax
  call printf
  movq -72(%rbp), %r11
  movq %r11, %rsi
  movq $.LC0, %rdi
  movl $0, %eax
  call printf
  movq $.LC13, %rdi
  movl $0, %eax
  call printf
  movq -88(%rbp), %r12
  movq %r12, %rsi
  movq $.LC0, %rdi
  movl $0, %eax
  call printf
  movq $.LC1, %rdi
  movl $0, %eax
  call printf
  leave
  ret

