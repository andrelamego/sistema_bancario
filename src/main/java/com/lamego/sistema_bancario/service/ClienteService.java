package com.lamego.sistema_bancario.service;

import com.lamego.sistema_bancario.model.Cliente;
import com.lamego.sistema_bancario.persistence.cliente.ClienteDAO;

import java.sql.SQLException;
import java.util.List;

public class ClienteService {

    private final ClienteDAO clienteDAO;

    public ClienteService() {
        this.clienteDAO = new ClienteDAO();
    }

    public void cadastrarCliente(Cliente cliente) throws SQLException, IllegalArgumentException {
        validarClienteCadastro(cliente);
        clienteDAO.insertCliente(cliente);
    }

    public void atualizarSenhaCliente(String cpf, String novaSenha) throws SQLException, IllegalArgumentException {
        if (cpf == null || cpf.isBlank()) {
            throw new IllegalArgumentException("CPF do cliente é obrigatório.");
        }

        validarSenha(novaSenha);

        Cliente cliente = Cliente.builder()
                .cpf(cpf)
                .senha(novaSenha)
                .build();

        clienteDAO.updateSenhaCliente(cliente);
    }

    public void excluirCliente(String cpf) throws SQLException {
        if (cpf == null || cpf.isBlank()) {
            throw new IllegalArgumentException("CPF do cliente é obrigatório.");
        }

        clienteDAO.deleteCliente(cpf);
    }

    public Cliente buscarCliente(String cpf) throws SQLException {
        if (cpf == null || cpf.isBlank()) {
            throw new IllegalArgumentException("CPF do cliente é obrigatório.");
        }

        return clienteDAO.selectCliente(cpf);
    }

    public List<Cliente> listarClientes() throws SQLException {
        return clienteDAO.selectClientes();
    }

    public Cliente loginCliente(String cpf, String senha) throws SQLException {
        if (cpf == null || cpf.isBlank()) {
            throw new IllegalArgumentException("CPF do cliente é obrigatório.");
        }

        if (senha == null || senha.isBlank()) {
            throw new IllegalArgumentException("Senha do cliente é obrigatória.");
        }

        return clienteDAO.loginCliente(cpf, senha);
    }

    private void validarClienteCadastro(Cliente cliente) {
        if (cliente == null) {
            throw new IllegalArgumentException("Cliente não pode ser nulo.");
        }

        if (cliente.getCpf() == null || cliente.getCpf().isBlank()) {
            throw new IllegalArgumentException("CPF do cliente é obrigatório.");
        }

        if (cliente.getNome() == null || cliente.getNome().isBlank()) {
            throw new IllegalArgumentException("Nome do cliente é obrigatório.");
        }

        validarSenha(cliente.getSenha());
    }

    private void validarSenha(String senha) {
        if (senha == null || senha.isBlank()) {
            throw new IllegalArgumentException("Senha do cliente é obrigatória.");
        }

        if (senha.length() != 8) {
            throw new IllegalArgumentException("A senha deve conter exatamente 8 caracteres.");
        }

        int quantidadeNumeros = 0;

        for (char caractere : senha.toCharArray()) {
            if (Character.isDigit(caractere)) {
                quantidadeNumeros++;
            }
        }

        if (quantidadeNumeros < 3) {
            throw new IllegalArgumentException("A senha deve possuir pelo menos 3 caracteres numéricos.");
        }
    }
}