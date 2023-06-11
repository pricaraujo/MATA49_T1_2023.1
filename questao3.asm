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
;; Apenas valores 1 <= n <= 100 são aceitos, em qualquer outro caso   
;; o programa termina.
;; Cada elemento do vetor deve ser passado em uma linha separada:
;; Ex.:
;; 4
;; 1
;; 2
;; 3
;; 4

section .data
    base db 10
    n dq 0
    string_n times 8 db 0
    temp_buf times 8 db 0
    stoi_buf times 100 dq 0
    ans times 800 db 0

section .text
    global main

;; push only pushes registers or immediates
;; this macro pushes immediates or memory locations
%macro pushIM 1
    ;; you have to 0-extend the byte (with movzx)
    ;; to fill up the byte register
    ;; otherwise nasm complains of size mismatch
    movzx r15, byte %1
    push byte r15
    mov r15, 0
%endmacro

%macro mod 2
    mov rdx, 0
    mov rax, %1
    mov r15, %2                 ;there is no division by imm
    div r15
    mov r15, 0
    ;; rax: quotient, rdx: remainder
    mov %1, rax
%endmacro

%macro read 2
    ;; NOTE: preserves stack
    ;; @uses:
    ;; 1. rax
    ;; 2. rdx
    ;; 3. rsi
    ;; 4. rdi
    push qword %1
    push qword %2
    mov rax, 0
    mov rdi, 0
    pop qword rdx
    pop qword rsi
    syscall
%endmacro

%macro print 2
    ;; NOTE: preserves stack
    ;; @uses:
    ;; 1. rax
    ;; 2. rdx
    ;; 3. rsi
    ;; 4. rdi
    push qword %1
    push qword %2
    mov rax, 1
    mov rdi, 1
    pop qword rdx
    pop qword rsi
    syscall
%endmacro

%define zero 48
%define INTSIZE 8
%define space 32

stoi:
    ;; @params
    ;; receive string pointer in rsi
    ;; NOTE: conserves the stack
    ;; @uses
    ;; 1. rax
    ;; 2. rbx
    ;; 3. rcx
    ;; 4. rdx (in mul operation)
    ;; 5. rsi
    ;; 6. rdi
    ;; 7. r8
    ;; 8. r15 (in pushIM macro)
    ;; @return
    ;; return num in rdi
    mov rcx, 0
    .stoi_stack:
        cmp byte [rsi+rcx], zero
        jl .stoi_unstack
        cmp byte [rsi+rcx], (zero + 9)
        jg .stoi_unstack
        pushIM [rsi+rcx]
        inc rcx
        jmp .stoi_stack
    .stoi_unstack:
        mov rbx, 1                 ; power of ten
        .stoi_unstack_internal:
            ;; NOTE: you need to get intermediate result first, then advance to another power of ten
            cmp rcx, 0
            jle .stoi_end
            ;; get intermediate result
            mov rax, 1
            pop byte r8
            sub r8, zero
            mul r8              ; [rdx:rax] <- rax*OP
            mul rbx
            add rdi, rax
            dec rcx
            ;; new power of ten (undefined behavior on overflow)
            mov rax, rbx
            mul qword [base]
            mov rbx, rax

            jmp .stoi_unstack_internal
    .stoi_end:
        ret

itos:
    ;; @params
    ;; receive pointer to str in rsi
    ;; num in rdi
    ;; NOTE: preserves stack
    ;; @uses:
    ;; 1. rax
    ;; 2. rbx
    ;; 3. rcx
    ;; 4. rdx (in div operation in macro mod)
    ;; 5. rsi
    ;; 6. rdi
    ;; 7. r15 (in macro mod)
    ;; @return:
    ;; populates string buffer pointed by rsi
    ;; also returns len in rbx
    cmp rdi, 0                  ;0 is a corner case
    jne .itos_start
    mov byte [rsi], zero
    mov rbx, 1
    ret

    .itos_start:
    mov rbx, 0
    mov rcx, 0
    .itos_stack:
        ;; get digit in rdx
        mod rdi, [base]
        push byte rdx              ;remainder
        inc rcx
        cmp rdi, 0
        jle .itos_unstack
        jmp .itos_stack
    .itos_unstack:
        cmp rcx, 0
        jle .itos_end
        mov rax, 0              ;just to be sure
        pop byte rax
        add rax, zero
        mov [rsi + rbx], rax
        inc rbx
        dec rcx
        jmp .itos_unstack
    .itos_end:
        ret

