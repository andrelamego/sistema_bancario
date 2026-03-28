package com.lamego.sistema_bancario.persistence.cliente;

import com.lamego.sistema_bancario.model.Cliente;

import java.sql.SQLException;
import java.util.List;

public interface IClienteDAO {
    void insertCliente(Cliente cliente) throws SQLException;
    void updateSenhaCliente(Cliente cliente) throws SQLException;
    void deleteCliente(String cpf) throws SQLException;
    Cliente selectCliente(String cpf) throws SQLException;
    List<Cliente> selectClientes() throws SQLException;

    Cliente loginCliente(String cpf, String senha) throws SQLException;
}
