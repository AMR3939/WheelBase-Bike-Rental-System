<%@page import="java.sql.*" %>
<%
    Connection conn = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true";
        String username = "root";
        String password = "admin";

        conn = DriverManager.getConnection(url, username, password);
        application.setAttribute("conn", conn);
    } catch (ClassNotFoundException e) {
        out.println("Error: MySQL JDBC Driver not found.");
        e.printStackTrace();
    } catch (SQLException e) {
        out.println("Error: Unable to connect to database.");
        e.printStackTrace();
    } finally {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException ignore) {
                // Handle exception
            }
        }
    }
%>
