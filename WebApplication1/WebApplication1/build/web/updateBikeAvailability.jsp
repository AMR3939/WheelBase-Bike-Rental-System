<%@page import="java.sql.*" %>
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");

        String updateAvailabilityQuery = "UPDATE bikes b JOIN pickup p ON b.rented_by = p.username " +
                "SET b.is_available = 'Yes', b.rented_by = NULL " +
                "WHERE p.dropoffDateTime < NOW()";
        PreparedStatement updateAvailabilityStmt = con.prepareStatement(updateAvailabilityQuery);
        updateAvailabilityStmt.executeUpdate();

        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
