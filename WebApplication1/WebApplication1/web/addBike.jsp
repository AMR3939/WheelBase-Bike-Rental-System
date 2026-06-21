<%@page import="java.sql.*" %>
<%@page import="java.io.*,java.util.*"%>
<%
    String act = request.getParameter("submit");
    if (act != null && act.equals("addBike"))       //Add Bike from Admin page
    {
    try
    {
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String registration_no = request.getParameter("registration_no");
        String color = request.getParameter("color");
        String daily_rate = request.getParameter("daily_rate");
        String rented_by = request.getParameter("rented_by");

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");

        // Insert into the bikes table
        String bikeQuery = "INSERT INTO bikes (brand, model, registration_no, color, daily_rate, is_available, rented_by) VALUES (?, ?, ?, ?, ?, 'Yes', ?)";
        PreparedStatement bikePst = con.prepareStatement(bikeQuery, Statement.RETURN_GENERATED_KEYS);

        bikePst.setString(1, brand);
        bikePst.setString(2, model);
        bikePst.setString(3, registration_no);
        bikePst.setString(4, color);
        bikePst.setString(5, daily_rate);
        bikePst.setString(6, rented_by);

        bikePst.executeUpdate();

        // Get the generated user_id
        ResultSet rs = bikePst.getGeneratedKeys();
        int bikeId = -1;
        if (rs.next())
            bikeId = rs.getInt(1);

        if (bikeId != -1)
            out.println("<h2 class='success-message'>Bike Added Successfully!</h2><a href=\"admin.jsp\"><h3>Click here!</a><h3>");
        else
            out.println("<h2>Error adding bike.</h2><a href=\"admin.jsp\"><h3>Click here!</a> to try again!</h3>");

        con.close();
    }
    catch (Exception e)
    {
        out.println("Error: " + e.getMessage());
    }
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

    /* Metallic animated wheels */
    .wheel {
        width: 50px;
        height: 50px;
        border: 6px solid #bbb;
        border-radius: 50%;
        border-top: 6px solid #3498db;
        position: absolute;
        animation: spin 3s linear infinite;
        box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.3);
    }

    .wheel.wheel1 {
        top: -30px;
        right: -30px;
    }

    .wheel.wheel2 {
        bottom: -30px;
        left: -30px;
        animation-direction: reverse;
    }

    @keyframes spin {
        0% {
            transform: rotate(0deg);
        }
        100% {
            transform: rotate(360deg);
        }
    }
</style>

<div class="container">
    <div class="wheel wheel1"></div>
    <div class="wheel wheel2"></div>
    <%
        // Display messages within the styled container
    %>
</div>
