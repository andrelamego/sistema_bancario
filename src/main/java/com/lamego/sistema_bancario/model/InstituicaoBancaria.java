package com.lamego.sistema_bancario.model;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InstituicaoBancaria {
    private Long id;
    private String nome;
}
