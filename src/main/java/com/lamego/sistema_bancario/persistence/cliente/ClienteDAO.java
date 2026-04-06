package com.lamego.sistema_bancario.persistence.cliente;

import com.lamego.sistema_bancario.model.Cliente;
import com.lamego.sistema_bancario.persistence.GenericDAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO implements IClienteDAO{
    // SOLID (SRP): classe responsável somente por operações de persistência de Cliente.
    private final GenericDAO genericDAO;

    public ClienteDAO() {
        this.genericDAO = new GenericDAO();
    }

    @Override
    public void insertCliente(Cliente cliente) throws SQLException {
        String sql = "EXEC sp_insert_cliente ?, ?, ?";

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql)) {

            cs.setString(1, cliente.getCpf());
            cs.setString(2, cliente.getNome());
            cs.setString(3, cliente.getSenha());

            cs.execute();
        }
    }

    @Override
    public void updateSenhaCliente(Cliente cliente) throws SQLException {
        String sql = "EXEC sp_update_senha_cliente ?, ?";

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql)) {

            cs.setString(1, cliente.getCpf());
            cs.setString(2, cliente.getSenha());

            cs.execute();
        }
    }

    @Override
    public void deleteCliente(String cpf) throws SQLException {
        String sql = "EXEC sp_delete_cliente ?";

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql)) {

            cs.setString(1, cpf);
            cs.execute();
        }
    }

    @Override
    public Cliente selectCliente(String cpf) throws SQLException {
        String sql = "EXEC sp_select_cliente ?";

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql)) {

            cs.setString(1, cpf);
            ResultSet rs = cs.executeQuery();

            if(rs.next()){
                return mapResultSetToCliente(rs);
            }

            return null;
        }
    }

    @Override
    public List<Cliente> selectClientes() throws SQLException {
        String sql = "EXEC sp_select_clientes";

        List<Cliente> clientes = new ArrayList<>();

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql);
             ResultSet rs = cs.executeQuery()) {

            while(rs.next()){
                clientes.add(mapResultSetToCliente(rs));
            }

            return clientes;
        }
    }

    @Override
    public Cliente loginCliente(String cpf, String senha) throws SQLException {
        String sql = "EXEC sp_login_cliente ?, ?";

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql)) {

            cs.setString(1, cpf);
            cs.setString(2, senha);
            ResultSet rs = cs.executeQuery();

            if(rs.next()){
                return mapResultSetToCliente(rs);
            }

            return null;
        }
    }

    private Cliente mapResultSetToCliente(ResultSet rs) throws SQLException {
        Date dataSql = rs.getDate("data_primeira_conta");
        String senha = hasColumn(rs, "senha") ? rs.getString("senha") : null;

        return Cliente.builder()
                .cpf(rs.getString("cpf"))
                .nome(rs.getString("nome"))
                .dataPrimeiraConta(dataSql != null ? dataSql.toLocalDate() : null)
                .senha(senha)
                .build();
    }

    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        ResultSetMetaData metaData = rs.getMetaData();

        for (int i = 1; i <= metaData.getColumnCount(); i++) {
            String label = metaData.getColumnLabel(i);
            String name = metaData.getColumnName(i);
            if (columnName.equalsIgnoreCase(label) || columnName.equalsIgnoreCase(name)) {
                return true;
            }
        }

        return false;
    }
}
