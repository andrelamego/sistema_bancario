package com.lamego.sistema_bancario.model;

import lombok.*;
import lombok.experimental.SuperBuilder;

import java.math.BigDecimal;

@Data
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class ContaCorrente extends ContaBancaria{
    // SOLID (LSP): extensão especializada que preserva o contrato de ContaBancaria.
    private BigDecimal limiteCredito;
}
