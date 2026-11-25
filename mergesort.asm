# ==========================================
# MERGE SORT EM ASSEMBLY MIPS
# CI1210 - UFPR
#
# Integrantes:
# Eremir Bley Correa Neto
# Pedro Mendes Vilela
# Thomas Mario Lima
# ==========================================

# mergesort(v, esq, dir)
# $a0 = endereco do vetor
# $a1 = esquerda
# $a2 = direita

mergesort:
    # Reservar espaco na pilha
    addi $sp, $sp, -24

    # Salvar registradores
    sw $ra, 20($sp)
    sw $fp, 16($sp)
    sw $a0, 12($sp)
    sw $a1,  8($sp)
    sw $a2,  4($sp)
    sw $s0,  0($sp)

    move $fp, $sp

    # Caso base: esq >= dir
    bge $a1, $a2, fim_mergesort

    # meio = (esq + dir) / 2
    add $t0, $a1, $a2
    li $t1, 2
    div $t0, $t1
    mflo $s0

    # ==================================
    # mergesort(v, esq, meio)
    # ==================================

    lw $a0, 12($fp)
    lw $a1,  8($fp)
    move $a2, $s0

    jal mergesort

    # ==================================
    # mergesort(v, meio + 1, dir)
    # ==================================

    lw $a0, 12($fp)
    addi $a1, $s0, 1
    lw $a2, 4($fp)

    jal mergesort

    # ==================================
    # merge(v, esq, meio, dir)
    # ==================================

    lw $a0, 12($fp)
    lw $a1,  8($fp)
    move $a2, $s0
    lw $a3,  4($fp)

    jal merge

fim_mergesort:
    # Restaurar pilha e registradores
    move $sp, $fp

    lw $s0,  0($sp)
    lw $a2,  4($sp)
    lw $a1,  8($sp)
    lw $a0, 12($sp)
    lw $fp, 16($sp)
    lw $ra, 20($sp)

    addi $sp, $sp, 24
    jr $ra


# ==========================================
# FUNCAO MERGE
# ==========================================

# merge(v, esq, meio, dir)
# $a0 = endereco do vetor
# $a1 = esquerda
# $a2 = meio
# $a3 = direita

merge:
    # i = esq
    move $t0, $a1

    # j = meio + 1
    addi $t1, $a2, 1

while1:
    # while (i < j && j <= dir)

    bge $t0, $t1, endwhile1
    bgt $t1, $a3, endwhile1

    # Carregar v[i]
    sll $t2, $t0, 2
    add $t2, $t2, $a0
    lw $t3, 0($t2)

    # Carregar v[j]
    sll $t4, $t1, 2
    add $t4, $t4, $a0
    lw $t5, 0($t4)

    # Comparar v[j] < v[i]
    slt $t6, $t5, $t3
    bne $t6, $zero, deslocar

    # Se v[i] <= v[j], avanca i
    addi $t0, $t0, 1
    j while1

deslocar:
    # k = j
    move $t4, $t1

while2:
    # while (k > i)
    beq $t4, $t0, endwhile2

    # Endereco de v[k]
    sll $t2, $t4, 2
    add $t2, $t2, $a0

    # Endereco de v[k-1]
    addi $t5, $t4, -1
    sll $t5, $t5, 2
    add $t5, $t5, $a0

    # Carregar os elementos
    lw $t6, 0($t2)
    lw $t7, 0($t5)

    # Trocar os elementos vizinhos
    sw $t7, 0($t2)
    sw $t6, 0($t5)

    # k--
    addi $t4, $t4, -1
    j while2

endwhile2:
    # i++
    addi $t0, $t0, 1

    # j++
    addi $t1, $t1, 1

    j while1

endwhile1:
    jr $ra
