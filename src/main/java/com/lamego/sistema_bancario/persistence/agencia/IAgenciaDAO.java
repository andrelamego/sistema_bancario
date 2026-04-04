package com.lamego.sistema_bancario.persistence.agencia;

import com.lamego.sistema_bancario.model.Agencia;

import java.sql.SQLException;
import java.util.List;

public interface IAgenciaDAO {
    // SOLID (ISP + DIP): contrato pequeno e específico para persistência de Agência.
    void insertAgencia(Agencia agencia) throws SQLException;
    void updateAgencia(Agencia agencia) throws SQLException;
    void deleteAgencia(Long id) throws SQLException;
    Agencia selectAgencia(Long id) throws SQLException;
    List<Agencia> selectAgencias() throws SQLException;
}
