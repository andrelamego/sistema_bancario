package com.lamego.sistema_bancario.persistence.conta;

import com.lamego.sistema_bancario.model.Agencia;
import com.lamego.sistema_bancario.model.ContaBancaria;
import com.lamego.sistema_bancario.model.ContaCorrente;
import com.lamego.sistema_bancario.model.ContaPoupanca;
import com.lamego.sistema_bancario.persistence.GenericDAO;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ContaDAO implements IContaDAO{
    // SOLID (SRP): implementação de acesso a dados específica para Conta.
    private final GenericDAO genericDAO;

    public ContaDAO() {
        this.genericDAO = new GenericDAO();
    }

    @Override
    public String insertContaCorrente(String cpfCliente, Long idAgencia) throws SQLException {
        String sql = "EXEC sp_insert_conta_corrente ?, ?";
        String codigoConta = "";

        try(Connection connection = genericDAO.getConnection();
            CallableStatement cs = connection.prepareCall(sql)){

            cs.setString(1, cpfCliente);
            cs.setLong(2, idAgencia);

            try(ResultSet rs = cs.executeQuery()){
                if(rs.next()){
                    codigoConta = rs.getString("codigo_conta");
                }
            }
        }

        return codigoConta;
    }

    @Override
    public String insertContaPoupanca(String cpfCliente, Long idAgencia) throws SQLException {
        String sql = "EXEC sp_insert_conta_poupanca ?, ?";
        String codigoContaGerado = null;

        try (Connection c = genericDAO.getConnection();
             CallableStatement cs = c.prepareCall(sql)) {

            cs.setString(1, cpfCliente);
            cs.setLong(2, idAgencia);

            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    codigoContaGerado = rs.getString("codigo_conta");
                }
            }
        }

        return codigoContaGerado;
    }

    @Override
    public void deleteConta(String numeroConta) throws SQLException {
        String sql = "EXEC sp_delete_conta ?";

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql)) {

            cs.setString(1, numeroConta);
            cs.execute();
        }
    }

    @Override
    public ContaBancaria selectConta(String numeroConta) throws SQLException {
        String sql = "EXEC sp_select_conta ?";

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql)) {

            cs.setString(1, numeroConta);
            ResultSet rs = cs.executeQuery();

            if(rs.next()){
                return mapResultSetToConta(rs);
            }

            return null;
        }
    }

    @Override
    public List<ContaBancaria> selectContasCliente(String cpf) throws SQLException {
        String sql = "EXEC sp_select_contas_cliente ?";

        List<ContaBancaria> contas = new ArrayList<>();

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql)) {

            cs.setString(1, cpf);
            ResultSet rs = cs.executeQuery();

            while(rs.next()){
                ContaBancaria conta = mapResultSetToConta(rs);
                if (conta != null) {
                    contas.add(conta);
                }
            }

            return contas;
        }
    }

    @Override
    public void updateSaldoConta(String codigoConta, BigDecimal novoSaldo) throws SQLException {
        String sql = "EXEC sp_update_saldo_conta ?, ?";

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql)) {

            cs.setString(1, codigoConta);
            cs.setBigDecimal(2, novoSaldo);

            cs.execute();
        }
    }

    @Override
    public void updateLimiteCredito(String codigoConta, BigDecimal novoLimite) throws SQLException {
        String sql = "EXEC sp_update_limite_credito ?, ?";

        try (Connection c = genericDAO.getConnection();
             CallableStatement cs = c.prepareCall(sql)) {

            cs.setString(1, codigoConta);
            cs.setBigDecimal(2, novoLimite);

            cs.execute();
        }
    }

    @Override
    public void updatePercentualRendimento(String codigoConta, BigDecimal novoPercentual) throws SQLException {
        String sql = "EXEC sp_update_rendimento_poupanca ?, ?";

        try (Connection c = genericDAO.getConnection();
             CallableStatement cs = c.prepareCall(sql)) {

            cs.setString(1, codigoConta);
            cs.setBigDecimal(2, novoPercentual);

            cs.execute();
        }
    }

    @Override
    public void updateDiaAniversario(String codigoConta, int novoDia) throws SQLException {
        String sql = "EXEC sp_update_dia_aniversario_poupanca ?, ?";

        try (Connection c = genericDAO.getConnection();
             CallableStatement cs = c.prepareCall(sql)) {

            cs.setString(1, codigoConta);
            cs.setInt(2, novoDia);

            cs.execute();
        }
    }

    @Override
    public void addSegundoTitular(String codigoConta, String cpfTitularAtual, String senhaTitularAtual, String cpfNovoTitular) throws SQLException {
        String sql = "EXEC sp_add_segundo_titular ?, ?, ?, ?";

        try (Connection c = genericDAO.getConnection();
             CallableStatement cs = c.prepareCall(sql)) {

            cs.setString(1, codigoConta);
            cs.setString(2, cpfTitularAtual);
            cs.setString(3, senhaTitularAtual);
            cs.setString(4, cpfNovoTitular);

            cs.execute();
        }
    }

    private ContaBancaria mapResultSetToConta(ResultSet rs) throws SQLException {
        LocalDate dataSql = rs.getDate("data_abertura").toLocalDate();

        Agencia agencia = Agencia.builder()
                .codigo(rs.getString("codigo_agencia"))
                .cidade(rs.getString("cidade"))
                .build();

        BigDecimal saldo = rs.getBigDecimal("saldo");
        String codigoConta = rs.getString("codigo_conta");
        String tipoConta = rs.getString("tipo_conta");

        BigDecimal limiteCredito = rs.getBigDecimal("limite_credito");
        BigDecimal percentualRendimento = rs.getBigDecimal("percentual_rendimento");

        // SOLID (LSP): decisão por subtipo concreto permite tratar ambos via tipo base ContaBancaria.
        if ("CORRENTE".equalsIgnoreCase(tipoConta) || limiteCredito != null) {
            return ContaCorrente.builder()
                    .codigo(codigoConta)
                    .dataAbertura(dataSql)
                    .saldo(saldo)
                    .tipoConta("CORRENTE")
                    .agencia(agencia)
                    .limiteCredito(limiteCredito)
                    .build();
        }

        if ("POUPANCA".equalsIgnoreCase(tipoConta) || percentualRendimento != null) {
            return ContaPoupanca.builder()
                    .codigo(codigoConta)
                    .dataAbertura(dataSql)
                    .saldo(saldo)
                    .tipoConta("POUPANCA")
                    .agencia(agencia)
                    .percentualRendimento(percentualRendimento)
                    .diaAniversario(rs.getInt("dia_aniversario"))
                    .build();
        }

        return null;
    }
}
