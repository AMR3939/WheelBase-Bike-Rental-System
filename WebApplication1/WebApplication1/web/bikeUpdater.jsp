<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update Bike Availability</title>
</head>
<body>
    <%
        // Get form parameters
        String bikeId = request.getParameter("bikeId");
        String availability = request.getParameter("availability");
        
        Connection conn = null;
        String message = "";
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");
            
            // If availability is being set to "No", ensure there's no current rental
            if(availability.equals("No")) {
                String checkQuery = "SELECT rented_by FROM bikes WHERE bike_id = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
                checkStmt.setString(1, bikeId);
                ResultSet rs = checkStmt.executeQuery();
                
                if(rs.next() && rs.getString("rented_by") != null) {
                    message = "Error: Cannot mark bike as unavailable while it is rented out.";
                    %>
                    <div class="alert alert-danger"><%= message %></div>
                    <% 
                    return;
                }
            }
            
            // Update bike availability
            String updateQuery = "UPDATE bikes SET is_available = ? WHERE bike_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(updateQuery);
            pstmt.setString(1, availability);
            pstmt.setString(2, bikeId);
            
            int result = pstmt.executeUpdate();
            
            if(result > 0) {
                message = "Bike availability updated successfully!";
                %>
                <div class="alert alert-success"><%= message %></div>
                <%
            } else {
                message = "Error updating bike availability.";
                %>
                <div class="alert alert-danger"><%= message %></div>
                <%
            }
            
        } catch(Exception e) {
            message = "Error: " + e.getMessage();
            %>
            <div class="alert alert-danger"><%= message %></div>
            <%
        } finally {
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
    %>
    
    <script>
        // Redirect back to maintenance staff page after 2 seconds
        setTimeout(function() {
            window.location.href = "Maintenance_Staff.jsp";
        }, 2000);
    </script>
</body>
</html>