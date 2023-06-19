;; Questão 9 
;; Escreva um programa em assembly que receba os
;; três lados do triângulo, por exemplo, l1, l2 e l3. E
;; verifique se o triângulo é equilátero, isósceles, ou
;; escaleno
;; Grupo: Lucas dos Santos Lima e Joab Guimarães
section .data
    message_lado1 db "Insira o tamanho do primeiro lado: ",10,0
    message_lado2 db "Insira o tamanho do segundo lado: ",10,0
    message_lado3 db "Insira o tamanho do terceiro lado: ",10,0
    num db "%d",10,0
    equilatero db "Equilatero",10,0
    escaleno db "Escaleno",10,0
    isosceles db "Isosceles",10,0
    read_int db "%d",0

section .bss 
    lado_1: resb 1
    lado_2: resb 1
    lado_3: resb 1

section .text
    global main
    extern scanf 
    extern printf

print_equilatero: 
    mov rdi, equilatero
    mov rsi, 0
    mov rax, 0
    call printf
    jmp end

print_isosceles: 
    mov rdi, isosceles
    mov rsi, 0
    mov rax, 0
    call printf
    jmp end 

print_escaleno: 
    mov rdi, escaleno
    mov rsi, 0
    mov rax, 0
    call printf
    jmp end

main:   
    mov rbp, rsp
	push rbp

    ; Mensagem amigável pra inserir o primeiro lado 
    mov rdi, message_lado1
    mov rsi, 0
    mov rax, 0
    call printf


    ; Ler o primeiro lado com scanf 
    mov rdi, read_int
	mov rsi, lado_1
    mov rax, 0
    call scanf

    ; Mensagem amigável pra inserir o segundo lado 
    mov rdi, message_lado2
    mov rsi, 0
    mov rax, 0
    call printf

    ; Ler o segundo lado com scanf 
    mov rdi, read_int
	mov rsi, lado_2
    mov rax, 0
    call scanf

    ; Mensagem amigável pra inserir o terceiro lado 
    mov rdi, message_lado3
    mov rsi, 0
    mov rax, 0
    call printf

    ; Ler o terceiro lado com scanf 
    mov rdi, read_int
	mov rsi, lado_3
    mov rax, 0
    call scanf

    xor rsi, rsi 
    xor rdi, rdi 

    ; Verificando se é equilátero
    ; Caso os dois primeiros lados sejam iguais
    ; ir parar check_equilatero
    mov rax, [lado_1]
    mov r9, [lado_2]
    cmp rax, r9
    je check_equilatero

    ; Caso l1 e l3 sejam iguais, mas l1 e l2 sejam diferentes, 
    ; sabemos que ele é isosceles
    mov rax, [lado_1]
    mov r9, [lado_3]
    cmp rax, r9
    je print_isosceles

    jmp print_escaleno

; Verificar se os lados 1 e 3 são iguais
; Caso sejam, printar que é equilatero 
; Caso não, é isosceles
check_equilatero:
    mov rax, [lado_1]
    mov r9, [lado_3]
    cmp rax, r9
    je print_equilatero
    jmp print_isosceles

end: 
    mov rax, 60
    mov rdi, 0
    syscall
