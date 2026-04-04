package com.lamego.sistema_bancario.persistence;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class GenericDAO {

    // SOLID (SRP): classe dedicada somente à responsabilidade de conexão com banco.
    private static final String hostName = "localhost";
    private static final String port = "64638";
    private static final String dbName = "bd_sistema_bancario";
    private static final String userName = "admin";
    private static final String password = "12345678";

    private static final String URL =
            String.format(
                    "jdbc:jtds:sqlserver://%s:%s/%s;useNTLMv2=false;",
                    hostName,
                    port,
                    dbName
            );

    static {
        try {
            Class.forName("net.sourceforge.jtds.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Erro ao carregar driver JDBC.", e);
        }
    }

    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, userName, password);
    }
}
