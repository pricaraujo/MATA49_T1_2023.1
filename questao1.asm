section .data


;Grupo 01: Fabrício Silva e Victor Coutinho


	n1	dq 0.0
	n3 	dq 0.0
	n5	dq 4.0
	
	str1   	db  "Digite a %d° altura",10,0
	str2    db  "A média das alturas é %.2f",10,0
	
	fmt 	dq "%lf"

	
section .text

	global 	main
	extern 	printf, scanf
	
	
	main:
	push 	rbp
	mov  	rbp, rsp
	
	;Inicialização do registrador XMM6, que armazenará a soma das alturas
	movq 	xmm6, [n3]


	;Inicialização dos registradores que controlarão o loop
	mov 	r12, 0
	mov 	r13, 4
	

	.loop:
	
	inc 	r12

	;Impressão da mensagem na tela
	mov     rdi, str1
    	mov     rsi, r12
    	mov     rax, 0
    	call    printf
	
	;Recebe os valores das alturas
	mov 	rdi, fmt
	mov 	rsi, n1
	mov 	rax, 1
	call 	scanf

	;Armazena os valores lidos em XMM6
	movq 	xmm0, [n1]
	addsd 	xmm6, xmm0
	
	;Condicional de execução do loop
	cmp 	r12, r13
	je 	.end
	jmp 	.loop

	
	.end:

	;Calcula a média das alturas
	movq 	xmm1, [n5]
	movq 	xmm0, xmm6
	divsd 	xmm0, xmm1
	
	;Imprime o resultado na tela
	mov     rdi, str2
	call 	printf


	;Finaliza o código	
	leave
	ret
