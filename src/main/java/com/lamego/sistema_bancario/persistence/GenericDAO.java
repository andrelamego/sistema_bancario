package com.lamego.sistema_bancario.persistence;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class GenericDAO {
    private Connection c;

    public Connection getConnection() throws SQLException, ClassNotFoundException {
        String hostName = "localhost";
        String port = "64638";
        String dbName = "bd_sistema_bancario";
        String userName = "admin";
        String password = "12345678";
        Class.forName("net.sourceforge.jtds.jdbc.Driver");
        return c = DriverManager.getConnection(String.format("jdbc:jtds:sqlserver://%s:%s;databaseName:%s;user=%s;password=%s;",
                hostName, port, dbName, userName, password));
    }
}
