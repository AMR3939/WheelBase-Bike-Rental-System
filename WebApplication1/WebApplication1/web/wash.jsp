<%@ page import="java.sql.*, java.util.*" %>
<%
    String washDate = request.getParameter("wash-date");

    if (washDate != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");

            String washInsertQuery = "INSERT INTO repair (date_reported, reported_by, location, repair_status, repair_cost) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(washInsertQuery);
            pst.setString(1, washDate);
            pst.setString(2, "Wash Schedule");
            pst.setString(3, "Default Location"); // Modify as needed
            pst.setString(4, "In progress");
            pst.setBigDecimal(5, new java.math.BigDecimal("0.00")); // Initial repair cost, modify as needed

            int rowsInserted = pst.executeUpdate();

            if (rowsInserted > 0) {
                out.println("<h2>Wash schedule added successfully!</h2>");
            } else {
                out.println("<h2>Error adding wash schedule.</h2>");
            }

            con.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    } else {
        out.println("<h2>Please provide a wash date.</h2>");
    }
%>
