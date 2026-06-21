<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Business Management Portal - Home</title>
    <style>
        /* Reset styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            color: #333;
            overflow-x: hidden;
        }

        /* Header styles */
        header {
            background-color: #333;
            padding: 10px 0;
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease;
        }

        header.scroll {
            background-color: rgba(51, 51, 51, 0.8);
        }

        nav ul {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        nav ul li {
            margin: 0 15px;
            position: relative;
        }

        nav ul li a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            padding: 10px 15px;
            display: inline-block;
            transition: color 0.3s ease;
            cursor: pointer;
        }

        nav ul li a:hover {
            color: #f0f0f0;
        }

        /* Main styles */
        main {
            margin-top: 80px; /* Height of the header */
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
        }

        main section {
            width: 100%;
            max-width: 600px;
            margin-bottom: 20px;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            animation: fadeIn 0.5s ease;
            display: none; /* Hide sections by default */
        }

        /* Form styles */
        form {
            display: flex;
            flex-direction: column;
        }

        form h2 {
            margin-bottom: 10px;
            font-size: 1.5em;
        }

        form label {
            display: block;
            margin-bottom: 8px;
        }

        form input,
        form button {
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 1em;
        }

        form button {
            background-color: #333;
            color: #fff;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        form button:hover {
            background-color: #555;
        }

        footer {
            background-color: #333;
            color: white;
            text-align: center;
            padding: 10px 0;
            position: fixed;
            width: 100%;
            bottom: 0;
        }

        footer p {
            margin: 0;
        }
    </style>
</head>
<body>
    <header>
        <nav>
            <ul>
                <li><a href="#add-admin" onclick="showSection('add-admin')">Add Admin</a></li>
                <li><a href="#add-maintenance-staff" onclick="showSection('add-maintenance-staff')">Add Maintenance Staff</a></li>
                <li><a href="#sales" onclick="showSection('sales')">Sales Report</a></li>
                <li><a href="#inventory" onclick="showSection('inventory')">Inventory Report</a></li>
                <li><a href="logout.jsp">Logout</a></li>
            </ul>
        </nav>
    </header>
    <main>
        <section id="add-admin">
            <h2>Add Admin</h2>
            <form action="query.jsp" method="post">
                <label>
                    <input type="radio" name="user" value="admin" checked required style="display:none;">
                    Admin
                </label><br><br>
                <input type="text" name="textname" placeholder="Username" required>
                <input type="password" name="textpsswd" placeholder="Password" required>
                <input type="text" name="fullname" placeholder="Enter your full name" required>
                <input type="text" name="phone" placeholder="Enter your phone number" required>
                <input type="text" name="address" placeholder="Enter your address" required>
                <input type="email" name="email" placeholder="Enter your email" required>
                <button type="submit" name="submit" value="add_admin">Add Admin</button>
            </form>
        </section>

        <section id="add-maintenance-staff">
            <h2>Add Maintenance Staff</h2>
            <form action="query.jsp" method="post">
                <label>
                    <input type="radio" name="user" value="Maintenance_Staff" checked required style="display:none;">
                    Maintenance Staff
                </label><br><br>
                <input type="text" name="textname" placeholder="Username" required>
                <input type="password" name="textpsswd" placeholder="Password" required>
                <input type="text" name="fullname" placeholder="Enter your full name" required>
                <input type="text" name="phone" placeholder="Enter your phone number" required>
                <input type="text" name="address" placeholder="Enter your address" required>
                <input type="email" name="email" placeholder="Enter your email" required>
                <button type="submit" name="submit" value="add_staff">Add Maintenance Staff</button>
            </form>            
        </section>
        
        <section id="sales">
            <h2>Sales Report</h2>
    <table class="tabledetails">
        <thead>
            <tr>
                <th>Rented By</th>
                <th>Rental Duration (days)</th>
                <th>Daily Rate ($)</th>
                <th>Total Amount ($)</th>
                <th>Payment Date</th>
            </tr>
        </thead>
        <tbody>
            <% 
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");
                    stmt = conn.createStatement();
                    
                    // Fetching payment details from customer_payments table
                    String query = "SELECT rented_by, rental_duration, daily_rate, total_amount, payment_date FROM customer_payments";
                    rs = stmt.executeQuery(query);

                    while (rs.next()) {
                        String rentedBy = rs.getString("rented_by");
                        int rentalDuration = rs.getInt("rental_duration");
                        double dailyRate = rs.getDouble("daily_rate");
                        double totalAmount = rs.getDouble("total_amount");
                        Timestamp paymentDate = rs.getTimestamp("payment_date");
            %>
            <tr>
                <td><%= rentedBy %></td>
                <td><%= rentalDuration %></td>
                <td><%= dailyRate %></td>
                <td><%= totalAmount %></td>
                <td><%= paymentDate %></td>
            </tr>
            <% 
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
        </tbody>
    </table>                  
        </section>
        
        <section id="inventory">
            <h2>Inventory Report</h2>
            <table class="tabledetails">
                <thead>
                    <tr>
                        <th>Item</th>
                        <th>Quantity</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        Connection connn = null;
                        Statement stmtt = null;
                        ResultSet rss = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            connn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");
                            stmtt = connn.createStatement();
                            String query = "SELECT * FROM inventory"; // Adjust the table name as needed
                            rss = stmtt.executeQuery(query);

                            while (rss.next()) {
                                String item = rss.getString("item");
                                String quantity = rss.getString("quantity");
                    %>
                    <tr>
                        <td><%= item %></td>
                        <td><%= quantity %></td>
                    </tr>
                    <% 
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            try {
                                if (rss != null) rss.close();
                                if (stmtt != null) stmtt.close();
                                if (connn != null) connn.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                    %>
                </tbody>
            </table>         
        </section>
    </main>
    <footer>
        <p>&copy; 2023 Business Management Portal</p>
    </footer>

    <script>
        function showSection(sectionId) {
            // Hide all sections
            document.querySelectorAll('main section').forEach(section => {
                section.style.display = 'none';
            });

            // Show the selected section
            document.getElementById(sectionId).style.display = 'block';
        }

        // Show the first section by default when the page loads
        document.addEventListener("DOMContentLoaded", function() {
            showSection('add-admin');
        });

        // Change header background on scroll
        window.addEventListener('scroll', function() {
            const header = document.querySelector('header');
            header.classList.toggle('scroll', window.scrollY > 0);
        });
    </script>
</body>
</html>
