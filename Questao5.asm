;Converter Fahrenheit para Celsius
;Daniel Fernandes & Elias Neto

section .data
    msg1 db "Digite a temperatura em Fahrenheit: ", 0
    msg2 db "A temperatura em Celsius é: %d", 10, 0

section .text
    global main
    extern printf, scanf

main:
    mov rdi, msg1
    mov rax, 0
    call printf

    ; lê a entrada do usuário em rsi
    mov rdi, "%d"
    sub rsp, 8 ; aloca espaço na pilha para armazenar o valor lido
    mov rsi, rsp 
    mov rax, 0
    call scanf
    add rsp, 8 ; desaloca o espaço da pilha

    ; carrega o valor lido em rax e converte para Celsius
    mov rax, [rsp]
    sub rax, 32
    imul rax, 5
    cqo ; estende o sinal de rax para rdx:rax
    mov rcx, 9
    idiv rcx

    ; imprime a mensagem 2 com o valor de rax
    mov rdi, msg2
    mov rsi, rax
    mov rax, 0
    call printf

    mov rax, 60
    mov rdi, 0
    syscall

