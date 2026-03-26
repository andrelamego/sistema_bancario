package com.lamego.sistema_bancario.model;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Agencia {
    private Long id;
    private String codigo;
    private String cep;
    private String cidade;
    private InstituicaoBancaria instituicaoBancaria;
}
