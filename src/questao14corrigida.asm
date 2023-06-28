;Grupo 14: Marcelo Moura e Priscila

section .data

	horaExtra	dq 1.5
  horasTrabalhadas dq 0.0
  valHora dq 0.0
  standardHrs dq 160.0

  resultado dq 0.0
  valhoraExtra dq 0.0
  temp dq 0.0

	str1 db  "Digite o valor da hora",10,0	
  str2 db "Agora digite a quantidade de horas trabalhadas",10,0

	format dq "%lf"

section .text

	global 	main
	extern 	printf, scanf
	
	
	main:
	push 	rbp
	mov  	rbp, rsp

  

  ;imprime msg
  xor eax, eax
  lea rdi, [str1]
  call printf

  ;lê valor da hora
  mov eax, 1
  mov rdi, format
  mov rsi, valHora
  call scanf

  ;mais uma mensagem
  xor eax, eax
  lea rdi, [str2]
  call printf

  ;outro input
  mov rax, 1
  mov rdi, format
  mov rsi, horasTrabalhadas
  call scanf

  ;subtraindo todas as horas trabalhadas com 160 e comparando
  fld qword [horasTrabalhadas]
  fld qword [standardHrs]
 
  fcomi st1
  fstsw ax
  sahf
  fstp st0
  
  ja ifgreater

  xor eax, eax
  lea rdi, [str2]
  call printf
  fld qword [horasTrabalhadas]
  fmul qword [valHora]
  fstp qword [resultado]

  jmp end
  
  ifgreater:
    
    fld qword [standardHrs]
    fmul qword [valHora]
    fld qword [valHora]
    fmul qword [horaExtra]
    fstp qword [valhoraExtra]
    fld qword [horasTrabalhadas]
    fsub qword [standardHrs]
    fmul qword [valhoraExtra]

    faddp st1

    fstp qword [resultado]

  ;printar resultado
  movq xmm0, [resultado]
  mov rdi, format
  mov rax, 1
  call printf
  add rsp, 8

	;Finaliza o código
  end:
    leave
  	ret
