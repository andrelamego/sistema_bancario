package com.lamego.sistema_bancario.model;

import lombok.*;
import lombok.experimental.SuperBuilder;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
public class ContaBancaria {
    private String codigo;
    private LocalDate dataAbertura;
    private BigDecimal saldo;
    private Agencia agencia;
}
