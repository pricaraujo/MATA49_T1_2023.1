; Questão 4: Escreva um programa em assembly que leia um valor N e calcule o valor fatorial
; Grupo: Lucas Lima, Lea Lisboa, Matheus Salaroli

section .data
  str1 db "Digite um numero para calcular o fatorial: ",10,0
  str2 db "O fatorial é igual a %d",10,0
  fmt db "%d"

  result dq 1

section .bss
  num resb 1

section .text
  extern printf, scanf
  global main

  main:
    call readNum
    call calculate
    call exit

  ; Faz a leitura do numero para calcular o fatorial e armazena em num
  readNum:
    mov rdi, str1
    mov rax, 0
    call printf

    mov rdi, fmt
    mov rsi, num
    mov rax, 0
    call scanf
    ret

  ; Calcula o fatorial do numero digitado pelo usuario
  calculate:
    cmp byte [num], 1
    jle resultCalculate

    mov rax, [result]
    mov rbx, [num]
    mul rbx
    mov [result], rax
    dec byte [num]

    jmp calculate
    ret

  ; Escreve o resultado do fatorial
  resultCalculate:
    mov rdi, str2
    mov rsi, [result]
    mov rax, 0
    call printf
    ret

  ; Finaliza o programa
  exit:
    mov rax, 60
    mov rdi, 0
    syscall
    ret