read_int_vector:
    ;; @params
    ;; ptr to temporary string in rsi
    ;; receives ptr to destination array in rdi
    ;; size (number of elements in vector) in rdx
    ;; NOTE: preserves stack
    ;; @uses:
    ;; 1. rax (in read macro)
    ;; 2. rbx (in stoi)
    ;; 2; rcx
    ;; 3. rdx
    ;; 4. rsi
    ;; 5. rdi
    ;; 6. r8 (in stoi)
    ;; 7. r9 (in stoi)
    ;; 8. r10 (index)
    ;; 9. r15 (in 'pushIM' macro used in stoi)
    ;; @returns
    ;; void
    mov r10, 0
    .read_int_vector_loop:
        cmp qword r10, rdx
        jge .read_int_vector_end
        push qword rdx
        push qword rdi
        push qword rsi
        push qword rsi          ;pushing twice will be important
        read rsi, INTSIZE
        pop qword rsi
        call stoi
        ;; stoi returns in rdi
        mov rax, rdi
        pop qword rsi
        pop qword rdi
        pop qword rdx
        ;; save integer in correct pos
        ;; (as quad word - 8 bytes)
        mov qword [rdi+INTSIZE*r10], rax
        inc r10
        jmp .read_int_vector_loop
    .read_int_vector_end:
        ret

reverse:
    ;; @params
    ;; receives ptr to integer array in rsi
    ;; size in rdx
    ;; @uses:
    ;;  1. rcx
    ;;  2. rdx
    ;;  3. rsi
    ;;  4. r8 (as left element of swap)
    ;;  5. r9 (as right element of swap)
    ;;  6. r10 (as temporary)
    ;; @returns
    ;; void (reverse vector in place)
    mov rcx, 0
    .reverse_loop:
        lea r10, [2*rcx]
        cmp r10, rdx            ;asserts 2*rcx < (rdx = sizeof buffer)
        jge .reverse_end
        ;; ptr + i
        lea r8, [rsi + INTSIZE * rcx]
        ;; ptr + n - 1 - i
        lea r9, [rsi + INTSIZE * (rdx - 1)]
        lea r10, [INTSIZE * rcx]
        sub r9, r10

        ;; swap
        push qword [r8]
        push qword [r9]
        pop qword [r8]
        pop qword [r9]
        ;; increment
        add rcx, 1
        jmp .reverse_loop
    .reverse_end:
        ret

print_int_vector:
    ;; @params
    ;; receives ptr to temporary buffer in rsi
    ;; receives ptr to integer array in rdi
    ;; size in rdx
    ;; NOTE: preserves stack
    ;; @uses:
    ;; 1. rax
    ;; 2. rbx
    ;; 3. rcx
    ;; 4. rdx (in div operation in macro mod)
    ;; 5. rsi
    ;; 6. rdi
    ;; 7. r8 (index)
    ;; 8. r15 (in macro mod)
    ;; @returns
    ;; void
    mov r8, 0
    .print_int_vector_loop:
        cmp r8, rdx
        jge .print_int_vector_end
        ;; preserve args
        push qword rdx
        push qword rdi
        push qword rsi
        mov rdi, [rdi+INTSIZE*r8]
        call itos
        ;; now num ptr is in rsi
        ;; len in rbx
        ;; print num
        push qword rsi
        push qword rbx
        mov rax, 1
        mov rdi, 1
        pop qword rdx
        pop qword rsi
        syscall
        ;; print space
        mov byte [rsi], space
        print rsi, 1
        ;; recover args
        pop qword rsi
        pop qword rdi
        pop qword rdx
        ;; increment
        inc r8
        jmp .print_int_vector_loop
    .print_int_vector_end:
        ret

main:
    mov rbp, rsp; for correct debugging
    ;; read n (size of vector)
    read string_n, 8
    mov rsi, string_n
    call stoi
    mov [n], rdi
    ;; validate vector length
    cmp qword [n], 100
    jg .main_end
    cmp qword [n], 0
    jle .main_end

    ;; read vector
    mov rsi, temp_buf
    mov rdi, stoi_buf
    mov rdx, [n]
    call read_int_vector

    ;; reverse in place
    mov rsi, stoi_buf
    mov rdx, [n]
    call reverse

    ;; print vector
    mov rsi, temp_buf
    mov rdi, stoi_buf
    mov rdx, [n]
    call print_int_vector

    .main_end:
    mov rax, 60
    mov rdx, 0
    syscall
