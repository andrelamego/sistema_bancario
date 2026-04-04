package com.lamego.sistema_bancario.persistence.instituicaoBancaria;

import com.lamego.sistema_bancario.model.InstituicaoBancaria;

import java.sql.SQLException;
import java.util.List;

public interface IInstituicaoBancariaDAO {
    // SOLID (ISP + DIP): contrato de persistência específico de Instituição Bancária.
    void insertInstituicaoBancaria(InstituicaoBancaria instituicao) throws SQLException;
    void updateInstituicaoBancaria(InstituicaoBancaria instituicao) throws SQLException;
    void deleteInstituicaoBancaria(Long id) throws SQLException;
    InstituicaoBancaria selectInstituicaoBancaria(Long id) throws SQLException;
    List<InstituicaoBancaria> selectInstituicoesBancarias() throws SQLException;
}
