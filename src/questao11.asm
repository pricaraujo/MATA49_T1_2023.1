; Questão 11
; Elabore um algoritmo que leia a altura de duas
; pessoas, verifique qual a mais alta, em seguida,
; responda mostrando qual a porcentagem que a outra é
; mais baixa enquanto a diferença for menor que 40%.
;Integrantes: Breno Cupertino, Carlos Melo, Thiago Seixas
section .data
str0        db  "Digite a primeira altura em cm",10,0  ; Mensagem para solicitar a primeira altura
str1        db  "Digite a segunda altura em cm",10,0  ; Mensagem para solicitar a segunda altura
resp1       db  "A pessoa 2 é menor que a pessoa 1 em %d %%",10,0  ; Mensagem de resposta se a pessoa 2 for menor que a pessoa 1
resp2       db  "A pessoa 1 é menor que a pessoa 2 em %d %%",10,0  ; Mensagem de resposta se a pessoa 1 for menor que a pessoa 2
resp3       db  "A diferença é maior ou igual a 40%%",10,0  ; Mensagem de resposta se a diferença for maior ou igual a 40%
resp4       db  "Os indivíduos têm a mesma altura",10,0  ; Mensagem de resposta se os indivíduos tiverem a mesma altura

fmt         db  "%d"  ; Formato de leitura/escrita para um número decimal

n1          dq 0  ; Variável para armazenar a primeira altura
n2          dq 0  ; Variável para armazenar a segunda altura

section .bss

res         resb 1  ; Variável de resultado

section .text
    global main
    extern printf, scanf
    
main:
    push    rbp    ; Instruções para depuração correta
    mov     rbp, rsp


    mov     rdi, str0  ; Imprime a mensagem solicitando a primeira altura
    mov     rax, 0
    call    printf

    mov     rdi, fmt  ; Lê a primeira altura
    mov     rsi, n1
    mov     rax, 0
    call    scanf
    
    mov     rdi, str1  ; Imprime a mensagem solicitando a segunda altura
    mov     rax, 0
    call    printf
    
    mov     rdi, fmt  ; Lê a segunda altura
    mov     rsi, n2
    mov     rax, 0
    call    scanf
    
    mov     rax, qword [n1]  ; Compara as alturas
    cmp     rax, qword [n2]
    je      Igual            ; Se forem iguais, pula para Igual
    
    cmp     rax, qword [n2]  ; Se a primeira altura for maior que a segunda, pula para n2Menor
    jg      n2Menor
    jmp     n1Menor          ; Se a segunda altura for maior que a primeira, pula para n1Menor
    
n2Menor:
    mov     rax, qword [n1]  ; Calcula a diferença
    sub     rax, qword [n2]
    
    mov     rbx, 100  ; Multiplica o valor em rax por 100
    mul     rbx
    
    mov     rbx, qword [n1] ; divide o valor em rax pela maior altura
    div     rbx
    mov     [res], al
    
    mov     al, 40
    cmp     byte [res], al
    jge     Maior40  ; Se a diferença for maior ou igual a 40%, pula para Maior40
    
    mov     rdi, resp1  ; Imprime a mensagem de resposta informando que a pessoa 2 é menor que a pessoa 1
    mov     rsi, [res]
    mov     rax, 0
    call    printf
    jmp     exit        ; Pula para o final do programa
        
n1Menor:
    mov     rax, qword [n2]  ; Calcula a diferença
    sub     rax, qword [n1]
    
    mov     rbx, 100 ; Multiplica o valor em rax por 100
    mul     rbx
   
    mov     rbx, qword [n2] ; divide o valor em rax pela maior altura
    div     rbx
    mov     [res], al
    
    mov     al, 40
    cmp     byte [res], al
    jge     Maior40  ; Se a diferença for maior ou igual a 40%, pula para Maior40
    
    mov     rdi, resp2  ; Imprime a mensagem de resposta informando que a pessoa 1 é menor que a pessoa 2
    mov     rsi, [res]
    mov     rax, 0
    call    printf
    jmp     exit        ; Pula para o final do programa
    
Maior40:
    mov     rdi, resp3  ; Imprime a mensagem de resposta informando que a diferença é maior ou igual a 40%
    mov     rax, 0
    call    printf
    jmp     exit        ; Pula para o final do programa
    
Igual:
    mov     rdi, resp4  ; Imprime a mensagem de resposta informando que os indivíduos têm a mesma altura
    mov     rax, 0
    call    printf
    jmp     exit        ; Pula para o final do programa
    
exit:
    leave           ; Desfaz as operações de criação do quadro de pilha
    mov     rax, 0  ; Define o valor de retorno como 0
    ret             ; Retorno do programa