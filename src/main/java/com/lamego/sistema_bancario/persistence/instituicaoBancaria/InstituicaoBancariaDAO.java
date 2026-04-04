package com.lamego.sistema_bancario.persistence.instituicaoBancaria;

import com.lamego.sistema_bancario.model.InstituicaoBancaria;
import com.lamego.sistema_bancario.persistence.GenericDAO;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InstituicaoBancariaDAO implements IInstituicaoBancariaDAO {
    // SOLID (SRP): implementação de persistência exclusiva para Instituição Bancária.
    private final GenericDAO genericDAO;

    public InstituicaoBancariaDAO() {
        this.genericDAO = new GenericDAO();
    }

    @Override
    public void insertInstituicaoBancaria(InstituicaoBancaria instituicao) throws SQLException {
        String sql = "EXEC sp_insert_instituicao_bancaria ?, ?";

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql)) {

            cs.setLong(1, instituicao.getId());
            cs.setString(2, instituicao.getNome());

            cs.execute();
        }
    }

    @Override
    public void updateInstituicaoBancaria(InstituicaoBancaria instituicao) throws SQLException {
        String sql = "EXEC sp_update_instituicao_bancaria ?, ?";

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql)) {

            cs.setLong(1, instituicao.getId());
            cs.setString(2, instituicao.getNome());

            cs.execute();
        }
    }

    @Override
    public void deleteInstituicaoBancaria(Long id) throws SQLException {
        String sql = "EXEC sp_delete_instituicao_bancaria ?";

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql)) {

            cs.setLong(1, id);
            cs.execute();
        }
    }

    @Override
    public InstituicaoBancaria selectInstituicaoBancaria(Long id) throws SQLException {
        String sql = "EXEC sp_select_instituicao_bancaria ?";

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql)) {

            cs.setLong(1, id);

            ResultSet rs = cs.executeQuery();

            if(rs.next()){
                return mapResultSetToInstituicao(rs);
            }

            return null;
        }
    }

    @Override
    public List<InstituicaoBancaria> selectInstituicoesBancarias() throws SQLException {
        String sql = "EXEC sp_select_instituicoes_bancarias";

        List<InstituicaoBancaria> instituicoes = new ArrayList<>();

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql);
             ResultSet rs = cs.executeQuery()) {


            while (rs.next()) {
                instituicoes.add(mapResultSetToInstituicao(rs));
            }
        }

        return instituicoes;
    }

    private InstituicaoBancaria mapResultSetToInstituicao(ResultSet rs) throws SQLException {
        return InstituicaoBancaria.builder()
                .id(rs.getLong("id_instituicao"))
                .nome(rs.getString("nome"))
                .build();
    }
}
