package com.lamego.sistema_bancario.model;

import lombok.*;
import lombok.experimental.SuperBuilder;

import java.math.BigDecimal;

@Data
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class ContaPoupanca extends ContaBancaria{
    private BigDecimal percentualRendimento;
    private int diaAniversario;
}
