<%@ page import="java.sql.*" %>
<%@ page import="java.io.*,java.util.*" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp"); // Changed to login.jsp
        return;
    }
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Booking History</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to bottom right, #141e30, #243b55);
            color: #ffffff;
            text-align: center;
            padding: 20px;
        }
        table {
            width: 80%;
            margin: auto;
            border-collapse: collapse;
            background: #1a2d4a;
            color: white;
        }
        th, td {
            border: 1px solid white;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #3498db;
        }
        .error-message {
            color: #ff4444;
            background-color: rgba(255, 68, 68, 0.1);
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
        }
        .no-records {
            padding: 20px;
            text-align: center;
            font-style: italic;
            color: #888;
        }
    </style>
</head>
<body>
    <h1>Booking History</h1>
    
    <%
        boolean hasRecords = false;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");
            
            // Debug: Print username
            System.out.println("Looking up history for username: " + username);
            
            String query = "SELECT b.brand, b.model, b.registration_no, " +
                         "p.pickupDateTime, p.dropoffDateTime, cp.total_amount " +
                         "FROM pickup p " +
                         "JOIN bikes b ON p.bike_id = b.bike_id " +
                         "LEFT JOIN customer_payments cp ON b.bike_id = cp.bike_id " +
                         "WHERE p.username = ? " +
                         "ORDER BY p.pickupDateTime DESC";
            
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            
            // Debug: Print SQL
            System.out.println("Executing query: " + query);
    %>
    
    <table>
        <tr>
            <th>Bike Brand</th>
            <th>Model</th>
            <th>Registration No</th>
            <th>Pickup Date</th>
            <th>Dropoff Date</th>
            <th>Total Amount</th>
        </tr>
        <%
            while (rs.next()) {
                hasRecords = true;
        %>
        <tr>
            <td><%= rs.getString("brand") %></td>
            <td><%= rs.getString("model") %></td>
            <td><%= rs.getString("registration_no") %></td>
            <td><%= rs.getDate("pickupDateTime") %></td>
            <td><%= rs.getDate("dropoffDateTime") %></td>
            <td>Rs <%= rs.getDouble("total_amount") %></td>
        </tr>
        <%
            }
            
            if (!hasRecords) {
        %>
            <tr>
                <td colspan="6" class="no-records">No booking history found</td>
            </tr>
        <%
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            %>
            <div class="error-message">
                Error retrieving booking history: <%= e.getMessage() %>
            </div>
            <%
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
    </table>
    <br>
    <a href="customer.jsp" class="button">Back to Dashboard</a>
</body>
</html>