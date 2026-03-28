package com.lamego.sistema_bancario.service;

import com.lamego.sistema_bancario.model.ContaBancaria;
import com.lamego.sistema_bancario.persistence.conta.ContaDAO;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class ContaService {

    private final ContaDAO contaDAO;

    public ContaService() {
        this.contaDAO = new ContaDAO();
    }

    public String cadastrarContaCorrente(String cpfCliente, Long idAgencia) throws SQLException {
        validarCpf(cpfCliente);
        validarIdAgencia(idAgencia);

        return contaDAO.insertContaCorrente(cpfCliente, idAgencia);
    }

    public String cadastrarContaPoupanca(String cpfCliente, Long idAgencia) throws SQLException {
        validarCpf(cpfCliente);
        validarIdAgencia(idAgencia);

        return contaDAO.insertContaPoupanca(cpfCliente, idAgencia);
    }

    public void excluirConta(String codigoConta) throws SQLException {
        validarCodigoConta(codigoConta);
        contaDAO.deleteConta(codigoConta);
    }

    public ContaBancaria buscarConta(String codigoConta) throws SQLException {
        validarCodigoConta(codigoConta);
        return contaDAO.selectConta(codigoConta);
    }

    public List<ContaBancaria> listarContasCliente(String cpfCliente) throws SQLException {
        validarCpf(cpfCliente);
        return contaDAO.selectContasCliente(cpfCliente);
    }

    public void atualizarSaldoConta(String codigoConta, BigDecimal novoSaldo) throws SQLException {
        validarCodigoConta(codigoConta);

        if (novoSaldo == null) {
            throw new IllegalArgumentException("O novo saldo é obrigatório.");
        }

        if (novoSaldo.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("O saldo não pode ser negativo.");
        }

        contaDAO.updateSaldoConta(codigoConta, novoSaldo);
    }

    public void atualizarLimiteCredito(String codigoConta, BigDecimal novoLimite) throws SQLException {
        validarCodigoConta(codigoConta);

        if (novoLimite == null) {
            throw new IllegalArgumentException("O novo limite é obrigatório.");
        }

        if (novoLimite.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("O limite de crédito não pode ser negativo.");
        }

        contaDAO.updateLimiteCredito(codigoConta, novoLimite);
    }

    public void atualizarRendimentoPoupanca(String codigoConta, BigDecimal novoPercentual) throws SQLException {
        validarCodigoConta(codigoConta);

        if (novoPercentual == null) {
            throw new IllegalArgumentException("O novo percentual de rendimento é obrigatório.");
        }

        if (novoPercentual.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("O percentual de rendimento não pode ser negativo.");
        }

        contaDAO.updatePercentualRendimento(codigoConta, novoPercentual);
    }

    public void atualizarDiaAniversarioPoupanca(String codigoConta, Integer novoDia) throws SQLException {
        validarCodigoConta(codigoConta);

        if (novoDia == null) {
            throw new IllegalArgumentException("O novo dia de aniversário é obrigatório.");
        }

        if (novoDia < 1 || novoDia > 31) {
            throw new IllegalArgumentException("O dia de aniversário deve estar entre 1 e 31.");
        }

        contaDAO.updateDiaAniversario(codigoConta, novoDia);
    }

    public void adicionarSegundoTitular(String codigoConta, String cpfTitularAtual, String senhaTitularAtual, String cpfNovoTitular) throws SQLException {
        validarCodigoConta(codigoConta);
        validarCpf(cpfTitularAtual);
        validarCpf(cpfNovoTitular);

        if (senhaTitularAtual == null || senhaTitularAtual.isBlank()) {
            throw new IllegalArgumentException("A senha do titular atual é obrigatória.");
        }

        contaDAO.addSegundoTitular(codigoConta, cpfTitularAtual, senhaTitularAtual, cpfNovoTitular);
    }

    private void validarCpf(String cpf) {
        if (cpf == null || cpf.isBlank()) {
            throw new IllegalArgumentException("CPF é obrigatório.");
        }
    }

    private void validarIdAgencia(Long idAgencia) {
        if (idAgencia == null || idAgencia <= 0) {
            throw new IllegalArgumentException("ID da agência inválido.");
        }
    }

    private void validarCodigoConta(String codigoConta) {
        if (codigoConta == null || codigoConta.isBlank()) {
            throw new IllegalArgumentException("Código da conta é obrigatório.");
        }
    }
}