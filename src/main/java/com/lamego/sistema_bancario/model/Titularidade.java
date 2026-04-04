package com.lamego.sistema_bancario.model;

public class Titularidade {
    // SOLID (SRP): entidade de associação (conta-cliente) isolada das regras de aplicação.
    private ContaBancaria contaBancaria;
    private Cliente cliente;
    private int ordemTitular;
}
