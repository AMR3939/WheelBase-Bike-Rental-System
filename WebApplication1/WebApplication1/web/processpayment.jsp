<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="java.sql.*" %>
<%@page import="java.text.SimpleDateFormat" %>

<%
    String bikeId = request.getParameter("bikeId");
    String cardNumber = request.getParameter("cardNumber");
    // Get pickup and dropoff dates from parameters
    String pickupDateTime = request.getParameter("pickupDateTime");
    String dropoffDateTime = request.getParameter("dropoffDateTime");
    
    // Debugging - log the values to see what's being received
    System.out.println("Debug - pickupDateTime: " + pickupDateTime);
    System.out.println("Debug - dropoffDateTime: " + dropoffDateTime);
    System.out.println("Debug - bikeId: " + bikeId);
    
    // Fallback to session if parameters are null
    if (pickupDateTime == null || pickupDateTime.trim().isEmpty()) {
        pickupDateTime = (String)session.getAttribute("pickupDateTime");
        System.out.println("Using session pickupDateTime: " + pickupDateTime);
    }
    if (dropoffDateTime == null || dropoffDateTime.trim().isEmpty()) {
        dropoffDateTime = (String)session.getAttribute("dropoffDateTime");
        System.out.println("Using session dropoffDateTime: " + dropoffDateTime);
    }
    if (bikeId == null || bikeId.trim().isEmpty()) {
        bikeId = (String)session.getAttribute("bikeId");
        System.out.println("Using session bikeId: " + bikeId);
    }
    
    // Get other parameters
    Integer userId = (Integer) session.getAttribute("userId");
    String fullName = (String) session.getAttribute("full_name");
    String username = (String) session.getAttribute("username");
    String dailyRateStr = request.getParameter("dailyRate");
    String daysStr = request.getParameter("days");
    
    System.out.println("Debug - userId: " + userId);
    System.out.println("Debug - fullName: " + fullName);
    System.out.println("Debug - username: " + username);
    System.out.println("Debug - dailyRateStr: " + dailyRateStr);
    System.out.println("Debug - daysStr: " + daysStr);

    // Check for missing required parameters and provide defaults or error messages
    if (userId == null || username == null) {
        out.println("<div class='card error'><h2>Error: User not logged in or session expired</h2>");
        out.println("<a href='login.jsp' class='button'>Return to Login</a></div>");
        return;
    }
    
    if (bikeId == null || bikeId.trim().isEmpty()) {
        out.println("<div class='card error'><h2>Error: Bike ID is missing</h2>");
        out.println("<a href='customer.jsp' class='button'>Return to Customer Page</a></div>");
        return;
    }
    
    if (dailyRateStr == null || dailyRateStr.trim().isEmpty()) {
        // Try to fetch daily rate from database
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection tempConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=UTF-8", "root", "admin");
            PreparedStatement tempStmt = tempConn.prepareStatement("SELECT daily_rate FROM bikes WHERE bike_id = ?");
            tempStmt.setInt(1, Integer.parseInt(bikeId));
            ResultSet rs = tempStmt.executeQuery();
            if (rs.next()) {
                dailyRateStr = String.valueOf(rs.getDouble("daily_rate"));
                System.out.println("Fetched dailyRate from DB: " + dailyRateStr);
            } else {
                out.println("<div class='card error'><h2>Error: Could not find daily rate for the bike</h2>");
                out.println("<a href='customer.jsp' class='button'>Return to Customer Page</a></div>");
                rs.close();
                tempStmt.close();
                tempConn.close();
                return;
            }
            rs.close();
            tempStmt.close();
            tempConn.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<div class='card error'><h2>Error retrieving daily rate: " + e.getMessage() + "</h2>");
            out.println("<a href='customer.jsp' class='button'>Return to Customer Page</a></div>");
            return;
        }
    }
    
    // Ensure we have days value - recalculate if needed
    if (daysStr == null || daysStr.trim().isEmpty() || daysStr.equals("0")) {
        try {
            // Recalculate days from dates if available
            if (pickupDateTime != null && dropoffDateTime != null) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                java.util.Date pickup = sdf.parse(pickupDateTime);
                java.util.Date dropoff = sdf.parse(dropoffDateTime);
                
                // Calculate days difference
                long diff = dropoff.getTime() - pickup.getTime();
                int recalculatedDays = (int) Math.ceil(diff / (1000.0 * 60 * 60 * 24));
                if (recalculatedDays < 1) recalculatedDays = 1; // Minimum 1 day
                
                daysStr = String.valueOf(recalculatedDays);
                System.out.println("Recalculated days: " + daysStr);
            } else {
                // Default to 1 day if we can't calculate
                daysStr = "1";
                System.out.println("Using default days: " + daysStr);
            }
        } catch (Exception e) {
            e.printStackTrace();
            daysStr = "1"; // Default to 1 day on error
            System.out.println("Error calculating days, using default: " + daysStr);
        }
    }

    double dailyRate = Double.parseDouble(dailyRateStr);
    int days = Integer.parseInt(daysStr);
    double amount = dailyRate * days;

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=UTF-8", "root", "admin");
        
        // Start transaction
        conn.setAutoCommit(false);

        try {
            // Insert payment details into payments table
            String sql = "INSERT INTO payments (user_id, bike_id, payment_date, amount) VALUES (?, ?, NOW(), ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, Integer.parseInt(bikeId));
            pstmt.setDouble(3, amount);
            pstmt.executeUpdate();

            // Insert into pickup table - using pickupDateTime and dropoffDateTime
            String pickupSql = "INSERT INTO pickup (pickupDateTime, dropoffDateTime, username, bike_id) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(pickupSql);
            pstmt.setString(1, pickupDateTime);
            pstmt.setString(2, dropoffDateTime);
            pstmt.setString(3, username);
            pstmt.setInt(4, Integer.parseInt(bikeId));
            pstmt.executeUpdate();

            // Update bike availability
            String updateBikeSql = "UPDATE bikes SET rented_by = ?, is_available = 'No' WHERE bike_id = ?";
            pstmt = conn.prepareStatement(updateBikeSql);
            pstmt.setString(1, fullName);
            pstmt.setInt(2, Integer.parseInt(bikeId));
            pstmt.executeUpdate();

            // Insert payment details into customer_payments table
            String customerPaymentSql = "INSERT INTO customer_payments (user_id, card_number, amount, bike_id, rented_by, rental_duration, daily_rate, total_amount, payment_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
            pstmt = conn.prepareStatement(customerPaymentSql);
            pstmt.setInt(1, userId);
            pstmt.setString(2, cardNumber);
            pstmt.setDouble(3, amount);
            pstmt.setInt(4, Integer.parseInt(bikeId));
            pstmt.setString(5, fullName);
            pstmt.setInt(6, days);
            pstmt.setDouble(7, dailyRate);
            pstmt.setDouble(8, amount);
            pstmt.executeUpdate();

            // Commit the transaction
            conn.commit();

            // Display success message and receipt
            out.println("<div class='card success' id='receipt'>");
            out.println("<h2>Payment Successful</h2>");
            out.println("<p>Bike ID: " + bikeId + " is now rented by: " + fullName + "</p>");

            // Displaying receipt details
            out.println("<div class='details'>");
            out.println("<table>");
            out.println("<tr><th>Card Number:</th><td>" + cardNumber + "</td></tr>");
            out.println("<tr><th>Amount:</th><td>₹" + amount + "</td></tr>");
            out.println("<tr><th>Bike ID:</th><td>" + bikeId + "</td></tr>");
            out.println("<tr><th>Rented By:</th><td>" + fullName + "</td></tr>");
            out.println("<tr><th>Rental Duration:</th><td>" + days + " days</td></tr>");
            out.println("<tr><th>Daily Rate:</th><td>₹" + dailyRate + "</td></tr>");
            out.println("<tr><th>Total Amount:</th><td>₹" + amount + "</td></tr>");
            out.println("<tr><th>Pickup Date:</th><td>" + pickupDateTime + "</td></tr>");
            out.println("<tr><th>Drop-off Date:</th><td>" + dropoffDateTime + "</td></tr>");
            out.println("</table>");
            out.println("</div>");

            out.println("<button class='print-button' onclick='printReceipt()'>Print Bill</button>");
            out.println("<a href='customer.jsp' class='button'>Return to Customer Page</a>");
            out.println("</div>");

        } catch (SQLException e) {
            // If there's an error, rollback the transaction
            conn.rollback();
            System.out.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
            out.println("<div class='card error'><h2>SQL Error: " + e.getMessage() + "</h2>");
            out.println("<a href='customer.jsp' class='button'>Return to Customer Page</a></div>");
        }

    } catch (SQLException e) {
        System.out.println("SQL Error: " + e.getMessage());
        e.printStackTrace();
        out.println("<div class='card error'><h2>SQL Error: " + e.getMessage() + "</h2>");
        out.println("<a href='customer.jsp' class='button'>Return to Customer Page</a></div>");
    } catch (ClassNotFoundException e) {
        System.out.println("Driver Error: " + e.getMessage());
        e.printStackTrace();
        out.println("<div class='card error'><h2>Driver Error: " + e.getMessage() + "</h2>");
        out.println("<a href='customer.jsp' class='button'>Return to Customer Page</a></div>");
    } catch (Exception e) {
        System.out.println("Unexpected Error: " + e.getMessage());
        e.printStackTrace();
        out.println("<div class='card error'><h2>Unexpected Error: " + e.getMessage() + "</h2>");
        out.println("<a href='customer.jsp' class='button'>Return to Customer Page</a></div>");
    } finally {
        if (conn != null) {
            try {
                conn.setAutoCommit(true);  // Reset auto-commit to true before closing
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #181818;
        color: #ffffff;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
    }

    .card {
        background-color: #212121;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
        max-width: 600px;
        padding: 20px;
        margin: 20px;
    }

    .card.success {
        border-left: 6px solid #4caf50;
    }

    .card.error {
        border-left: 6px solid #f44336;
    }

    h2 {
        color: #4caf50;
        font-size: 2em;
        margin-top: 0;
    }

    .details table {
        width: 100%;
        border-collapse: collapse;
        margin: 20px 0;
    }

    .details th, .details td {
        text-align: left;
        padding: 10px 15px;
        border-bottom: 1px solid #444;
        font-size: 1em;
    }

    .details th {
        background-color: #333;
        color: #4caf50;
        font-weight: bold;
    }

    .details td {
        color: #ffffff;
    }

    .print-button, .button {
        display: inline-block;
        padding: 12px 24px;
        margin: 10px 5px;
        color: #ffffff;
        border-radius: 6px;
        text-decoration: none;
        font-size: 1em;
        font-weight: bold;
        border: none;
        transition: background-color 0.3s;
        cursor: pointer;
    }

    .print-button {
        background-color: #4caf50;
    }

    .button {
        background-color: #007bff;
    }

    .print-button:hover {
        background-color: #45a049;
    }

    .button:hover {
        background-color: #0056b3;
    }
</style>

<script>
    function printReceipt() {
        const printContent = document.getElementById("receipt").innerHTML;
        const originalContent = document.body.innerHTML;

        document.body.innerHTML = printContent;
        window.print();
        document.body.innerHTML = originalContent;
    }
</script>