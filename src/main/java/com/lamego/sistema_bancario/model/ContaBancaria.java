package com.lamego.sistema_bancario.model;

import lombok.*;
import lombok.experimental.SuperBuilder;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
public abstract class ContaBancaria {
    // SOLID (LSP): contrato base para permitir substituição por ContaCorrente/ContaPoupanca.
    private String codigo;
    private LocalDate dataAbertura;
    private BigDecimal saldo;
    private String tipoConta;
    private Agencia agencia;
    private Titularidade titularidade;
}
