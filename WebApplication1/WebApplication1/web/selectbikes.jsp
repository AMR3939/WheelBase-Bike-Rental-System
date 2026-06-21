<%@page import="java.sql.*" %>
<%@page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession session = request.getSession();
    String fullName = (String) session.getAttribute("full_name");

    String bikeId = request.getParameter("bike_id");

    if (bikeId != null && fullName != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");

            String updateBikeQuery = "UPDATE bikes SET rented_by = ?, is_available = 'No' WHERE bike_id = ?";
            PreparedStatement updateBikeStmt = con.prepareStatement(updateBikeQuery);
            updateBikeStmt.setString(1, fullName);
            updateBikeStmt.setInt(2, Integer.parseInt(bikeId));

            int rowsUpdated = updateBikeStmt.executeUpdate();

            if (rowsUpdated > 0) {
                out.println("<h2>Bike successfully selected!</h2><a href='Maintenance_Staff.jsp'><h3>Click here to go back.</h3></a>");
            } else {
                out.println("<h2>Error selecting bike.</h2><a href='Maintenance_Staff.jsp'><h3>Click here to try again.</h3></a>");
            }

            con.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    } else {
        out.println("<h2>Error: Bike ID or user information not found.</h2>");
    }
%>
