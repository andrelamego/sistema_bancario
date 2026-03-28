package com.lamego.sistema_bancario.service;

import com.lamego.sistema_bancario.model.InstituicaoBancaria;
import com.lamego.sistema_bancario.persistence.instituicaoBancaria.InstituicaoBancariaDAO;

import java.sql.SQLException;
import java.util.List;

public class InstituicaoBancariaService {
    private final InstituicaoBancariaDAO instituicaoBancariaDAO;

    public InstituicaoBancariaService() {
        this.instituicaoBancariaDAO = new InstituicaoBancariaDAO();
    }

    public void cadastrarInstituicaoBancaria(InstituicaoBancaria instituicao) throws SQLException, IllegalArgumentException {
        validarInstituicao(instituicao);
        instituicaoBancariaDAO.insertInstituicaoBancaria(instituicao);
    }

    public void atualizarInstituicaoBancaria(InstituicaoBancaria instituicao) throws SQLException, IllegalArgumentException {
        validarInstituicao(instituicao);
        instituicaoBancariaDAO.updateInstituicaoBancaria(instituicao);
    }

    public void excluirInstituicaoBancaria(Long id) throws SQLException {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("ID da instituição inválido.");
        }

        instituicaoBancariaDAO.deleteInstituicaoBancaria(id);
    }

    public InstituicaoBancaria buscarInstituicaoBancaria(Long id) throws SQLException {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("ID da instituição inválido.");
        }

        return instituicaoBancariaDAO.selectInstituicaoBancaria(id);
    }

    public List<InstituicaoBancaria> listarInstituicoesBancarias() throws SQLException {
        return instituicaoBancariaDAO.selectInstituicoesBancarias();
    }

    private void validarInstituicao(InstituicaoBancaria instituicao) {
        if (instituicao == null) {
            throw new IllegalArgumentException("Instituição bancária não pode ser nula.");
        }

        if (instituicao.getId() == null || instituicao.getId() <= 0) {
            throw new IllegalArgumentException("ID da instituição inválido.");
        }

        if (instituicao.getNome() == null || instituicao.getNome().isBlank()) {
            throw new IllegalArgumentException("Nome da instituição é obrigatório.");
        }
    }
}
