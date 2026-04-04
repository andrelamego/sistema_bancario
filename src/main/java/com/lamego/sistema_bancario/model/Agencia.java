package com.lamego.sistema_bancario.model;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Agencia {
    // SOLID (SRP): entidade somente com estado de domínio, sem regra de negócio ou acesso a dados.
    private Long id;
    private String codigo;
    private String cep;
    private String cidade;
    private InstituicaoBancaria instituicaoBancaria;
}
