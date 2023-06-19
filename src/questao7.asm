; Questão 7: Leia a idade de uma pessoa expressa em anos, meses e dias e escreva somente em dias.
; Equipe: Yan Brandão, João Gabriel Lofiego, João Soares

global main
extern printf
extern scanf

section .bss
    anos resb 3 ; Maximo de 999
    meses resb 4 ; Maximo de 9.999
    dias resb 6 ; Maximo de 99.999

section .data
    anosMsg db "Quantos anos voce tem?", 10, 0
    
    mesesMsg db "E quantos meses?", 10, 0
    
    diasMsg db "E quantos dias?", 10, 0
    
    intformat db "%d", 0 ; Formato para poder pegar o int no scanf
    
    final db "Voce tem %d dias", 10, 0
    
section .text
main:
    ;Padrao de comeco, n entendi direito, mas sem isso nao roda
    push rbp
    mov rbp, rsp

    ;print da pergunta dos anos
    mov rdi, anosMsg
    call printf
    
    ;scan do numero de anos
    mov rdi, intformat
    mov rsi, anos
    call scanf
    
    ;armazena o valor de anos no rbx
    mov rbx, [anos]
    
    ;print da pergunta dos meses
    mov rdi, mesesMsg
    call printf
    
    ;scan do numero de meses
    mov rdi, intformat
    mov rsi, meses
    call scanf
    
    ;armazena o valor de meses em r12
    mov r12, [meses]
    
    ;print da pergunta de dias
    mov rdi, diasMsg
    call printf
    
    ;scan do numero de dias
    mov rdi, intformat
    mov rsi, dias
    call scanf
    
    ;multiplica o valor de anos por 365
    mov rax, 365
    mul rbx
    mov rbx, rax
    
    ;multiplica o valor de meses por 30
    mov rax, 30
    mul r12
    
    add rax, rbx ;soma a quantidade de dias dos anos e dos meses
    add rax, [dias] ;soma a quantidade de dias
    
    ;imprime a mensagem final
    mov rdi, final
    mov rsi, rax
    call printf
    
    leave
    ret
