;; -----------------------------------------------------
;; |    MATA49 - Programação de Software Básico        |
;; -----------------------------------------------------
;; | Grupo:                                            |
;; | David de Oliveira Lima                            |
;; | Israel Almeida Pedreira                           |
;; | Márcio dos Santos Junior                          |
;; -----------------------------------------------------
;; | Comandos de compilação:                           |
;; | nasm -g -f elf64 -F dwarf main.asm -o triangulo.o |
;; | gcc triangulo.o -o triangulo -lm -no-pie -m64     |
;; -----------------------------------------------------

section .data
    p1text db "Insira o primeiro ponto (x1, y1): ",0

    p2text db "Insira o segundo ponto (x2, y2): ",0
    flag db "Dois lados iguais", 0, 10
    p3text db "Insira o terceiro ponto (x3, y3): ",0

    pontosInseridos db "Pontos inseridos (p1, p2 e p3, respectivamente):",10,0   

    equilatero db "Os pontos formam um triângulo equilatero.",10,0    
    escaleno db "Os pontos formam um triângulo escaleno.",10,0   
    isosceles db "Os pontos formam um triângulo isosceles.",10,0
    
    formatacao_exibe_distancia db "Distância: %lf", 10 ,0
    formatacao_exibe_ponto db "(%lf, %lf)",10,0    
    formatacao_entrada db "%lf %lf",0

    valor_arredondamento dq 10000.0

section .bss
    x1 resq 1
    y1 resq 1
    x2 resq 1
    y2 resq 1
    x3 resq 1
    y3 resq 1
    d12 resq 1
    d23 resq 1
    d13 resq 1   

section .text
global main
extern printf, scanf

%macro print 1
    ; Exibe menssagem
    mov rdi, %1
    call printf
%endmacro

%macro printDist 1
    ; Exibe distancia
    mov rdi, formatacao_exibe_distancia
    movsd xmm0, qword [%1]
    call printf
%endmacro

%macro printPonto 2
    ; Exibe um ponto
    mov rdi, formatacao_exibe_ponto
    movsd xmm0, qword [%1]
    movsd xmm1, qword [%2]
    call printf
%endmacro

%macro lerPonto 3
    ; Faz a leitura de um ponto
    print %3

    mov rdi, formatacao_entrada
    mov rsi, %1
    mov rdx, %2
    call scanf
%endmacro

%macro distancia 5
    ;; %1 -> x1, %2 -> y1
    ;; %3 -> x2, %4 -> y2
    ;; %5 -> variável destino
    movsd xmm0, qword [%1]
    movsd xmm1, qword [%3]
    movsd xmm2, qword [%2]
    movsd xmm3, qword [%4]
    call calcularDistancia
    movsd qword [%5], xmm0
%endmacro

main:
    ;; Setar o rbp para a base da pilha
    push rbp
    ;; Stack pointer apontando para a base
    ;; (necessario para as funcoes externas)
    mov rbp, rsp

    ;; Leitura de pontos
    lerPonto x1, y1, p1text ;; Ponto 1
    lerPonto x2, y2, p2text ;; Ponto 2
    lerPonto x3, y3, p3text ;; Ponto 3

    ;; Printar os pontos
    print pontosInseridos ;; "Pontos inseridos (p1, p2, p3):"

    printPonto x1, y1
    printPonto x2, y2
    printPonto x3, y3

    ;; Calcular distância

    distancia x1, y1, x2, y2, d12
    distancia x1, y1, x3, y3, d13
    distancia x2, y2, x3, y3, d23

    ;exibe as distancias com 4 casas decimais
    printDist d12
    printDist d13
    printDist d23

    ;; Avaliar tipo do triângulo
    movsd xmm0, [d12]
    movsd xmm1, [d13]
    movsd xmm2, [d23]
    comisd xmm0, xmm1
    je doisLadosIguais    
    jmp doisLadosDiferentes

doisLadosIguais:    
    comisd xmm0, xmm2
    je isEquilatero
    jmp isIsosceles

doisLadosDiferentes:
    comisd xmm0, xmm2
    je isIsosceles    

    comisd xmm1, xmm2
    jne isEscaleno
    jmp isIsosceles

isEscaleno:
    print escaleno
    jmp finalizar

isIsosceles:
    print isosceles
    jmp finalizar

isEquilatero:
    print equilatero
    jmp finalizar

calcularDistancia:
    ; realiza o calculo da distancia euclidiana
    ;
    subsd xmm0, xmm1 ; x_1 - x_2
    mulsd xmm0, xmm0 ; (x_1 - x_2)²

    subsd xmm2, xmm3 ; y_1 - y_2
    mulsd xmm2, xmm2 ; (y_1 - y_2)²

    addsd xmm0, xmm2 ; (x_1 - x_2)²+* (y_1 - y_2)²

    sqrtsd xmm0, xmm0 ; sqrt( (x_1 - x_2)²+* (y_1 - y_2)² )

    ;; Arredondar para duas casas decimais
    movsd xmm1, [valor_arredondamento] ; define a quantidade de casas do arredondamento
    mulsd xmm0, xmm1                   ; resultado * arredondamento
    roundsd xmm0, xmm0, 1              ; round(resultado * arredondamento)
    divsd xmm0, xmm1                   ; round(resultado * arredondamento) / arredondamento
    ret

finalizar:
    ;; Finalizar programa
    mov rax, 0
    mov rbx, 0
    leave
    ret
