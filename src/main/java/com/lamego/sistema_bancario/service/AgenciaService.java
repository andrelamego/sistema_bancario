package com.lamego.sistema_bancario.service;

import com.lamego.sistema_bancario.model.Agencia;
import com.lamego.sistema_bancario.persistence.agencia.AgenciaDAO;

import java.sql.SQLException;
import java.util.List;

public class AgenciaService {

    private final AgenciaDAO agenciaDAO;

    public AgenciaService() {
        this.agenciaDAO = new AgenciaDAO();
    }

    public void cadastrarAgencia(Agencia agencia) throws SQLException, IllegalArgumentException {
        validarAgencia(agencia);
        agenciaDAO.insertAgencia(agencia);
    }

    public void atualizarAgencia(Agencia agencia) throws SQLException, IllegalArgumentException {
        validarAgencia(agencia);
        agenciaDAO.updateAgencia(agencia);
    }

    public void excluirAgencia(Long id) throws SQLException {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("ID da agência inválido.");
        }

        agenciaDAO.deleteAgencia(id);
    }

    public Agencia buscarAgencia(Long id) throws SQLException {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("ID da agência inválido.");
        }

        return agenciaDAO.selectAgencia(id);
    }

    public List<Agencia> listarAgencias() throws SQLException {
        return agenciaDAO.selectAgencias();
    }

    private void validarAgencia(Agencia agencia) {
        if (agencia == null) {
            throw new IllegalArgumentException("Agência não pode ser nula.");
        }

        if (agencia.getId() == null || agencia.getId() <= 0) {
            throw new IllegalArgumentException("ID da agência inválido.");
        }

        if (agencia.getCodigo() == null || agencia.getCodigo().isBlank()) {
            throw new IllegalArgumentException("Código da agência é obrigatório.");
        }

        if (agencia.getCep() == null || agencia.getCep().isBlank()) {
            throw new IllegalArgumentException("CEP da agência é obrigatório.");
        }

        if (agencia.getCidade() == null || agencia.getCidade().isBlank()) {
            throw new IllegalArgumentException("Cidade da agência é obrigatória.");
        }

        if (agencia.getInstituicaoBancaria() == null) {
            throw new IllegalArgumentException("A instituição bancária da agência é obrigatória.");
        }

        if (agencia.getInstituicaoBancaria().getId() == null || agencia.getInstituicaoBancaria().getId() <= 0) {
            throw new IllegalArgumentException("ID da instituição bancária inválido.");
        }
    }
}
