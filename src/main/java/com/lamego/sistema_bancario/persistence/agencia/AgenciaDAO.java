package com.lamego.sistema_bancario.persistence.agencia;

import com.lamego.sistema_bancario.model.Agencia;
import com.lamego.sistema_bancario.persistence.GenericDAO;
import com.lamego.sistema_bancario.persistence.instituicaoBancaria.InstituicaoBancariaDAO;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AgenciaDAO implements IAgenciaDAO {
    private final GenericDAO genericDAO;
    private final InstituicaoBancariaDAO instituicaoBancariaDAO;

    public AgenciaDAO() {
        this.genericDAO = new GenericDAO();
        this.instituicaoBancariaDAO = new InstituicaoBancariaDAO();
    }

    @Override
    public void insertAgencia(Agencia agencia) throws SQLException {
        String sql = "EXEC sp_insert_agencia ?, ?, ?, ?, ?";

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql)) {

            cs.setLong(1, agencia.getId());
            cs.setString(2, agencia.getCodigo());
            cs.setString(3, agencia.getCep());
            cs.setString(4, agencia.getCidade());
            cs.setLong(5, agencia.getInstituicaoBancaria().getId());

            cs.execute();
        }
    }

    @Override
    public void updateAgencia(Agencia agencia) throws SQLException {
        String sql = "EXEC sp_update_agencia ?, ?, ?, ?, ?";

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql)) {

            cs.setLong(1, agencia.getId());
            cs.setString(2, agencia.getCodigo());
            cs.setString(3, agencia.getCep());
            cs.setString(4, agencia.getCidade());
            cs.setLong(5, agencia.getInstituicaoBancaria().getId());

            cs.execute();
        }
    }

    @Override
    public void deleteAgencia(Long id) throws SQLException {
        String sql = "EXEC sp_delete_agencia ?";

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql)) {

            cs.setLong(1, id);
            cs.execute();
        }
    }

    @Override
    public Agencia selectAgencia(Long id) throws SQLException {
        String sql = "EXEC sp_select_agencia ?";

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql)) {

            cs.setLong(1, id);
            ResultSet rs = cs.executeQuery();

            if(rs.next()){
                return mapResultSetToAgencia(rs);
            }

            return null;
        }
    }

    @Override
    public List<Agencia> selectAgencias() throws SQLException {
        String sql = "EXEC sp_select_agencias";

        List<Agencia> agencias = new ArrayList<>();

        try (Connection connection = genericDAO.getConnection();
             CallableStatement cs = connection.prepareCall(sql);
             ResultSet rs = cs.executeQuery()) {

            while(rs.next()){
                agencias.add(mapResultSetToAgencia(rs));
            }

            return agencias;
        }
    }

    private Agencia mapResultSetToAgencia(ResultSet rs) throws SQLException {
        return Agencia.builder()
                .id(rs.getLong("id_agencia"))
                .codigo(rs.getString("codigo"))
                .cep(rs.getString("cep"))
                .cidade(rs.getString("cidade"))
                .instituicaoBancaria(instituicaoBancariaDAO.selectInstituicaoBancaria(rs.getLong("id_instituicao")))
                .build();
    }
}
