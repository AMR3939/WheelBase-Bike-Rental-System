<%@page import="java.sql.*" %>
<%@page import="java.io.*,java.util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Portal</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap');

        body {
            font-family: 'Montserrat', sans-serif;
            margin: 0;
            padding: 0;
            background: radial-gradient(circle at top right, #fff, #e0e8f3);
            color: #333;
        }

        header {
            background: linear-gradient(45deg, #3498db, #2c3e50);
            color: #fff;
            padding: 20px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        nav ul {
            list-style-type: none;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
        }

        nav ul li {
            margin: 0 20px;
            position: relative;
        }

        nav ul li a {
            color: #fff;
            text-decoration: none;
            font-weight: bold;
            transition: color 0.3s ease;
            padding: 10px;
        }

        nav ul li a::before {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 2px;
            background-color: transparent;
            transition: background-color 0.3s ease;
        }

        nav ul li a:hover::before {
            background-color: #fff;
        }

        section {
            padding: 40px;
            background-color: #fff;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            margin: 40px;
            position: relative;
            overflow: hidden;
        }

        section::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 10px;
            background: linear-gradient(to right, #3498db, #2c3e50);
        }

        form {
            margin-top: 20px;
        }

        label {
            display: block;
            margin-bottom: 10px;
            font-weight: bold;
            color: #2c3e50;
        }

        input, textarea, select {
            width: 100%;
            padding: 10px;
            border: 2px solid #ddd;
            border-radius: 5px;
            margin-bottom: 20px;
            box-sizing: border-box;
            font-family: 'Montserrat', sans-serif;
            transition: border-color 0.3s ease;
        }

        input:focus, textarea:focus, select:focus {
            border-color: #2c3e50;
            outline: none;
        }

        button[type="submit"] {
            padding: 10px 20px;
            background-color: #2c3e50;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            font-family: 'Montserrat', sans-serif;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        button[type="submit"]:hover {
            background-color: #3498db;
        }

        .payment-details {
            margin-top: 20px;
        }

        .payment-details table {
            width: 100%;
            border-collapse: collapse;
        }

        .payment-details th, .payment-details td {
            padding: 10px;
            border: 1px solid #ddd;
        }

        .payment-details th {
            background-color: #3498db;
            color: #fff;
        }
    </style>
</head>
<body>
    <header>
        <nav>
            <ul>
                <li><a href="#add-bike">Add Bike</a></li>
                <li><a href="#add-inventory">Add Inventory</a></li>
                <li><a href="#sales-report">Sales Report</a></li>
                <li><a href="logout.jsp">Logout</a></li>
            </ul>
        </nav>
    </header>
    <main>
        <section id="add-bike">
            <h2>Add Bike</h2>
            <form action="addBike.jsp" method="post">
                <label>Brand:</label>
                <input type="text" name="brand" placeholder="Enter the brand name" required>
                
                <label>Model:</label>
                <input type="text" name="model" placeholder="Enter the model name" required>
                
                <label>Registration Number</label>
                <input type="text" name="registration_no" placeholder="Enter the registration_no" required>
                
                <label>Color:</label>
                <input type="text" name="color" placeholder="Enter the color" required>
                
                <label>Daily Rate</label>
                <input type="number" name="daily_rate" placeholder="Enter the daily rate" required>
                
                <button type="submit" name="submit" value="addBike">Add Bike</button>
            </form>
        </section>
        <section id="add-inventory">
            <h2>Add Inventory</h2>
           <form action="addInventory.jsp" method="post">
                <label for="item">Item:</label>
                <input type="text" id="item" name="item" required>
                
                <label for="quantity">Quantity:</label>
                <input type="number" id="quantity" name="quantity" required>
                
                <label for="supplier">Supplier:</label>
                <input type="text" id="supplier" name="supplier" required>
                
                <button type="submit">Add Inventory</button>
            </form>
        </section>
        
        <section id="sales-report">
            <h2>Sales Report - Admin Panel</h2>
            <!-- Date Filter Form -->
            <form action="admin.jsp" method="get">
                <label for="paymentDate">Select Payment Date:</label>
                <input type="date" id="paymentDate" name="paymentDate" required>
                <button type="submit">Filter</button>
            </form>

            <div class="payment-details">
                <table>
                    <tr>
                        <th>Payment ID</th>
                        <th>User ID</th>
                        <th>Amount</th>
                        <th>Bike ID</th>
                        <th>Rented By</th>
                        <th>Rental Duration (Days)</th>
                        <th>Daily Rate</th>
                        <th>Total Amount</th>
                        <th>Payment Date</th>
                    </tr>
                    <%
                        String selectedDate = request.getParameter("paymentDate");
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=UTF-8", "root", "admin");

                            String sql = "SELECT payment_id, user_id, amount, bike_id, rented_by, rental_duration, daily_rate, total_amount, payment_date FROM customer_payments";
                            if (selectedDate != null && !selectedDate.isEmpty()) {
                                sql += " WHERE DATE(payment_date) = ?";
                            }
                            pstmt = conn.prepareStatement(sql);
                            if (selectedDate != null && !selectedDate.isEmpty()) {
                                pstmt.setString(1, selectedDate);
                            }
                            rs = pstmt.executeQuery();

                            while (rs.next()) {
                                int paymentId = rs.getInt("payment_id");
                                int userId = rs.getInt("user_id");
                                double amount = rs.getDouble("amount");
                                int bikeId = rs.getInt("bike_id");
                                String rentedBy = rs.getString("rented_by");
                                int rentalDuration = rs.getInt("rental_duration");
                                double dailyRate = rs.getDouble("daily_rate");
                                double totalAmount = rs.getDouble("total_amount");
                                java.sql.Date paymentDate = rs.getDate("payment_date");

                                out.println("<tr>");
                                out.println("<td>" + paymentId + "</td>");
                                out.println("<td>" + userId + "</td>");
                                out.println("<td>?" + amount + "</td>");
                                out.println("<td>" + bikeId + "</td>");
                                out.println("<td>" + rentedBy + "</td>");
                                out.println("<td>" + rentalDuration + "</td>");
                                out.println("<td>?" + dailyRate + "</td>");
                                out.println("<td>?" + totalAmount + "</td>");
                                out.println("<td>" + paymentDate + "</td>");
                                out.println("</tr>");
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            out.println("<tr><td colspan='10'>Error retrieving data</td></tr>");
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
                            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                        }
                    %>
                </table>
            </div>
        </section>
    </main>
</body>
</html>