section .data

;Grupo: Gabriel Sizinio, Caio Mello, Fernando Schettini

;Comandos para rodar o código:

;nasm questao2.asm -f elf64
;gcc -o nat questao2.o questao2C.o -no-pie
;./nat

;Armazena na memória as strings e variáveis que serão utilizadas

s1 db "Numeros Lidos:", 10,0
s2 db "Media Aritmetica : %d", 10,0
s3 db "Media Geometrica: %d", 10,0
s4 db "Media Harmonica: %d", 10,0
s5 db "%d ", 10,0
s6 dd 0
fmt db "%d"

n1 dd 0
n2 dd 0
n3 dd 0
ma dd 0
mg dd 0
mh dd 0
zero dd 0

section .bss

;Armazena as variáveis que irão receber valores no programa

res resb 1

section .text
	global main
	extern printf, scanf, MArit, MGeo, MHarm, cbrtt
	
	;Chama as funções externas que vão ser utilizadas
	
	main:
	push rbp
	mov rbp, rsp
	
	mov rdi, fmt
	mov rsi, n1
	mov rax, 0
	call scanf
	
	;Lê o primeiro valor
	
	mov rdi, fmt
	mov rsi, n2
	mov rax, 0
	call scanf
	
	;Lê o segundo valor

	mov rdi, fmt
	mov rsi, n3
	mov rax, 0
	call scanf
	
	;Lê o terceiro valor
	
	mov rdi, s1
	mov rax, 0
	call printf
	
	;Imprime "Os valores lidos foram"
	
	mov rdi, s5
	mov rsi, [n1]
	mov rax, 0
	call printf
	
	;Imprime o primeiro valor lido

	mov rdi, s5
	mov rsi, [n2]
	mov rax, 0
	call printf
	
	;Imprime o segundo valor lido
	
	mov rdi, s5
	mov rsi, [n3]
	mov rax, 0
	call printf
	
	;Imprime o terceiro valor lido
	
	mov rdi, [n1]
	mov rsi, [n2]
	mov rdx, [n3]
	call MArit
	add rsp, 16
	
	;Põe os parâmetros em RDX, RDI e RSI, e chama a função MArit
	
	mov [ma], rax
	
	;Armazena o resultado na memória
	
	mov rdi, s2
	mov rsi, [ma]
	mov rax, [zero]
	call printf
	
	;Imprime o resultado
	
	mov rdi, [n1]
	mov rsi, [n2]
	mov rdx, [n3]
	call MGeo
	add rsp, 16
	mov [ma], rax
	
	;Põe os parâmetros em RDX, RDI e RSI, e chama a função MGeo
	;Armazena o resultado na memória

	mov rdi, s3
	mov rsi, [ma]
	mov rax, [zero]
	call printf
	
	;Imprime o resultado

	mov rdi, [n1]
	mov rsi, [n2]
	mov rdx, [n3]
	call MHarm
	add rsp, 16
	mov [ma], rax
	
	;Põe os parâmetros em RDX, RDI e RSI, e chama a função MHarm
	;Armazena o resultado na memória
	
	mov rdi, s4
	mov rsi, [ma]
	mov rax, [zero]
	call printf
	
	;Imprime o resultado
	
	leave
	mov rax, [zero]
	ret
	
	;Encerra o programa