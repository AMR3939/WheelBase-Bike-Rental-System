<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.*" %>

<%
    String username = (String) session.getAttribute("username");
    String existingPassword = request.getParameter("existingPassword");
    String newPassword = request.getParameter("newPassword");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    boolean isPasswordChanged = false;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");

        String checkPasswordQuery = "SELECT password FROM user WHERE username = ?";
        pstmt = conn.prepareStatement(checkPasswordQuery);
        pstmt.setString(1, username);
        rs = pstmt.executeQuery();

        if (rs.next() && rs.getString("password").equals(existingPassword)) {
            String updatePasswordQuery = "UPDATE user SET password = ? WHERE username = ?";
            pstmt = conn.prepareStatement(updatePasswordQuery);
            pstmt.setString(1, newPassword);
            pstmt.setString(2, username);
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                isPasswordChanged = true;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }

    if (isPasswordChanged) {
        session.invalidate();
        response.sendRedirect("logout.jsp");
    } else {
%>
    <script>
        alert("Incorrect existing password. Please try again.");
        history.back();
    </script>
<%
    }
%>
