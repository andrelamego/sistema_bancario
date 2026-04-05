package com.lamego.sistema_bancario.persistence;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class GenericDAO {

    // SOLID (SRP): classe dedicada somente à responsabilidade de conexão com banco.
    private static final String hostName = envOrDefault("DB_HOST", "localhost");
    private static final String port = envOrDefault("DB_PORT", "64638");
    private static final String dbName = envOrDefault("DB_NAME", "bd_sistema_bancario");
    private static final String userName = envOrDefault("DB_USER", "admin");
    private static final String password = envOrDefault("DB_PASSWORD", "12345678");

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

    private static String envOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);
        if (value == null || value.isBlank()) {
            return defaultValue;
        }
        return value;
    }
}
