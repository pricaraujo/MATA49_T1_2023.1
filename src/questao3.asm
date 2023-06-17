;; Questão 3: Criar um programa em Assembly que inverta a ordem
;; dos elementos de um vetor de tamanho n
;; Grupo: Dely, Igor Prado, Lucas Azevedo
;; 11 de junho de 2023
;;
;; Instruções de compilação e execução
;; (OS testado : Linux Mint 20.3 Una, Kernel 5.4.0-150-generic x86_64)
;; (CPU: AMD Ryzen 3 3200G with Radeon Vega Graphics)
;; (NASM: NASM version 2.14.02)
;; (GCC: gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1))
;; Compile com "nasm -f elf64 -o questao3.o questao3.asm"
;; Link utilizando "gcc -no-pie -o questao3 questao3.o"
;; Execute com "./questao3"
;;
;; Instruções de uso:
;; O tamanho (n) do vetor deve ser passado em uma única linha.
;; Apenas valores 1 <= n <= 1000 são aceitos, em qualquer outro caso
;; o programa termina.
;; Cada elemento do vetor deve ser passado em uma linha separada:
;; Ex.:
;; 4
;; 1
;; 2
;; 3
;; 4

section .data
    fmt_in db "%d", 0
    fmt_out db "%d ", 0
    n dq 0
    i dq 0                      ;loop index
    ;; NOTE: we use a loop index saved in memmory because scanf (and print) might modify some (or all) registers
    v times 1000 dq 0
    null db 0

section .text
    global main
    extern printf, scanf

%define INTSIZE 8

reverse:
    ;; @params (on stack, in this order)
    ;; 1. pointer to start of array
    ;; 2. size of array
    ;; NOTE: does not preserve stack

    ;; remove ra (return address) from stack
    pop qword rax

    pop qword rdx
    pop qword rsi

    ;; put ra back on stack
    push qword rax

    mov rcx, 0
    .reverse_loop:
        mov rax, rcx
        add rax, rcx
        cmp qword rax, rdx
        jge .reverse_end
        lea r8, [rsi + INTSIZE * rcx] ;a[i]
        lea r9, [rsi + INTSIZE * rdx - INTSIZE] ;a[n-1-i]
        lea r10, [INTSIZE * rcx]
        sub r9, r10
        push qword [r8]
        push qword [r9]
        pop qword [r8]
        pop qword [r9]
        inc rcx
        jmp .reverse_loop
    .reverse_end:
        mov r8, 0
        ret

main:
    push rbp
    mov rbp, rsp

    mov rdi, fmt_in
    mov rsi, n
    mov rax, 0
    call scanf

    ;; input validation (1 <= n <= 1000)
    mov rax, [n]
    cmp rax, 1000
    jg .main_end
    cmp rax, 0
    jle .main_end
    xor rax, rax

    mov qword [i], 0
    .read_loop:
        mov rcx, [i]
        mov rdx, [n]
        cmp rcx, rdx
        jge .read_end
        ;; call scanf
        mov rdi, fmt_in
        lea rsi, [v + INTSIZE*rcx]
        mov rax, 0
        call scanf
        mov rcx, [i]
        inc rcx
        mov [i], rcx
        jmp .read_loop
    .read_end:
        push qword v
        push qword [n]
        call reverse

    mov qword [i], 0
    .print_loop:
        mov rcx, [i]
        mov rdx, [n]
        cmp qword rcx, rdx
        jge .main_end
        mov rdi, fmt_out
        mov rsi, [v + INTSIZE * rcx]
        mov rax, 0
        call printf
        mov rcx, [i]
        inc rcx
        mov [i], rcx
        jmp .print_loop
    .main_end:
        leave
        mov rax, 0
        ret
