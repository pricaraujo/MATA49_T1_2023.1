; Faça um algoritmo para ler: quantidade atual em estoque, quantidade máxima em estoque e quantidade
; mínima em estoque de um produto. Calcular e escrever a quantidade média ((quantidade média = quantidade
; máxima + quantidade mínima)/2). Se a quantidade em estoque for maior ou igual a quantidade média, 
; escrever a mensagem 'Não efetuar compra', senão escrever a mensagem 'Efetuar compra'.

section .data
    efetuar: db "Efetuar compra", 0
    nao_efetuar: db "Nao efetuar compra", 0
    msg_quantidade_atual: db "Quantidade atual em estoque: ", 0
    msg_quantidade_maxima: db "Quantidade maxima em estoque: ", 0
    msg_quantidade_minima: db "Quantidade minima em estoque: ", 0
    msg_quantidade_media: db "Quantidade media em estoque: ", 0

    quebra_de_linha: db `\n`, 0
    formato_entrada: db "%d", 0
    formato_saida: db "%s", 0

section .bss
    ; reserva variaveis para receber os valores escritos no terminal e resultado de calculos
    quantidade_atual: resb 10
    quantidade_maxima: resb 10
    quantidade_minima: resb 10
    quantidade_media: resb 10

section .text

extern scanf, printf, strlen
global main

    main:
        ; macro responsavel por imprimir qualquer string ou decimal no terminal
        %macro imprimir_mensagem 2
            mov rdi, %1
            mov rsi, %2
            xor rax, rax
            call printf
        %endmacro

        ; macro responsavel por ler um decimal do terminal
        %macro ler_quantidade 1
            mov rdi, formato_entrada
            mov rsi, %1
            xor rax, rax
            call scanf
        %endmacro

        ; macro responsavel por calcular a media da quantidade maxima e minima do estoque
        %macro calcular_media  3
            mov rax, [%1]
            add rax, [%2]
            mov rbx, 2
            div rbx

            mov [%3], rax
        %endmacro
        
        ; prólogo
        push rbp 
        mov rbp, rsp

        xor rdi, rdi 
        xor rsi, rsi
        xor rax, rax

        ; Lê a quantidade atual em estoque
        imprimir_mensagem formato_saida, msg_quantidade_atual
        ler_quantidade quantidade_atual

        ; Lê a quantidade máxima do estoque
        imprimir_mensagem formato_saida, msg_quantidade_maxima
        ler_quantidade quantidade_maxima

        ; Lê a quantidade mínima do estoque
        imprimir_mensagem formato_saida, msg_quantidade_minima
        ler_quantidade quantidade_minima

        ; Calcula a quantidade média
        calcular_media quantidade_maxima, quantidade_minima, quantidade_media

        ; Imprime a media do estoque
        imprimir_mensagem formato_saida, msg_quantidade_media
        imprimir_mensagem formato_entrada, [quantidade_media]

        ; Imprimir quebra de linha para ajuste das saídas
        imprimir_mensagem formato_saida, quebra_de_linha

        ; Checa o estoque atual com a média do estoque
        mov rax, [quantidade_atual]
        mov rbx, [quantidade_media]

        cmp rax, rbx
        ; se o estoque atual for igual ou maior, imprime "Não efetuar a compra"
        jge imprimir_nao_efetuar 
        ; se o estoque for menor, imprime "Efetuar a compra"
        jmp imprimir_efetuar 

        ; Finaliza a execução do programa.
        finalizar:
            ; epílogo
            leave
            mov rax, 60
            xor rdi, rdi
            syscall

        imprimir_nao_efetuar:
            imprimir_mensagem formato_saida, nao_efetuar
            imprimir_mensagem formato_saida, quebra_de_linha

            jmp finalizar

        imprimir_efetuar:
            imprimir_mensagem formato_saida, efetuar
            imprimir_mensagem formato_saida, quebra_de_linha

            jmp finalizar

