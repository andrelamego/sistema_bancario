package com.lamego.sistema_bancario.model;

import lombok.*;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Cliente {
    // SOLID (SRP): POJO de domínio isolado da lógica de aplicação.
    private String cpf;
    private String nome;
    private LocalDate dataPrimeiraConta;
    private String senha;
}
