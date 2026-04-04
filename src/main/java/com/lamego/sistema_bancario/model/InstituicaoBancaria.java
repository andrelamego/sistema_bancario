package com.lamego.sistema_bancario.model;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InstituicaoBancaria {
    // SOLID (SRP): representação de domínio sem acoplamento com camadas de serviço/persistência.
    private Long id;
    private String nome;
}
