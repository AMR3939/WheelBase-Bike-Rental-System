<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bike Maintenance Portal</title>
    <style>
        body {
            font-family: 'Montserrat', sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #f8c471, #fc9d9a);
            color: #333;
        }
        header {
            background: linear-gradient(45deg, #4c6793, #5e4f88);
            color: #fff;
            padding: 10px;
            text-align: center;
        }
        nav ul {
            list-style-type: none;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
        }
        nav ul li {
            margin: 0 10px;
        }
        nav ul li a {
            color: #fff;
            text-decoration: none;
            font-weight: bold;
            transition: color 0.3s ease;
        }
        nav ul li a:hover {
            color: #f8c471;
        }
        section {
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            margin: 20px;
        }
        form {
            margin-top: 10px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"], input[type="date"], textarea {
            width: 100%;
            padding: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-bottom: 10px;
            box-sizing: border-box;
            font-family: 'Montserrat', sans-serif;
        }
        button[type="submit"] {
            padding: 5px 10px;
            background-color: #4c6793;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            font-family: 'Montserrat', sans-serif;
        }
        button[type="submit"]:hover {
            background-color: #5e4f88;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 10px;
        }
        th, td {
            padding: 5px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
    </style>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>
    <header>
        <nav>
            <ul>
                <li><a href="#home">Home</a></li>
                <li><a href="#repair-queue">Repair Queue</a></li>
                <li><a href="#wash-schedule">Wash Schedule</a></li>
                <li><a href="#availability">Availability</a></li>
                <li><a href="#garage">Garage</a></li>
                <li><a href="logout.jsp">Logout</a></li>
            </ul>
        </nav>
    </header>
    <main>
        <section id="home">
            <h1>Welcome to the Bike Maintenance Portal</h1>
            <p>Manage bike repairs, washing, inspections, and garage from this portal.</p>
        </section>
        
        <section id="availibility">
            <h2>Availibility</h2>
            <form id="bike-updating-form" action="bikeUpdater.jsp" method="post">
                <div class="form-group">
                    <label for="bikeSelect">Select Bike:</label>
                    <select name="bikeId" id="bikeSelect" required>
                        <%
                            Connection conn = null;
                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bike?useSSL=false&allowPublicKeyRetrieval=true", "root", "admin");

                                String query = "SELECT bike_id, brand, model, registration_no, is_available FROM bikes";
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery(query);

                                while(rs.next()) {
                                    String bikeInfo = rs.getString("brand") + " " + 
                                                    rs.getString("model") + " (" + 
                                                    rs.getString("registration_no") + ") - Currently " + 
                                                    rs.getString("is_available");
                                    %>
                                    <option value="<%= rs.getInt("bike_id") %>"><%= bikeInfo %></option>
                                    <%
                                }
                            } catch(Exception e) {
                                e.printStackTrace();
                            } finally {
                                if(conn != null) try { conn.close(); } catch(Exception e) {}
                            }
                        %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="availabilitySelect">Set Availability:</label>
                    <select name="availability" id="availabilitySelect" required>
                        <option value="Yes">Available</option>
                        <option value="No">Not Available</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary">Update Availability</button>
            </form>
        </section>
            
        <section id="repair-queue">
            <h2>Repair Queue</h2>
            <form action="repair.jsp" method="post">
                <label for="repair-description">New Repair:</label>
                <textarea id="repair-description" name="repair-description" required></textarea>
                <button type="submit" name="submit" value="repair">Submit</button>
            </form>
        </section>
        <section id="wash-schedule">
            <h2>Wash Schedule</h2>
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Bikes to Wash</th>
                    </tr>
                </thead>
            </table>
            <form action="wash.jsp" method="post">
                <label for="wash-date">Add Wash Schedule:</label>
                <input type="date" id="wash-date" name="wash-date" required>
                <button type="submit" name="submit" value="wash">Add</button>
            </form>
        </section>
        <section id="inventory">
            <h2>Inventory</h2>
            <form id="inventoryForm" action="query.jsp" method="post">
                <label for="item">Item:</label>
                <input type="text" id="item" name="item" required>
                <label for="quantity">Quantity:</label>
                <input type="number" id="quantity" name="quantity" required>
                <button type="submit" name="submit" value="Add Item">Add Item</button>
            </form>
            <ul id="inventoryList"></ul>
        </section>
<!--        <section id="salesreport">
            <h2>Sales report</h2>
            <form id="salesform" action="query.jsp" method="post">
                <label for="item">Product Name :</label>
                <input type="text" id="item" name="productname" required>
                <label for="quantity">Quantity sold:</label>
                <input type="number" id="quantity" name="quantitysold" required>
                <label for="quantity">Total sales:</label>
                <input type="number" id="quantity" name="quantity" required>
                <button type="submit" name="submit" value="Add report">Add report</button>
            </form>
            <ul id="salesreport"></ul>
        </section>-->
    </main>
</body>
</html>
