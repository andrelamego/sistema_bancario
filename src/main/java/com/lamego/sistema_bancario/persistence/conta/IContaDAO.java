package com.lamego.sistema_bancario.persistence.conta;

import com.lamego.sistema_bancario.model.ContaBancaria;
import com.lamego.sistema_bancario.model.ContaCorrente;
import com.lamego.sistema_bancario.model.ContaPoupanca;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public interface IContaDAO {
    // SOLID (ISP + DIP): abstração de operações de Conta para desacoplar regra de negócio da implementação JDBC.
    String insertContaCorrente(String cpfCliente, Long idAgencia) throws SQLException;
    String insertContaPoupanca(String cpfCliente, Long idAgencia) throws SQLException;
    void deleteConta(String numeroConta) throws SQLException;
    ContaBancaria selectConta(String numeroConta) throws SQLException;
    List<ContaBancaria> selectContasCliente(String cpf) throws SQLException;
    void updateSaldoConta(String codigoConta, BigDecimal novoSaldo) throws SQLException;
    void updateLimiteCredito(String codigoConta, BigDecimal novoLimite) throws SQLException;
    void updatePercentualRendimento(String codigoConta, BigDecimal novoPercentual) throws SQLException;
    void updateDiaAniversario(String codigoConta, int novoDia) throws SQLException;
    void addSegundoTitular(String codigoConta, String cpfTitularAtual, String senhaTitularAtual, String cpfNovoTitular) throws SQLException;
}
