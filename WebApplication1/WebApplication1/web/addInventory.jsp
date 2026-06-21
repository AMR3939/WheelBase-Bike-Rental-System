<%@page import="java.sql.*" %>
<%@page import="java.io.*,java.util.*"%>
<%
    // Get parameters from the request
    String item = request.getParameter("item");
    int quantity = Integer.parseInt(request.getParameter("quantity"));
    String supplier = request.getParameter("supplier");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // Load the MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        // Create connection to the database
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");
        
        // Prepare SQL statement
        String sql = "INSERT INTO inventory (item, quantity, supplier) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, item);
        pstmt.setInt(2, quantity);
        pstmt.setString(3, supplier);
        
        // Execute update and check if successful
        int rowsAffected = pstmt.executeUpdate();
        
        if (rowsAffected > 0) {
            out.println("<h2 class='success-message'>Inventory item added successfully!</h2>");
            out.println("<a href=\"admin.jsp\"><h3>Click here to return to admin panel</h3></a>");
        } else {
            out.println("<h2>Error adding inventory item.</h2><a href=\"admin.jsp\"><h3>Click here to try again!</h3></a>");
        }
    } catch (Exception e) {
        out.println("<h2>Error adding inventory item:</h2>");
        out.println("<p>" + e.getMessage() + "</p>");
    } finally {
        // Clean up resources
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>

<style>
    /* Gradient background with animation */
    body {
        font-family: Arial, sans-serif;
        background: linear-gradient(135deg, #4facfe, #00f2fe);
        background-size: 200% 200%;
        animation: gradientShift 10s ease infinite;
        color: #333;
        display: flex;
        align-items: center;
        justify-content: center;
        min-height: 100vh;
        margin: 0;
        overflow: hidden;
    }

    @keyframes gradientShift {
        0% { background-position: 0% 50%; }
        50% { background-position: 100% 50%; }
        100% { background-position: 0% 50%; }
    }

    /* Container styling */
    .container {
        max-width: 600px;
        padding: 30px;
        background-color: rgba(255, 255, 255, 0.95);
        border-radius: 15px;
        box-shadow: 0px 15px 30px rgba(0, 0, 0, 0.2);
        text-align: center;
        position: relative;
        overflow: hidden;
    }

    h2 {
        color: #2c3e50;
        font-size: 24px;
        margin-bottom: 15px;
    }

    h3, a {
        color: #2980b9;
        text-decoration: none;
        font-size: 18px;
    }

    a:hover {
        color: #1a73e8;
        text-decoration: underline;
    }

    p {
        color: #666;
        font-size: 16px;
        line-height: 1.5;
    }

    /* Animated success message */
    .success-message {
        color: #2ecc71;
        animation: fadeInScale 1s ease-out forwards, pulsate 1.5s infinite alternate;
        opacity: 0;
        transform: scale(0.5);
        text-shadow: 0 0 5px rgba(46, 204, 113, 0.5);
    }

    @keyframes fadeInScale {
        0% {
            opacity: 0;
            transform: scale(0.5);
        }
        100% {
            opacity: 1;
            transform: scale(1);
        }
    }

    @keyframes pulsate {
        0% { text-shadow: 0 0 5px rgba(46, 204, 113, 0.5); }
        100% { text-shadow: 0 0 15px rgba(46, 204, 113, 0.9); }
    }
</style>

<div class="container">
    <%
        // Display messages within the styled container
    %>
</div>
