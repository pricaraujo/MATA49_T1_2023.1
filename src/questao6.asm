section .data
    result db "%d", 0
    input db "%d", 0
    num dq 0

section .text
  global main
  extern printf, scanf

main:

  mov rdi, input
  mov rsi, num
  mov rax, 0
  call scanf

  mov rdi, [num]

  xor rax, rax
  xor rbx, rbx
  xor rcx, rcx
  mov rdx, 2 ;Limpa os registradores e guarda a soma dos dois primeiros nms da seq em rdx
  mov rax, 1
  mov rbx, 1 ;Salva os primeiros dois números de Fibonacci em rax e rbx

  .fibonacci_loop:
      add rax, rbx ;Soma os últimos dois números de fibonacci
      mov rcx, rax
      mov rax, rbx
      mov rbx, rcx ;Utiliza rcx como auxiliar para manter a ordem rax e rbx como os últimos dois números de FIbonacci
      add rdx, rcx ;Soma o último número de Fibonacci à soma de todos os números anteriores
      cmp rdx, rdi

      jge .fibonacci_exit
      jmp .fibonacci_loop ;Se a soma atual é menor que o número de entrada, repete o loop. Caso contrário, encerra o programa.

  .fibonacci_exit:
      push rbp
      mov rbp, rsp

      mov rsi, rdx
      mov rdi, result
      mov rax, 0
      call printf

      leave
      ret
