# ==========================================
# MERGE SORT EM ASSEMBLY MIPS
# CI1210 - UFPR
#
# Integrantes:
# Eremir Bley Correa Neto
# Pedro Mendes Vilela
# Thomas Mario Lima
# ==========================================

# ==========================================
# CODIGO PARA COMPILAR / TESTES /
# ==========================================

.data
vetor:        .word 8, 3, 6, 1, 7, 2, 5, 4
passos:       .word 0
msg_antes:    .asciiz "Antes:  "
msg_depois:   .asciiz "Depois: "
msg_passo:    .asciiz "Passo "
msg_merge:    .asciiz " - merge ["
msg_ate:      .asciiz ".."
msg_faixa:    .asciiz "]: "
msg_espaco:   .asciiz " "
msg_quebra:   .asciiz "\n"

.text
.globl main

main:
    li $v0, 4
    la $a0, msg_antes
    syscall
    la $a0, vetor
    li $a1, 8
    jal imprimir

    la $a0, vetor
    li $a1, 0
    li $a2, 7
    jal mergesort

    li $v0, 4
    la $a0, msg_depois
    syscall
    la $a0, vetor
    li $a1, 8
    jal imprimir

    li $v0, 10
    syscall

# imprimir(a0=vetor, a1=tamanho)
# $s1 e $s2 sao preservados antes de serem utilizados.
imprimir:
    addi $sp, $sp, -8
    sw $s1, 4($sp)
    sw $s2, 0($sp)
    move $s1, $a0
    move $s2, $a1

loop_imprimir:
    beq $s2, $zero, fim_imprimir
    lw $a0, 0($s1)
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, msg_espaco
    syscall
    addi $s1, $s1, 4
    addi $s2, $s2, -1
    j loop_imprimir

fim_imprimir:
    li $v0, 4
    la $a0, msg_quebra
    syscall
    lw $s2, 0($sp)
    lw $s1, 4($sp)
    addi $sp, $sp, 8
    jr $ra

# mergesort(a0=vetor, a1=esq, a2=dir)
mergesort:
    addi $sp, $sp, -24
    sw $ra, 20($sp)
    sw $fp, 16($sp)
    sw $a0, 12($sp)
    sw $a1, 8($sp)
    sw $a2, 4($sp)
    sw $s0, 0($sp)
    move $fp, $sp

    bge $a1, $a2, fim_mergesort

    add $t0, $a1, $a2
    li $t1, 2
    div $t0, $t1
    mflo $s0

    # mergesort(v, esq, meio)
    lw $a0, 12($fp)
    lw $a1, 8($fp)
    move $a2, $s0
    jal mergesort

    # mergesort(v, meio+1, dir)
    lw $a0, 12($fp)
    addi $a1, $s0, 1
    lw $a2, 4($fp)
    jal mergesort

    # merge(v, esq, meio, dir)
    lw $a0, 12($fp)
    lw $a1, 8($fp)
    move $a2, $s0
    lw $a3, 4($fp)
    jal merge

    # Mostrar a etapa apos cada intercalação.
    la $t8, passos
    lw $t9, 0($t8)
    addi $t9, $t9, 1
    sw $t9, 0($t8)

    li $v0, 4
    la $a0, msg_passo
    syscall
    la $t8, passos
    lw $a0, 0($t8)
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, msg_merge
    syscall
    lw $a0, 8($fp)
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, msg_ate
    syscall
    lw $a0, 4($fp)
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, msg_faixa
    syscall
    lw $a0, 12($fp)
    li $a1, 8
    jal imprimir

fim_mergesort:
    move $sp, $fp
    lw $s0, 0($sp)
    lw $a2, 4($sp)
    lw $a1, 8($sp)
    lw $a0, 12($sp)
    lw $fp, 16($sp)
    lw $ra, 20($sp)
    addi $sp, $sp, 24
    jr $ra

# merge(a0=vetor, a1=esq, a2=meio, a3=dir)
# Intercalacao por trocas entre elementos vizinhos.
merge:
    move $t0, $a1
    addi $t1, $a2, 1

while1:
    bge $t0, $t1, endwhile1
    bgt $t1, $a3, endwhile1

    sll $t2, $t0, 2
    add $t2, $t2, $a0
    lw $t3, 0($t2)

    sll $t4, $t1, 2
    add $t4, $t4, $a0
    lw $t5, 0($t4)

    slt $t6, $t5, $t3
    bne $t6, $zero, deslocar
    addi $t0, $t0, 1
    j while1

deslocar:
    move $t4, $t1

while2:
    beq $t4, $t0, endwhile2
    sll $t2, $t4, 2
    add $t2, $t2, $a0
    addi $t5, $t4, -1
    sll $t5, $t5, 2
    add $t5, $t5, $a0
    lw $t6, 0($t2)
    lw $t7, 0($t5)
    sw $t7, 0($t2)
    sw $t6, 0($t5)
    addi $t4, $t4, -1
    j while2

endwhile2:
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j while1

endwhile1:
    jr $ra

